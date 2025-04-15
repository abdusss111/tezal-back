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

type IAdEquipmentClient interface {
	Get(ctx context.Context, f model.FilterAdEquipmentClients) ([]model.AdEquipmentClient, int, error)
	GetByID(ctx context.Context, id int) (model.AdEquipmentClient, error)
	Create(ctx context.Context, ad model.AdEquipmentClient) error
	Update(ctx context.Context, ad model.AdEquipmentClient) error
	UpdateStatus(ctx context.Context, ad model.AdEquipmentClient) error
	Delete(ctx context.Context, id int) error

	GetFavorite(ctx context.Context, userID int) ([]model.FavoriteAdEquipmentClient, error)
	CreateFavorite(ctx context.Context, fav model.FavoriteAdEquipmentClient) error
	DeleteFavorite(ctx context.Context, fav model.FavoriteAdEquipmentClient) error
	GetSeen(ctx context.Context, id int) (int, error)
	IncrementSeen(ctx context.Context, id int) error
}

type adEquipmentClient struct {
	adEquipmentClientRepo repository.IAdEquipmentClient
	remotes               client.DocumentsRemote
	favoriteRepo          repository.IFavorite
	elastic               elastic.IAdEquipmentClient
	subscriptionService   ISubscription
}

func NewAdEquipmentClient(
	adEquipmentClientRepo repository.IAdEquipmentClient,
	remotes client.DocumentsRemote,
	favoriteRepo repository.IFavorite,
	elastic elastic.IAdEquipmentClient,
	subscriptionService ISubscription,
) IAdEquipmentClient {
	return &adEquipmentClient{
		adEquipmentClientRepo: adEquipmentClientRepo,
		remotes:               remotes,
		favoriteRepo:          favoriteRepo,
		elastic:               elastic,
		subscriptionService:   subscriptionService,
	}
}

