package controller

import (
	"net/http"
	"strconv"

	"github.com/gin-gonic/gin"
	"gitlab.com/eqshare/eqshare-back/internal/service"
	"gitlab.com/eqshare/eqshare-back/model"
)

type city struct {
	service service.ICity
}

func NewCity(r *gin.Engine, service service.ICity, auth service.IAuthentication) {
	handler := &city{service: service}

	r.GET("/city", handler.Get)
	r.GET("/city/:id", handler.GetByID)
	r.POST("/city", authorize(auth, model.ROLE_ADMIN), handler.Create)
	r.PUT("/city/:id", authorize(auth, model.ROLE_ADMIN), handler.Update)
	r.DELETE("/city/:id", authorize(auth, model.ROLE_ADMIN), handler.Delete)
}

//	@Summary		Получние всех городов.
//	@Description	Получние всех городов.
//	@Accept			json
//	@Produce		json
//	@Tags			City
//
//	@Param			Authorization	header		string	true	"приставка `Bearer` с пробелом и сам токен"
//
//	@Success		200				{object}	[]model.City
//	@Failure		403				{object}	map[string]interface{}
//	@Failure		400,404			{object}	map[string]interface{}
//	@Failure		500				{object}	map[string]interface{}
//	@Failure		default			{object}	map[string]interface{}
//	@Router			/city [get]
func (b *city) Get(c *gin.Context) {
	cities, err := b.service.Get(model.FilterCity{})
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"brands": cities})
}

//	@Summary		Получние городов по индентификатору.
//	@Description	Получние городов по индентификатору.
//	@Accept			json
//	@Produce		json
//	@Tags			City
//
//	@Param			Authorization	header		string	true	"приставка `Bearer` с пробелом и сам токен"
//
//	@Param			id				path		int		true	"идентификатор"
//	@Success		200				{object}	model.City
//	@Failure		403				{object}	map[string]interface{}
//	@Failure		400,404			{object}	map[string]interface{}
//	@Failure		500				{object}	map[string]interface{}
//	@Failure		default			{object}	map[string]interface{}
//	@Router			/city/:id [get]
func (b *city) GetByID(c *gin.Context) {
	id, err := strconv.Atoi(c.Param("id"))
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	city, err := b.service.GetByID(id)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"brand": city})
}

//	@Summary		Создание городов.
//	@Description	Создание городов.
//	@Accept			json
//	@Produce		json
//	@Tags			City
//
//	@Param			Authorization	header		string					true	"приставка `Bearer` с пробелом и сам токен"
//
//	@Param			city			body		model.City				true	"тело города"
//	@Success		200				{object}	map[string]interface{}	"success"
//	@Failure		403				{object}	map[string]interface{}
//	@Failure		400,404			{object}	map[string]interface{}
//	@Failure		500				{object}	map[string]interface{}
//	@Failure		default			{object}	map[string]interface{}
//	@Router			/city [post]
func (b *city) Create(c *gin.Context) {
	city := model.City{}

	if err := c.BindJSON(&city); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	if err := b.service.Create(city); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"status": "success"})
}

//	@Summary		Обновление городов по индентификатору.
//	@Description	Обновление городов по индентификатору.
//	@Accept			json
//	@Produce		json
//	@Tags			City
//	@Param			city			body		model.City	true	"тело городов"
//
//	@Param			Authorization	header		string		true	"приставка `Bearer` с пробелом и сам токен"
//
//	@Success		200				{object}	model.City
//	@Failure		403				{object}	map[string]interface{}
//	@Failure		400,404			{object}	map[string]interface{}
//	@Failure		500				{object}	map[string]interface{}
//	@Failure		default			{object}	map[string]interface{}
//	@Router			/city [put]
func (b *city) Update(c *gin.Context) {
	city := model.City{}

	if err := c.BindJSON(&city); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	var err error
	city.ID, err = strconv.Atoi(c.Param("id"))
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	if err := b.service.Update(city); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"status": "success"})
}

//	@Summary		Удаление города.
//	@Description	Удаление города.
//	@Accept			json
//	@Produce		json
//	@Tags			City
//	@Param			id				query		int						true	"идентификатор города"
//
//	@Param			Authorization	header		string					true	"приставка `Bearer` с пробелом и сам токен"
//
//	@Success		200				{object}	map[string]interface{}	"success"
//	@Failure		403				{object}	map[string]interface{}
//	@Failure		400,404			{object}	map[string]interface{}
//	@Failure		500				{object}	map[string]interface{}
//	@Failure		default			{object}	map[string]interface{}
//	@Router			/city/:id [delete]
func (b *city) Delete(c *gin.Context) {
	id, err := strconv.Atoi(c.Param("id"))
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	if err := b.service.Delete(id); err != nil {
		return
	}

	c.JSON(http.StatusOK, gin.H{"status": "success"})
}
