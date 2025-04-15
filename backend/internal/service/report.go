package service

import (
	"context"
	"fmt"
	"time"

	"gitlab.com/eqshare/eqshare-back/internal/client"
	"gitlab.com/eqshare/eqshare-back/internal/repository"
	"gitlab.com/eqshare/eqshare-back/model"
)

type IReport interface {
	GetReason(ctx context.Context) ([]model.ReportReason, error)
	GetReasonSystem(ctx context.Context) ([]model.ReportReasonSystem, error)

	CreateAdSpecializedMachineries(ctx context.Context, report model.ReportAdSpecializedMachineries) error
	GetAdSpecializedMachineries(ctx context.Context, f model.FilterReportAdSpecializedMachineries) ([]model.ReportAdSpecializedMachineries, int, error)
	GetByIDAdSpecializedMachineries(ctx context.Context, id int) (model.ReportAdSpecializedMachineries, error)
	DeleteAdSpecializedMachineries(ctx context.Context, id int) error

	CreateAdSpecializedMachineriesClient(ctx context.Context, report model.ReportAdSpecializedMachineriesClient) error
	GetAdSpecializedMachineriesClient(ctx context.Context, f model.FilterReportAdSpecializedMachineriesClient) ([]model.ReportAdSpecializedMachineriesClient, int, error)
	GetByIDAdSpecializedMachineriesClient(ctx context.Context, id int) (model.ReportAdSpecializedMachineriesClient, error)
	DeleteAdSpecializedMachineriesClient(ctx context.Context, id int) error

	CreateAdEquipments(ctx context.Context, report model.ReportAdEquipments) error
	GetAdEquipments(ctx context.Context, f model.FilterReportAdEquipments) ([]model.ReportAdEquipments, int, error)
	GetByIDAdEquipments(ctx context.Context, id int) (model.ReportAdEquipments, error)
	DeleteAdEquipments(ctx context.Context, id int) error

	CreateAdEquipmentsClient(ctx context.Context, report model.ReportAdEquipmentClient) error
	GetAdEquipmentsClient(ctx context.Context, f model.FilterReportAdEquipmentsClient) ([]model.ReportAdEquipmentClient, int, error)
	GetByIDAdEquipmentsClient(ctx context.Context, id int) (model.ReportAdEquipmentClient, error)
	DeleteAdEquipmentsClient(ctx context.Context, id int) error

	CreateAdConstructionMaterials(ctx context.Context, report model.ReportAdConstructionMaterials) error
	GetAdConstructionMaterials(ctx context.Context, f model.FilterReportAdConstructionMaterials) ([]model.ReportAdConstructionMaterials, int, error)
	GetByIDAdConstructionMaterials(ctx context.Context, id int) (model.ReportAdConstructionMaterials, error)
	DeleteAdConstructionMaterials(ctx context.Context, id int) error

	CreateAdConstructionMaterialsClient(ctx context.Context, report model.ReportAdConstructionMaterialClient) error
	GetAdConstructionMaterialsClient(ctx context.Context, f model.FilterReportAdConstructionMaterialsClient) ([]model.ReportAdConstructionMaterialClient, int, error)
	GetByIDAdConstructionMaterialsClient(ctx context.Context, id int) (model.ReportAdConstructionMaterialClient, error)
	DeleteAdConstructionMaterialsClient(ctx context.Context, id int) error

	CreateAdServices(ctx context.Context, report model.ReportAdServices) error
	GetAdServices(ctx context.Context, f model.FilterReportAdServices) ([]model.ReportAdServices, int, error)
	GetByIDAdServices(ctx context.Context, id int) (model.ReportAdServices, error)
	DeleteAdServices(ctx context.Context, id int) error

	CreateAdServicesClient(ctx context.Context, report model.ReportAdServiceClient) error
	GetAdServicesClient(ctx context.Context, f model.FilterReportAdServicesClient) ([]model.ReportAdServiceClient, int, error)
	GetByIDAdServicesClient(ctx context.Context, id int) (model.ReportAdServiceClient, error)
	DeleteAdServicesClient(ctx context.Context, id int) error

	CreateSystem(ctx context.Context, report model.ReportSystem) error
	GetSystem(ctx context.Context, f model.FilterReportSystem) ([]model.ReportSystem, int, error)
	GetByIDSystem(ctx context.Context, id int) (model.ReportSystem, error)
	DeleteSystem(ctx context.Context, id int) error
}

