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

type IServiceCategory interface {
	Get(ctx context.Context, f model.FilterServiceCategory) ([]model.ServiceCategory, error)
	GetByID(ctx context.Context, id int) (model.ServiceCategory, error)
	Create(ctx context.Context, ec model.ServiceCategory) error
	Update(ctx context.Context, ec model.ServiceCategory) error
	Delete(ctx context.Context, id int) error
}

type serviceCategory struct {
	serviceCategoryRepo repository.IServiceCategory
	adServiceRepo       repository.IAdService
	adServiceClientRepo repository.IAdServiceClient
	remotes             client2.DocumentsRemote
	elastic             elastic.ICategorySvc
}

func NewServiceCategory(
	serviceCategoryRepo repository.IServiceCategory,
	adServiceRepo repository.IAdService,
	adServiceClientRepo repository.IAdServiceClient,
	remotes client2.DocumentsRemote,
	elastic elastic.ICategorySvc,
) IServiceCategory {
	return &serviceCategory{
		serviceCategoryRepo: serviceCategoryRepo,
		adServiceRepo:       adServiceRepo,
		adServiceClientRepo: adServiceClientRepo,
		remotes:             remotes,
		elastic:             elastic,
	}
}

func (service *serviceCategory) Get(ctx context.Context, f model.FilterServiceCategory) ([]model.ServiceCategory, error) {
	errCh := make(chan error, 3)
	categoryResultCh := make(chan []model.ServiceCategory, 1)
	adEqCategoryCountResultCh := make(chan map[int]int, 1)

	wg := sync.WaitGroup{}

	wg.Add(1)
	go func() {
		defer wg.Done()
		res, err := service.serviceCategoryRepo.Get(ctx, f)
		if err != nil {
			errCh <- fmt.Errorf("service serviceCategory: Get: %w", err)
			categoryResultCh <- nil
			return
		}
		categoryResultCh <- res
	}()

	wg.Add(1)
	go func() {
		defer wg.Done()
		res, err := service.adServiceRepo.GetCountBySubCategory(ctx)
		if err != nil {
			errCh <- fmt.Errorf("service serviceCategory: Get: %w", err)
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
				return nil, fmt.Errorf("service serviceCategory: Get: Document: %w", err)
			}
			res[i].UrlDocuments = append(res[i].UrlDocuments, d.ShareLink)
		}

		var sum int

		for j := range res[i].ServiceSubCategories {
			res[i].ServiceSubCategories[j].UrlDocuments = make([]string, 0, len(res[i].ServiceSubCategories[j].Documents))
			for _, d := range res[i].ServiceSubCategories[j].Documents {
				d, err := service.remotes.Share(ctx, d, time.Hour)
				if err != nil {
					return nil, fmt.Errorf("service serviceCategory: Get: ServiceSubCategories: Document: %w", err)
				}
				res[i].ServiceSubCategories[j].UrlDocuments = append(res[i].ServiceSubCategories[j].UrlDocuments, d.ShareLink)
			}

			count := adEqCount[res[i].ServiceSubCategories[j].ID]
			sum += count
			res[i].ServiceSubCategories[j].CountAd = &count
		}

		res[i].CountAd = &sum
	}

	//logrus.Info("Total: ", len(res))
	//
	//for _, d := range res {
	//	logrus.Info("AdConstructionMaterial: ", d.ID)
	//
	//	err := service.elastic.Update(context.Background(), d)
	//	if err != nil {
	//		return nil, err
	//	}
	//}

	return res, nil
}

func (service *serviceCategory) GetByID(ctx context.Context, id int) (model.ServiceCategory, error) {
	res, err := service.serviceCategoryRepo.GetByID(ctx, id)
	if err != nil {
		return res, fmt.Errorf("service serviceCategory: GetByID: %w", err)
	}

	res.UrlDocuments = make([]string, 0, len(res.Documents))

	for i := range res.Documents {
		res.Documents[i], err = service.remotes.Share(ctx, res.Documents[i], time.Hour)
		if err != nil {
			return res, fmt.Errorf("service serviceCategory: GetByID ShareDocument: %w", err)
		}
		res.UrlDocuments = append(res.UrlDocuments, res.Documents[i].ShareLink)
	}

	for i := range res.ServiceSubCategories {
		res.ServiceSubCategories[i].UrlDocuments = make([]string, 0, len(res.ServiceSubCategories[i].Documents))
		for j := range res.ServiceSubCategories[i].Documents {
			res.ServiceSubCategories[i].Documents[j], err = service.remotes.Share(ctx, res.ServiceSubCategories[i].Documents[j], time.Hour)
			if err != nil {
				return res, fmt.Errorf("service serviceCategory: GetByID ShareDocument: %w", err)
			}
			res.ServiceSubCategories[i].UrlDocuments = append(
				res.ServiceSubCategories[i].UrlDocuments,
				res.ServiceSubCategories[i].Documents[j].ShareLink)
		}
	}

	return res, nil
}

func (service *serviceCategory) Create(ctx context.Context, ec model.ServiceCategory) error {
	id, err := service.serviceCategoryRepo.Create(ctx, ec)
	if err != nil {
		return fmt.Errorf("service serviceCategory: Create: %w", err)
	}

	for _, d := range ec.Documents {
		_, err := service.remotes.Upload(ctx, d)
		if err != nil {
			return fmt.Errorf("service serviceCategory: Create: Upload foto: %w", err)
		}
	}

	{
		ec, err := service.serviceCategoryRepo.GetByID(ctx, id)
		if err != nil {
			return fmt.Errorf("service serviceCategory: GetByID: %w", err)
		}

		err = service.elastic.Create(ctx, ec)
		if err != nil {
			return fmt.Errorf("service serviceCategory: Elastic: %w", err)
		}
	}

	return nil
}

func (service *serviceCategory) Update(ctx context.Context, ec model.ServiceCategory) error {
	ecOld, err := service.GetByID(ctx, ec.ID)
	if err != nil {
		return fmt.Errorf("service serviceCategory: GetOld: %w", err)
	}

	if ec.Name == "" {
		ec.Name = ecOld.Name
	}

	err = service.serviceCategoryRepo.Update(ctx, ec)
	if err != nil {
		return fmt.Errorf("service serviceCategory: Update: %w", err)
	}

	for _, d := range ec.Documents {
		_, err := service.remotes.Upload(ctx, d)
		if err != nil {
			return fmt.Errorf("service serviceCategory: Upload Document: %w", err)
		}
	}

	err = service.elastic.Update(ctx, ec)
	if err != nil {
		return fmt.Errorf("service serviceCategory: Elastic: %w", err)
	}

	return nil
}

func (service *serviceCategory) Delete(ctx context.Context, id int) error {
	err := service.serviceCategoryRepo.Delete(ctx, id)
	if err != nil {
		return fmt.Errorf("service serviceCategory: Delete: %w", err)
	}

	err = service.elastic.Delete(ctx, id)
	if err != nil {
		return fmt.Errorf("service serviceCategory: Elastic: %w", err)
	}

	return nil
}
