package service

import (
	"context"
	"fmt"
	"github.com/sirupsen/logrus"
	"time"

	client2 "gitlab.com/eqshare/eqshare-back/internal/client"
	"gitlab.com/eqshare/eqshare-back/internal/elastic"
	"gitlab.com/eqshare/eqshare-back/internal/repository"
	"gitlab.com/eqshare/eqshare-back/model"
)

type IEquipmentSubCategory interface {
	GetAll(ctx context.Context) ([]model.EquipmentSubCategory, error)
	Get(ctx context.Context, f model.FilterEquipmentSubCategory) ([]model.EquipmentSubCategory, error)
	GetByID(ctx context.Context, id int) (model.EquipmentSubCategory, error)
	Create(ctx context.Context, ec model.EquipmentSubCategory) error
	Update(ctx context.Context, ec model.EquipmentSubCategory) error
	Delete(ctx context.Context, id int) error
	SetParamSubCategory(ctx context.Context, tps []model.EquipmentSubCategoriesParams) error
	DeleteParamSubCategory(ctx context.Context, tps model.EquipmentSubCategoriesParams) error
}

type equipmentSubCategory struct {
	equipmentSubCategoryRepo       repository.IEquipmentSubCategory
	equipmentSubCategoryParamsRepo repository.IEquipmentSubCategoryParams
	remotes                        client2.DocumentsRemote
	equipmentCategoryRepo          IEquipmentCategory
	elastic                        elastic.ICategoryEq
}

func NewEquipmentSubCategory(
	equipmentSubCategoryRepo repository.IEquipmentSubCategory,
	equipmentSubCategoryParamsRepo repository.IEquipmentSubCategoryParams,
	remotes client2.DocumentsRemote,
	equipmentCategoryRepo IEquipmentCategory,
	elastic elastic.ICategoryEq,
) IEquipmentSubCategory {
	return &equipmentSubCategory{
		equipmentSubCategoryRepo:       equipmentSubCategoryRepo,
		equipmentSubCategoryParamsRepo: equipmentSubCategoryParamsRepo,
		remotes:                        remotes,
		equipmentCategoryRepo:          equipmentCategoryRepo,
		elastic:                        elastic,
	}
}

func (service *equipmentSubCategory) GetAll(ctx context.Context) ([]model.EquipmentSubCategory, error) {
	res, err := service.equipmentSubCategoryRepo.GetList(ctx)
	if err != nil {
		return res, fmt.Errorf("service equipmentSubCategory: Get: %w", err)
	}

	//logrus.Info("Total: ", len(res))
	//
	//for _, d := range res {
	//	logrus.Info("AdConstructionMaterial: ", d.ID)
	//
	//	err := service.elastic.Update1(context.Background(), d)
	//	if err != nil {
	//		return nil, err
	//	}
	//}

	return res, nil
}

func (service *equipmentSubCategory) Get(ctx context.Context, f model.FilterEquipmentSubCategory) ([]model.EquipmentSubCategory, error) {
	res, err := service.equipmentSubCategoryRepo.Get(ctx, f)

	if err != nil {
		return res, fmt.Errorf("service equipmentSubCategory: Get: %w", err)
	}

	for i := range res {
		logrus.Info(res[i].Documents)
		res[i].UrlDocuments = make([]string, 0, len(res[i].Documents))
		for j := range res[i].Documents {
			res[i].Documents[j], err = service.remotes.Share(ctx, res[i].Documents[j], time.Hour*1)
			if err != nil {
				return nil, fmt.Errorf("service equipmentSubCategory: Get: Document: %w", err)
			}
			res[i].UrlDocuments = append(res[i].UrlDocuments, res[i].Documents[j].ShareLink)
		}
	}

	return res, nil
}

func (service *equipmentSubCategory) GetByID(ctx context.Context, id int) (model.EquipmentSubCategory, error) {
	res, err := service.equipmentSubCategoryRepo.GetByID(ctx, id)
	if err != nil {
		return res, fmt.Errorf("service equipmentSubCategory: GetByID: %w", err)
	}

	res.UrlDocuments = make([]string, 0, len(res.Documents))
	for j := range res.Documents {
		res.Documents[j], err = service.remotes.Share(ctx, res.Documents[j], time.Hour)
		if err != nil {
			return model.EquipmentSubCategory{}, fmt.Errorf("service equipmentSubCategory: Get: Document: %w", err)
		}
		res.UrlDocuments = append(res.UrlDocuments, res.Documents[j].ShareLink)
	}

	return res, nil
}