type report struct {
	reportReasonRepo                       repository.IReportReason
	reportAdSpecializedMachineryRepo       repository.IReportAdSpecializedMachinery
	reportAdSpecializedMachineryClientRepo repository.IReportAdSpecializedMachineryClient
	reportAdEquipmentRepo                  repository.IReportAdEquipment
	reportAdEquipmentClientRepo            repository.IReportAdEquipmentClient
	reportAdConstructionalMaterialRepo     repository.IReportAdConstructionMaterial
	reportAdConstructionMaterialClientRepo repository.IReportAdConstructionMaterialClient
	reportAdServiceRepo                    repository.IReportAdService
	reportAdServiceClientRepo              repository.IReportAdServiceClient
	reportSystem                           repository.IReportSysytem
	remotes                                client.DocumentsRemote
}

func NewReport(
	reportReasonRepo repository.IReportReason,
	reportAdSpecializedMachineryRepo repository.IReportAdSpecializedMachinery,
	reportAdEquipmentRepo repository.IReportAdEquipment,
	reportSystem repository.IReportSysytem,
	reportAdSpecializedMachineryClientRepo repository.IReportAdSpecializedMachineryClient,
	reportAdEquipmentClientRepo repository.IReportAdEquipmentClient,
	remotes client.DocumentsRemote,
	reportAdConstructionalMaterialRepo repository.IReportAdConstructionMaterial,
	reportAdConstructionMaterialClientRepo repository.IReportAdConstructionMaterialClient,
	reportAdServiceRepo repository.IReportAdService,
	reportAdServiceClientRepo repository.IReportAdServiceClient,
) IReport {
	return &report{
		reportReasonRepo:                       reportReasonRepo,
		reportAdSpecializedMachineryRepo:       reportAdSpecializedMachineryRepo,
		reportAdEquipmentRepo:                  reportAdEquipmentRepo,
		reportAdServiceRepo:                    reportAdServiceRepo,
		reportAdConstructionalMaterialRepo:     reportAdConstructionalMaterialRepo,
		reportSystem:                           reportSystem,
		remotes:                                remotes,
		reportAdSpecializedMachineryClientRepo: reportAdSpecializedMachineryClientRepo,
		reportAdEquipmentClientRepo:            reportAdEquipmentClientRepo,
		reportAdConstructionMaterialClientRepo: reportAdConstructionMaterialClientRepo,
		reportAdServiceClientRepo:              reportAdServiceClientRepo,
	}
}

func (r *report) GetReason(ctx context.Context) ([]model.ReportReason, error) {
	res, err := r.reportReasonRepo.Get(ctx)
	if err != nil {
		return nil, fmt.Errorf("service report: GetReason: %w", err)
	}
	return res, nil
}

func (r *report) CreateAdSpecializedMachineries(ctx context.Context, report model.ReportAdSpecializedMachineries) error {
	err := r.reportAdSpecializedMachineryRepo.Create(ctx, report)
	if err != nil {
		return fmt.Errorf("service report: CreateAdSpecializedMachineries: %w", err)
	}
	return nil
}

func (r *report) GetAdSpecializedMachineries(ctx context.Context, f model.FilterReportAdSpecializedMachineries) ([]model.ReportAdSpecializedMachineries, int, error) {
	res, count, err := r.reportAdSpecializedMachineryRepo.Get(ctx, f)
	if err != nil {
		return nil, 0, fmt.Errorf("service report: GetAdSpecializedMachineries: %w", err)
	}

	for i := range res {
		res[i].AdSpecializedMachinery.UrlDocument = make([]string, 0, len(res[i].AdSpecializedMachinery.Document))
		for _, d := range res[i].AdSpecializedMachinery.Document {
			d, err := r.remotes.Share(ctx, d, time.Hour)
			if err != nil {
				return nil, 0, fmt.Errorf("service report: GetAdSpecializedMachineries: ShareDocument: %w", err)
			}
			res[i].AdSpecializedMachinery.UrlDocument = append(res[i].AdSpecializedMachinery.UrlDocument, d.ShareLink)
		}
	}

	return res, count, nil
}

