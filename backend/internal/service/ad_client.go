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

type IAdClient interface {
	Create(ctx context.Context, ad model.AdClient) error
	Update(ctx context.Context, ad model.AdClient) error
	GetByID(ctx context.Context, ad model.AdClient) (model.AdClient, error)
	GetOwnerList(ctx context.Context, ad model.AdClient) ([]model.AdClient, error)
	GetList(ctx context.Context, filter model.FilterAdClient) ([]model.AdClient, int, error)
	Delete(ctx context.Context, ad model.AdClient) error
	CreateInteracted(adClientID int, userID int) error
	GetInteracted(id int) ([]model.AdClientInteracted, error)
	GetFavorite(ctx context.Context, userID int) ([]model.FavoriteAdClient, error)
	CreateFavorite(ctx context.Context, fav model.FavoriteAdClient) error
	DeleteFavorite(ctx context.Context, fav model.FavoriteAdClient) error
	GetSeen(ctx context.Context, id int) (int, error)
	IncrementSeen(ctx context.Context, id int) error
}

type adClientService struct {
	adClientRepo        repository.IAdClient
	docRepo             repository.IDocument
	remoteRepo          client.DocumentsRemote
	repoLogs            repository.IAdminLogsRepository
	repoUsers           repository.IUser
	favoriteRepo        repository.IFavorite
	adSmClientElastic   elastic.IAdSpecializedMachineryClient
	subscriptionService ISubscription
}

func NewAdClientService(adClientRepo repository.IAdClient,
	docRepo repository.IDocument,
	remoteRepo client.DocumentsRemote,
	repoUsers repository.IUser,
	repoLogs repository.IAdminLogsRepository,
	favoriteRepo repository.IFavorite,
	adSmClientElastic elastic.IAdSpecializedMachineryClient,
	subscriptionService ISubscription) *adClientService {
	return &adClientService{
		adClientRepo:        adClientRepo,
		docRepo:             docRepo,
		remoteRepo:          remoteRepo,
		repoLogs:            repoLogs,
		repoUsers:           repoUsers,
		favoriteRepo:        favoriteRepo,
		adSmClientElastic:   adSmClientElastic,
		subscriptionService: subscriptionService,
	}
}

func (s *adClientService) Create(ctx context.Context, ad model.AdClient) error {
	ad.Status = model.STATUS_CREATED
	ad, err := s.adClientRepo.Create(ad)
	if err != nil {
		return err
	}

	author, err := s.repoUsers.GetByID(ad.UserID)
	if err != nil {
		return err
	}

	logs := model.Logs{
		Text:        "ad_client",
		Author:      fmt.Sprintf("%v %v %v", author.FirstName, author.LastName, author.PhoneNumber),
		Description: "создание объявлении клиента о работе",
	}

	for i := range ad.Documents {
		doc, err := s.remoteRepo.Upload(ctx, ad.Documents[i])
		if err != nil {
			return err
		}

		ad.Documents[i] = doc
	}

	err = s.repoLogs.CreateLogs(logs)
	if err != nil {
		return err
	}

	{
		adElastic, err := s.adClientRepo.GetByID(ad)
		if err != nil {
			return err
		}

		err = s.adSmClientElastic.Create(ctx, adElastic)
		if err != nil {
			return err
		}
		ad = adElastic
	}

	title := "У вас есть объявления"
	message := ad.Type.Name + " - " + ad.Headline + ". Нажмите чтобы посмотреть"
	err = s.subscriptionService.SendOutNoticeAdClientSM(ctx, ad.TypeID, message, title, ad.ID, ad.CityID)
	if err != nil {
		return err
	}

	return nil
}

func (s *adClientService) Update(ctx context.Context, ad model.AdClient) (err error) {
	//if err = s.adClientRepo.Update(ad); err != nil {
	//	return err
	//}

	author, err := s.repoUsers.GetByID(ad.UserID)
	if err != nil {
		return err
	}

	logs := model.Logs{
		Text:        "ad_client",
		Author:      fmt.Sprintf("%v %v %v", author.FirstName, author.LastName, author.PhoneNumber),
		Description: "обновление объявлении клиента о работе",
	}

	if err = s.adClientRepo.Update(ad); err != nil {
		return err
	}

	err = s.repoLogs.CreateLogs(logs)
	if err != nil {
		return err
	}

	err = s.adClientRepo.Update(ad)
	if err != nil {
		return err
	}

	return nil
	// s.adClientRepo.UpdateAdClientDocuments(m2m)
}

func (s *adClientService) GetByID(ctx context.Context, ad model.AdClient) (model.AdClient, error) {
	ad, err := s.adClientRepo.GetByID(ad)
	if err != nil {
		return ad, err
	}

	for i := range ad.Documents {
		doc, err := s.remoteRepo.Share(ctx, ad.Documents[i], time.Hour)
		if err != nil {
			return ad, err
		}

		ad.Documents[i] = doc
	}

	return ad, nil
}

