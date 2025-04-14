package service

import (
	"context"
	"fmt"
	"time"

	client2 "gitlab.com/eqshare/eqshare-back/internal/client"
	"gitlab.com/eqshare/eqshare-back/internal/elastic"
	"gitlab.com/eqshare/eqshare-back/internal/repository"
	"gitlab.com/eqshare/eqshare-back/model"
)

type IServiceSubCategory interface {
	Get(ctx context.Context, f model.FilterServiceSubCategory) ([]model.ServiceSubCategory, error)
	GetByID(ctx context.Context, id int) (model.ServiceSubCategory, error)
	Create(ctx context.Context, ec model.ServiceSubCategory) error
	Update(ctx context.Context, ec model.ServiceSubCategory) error
	Delete(ctx context.Context, id int) error
	SetParamSubCategory(ctx context.Context, tps []model.ServiceSubCategoriesParams) error
	DeleteParamSubCategory(ctx context.Context, tps model.ServiceSubCategoriesParams) error
}

type serviceSubCategory struct {
	serviceSubCategoryRepo       repository.IServiceSubCategory
	serviceSubCategoryParamsRepo repository.IServiceSubCategoryParams
	remotes                      client2.DocumentsRemote
	serviceCategoryRepo          IServiceCategory
	elastic                      elastic.ICategorySvc
}

func NewServiceSubCategory(
	serviceSubCategoryRepo repository.IServiceSubCategory,
	serviceSubCategoryParamsRepo repository.IServiceSubCategoryParams,
	remotes client2.DocumentsRemote,
	serviceCategoryRepo IServiceCategory,
	elastic elastic.ICategorySvc,
) IServiceSubCategory {
	return &serviceSubCategory{
		serviceSubCategoryRepo:       serviceSubCategoryRepo,
		serviceSubCategoryParamsRepo: serviceSubCategoryParamsRepo,
		remotes:                      remotes,
		serviceCategoryRepo:          serviceCategoryRepo,
		elastic:                      elastic,
	}
}

func (service *serviceSubCategory) Get(ctx context.Context, f model.FilterServiceSubCategory) ([]model.ServiceSubCategory, error) {
	res, err := service.serviceSubCategoryRepo.Get(ctx, f)
	if err != nil {
		return res, fmt.Errorf("service serviceSubCategory: Get: %w", err)
	}

	for i := range res {
		res[i].UrlDocuments = make([]string, 0, len(res[i].Documents))
		for j := range res[i].Documents {
			res[i].Documents[j], err = service.remotes.Share(ctx, res[i].Documents[j], time.Hour*1)
			if err != nil {
				return nil, fmt.Errorf("service serviceSubCategory: Get: Document: %w", err)
			}
			res[i].UrlDocuments = append(res[i].UrlDocuments, res[i].Documents[j].ShareLink)
		}
	}

	return res, nil
}

func (service *serviceSubCategory) GetByID(ctx context.Context, id int) (model.ServiceSubCategory, error) {
	res, err := service.serviceSubCategoryRepo.GetByID(ctx, id)
	if err != nil {
		return res, fmt.Errorf("service serviceSubCategory: GetByID: %w", err)
	}

	res.UrlDocuments = make([]string, 0, len(res.Documents))
	for j := range res.Documents {
		res.Documents[j], err = service.remotes.Share(ctx, res.Documents[j], time.Hour)
		if err != nil {
			return model.ServiceSubCategory{}, fmt.Errorf("service serviceSubCategory: Get: Document: %w", err)
		}
		res.UrlDocuments = append(res.UrlDocuments, res.Documents[j].ShareLink)
	}

	return res, nil
}

func (service *serviceSubCategory) Create(ctx context.Context, ec model.ServiceSubCategory) error {
	err := service.serviceSubCategoryRepo.Create(ctx, ec)
	if err != nil {
		return fmt.Errorf("service serviceSubCategory: Create: %w", err)
	}

	for _, d := range ec.Documents {
		_, err := service.remotes.Upload(ctx, d)
		if err != nil {
			return fmt.Errorf("service serviceSubCategory: Create: Upload foto: %w", err)
		}
	}

	{
		ec, err := service.serviceCategoryRepo.GetByID(ctx, ec.ServiceCategoriesID)
		if err != nil {
			return fmt.Errorf("service serviceSubCategory: %w", err)
		}

		err = service.elastic.Create(ctx, ec)
		if err != nil {
			return fmt.Errorf("service serviceSubCategory: Elastic: %w", err)
		}
	}

	return nil
}

func (service *serviceSubCategory) Update(ctx context.Context, ec model.ServiceSubCategory) error {
	ecOld, err := service.GetByID(ctx, ec.ID)
	if err != nil {
		return fmt.Errorf("service serviceSubCategory: GetOld: %w", err)
	}

	if ec.Name == "" {
		ec.Name = ecOld.Name
	}

	err = service.serviceSubCategoryRepo.Update(ctx, ec)
	if err != nil {
		return fmt.Errorf("service serviceSubCategory: Update: %w", err)
	}

	for _, d := range ec.Documents {
		_, err := service.remotes.Upload(ctx, d)
		if err != nil {
			return fmt.Errorf("service serviceSubCategory: Upload Document: %w", err)
		}
	}

	{
		ec, err := service.serviceCategoryRepo.GetByID(ctx, ec.ServiceCategoriesID)
		if err != nil {
			return fmt.Errorf("service serviceSubCategory: %w", err)
		}

		err = service.elastic.Update(ctx, ec)
		if err != nil {
			return fmt.Errorf("service serviceSubCategory: Elastic: %w", err)
		}
	}

	return nil
}

func (service *serviceSubCategory) Delete(ctx context.Context, id int) error {
	err := service.serviceSubCategoryRepo.Delete(ctx, id)
	if err != nil {
		return fmt.Errorf("service serviceSubCategory: Delete: %w", err)
	}

	{
		subCat, err := service.serviceSubCategoryRepo.GetByID(ctx, id)
		if err != nil {
			return fmt.Errorf("service serviceSubCategory: Delete: GetByID: %w", err)
		}

		ec, err := service.serviceCategoryRepo.GetByID(ctx, subCat.ServiceCategoriesID)
		if err != nil {
			return fmt.Errorf("service serviceSubCategory: Delete: GetByID: %w", err)
		}

		err = service.elastic.Update(ctx, ec)
		if err != nil {
			return fmt.Errorf("service serviceSubCategory: Delete: Elastic: %w", err)
		}
	}

	return nil
}

func (service *serviceSubCategory) SetParamSubCategory(ctx context.Context, tps []model.ServiceSubCategoriesParams) error {
	if len(tps) == 0 {
		return nil
	}

	err := service.serviceSubCategoryParamsRepo.Set(ctx, tps)
	if err != nil {
		return fmt.Errorf("service serviceSubCategory: SetParamSubCategory: %w", err)
	}

	return nil
}

func (service *serviceSubCategory) DeleteParamSubCategory(ctx context.Context, tps model.ServiceSubCategoriesParams) error {
	return nil
}

// if len(tps) == 0 {
// 	return nil
// }
// return tp.repoTypeParam.Set(ctx, tps)
// }

// func (tp *typeSM) DeleteParamSubCategory(ctx context.Context, tps model.TypesParams) error {
// return tp.repoTypeParam.Delete(ctx, tps)