func (r *report) GetByIDAdSpecializedMachineries(ctx context.Context, id int) (model.ReportAdSpecializedMachineries, error) {
	res, err := r.reportAdSpecializedMachineryRepo.GetByID(ctx, id)
	if err != nil {
		return model.ReportAdSpecializedMachineries{}, fmt.Errorf("service report: GetByIDAdSpecializedMachineries: %w", err)
	}

	res.AdSpecializedMachinery.UrlDocument = make([]string, 0, len(res.AdSpecializedMachinery.Document))
	for _, d := range res.AdSpecializedMachinery.Document {
		d, err := r.remotes.Share(ctx, d, time.Hour)
		if err != nil {
			return model.ReportAdSpecializedMachineries{}, fmt.Errorf("service report: GetAdSpecializedMachineries: ShareDocument: %w", err)
		}
		res.AdSpecializedMachinery.UrlDocument = append(res.AdSpecializedMachinery.UrlDocument, d.ShareLink)
	}

	return res, nil
}

func (r *report) DeleteAdSpecializedMachineries(ctx context.Context, id int) error {
	err := r.reportAdSpecializedMachineryRepo.Delete(ctx, id)
	if err != nil {
		return fmt.Errorf("service report: DeleteAdSpecializedMachineries: %w", err)
	}
	return nil
}

func (r *report) CreateAdSpecializedMachineriesClient(ctx context.Context, report model.ReportAdSpecializedMachineriesClient) error {
	err := r.reportAdSpecializedMachineryClientRepo.Create(ctx, report)
	if err != nil {
		return fmt.Errorf("service report: CreateAdSpecializedMachineries: %w", err)
	}
	return nil
}

func (r *report) GetAdSpecializedMachineriesClient(ctx context.Context, f model.FilterReportAdSpecializedMachineriesClient) ([]model.ReportAdSpecializedMachineriesClient, int, error) {
	res, count, err := r.reportAdSpecializedMachineryClientRepo.Get(ctx, f)
	if err != nil {
		return nil, 0, fmt.Errorf("service report: GetAdSpecializedMachineries: %w", err)
	}

	for i := range res {
		res[i].AdClient.UrlDocuments = make([]string, 0, len(res[i].AdClient.Documents))
		for _, d := range res[i].AdClient.Documents {
			d, err := r.remotes.Share(ctx, d, time.Hour)
			if err != nil {
				return nil, 0, fmt.Errorf("service report: GetAdSpecializedMachineries: ShareDocument: %w", err)
			}
			res[i].AdClient.UrlDocuments = append(res[i].AdClient.UrlDocuments, d.ShareLink)
		}
	}

	return res, count, nil
}

func (r *report) GetByIDAdSpecializedMachineriesClient(ctx context.Context, id int) (model.ReportAdSpecializedMachineriesClient, error) {
	res, err := r.reportAdSpecializedMachineryClientRepo.GetByID(ctx, id)
	if err != nil {
		return model.ReportAdSpecializedMachineriesClient{}, fmt.Errorf("service report: GetByIDAdSpecializedMachineries: %w", err)
	}

	res.AdClient.UrlDocuments = make([]string, 0, len(res.AdClient.Documents))
	for _, d := range res.AdClient.Documents {
		d, err := r.remotes.Share(ctx, d, time.Hour)
		if err != nil {
			return model.ReportAdSpecializedMachineriesClient{}, fmt.Errorf("service report: GetAdSpecializedMachineries: ShareDocument: %w", err)
		}
		res.AdClient.UrlDocuments = append(res.AdClient.UrlDocuments, d.ShareLink)
	}

	return res, nil
}

