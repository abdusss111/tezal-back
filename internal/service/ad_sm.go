package service

import (
	"context"
	"errors"
	"fmt"

	//"github.com/elastic/go-elasticsearch/v7"
	//"github.com/sirupsen/logrus"
	"time"

	"gitlab.com/eqshare/eqshare-back/pkg/util"

	client2 "gitlab.com/eqshare/eqshare-back/internal/client"
	"gitlab.com/eqshare/eqshare-back/internal/elastic"
	"gitlab.com/eqshare/eqshare-back/internal/repository"
	"gitlab.com/eqshare/eqshare-back/model"
)

type IAdSpecializedMachinery interface {
	Create(ctx context.Context, ad model.AdSpecializedMachinery) (int, error)
	Get(ctx context.Context, f model.FilterAdSpecializedMachinery) ([]model.AdSpecializedMachinery, int, error)
	GetByID(id int) (model.AdSpecializedMachinery, error)
	Update(ad model.AdSpecializedMachinery) error
	UpdateFoto(ad model.AdSpecializedMachinery) error
	Delete(id int) error
	Interacted(adID int, userID int) error
	GetInteracted(adID int) ([]model.AdSpecializedMachineryInteracted, error)
	SMRate(rate int, sb model.AdSpecializedMachinery) (err error)
	GetFavorite(ctx context.Context, userID int) ([]model.FavoriteAdSpecializedMachinery, error)
	CreateFavorite(ctx context.Context, fav model.FavoriteAdSpecializedMachinery) error
	DeleteFavorite(ctx context.Context, fav model.FavoriteAdSpecializedMachinery) error
	GetSeen(ctx context.Context, id int) (int, error)
	IncrementSeen(ctx context.Context, id int) error
}

type AdSpecializedMachinery struct {
	repo            repository.IAdSpecializedMachinery
	repoSMRequest   repository.ISpecializedMachineryRequest
	repoRequestExec repository.IRequestExecution
	docRepo         repository.IDocument
	repoUsers       repository.IUser
	repoLogs        repository.IAdminLogsRepository
	favoriteRepo    repository.IFavorite
	remotes         client2.DocumentsRemote
	elastic         elastic.IAdSpecializedMachinery
}

func NewAdSpecializedMachinery(repo repository.IAdSpecializedMachinery,
	docRepo repository.IDocument, remotes client2.DocumentsRemote,
	repoSMRequest repository.ISpecializedMachineryRequest,
	repoRequestExec repository.IRequestExecution,
	repoLogs repository.IAdminLogsRepository,
	repoUsers repository.IUser,
	favoriteRepo repository.IFavorite,
	elastic elastic.IAdSpecializedMachinery) *AdSpecializedMachinery {
	return &AdSpecializedMachinery{
		repo:            repo,
		docRepo:         docRepo,
		remotes:         remotes,
		repoSMRequest:   repoSMRequest,
		repoRequestExec: repoRequestExec,
		repoLogs:        repoLogs,
		repoUsers:       repoUsers,
		favoriteRepo:    favoriteRepo,
		elastic:         elastic,
	}
}

func (a *AdSpecializedMachinery) Create(ctx context.Context, ad model.AdSpecializedMachinery) (int, error) {
	id, err := a.repo.Create(ad)
	if err != nil {
		return 0, err
	}

	// doc := make([]*model.Document, 0, len(ad.Document))

	// for i := 0; i < len(ad.Document); i++ {
	// 	doc = append(doc, &ad.Document[i])
	// }

	// if err := a.docRepo.CreateMany(context.Background(), doc...); err != nil {
	// 	return 0, err
	// }

	// links := make([]model.AdSpecializedMachineriesDocuments, 0, len(ad.Document))

	author, err := a.repoUsers.GetByID(int(ad.UserID))
	if err != nil {
		return 0, err
	}

	logs := model.Logs{
		Text:        "ad_specialized_machinery",
		Author:      fmt.Sprintf("%v %v %v", author.FirstName, author.LastName, author.PhoneNumber),
		Description: "создание объявлении о спецтехнике",
	}

	for i, d := range ad.Document {
		// l := model.AdSpecializedMachineriesDocuments{}
		// l.DocumentID = d.ID
		// l.AdSpecializedMachinerieID = adID
		// links = append(links, l)
		_, err := a.remotes.Upload(ctx, ad.Document[i])
		if err != nil {
			return 0, fmt.Errorf("documne title \"%v\": %v", d.Title, err.Error())
		}
	}

	// if err := a.repo.CreateLinkDocument(links...); err != nil {
	// 	return 0, err
	// }

	err = a.repoLogs.CreateLogs(logs)
	if err != nil {
		return 0, err
	}

	ad, err = a.repo.GetByID(id)
	if err != nil {
		return 0, err
	}

	err = a.elastic.Create(ctx, ad)
	if err != nil {
		return 0, err
	}

	return id, nil
}

