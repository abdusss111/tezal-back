package controller

import (
	"github.com/gin-gonic/gin"
	"gitlab.com/eqshare/eqshare-back/internal/client"
	"gitlab.com/eqshare/eqshare-back/model"
	"net/http"
)

type test struct {
	remote client.Remote
}

func NewTest(r *gin.Engine, remote client.Remote) {
	handler := &test{remote: remote}
	r.POST("/test/fcm", handler.Create)

}

func (b *test) Create(c *gin.Context) {
	type TestFCM struct {
		Token string `json:"fcm_token"`
	}
	var input TestFCM

	if err := c.BindJSON(&input); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	if err := b.remote.NotificationClient.Send(c, model.Notification{
		DeviceTokens: []string{input.Token},
		Message:      "Test message do not use in production",
		Tittle:       "Test message",
	}); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"status": "success"})
}
