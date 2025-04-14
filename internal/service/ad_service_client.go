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

type IAdServiceClient interface {
	Get(ctx context.Context, f model.FilterAdServiceClients) ([]model.AdServiceClient, int, error)
	GetByID(ctx context.Context, id int) (model.AdServiceClient, error)
	Create(ctx context.Context, ad model.AdServiceClient) error
	Update(ctx context.Context, ad model.AdServiceClient) error
	UpdateStatus(ctx context.Context, ad model.AdServiceClient) error
	Delete(ctx context.Context, id int) error

	GetFavorite(ctx context.Context, userID int) ([]model.FavoriteAdServiceClient, error)
	CreateFavorite(ctx context.Context, fav model.FavoriteAdServiceClient) error
	DeleteFavorite(ctx context.Context, fav model.FavoriteAdServiceClient) error
	GetSeen(ctx context.Context, id int) (int, error)
	IncrementSeen(ctx context.Context, id int) error
}

type adServiceClient struct {
	adServiceClientRepo repository.IAdServiceClient
	remotes             client.DocumentsRemote
	favoriteRepo        repository.IFavorite
	elastic             elastic.IAdServiceClient
	subscriptionService ISubscription
}

func NewAdServiceClient(
	adServiceClientRepo repository.IAdServiceClient,
	remotes client.DocumentsRemote,
	favoriteRepo repository.IFavorite,
	elastic elastic.IAdServiceClient,
	subscriptionService ISubscription,
) IAdServiceClient {
	return &adServiceClient{
		adServiceClientRepo: adServiceClientRepo,
		remotes:             remotes,
		favoriteRepo:        favoriteRepo,
		elastic:             elastic,
		subscriptionService: subscriptionService,
	}
}

