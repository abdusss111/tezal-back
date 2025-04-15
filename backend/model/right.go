package model

type Right struct {
	ID          int    `json:"id"`
	Name        string `json:"name"`
	Description string `json:"description"`
}

type RoleRight struct {
	RoleID  int `json:"role_id" gorm:"foreignKey:ID"`
	RightID int `json:"right_id" gorm:"foreignKey:ID"`
}
