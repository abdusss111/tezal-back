package controller

import (
	"net/http"
	"strconv"

	"github.com/gin-gonic/gin"
	"gitlab.com/eqshare/eqshare-back/internal/service"
	"gitlab.com/eqshare/eqshare-back/model"
)

type param struct {
	service service.IParam
}

func NewParam(r *gin.Engine, auth service.IAuthentication, service service.IParam) {
	handler := param{service: service}

	p := r.Group("/param")

	p.GET("", handler.Get)
	p.GET("/:id", handler.GetByID)
}

//	@Summary		Список параметров
//	@Description	Список параметров
//	@Description	Пока без проверки авторизации
//	@Security		ApiKeyAuth
//	@Accept			json
//	@Produce		json
//	@Tags			Param
//	@Param			Authorization	header		string	true	"приставка `Bearer` с пробелом и сам токен"
//	@Success		200				{object}	[]model.Param
//	@Failure		403				{object}	map[string]interface{}
//	@Failure		400,404			{object}	map[string]interface{}
//	@Failure		500				{object}	map[string]interface{}
//	@Failure		default			{object}	map[string]interface{}
//	@Router			/param [get]
func (p *param) Get(c *gin.Context) {
	params, err := p.service.Get(c, model.FilterParam{})
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"params": params})
}

//	@Summary		Параметров по идентификатору
//	@Description	Параметров по идентификатору
//	@Description	Пока без проверки авторизации
//	@Security		ApiKeyAuth
//	@Accept			json
//	@Produce		json
//	@Tags			Param
//	@Param			Authorization	header		string	true	"приставка `Bearer` с пробелом и сам токен"
//	@Success		200				{object}	model.Param
//	@Failure		403				{object}	map[string]interface{}
//	@Failure		400,404			{object}	map[string]interface{}
//	@Failure		500				{object}	map[string]interface{}
//	@Failure		default			{object}	map[string]interface{}
//	@Router			/param/:id [get]
func (p *param) GetByID(c *gin.Context) {
	id, err := strconv.Atoi(c.Param("id"))
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error id": err.Error()})
		return
	}

	param, err := p.service.GetByID(c, id)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"param": param})
}