func (service *adEquipmentClient) Get(ctx context.Context, f model.FilterAdEquipmentClients) ([]model.AdEquipmentClient, int, error) {
	res, total, err := service.adEquipmentClientRepo.Get(ctx, f)
	if err != nil {
		return nil, 0, fmt.Errorf("service adEquipmentClient: Get: %w", err)
	}

	for i, ad := range res {
		res[i].UrlDocument = make([]string, 0, len(ad.Documents))
		for _, v := range ad.Documents {
			v, err = service.remotes.Share(ctx, v, time.Hour*1)
			if err != nil {
				return nil, 0, fmt.Errorf("service adEquipmentClient: get document: id ad %d: id_doc %d: error: %w", ad.ID, v.ID, err)
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

func (service *adEquipmentClient) GetByID(ctx context.Context, id int) (model.AdEquipmentClient, error) {
	res, err := service.adEquipmentClientRepo.GetByID(ctx, id)
	if err != nil {
		return res, fmt.Errorf("service adEquipmentClient: GetByID: %w", err)
	}

	res.UrlDocument = make([]string, 0, len(res.Documents))
	for _, d := range res.Documents {
		d, err = service.remotes.Share(ctx, d, time.Hour*1)
		if err != nil {
			return res, fmt.Errorf("service adEquipmentClient: GetByID: get document: id_doc: %d: %w", res.ID, err)
		}
		res.UrlDocument = append(res.UrlDocument, d.ShareLink)
	}

	return res, nil
}

func (service *adEquipmentClient) Create(ctx context.Context, ad model.AdEquipmentClient) error {
	ad.Status = model.STATUS_CREATED

	id, err := service.adEquipmentClientRepo.Create(ctx, ad)
	if err != nil {
		return fmt.Errorf("service adEquipmentClient: Create: %w", err)
	}

	for i, d := range ad.Documents {
		_, err := service.remotes.Upload(ctx, ad.Documents[i])
		if err != nil {
			return fmt.Errorf("service adEquipmentClient: Upload Document: documne title \"%v\": %v", d.Title, err.Error())
		}
	}

	{
		adElastic, err := service.adEquipmentClientRepo.GetByID(ctx, id)
		if err != nil {
			return fmt.Errorf("service adEquipmentClient: GetByID: %w", err)
		}

		err = service.elastic.Create(ctx, adElastic)
		if err != nil {
			return fmt.Errorf("service adEquipmentClient: Create elastic: %w", err)
		}
		ad = adElastic
	}

	title := "У вас есть объявления"
	message := ad.EquipmentSubCategory.Name + " - " + ad.Title + ". Нажмите чтобы посмотреть"
	err = service.subscriptionService.SendOutNoticeAdClientEQ(ctx, ad.EquipmentSubCategoryID, message, title, id, ad.CityID)
	if err != nil {
		return fmt.Errorf("service adEquipmentClient: SendOutNoticeAdClientEQ elastic: %w", err)
	}

	return nil
}

func (service *adEquipmentClient) Update(ctx context.Context, ad model.AdEquipmentClient) error {
	err := service.adEquipmentClientRepo.Update(ctx, ad)
	if err != nil {
		return fmt.Errorf("service adEquipmentClient: Update: %w", err)
	}

	{
		ad, err := service.adEquipmentClientRepo.GetByID(ctx, ad.ID)
		if err != nil {
			return fmt.Errorf("service adEquipmentClient: GetByID: %w", err)
		}

		err = service.elastic.Update(ctx, ad)
		if err != nil {
			return fmt.Errorf("service adEquipmentClient: Elastic: %w", err)
		}
	}

	return nil
}

func (service *adEquipmentClient) UpdateStatus(ctx context.Context, ad model.AdEquipmentClient) error {
	err := service.adEquipmentClientRepo.UpdateStatus(ctx, ad)
	if err != nil {
		return fmt.Errorf("service adEquipmentClient: Update: %w", err)
	}

	return nil
}

func (service *adEquipmentClient) Delete(ctx context.Context, id int) error {
	err := service.adEquipmentClientRepo.Delete(ctx, id)
	if err != nil {
		return fmt.Errorf("service adEquipmentClient: Delete: %w", err)
	}

	err = service.elastic.Delete(ctx, id)
	if err != nil {
		return err
	}

	return nil
}

func (service *adEquipmentClient) GetFavorite(ctx context.Context, userID int) ([]model.FavoriteAdEquipmentClient, error) {
	res, err := service.favoriteRepo.GetAdEquipmentClientByUserID(ctx, userID)
	if err != nil {
		return nil, fmt.Errorf("service adEquipmentClient: GetFavorite: %w", err)
	}

	for i, ad := range res {
		res[i].AdEquipmentClient.UrlDocument = make([]string, 0, len(ad.AdEquipmentClient.Documents))
		for _, v := range ad.AdEquipmentClient.Documents {
			v, err = service.remotes.Share(ctx, v, time.Hour*1)
			if err != nil {
				return nil, fmt.Errorf("service adEquipmentClient: GetFavorite: get document: id ad %d: id_doc %d: error: %w", ad.AdEquipmentClient.ID, v.ID, err)
			}
			res[i].AdEquipmentClient.UrlDocument = append(res[i].AdEquipmentClient.UrlDocument, v.ShareLink)
		}
	}

	return res, nil
}

func (service *adEquipmentClient) CreateFavorite(ctx context.Context, fav model.FavoriteAdEquipmentClient) error {
	err := service.favoriteRepo.CreateAdEquipmentClient(ctx, fav)
	if err != nil {
		return fmt.Errorf("service adEquipmentClient: CreateFavorite: %w", err)
	}
	return nil
}

func (service *adEquipmentClient) DeleteFavorite(ctx context.Context, fav model.FavoriteAdEquipmentClient) error {
	err := service.favoriteRepo.DeleteAdEquipmentClient(ctx, fav)
	if err != nil {
		return fmt.Errorf("service adEquipmentClient: DeleteFavorite: %w", err)
	}
	return nil
}

func (service *adEquipmentClient) GetSeen(ctx context.Context, id int) (int, error) {
	res, err := service.adEquipmentClientRepo.GetByIDSeen(ctx, id)
	if err != nil {
		if errors.Is(err, model.ErrNotFound) {
			err := service.adEquipmentClientRepo.CreateSeen(ctx, id)
			if err != nil {
				return 0, fmt.Errorf("service adEquipmentClientRepo: GetSeen: CreateSeen: %w", err)
			}
			return 0, nil
		}
		return 0, fmt.Errorf("service adEquipmentClientRepo: GetSeen: %w", err)
	}

	return res, nil
}

func (service *adEquipmentClient) IncrementSeen(ctx context.Context, id int) error {
	_, err := service.adEquipmentClientRepo.GetByIDSeen(ctx, id)
	if err != nil {
		if errors.Is(err, model.ErrNotFound) {
			err := service.adEquipmentClientRepo.CreateSeen(ctx, id)
			if err != nil {
				return fmt.Errorf("service adEquipmentClientRepo: IncrementSeen: CreateSeen: %w", err)
			}
			err = service.adEquipmentClientRepo.IncrementSeen(ctx, id)
			if err != nil {
				return fmt.Errorf("service adEquipmentClientRepo: IncrementSeen: IncrementSeen2: %w", err)
			}
			return nil
		}
		return fmt.Errorf("service adEquipmentClientRepo: IncrementSeen: IncrementSeen2: %w", err)
	}

	err = service.adEquipmentClientRepo.IncrementSeen(ctx, id)
	if err != nil {
		return fmt.Errorf("service adEquipmentClientRepo: IncrementSeen: IncrementSeen: %w", err)
	}
	return nil
}
