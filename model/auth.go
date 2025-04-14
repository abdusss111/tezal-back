package model

import (
	"errors"
	"time"
)

var CodeExpired = errors.New("code expired")
var CodeMismatch = errors.New("code does not match")

type SignIn struct {
	PhoneNumber string `json:"phone_number"`
	Password    string `json:"password"`
}

type SignUp struct {
	FirstName   string    `json:"first_name"`
	LastName    string    `json:"last_name"`
	CityID      uint      `json:"city_id"`
	PhoneNumber string    `json:"phone_number"`
	Password    string    `json:"password"`
	Document    *Document `json:"-"`
	Email       string    `json:"email"`
}

type SendCode struct {
	PhoneNumber string `json:"phone_number"`
}

type ConfirmCode struct {
	PhoneNumber string `json:"phone_number"`
	Code        int    `json:"code"`
}

type Claim struct {
	Audience  string `json:"aud,omitempty"`
	ExpiresAt int64  `json:"exp,omitempty"`
	Id        string `json:"jti,omitempty"`
	IssuedAt  int64  `json:"iat,omitempty"`
	Issuer    string `json:"iss,omitempty"`
	NotBefore int64  `json:"nbf,omitempty"`
	Subject   string `json:"sub,omitempty"`
}

type Token struct {
	Access  string `json:"access"`
	Refresh string `json:"refresh"`
}

type DeviceToken struct {
	ID        int       `json:"id"`
	UserID    int       `json:"user_id"`
	Token     string    `json:"token"`
	CreatedAt time.Time `json:"-" gorm:"<-:create;"`
	UpdatedAt time.Time `json:"-" gorm:"<-:update;"`
}