func (s *adClientService) GetOwnerList(ctx context.Context, ad model.AdClient) (ads []model.AdClient, err error) {
	ads, err = s.adClientRepo.GetOwnerList(ad)
	if err != nil {
		return ads, err
	}

	for i := range ads {
		for j := range ads[i].Documents {
			doc, err := s.remoteRepo.Share(ctx, ads[i].Documents[j], time.Hour)
			if err != nil {
				return ads, err
			}

			ads[i].Documents[j] = doc
		}
	}

	return ads, nil
}

func (s *adClientService) GetList(ctx context.Context, filter model.FilterAdClient) ([]model.AdClient, int, error) {
	ads, total, err := s.adClientRepo.GetList(filter)
	if err != nil {
		return ads, total, err
	}

	for i := range ads {
		for j := range ads[i].Documents {
			doc, err := s.remoteRepo.Share(ctx, ads[i].Documents[j], time.Hour)
			if err != nil {
				return ads, total, err
			}

			ads[i].Documents[j] = doc
		}
	}

	//logrus.Info("Total: ", len(ads))
	//
	//for _, d := range ads {
	//	logrus.Info("AdConstructionMaterial: ", d.ID)
	//
	//	err := s.adSmClientElastic.Update(context.Background(), d)
	//	if err != nil {
	//		return nil, 0, err
	//	}
	//}

	return ads, total, nil
}

func (s *adClientService) Delete(ctx context.Context, ad model.AdClient) error {
	author, err := s.repoUsers.GetByID(ad.UserID)
	if err != nil {
		return err
	}

	logs := model.Logs{
		Text:        "ad_client",
		Author:      fmt.Sprintf("%v %v %v", author.FirstName, author.LastName, author.PhoneNumber),
		Description: "удаление объявлении клиента о работе",
	}

	ad.Status = model.STATUS_DELETED

	if err := s.adClientRepo.Update(ad); err != nil {
		return nil
	}

	if err = s.adClientRepo.Delete(ctx, ad); err != nil {
		return err
	}

	err = s.repoLogs.CreateLogs(logs)
	if err != nil {
		return err
	}

	err = s.adSmClientElastic.Delete(ctx, ad.ID)
	if err != nil {
		return err
	}

	return nil
}

func (s *adClientService) CreateInteracted(adClientID int, userID int) error {
	return s.adClientRepo.CreateInteracted(adClientID, userID)
}

func (s *adClientService) GetInteracted(id int) ([]model.AdClientInteracted, error) {
	list, err := s.adClientRepo.GetInteracted(id)
	if err != nil {
		return list, err
	}

	for i := range list {
		user, err := s.repoUsers.GetByID(list[i].UserID)
		if err != nil {
			return list, err
		}

		list[i].UserRating = user.Rating
	}

	return list, nil
}

func (s *adClientService) GetFavorite(ctx context.Context, userID int) ([]model.FavoriteAdClient, error) {
	fav, err := s.favoriteRepo.GetAdClientByUserID(ctx, userID)
	if err != nil {
		return nil, err
	}

	for _, fac := range fav {
		for j, d := range fac.AdClient.Documents {
			d, err := s.remoteRepo.Share(ctx, d, time.Duration(time.Hour))
			if err != nil {
				return nil, err
			}
			fac.AdClient.Documents[j] = d
		}
	}

	return fav, nil
}

func (s *adClientService) CreateFavorite(ctx context.Context, fav model.FavoriteAdClient) error {
	return s.favoriteRepo.CreateAdClient(ctx, fav)
}

func (s *adClientService) DeleteFavorite(ctx context.Context, fav model.FavoriteAdClient) error {
	return s.favoriteRepo.DeleteAdClient(ctx, fav)
}

func (service *adClientService) GetSeen(ctx context.Context, id int) (int, error) {
	res, err := service.adClientRepo.GetByIDSeen(ctx, id)
	if err != nil {
		if errors.Is(err, model.ErrNotFound) {
			err := service.adClientRepo.CreateSeen(ctx, id)
			if err != nil {
				return 0, fmt.Errorf("service adClientService: GetSeen: CreateSeen: %w", err)
			}
			return 0, nil
		}
		return 0, fmt.Errorf("service adClientService: GetSeen: %w", err)
	}

	return res, nil
}

func (service *adClientService) IncrementSeen(ctx context.Context, id int) error {
	_, err := service.adClientRepo.GetByIDSeen(ctx, id)
	if err != nil {
		if errors.Is(err, model.ErrNotFound) {
			err := service.adClientRepo.CreateSeen(ctx, id)
			if err != nil {
				return fmt.Errorf("service adClientService: IncrementSeen: CreateSeen: %w", err)
			}
			err = service.adClientRepo.IncrementSeen(ctx, id)
			if err != nil {
				return fmt.Errorf("service adClientService: IncrementSeen: IncrementSeen2: %w", err)
			}
			return nil
		}
		return fmt.Errorf("service adClientService: IncrementSeen: IncrementSeen2: %w", err)
	}

	err = service.adClientRepo.IncrementSeen(ctx, id)
	if err != nil {
		return fmt.Errorf("service adClientService: IncrementSeen: IncrementSeen: %w", err)
	}
	return nil
}
