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

type IAdService interface {
	Get(ctx context.Context, f model.FilterAdService) ([]model.AdService, int, error)
	GetByID(ctx context.Context, id int) (model.AdService, error)
	Create(ctx context.Context, ad model.AdService) error
	Update(ctx context.Context, ad model.AdService) error
	Delete(ctx context.Context, id int) error

	GetFavorite(ctx context.Context, userID int) ([]model.FavoriteAdService, error)
	CreateFavorite(ctx context.Context, fav model.FavoriteAdService) error
	DeleteFavorite(ctx context.Context, fav model.FavoriteAdService) error

	Interacted(adID int, userID int) error
	GetInteracted(adID int) ([]model.AdService, error)

	GetSeen(ctx context.Context, id int) (int, error)
	IncrementSeen(ctx context.Context, id int) error
}

type adService struct {
	adServiceRepo repository.IAdService
	remotes       client.DocumentsRemote
	favoriteRepo  repository.IFavorite
	elastic       elastic.IAdService
}

func NewAdService(
	adServiceRepo repository.IAdService,
	remotes client.DocumentsRemote,
	favoriteRepo repository.IFavorite,
	elastic elastic.IAdService,
) IAdService {
	return &adService{
		adServiceRepo: adServiceRepo,
		remotes:       remotes,
		favoriteRepo:  favoriteRepo,
		elastic:       elastic,
	}
}

func (service *adService) Get(ctx context.Context, f model.FilterAdService) ([]model.AdService, int, error) {
	res, total, err := service.adServiceRepo.Get(ctx, f)
	if err != nil {
		return nil, 0, fmt.Errorf("service adService: Get: %w", err)
	}

	for i, ad := range res {
		res[i].UrlDocument = make([]string, 0, len(ad.Documents))
		for _, v := range ad.Documents {
			v, err = service.remotes.Share(ctx, v, time.Duration(time.Hour))
			if err != nil {
				return nil, 0, fmt.Errorf("service adService: get document: id ad %d: id_doc %d: error: %w", ad.ID, v.ID, err)
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

func (service *adService) GetByID(ctx context.Context, id int) (model.AdService, error) {
	res, err := service.adServiceRepo.GetByID(ctx, id)
	if err != nil {
		return res, fmt.Errorf("service adService: GetByID: %w", err)
	}

	res.UrlDocument = make([]string, 0, len(res.Documents))
	for _, d := range res.Documents {
		d, err = service.remotes.Share(ctx, d, time.Duration(time.Hour))
		if err != nil {
			return res, fmt.Errorf("service adService: GetByID: get document: id_doc: %d: %w", res.ID, err)
		}
		res.UrlDocument = append(res.UrlDocument, d.ShareLink)
	}

	return res, nil
}

func (service *adService) Create(ctx context.Context, ad model.AdService) error {
	{
		n := 50
		ad.CountRate = &n
	}
	{
		n := 5.0
		ad.Rating = &n
	}

	id, err := service.adServiceRepo.Create(ctx, ad)
	if err != nil {
		return fmt.Errorf("service adService: Create: %w", err)
	}

	for i, d := range ad.Documents {
		_, err := service.remotes.Upload(ctx, ad.Documents[i])
		if err != nil {
			return fmt.Errorf("service adService: Upload Document: documne title \"%v\": %v", d.Title, err.Error())
		}
	}

	{
		adElastic, err := service.adServiceRepo.GetByID(ctx, id)
		if err != nil {
			return err
		}

		err = service.elastic.Create(ctx, adElastic)
		if err != nil {
			return err
		}
	}

	return nil
}

func (service *adService) Update(ctx context.Context, ad model.AdService) error {
	err := service.adServiceRepo.Update(ctx, ad)
	if err != nil {
		return fmt.Errorf("service adService: Update: %w", err)
	}

	{
		ad, err := service.adServiceRepo.GetByID(ctx, ad.ID)
		if err != nil {
			return err
		}

		err = service.elastic.Update(ctx, ad)
		if err != nil {
			return err
		}
	}
	return nil
}

func (service *adService) Delete(ctx context.Context, id int) error {
	err := service.adServiceRepo.Delete(ctx, id)
	if err != nil {
		return fmt.Errorf("service adService: Delete: %w", err)
	}

	err = service.elastic.Delete(ctx, id)
	if err != nil {
		return fmt.Errorf("service adService: Elastic: Delete: %w", err)
	}

	return nil
}

func (service *adService) GetFavorite(ctx context.Context, userID int) ([]model.FavoriteAdService, error) {
	res, err := service.favoriteRepo.GetAdServiceByUserID(ctx, userID)
	if err != nil {
		return nil, fmt.Errorf("service adService: GetFavorite: %w", err)
	}

	for i, ad := range res {
		res[i].AdService.UrlDocument = make([]string, 0, len(ad.AdService.Documents))
		for _, v := range ad.AdService.Documents {
			v, err = service.remotes.Share(ctx, v, time.Hour*1)
			if err != nil {
				return nil, fmt.Errorf("service adService: GetFavorite: get document: id ad %d: id_doc %d: error: %w", ad.AdService.ID, v.ID, err)
			}
			res[i].AdService.UrlDocument = append(res[i].AdService.UrlDocument, v.ShareLink)
		}
	}

	return res, nil
}

func (service *adService) CreateFavorite(ctx context.Context, fav model.FavoriteAdService) error {
	err := service.favoriteRepo.CreateAdService(ctx, fav)
	if err != nil {
		return fmt.Errorf("service adService: CreateFavorite: %w", err)
	}
	return nil
}

func (service *adService) DeleteFavorite(ctx context.Context, fav model.FavoriteAdService) error {
	err := service.favoriteRepo.DeleteAdService(ctx, fav)
	if err != nil {
		return fmt.Errorf("service adService: DeleteFavorite: %w", err)
	}
	return nil
}

func (service *adService) Interacted(adID int, userID int) error {
	return nil
}
func (service *adService) GetInteracted(adID int) ([]model.AdService, error) {
	return nil, nil
}

func (service *adService) GetSeen(ctx context.Context, id int) (int, error) {
	res, err := service.adServiceRepo.GetByIDSeen(ctx, id)
	if err != nil {
		if errors.Is(err, model.ErrNotFound) {
			err := service.adServiceRepo.CreateSeen(ctx, id)
			if err != nil {
				return 0, fmt.Errorf("service adService: GetSeen: CreateSeen: %w", err)
			}
			return 0, nil
		}
		return 0, fmt.Errorf("service adService: GetSeen: %w", err)
	}

	return res, nil
}

func (service *adService) IncrementSeen(ctx context.Context, id int) error {
	_, err := service.adServiceRepo.GetByIDSeen(ctx, id)
	if err != nil {
		if errors.Is(err, model.ErrNotFound) {
			err := service.adServiceRepo.CreateSeen(ctx, id)
			if err != nil {
				return fmt.Errorf("service adService: IncrementSeen: CreateSeen: %w", err)
			}
			err = service.adServiceRepo.IncrementSeen(ctx, id)
			if err != nil {
				return fmt.Errorf("service adService: IncrementSeen: IncrementSeen2: %w", err)
			}
			return nil
		}
		return fmt.Errorf("service adService: IncrementSeen: IncrementSeen2: %w", err)
	}

	err = service.adServiceRepo.IncrementSeen(ctx, id)
	if err != nil {
		return fmt.Errorf("service adService: IncrementSeen: IncrementSeen: %w", err)
	}
	return nil
}
