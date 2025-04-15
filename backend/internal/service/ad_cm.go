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

type IAdConstructionMaterial interface {
	Get(ctx context.Context, f model.FilterAdConstructionMaterial) ([]model.AdConstructionMaterial, int, error)
	GetByID(ctx context.Context, id int) (model.AdConstructionMaterial, error)
	Create(ctx context.Context, ad model.AdConstructionMaterial) error
	Update(ctx context.Context, ad model.AdConstructionMaterial) error
	Delete(ctx context.Context, id int) error

	GetFavorite(ctx context.Context, userID int) ([]model.FavoriteAdConstructionMaterial, error)
	CreateFavorite(ctx context.Context, fav model.FavoriteAdConstructionMaterial) error
	DeleteFavorite(ctx context.Context, fav model.FavoriteAdConstructionMaterial) error

	Interacted(adID int, userID int) error
	GetInteracted(adID int) ([]model.AdConstructionMaterial, error)

	GetSeen(ctx context.Context, id int) (int, error)
	IncrementSeen(ctx context.Context, id int) error
}

type adConstructionMaterial struct {
	adConstructionMaterialRepo repository.IAdConstructionMaterials
	remotes                    client.DocumentsRemote
	favoriteRepo               repository.IFavorite
	elastic                    elastic.IAdConstructionMaterial
}

func NewAdConstructionMaterial(
	adConstructionMaterialRepo repository.IAdConstructionMaterials,
	remotes client.DocumentsRemote,
	favoriteRepo repository.IFavorite,
	elastic elastic.IAdConstructionMaterial,
) IAdConstructionMaterial {
	return &adConstructionMaterial{
		adConstructionMaterialRepo: adConstructionMaterialRepo,
		remotes:                    remotes,
		favoriteRepo:               favoriteRepo,
		elastic:                    elastic,
	}
}

