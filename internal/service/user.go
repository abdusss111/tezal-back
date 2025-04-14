package service

import (
	"context"
	"errors"
	"fmt"
	"gitlab.com/eqshare/eqshare-back/internal/client/sms"
	"gitlab.com/eqshare/eqshare-back/internal/client/smtp"
	"gitlab.com/eqshare/eqshare-back/pkg/util"
	"log"
	"time"

	"gitlab.com/eqshare/eqshare-back/internal/client"
	"gitlab.com/eqshare/eqshare-back/internal/repository"
	"gitlab.com/eqshare/eqshare-back/model"
)

type IUser interface {
	Create(role model.User) (model.User, error)
	Get(f model.FilterUser) ([]model.User, error)
	GetByID(id int) (model.User, error)
	Update(user model.User) error
	Delete(id int) error
	UpdateUserName(user model.User) error
	UpdateNickName(user model.User) error
	UpdateFoto(user model.User, isCustom bool) *string
	ResetPassword(email string, phone string) error
}

type user struct {
	repo    repository.IUser
	remotes client.DocumentsRemote
	smtp    client.SMTPClient
	sms     client.SMSClient
}

func NewUser(repo repository.IUser, remotes client.DocumentsRemote, smtp client.SMTPClient, sms client.SMSClient) *user {
	return &user{repo: repo,
		remotes: remotes,
		smtp:    smtp,
		sms:     sms,
	}
}

func (u *user) Create(user model.User) (model.User, error) {
	hashedPass, err := hashPassword(user.Password)
	if err != nil {
		return model.User{}, errors.New("failed to hash password")
	}
	user.Password = hashedPass
	us, err := u.repo.Create(user)

	if err != nil {
		return model.User{}, fmt.Errorf("service user: Create err: %w", err)
	}

	if us.Document != nil {
		_, err = u.remotes.Upload(context.Background(), *us.Document)
		if err != nil {
			return model.User{}, fmt.Errorf("service user: Create Upload err: %w", err)
		}
	}

	return us, nil
}

func (u *user) Get(f model.FilterUser) ([]model.User, error) {
	res, err := u.repo.Get(f)
	if err != nil {
		return nil, fmt.Errorf("service user: Get err: %w", err)
	}

	for i := range res {
		if res[i].Document != nil {
			d, err := u.remotes.Share(context.Background(), *res[i].Document, time.Hour*1)
			if err != nil {
				return nil, fmt.Errorf("service user: Get Share Document err: %w", err)
			}
			res[i].UrlDocument = &d.ShareLink
			log.Printf("UrlDocument: %s", *res[i].UrlDocument)
		}

		if res[i].CustomDocument != nil {
			d, err := u.remotes.Share(context.Background(), *res[i].CustomDocument, time.Hour*1)
			if err != nil {
				return nil, fmt.Errorf("service user: Get Share Custom Document err: %w", err)
			}
			res[i].CustomUrlDocument = &d.ShareLink
			log.Printf("CustomUrlDocument: %s", *res[i].CustomUrlDocument)
		}
	}

	return res, nil
}

func (u *user) GetByID(id int) (model.User, error) {
	user, err := u.repo.GetByID(id)
	if err != nil {
		return model.User{}, fmt.Errorf("service user: GetByID err: %w", err)
	}

	if user.Document != nil {
		d, err := u.remotes.Share(context.Background(), *user.Document, time.Hour*1)
		if err != nil {
			return model.User{}, fmt.Errorf("service user: GetByID GetDocument err: %w", err)
		}
		user.Document = &d
		user.UrlDocument = &d.ShareLink
	}

	if user.CustomDocument != nil {
		d, err := u.remotes.Share(context.Background(), *user.CustomDocument, time.Hour*1)
		if err != nil {
			return model.User{}, fmt.Errorf("service user: GetByID GetDocument err: %w", err)
		}
		user.CustomDocument = &d
		user.CustomUrlDocument = &d.ShareLink
	}

	return user, nil
}

func (u *user) Update(user model.User) (err error) {
	user.Password, err = hashPassword(user.Password)
	if err != nil {
		return err
	}

	return u.repo.Update(user)
}

func (u *user) Delete(id int) error {
	return u.repo.Delete(id)
}

func (u *user) UpdateUserName(user model.User) error {
	return u.repo.UpdateUserName(user)
}

func (u *user) UpdateNickName(user model.User) error {
	return u.repo.UpdateNickName(user)
}

