package controller

import (
	"net/http"
	"strconv"

	"github.com/gin-gonic/gin"
	"gitlab.com/eqshare/eqshare-back/internal/service"
	"gitlab.com/eqshare/eqshare-back/model"
)

type right struct {
	service service.IRigthr
}

func NewRigth(r *gin.Engine, service service.IRigthr, auth service.IAuthentication) {
	handler := &right{service: service}

	r.GET("/rights", authorize(auth, model.ROLE_ADMIN, model.ROLE_CLIENT, model.ROLE_DRIVER), handler.Get)
	r.GET("/rights/:id", authorize(auth, model.ROLE_ADMIN, model.ROLE_CLIENT, model.ROLE_DRIVER), handler.GetByID)
	r.POST("/rights", authorize(auth, model.ROLE_ADMIN), handler.Create)
	r.PUT("/rights/:id", authorize(auth, model.ROLE_ADMIN), handler.Update)
	r.DELETE("/rights/:id", authorize(auth, model.ROLE_ADMIN), handler.Delete)
}

//	@Summary		Получние всех прав.
//	@Description	Получние всех прав.
//	@Accept			json
//	@Produce		json
//	@Tags			Rigth
//	@Success		200
//	@Success		200		{object}	[]model.Right
//	@Failure		403		{object}	map[string]interface{}
//	@Failure		400,404	{object}	map[string]interface{}
//	@Failure		500		{object}	map[string]interface{}
//	@Failure		default	{object}	map[string]interface{}
//	@Router			/right [get]
func (r *right) Get(c *gin.Context) {
	rights, err := r.service.Get()
	if err != nil {
		c.JSON(http.StatusInternalServerError, err.Error())
		return
	}

	c.JSON(http.StatusOK, rights)
}

//	@Summary		Получение прав по идентификатору
//	@Description	Получение прав по идентификатору. В случае если если прав по идентифиатору нет вернут 500 ошибку.
//	@Description	TODO сделать так что бы возврашал 204
//	@Accept			json
//	@Produce		json
//	@Tags			Rigth
//	@Success		200
//	@Param			id		path		int	true	"идентификатор право"
//	@Success		200		{object}	model.Right
//	@Failure		403		{object}	map[string]interface{}
//	@Failure		400,404	{object}	map[string]interface{}
//	@Failure		500		{object}	map[string]interface{}
//	@Failure		default	{object}	map[string]interface{}
//	@Router			/right/:id [get]
func (r *right) GetByID(c *gin.Context) {
	id, err := strconv.Atoi(c.Param("id"))
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	if id <= 0 {
		c.JSON(http.StatusBadRequest, gin.H{"error": "don't correct id"})
		return
	}

	right, err := r.service.GetByID(id)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, right)
}

//	@Summary		Создание прав.
//	@Description	Создается обеъект право. Использется в ролях.
//	@Accept			json
//	@Produce		json
//	@Tags			Rigth
//	@Success		200
//	@Param			rigth	body		model.Right				true	"тело право, `id` не заполнять"
//	@Success		200		{object}	map[string]interface{}	"success"
//	@Failure		403		{object}	map[string]interface{}
//	@Failure		400,404	{object}	map[string]interface{}
//	@Failure		500		{object}	map[string]interface{}
//	@Failure		default	{object}	map[string]interface{}
//	@Router			/right [post]
func (r *right) Create(c *gin.Context) {
	right := model.Right{}

	if err := c.BindJSON(&right); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	if err := r.service.Create(right); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"status": "success"})
}

//	@Summary		Измение право.
//	@Description	Изменение объект право.
//	@Accept			json
//	@Produce		json
//	@Tags			Rigth
//	@Success		200
//	@Param			id		path		int						true	"идентификатор право"
//	@Param			rigth	body		model.Right				true	"тело право, `id` не заполнять"
//	@Success		200		{object}	map[string]interface{}	"success"
//	@Failure		403		{object}	map[string]interface{}
//	@Failure		400,404	{object}	map[string]interface{}
//	@Failure		500		{object}	map[string]interface{}
//	@Failure		default	{object}	map[string]interface{}
//	@Router			/right/:id [put]
func (r *right) Update(c *gin.Context) {
	id, err := strconv.Atoi(c.Param("id"))
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	if id <= 0 {
		c.JSON(http.StatusBadRequest, gin.H{"error": "don't correct id"})
		return
	}

	right := model.Right{}

	if err := c.BindJSON(&right); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	right.ID = id

	if err := r.service.Update(right); err != nil {
		c.JSON(http.StatusInternalServerError, err.Error())
		return
	}

	c.JSON(http.StatusOK, gin.H{"status": "success"})
}

//	@Summary		Удаление право.
//	@Description	Удаление право прооиходит польностью. В истории не осатеся.
//	@Description	Сделано по причине что ендпониты удаление только администрации.
//	@Accept			json
//	@Produce		json
//	@Tags			Rigth
//	@Success		200
//	@Param			id		path		int						true	"идентификатор право"
//	@Success		200		{object}	map[string]interface{}	"success"
//	@Failure		403		{object}	map[string]interface{}
//	@Failure		400,404	{object}	map[string]interface{}
//	@Failure		500		{object}	map[string]interface{}
//	@Failure		default	{object}	map[string]interface{}
//	@Router			/right/:id [delete]
func (r *right) Delete(c *gin.Context) {
	id, err := strconv.Atoi(c.Param("id"))
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	if id <= 0 {
		c.JSON(http.StatusBadRequest, gin.H{"error": "don't correct id"})
		return
	}

	if err := r.service.Delete(id); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"status": "success"})
}
