package model

type Role struct {
	ID          int     `json:"id"`
	Name        string  `json:"name"`
	Description string  `json:"description"`
	Rights      []Right `json:"rights,omitempty" gorm:"many2many:role_right"`
}

type UserRole struct {
	UserID int `json:"user_id" gorm:"foreignKey:ID"`
	RoleID int `json:"role_id" gorm:"foreignKey:ID"`
}
