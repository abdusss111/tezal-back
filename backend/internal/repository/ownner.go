package repository

import (
	"context"

	"github.com/jackc/pgx/v5/pgconn"
	"gitlab.com/eqshare/eqshare-back/model"
	"gorm.io/gorm"
	"gorm.io/gorm/clause"
)

type IOwner interface {
	Create(owner model.Owner) error
	// GetByUserID(userID int) (model.Owner, error)
	GetByID(id int) (model.Owner, error)
	Get(f model.FilterOwner) ([]model.Owner, error)
	AddWorker(ownerID, workerID int) error
	DeleteWorker(ownerID, workerID int) error
	Deleted(id int) error
	GetOwnerDriverRequest(ownerID, driverID int) (*model.OwnerDriverRequests, error)
	GetOwnerDriverRequests(driverId int) ([]*model.OwnerDriverRequests, error)
	DeleteOwnerDriverRequest(ownerID, driverID int) error
	CreateOwnerDriverRequest(request model.OwnerDriverRequests) error
	UpdateOwnerDriverRequest(request *model.OwnerDriverRequests) error
	AddDriverToOwner(ownerID, driverID int) error
}

type owner struct {
	db *gorm.DB
}

func NewOwner(db *gorm.DB) *owner {
	return &owner{db: db}
}

func (o *owner) Create(owner model.Owner) error {
	return o.db.Create(&owner).Error
}

// func (o *owner) GetByUserID(userID int) (model.Owner, error) {
// 	owner := model.Owner{}
// 	return model.Owner{}, o.db.Model(&model.Owner{}).Find(&owner, "user_id = ?", userID).Error
// }

func (o *owner) GetByID(id int) (model.Owner, error) {
	owner := model.Owner{}
	res := o.db.Model(&model.Owner{}).Preload(clause.Associations).Find(&owner, "user_id = ?", id)
	if res.Error != nil {
		return model.Owner{}, res.Error
	}

	if res.RowsAffected == 0 {
		return owner, model.ErrNotFound
	}

	return owner, nil
}

func (o *owner) Get(f model.FilterOwner) ([]model.Owner, error) {
	owmers := make([]model.Owner, 0)

	stmt := o.db.Model(&model.Owner{}).Preload("User").Order("created_at DESC")

	if f.IDs != nil {
		stmt = stmt.Where("id in (?)", f.IDs)
	}

	if f.UserIDs != nil {
		stmt = stmt.Where("user_id in (?)", f.UserIDs)
	}

	return owmers, stmt.Find(&owmers).Error
}

func (o *owner) AddWorker(ownerID, workerID int) error {
	err := o.db.Exec(`
	INSERT INTO owners_users (owner_id, worker_id)
	VALUES (?, ?);`, ownerID, workerID).Error
	if err != nil {
		if errPG, ok := err.(*pgconn.PgError); ok && errPG.ConstraintName == "owners_users_pk" {
			return nil
		}
		return err
	}

	return nil
}

func (o *owner) DeleteWorker(ownerID, workerID int) error {
	return o.db.Exec(`
	DELETE
	FROM owners_users
	WHERE owner_id = ? AND worker_id = ?;`, ownerID, workerID).Error
}

func (o *owner) Deleted(id int) error {
	return o.db.Transaction(func(tx *gorm.DB) error {
		ctx, cansel := context.WithCancel(context.Background())
		defer cansel()

		workerIDs := make([]int, 0)

		if err := tx.WithContext(ctx).
			Table("owners_users").Where("owner_id = ?", id).
			Select("worker_id").Find(&workerIDs).
			Error; err != nil {
			return err
		}

		if err := tx.WithContext(ctx).
			Model(&model.User{}).Where("id in (?)", workerIDs).
			Update("owner_id", nil).Error; err != nil {
			return err
		}

		if err := tx.WithContext(ctx).Exec(`
			DELETE
			FROM owners_users
			WHERE owner_id = ?`, id).Error; err != nil {
			return err
		}

		if err := tx.WithContext(ctx).Delete(&model.Owner{}, "user_id", id).Error; err != nil {
			return err
		}

		return nil
	})
}

func (o *owner) GetOwnerDriverRequest(ownerID, driverID int) (*model.OwnerDriverRequests, error) {
	var request model.OwnerDriverRequests
	//err := o.db.Where("owner_id = ? AND driver_id = ?", ownerID, driverID).First(&request).Error

	err := o.db.Table("owner_driver_requests AS odr").
		Select("odr.owner_id, odr.driver_id, CONCAT(u.first_name, ' ', u.last_name) AS full_name, odr.status, odr.created_at, odr.updated_at").
		//Joins("JOIN owners_users AS ou ON ou.owner_id = odr.owner_id").
		//Joins("JOIN owners AS o ON o.user_id = ou.owner_id").
		Joins("JOIN users AS u ON u.id = odr.owner_id").
		Where("odr.owner_id = ? AND odr.driver_id = ?", ownerID, driverID).
		First(&request).Error

	if err != nil {
		return &request, err
	}
	return &request, nil
}

func (o *owner) DeleteOwnerDriverRequest(ownerID, driverID int) error {
	err := o.db.Table("owner_driver_requests").
		Where("owner_id = ? AND driver_id = ?", ownerID, driverID).
		Delete(nil).Error

	if err != nil {
		return err
	}
	return nil
}

func (o *owner) GetOwnerDriverRequests(driverId int) ([]*model.OwnerDriverRequests, error) {
	var requests []*model.OwnerDriverRequests
	//err := o.db.Model(&model.OwnerDriverRequests{}).Where("driver_id = ?", driverId).Find(&requests).Error

	err := o.db.Table("owner_driver_requests AS odr").
		Select("odr.owner_id, odr.driver_id, CONCAT(u.first_name, ' ', u.last_name) AS full_name, odr.status, odr.created_at, odr.updated_at").
		//Joins("JOIN owners_users AS ou ON ou.owner_id = odr.owner_id").
		//Joins("JOIN owners AS o ON o.user_id = ou.owner_id").
		Joins("JOIN users AS u ON u.id = odr.owner_id").
		Where("odr.driver_id = ?", driverId).
		Find(&requests).Error

	if err != nil {
		return requests, err
	}
	return requests, nil
}

func (o *owner) CreateOwnerDriverRequest(request model.OwnerDriverRequests) error {
	err := o.db.Create(&request).Error

	//err := o.db.Model(&model.OwnerDriverRequests{}).Where("full_name is null").Update("full_name", request.FullName).Error
	//if err != nil {
	//	return err
	//}

	return err
}

func (o *owner) UpdateOwnerDriverRequest(request *model.OwnerDriverRequests) error {
	return o.db.Model(&model.OwnerDriverRequests{}).
		Where("owner_id = ? AND driver_id = ?", request.OwnerID, request.DriverID).
		Update("status", request.Status).Error
}

func (o *owner) AddDriverToOwner(ownerID, driverID int) error {
	// Добавляем запись в таблицу связей владельцев и водителей
	err := o.db.Exec(`
        INSERT INTO owners_users (owner_id, worker_id)
        VALUES (?, ?)
        ON CONFLICT DO NOTHING;`, ownerID, driverID).Error
	if err != nil {
		return err
	}

	// Обновляем поле OwnerID у водителя
	return o.db.Model(&model.User{}).
		Where("id = ?", driverID).
		Update("owner_id", ownerID).Error
}
