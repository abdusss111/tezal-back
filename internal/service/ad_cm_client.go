package service

import (
	"context"
	"errors"
	"fmt"
	"time"

	"gitlab.com/eqshare/eqshare-back/internal/client"
	"gitlab.com/eqshare/eqshare-back/internal/elastic"
	"gitlab.com/eqshare/eqshare-back/internal/repository"
	"gitlab.com/eqshare/eqshare-back/model"
)

type IAdConstructionMaterialClient interface {
	Get(ctx context.Context, f model.FilterAdConstructionMaterialClients) ([]model.AdConstructionMaterialClient, int, error)
	GetByID(ctx context.Context, id int) (model.AdConstructionMaterialClient, error)
	Create(ctx context.Context, ad model.AdConstructionMaterialClient) error
	Update(ctx context.Context, ad model.AdConstructionMaterialClient) error
	UpdateStatus(ctx context.Context, ad model.AdConstructionMaterialClient) error
	Delete(ctx context.Context, id int) error

	GetFavorite(ctx context.Context, userID int) ([]model.FavoriteAdConstructionMaterialClient, error)
	CreateFavorite(ctx context.Context, fav model.FavoriteAdConstructionMaterialClient) error
	DeleteFavorite(ctx context.Context, fav model.FavoriteAdConstructionMaterialClient) error
	GetSeen(ctx context.Context, id int) (int, error)
	IncrementSeen(ctx context.Context, id int) error
}

type adConstructionMaterialClient struct {
	adConstructionMaterialClientRepo repository.IAdConstructionMaterialClient
	remotes                          client.DocumentsRemote
	favoriteRepo                     repository.IFavorite
	elastic                          elastic.IAdConstructionMaterialClient
	subscriptionService              ISubscription
}

func NewAdConstructionMaterialClient(
	adConstructionMaterialClientRepo repository.IAdConstructionMaterialClient,
	remotes client.DocumentsRemote,
	favoriteRepo repository.IFavorite,
	elastic elastic.IAdConstructionMaterialClient,
	subscriptionService ISubscription,
) IAdConstructionMaterialClient {
	return &adConstructionMaterialClient{
		adConstructionMaterialClientRepo: adConstructionMaterialClientRepo,
		remotes:                          remotes,
		favoriteRepo:                     favoriteRepo,
		elastic:                          elastic,
		subscriptionService:              subscriptionService,
	}
}

func (service *adConstructionMaterialClient) Get(ctx context.Context, f model.FilterAdConstructionMaterialClients) ([]model.AdConstructionMaterialClient, int, error) {
	res, total, err := service.adConstructionMaterialClientRepo.Get(ctx, f)
	if err != nil {
		return nil, 0, fmt.Errorf("service adConstructionMaterialClient: Get: %w", err)
	}

	for i, ad := range res {
		res[i].UrlDocument = make([]string, 0, len(ad.Documents))
		for _, v := range ad.Documents {
			v, err = service.remotes.Share(ctx, v, time.Hour*1)
			if err != nil {
				return nil, 0, fmt.Errorf("service adConstructionMaterialClient: get document: id ad %d: id_doc %d: error: %w", ad.ID, v.ID, err)
			}
			res[i].UrlDocument = append(res[i].UrlDocument, v.ShareLink)
		}
	}

	//для случаи если индексы упадут
	//logrus.Info("Total: ", len(res))
	//
	//for _, d := range res {
	//	logrus.Info("AdConstructionMaterial: ", d.ID)
	//
	//	err := service.elastic.Update(context.Background(), d)
	//	if err != nil {
	//		return nil, 0, err
	//	}
	//}

	return res, total, nil
}

func (service *adConstructionMaterialClient) GetByID(ctx context.Context, id int) (model.AdConstructionMaterialClient, error) {
	res, err := service.adConstructionMaterialClientRepo.GetByID(ctx, id)
	if err != nil {
		return res, fmt.Errorf("service adConstructionMaterialClient: GetByID: %w", err)
	}

	res.UrlDocument = make([]string, 0, len(res.Documents))
	for _, d := range res.Documents {
		d, err = service.remotes.Share(ctx, d, time.Hour*1)
		if err != nil {
			return res, fmt.Errorf("service adConstructionMaterialClient: GetByID: get document: id_doc: %d: %w", res.ID, err)
		}
		res.UrlDocument = append(res.UrlDocument, d.ShareLink)
	}

	return res, nil
}

func (service *adConstructionMaterialClient) Create(ctx context.Context, ad model.AdConstructionMaterialClient) error {
	ad.Status = model.STATUS_CREATED

	id, err := service.adConstructionMaterialClientRepo.Create(ctx, ad)
	if err != nil {
		return fmt.Errorf("service adConstructionMaterialClient: Create: %w", err)
	}

	for i, d := range ad.Documents {
		_, err := service.remotes.Upload(ctx, ad.Documents[i])
		if err != nil {
			return fmt.Errorf("service adConstructionMaterialClient: Upload Document: documne title \"%v\": %v", d.Title, err.Error())
		}
	}

	{
		adElastic, err := service.adConstructionMaterialClientRepo.GetByID(ctx, id)
		if err != nil {
			return fmt.Errorf("service adConstructionMaterialClient: GetByID: %w", err)
		}

		err = service.elastic.Create(ctx, adElastic)
		if err != nil {
			return fmt.Errorf("service adConstructionMaterialClient: Create elastic: %w", err)
		}
		ad = adElastic
	}

	title := "У вас есть объявления"
	message := ad.ConstructionMaterialSubCategory.Name + " - " + ad.Title + ". Нажмите чтобы посмотреть"
	err = service.subscriptionService.SendOutNoticeAdClientCM(ctx, ad.ConstructionMaterialSubCategoryID, message, title, id, ad.CityID)
	if err != nil {
		return fmt.Errorf("service adConstructionMaterialClient: SendOutNoticeAdClientEQ elastic: %w", err)
	}

	return nil
}