func (service *adConstructionMaterial) Get(ctx context.Context, f model.FilterAdConstructionMaterial) ([]model.AdConstructionMaterial, int, error) {
	res, total, err := service.adConstructionMaterialRepo.Get(ctx, f)
	if err != nil {
		return nil, 0, fmt.Errorf("service adConstructionMaterial: Get: %w", err)
	}

	for i, ad := range res {
		res[i].UrlDocument = make([]string, 0, len(ad.Documents))
		for _, v := range ad.Documents {
			v, err = service.remotes.Share(ctx, v, time.Hour)
			if err != nil {
				return nil, 0, fmt.Errorf("service adConstructionMaterial: get document: id ad %d: id_doc %d: error: %w", ad.ID, v.ID, err)
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

func (service *adConstructionMaterial) GetByID(ctx context.Context, id int) (model.AdConstructionMaterial, error) {
	res, err := service.adConstructionMaterialRepo.GetByID(ctx, id)
	if err != nil {
		return res, fmt.Errorf("service adConstructionMaterial: GetByID: %w", err)
	}

	res.UrlDocument = make([]string, 0, len(res.Documents))
	for _, d := range res.Documents {
		d, err = service.remotes.Share(ctx, d, time.Hour)
		if err != nil {
			return res, fmt.Errorf("service adConstructionMaterial: GetByID: get document: id_doc: %d: %w", res.ID, err)
		}
		res.UrlDocument = append(res.UrlDocument, d.ShareLink)
	}

	return res, nil
}

func (service *adConstructionMaterial) Create(ctx context.Context, ad model.AdConstructionMaterial) error {
	{
		n := 50
		ad.CountRate = &n
	}
	{
		n := 5.0
		ad.Rating = &n
	}

	id, err := service.adConstructionMaterialRepo.Create(ctx, ad)
	if err != nil {
		return fmt.Errorf("service adConstructionMaterial: Create: %w", err)
	}

	for i, d := range ad.Documents {
		_, err := service.remotes.Upload(ctx, ad.Documents[i])
		if err != nil {
			return fmt.Errorf("service adConstructionMaterial: Upload Document: documne title \"%v\": %v", d.Title, err.Error())
		}
	}

	{
		adElastic, err := service.adConstructionMaterialRepo.GetByID(ctx, id)
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

func (service *adConstructionMaterial) Update(ctx context.Context, ad model.AdConstructionMaterial) error {
	err := service.adConstructionMaterialRepo.Update(ctx, ad)
	if err != nil {
		return fmt.Errorf("service adConstructionMaterial: Update: %w", err)
	}

	{
		ad, err := service.adConstructionMaterialRepo.GetByID(ctx, ad.ID)
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

func (service *adConstructionMaterial) Delete(ctx context.Context, id int) error {
	err := service.adConstructionMaterialRepo.Delete(ctx, id)
	if err != nil {
		return fmt.Errorf("service adConstructionMaterial: Delete: %w", err)
	}

	err = service.elastic.Delete(ctx, id)
	if err != nil {
		return fmt.Errorf("service adConstructionMaterial: Elastic: Delete: %w", err)
	}

	return nil
}

func (service *adConstructionMaterial) GetFavorite(ctx context.Context, userID int) ([]model.FavoriteAdConstructionMaterial, error) {
	res, err := service.favoriteRepo.GetAdConstructionMaterialByUserID(ctx, userID)
	if err != nil {
		return nil, fmt.Errorf("service adConstructionMaterial: GetFavorite: %w", err)
	}

	for i, ad := range res {
		res[i].AdConstructionMaterial.UrlDocument = make([]string, 0, len(ad.AdConstructionMaterial.Documents))
		for _, v := range ad.AdConstructionMaterial.Documents {
			v, err = service.remotes.Share(ctx, v, time.Hour*1)
			if err != nil {
				return nil, fmt.Errorf("service adConstructionMaterial: GetFavorite: get document: id ad %d: id_doc %d: error: %w", ad.AdConstructionMaterial.ID, v.ID, err)
			}
			res[i].AdConstructionMaterial.UrlDocument = append(res[i].AdConstructionMaterial.UrlDocument, v.ShareLink)
		}
	}

	return res, nil
}

func (service *adConstructionMaterial) CreateFavorite(ctx context.Context, fav model.FavoriteAdConstructionMaterial) error {
	err := service.favoriteRepo.CreateAdConstructionMaterial(ctx, fav)
	if err != nil {
		return fmt.Errorf("service adConstructionMaterial: CreateFavorite: %w", err)
	}
	return nil
}

func (service *adConstructionMaterial) DeleteFavorite(ctx context.Context, fav model.FavoriteAdConstructionMaterial) error {
	err := service.favoriteRepo.DeleteAdConstructionMaterial(ctx, fav)
	if err != nil {
		return fmt.Errorf("service adConstructionMaterial: DeleteFavorite: %w", err)
	}
	return nil
}

func (service *adConstructionMaterial) Interacted(adID int, userID int) error {
	return nil
}

func (service *adConstructionMaterial) GetInteracted(adID int) ([]model.AdConstructionMaterial, error) {
	return nil, nil
}

func (service *adConstructionMaterial) GetSeen(ctx context.Context, id int) (int, error) {
	res, err := service.adConstructionMaterialRepo.GetByIDSeen(ctx, id)
	if err != nil {
		if errors.Is(err, model.ErrNotFound) {
			err := service.adConstructionMaterialRepo.CreateSeen(ctx, id)
			if err != nil {
				return 0, fmt.Errorf("service adConstructionMaterial: GetSeen: CreateSeen: %w", err)
			}
			return 0, nil
		}
		return 0, fmt.Errorf("service adConstructionMaterial: GetSeen: %w", err)
	}

	return res, nil
}

func (service *adConstructionMaterial) IncrementSeen(ctx context.Context, id int) error {
	_, err := service.adConstructionMaterialRepo.GetByIDSeen(ctx, id)
	if err != nil {
		if errors.Is(err, model.ErrNotFound) {
			err := service.adConstructionMaterialRepo.CreateSeen(ctx, id)
			if err != nil {
				return fmt.Errorf("service adConstructionMaterial: IncrementSeen: CreateSeen: %w", err)
			}
			err = service.adConstructionMaterialRepo.IncrementSeen(ctx, id)
			if err != nil {
				return fmt.Errorf("service adConstructionMaterial: IncrementSeen: IncrementSeen2: %w", err)
			}
			return nil
		}
		return fmt.Errorf("service adConstructionMaterial: IncrementSeen: IncrementSeen2: %w", err)
	}

	err = service.adConstructionMaterialRepo.IncrementSeen(ctx, id)
	if err != nil {
		return fmt.Errorf("service adConstructionMaterial: IncrementSeen: IncrementSeen: %w", err)
	}
	return nil
}
