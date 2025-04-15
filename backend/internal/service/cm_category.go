package service

import (
	"context"
	"fmt"
	"sync"
	"time"

	client2 "gitlab.com/eqshare/eqshare-back/internal/client"
	"gitlab.com/eqshare/eqshare-back/internal/elastic"
	"gitlab.com/eqshare/eqshare-back/internal/repository"
	"gitlab.com/eqshare/eqshare-back/model"
)

type IConstructionMaterialCategory interface {
	Get(ctx context.Context, f model.FilterConstructionMaterialCategory) ([]model.ConstructionMaterialCategory, error)
	GetByID(ctx context.Context, id int) (model.ConstructionMaterialCategory, error)
	Create(ctx context.Context, ec model.ConstructionMaterialCategory) error
	Update(ctx context.Context, ec model.ConstructionMaterialCategory) error
	Delete(ctx context.Context, id int) error
}

type constructionMaterialCategory struct {
	constructionMaterialCategoryRepo repository.IConstructionMaterialCategory
	adConstructionMaterialRepo       repository.IAdConstructionMaterials
	adConstructionMaterialClientRepo repository.IAdConstructionMaterialClient
	remotes                          client2.DocumentsRemote
	elastic                          elastic.ICategoryCm
}

func NewConstructionMaterialCategory(
	constructionMaterialCategoryRepo repository.IConstructionMaterialCategory,
	adConstructionMaterialRepo repository.IAdConstructionMaterials,
	adConstructionMaterialClientRepo repository.IAdConstructionMaterialClient,
	remotes client2.DocumentsRemote,
	elastic elastic.ICategoryCm,
) IConstructionMaterialCategory {
	return &constructionMaterialCategory{
		constructionMaterialCategoryRepo: constructionMaterialCategoryRepo,
		adConstructionMaterialRepo:       adConstructionMaterialRepo,
		adConstructionMaterialClientRepo: adConstructionMaterialClientRepo,
		remotes:                          remotes,
		elastic:                          elastic,
	}
}

func (service *constructionMaterialCategory) Get(ctx context.Context, f model.FilterConstructionMaterialCategory) ([]model.ConstructionMaterialCategory, error) {
	errCh := make(chan error, 3)
	categoryResultCh := make(chan []model.ConstructionMaterialCategory, 1)
	adEqCategoryCountResultCh := make(chan map[int]int, 1)

	wg := sync.WaitGroup{}

	wg.Add(1)
	go func() {
		defer wg.Done()
		res, err := service.constructionMaterialCategoryRepo.Get(ctx, f)
		if err != nil {
			errCh <- fmt.Errorf("service constructionMaterialCategory: Get: %w", err)
			categoryResultCh <- nil
			return
		}
		categoryResultCh <- res
	}()

	wg.Add(1)
	go func() {
		defer wg.Done()
		res, err := service.adConstructionMaterialRepo.GetCountBySubCategory(ctx)
		if err != nil {
			errCh <- fmt.Errorf("service constructionMaterialCategory: Get: %w", err)
			adEqCategoryCountResultCh <- nil
			return
		}
		adEqCategoryCountResultCh <- res
	}()

	wg.Wait()
	close(errCh)
	close(categoryResultCh)
	close(adEqCategoryCountResultCh)

	for err := range errCh {
		return nil, err
	}

	res := <-categoryResultCh
	adEqCount := <-adEqCategoryCountResultCh

	for i := range res {
		res[i].UrlDocuments = make([]string, 0, len(res[i].Documents))
		for _, d := range res[i].Documents {
			d, err := service.remotes.Share(ctx, d, time.Hour)
			if err != nil {
				return nil, fmt.Errorf("service constructionMaterialCategory: Get: Document: %w", err)
			}
			res[i].UrlDocuments = append(res[i].UrlDocuments, d.ShareLink)
		}

		var sum int

		for j := range res[i].ConstructionMaterialSubCategories {
			res[i].ConstructionMaterialSubCategories[j].UrlDocuments = make([]string, 0, len(res[i].ConstructionMaterialSubCategories[j].Documents))
			for _, d := range res[i].ConstructionMaterialSubCategories[j].Documents {
				d, err := service.remotes.Share(ctx, d, time.Hour)
				if err != nil {
					return nil, fmt.Errorf("service constructionMaterialCategory: Get: ConstructionMaterialSubCategories: Document: %w", err)
				}
				res[i].ConstructionMaterialSubCategories[j].UrlDocuments = append(res[i].ConstructionMaterialSubCategories[j].UrlDocuments, d.ShareLink)
			}

			count := adEqCount[res[i].ConstructionMaterialSubCategories[j].ID]
			sum += count
			res[i].ConstructionMaterialSubCategories[j].CountAd = &count
		}

		res[i].CountAd = &sum
	}

	//logrus.Info("Total: ", len(res))
	//
	//for _, d := range res {
	//	logrus.Info("AdConstructionMaterial: ", d.ID)
	//	err := service.elastic.Update(context.Background(), d)
	//	if err != nil {
	//		return nil, err
	//	}
	//}

	return res, nil
}