// Get does the main retrieval + adds ShareLink
func (a *AdSpecializedMachinery) Get(ctx context.Context, f model.FilterAdSpecializedMachinery) ([]model.AdSpecializedMachinery, int, error) {
	// fetch from repository
	adsms, total, err := a.repo.Get(ctx, f)
	if err != nil {
		return nil, total, err
	}

	// for each record, fill in share links if needed
	for i, asm := range adsms {
		adsms[i].UrlDocument = make([]string, 0, len(asm.Document))
		adsms[i].ThumbnailDocument = make([]string, 0, len(asm.Document))

		for _, d := range asm.Document {
			t, err := a.remotes.Share(ctx, d, time.Hour)
			if err != nil {
				return adsms, total, err
			}
			adsms[i].UrlDocument = append(adsms[i].UrlDocument, t.ShareLink)
			adsms[i].ThumbnailDocument = append(adsms[i].ThumbnailDocument, t.ThumbnailLink)
		}
	}

	return adsms, total, nil
}

func (a *AdSpecializedMachinery) GetByID(id int) (model.AdSpecializedMachinery, error) {
	adsm, err := a.repo.GetByID(id)
	if err != nil {
		return model.AdSpecializedMachinery{}, err
	}

	adsm.UrlDocument = make([]string, 0, len(adsm.Document))
	adsm.ThumbnailDocument = make([]string, 0, len(adsm.Document))

	for _, d := range adsm.Document {
		t, err := a.remotes.Share(context.Background(), d, time.Hour*1)
		if err != nil {
			return model.AdSpecializedMachinery{}, err
		}

		adsm.UrlDocument = append(adsm.UrlDocument, t.ShareLink)
		adsm.ThumbnailDocument = append(adsm.ThumbnailDocument, t.ThumbnailLink)
	}

	return adsm, nil
}

func (a *AdSpecializedMachinery) Update(ad model.AdSpecializedMachinery) error {
	adOld, err := a.repo.GetByID(ad.ID)
	if err != nil {
		return err
	}

	author, err := a.repoUsers.GetByID(int(ad.UserID))
	if err != nil {
		return err
	}

	logs := model.Logs{
		Text:        "ad_specialized_machinery",
		Author:      fmt.Sprintf("%v %v %v", author.FirstName, author.LastName, author.PhoneNumber),
		Description: "обновление объявлении о спецтехнике",
	}

	if adOld.UserID != ad.UserID {
		return model.ErrAccessDenied
	}

	if err = a.repo.Update(ad); err != nil {
		return err
	}

	err = a.repoLogs.CreateLogs(logs)
	if err != nil {
		return err
	}

	err = a.elastic.Update(context.Background(), ad)
	if err != nil {
		return err
	}

	return nil
}

func (a *AdSpecializedMachinery) UpdateFoto(ad model.AdSpecializedMachinery) error {
	adOld, err := a.repo.GetByID(ad.ID)
	if err != nil {
		return err
	}

	if adOld.UserID != ad.UserID {
		return model.ErrAccessDenied
	}

	ids := make([]int, 0, len(adOld.Document))

	for _, d := range adOld.Document {
		ids = append(ids, d.ID)

		_, err := a.remotes.Delete(context.Background(), d)
		if err != nil {
			return err
		}
	}

	if err := a.docRepo.DeleteUnscoped(ids...); err != nil {
		return err
	}

	adOld.Document = ad.Document

	if err := a.repo.UpdateFoto(adOld); err != nil {
		return err
	}

	for i := range ad.Document {
		_, err := a.remotes.Upload(context.Background(), ad.Document[i])
		if err != nil {
			return err
		}
	}

	return nil
}

func (a *AdSpecializedMachinery) Delete(id int) error {
	err := a.repo.Delete(id)
	if err != nil {
		return err
	}

	err = a.elastic.Delete(context.Background(), id)
	if err != nil {
		return err
	}

	return nil
}

