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

type IAdEquipment interface {
	Get(ctx context.Context, f model.FilterAdEquipment) ([]model.AdEquipment, int, error)
	GetByID(ctx context.Context, id int) (model.AdEquipment, error)
	Create(ctx context.Context, ad model.AdEquipment) error
	Update(ctx context.Context, ad model.AdEquipment) error
	Delete(ctx context.Context, id int) error

	GetFavorite(ctx context.Context, userID int) ([]model.FavoriteAdEquipment, error)
	CreateFavorite(ctx context.Context, fav model.FavoriteAdEquipment) error
	DeleteFavorite(ctx context.Context, fav model.FavoriteAdEquipment) error

	Interacted(adID int, userID int) error
	GetInteracted(adID int) ([]model.AdEquipment, error)

	GetSeen(ctx context.Context, id int) (int, error)
	IncrementSeen(ctx context.Context, id int) error
}

type adEquipment struct {
	adEquipmentRepo repository.IAdEquipment
	remotes         client.DocumentsRemote
	favoriteRepo    repository.IFavorite
	elastic         elastic.IAdEquipment
}

func NewAdEquipment(
	adEquipmentRepo repository.IAdEquipment,
	remotes client.DocumentsRemote,
	favoriteRepo repository.IFavorite,
	elastic elastic.IAdEquipment,
) IAdEquipment {
	return &adEquipment{
		adEquipmentRepo: adEquipmentRepo,
		remotes:         remotes,
		favoriteRepo:    favoriteRepo,
		elastic:         elastic,
	}
}

