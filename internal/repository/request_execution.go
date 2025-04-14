package repository

import (
	"context"
	"fmt"
	"strings"

	"gitlab.com/eqshare/eqshare-back/model"
	"gorm.io/gorm"
)

type IRequestExecution interface {
	Create(ctx context.Context, re model.RequestExecution) (int, error)
	Get(f model.FilterRequestExecution) ([]model.RequestExecution, int, error)
	// GetCoordinateByID(ctx context.Context, id int) (model.Coordinates, error)
	GetByID(id int) (model.RequestExecution, error)
	Update(re model.RequestExecution) error
	// UpdateCordinate(c model.Coordinates) error
	UpdateAssignTo(id int, workerID *int) error
	GetRequestID(req model.RequestExecution) (model.RequestExecution, error)
	GetHistoryByID(id int) ([]model.RequestExecution, error)

	CreateCordinate(ctx context.Context, cord model.RequestExecutionMove) error
	GetCordinateByID(ctx context.Context, id int, f model.FilterRequestExecutionMove) ([]model.RequestExecutionMove, error)

	HistoryTraveledWay(ctx context.Context, id int) ([]model.Coordinates, error)

	UpdatePostNotification(ctx context.Context, id ...int) error
	UpdateEndLeaseAt(ctx context.Context, id int, EndLeaseAt model.Time) error
}

type requestExecution struct {
	db *gorm.DB
}

func NewRequestExecution(db *gorm.DB) *requestExecution {
	return &requestExecution{db: db}
}

func (r *requestExecution) Create(ctx context.Context, re model.RequestExecution) (int, error) {
	// tx := r.db.Begin()
	// defer tx.Rollback()

	// err := tx.WithContext(ctx).Create(&re).Error
	// if err != nil {
	// 	return 0, fmt.Errorf("repo requestExecution Create: %w", err)
	// }

	// docs := make([]map[string]interface{}, 0, len(re.Documents))

	// for _, d := range re.Documents {
	// 	docs = append(docs, map[string]interface{}{
	// 		"request_execution_id": re.ID,
	// 		"document_id":          d.ID,
	// 	})
	// }

	// err = tx.WithContext(ctx).
	// 	Table("request_executions_documents").
	// 	Create(docs).Error
	// if err != nil {
	// 	return 0, fmt.Errorf("repo requestExecution Create: docs: %w", err)
	// }

	// tx.Commit()

	err := r.db.WithContext(ctx).Create(&re).Error
	if err != nil {
		return 0, fmt.Errorf("repo requestExecution: Create: %w", err)
	}

	return re.ID, err
}