func (service *adConstructionMaterialClient) Update(ctx context.Context, ad model.AdConstructionMaterialClient) error {
	err := service.adConstructionMaterialClientRepo.Update(ctx, ad)
	if err != nil {
		return fmt.Errorf("service adConstructionMaterialClient: Update: %w", err)
	}

	{
		ad, err := service.adConstructionMaterialClientRepo.GetByID(ctx, ad.ID)
		if err != nil {
			return fmt.Errorf("service adConstructionMaterialClient: GetByID: %w", err)
		}

		err = service.elastic.Update(ctx, ad)
		if err != nil {
			return fmt.Errorf("service adConstructionMaterialClient: Elastic: %w", err)
		}
	}

	return nil
}

func (service *adConstructionMaterialClient) UpdateStatus(ctx context.Context, ad model.AdConstructionMaterialClient) error {
	err := service.adConstructionMaterialClientRepo.UpdateStatus(ctx, ad)
	if err != nil {
		return fmt.Errorf("service adConstructionMaterialClient: Update: %w", err)
	}

	return nil
}

func (service *adConstructionMaterialClient) Delete(ctx context.Context, id int) error {
	err := service.adConstructionMaterialClientRepo.Delete(ctx, id)
	if err != nil {
		return fmt.Errorf("service adConstructionMaterialClient: Delete: %w", err)
	}

	err = service.elastic.Delete(ctx, id)
	if err != nil {
		return err
	}

	return nil
}

func (service *adConstructionMaterialClient) GetFavorite(ctx context.Context, userID int) ([]model.FavoriteAdConstructionMaterialClient, error) {
	res, err := service.favoriteRepo.GetAdConstructionMaterialClientByUserID(ctx, userID)
	if err != nil {
		return nil, fmt.Errorf("service adConstructionMaterialClient: GetFavorite: %w", err)
	}

	for i, ad := range res {
		res[i].AdConstructionMaterialClient.UrlDocument = make([]string, 0, len(ad.AdConstructionMaterialClient.Documents))
		for _, v := range ad.AdConstructionMaterialClient.Documents {
			v, err = service.remotes.Share(ctx, v, time.Hour*1)
			if err != nil {
				return nil, fmt.Errorf("service adConstructionMaterialClient: GetFavorite: get document: id ad %d: id_doc %d: error: %w", ad.AdConstructionMaterialClient.ID, v.ID, err)
			}
			res[i].AdConstructionMaterialClient.UrlDocument = append(res[i].AdConstructionMaterialClient.UrlDocument, v.ShareLink)
		}
	}

	return res, nil
}

func (service *adConstructionMaterialClient) CreateFavorite(ctx context.Context, fav model.FavoriteAdConstructionMaterialClient) error {
	err := service.favoriteRepo.CreateAdConstructionMaterialClient(ctx, fav)
	if err != nil {
		return fmt.Errorf("service adConstructionMaterialClient: CreateFavorite: %w", err)
	}
	return nil
}

func (service *adConstructionMaterialClient) DeleteFavorite(ctx context.Context, fav model.FavoriteAdConstructionMaterialClient) error {
	err := service.favoriteRepo.DeleteAdConstructionMaterialClient(ctx, fav)
	if err != nil {
		return fmt.Errorf("service adConstructionMaterialClient: DeleteFavorite: %w", err)
	}
	return nil
}

func (service *adConstructionMaterialClient) GetSeen(ctx context.Context, id int) (int, error) {
	res, err := service.adConstructionMaterialClientRepo.GetByIDSeen(ctx, id)
	if err != nil {
		if errors.Is(err, model.ErrNotFound) {
			err := service.adConstructionMaterialClientRepo.CreateSeen(ctx, id)
			if err != nil {
				return 0, fmt.Errorf("service adConstructionMaterialClientRepo: GetSeen: CreateSeen: %w", err)
			}
			return 0, nil
		}
		return 0, fmt.Errorf("service adConstructionMaterialClientRepo: GetSeen: %w", err)
	}

	return res, nil
}

func (service *adConstructionMaterialClient) IncrementSeen(ctx context.Context, id int) error {
	_, err := service.adConstructionMaterialClientRepo.GetByIDSeen(ctx, id)
	if err != nil {
		if errors.Is(err, model.ErrNotFound) {
			err := service.adConstructionMaterialClientRepo.CreateSeen(ctx, id)
			if err != nil {
				return fmt.Errorf("service adConstructionMaterialClientRepo: IncrementSeen: CreateSeen: %w", err)
			}
			err = service.adConstructionMaterialClientRepo.IncrementSeen(ctx, id)
			if err != nil {
				return fmt.Errorf("service adConstructionMaterialClientRepo: IncrementSeen: IncrementSeen2: %w", err)
			}
			return nil
		}
		return fmt.Errorf("service adConstructionMaterialClientRepo: IncrementSeen: IncrementSeen2: %w", err)
	}

	err = service.adConstructionMaterialClientRepo.IncrementSeen(ctx, id)
	if err != nil {
		return fmt.Errorf("service adConstructionMaterialClientRepo: IncrementSeen: IncrementSeen: %w", err)
	}
	return nil
}