func (service *adEquipment) Get(ctx context.Context, f model.FilterAdEquipment) ([]model.AdEquipment, int, error) {
	res, total, err := service.adEquipmentRepo.Get(ctx, f)
	if err != nil {
		return nil, 0, fmt.Errorf("service adEquipment: Get: %w", err)
	}

	for i, ad := range res {
		res[i].
			UrlDocument = make([]string, 0, len(ad.Documents))
		for _, v := range ad.Documents {
			v, err = service.remotes.Share(ctx, v, time.Duration(time.Hour))
			if err != nil {
				return nil, 0, fmt.Errorf("service adEquipment: get document: id ad %d: id_doc %d: error: %w", ad.ID, v.ID, err)
			}
			res[i].UrlDocument = append(res[i].UrlDocument, v.ShareLink)
		}
	}

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

func (service *adEquipment) GetByID(ctx context.Context, id int) (model.AdEquipment, error) {
	res, err := service.adEquipmentRepo.GetByID(ctx, id)
	if err != nil {
		return res, fmt.Errorf("service adEquipment: GetByID: %w", err)
	}

	res.UrlDocument = make([]string, 0, len(res.Documents))
	for _, d := range res.Documents {
		d, err = service.remotes.Share(ctx, d, time.Duration(time.Hour))
		if err != nil {
			return res, fmt.Errorf("service adEquipment: GetByID: get document: id_doc: %d: %w", res.ID, err)
		}
		res.UrlDocument = append(res.UrlDocument, d.ShareLink)
	}

	return res, nil
}

func (service *adEquipment) Create(ctx context.Context, ad model.AdEquipment) error {
	{
		n := 50
		ad.CountRate = &n
	}
	{
		n := 5.0
		ad.Rating = &n
	}

	id, err := service.adEquipmentRepo.Create(ctx, ad)
	if err != nil {
		return fmt.Errorf("service adEquipment: Create: %w", err)
	}

	for i, d := range ad.Documents {
		_, err := service.remotes.Upload(ctx, ad.Documents[i])
		if err != nil {
			return fmt.Errorf("service adEquipment: Upload Document: documne title \"%v\": %v", d.Title, err.Error())
		}
	}

	{
		ad, err := service.adEquipmentRepo.GetByID(ctx, id)
		if err != nil {
			return err
		}

		err = service.elastic.Create(ctx, ad)
		if err != nil {
			return err
		}
	}

	return nil
}

func (service *adEquipment) Update(ctx context.Context, ad model.AdEquipment) error {
	err := service.adEquipmentRepo.Update(ctx, ad)
	if err != nil {
		return fmt.Errorf("service adEquipment: Update: %w", err)
	}

	{
		ad, err := service.adEquipmentRepo.GetByID(ctx, ad.ID)
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

func (service *adEquipment) Delete(ctx context.Context, id int) error {
	err := service.adEquipmentRepo.Delete(ctx, id)
	if err != nil {
		return fmt.Errorf("service adEquipment: Delete: %w", err)
	}

	err = service.elastic.Delete(ctx, id)
	if err != nil {
		return fmt.Errorf("service adEquipment: Elastic: Delete: %w", err)
	}

	return nil
}

func (service *adEquipment) GetFavorite(ctx context.Context, userID int) ([]model.FavoriteAdEquipment, error) {
	res, err := service.favoriteRepo.GetAdEquipmentByUserID(ctx, userID)
	if err != nil {
		return nil, fmt.Errorf("service adEquipment: GetFavorite: %w", err)
	}

	for i, ad := range res {
		res[i].AdEquipment.UrlDocument = make([]string, 0, len(ad.AdEquipment.Documents))
		for _, v := range ad.AdEquipment.Documents {
			v, err = service.remotes.Share(ctx, v, time.Hour*1)
			if err != nil {
				return nil, fmt.Errorf("service adEquipment: GetFavorite: get document: id ad %d: id_doc %d: error: %w", ad.AdEquipment.ID, v.ID, err)
			}
			res[i].AdEquipment.UrlDocument = append(res[i].AdEquipment.UrlDocument, v.ShareLink)
		}
	}

	return res, nil
}

func (service *adEquipment) CreateFavorite(ctx context.Context, fav model.FavoriteAdEquipment) error {
	err := service.favoriteRepo.CreateAdEquipment(ctx, fav)
	if err != nil {
		return fmt.Errorf("service adEquipment: CreateFavorite: %w", err)
	}
	return nil
}

func (service *adEquipment) DeleteFavorite(ctx context.Context, fav model.FavoriteAdEquipment) error {
	err := service.favoriteRepo.DeleteAdEquipment(ctx, fav)
	if err != nil {
		return fmt.Errorf("service adEquipment: DeleteFavorite: %w", err)
	}
	return nil
}

func (service *adEquipment) Interacted(adID int, userID int) error {
	return nil
}
func (service *adEquipment) GetInteracted(adID int) ([]model.AdEquipment, error) {
	return nil, nil
}

func (service *adEquipment) GetSeen(ctx context.Context, id int) (int, error) {
	res, err := service.adEquipmentRepo.GetByIDSeen(ctx, id)
	if err != nil {
		if errors.Is(err, model.ErrNotFound) {
			err := service.adEquipmentRepo.CreateSeen(ctx, id)
			if err != nil {
				return 0, fmt.Errorf("service adEquipment: GetSeen: CreateSeen: %w", err)
			}
			return 0, nil
		}
		return 0, fmt.Errorf("service adEquipment: GetSeen: %w", err)
	}

	return res, nil
}

func (service *adEquipment) IncrementSeen(ctx context.Context, id int) error {
	_, err := service.adEquipmentRepo.GetByIDSeen(ctx, id)
	if err != nil {
		if errors.Is(err, model.ErrNotFound) {
			err := service.adEquipmentRepo.CreateSeen(ctx, id)
			if err != nil {
				return fmt.Errorf("service adEquipment: IncrementSeen: CreateSeen: %w", err)
			}
			err = service.adEquipmentRepo.IncrementSeen(ctx, id)
			if err != nil {
				return fmt.Errorf("service adEquipment: IncrementSeen: IncrementSeen2: %w", err)
			}
			return nil
		}
		return fmt.Errorf("service adEquipment: IncrementSeen: IncrementSeen2: %w", err)
	}

	err = service.adEquipmentRepo.IncrementSeen(ctx, id)
	if err != nil {
		return fmt.Errorf("service adEquipment: IncrementSeen: IncrementSeen: %w", err)
	}
	return nil
}