func (r *requestExecution) Get(f model.FilterRequestExecution) ([]model.RequestExecution, int, error) {
	re := make([]model.RequestExecution, 0)

	stmt := r.db.Preload("UserAssignTo").
		Preload("Driver").
		Preload("Clinet").
		Preload("RequestAdEquipmentClient.AdEquipmentClient").
		Preload("SpecializedMachineryRequest.AdSpecializedMachinery").
		Preload("SpecializedMachineryRequest.AdSpecializedMachinery.Type").
		Preload("Request.AdClient.Type").
		Preload("RequestAdEquipmentClient.AdEquipmentClient").
		Preload("RequestAdEquipmentClient.AdEquipmentClient.EquipmentSubCategory").
		Preload("RequestAdEquipment.AdEquipment").
		Preload("RequestAdEquipment.AdEquipment.EquipmentSubCategory").
		Preload("RequestAdConstructionMaterialClient.AdConstructionMaterialClient").
		Preload("RequestAdConstructionMaterialClient.AdConstructionMaterialClient.ConstructionMaterialSubCategory").
		Preload("RequestAdConstructionMaterial.AdConstructionMaterial").
		Preload("RequestAdConstructionMaterial.AdConstructionMaterial.ConstructionMaterialSubCategory").
		Preload("RequestAdServiceClient.AdServiceClient").
		Preload("RequestAdServiceClient.AdServiceClient.ServiceSubCategory").
		Preload("RequestAdService.AdService.ServiceSubCategory")

	if f.DocumentDetail != nil && *f.DocumentDetail {
		stmt = stmt.Preload("Documents")
	}

	if len(f.ID) != 0 {
		stmt = stmt.Where("id in (?)", f.ID)
	}

	if f.ClientID != nil {
		// stmt = stmt.Where(`(specialized_machinery_request_id IN (SELECT s.id
		// 														FROM specialized_machinery_requests s
		// 														WHERE user_id = ?)
		// 	OR request_id IN (SELECT r.id
		// 					   FROM requests r
		// 					   WHERE r.ad_client_id IN (SELECT ad.id
		// 							FROM ad_clients ad
		// 							WHERE ad.user_id = ?)))`, f.ClientID, f.ClientID)
		stmt = stmt.Where("clinet_id = ?", f.ClientID)
	}

	// Handle the case where both DriverID and AssignTo are passed
	if f.DriverID != nil && f.AssignTo != nil {
		stmt = stmt.Where("(driver_id = ? OR assign_to = ?)", f.DriverID, f.AssignTo)
	} else {
		// Handle each filter separately if only one of them is passed
		if f.DriverID != nil {
			stmt = stmt.Where("driver_id = ?", f.DriverID)
		}

		if f.AssignTo != nil {
			stmt = stmt.Where("assign_to = ?", f.AssignTo)
		}
	}

	if f.Status != nil {
		stmt = stmt.Where(`status in (?)`, f.Status)
	}

	if f.Src != nil {
		stmt = stmt.Where(`src in (?)`, f.Src)
	}

	if f.MinUpdatedAt.Valid {
		stmt = stmt.Where("updated_at >= ?", f.MinUpdatedAt)
	}

	if f.MaxUpdatedAt.Valid {
		stmt = stmt.Where("updated_at <= ?", f.MaxUpdatedAt)
	}

	if f.AfterStartLeaseAt.Valid {
		stmt = stmt.Where("start_lease_at >= ?", f.AfterStartLeaseAt)
	}

	if f.BeforeStartLeaseAt.Valid {
		stmt = stmt.Where("start_lease_at <= ?", f.BeforeStartLeaseAt)
	}

	if f.AfterEndLeaseAt.Valid {
		stmt = stmt.Where("end_lease_at >= ?", f.AfterEndLeaseAt)
	}

	if f.BeforeEndLeaseAt.Valid {
		stmt = stmt.Where("end_lease_at <= ?", f.BeforeEndLeaseAt)
	}

	if f.PostNotification != nil {
		stmt = stmt.Where("post_notification = ?", f.PostNotification)
	}

	if f.ForgotToStart != nil {
		stmt = stmt.Where("forgot_to_start = ?", f.ForgotToStart)
	}

	if f.ForgotToEnd != nil {
		stmt = stmt.Where("forgot_to_end = ?", f.ForgotToEnd)
	}

	if f.Limit != nil {
		if *f.Limit != 0 {
			stmt = stmt.Limit(*f.Limit)
		}
	}

	if f.Offset != nil {
		stmt = stmt.Offset(*f.Offset)
	}

	if len(f.ASC) != 0 {
		temp := make([]string, 0, len(f.ASC))
		for _, val := range f.ASC {
			temp = append(temp, fmt.Sprintf("%s ASC", val))
		}

		stmt = stmt.Order(strings.Join(temp, ", "))
	}

	if len(f.DESC) != 0 {
		temp := make([]string, 0, len(f.DESC))
		for _, val := range f.DESC {
			temp = append(temp, fmt.Sprintf("%s DESC", val))
		}

		stmt = stmt.Order(strings.Join(temp, ", "))
	}

	stmt = stmt.Order("updated_at DESC")

	res := stmt.Find(&re)
	if res.Error != nil {
		return nil, 0, res.Error
	}

	var n int64
	res = res.Limit(-1).Offset(-1)
	res = res.Count(&n)
	if res.Error != nil {
		return nil, 0, res.Error
	}

	return re, int(n), nil
}

