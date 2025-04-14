package service

import (
	"context"
	"fmt"

	"gitlab.com/eqshare/eqshare-back/internal/repository"
	"gitlab.com/eqshare/eqshare-back/model"
)

type IStatistic interface {
	GetRequestExecutionStatistic(status string) ([]model.RequestByStatusReport, error)
	GetAdClientStatistic() ([]model.AdReport, error)
	GetAdSmStatistic() ([]model.AdReport, error)
	GetClientRequestStatistic(status string) ([]model.RequestByStatusReport, error)
	GetAdSpecializedMachineryStaticByID(id int) ([]model.AdSpecializedMachineryStatByID, error)
	GetAdClientStatisticByID(id int) ([]model.AdClinetStatByID, error)
	GetRequestExecutionHistory(id int) ([]model.RequestExectionHistory, error)
	RequestExectionStatusTime(id int) (model.RequestExectionStatusTime, error)
	AdClientCountBySubCategory(f model.FilterSubCategoryCount) ([]model.SubCategoryCount, error)
	AdSpecializedMachineryCountBySubCategory(f model.FilterSubCategoryCount) ([]model.SubCategoryCount, error)
	AdClientCountByCategory(f model.FilterCategoryCount) ([]model.CategoryCount, error)
	AdSpecializedMachineryCountByCategory(f model.FilterCategoryCount) ([]model.CategoryCount, error)
	AdEquipmentClientCountByCategory(ctx context.Context, f model.FilterCategoryCount) ([]model.CategoryCount, error)
	AdEquipmentCountByCategory(ctx context.Context, f model.FilterCategoryCount) ([]model.CategoryCount, error)
	AdEquipmentClientCountBySubCategory(ctx context.Context, f model.FilterCategoryCount) ([]model.CategoryCount, error)
	AdEquipmentCountBySubCategory(ctx context.Context, f model.FilterCategoryCount) ([]model.CategoryCount, error)
	RequestExectionSumPaymentAmount(ctx context.Context, f model.FilterRequestExecution) (int, error)
}

type statistic struct {
	sRepo repository.IStatistic
}

func NewStatisticService(rRepo repository.IStatistic) *statistic {
	return &statistic{
		sRepo: rRepo,
	}
}

func (s *statistic) GetRequestExecutionStatistic(status string) ([]model.RequestByStatusReport, error) {
	return s.sRepo.GetRequestExecutionStatistic(status)
}

func (s *statistic) GetAdClientStatistic() ([]model.AdReport, error) {
	return s.sRepo.GetAdClientStatistic()
}

func (s *statistic) GetAdSmStatistic() ([]model.AdReport, error) {
	return s.sRepo.GetAdSmStatic()
}

func (s *statistic) GetClientRequestStatistic(status string) ([]model.RequestByStatusReport, error) {
	return s.sRepo.GetClientRequestStatistic(status)
}

func (s *statistic) GetAdSpecializedMachineryStaticByID(id int) ([]model.AdSpecializedMachineryStatByID, error) {
	return s.sRepo.GetAdSpecializedMachineryStaticByID(id)
}

func (s *statistic) GetAdClientStatisticByID(id int) ([]model.AdClinetStatByID, error) {
	return s.sRepo.GetAdClientStatisticByID(id)
}

func (s *statistic) GetRequestExecutionHistory(id int) ([]model.RequestExectionHistory, error) {
	res, err := s.sRepo.GetRequestExecutionHistory(id)
	if err != nil {
		return nil, err
	}

	var haveResume bool

	for i, reh := range res {
		if reh.Status == model.STATUS_WORKING {
			if !haveResume {
				haveResume = true
			} else {
				res[i].Status = model.STATUS_RESUME
			}
		}
	}

	return res, nil
}

func (s *statistic) RequestExectionStatusTime(id int) (model.RequestExectionStatusTime, error) {
	res, err := s.sRepo.RequestExectionStatusTime(id)
	if err != nil {
		return model.RequestExectionStatusTime{}, err
	}

	res.TotalWork = res.Working + res.Pause
	res.Total = res.AwaitsStart + res.Working + res.Pause + res.Finished + res.OnRoad

	return res, nil
}

func (s *statistic) AdClientCountBySubCategory(f model.FilterSubCategoryCount) ([]model.SubCategoryCount, error) {
	return s.sRepo.AdClientCountBySubCategory(f)
}

func (s *statistic) AdSpecializedMachineryCountBySubCategory(f model.FilterSubCategoryCount) ([]model.SubCategoryCount, error) {
	return s.sRepo.AdSpecializedMachineryCountBySubCategory(f)
}

func (s *statistic) AdClientCountByCategory(f model.FilterCategoryCount) ([]model.CategoryCount, error) {
	return s.sRepo.AdSpecializedMachineryCountByCategory(f)
}

func (s *statistic) AdSpecializedMachineryCountByCategory(f model.FilterCategoryCount) ([]model.CategoryCount, error) {
	return s.sRepo.AdClientCountByCategory(f)
}

func (s *statistic) AdEquipmentClientCountByCategory(ctx context.Context, f model.FilterCategoryCount) ([]model.CategoryCount, error) {
	res, err := s.sRepo.AdEquipmentClientCountByCategory(ctx, f)
	if err != nil {
		return nil, fmt.Errorf("service statistic: AdEquipmentClientCountByCategory: err: %w", err)
	}
	return res, nil
}

func (s *statistic) AdEquipmentCountByCategory(ctx context.Context, f model.FilterCategoryCount) ([]model.CategoryCount, error) {
	res, err := s.sRepo.AdEquipmentCountByCategory(ctx, f)
	if err != nil {
		return nil, fmt.Errorf("service statistic: AdEquipmentCountByCategory: err: %w", err)
	}
	return res, nil
}

func (s *statistic) AdEquipmentClientCountBySubCategory(ctx context.Context, f model.FilterCategoryCount) ([]model.CategoryCount, error) {
	res, err := s.sRepo.AdEquipmentClientCountBySubCategory(ctx, f)
	if err != nil {
		return nil, fmt.Errorf("service statistic: AdEquipmentClientCountBySubCategory: err: %w", err)
	}
	return res, nil
}

func (s *statistic) AdEquipmentCountBySubCategory(ctx context.Context, f model.FilterCategoryCount) ([]model.CategoryCount, error) {
	res, err := s.sRepo.AdEquipmentCountBySubCategory(ctx, f)
	if err != nil {
		return nil, fmt.Errorf("service statistic: AdEquipmentCountBySubCategory: err: %w", err)
	}
	return res, nil
}

func (s *statistic) RequestExectionSumPaymentAmount(ctx context.Context, f model.FilterRequestExecution) (int, error) {
	res, err := s.sRepo.RequestExectionSumPaymentAmount(ctx, f)
	if err != nil {
		return 0, fmt.Errorf("service statistic: RequestExectionSumPaymentAmount: err: %w", err)
	}

	return res, nil
}
