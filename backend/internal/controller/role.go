package controller

import (
	"net/http"
	"strconv"

	"github.com/gin-gonic/gin"
	"gitlab.com/eqshare/eqshare-back/internal/service"
	"gitlab.com/eqshare/eqshare-back/model"
)

type role struct {
	service service.IRole
}

func NewRole(r *gin.Engine, service service.IRole, auth service.IAuthentication) {
	handler := &role{service: service}

	r.GET("/role", authorize(auth, model.ROLE_ADMIN, model.ROLE_CLIENT, model.ROLE_DRIVER), handler.Get)
	r.GET("/role/:id", authorize(auth, model.ROLE_ADMIN, model.ROLE_CLIENT, model.ROLE_DRIVER), handler.GetByID)
	r.POST("/role", authorize(auth, model.ROLE_ADMIN), handler.Create)
	r.PUT("/role/:id", authorize(auth, model.ROLE_ADMIN), handler.Update)
	r.DELETE("/role/:id", authorize(auth, model.ROLE_ADMIN), handler.Delete)
}

//	@Summary		Получние всех ролей.
//	@Description	Получние всех ролей.
//	@Accept			json
//	@Produce		json
//	@Tags			Role
//	@Success		200
//	@Success		200		{object}	[]model.Role
//	@Failure		403		{object}	map[string]interface{}
//	@Failure		400,404	{object}	map[string]interface{}
//	@Failure		500		{object}	map[string]interface{}
//	@Failure		default	{object}	map[string]interface{}
//	@Router			/role [get]
func (r *role) Get(c *gin.Context) {
	role, err := r.service.Get()
	if err != nil {
		c.JSON(http.StatusInternalServerError, err.Error())
		return
	}

	c.JSON(http.StatusOK, role)
}

//	@Summary		Получение роли по идентификатору
//	@Description	Получение роли по идентификатору. В случае если если роль по идентифиатору нет вернут 500 ошибку.
//	@Description	TODO сделать так что бы возврашал 204
//	@Accept			json
//	@Produce		json
//	@Tags			Role
//	@Success		200
//	@Param			id		path		int	true	"идентификатор право"
//	@Success		200		{object}	model.Role
//	@Failure		403		{object}	map[string]interface{}
//	@Failure		400,404	{object}	map[string]interface{}
//	@Failure		500		{object}	map[string]interface{}
//	@Failure		default	{object}	map[string]interface{}
//	@Router			/role/:id [get]
func (r *role) GetByID(c *gin.Context) {
	id, err := strconv.Atoi(c.Param("id"))
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	if id <= 0 {
		c.JSON(http.StatusBadRequest, gin.H{"error": "don't correct id"})
		return
	}

	role, err := r.service.GetByID(id)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, role)
}

//	@Summary		Создание прав.
//	@Description	Создается обеъект право. Использется в ролях.
//	@Description	Параметр rights нужно заполнять `только` идентификатор id.
//	@Accept			json
//	@Produce		json
//	@Tags			Role
//	@Success		200
//	@Param			rigth	body		model.Role				true	"тело право, `id` не заполнять"
//	@Success		200		{object}	map[string]interface{}	"success"
//	@Failure		403		{object}	map[string]interface{}
//	@Failure		400,404	{object}	map[string]interface{}
//	@Failure		500		{object}	map[string]interface{}
//	@Failure		default	{object}	map[string]interface{}
//	@Router			/role [post]
func (r *role) Create(c *gin.Context) {
	role := model.Role{}

	if err := c.BindJSON(&role); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	if err := r.service.Create(role); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"status": "success"})
}

//	@Summary		Измение роли.
//	@Description	Изменение объект роли.
//	@Accept			json
//	@Produce		json
//	@Tags			Role
//	@Success		200
//	@Param			id		path		int						true	"идентификатор право"
//	@Param			rigth	body		model.Role				true	"тело право, `id` не заполнять"
//	@Success		200		{object}	map[string]interface{}	"success"
//	@Failure		403		{object}	map[string]interface{}
//	@Failure		400,404	{object}	map[string]interface{}
//	@Failure		500		{object}	map[string]interface{}
//	@Failure		default	{object}	map[string]interface{}
//	@Router			/role/:id [put]
func (r *role) Update(c *gin.Context) {
	id, err := strconv.Atoi(c.Param("id"))
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	if id <= 0 {
		c.JSON(http.StatusBadRequest, gin.H{"error": "don't correct id"})
		return
	}

	role := model.Role{}

	if err := c.BindJSON(&role); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	role.ID = id

	if err := r.service.Update(role); err != nil {
		c.JSON(http.StatusInternalServerError, err.Error())
		return
	}

	c.JSON(http.StatusOK, gin.H{"status": "success"})
}

//	@Summary		Удаление роли.
//	@Description	Удаление роли прооиходит польностью. В истории не осатеся.
//	@Description	Сделано по причине что ендпониты удаление только администрации.
//	@Accept			json
//	@Produce		json
//	@Tags			Role
//	@Success		200
//	@Param			id		path		int						true	"идентификатор право"
//	@Success		200		{object}	map[string]interface{}	"success"
//	@Failure		403		{object}	map[string]interface{}
//	@Failure		400,404	{object}	map[string]interface{}
//	@Failure		500		{object}	map[string]interface{}
//	@Failure		default	{object}	map[string]interface{}
//	@Router			/role/:id [delete]
func (r *role) Delete(c *gin.Context) {
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