func (r *report) DeleteAdSpecializedMachineriesClient(ctx context.Context, id int) error {
	err := r.reportAdSpecializedMachineryClientRepo.Delete(ctx, id)
	if err != nil {
		return fmt.Errorf("service report: DeleteAdSpecializedMachineries: %w", err)
	}
	return nil
}

func (r *report) CreateAdEquipments(ctx context.Context, report model.ReportAdEquipments) error {
	err := r.reportAdEquipmentRepo.Create(ctx, report)
	if err != nil {
		return fmt.Errorf("service report: CreateAdEquipments: %w", err)
	}
	return nil
}

func (r *report) GetAdEquipments(ctx context.Context, f model.FilterReportAdEquipments) ([]model.ReportAdEquipments, int, error) {
	res, count, err := r.reportAdEquipmentRepo.Get(ctx, f)
	if err != nil {
		return nil, 0, fmt.Errorf("service report: GetAdEquipments: %w", err)
	}

	for i := range res {
		res[i].AdEquipment.UrlDocument = make([]string, 0, len(res[i].AdEquipment.Documents))
		for _, d := range res[i].AdEquipment.Documents {
			d, err := r.remotes.Share(ctx, d, time.Hour)
			if err != nil {
				return nil, 0, fmt.Errorf("service report: GetAdEquipments: ShareDocument: %w", err)
			}
			res[i].AdEquipment.UrlDocument = append(res[i].AdEquipment.UrlDocument, d.ShareLink)
		}
	}

	return res, count, nil
}

func (r *report) GetByIDAdEquipments(ctx context.Context, id int) (model.ReportAdEquipments, error) {
	res, err := r.reportAdEquipmentRepo.GetByID(ctx, id)
	if err != nil {
		return model.ReportAdEquipments{}, fmt.Errorf("service report: GetByIDAdEquipments: %w", err)
	}

	res.AdEquipment.UrlDocument = make([]string, 0, len(res.AdEquipment.Documents))
	for _, d := range res.AdEquipment.Documents {
		d, err := r.remotes.Share(ctx, d, time.Hour)
		if err != nil {
			return model.ReportAdEquipments{}, fmt.Errorf("service report: GetByIDAdEquipments: ShareDocument: %w", err)
		}
		res.AdEquipment.UrlDocument = append(res.AdEquipment.UrlDocument, d.ShareLink)
	}

	return res, nil
}

func (r *report) DeleteAdEquipments(ctx context.Context, id int) error {
	err := r.reportAdEquipmentRepo.Delete(ctx, id)
	if err != nil {
		return fmt.Errorf("service report: DeleteAdEquipments: %w", err)
	}
	return nil
}

func (r *report) CreateAdEquipmentsClient(ctx context.Context, report model.ReportAdEquipmentClient) error {
	err := r.reportAdEquipmentClientRepo.Create(ctx, report)
	if err != nil {
		return fmt.Errorf("service report: CreateAdEquipments: %w", err)
	}
	return nil
}

func (r *report) GetAdEquipmentsClient(ctx context.Context, f model.FilterReportAdEquipmentsClient) ([]model.ReportAdEquipmentClient, int, error) {
	res, count, err := r.reportAdEquipmentClientRepo.Get(ctx, f)
	if err != nil {
		return nil, 0, fmt.Errorf("service report: GetAdEquipments: %w", err)
	}

	for i := range res {
		res[i].AdEquipmentClient.UrlDocument = make([]string, 0, len(res[i].AdEquipmentClient.Documents))
		for _, d := range res[i].AdEquipmentClient.Documents {
			d, err := r.remotes.Share(ctx, d, time.Hour)
			if err != nil {
				return nil, 0, fmt.Errorf("service report: GetAdEquipments: ShareDocument: %w", err)
			}
			res[i].AdEquipmentClient.UrlDocument = append(res[i].AdEquipmentClient.UrlDocument, d.ShareLink)
		}
	}

	return res, count, nil
}