func (r *requestExecution) GetByID(id int) (model.RequestExecution, error) {
	re := model.RequestExecution{}

	res := r.db.Model(&model.RequestExecution{}).
		Unscoped().
		Preload("SpecializedMachineryRequest").
		Preload("SpecializedMachineryRequest.Document").
		Preload("SpecializedMachineryRequest.AdSpecializedMachinery").
		Preload("SpecializedMachineryRequest.AdSpecializedMachinery.User").
		Preload("SpecializedMachineryRequest.AdSpecializedMachinery.Brand").
		Preload("SpecializedMachineryRequest.AdSpecializedMachinery.Type").
		Preload("SpecializedMachineryRequest.AdSpecializedMachinery.City").
		Preload("SpecializedMachineryRequest.AdSpecializedMachinery.Document").
		Preload("Request").
		Preload("Request.AdClient").
		Preload("Request.AdClient.Documents").
		Preload("Request.AdClient.User").
		Preload("Request.AdClient.Type").
		Preload("Request.AdClient.City").
		Preload("RequestAdEquipmentClient").
		Preload("RequestAdEquipmentClient.User").
		Preload("RequestAdEquipmentClient.Executor").
		Preload("RequestAdEquipmentClient").
		Preload("RequestAdEquipmentClient.AdEquipmentClient").
		Preload("RequestAdEquipmentClient.AdEquipmentClient.User").
		Preload("RequestAdEquipmentClient.AdEquipmentClient.City").
		Preload("RequestAdEquipmentClient.AdEquipmentClient.Documents").
		Preload("RequestAdEquipmentClient.AdEquipmentClient.EquipmentSubCategory").
		Preload("RequestAdEquipment").
		Preload("RequestAdEquipment.User").
		Preload("RequestAdEquipment.Executor").
		Preload("RequestAdEquipment.Document").
		Preload("RequestAdEquipment.AdEquipment").
		Preload("RequestAdEquipment.AdEquipment.Documents").
		Preload("RequestAdEquipment.AdEquipment.User").
		Preload("RequestAdEquipment.AdEquipment.EquipmentBrand").
		Preload("RequestAdEquipment.AdEquipment.EquipmentSubCategory").
		Preload("RequestAdEquipment.AdEquipment.City").
		Preload("RequestAdConstructionMaterialClient").
		Preload("RequestAdConstructionMaterialClient.User").
		Preload("RequestAdConstructionMaterialClient.Executor").
		Preload("RequestAdConstructionMaterialClient").
		Preload("RequestAdConstructionMaterialClient.AdConstructionMaterialClient").
		Preload("RequestAdConstructionMaterialClient.AdConstructionMaterialClient.User").
		Preload("RequestAdConstructionMaterialClient.AdConstructionMaterialClient.City").
		Preload("RequestAdConstructionMaterialClient.AdConstructionMaterialClient.Documents").
		Preload("RequestAdConstructionMaterialClient.AdConstructionMaterialClient.ConstructionMaterialSubCategory").
		Preload("RequestAdConstructionMaterial").
		Preload("RequestAdConstructionMaterial.User").
		Preload("RequestAdConstructionMaterial.Executor").
		Preload("RequestAdConstructionMaterial.Document").
		Preload("RequestAdConstructionMaterial.AdConstructionMaterial").
		Preload("RequestAdConstructionMaterial.AdConstructionMaterial.Documents").
		Preload("RequestAdConstructionMaterial.AdConstructionMaterial.User").
		Preload("RequestAdConstructionMaterial.AdConstructionMaterial.ConstructionMaterialBrand").
		Preload("RequestAdConstructionMaterial.AdConstructionMaterial.ConstructionMaterialSubCategory").
		Preload("RequestAdConstructionMaterial.AdConstructionMaterial.City").
		Preload("RequestAdServiceClient").
		Preload("RequestAdServiceClient.User").
		Preload("RequestAdServiceClient.Executor").
		Preload("RequestAdServiceClient").
		Preload("RequestAdServiceClient.AdServiceClient").
		Preload("RequestAdServiceClient.AdServiceClient.User").
		Preload("RequestAdServiceClient.AdServiceClient.City").
		Preload("RequestAdServiceClient.AdServiceClient.Documents").
		Preload("RequestAdServiceClient.AdServiceClient.ServiceSubCategory").
		Preload("RequestAdService").
		Preload("RequestAdService.User").
		Preload("RequestAdService.Executor").
		Preload("RequestAdService.Document").
		Preload("RequestAdService.AdService").
		Preload("RequestAdService.AdService.Documents").
		Preload("RequestAdService.AdService.User").
		Preload("RequestAdService.AdService.ServiceBrand").
		Preload("RequestAdService.AdService.ServiceSubCategory").
		Preload("RequestAdService.AdService.City").
		Preload("Driver").
		Preload("Clinet").
		Preload("UserAssignTo").
		Preload("Documents").
		First(&re, id)
	if res.Error != nil {
		return re, res.Error
	}

	return re, nil
}

func (r *requestExecution) Update(re model.RequestExecution) error {
	m := make(map[string]interface{}, 0)

	if re.Status != "" {
		m["status"] = re.Status
	}

	if re.WorkStartedAt.Valid {
		m["work_started_at"] = re.WorkStartedAt
	}

	if re.WorkEndAt.Valid {
		m["work_end_at"] = re.WorkEndAt
	}

	if re.Rate != nil {
		m["rate"] = re.Rate
	}

	if re.RateComment != nil {
		m["rate_comment"] = re.RateComment
	}

	if re.ClinetPaymentAmount != nil {
		m["clinet_payment_amount"] = re.ClinetPaymentAmount
	}
	if re.DriverPaymentAmount != nil {
		m["driver_payment_amount"] = re.DriverPaymentAmount
	}

	m["work_started_clinet"] = re.WorkStartedClinet
	m["work_started_driver"] = re.WorkStartedDriver
	m["forgot_to_start"] = re.ForgotToStart
	m["forgot_to_end"] = re.ForgotToEnd

	return r.db.Model(&model.RequestExecution{}).Where("id = ?", re.ID).Updates(m).Error
}

