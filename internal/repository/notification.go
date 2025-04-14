package repository

import (
	"strings"

	"github.com/jackc/pgx/v5/pgconn"
	"gitlab.com/eqshare/eqshare-back/model"
	"gorm.io/gorm"
)

type INotification interface {
	SaveDeviceToken(token model.DeviceToken) error
	GetDeviceToken(token model.DeviceToken) ([]string, error)
	ExistDeviceToken(token model.DeviceToken) (bool, error)
	//GetMultiDeviceToken(userIds []int) (tokensStr []string, err error)
}

type notification struct {
	db *gorm.DB
}

func NewNotificationRepository(db *gorm.DB) *notification {
	return &notification{
		db: db,
	}
}

func (a *notification) SaveDeviceToken(token model.DeviceToken) error {
	resC := a.db.Create(&token)
	if errPG, ok := resC.Error.(*pgconn.PgError); ok {
		if errPG.ConstraintName != "device_tokens_pk" {
			return resC.Error
		}
	}

	if resC.RowsAffected != 0 {
		return nil
	}

	resU := a.db.Model(&token).Where("token = ?", token.Token).Update("user_id", token.UserID)
	if resU.Error != nil {
		return resU.Error
	}

	return nil
}

func (a *notification) GetDeviceToken(token model.DeviceToken) (tokensStr []string, err error) {
	var tokens []model.DeviceToken
	if err = a.db.Model(&model.DeviceToken{}).
		Where("user_id = ? AND deleted_at IS NULL", token.UserID).
		Find(&tokens).Error; err != nil {
		return tokensStr, err
	}

	for i := range tokens {
		tokensStr = append(tokensStr, strings.TrimSpace(tokens[i].Token))
	}

	return tokensStr, nil
}

//func (a *notification) GetMultiDeviceToken(userIds []int) (tokensStr []string, err error) {
//	var tokens []model.DeviceToken
//	if len(userIds) == 0 {
//		return nil, nil
//	} else if len(userIds) == 1 {
//		if err = a.db.Model(&model.DeviceToken{}).Where("user_id = ?", userIds).Find(&tokens).Error; err != nil {
//			return tokensStr, err
//		}
//	} else {
//		if err = a.db.Model(&model.DeviceToken{}).Where("user_id IN ?", userIds).Find(&tokens).Error; err != nil {
//			return tokensStr, err
//		}
//	}
//
//	for i := range tokens {
//		tokensStr = append(tokensStr, tokens[i].Token)
//	}
//
//	return tokensStr, nil
//}

func (a *notification) ExistDeviceToken(token model.DeviceToken) (bool, error) {
	res := a.db.Model(&model.DeviceToken{}).Where("token = ?", token.Token).Find(&token)

	if err := res.Error; err != nil {
		return false, err
	}

	if res.RowsAffected == 0 {
		return false, nil
	}

	return true, nil
}
