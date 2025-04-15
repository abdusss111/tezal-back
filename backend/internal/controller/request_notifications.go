package controller

import (
	"github.com/gin-gonic/gin"
	"gitlab.com/eqshare/eqshare-back/internal/service"
	"gitlab.com/eqshare/eqshare-back/model"
	"net/http"
)

type requestNotification struct {
	service service.IRequestNotification
}

func NewRequestNotification(r *gin.Engine, auth service.IAuthentication, service service.IRequestNotification, middlware ...gin.HandlerFunc) {
	handler := requestNotification{service: service}

	re := r.Group("/notification")

	re.GET("/owner_driver", authorize(auth, model.ROLE_DRIVER, model.ROLE_ADMIN), handler.GetRequestNotifications)
}

// @Summary	Получние уведомлении водителя
// @Accept		json
// @Produce	json
// @Tags		RequestExecution
// @Param		Authorization	header		string	true	"приставка `Bearer` с пробелом и сам токен водителя"
// @Success	200				{object}	model.OwnerDriverRequests
// @Failure	403				{object}	map[string]interface{}
// @Failure	400,404			{object}	map[string]interface{}
// @Failure	500				{object}	map[string]interface{}
// @Failure	default			{object}	map[string]interface{}
// @Router		/notification/owner_driver [get]
func (r *requestNotification) GetRequestNotifications(c *gin.Context) {

	user, err := GetUserFromGin(c)
	if err != nil {
		return
	}

	if user.AccessRole == model.ROLE_CLIENT {
		c.JSON(http.StatusUnauthorized, gin.H{
			"access_role":   model.ROLE_CLIENT,
			"notifications": "access denied",
		})
	}

	notifications, err := r.service.GetOwnerDriverRequests(user.ID)
	if err != nil {
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"notifications": notifications,
		"access_role":   user.AccessRole,
	})
}