func (service *equipmentSubCategory) Create(ctx context.Context, ec model.EquipmentSubCategory) error {
	err := service.equipmentSubCategoryRepo.Create(ctx, ec)
	if err != nil {
		return fmt.Errorf("service equipmentSubCategory: Create: %w", err)
	}

	for _, d := range ec.Documents {
		_, err := service.remotes.Upload(ctx, d)
		if err != nil {
			return fmt.Errorf("service equipmentSubCategory: Create: Upload foto: %w", err)
		}
	}

	{
		ec, err := service.equipmentCategoryRepo.GetByID(ctx, ec.EquipmentCategoriesID)
		if err != nil {
			return fmt.Errorf("service equipmentSubCategory: %w", err)
		}

		err = service.elastic.Create(ctx, ec)
		if err != nil {
			return fmt.Errorf("service equipmentSubCategory: Elastic: %w", err)
		}
	}

	return nil
}

func (service *equipmentSubCategory) Update(ctx context.Context, ec model.EquipmentSubCategory) error {
	ecOld, err := service.GetByID(ctx, ec.ID)
	if err != nil {
		return fmt.Errorf("service equipmentSubCategory: GetOld: %w", err)
	}

	if ec.Name == "" {
		ec.Name = ecOld.Name
	}

	err = service.equipmentSubCategoryRepo.Update(ctx, ec)
	if err != nil {
		return fmt.Errorf("service equipmentSubCategory: Update: %w", err)
	}

	for _, d := range ec.Documents {
		_, err := service.remotes.Upload(ctx, d)
		if err != nil {
			return fmt.Errorf("service equipmentSubCategory: Upload Document: %w", err)
		}
	}

	{
		ec, err := service.equipmentCategoryRepo.GetByID(ctx, ec.EquipmentCategoriesID)
		if err != nil {
			return fmt.Errorf("service equipmentSubCategory: %w", err)
		}

		err = service.elastic.Update(ctx, ec)
		if err != nil {
			return fmt.Errorf("service equipmentSubCategory: Elastic: %w", err)
		}
	}

	return nil
}

func (service *equipmentSubCategory) Delete(ctx context.Context, id int) error {
	err := service.equipmentSubCategoryRepo.Delete(ctx, id)
	if err != nil {
		return fmt.Errorf("service equipmentSubCategory: Delete: %w", err)
	}

	{
		subec, err := service.equipmentSubCategoryRepo.GetByID(ctx, id)
		if err != nil {
			return fmt.Errorf("service equipmentSubCategory: Delete: GetByID: %w", err)
		}

		ec, err := service.equipmentCategoryRepo.GetByID(ctx, subec.EquipmentCategoriesID)
		if err != nil {
			return fmt.Errorf("service equipmentSubCategory: Delete: GetByID: %w", err)
		}

		err = service.elastic.Update(ctx, ec)
		if err != nil {
			return fmt.Errorf("service equipmentSubCategory: Delete: Elastic: %w", err)
		}
	}

	return nil
}

func (service *equipmentSubCategory) SetParamSubCategory(ctx context.Context, tps []model.EquipmentSubCategoriesParams) error {
	if len(tps) == 0 {
		return nil
	}

	err := service.equipmentSubCategoryParamsRepo.Set(ctx, tps)
	if err != nil {
		return fmt.Errorf("service equipmentSubCategory: SetParamSubCategory: %w", err)
	}

	return nil
}

func (service *equipmentSubCategory) DeleteParamSubCategory(ctx context.Context, tps model.EquipmentSubCategoriesParams) error {
	return nil
}

// if len(tps) == 0 {
// 	return nil
// }
// return tp.repoTypeParam.Set(ctx, tps)
// }

// func (tp *typeSM) DeleteParamSubCategory(ctx context.Context, tps model.TypesParams) error {
// return tp.repoTypeParam.Delete(ctx, tps)