func (service *adServiceClient) Get(ctx context.Context, f model.FilterAdServiceClients) ([]model.AdServiceClient, int, error) {
	res, total, err := service.adServiceClientRepo.Get(ctx, f)
	if err != nil {
		return nil, 0, fmt.Errorf("service adServiceClient: Get: %w", err)
	}

	for i, ad := range res {
		res[i].UrlDocument = make([]string, 0, len(ad.Documents))
		for _, v := range ad.Documents {
			v, err = service.remotes.Share(ctx, v, time.Hour*1)
			if err != nil {
				return nil, 0, fmt.Errorf("service adServiceClient: get document: id ad %d: id_doc %d: error: %w", ad.ID, v.ID, err)
			}
			res[i].UrlDocument = append(res[i].UrlDocument, v.ShareLink)
		}
	}

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

func (service *adServiceClient) GetByID(ctx context.Context, id int) (model.AdServiceClient, error) {
	res, err := service.adServiceClientRepo.GetByID(ctx, id)
	if err != nil {
		return res, fmt.Errorf("service adServiceClient: GetByID: %w", err)
	}

	res.UrlDocument = make([]string, 0, len(res.Documents))
	for _, d := range res.Documents {
		d, err = service.remotes.Share(ctx, d, time.Hour*1)
		if err != nil {
			return res, fmt.Errorf("service adServiceClient: GetByID: get document: id_doc: %d: %w", res.ID, err)
		}
		res.UrlDocument = append(res.UrlDocument, d.ShareLink)
	}

	return res, nil
}

func (service *adServiceClient) Create(ctx context.Context, ad model.AdServiceClient) error {
	ad.Status = model.STATUS_CREATED

	id, err := service.adServiceClientRepo.Create(ctx, ad)
	if err != nil {
		return fmt.Errorf("service adServiceClient: Create: %w", err)
	}

	for i, d := range ad.Documents {
		_, err := service.remotes.Upload(ctx, ad.Documents[i])
		if err != nil {
			return fmt.Errorf("service adServiceClient: Upload Document: documne title \"%v\": %v", d.Title, err.Error())
		}
	}

	{
		adElastic, err := service.adServiceClientRepo.GetByID(ctx, id)
		if err != nil {
			return fmt.Errorf("service adServiceClient: GetByID: %w", err)
		}
		err = service.elastic.Create(ctx, adElastic)
		if err != nil {
			return fmt.Errorf("service adServiceClient: Create elastic: %w", err)
		}
		ad = adElastic
	}

	title := "У вас есть объявления"
	message := ad.ServiceSubCategory.Name + " - " + ad.Title + ". Нажмите чтобы посмотреть"
	err = service.subscriptionService.SendOutNoticeAdClientSVC(ctx, ad.ServiceSubCategoryID, message, title, id, ad.CityID)
	if err != nil {
		return fmt.Errorf("service adServiceClient: SendOutNoticeAdClientEQ elastic: %w", err)
	}

	return nil
}

func (service *adServiceClient) Update(ctx context.Context, ad model.AdServiceClient) error {
	err := service.adServiceClientRepo.Update(ctx, ad)
	if err != nil {
		return fmt.Errorf("service adServiceClient: Update: %w", err)
	}

	{
		ad, err := service.adServiceClientRepo.GetByID(ctx, ad.ID)
		if err != nil {
			return fmt.Errorf("service adServiceClient: GetByID: %w", err)
		}

		err = service.elastic.Update(ctx, ad)
		if err != nil {
			return fmt.Errorf("service adServiceClient: Elastic: %w", err)
		}
	}

	return nil
}

func (service *adServiceClient) UpdateStatus(ctx context.Context, ad model.AdServiceClient) error {
	err := service.adServiceClientRepo.UpdateStatus(ctx, ad)
	if err != nil {
		return fmt.Errorf("service adServiceClient: Update: %w", err)
	}

	return nil
}

func (service *adServiceClient) Delete(ctx context.Context, id int) error {
	err := service.adServiceClientRepo.Delete(ctx, id)
	if err != nil {
		return fmt.Errorf("service adServiceClient: Delete: %w", err)
	}

	err = service.elastic.Delete(ctx, id)
	if err != nil {
		return err
	}

	return nil
}

func (service *adServiceClient) GetFavorite(ctx context.Context, userID int) ([]model.FavoriteAdServiceClient, error) {
	res, err := service.favoriteRepo.GetAdServiceClientByUserID(ctx, userID)
	if err != nil {
		return nil, fmt.Errorf("service adServiceClient: GetFavorite: %w", err)
	}

	for i, ad := range res {
		res[i].AdServiceClient.UrlDocument = make([]string, 0, len(ad.AdServiceClient.Documents))
		for _, v := range ad.AdServiceClient.Documents {
			v, err = service.remotes.Share(ctx, v, time.Hour*1)
			if err != nil {
				return nil, fmt.Errorf("service adServiceClient: GetFavorite: get document: id ad %d: id_doc %d: error: %w", ad.AdServiceClient.ID, v.ID, err)
			}
			res[i].AdServiceClient.UrlDocument = append(res[i].AdServiceClient.UrlDocument, v.ShareLink)
		}
	}

	return res, nil
}

func (service *adServiceClient) CreateFavorite(ctx context.Context, fav model.FavoriteAdServiceClient) error {
	err := service.favoriteRepo.CreateAdServiceClient(ctx, fav)
	if err != nil {
		return fmt.Errorf("service adServiceClient: CreateFavorite: %w", err)
	}
	return nil
}

func (service *adServiceClient) DeleteFavorite(ctx context.Context, fav model.FavoriteAdServiceClient) error {
	err := service.favoriteRepo.DeleteAdServiceClient(ctx, fav)
	if err != nil {
		return fmt.Errorf("service adServiceClient: DeleteFavorite: %w", err)
	}
	return nil
}

func (service *adServiceClient) GetSeen(ctx context.Context, id int) (int, error) {
	res, err := service.adServiceClientRepo.GetByIDSeen(ctx, id)
	if err != nil {
		if errors.Is(err, model.ErrNotFound) {
			err := service.adServiceClientRepo.CreateSeen(ctx, id)
			if err != nil {
				return 0, fmt.Errorf("service adServiceClientRepo: GetSeen: CreateSeen: %w", err)
			}
			return 0, nil
		}
		return 0, fmt.Errorf("service adServiceClientRepo: GetSeen: %w", err)
	}

	return res, nil
}

func (service *adServiceClient) IncrementSeen(ctx context.Context, id int) error {
	_, err := service.adServiceClientRepo.GetByIDSeen(ctx, id)
	if err != nil {
		if errors.Is(err, model.ErrNotFound) {
			err := service.adServiceClientRepo.CreateSeen(ctx, id)
			if err != nil {
				return fmt.Errorf("service adServiceClientRepo: IncrementSeen: CreateSeen: %w", err)
			}
			err = service.adServiceClientRepo.IncrementSeen(ctx, id)
			if err != nil {
				return fmt.Errorf("service adServiceClientRepo: IncrementSeen: IncrementSeen2: %w", err)
			}
			return nil
		}
		return fmt.Errorf("service adServiceClientRepo: IncrementSeen: IncrementSeen2: %w", err)
	}

	err = service.adServiceClientRepo.IncrementSeen(ctx, id)
	if err != nil {
		return fmt.Errorf("service adServiceClientRepo: IncrementSeen: IncrementSeen: %w", err)
	}
	return nil
}
