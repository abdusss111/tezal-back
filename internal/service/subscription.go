package service

import (
	"context"
	"fmt"
	"strconv"

	"gitlab.com/eqshare/eqshare-back/internal/client"
	"gitlab.com/eqshare/eqshare-back/internal/repository"
	"gitlab.com/eqshare/eqshare-back/model"
)

type subscription struct {
	repo          repository.ISubscription
	messageClient client.NotificationClient
}

type ISubscription interface {
	SubscriptionToCreateAdClientSM(ctx context.Context, userID int, subCategoryID []int, cityID []int) error
	SubscriptionToCreateAdClientEQ(ctx context.Context, userID int, typeID []int, cityID []int) error
	SubscriptionToCreateAdClientCM(ctx context.Context, userID int, subCategoryID []int, cityID []int) error
	SubscriptionToCreateAdClientSVC(ctx context.Context, userID int, subCategoryID []int, cityID []int) error

	UnsubscriptionToCreateAdClientSM(ctx context.Context, userID int, typeID []int) error
	UnsubscriptionToCreateAdClientEQ(ctx context.Context, userID int, subCategoryID []int) error
	UnsubscriptionToCreateAdClientCM(ctx context.Context, userID int, subCategoryID []int) error
	UnsubscriptionToCreateAdClientSVC(ctx context.Context, userID int, subCategoryID []int) error

	SendOutNoticeAdClientSM(ctx context.Context, subCategoryID int, message, title string, adID int, cityID int) error
	SendOutNoticeAdClientEQ(ctx context.Context, typeID int, message, title string, adID int, cityID int) error
	SendOutNoticeAdClientCM(ctx context.Context, typeID int, message, title string, adID int, cityID int) error
	SendOutNoticeAdClientSVC(ctx context.Context, typeID int, message, title string, adID int, cityID int) error

	GetToCreateAdClientSM(ctx context.Context, userID int) ([]model.AdClientCreationSubscription, error)
	GetToCreateAdClientEQ(ctx context.Context, userID int) ([]model.AdClientCreationSubscription, error)
	GetToCreateAdClientCM(ctx context.Context, userID int) ([]model.AdClientCreationSubscription, error)
	GetToCreateAdClientSVC(ctx context.Context, userID int) ([]model.AdClientCreationSubscription, error)
}

func NewSubscription(repo repository.ISubscription, messageClient client.NotificationClient) ISubscription {
	return &subscription{
		repo:          repo,
		messageClient: messageClient,
	}
}

func (service *subscription) GetToCreateAdClientSM(ctx context.Context, userID int) ([]model.AdClientCreationSubscription, error) {
	subs, err := service.repo.GetToCreateAdClient(ctx, model.TypeRequestSMClient, userID)
	if err != nil {
		return nil, err
	}

	return subs, nil
}

func (service *subscription) GetToCreateAdClientEQ(ctx context.Context, userID int) ([]model.AdClientCreationSubscription, error) {
	subs, err := service.repo.GetToCreateAdClient(ctx, model.TypeRequestEqClient, userID)
	if err != nil {
		return nil, err
	}

	return subs, nil
}

func (service *subscription) SubscriptionToCreateAdClientSM(ctx context.Context, userID int, typeID []int, cityID []int) error {
	subs := make([]model.AdClientCreationSubscription, 0, len(typeID))

	for _, cat := range typeID {
		for _, cityForSubs := range cityID {
			cat := cat
			cityForSubs := cityForSubs
			subs = append(subs, model.AdClientCreationSubscription{
				UserID: userID,
				Src:    model.TypeRequestSMClient,
				CityID: &cityForSubs,
				TypeID: &cat,
			})
		}
	}

	err := service.repo.Create(ctx, subs)
	if err != nil {
		return err
	}

	return nil
}

func (service *subscription) SubscriptionToCreateAdClientEQ(ctx context.Context, userID int, subCategoryID []int, cityID []int) error {
	subs := make([]model.AdClientCreationSubscription, 0, len(subCategoryID))

	for _, cat := range subCategoryID {
		for _, cityForSubs := range cityID {
			cat := cat
			cityForSubs := cityForSubs
			subs = append(subs, model.AdClientCreationSubscription{
				UserID:        userID,
				Src:           model.TypeRequestEqClient,
				CityID:        &cityForSubs,
				SubCategoryID: &cat,
			})
		}
	}

	err := service.repo.Create(ctx, subs)
	if err != nil {
		return err
	}

	return nil
}

func (service *subscription) UnsubscriptionToCreateAdClientSM(ctx context.Context, userID int, typeID []int) error {
	err := service.repo.Delete(ctx, userID, model.TypeRequestSMClient, nil, typeID)
	if err != nil {
		return err
	}

	return nil
}

func (service *subscription) UnsubscriptionToCreateAdClientEQ(ctx context.Context, userID int, subCategoryID []int) error {
	err := service.repo.Delete(ctx, userID, model.TypeRequestEqClient, subCategoryID, nil)
	if err != nil {
		return err
	}

	return nil
}

func (service *subscription) SendOutNoticeAdClientSM(ctx context.Context, typeID int, message, title string, adID int, cityID int) error {
	dv, err := service.repo.GetDeviceTokenBySrc(ctx, model.AdClientCreationSubscription{
		Src:    model.TypeRequestSMClient,
		TypeID: &typeID,
		CityID: &cityID,
	})
	if err != nil {
		return err
	}

	tokens := make([]string, 0)
	for _, d := range dv {
		tokens = append(tokens, d.Token)
	}

	if len(tokens) == 0 {
		return nil
	}

	err = service.messageClient.Send(ctx, model.Notification{
		DeviceTokens: tokens,
		Message:      message,
		Tittle:       title,
		Data: map[string]string{
			"id":   strconv.Itoa(adID),
			"type": model.TypeRequestCMClient,
		},
	})
	if err != nil {
		return err
	}

	return nil
}

