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

type IConstructionMaterialSubCategory interface {
	Get(ctx context.Context, f model.FilterConstructionMaterialSubCategory) ([]model.ConstructionMaterialSubCategory, error)
	GetByID(ctx context.Context, id int) (model.ConstructionMaterialSubCategory, error)
	Create(ctx context.Context, ec model.ConstructionMaterialSubCategory) error
	Update(ctx context.Context, ec model.ConstructionMaterialSubCategory) error
	Delete(ctx context.Context, id int) error
	SetParamSubCategory(ctx context.Context, tps []model.ConstructionMaterialSubCategoriesParams) error
	DeleteParamSubCategory(ctx context.Context, tps model.ConstructionMaterialSubCategoriesParams) error
}

type constructionMaterialSubCategory struct {
	constructionMaterialSubCategoryRepo       repository.IConstructionMaterialSubCategory
	constructionMaterialSubCategoryParamsRepo repository.IConstructionMaterialSubCategoryParams
	remotes                                   client2.DocumentsRemote
	constructionMaterialCategoryRepo          IConstructionMaterialCategory
	elastic                                   elastic.ICategoryCm
}

func NewConstructionMaterialSubCategory(
	constructionMaterialSubCategoryRepo repository.IConstructionMaterialSubCategory,
	constructionMaterialSubCategoryParamsRepo repository.IConstructionMaterialSubCategoryParams,
	remotes client2.DocumentsRemote,
	constructionMaterialCategoryRepo IConstructionMaterialCategory,
	elastic elastic.ICategoryCm,
) IConstructionMaterialSubCategory {
	return &constructionMaterialSubCategory{
		constructionMaterialSubCategoryRepo:       constructionMaterialSubCategoryRepo,
		constructionMaterialSubCategoryParamsRepo: constructionMaterialSubCategoryParamsRepo,
		remotes:                          remotes,
		constructionMaterialCategoryRepo: constructionMaterialCategoryRepo,
		elastic:                          elastic,
	}
}

func (service *constructionMaterialSubCategory) Get(ctx context.Context, f model.FilterConstructionMaterialSubCategory) ([]model.ConstructionMaterialSubCategory, error) {
	res, err := service.constructionMaterialSubCategoryRepo.Get(ctx, f)
	if err != nil {
		return res, fmt.Errorf("service constructionMaterialSubCategory: Get: %w", err)
	}

	for i := range res {
		res[i].UrlDocuments = make([]string, 0, len(res[i].Documents))
		for j := range res[i].Documents {
			res[i].Documents[j], err = service.remotes.Share(ctx, res[i].Documents[j], time.Hour*1)
			if err != nil {
				return nil, fmt.Errorf("service constructionMaterialSubCategory: Get: Document: %w", err)
			}
			res[i].UrlDocuments = append(res[i].UrlDocuments, res[i].Documents[j].ShareLink)
		}
	}

	return res, nil
}

func (service *constructionMaterialSubCategory) GetByID(ctx context.Context, id int) (model.ConstructionMaterialSubCategory, error) {
	res, err := service.constructionMaterialSubCategoryRepo.GetByID(ctx, id)
	if err != nil {
		return res, fmt.Errorf("service constructionMaterialSubCategory: GetByID: %w", err)
	}

	res.UrlDocuments = make([]string, 0, len(res.Documents))
	for j := range res.Documents {
		res.Documents[j], err = service.remotes.Share(ctx, res.Documents[j], time.Hour)
		if err != nil {
			return model.ConstructionMaterialSubCategory{}, fmt.Errorf("service constructionMaterialSubCategory: Get: Document: %w", err)
		}
		res.UrlDocuments = append(res.UrlDocuments, res.Documents[j].ShareLink)
	}

	return res, nil
}