func (u *user) UpdateFoto(user model.User, isCustom bool) *string {
	userOld, err := u.repo.GetByID(user.ID)
	if err != nil {
		errorMessage := fmt.Sprintf("service user: UpdateFoto err: %v", err)
		return &errorMessage
	}

	if isCustom {
		userOld.CustomDocument = user.CustomDocument
	} else {
		userOld.Document = user.Document
	}

	err = u.repo.UpdateFoto(userOld, isCustom)
	if err != nil {
		errorMessage := fmt.Sprintf("service user: UpdateFoto err: %v", err)
		return &errorMessage
	}

	var documentUrl *string

	// Загрузка и генерация ссылки на фотографию
	if isCustom {
		_, err = u.remotes.Upload(context.Background(), *user.CustomDocument)
		if err != nil {
			errorMessage := fmt.Sprintf("service user: UpdateFoto UploadFoto err: %v", err)
			return &errorMessage
		}

		// Генерация ссылки на документ
		doc, err := u.remotes.Share(context.Background(), *user.CustomDocument, time.Hour)
		if err != nil {
			errorMessage := fmt.Sprintf("service user: UpdateFoto Share err: %v", err)
			return &errorMessage
		}

		documentUrl = &doc.ShareLink // Используем поле ShareLink, которое является строкой
	} else {
		_, err = u.remotes.Upload(context.Background(), *user.Document)
		if err != nil {
			errorMessage := fmt.Sprintf("service user: UpdateFoto UploadFoto err: %v", err)
			return &errorMessage
		}

		// Генерация ссылки на документ
		doc, err := u.remotes.Share(context.Background(), *user.Document, time.Hour)
		if err != nil {
			errorMessage := fmt.Sprintf("service user: UpdateFoto Share err: %v", err)
			return &errorMessage
		}

		documentUrl = &doc.ShareLink // Используем поле ShareLink, которое является строкой
	}

	return documentUrl
}

func (u *user) ResetPassword(email string, phone string) error {
	temporaryPassword, err := util.GenerateTemporaryPassword(4)
	if err != nil {
		return fmt.Errorf("failed to generate temporary password: %v", err)
	}

	resetUser := model.User{}

	if email != "" {
		resetUser, err = u.repo.GetByEmail(email)
		if err != nil || resetUser.ID == 0 {
			return errors.New("user not found")
		}
		updatedAtInFixedZone := time.Date(
			resetUser.UpdatedAt.Year(), resetUser.UpdatedAt.Month(), resetUser.UpdatedAt.Day(),
			resetUser.UpdatedAt.Hour(), resetUser.UpdatedAt.Minute(), resetUser.UpdatedAt.Second(),
			resetUser.UpdatedAt.Nanosecond(), util.TimeZone)

		if time.Since(updatedAtInFixedZone) < time.Hour {
			return errors.New("too many tries, please try again later")
		}

		subject := smtp.ResetPasswordSubject
		body := fmt.Sprintf(smtp.ResetPasswordBody, resetUser.FirstName, temporaryPassword)
		err = u.smtp.SendSingle(resetUser.Email, subject, body)
		if err != nil {
			return fmt.Errorf("error senging reset password email: %v", err)
		}

	} else if phone != "" {
		resetUser, err = u.repo.GetByPhoneNumber(phone)
		if err != nil || resetUser.ID == 0 {
			return errors.New("user not found")
		}

		updatedAtInFixedZone := time.Date(
			resetUser.UpdatedAt.Year(), resetUser.UpdatedAt.Month(), resetUser.UpdatedAt.Day(),
			resetUser.UpdatedAt.Hour(), resetUser.UpdatedAt.Minute(), resetUser.UpdatedAt.Second(),
			resetUser.UpdatedAt.Nanosecond(), util.TimeZone)

		if time.Since(updatedAtInFixedZone) < time.Hour {
			return errors.New("too many tries, please try again later")
		}

		message := fmt.Sprintf(sms.ResetPasswordSMSMessage, temporaryPassword)
		err = u.sms.SendSingle(phone, message)
		if err != nil {
			return fmt.Errorf("error senging reset password phone: %v", err)
		}
	} else {
		return fmt.Errorf("user does not have email or phone")
	}
	newPassword, err := hashPassword(temporaryPassword)
	if err != nil {
		return fmt.Errorf("error hashing password %v", err)
	}

	err = u.repo.UpdatePassword(resetUser.ID, newPassword)
	if err != nil {
		return fmt.Errorf("error storing password %v", err)
	}

	return nil
}