func (a *AdSpecializedMachinery) Interacted(adID int, userID int) error {
	return a.repo.Interacted(adID, userID)
}

func (a *AdSpecializedMachinery) GetInteracted(adID int) ([]model.AdSpecializedMachineryInteracted, error) {
	return a.repo.GetInteracted(adID)
}

func (a *AdSpecializedMachinery) SMRate(rate int, sm model.AdSpecializedMachinery) error {
	reqExec, err := a.repoRequestExec.GetByID(sm.ID)
	if err != nil {
		return nil
	}

	reqExec.Rate = &rate

	smRequest, err := a.repoSMRequest.GetByID(reqExec.SpecializedMachineryRequest.ID)
	if err != nil {
		return err
	}

	driver, err := a.repoUsers.GetByID(smRequest.UserID)
	if err != nil {
		return err
	}

	sm, err = a.repo.GetByID(smRequest.AdSpecializedMachineryID)
	if err != nil {
		return err
	}

	sm.Rating, sm.CountRate = util.RateCalculation(sm.Rating, sm.CountRate, rate)
	driver.Rating, driver.CountRate = util.RateCalculation(driver.Rating, driver.CountRate, rate)

	if err = a.repoRequestExec.Update(reqExec); err != nil {
		return err
	}

	if err = a.repoUsers.Update(driver); err != nil {
		return err
	}

	return a.repo.Update(sm)
}

func (a *AdSpecializedMachinery) GetFavorite(ctx context.Context, userID int) ([]model.FavoriteAdSpecializedMachinery, error) {
	favorites, err := a.favoriteRepo.GetAdSpecializedMachineryByUserID(userID)
	if err != nil {
		return nil, err
	}

	for i, f := range favorites {
		favorites[i].AdSpecializedMachinery.UrlDocument = make([]string, 0, len(f.AdSpecializedMachinery.Document))

		for _, d := range f.AdSpecializedMachinery.Document {
			d, err = a.remotes.Share(ctx, d, time.Duration(time.Hour))
			if err != nil {
				return nil, err
			}
			favorites[i].AdSpecializedMachinery.UrlDocument = append(favorites[i].AdSpecializedMachinery.UrlDocument, d.ShareLink)
		}
	}

	return favorites, nil
}

func (a *AdSpecializedMachinery) CreateFavorite(ctx context.Context, fav model.FavoriteAdSpecializedMachinery) error {
	return a.favoriteRepo.CreateAdSpecializedMachinery(ctx, fav)
}
func (a *AdSpecializedMachinery) DeleteFavorite(ctx context.Context, fav model.FavoriteAdSpecializedMachinery) error {
	return a.favoriteRepo.DeleteAdSpecializedMachinery(ctx, fav)
}

func (service *AdSpecializedMachinery) GetSeen(ctx context.Context, id int) (int, error) {
	res, err := service.repo.GetByIDSeen(ctx, id)
	if err != nil {
		if errors.Is(err, model.ErrNotFound) {
			err := service.repo.CreateSeen(ctx, id)
			if err != nil {
				return 0, fmt.Errorf("service adSpecializedMachinery: GetSeen: CreateSeen: %w", err)
			}
			return 0, nil
		}
		return 0, fmt.Errorf("service adSpecializedMachinery: GetSeen: %w", err)
	}

	return res, nil
}

func (service *AdSpecializedMachinery) IncrementSeen(ctx context.Context, id int) error {
	_, err := service.repo.GetByIDSeen(ctx, id)
	if err != nil {
		if errors.Is(err, model.ErrNotFound) {
			err := service.repo.CreateSeen(ctx, id)
			if err != nil {
				return fmt.Errorf("service adSpecializedMachinery: IncrementSeen: CreateSeen: %w", err)
			}
			err = service.repo.IncrementSeen(ctx, id)
			if err != nil {
				return fmt.Errorf("service adSpecializedMachinery: IncrementSeen: IncrementSeen2: %w", err)
			}
			return nil
		}
		return fmt.Errorf("service adSpecializedMachinery: IncrementSeen: IncrementSeen2: %w", err)
	}

	err = service.repo.IncrementSeen(ctx, id)
	if err != nil {
		return fmt.Errorf("service adSpecializedMachinery: IncrementSeen: IncrementSeen: %w", err)
	}
	return nil
}
