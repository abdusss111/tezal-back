package sms

import (
	"encoding/json"
	"fmt"
	"gitlab.com/eqshare/eqshare-back/model"
	"gitlab.com/eqshare/eqshare-back/pkg/util"
	"io"
	"net/http"
	"net/url"

	"gitlab.com/eqshare/eqshare-back/config"
)

type Client struct {
	apiKey   string
	endpoint string
}

const (
	ResetPasswordSMSMessage = "Ваш временный пароль: %v\nС уважением, TOO MEZET"
	SendAuthCodeSMSMessage  = "Ваш код для подтверждения: %v\nС уважением, TOO MEZET"
)

func NewSMSService(cfg config.SMS) *Client {
	return &Client{
		apiKey:   cfg.ApiKey,
		endpoint: "https://api.mobizon.kz/service/message/sendsmsmessage",
	}
}

func (c *Client) send(to, text string) (string, error) {
	params := url.Values{}
	params.Set("apiKey", c.apiKey)
	params.Set("recipient", to)
	params.Set("text", text)

	resp, err := http.PostForm(c.endpoint, params)
	if err != nil {
		return "", fmt.Errorf("failed to send SMS: %v", err)
	}
	defer resp.Body.Close()

	body, err := io.ReadAll(resp.Body)
	if err != nil {
		return "", fmt.Errorf("failed to read response: %v", err)
	}

	var result map[string]interface{}
	if err := json.Unmarshal(body, &result); err != nil {
		return "", fmt.Errorf("failed to unmarshal response: %v", err)
	}
	fmt.Println(result)
	status, ok := result["code"].(float64)
	if ok && status != 0 {
		return "", fmt.Errorf("%v", result["data"])
	}

	return string(body), nil
}

func (c *Client) SendSingle(to, text string) error {
	formattedNumber, err := util.ValidateAndFormatPhoneNumber(to)
	if err != nil {
		return fmt.Errorf("%w: %v", model.InvalidPhoneNumber, err)
	}

	if _, err = c.send(formattedNumber, text); err != nil {
		return err
	}
	return nil
}

func (c *Client) SendMulti(recipients []string, text string) error {
	for _, recipient := range recipients {
		if _, err := c.send(recipient, text); err != nil {
			return fmt.Errorf("failed to send SMS to %s: %v", recipient, err)
		}
	}
	return nil
}
