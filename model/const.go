package model

import (
	"errors"
)

// пишется константы

// статут заявки
const (
	STATUS_CREATED        = "CREATED"
	STATUS_REVISED_CLIENT = "REVISED_CLIENT"
	STATUS_REVISED_DRIVER = "REVISED_DRIVER"
	STATUS_APPROVED       = "APPROVED"
	STATUS_CANCELED       = "CANCELED"
	STATUS_DELETED        = "DELETED"
)

const (
	STATUS_AWAITS_START = "AWAITS_START"
	STATUS_WORKING      = "WORKING"
	STATUS_PAUSE        = "PAUSE"
	STATUS_FINISHED     = "FINISHED"
	STATUS_ON_ROAD      = "ON_ROAD"

	STATUS_RESUME = "RESUME"
)

// еденицы измерения
const (
// ч
)

// для валидации проверки есть ли такая роль или нет
var ListRole map[string]struct{} = map[string]struct{}{
	ROLE_CLIENT: {},
	ROLE_DRIVER: {},
	ROLE_ADMIN:  {},
	ROLE_OWNER:  {},
}

const (
	ROLE_CLIENT = "CLIENT"
	ROLE_DRIVER = "DRIVER"
	ROLE_ADMIN  = "ADMIN"
	ROLE_OWNER  = "OWNER"
)

// роли в кирилице
const (
	ROLE_CLIENT_READ = "Клиент"
	ROLE_DRIVER_READ = "Водитель"
)

const (
	UserID = "userID"
)

const (
	TypeRequestSM             = "SM"
	TypeRequestSMClient       = "SM_CLIENT"
	TypeRequestEq             = "EQ"
	TypeRequestEqClient       = "EQ_CLIENT"
	TypeRequestCM             = "CM"
	TypeRequestCMClient       = "CM_CLIENT"
	TypeRequestSVC            = "SVC"
	TypeRequestSVCClient      = "SVC_CLIENT"
	NotificationTypeCM        = "request_ad_cm"
	NotificationTypeCMClient  = "request_ad_cm_client"
	NotificationTypeEQ        = "request_ad_equipment"
	NotificationTypeEQClient  = "request_ad_equipment_client"
	NotificationTypeSVC       = "request_ad_service"
	NotificationTypeSVCClient = "request_ad_service_client"
	NotificationTypeSM        = "request_ad_sm"
	NotificationTypeSMClient  = "request_ad_sm_client"
)

const (
	Kazakstan = 92
)

var SmsError = errors.New("ошибка при отправке сообщения")
var InvalidPhoneNumber = errors.New("invalid phone number")