func (r *report) GetByIDAdEquipmentsClient(ctx context.Context, id int) (model.ReportAdEquipmentClient, error) {
	res, err := r.reportAdEquipmentClientRepo.GetByID(ctx, id)
	if err != nil {
		return model.ReportAdEquipmentClient{}, fmt.Errorf("service report: GetByIDAdEquipments: %w", err)
	}

	res.AdEquipmentClient.UrlDocument = make([]string, 0, len(res.AdEquipmentClient.Documents))
	for _, d := range res.AdEquipmentClient.Documents {
		d, err := r.remotes.Share(ctx, d, time.Hour)
		if err != nil {
			return model.ReportAdEquipmentClient{}, fmt.Errorf("service report: GetByIDAdEquipments: ShareDocument: %w", err)
		}
		res.AdEquipmentClient.UrlDocument = append(res.AdEquipmentClient.UrlDocument, d.ShareLink)
	}

	return res, nil
}

func (r *report) DeleteAdEquipmentsClient(ctx context.Context, id int) error {
	err := r.reportAdEquipmentClientRepo.Delete(ctx, id)
	if err != nil {
		return fmt.Errorf("service report: DeleteAdEquipments: %w", err)
	}
	return nil
}

func (r *report) GetReasonSystem(ctx context.Context) ([]model.ReportReasonSystem, error) {
	res, err := r.reportReasonRepo.GetReasonSystem(ctx)
	if err != nil {
		return nil, fmt.Errorf("service report: GetReasonSystem: %w", err)
	}

	return res, nil
}

func (r *report) CreateSystem(ctx context.Context, report model.ReportSystem) error {
	err := r.reportSystem.Create(ctx, report)
	if err != nil {
		return fmt.Errorf("service report: CreateSystem: %w", err)
	}
	return nil
}

func (r *report) GetSystem(ctx context.Context, f model.FilterReportSystem) ([]model.ReportSystem, int, error) {
	res, count, err := r.reportSystem.Get(ctx, f)
	if err != nil {
		return nil, 0, fmt.Errorf("service report: GetSystem: %w", err)
	}
	return res, count, nil
}

func (r *report) GetByIDSystem(ctx context.Context, id int) (model.ReportSystem, error) {
	res, err := r.reportSystem.GetByID(ctx, id)
	if err != nil {
		return model.ReportSystem{}, fmt.Errorf("service report: GetSystem: %w", err)
	}
	return res, nil
}

func (r *report) DeleteSystem(ctx context.Context, id int) error {
	err := r.reportSystem.Delete(ctx, id)
	if err != nil {
		return fmt.Errorf("service report: GetSystem: %w", err)
	}
	return nil
}

func (r *report) GetAdConstructionMaterials(ctx context.Context, f model.FilterReportAdConstructionMaterials) ([]model.ReportAdConstructionMaterials, int, error) {
	res, count, err := r.reportAdConstructionalMaterialRepo.Get(ctx, f)
	if err != nil {
		return nil, 0, fmt.Errorf("service report: GetAdSpecializedMachineries: %w", err)
	}

	for i := range res {
		res[i].AdConstructionMaterial.UrlDocument = make([]string, 0, len(res[i].AdConstructionMaterial.Documents))
		for _, d := range res[i].AdConstructionMaterial.Documents {
			d, err := r.remotes.Share(ctx, d, time.Hour)
			if err != nil {
				return nil, 0, fmt.Errorf("service report: GetAdSpecializedMachineries: ShareDocument: %w", err)
			}
			res[i].AdConstructionMaterial.UrlDocument = append(res[i].AdConstructionMaterial.UrlDocument, d.ShareLink)
		}
	}

	return res, count, nil
}

func (r *report) GetByIDAdConstructionMaterials(ctx context.Context, id int) (model.ReportAdConstructionMaterials, error) {
	res, err := r.reportAdConstructionalMaterialRepo.GetByID(ctx, id)
	if err != nil {
		return model.ReportAdConstructionMaterials{}, fmt.Errorf("service report: GetByIDAdEquipments: %w", err)
	}

	res.AdConstructionMaterial.UrlDocument = make([]string, 0, len(res.AdConstructionMaterial.Documents))
	for _, d := range res.AdConstructionMaterial.Documents {
		d, err := r.remotes.Share(ctx, d, time.Hour)
		if err != nil {
			return model.ReportAdConstructionMaterials{}, fmt.Errorf("service report: GetByIDAdEquipments: ShareDocument: %w", err)
		}
		res.AdConstructionMaterial.UrlDocument = append(res.AdConstructionMaterial.UrlDocument, d.ShareLink)
	}

	return res, nil
}