func (service *constructionMaterialCategory) GetByID(ctx context.Context, id int) (model.ConstructionMaterialCategory, error) {
	res, err := service.constructionMaterialCategoryRepo.GetByID(ctx, id)
	if err != nil {
		return res, fmt.Errorf("service constructionMaterialCategory: GetByID: %w", err)
	}

	res.UrlDocuments = make([]string, 0, len(res.Documents))

	for i := range res.Documents {
		res.Documents[i], err = service.remotes.Share(ctx, res.Documents[i], time.Hour)
		if err != nil {
			return res, fmt.Errorf("service constructionMaterialCategory: GetByID ShareDocument: %w", err)
		}
		res.UrlDocuments = append(res.UrlDocuments, res.Documents[i].ShareLink)
	}

	for i := range res.ConstructionMaterialSubCategories {
		res.ConstructionMaterialSubCategories[i].UrlDocuments = make([]string, 0, len(res.ConstructionMaterialSubCategories[i].Documents))
		for j := range res.ConstructionMaterialSubCategories[i].Documents {
			res.ConstructionMaterialSubCategories[i].Documents[j], err = service.remotes.Share(ctx, res.ConstructionMaterialSubCategories[i].Documents[j], time.Hour)
			if err != nil {
				return res, fmt.Errorf("service constructionMaterialCategory: GetByID ShareDocument: %w", err)
			}
			res.ConstructionMaterialSubCategories[i].UrlDocuments = append(
				res.ConstructionMaterialSubCategories[i].UrlDocuments,
				res.ConstructionMaterialSubCategories[i].Documents[j].ShareLink)
		}
	}

	return res, nil
}

func (service *constructionMaterialCategory) Create(ctx context.Context, ec model.ConstructionMaterialCategory) error {
	id, err := service.constructionMaterialCategoryRepo.Create(ctx, ec)
	if err != nil {
		return fmt.Errorf("service constructionMaterialCategory: Create: %w", err)
	}

	for _, d := range ec.Documents {
		_, err := service.remotes.Upload(ctx, d)
		if err != nil {
			return fmt.Errorf("service constructionMaterialCategory: Create: Upload foto: %w", err)
		}
	}

	{
		ec, err := service.constructionMaterialCategoryRepo.GetByID(ctx, id)
		if err != nil {
			return fmt.Errorf("service constructionMaterialCategory: GetByID: %w", err)
		}

		err = service.elastic.Create(ctx, ec)
		if err != nil {
			return fmt.Errorf("service constructionMaterialCategory: Elastic: %w", err)
		}
	}

	return nil
}

func (service *constructionMaterialCategory) Update(ctx context.Context, ec model.ConstructionMaterialCategory) error {
	ecOld, err := service.GetByID(ctx, ec.ID)
	if err != nil {
		return fmt.Errorf("service constructionMaterialCategory: GetOld: %w", err)
	}

	if ec.Name == "" {
		ec.Name = ecOld.Name
	}

	err = service.constructionMaterialCategoryRepo.Update(ctx, ec)
	if err != nil {
		return fmt.Errorf("service constructionMaterialCategory: Update: %w", err)
	}

	for _, d := range ec.Documents {
		_, err := service.remotes.Upload(ctx, d)
		if err != nil {
			return fmt.Errorf("service constructionMaterialCategory: Upload Document: %w", err)
		}
	}

	err = service.elastic.Update(ctx, ec)
	if err != nil {
		return fmt.Errorf("service constructionMaterialCategory: Elastic: %w", err)
	}

	return nil
}

func (service *constructionMaterialCategory) Delete(ctx context.Context, id int) error {
	err := service.constructionMaterialCategoryRepo.Delete(ctx, id)
	if err != nil {
		return fmt.Errorf("service constructionMaterialCategory: Delete: %w", err)
	}

	err = service.elastic.Delete(ctx, id)
	if err != nil {
		return fmt.Errorf("service constructionMaterialCategory: Elastic: %w", err)
	}

	return nil
}