func (service *constructionMaterialSubCategory) Create(ctx context.Context, ec model.ConstructionMaterialSubCategory) error {
	err := service.constructionMaterialSubCategoryRepo.Create(ctx, ec)
	if err != nil {
		return fmt.Errorf("service constructionMaterialSubCategory: Create: %w", err)
	}

	for _, d := range ec.Documents {
		_, err := service.remotes.Upload(ctx, d)
		if err != nil {
			return fmt.Errorf("service constructionMaterialSubCategory: Create: Upload foto: %w", err)
		}
	}

	{
		ec, err := service.constructionMaterialCategoryRepo.GetByID(ctx, ec.ConstructionMaterialCategoriesID)
		if err != nil {
			return fmt.Errorf("service constructionMaterialSubCategory: %w", err)
		}

		err = service.elastic.Create(ctx, ec)
		if err != nil {
			return fmt.Errorf("service constructionMaterialSubCategory: Elastic: %w", err)
		}
	}

	return nil
}

func (service *constructionMaterialSubCategory) Update(ctx context.Context, ec model.ConstructionMaterialSubCategory) error {
	ecOld, err := service.GetByID(ctx, ec.ID)
	if err != nil {
		return fmt.Errorf("service constructionMaterialSubCategory: GetOld: %w", err)
	}

	if ec.Name == "" {
		ec.Name = ecOld.Name
	}

	err = service.constructionMaterialSubCategoryRepo.Update(ctx, ec)
	if err != nil {
		return fmt.Errorf("service constructionMaterialSubCategory: Update: %w", err)
	}

	for _, d := range ec.Documents {
		_, err := service.remotes.Upload(ctx, d)
		if err != nil {
			return fmt.Errorf("service constructionMaterialSubCategory: Upload Document: %w", err)
		}
	}

	{
		ec, err := service.constructionMaterialCategoryRepo.GetByID(ctx, ec.ConstructionMaterialCategoriesID)
		if err != nil {
			return fmt.Errorf("service constructionMaterialSubCategory: %w", err)
		}

		err = service.elastic.Update(ctx, ec)
		if err != nil {
			return fmt.Errorf("service constructionMaterialSubCategory: Elastic: %w", err)
		}
	}

	return nil
}

func (service *constructionMaterialSubCategory) Delete(ctx context.Context, id int) error {
	err := service.constructionMaterialSubCategoryRepo.Delete(ctx, id)
	if err != nil {
		return fmt.Errorf("service constructionMaterialSubCategory: Delete: %w", err)
	}

	{
		subCat, err := service.constructionMaterialSubCategoryRepo.GetByID(ctx, id)
		if err != nil {
			return fmt.Errorf("service constructionMaterialSubCategory: Delete: GetByID: %w", err)
		}

		ec, err := service.constructionMaterialCategoryRepo.GetByID(ctx, subCat.ConstructionMaterialCategoriesID)
		if err != nil {
			return fmt.Errorf("service constructionMaterialSubCategory: Delete: GetByID: %w", err)
		}

		err = service.elastic.Update(ctx, ec)
		if err != nil {
			return fmt.Errorf("service constructionMaterialSubCategory: Delete: Elastic: %w", err)
		}
	}

	return nil
}

func (service *constructionMaterialSubCategory) SetParamSubCategory(ctx context.Context, tps []model.ConstructionMaterialSubCategoriesParams) error {
	if len(tps) == 0 {
		return nil
	}

	err := service.constructionMaterialSubCategoryParamsRepo.Set(ctx, tps)
	if err != nil {
		return fmt.Errorf("service constructionMaterialSubCategory: SetParamSubCategory: %w", err)
	}

	return nil
}

func (service *constructionMaterialSubCategory) DeleteParamSubCategory(ctx context.Context, tps model.ConstructionMaterialSubCategoriesParams) error {
	return nil
}

// if len(tps) == 0 {
// 	return nil
// }
// return tp.repoTypeParam.Set(ctx, tps)
// }

// func (tp *typeSM) DeleteParamSubCategory(ctx context.Context, tps model.TypesParams) error {
// return tp.repoTypeParam.Delete(ctx, tps)
