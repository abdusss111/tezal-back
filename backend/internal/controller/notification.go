package controller

import (
	"net/http"

	"github.com/gin-gonic/gin"
	"gitlab.com/eqshare/eqshare-back/internal/service"
	"gitlab.com/eqshare/eqshare-back/model"
)

type notification struct {
	notificationService service.INotification
}

func NewNotification(r *gin.Engine, service service.IAuthentication, notificationService service.INotification) {
	handler := &notification{
		notificationService: notificationService,
	}

	r.POST("/device_tokens", CheckToken(service), handler.SaveDeviceToken)
}

// @Summary		При залогировании или зарегистрировании пользователя в систему необходимо передать токен устройства
// @Description	При залогировании или зарегистрировании пользователя в систему необходимо передать токен устройства
// @Security		ApiKeyAuth
// @Accept			json
// @Produce		json
// @Tags			Auth
// @Success		200
// @Param			Authorization	header		string					true	"Bearer должен быть, refresh токен"
// @Success		200				{object}	map[string]interface{}	"возвращает `success` при успешной выполнении"
// @Success		204				{object}	map[string]interface{}	"возврашет когда юзер с таким номером существует"
// @Failure		401				{object}	map[string]interface{}	"возвращается когда токен не действительный"
// @Failure		400,404			{object}	map[string]interface{}
// @Failure		500				{object}	map[string]interface{}
// @Failure		default			{object}	map[string]interface{}
// @Router			/device_tokens [post]
func (a *notification) SaveDeviceToken(c *gin.Context) {
	// token := c.Param("token")

	user, err := GetUserFromGin(c)
	if err != nil {
		c.JSON(http.StatusUnauthorized, gin.H{"error": err.Error()})
		return
	}

	type request struct {
		Token string `json:"token"`
	}

	r := request{}

	if err := c.BindJSON(&r); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	deviceToken := model.DeviceToken{
		UserID: user.ID,
		Token:  r.Token,
	}

	if err = a.notificationService.SaveDeviceToken(deviceToken); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"reason": "success"})
}