func (r *requestExecution) UpdatePostNotification(ctx context.Context, id ...int) error {
	if len(id) == 0 {
		return nil
	}

	m := make(map[string]interface{}, 0)

	m["post_notification"] = true

	stmt := r.db.Model(&model.RequestExecution{}).Where("id in (?)", id).Updates(m)
	if err := stmt.Error; err != nil {
		return fmt.Errorf("repository requestExecution: UpdatePostNotification: err: %w", err)
	}

	return nil
}

// func (r *requestExecution) UpdateCordinate(c model.Coordinates) error {
// 	return r.db.Model(&model.RequestExecution{}).
// 		Where("id = ?", c.RequestExecutionID).
// 		Updates(
// 			map[string]interface{}{
// 				"latitude":  c.Latitude,
// 				"longitude": c.Longitude,
// 			}).
// 		Error
// }

// func (r *requestExecution) GetCoordinateByID(ctx context.Context, id int) (model.Coordinates, error) {
// 	c := model.Coordinates{}

// 	err := r.db.WithContext(ctx).Table("request_executions").Select("latitude", "longitude").Where("id = ?", id).Find(&c).Error
// 	if err != nil {
// 		return c, err
// 	}

// 	return c, nil
// }

func (r *requestExecution) UpdateAssignTo(id int, workerID *int) error {
	return r.db.Model(&model.RequestExecution{}).Where("id = ?", id).Update("assign_to", workerID).Error
}

func (r *requestExecution) GetRequestID(req model.RequestExecution) (model.RequestExecution, error) {
	if err := r.db.Model(&model.RequestExecution{}).Find(&req).Error; err != nil {
		return req, err
	}

	return req, nil
}

func (r *requestExecution) GetHistoryByID(id int) ([]model.RequestExecution, error) {
	res := make([]model.RequestExecution, 0)

	err := r.db.Unscoped().
		Table("request_executions_histories").
		// Order("updated_at ASC").
		// Order("deleted_at ASC").
		Where("id = ?", id).
		Find(&res).Error
	if err != nil {
		return nil, err
	}

	return res, nil
}

func (r *requestExecution) CreateCordinate(ctx context.Context, cord model.RequestExecutionMove) error {
	err := r.db.WithContext(ctx).Create(&cord).Error
	if err != nil {
		return err
	}

	return nil
}

func (r *requestExecution) GetCordinateByID(ctx context.Context, id int, f model.FilterRequestExecutionMove) ([]model.RequestExecutionMove, error) {
	moves := make([]model.RequestExecutionMove, 0)

	stmt := r.db.WithContext(ctx).Model(&model.RequestExecutionMove{})

	if f.DescCreatedAt != nil {
		stmt = stmt.Order("created_at DESC")
	}

	if f.AscCreatedAt != nil {
		stmt = stmt.Order("created_at ASC")
	}

	if f.Limit != nil {
		stmt = stmt.Limit(*f.Limit)
	}

	err := stmt.Where("request_exection_id = ?", id).Find(&moves).Error
	if err != nil {
		return nil, err
	}

	return moves, nil
}

func (r *requestExecution) HistoryTraveledWay(ctx context.Context, id int) ([]model.Coordinates, error) {
	rows, err := r.db.WithContext(ctx).
		Table("request_execution_moves").
		Where("request_exection_id = ?", id).
		Select("request_exection_id", "created_at", "latitude", "longitude").
		Rows()
	if err != nil {
		return nil, fmt.Errorf("repository requestExecution: HistoryTraveledWay: %w", err)
	}

	res := make([]model.Coordinates, 0)
	defer rows.Close()
	for rows.Next() {
		c := model.Coordinates{}

		err := rows.Scan(&c.RequestExecutionID, &c.CreatedAt, &c.Latitude, &c.Longitude)
		if err != nil {
			return nil, fmt.Errorf("repository requestExecution: HistoryTraveledWay: Scan: %w", err)
		}

		res = append(res, c)
	}

	return res, nil
}

func (r *requestExecution) UpdateEndLeaseAt(ctx context.Context, id int, endLeaseAt model.Time) error {
	var val interface{}

	if !endLeaseAt.Valid {
		val = nil
	} else {
		val = endLeaseAt
	}

	stmt := r.db.WithContext(ctx).Model(&model.RequestExecution{}).
		Where("id = ?", id).
		Update("end_lease_at", val)
	if err := stmt.Error; err != nil {
		return fmt.Errorf("repository requestExecution: UpdateEndLeaseAt: %w", err)
	}

	return nil
}