func (r *report) CreateAdConstructionMaterials(ctx context.Context, report model.ReportAdConstructionMaterials) error {
	err := r.reportAdConstructionalMaterialRepo.Create(ctx, report)
	if err != nil {
		return fmt.Errorf("service report: CreateAdConstructionMaterials: %w", err)
	}
	return nil
}

func (r *report) DeleteAdConstructionMaterials(ctx context.Context, id int) error {
	err := r.reportAdConstructionalMaterialRepo.Delete(ctx, id)
	if err != nil {
		return fmt.Errorf("service report: DeleteAdConstructionMaterials: %w", err)
	}
	return nil
}

func (r *report) CreateAdConstructionMaterialsClient(ctx context.Context, report model.ReportAdConstructionMaterialClient) error {
	err := r.reportAdConstructionMaterialClientRepo.Create(ctx, report)
	if err != nil {
		return fmt.Errorf("service report: CreateAdEquipments: %w", err)
	}
	return nil
}

func (r *report) GetAdConstructionMaterialsClient(ctx context.Context, f model.FilterReportAdConstructionMaterialsClient) ([]model.ReportAdConstructionMaterialClient, int, error) {
	res, count, err := r.reportAdConstructionMaterialClientRepo.Get(ctx, f)
	if err != nil {
		return nil, 0, fmt.Errorf("service report: GetAdEquipments: %w", err)
	}

	for i := range res {
		res[i].AdConstructionMaterialClient.UrlDocument = make([]string, 0, len(res[i].AdConstructionMaterialClient.Documents))
		for _, d := range res[i].AdConstructionMaterialClient.Documents {
			d, err := r.remotes.Share(ctx, d, time.Hour)
			if err != nil {
				return nil, 0, fmt.Errorf("service report: GetAdEquipments: ShareDocument: %w", err)
			}
			res[i].AdConstructionMaterialClient.UrlDocument = append(res[i].AdConstructionMaterialClient.UrlDocument, d.ShareLink)
		}
	}

	return res, count, nil
}

func (r *report) GetByIDAdConstructionMaterialsClient(ctx context.Context, id int) (model.ReportAdConstructionMaterialClient, error) {
	res, err := r.reportAdConstructionMaterialClientRepo.GetByID(ctx, id)
	if err != nil {
		return model.ReportAdConstructionMaterialClient{}, fmt.Errorf("service report: GetByIDAdEquipments: %w", err)
	}

	res.AdConstructionMaterialClient.UrlDocument = make([]string, 0, len(res.AdConstructionMaterialClient.Documents))
	for _, d := range res.AdConstructionMaterialClient.Documents {
		d, err := r.remotes.Share(ctx, d, time.Hour)
		if err != nil {
			return model.ReportAdConstructionMaterialClient{}, fmt.Errorf("service report: GetByIDAdEquipments: ShareDocument: %w", err)
		}
		res.AdConstructionMaterialClient.UrlDocument = append(res.AdConstructionMaterialClient.UrlDocument, d.ShareLink)
	}

	return res, nil
}

func (r *report) DeleteAdConstructionMaterialsClient(ctx context.Context, id int) error {
	err := r.reportAdConstructionMaterialClientRepo.Delete(ctx, id)
	if err != nil {
		return fmt.Errorf("service report: DeleteAdEquipments: %w", err)
	}
	return nil
}

func (r *report) GetAdServices(ctx context.Context, f model.FilterReportAdServices) ([]model.ReportAdServices, int, error) {
	res, count, err := r.reportAdServiceRepo.Get(ctx, f)
	if err != nil {
		return nil, 0, fmt.Errorf("service report: GetAdSpecializedMachineries: %w", err)
	}

	for i := range res {
		res[i].AdService.UrlDocument = make([]string, 0, len(res[i].AdService.Documents))
		for _, d := range res[i].AdService.Documents {
			d, err := r.remotes.Share(ctx, d, time.Hour)
			if err != nil {
				return nil, 0, fmt.Errorf("service report: GetAdSpecializedMachineries: ShareDocument: %w", err)
			}
			res[i].AdService.UrlDocument = append(res[i].AdService.UrlDocument, d.ShareLink)
		}
	}

	return res, count, nil
}

