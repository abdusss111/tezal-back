package model

import "time"

type Owner struct {
	CreatedAt time.Time `json:"created_at"`
	UserID    int       `json:"user_id" gorm:"index"`
	User      User      `json:"user" gorm:"foreignKey:ID;references:UserID"`
	Worker    []User    `json:"worker" gorm:"many2many:owners_users;joinForeignKey:OwnerID;joinReferences:WorkerID;foreignKey:UserID;" `
}

type FilterOwner struct {
	IDs     []int
	UserIDs []int
}
