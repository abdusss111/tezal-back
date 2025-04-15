package smtp

import (
	"crypto/tls"
	"fmt"
	"gitlab.com/eqshare/eqshare-back/config"
	"gopkg.in/gomail.v2"
)

type Client struct {
	dialer *gomail.Dialer
	from   string
}

const (
	ResetPasswordSubject = "Восстановление пароля"
	ResetPasswordBody    = `Здравствуйте, %v

Вы получили это письмо, потому что мы получили запрос на сброс пароля для вашей учетной записи. Пожалуйста, используйте следующий пароль как временный:

Новый пароль: %v

Этот пароль можно будете поменять в настройках профиля

С уважением,
Команда поддержки`
)

func NewEmailService(cfg config.SMTP) *Client {
	dialer := gomail.NewDialer(cfg.Host, cfg.Port, cfg.Username, cfg.Password)
	dialer.TLSConfig = &tls.Config{InsecureSkipVerify: true}

	return &Client{
		dialer: dialer,
		from:   cfg.Username,
	}
}

func (c *Client) SendSingle(to, subject, body string) error {
	message := gomail.NewMessage()
	message.SetHeader("From", c.from)
	message.SetHeader("To", to)
	message.SetHeader("Subject", subject)
	message.SetBody("text/plain", body)

	if err := c.dialer.DialAndSend(message); err != nil {
		return fmt.Errorf("failed to send email: %v", err)
	}

	return nil
}

func (c *Client) SendMulti(recipients []string, subject, body string) error {
	messages := make([]*gomail.Message, 0, len(recipients))

	for _, recipient := range recipients {
		message := gomail.NewMessage()
		message.SetHeader("From", c.from)
		message.SetHeader("To", recipient)
		message.SetHeader("Subject", subject)
		message.SetBody("text/plain", body)

		messages = append(messages, message)
	}

	for _, message := range messages {
		if err := c.dialer.DialAndSend(message); err != nil {
			return fmt.Errorf("failed to send email to %s: %v", message.GetHeader("To")[0], err)
		}
	}

	return nil
}