func (r *report) GetByIDAdServices(ctx context.Context, id int) (model.ReportAdServices, error) {
	res, err := r.reportAdServiceRepo.GetByID(ctx, id)
	if err != nil {
		return model.ReportAdServices{}, fmt.Errorf("service report: GetByIDAdEquipments: %w", err)
	}

	res.AdService.UrlDocument = make([]string, 0, len(res.AdService.Documents))
	for _, d := range res.AdService.Documents {
		d, err := r.remotes.Share(ctx, d, time.Hour)
		if err != nil {
			return model.ReportAdServices{}, fmt.Errorf("service report: GetByIDAdEquipments: ShareDocument: %w", err)
		}
		res.AdService.UrlDocument = append(res.AdService.UrlDocument, d.ShareLink)
	}

	return res, nil
}

func (r *report) CreateAdServices(ctx context.Context, report model.ReportAdServices) error {
	err := r.reportAdServiceRepo.Create(ctx, report)
	if err != nil {
		return fmt.Errorf("service report: CreateAdServices: %w", err)
	}
	return nil
}

func (r *report) DeleteAdServices(ctx context.Context, id int) error {
	err := r.reportAdServiceRepo.Delete(ctx, id)
	if err != nil {
		return fmt.Errorf("service report: DeleteAdServices: %w", err)
	}
	return nil
}

func (r *report) CreateAdServicesClient(ctx context.Context, report model.ReportAdServiceClient) error {
	err := r.reportAdServiceClientRepo.Create(ctx, report)
	if err != nil {
		return fmt.Errorf("service report: CreateAdEquipments: %w", err)
	}
	return nil
}

func (r *report) GetAdServicesClient(ctx context.Context, f model.FilterReportAdServicesClient) ([]model.ReportAdServiceClient, int, error) {
	res, count, err := r.reportAdServiceClientRepo.Get(ctx, f)
	if err != nil {
		return nil, 0, fmt.Errorf("service report: GetAdEquipments: %w", err)
	}

	for i := range res {
		res[i].AdServiceClient.UrlDocument = make([]string, 0, len(res[i].AdServiceClient.Documents))
		for _, d := range res[i].AdServiceClient.Documents {
			d, err := r.remotes.Share(ctx, d, time.Hour)
			if err != nil {
				return nil, 0, fmt.Errorf("service report: GetAdEquipments: ShareDocument: %w", err)
			}
			res[i].AdServiceClient.UrlDocument = append(res[i].AdServiceClient.UrlDocument, d.ShareLink)
		}
	}

	return res, count, nil
}

func (r *report) GetByIDAdServicesClient(ctx context.Context, id int) (model.ReportAdServiceClient, error) {
	res, err := r.reportAdServiceClientRepo.GetByID(ctx, id)
	if err != nil {
		return model.ReportAdServiceClient{}, fmt.Errorf("service report: GetByIDAdEquipments: %w", err)
	}

	res.AdServiceClient.UrlDocument = make([]string, 0, len(res.AdServiceClient.Documents))
	for _, d := range res.AdServiceClient.Documents {
		d, err := r.remotes.Share(ctx, d, time.Hour)
		if err != nil {
			return model.ReportAdServiceClient{}, fmt.Errorf("service report: GetByIDAdEquipments: ShareDocument: %w", err)
		}
		res.AdServiceClient.UrlDocument = append(res.AdServiceClient.UrlDocument, d.ShareLink)
	}

	return res, nil
}

func (r *report) DeleteAdServicesClient(ctx context.Context, id int) error {
	err := r.reportAdServiceClientRepo.Delete(ctx, id)
	if err != nil {
		return fmt.Errorf("service report: DeleteAdEquipments: %w", err)
	}
	return nil
}
