package controller

import (
	"github.com/gin-gonic/gin"
	"gitlab.com/eqshare/eqshare-back/internal/service"
	"gitlab.com/eqshare/eqshare-back/model"
	"net/http"
)

type logs struct {
	logService service.IAdminLogsService
}

func NewLogs(r *gin.Engine, logService service.IAdminLogsService) {
	handler := logs{
		logService: logService,
	}

	r.GET("/logs", handler.GetLogs)
}

//	@Summary		Вся история бизнес процессов(логирование).
//	@Description	Получение всех список действий бизнес процессов.
//	@Description	`Получение заявок по обьявлению спецтехники, отклик на обьявление водителя...`
//	@Security		ApiKeyAuth
//	@Accept			json
//	@Produce		json
//	@Tags			Logs(логирование)
//	@Param			Authorization	header		string	true	"приставка `Bearer` с пробелом и сам токен"
//	@Success		200				{object}	[]model.Logs
//	@Failure		403				{object}	map[string]interface{}
//	@Failure		400,404			{object}	map[string]interface{}
//	@Failure		500				{object}	map[string]interface{}
//	@Failure		default			{object}	map[string]interface{}
//	@Router			/logs [get]
func (h *logs) GetLogs(ctx *gin.Context) {
	logs, err := h.logService.GetLogs(model.Logs{})
	if err != nil {
		ctx.JSON(http.StatusInternalServerError, gin.H{"reason": err.Error()})
		return
	}

	ctx.JSON(http.StatusOK, logs)
}
