package model

type AdClinetStatByID struct {
	Amount int    `json:"amount"`
	Status string `json:"status"`
}

type AdSpecializedMachineryStatByID struct {
	Amount int    `json:"amount"`
	Status string `json:"status"`
}

type RequestExectionHistory struct {
	ID            int    `json:"id"`
	Status        string `json:"status"`
	StartStatusAt Time   `json:"start_status_at"`
	EndStatusAt   Time   `json:"end_status_at"`
	Duration      int    `json:"duration"`
	WorkStartedAt Time   `json:"work_started_at"`
	WorkEndAt     Time   `json:"work_end_at"`
	Rate          int    `json:"rate"`
}

type RequestExectionStatusTime struct {
	AwaitsStart int `json:"awaits_start"`
	Working     int `json:"working"`
	Pause       int `json:"pause"`
	Finished    int `json:"finished"`
	OnRoad      int `json:"on_road"`
	TotalWork   int `json:"total_work" gorm:"-"`
	Total       int `json:"total" gorm:"-"`
}

type SubCategoryCount struct {
	ID    int    `json:"id"`
	Name  string `json:"name"`
	Count int    `json:"count"`
}

type FilterSubCategoryCount struct {
	IDs    []int
	CityID *int
}

type CategoryCount struct {
	ID    int    `json:"id"`
	Name  string `json:"name"`
	Count int    `json:"count"`
}

type FilterCategoryCount struct {
	IDs    []int
	CityID *int
}
