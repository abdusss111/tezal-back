package client

import (
	"context"
	firebase "firebase.google.com/go/v4"
	"github.com/aws/aws-sdk-go/service/s3"
	"gitlab.com/eqshare/eqshare-back/config"
	"gitlab.com/eqshare/eqshare-back/internal/client/document"
	"gitlab.com/eqshare/eqshare-back/internal/client/notification"
	"gitlab.com/eqshare/eqshare-back/internal/client/sms"
	"gitlab.com/eqshare/eqshare-back/internal/client/smtp"
	"gitlab.com/eqshare/eqshare-back/model"
	"time"
)

type DocumentsRemote interface {
	// Upload uploads a document to spaces
	Upload(ctx context.Context, doc model.Document) (model.Document, error)
	// Get returns a document from spaces
	Get(ctx context.Context, doc model.Document) (model.Document, error)
	// Delete deletes a document from spaces
	Delete(ctx context.Context, doc model.Document) (model.Document, error)
	// Share create share link for a document
	Share(ctx context.Context, doc model.Document, duration time.Duration) (model.Document, error)
}

type NotificationClient interface {
	Send(ctx context.Context, m model.Notification) error
}

type SMTPClient interface {
	SendSingle(to, subject, body string) error
}

type SMSClient interface {
	SendSingle(to, text string) error
	SendMulti(recipients []string, text string) error
}

type Remote struct {
	DocumentsRemote
	NotificationClient
	SMTPClient
	SMSClient
}

func NewRemote(s3 *s3.S3, cfg *config.ObjectStorage, app *firebase.App, cfgSMTP config.SMTP, cfgSMS config.SMS) *Remote {
	return &Remote{
		DocumentsRemote:    document.NewRemote(s3, cfg),
		NotificationClient: notification.NewNotificationService(app),
		SMTPClient:         smtp.NewEmailService(cfgSMTP),
		SMSClient:          sms.NewSMSService(cfgSMS),
	}
}
