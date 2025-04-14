package notification

import (
	"context"
	firebase "firebase.google.com/go/v4"
	"firebase.google.com/go/v4/messaging"
	"gitlab.com/eqshare/eqshare-back/model"
)

type client struct {
	mc *firebase.App
}

func NewNotificationService(mc *firebase.App) *client {
	return &client{
		mc: mc,
	}
}

func (c *client) Send(ctx context.Context, m model.Notification) error {
	messageClient, err := c.mc.Messaging(ctx)
	if err != nil {
		return err
	}

	_, err = messageClient.SendEachForMulticast(ctx, &messaging.MulticastMessage{
		Data: m.Data,
		Notification: &messaging.Notification{
			Title: m.Tittle,
			Body:  m.Message,
		},
		Tokens: m.DeviceTokens,
		APNS: &messaging.APNSConfig{
			Payload: &messaging.APNSPayload{
				Aps: &messaging.Aps{
					ContentAvailable: true,
					Sound:            "default",
					Alert: &messaging.ApsAlert{
						Title: m.Tittle,
						Body:  m.Message,
					},
				},
			},
		},
	})

	return err
}