func (service *subscription) SendOutNoticeAdClientEQ(ctx context.Context, subCategoryID int, message, title string, adID int, cityID int) error {
	dv, err := service.repo.GetDeviceTokenBySrc(ctx, model.AdClientCreationSubscription{
		Src:           model.TypeRequestEqClient,
		SubCategoryID: &subCategoryID,
		CityID:        &cityID,
	})
	if err != nil {
		return err
	}

	tokens := make([]string, 0)
	for _, d := range dv {
		tokens = append(tokens, d.Token)
	}

	if len(tokens) == 0 {
		return nil
	}

	err = service.messageClient.Send(ctx, model.Notification{
		DeviceTokens: tokens,
		Message:      message,
		Tittle:       title,
		Data: map[string]string{
			"id":   strconv.Itoa(adID),
			"type": model.TypeRequestEqClient,
		},
	})
	if err != nil {
		return err
	}

	return nil
}

func (service *subscription) SendOutNoticeAdClientCM(ctx context.Context, subCategoryID int, message, title string, adID int, cityID int) error {
	dv, err := service.repo.GetDeviceTokenBySrc(ctx, model.AdClientCreationSubscription{
		Src:           model.TypeRequestCMClient,
		SubCategoryID: &subCategoryID,
		CityID:        &cityID,
	})
	if err != nil {
		return err
	}

	tokens := make([]string, 0)
	for _, d := range dv {
		tokens = append(tokens, d.Token)
	}

	if len(tokens) == 0 {
		return nil
	}

	err = service.messageClient.Send(ctx, model.Notification{
		DeviceTokens: tokens,
		Message:      message,
		Tittle:       title,
		Data: map[string]string{
			"id":   strconv.Itoa(adID),
			"type": model.TypeRequestCMClient,
		},
	})
	if err != nil {
		return err
	}

	return nil
}

func (service *subscription) SendOutNoticeAdClientSVC(ctx context.Context, subCategoryID int, message, title string, adID int, cityID int) error {
	dv, err := service.repo.GetDeviceTokenBySrc(ctx, model.AdClientCreationSubscription{
		Src:           model.TypeRequestSVCClient,
		SubCategoryID: &subCategoryID,
		CityID:        &cityID,
	})
	if err != nil {
		return err
	}

	tokens := make([]string, 0)
	for _, d := range dv {
		tokens = append(tokens, d.Token)
	}

	if len(tokens) == 0 {
		return nil
	}
	fmt.Println()
	err = service.messageClient.Send(ctx, model.Notification{
		DeviceTokens: tokens,
		Message:      message,
		Tittle:       title,
		Data: map[string]string{
			"id":   strconv.Itoa(adID),
			"type": model.TypeRequestSVCClient,
		},
	})
	if err != nil {
		return err
	}

	return nil
}

func (service *subscription) GetToCreateAdClientCM(ctx context.Context, userID int) ([]model.AdClientCreationSubscription, error) {
	subs, err := service.repo.GetToCreateAdClient(ctx, model.TypeRequestCMClient, userID)
	if err != nil {
		return nil, err
	}

	return subs, nil
}

func (service *subscription) SubscriptionToCreateAdClientCM(ctx context.Context, userID int, subCategoryID []int, cityID []int) error {
	subs := make([]model.AdClientCreationSubscription, 0, len(subCategoryID))

	for _, cat := range subCategoryID {
		for _, cityForSubs := range cityID {
			cat := cat
			cityForSubs := cityForSubs
			subs = append(subs, model.AdClientCreationSubscription{
				UserID:        userID,
				Src:           model.TypeRequestCMClient,
				CityID:        &cityForSubs,
				SubCategoryID: &cat,
			})
		}
	}

	err := service.repo.Create(ctx, subs)
	if err != nil {
		return err
	}

	return nil
}

func (service *subscription) UnsubscriptionToCreateAdClientCM(ctx context.Context, userID int, subCategoryID []int) error {
	err := service.repo.Delete(ctx, userID, model.TypeRequestCMClient, subCategoryID, nil)
	if err != nil {
		return err
	}

	return nil
}

func (service *subscription) GetToCreateAdClientSVC(ctx context.Context, userID int) ([]model.AdClientCreationSubscription, error) {
	subs, err := service.repo.GetToCreateAdClient(ctx, model.TypeRequestSVCClient, userID)
	if err != nil {
		return nil, err
	}

	return subs, nil
}

func (service *subscription) SubscriptionToCreateAdClientSVC(ctx context.Context, userID int, subCategoryID []int, cityID []int) error {
	subs := make([]model.AdClientCreationSubscription, 0, len(subCategoryID))

	for _, cat := range subCategoryID {
		if len(cityID) == 0 {
			cityID = append(cityID, 0)
		}
		for _, cityForSubs := range cityID {
			cat := cat
			cityForSubs := cityForSubs
			subs = append(subs, model.AdClientCreationSubscription{
				UserID:        userID,
				Src:           model.TypeRequestSVCClient,
				CityID:        &cityForSubs,
				SubCategoryID: &cat,
			})
		}
	}

	err := service.repo.Create(ctx, subs)
	if err != nil {
		return err
	}

	return nil
}

func (service *subscription) UnsubscriptionToCreateAdClientSVC(ctx context.Context, userID int, subCategoryID []int) error {
	err := service.repo.Delete(ctx, userID, model.TypeRequestSVCClient, subCategoryID, nil)
	if err != nil {
		return err
	}

	return nil
}
