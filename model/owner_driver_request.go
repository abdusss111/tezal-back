package model

import "time"

type OwnerDriverRequests struct {
	OwnerID   int       `json:"owner_id"`
	DriverID  int       `json:"driver_id"`
	FullName  string    `json:"full_name"`
	Status    string    `json:"status"`
	CreatedAt time.Time `json:"created_at"`
	UpdatedAt time.Time `json:"updated_at"`
}
