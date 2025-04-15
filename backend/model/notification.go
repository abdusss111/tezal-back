package model

type Notification struct {
	// ServiceCode string
	DeviceTokens []string
	Message      string
	Tittle       string
	Data         map[string]string
}
