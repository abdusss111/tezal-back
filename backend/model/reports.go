package model

type AdReport struct {
	AdType       string  `json:"ad_type"`
	AdAmount     float32 `json:"ad_amount"`
	CategoryType string  `json:"category_type"`
	CategoryID   int     `json:"category_id"`
}

type RequestByStatusReport struct {
	RequestAmount float32 `json:"request_amount"`
	Status        string  `json:"status"`
}
