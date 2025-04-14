package model

import "time"

type AdClientCreationSubscription struct {
	ID            int       `json:"id"`
	CreatedAt     time.Time `json:"created_at"`
	UserID        int       `json:"user_id"`
	Src           string    `json:"src"`
	SubCategoryID *int      `json:"sub_category_id"`
	CityID        *int      `json:"city_id"`
	TypeID        *int      `json:"type_id"`
}
