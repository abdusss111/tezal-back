package repository

import (
	"errors"

	"gitlab.com/eqshare/eqshare-back/model"
	"gorm.io/gorm"
	"gorm.io/gorm/clause"
)

type IAuthentication interface {
	GetTokenByUUID(uuid string) (string, error)
	SaveToken(userID int, uuid, token string) error
	DeleteTokenByUUID(uuid string) error
	GetUUIDByUserID(userID int) (string, error)
}

type auth struct {
	db *gorm.DB
}

func NewAuthentication(db *gorm.DB) *auth {
	return &auth{
		db: db,
	}
}

func (a *auth) GetTokenByUUID(uuid string) (string, error) {
	var token string

	row := a.db.Table("authentications").Where("uuid = ?", uuid).Select("token").Row()
	if err := row.Scan(&token); err != nil {
		if errors.Is(err, gorm.ErrRecordNotFound) {
			return token, model.ErrNotFound
		}
		return token, err
	}

	return token, nil
}

func (a *auth) SaveToken(userID int, uuid, token string) error {
	type authentication struct {
		UUID   string
		UserID int
		Token  string
	}

	res := a.db.Table("authentications").Clauses(
		// clause.OnConflict{
		// 	Columns:   []clause.Column{{Name: "uuid"}},
		// 	DoUpdates: clause.AssignmentColumns([]string{"uuid", "user_id", "token"}),
		// },
		clause.OnConflict{
			Columns:   []clause.Column{{Name: "user_id"}},
			DoUpdates: clause.AssignmentColumns([]string{"uuid", "user_id", "token"}),
		},
	).Create(&authentication{
		UUID:   uuid,
		UserID: userID,
		Token:  token,
	})

	if res.Error != nil {
		return res.Error
	}

	return nil
}

func (a *auth) DeleteTokenByUUID(uuid string) error {
	type authentication struct {
		UUID   string
		UserID int
		Token  string
	}

	res := a.db.Table("authentications").Where("uuid = ?", uuid).Delete(&authentication{})
	if res.Error != nil {
		return nil
	} else if res.RowsAffected == 0 {
		return model.ErrNotFound
	}

	return nil
}

func (a *auth) GetUUIDByUserID(userID int) (string, error) {
	var uuid string

	row := a.db.Table("authentications").Where("user_id = ?", userID).Select("uuid").Row()
	if err := row.Scan(&uuid); err != nil {
		if errors.Is(err, gorm.ErrRecordNotFound) {
			return uuid, model.ErrNotFound
		}
		return uuid, err
	}

	return uuid, nil
}
