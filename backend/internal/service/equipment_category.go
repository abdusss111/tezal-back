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

type IEquipmentCategory interface {
	Get(ctx context.Context, f model.FilterEquipmentCategory) ([]model.EquipmentCategory, error)
	GetByID(ctx context.Context, id int) (model.EquipmentCategory, error)
	Create(ctx context.Context, ec model.EquipmentCategory) error
	Update(ctx context.Context, ec model.EquipmentCategory) error
	Delete(ctx context.Context, id int) error
}

type equipmentCategory struct {
	equipmentCategoryRepo repository.IEquipmentCategory
	adEquipmentRepo       repository.IAdEquipment
	adEquipmentClientRepo repository.IAdEquipmentClient
	remotes               client2.DocumentsRemote
	elastic               elastic.ICategoryEq
}

func NewEquipmentCategory(
	equipmentCategoryRepo repository.IEquipmentCategory,
	adEquipmentRepo repository.IAdEquipment,
	adEquipmentClientRepo repository.IAdEquipmentClient,
	remotes client2.DocumentsRemote,
	elastic elastic.ICategoryEq,
) IEquipmentCategory {
	return &equipmentCategory{
		equipmentCategoryRepo: equipmentCategoryRepo,
		adEquipmentRepo:       adEquipmentRepo,
		adEquipmentClientRepo: adEquipmentClientRepo,
		remotes:               remotes,
		elastic:               elastic,
	}
}

func (service *equipmentCategory) Get(ctx context.Context, f model.FilterEquipmentCategory) ([]model.EquipmentCategory, error) {
	errCh := make(chan error, 3)
	categoryResultCh := make(chan []model.EquipmentCategory, 1)
	adEqCategoryCountResultCh := make(chan map[int]int, 1)

	wg := sync.WaitGroup{}

	wg.Add(1)
	go func() {
		defer wg.Done()
		res, err := service.equipmentCategoryRepo.Get(ctx, f)
		if err != nil {
			errCh <- fmt.Errorf("service equipmentCategory: Get: %w", err)
			categoryResultCh <- nil
			return
		}
		categoryResultCh <- res
	}()

	wg.Add(1)
	go func() {
		defer wg.Done()
		res, err := service.adEquipmentRepo.GetCountBySubCategory(ctx)
		if err != nil {
			errCh <- fmt.Errorf("service equipmentCategory: Get: %w", err)
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
				return nil, fmt.Errorf("service equipmentCategory: Get: Document: %w", err)
			}
			res[i].UrlDocuments = append(res[i].UrlDocuments, d.ShareLink)
		}

		var sum int

		for j := range res[i].EquipmentSubCategories {
			res[i].EquipmentSubCategories[j].UrlDocuments = make([]string, 0, len(res[i].EquipmentSubCategories[j].Documents))
			for _, d := range res[i].EquipmentSubCategories[j].Documents {
				d, err := service.remotes.Share(ctx, d, time.Hour)
				if err != nil {
					return nil, fmt.Errorf("service equipmentCategory: Get: EquipmentSubCategories: Document: %w", err)
				}
				res[i].EquipmentSubCategories[j].UrlDocuments = append(res[i].EquipmentSubCategories[j].UrlDocuments, d.ShareLink)
			}

			count := adEqCount[res[i].EquipmentSubCategories[j].ID]
			sum += count
			res[i].EquipmentSubCategories[j].CountAd = &count
		}

		res[i].CountAd = &sum
	}

	//logrus.Infof("Total %d", len(res))
	//for _, d := range res {
	//	logrus.Info("Equipment category: ", d.ID, d.Name)
	//
	//	err := service.elastic.Update(context.Background(), d)
	//	if err != nil {
	//		return nil, err
	//	}
	//}

	return res, nil
}

func (service *equipmentCategory) GetByID(ctx context.Context, id int) (model.EquipmentCategory, error) {
	res, err := service.equipmentCategoryRepo.GetByID(ctx, id)
	if err != nil {
		return res, fmt.Errorf("service equipmentCategory: GetByID: %w", err)
	}

	res.UrlDocuments = make([]string, 0, len(res.Documents))

	for i := range res.Documents {
		res.Documents[i], err = service.remotes.Share(ctx, res.Documents[i], time.Hour)
		if err != nil {
			return res, fmt.Errorf("service equipmentCategory: GetByID ShareDocument: %w", err)
		}
		res.UrlDocuments = append(res.UrlDocuments, res.Documents[i].ShareLink)
	}

	for i := range res.EquipmentSubCategories {
		res.EquipmentSubCategories[i].UrlDocuments = make([]string, 0, len(res.EquipmentSubCategories[i].Documents))
		for j := range res.EquipmentSubCategories[i].Documents {
			res.EquipmentSubCategories[i].Documents[j], err = service.remotes.Share(ctx, res.EquipmentSubCategories[i].Documents[j], time.Hour)
			if err != nil {
				return res, fmt.Errorf("service equipmentCategory: GetByID ShareDocument: %w", err)
			}
			res.EquipmentSubCategories[i].UrlDocuments = append(
				res.EquipmentSubCategories[i].UrlDocuments,
				res.EquipmentSubCategories[i].Documents[j].ShareLink)
		}
	}

	return res, nil
}

func (service *equipmentCategory) Create(ctx context.Context, ec model.EquipmentCategory) error {
	id, err := service.equipmentCategoryRepo.Create(ctx, ec)
	if err != nil {
		return fmt.Errorf("service equipmentCategory: Create: %w", err)
	}

	for _, d := range ec.Documents {
		_, err := service.remotes.Upload(ctx, d)
		if err != nil {
			return fmt.Errorf("service equipmentCategory: Create: Upload foto: %w", err)
		}
	}

	{
		ec, err := service.equipmentCategoryRepo.GetByID(ctx, id)
		if err != nil {
			return fmt.Errorf("service equipmentCategory: GetByID: %w", err)
		}

		err = service.elastic.Create(ctx, ec)
		if err != nil {
			return fmt.Errorf("service equipmentCategory: Elastic: %w", err)
		}
	}

	return nil
}

func (service *equipmentCategory) Update(ctx context.Context, ec model.EquipmentCategory) error {
	ecOld, err := service.GetByID(ctx, ec.ID)
	if err != nil {
		return fmt.Errorf("service equipmentCategory: GetOld: %w", err)
	}

	if ec.Name == "" {
		ec.Name = ecOld.Name
	}

	err = service.equipmentCategoryRepo.Update(ctx, ec)
	if err != nil {
		return fmt.Errorf("service equipmentCategory: Update: %w", err)
	}

	for _, d := range ec.Documents {
		_, err := service.remotes.Upload(ctx, d)
		if err != nil {
			return fmt.Errorf("service equipmentCategory: Upload Document: %w", err)
		}
	}

	err = service.elastic.Update(ctx, ec)
	if err != nil {
		return fmt.Errorf("service equipmentCategory: Elastic: %w", err)
	}

	return nil
}

func (service *equipmentCategory) Delete(ctx context.Context, id int) error {
	err := service.equipmentCategoryRepo.Delete(ctx, id)
	if err != nil {
		return fmt.Errorf("service equipmentCategory: Delete: %w", err)
	}

	err = service.elastic.Delete(ctx, id)
	if err != nil {
		return fmt.Errorf("service equipmentCategory: Elastic: %w", err)
	}

	return nil
}
