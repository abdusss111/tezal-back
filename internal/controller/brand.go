package controller

import (
	"net/http"
	"strconv"

	"github.com/gin-gonic/gin"
	"gitlab.com/eqshare/eqshare-back/internal/service"
	"gitlab.com/eqshare/eqshare-back/model"
)

type brand struct {
	service      service.IBrand
	serviceCM    service.IConstructionMaterialBrand
	serviceBrand service.IServiceBrand // Бренды услуг
}

func NewBrand(r *gin.Engine, service service.IBrand, auth service.IAuthentication, serviceCM service.IConstructionMaterialBrand, serviceBrand service.IServiceBrand) {
	handler := &brand{
		service:      service,
		serviceCM:    serviceCM,
		serviceBrand: serviceBrand,
	}

	r.GET("/brand_sm", handler.Get)
	r.GET("/brand_sm/:id", handler.GetByID)

	r.POST("/brand_sm")
	r.PUT("/brand_sm/:id")
	r.DELETE("/brand_sm/:id")

	r.GET("/brand_cm", handler.GetCM)
	r.GET("/brand_cm/:id", handler.GetCMByID)

	r.GET("/brand_service", handler.GetService)
	r.GET("/brand_service/:id", handler.GetServiceByID)
}

// @Summary		Получние брендов спецтехники.
// @Description	Получние брендов спецтехники.
// @Accept			json
// @Produce		json
// @Tags			Brand
// @Success		200		{object}	[]model.Brand
// @Failure		403		{object}	map[string]interface{}
// @Failure		400,404	{object}	map[string]interface{}
// @Failure		500		{object}	map[string]interface{}
// @Failure		default	{object}	map[string]interface{}
// @Router			/brand_sm [get]
func (b *brand) Get(c *gin.Context) {
	brands, err := b.service.Get(model.FilterBrand{})
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"brands": brands})
}

// @Summary		Получние брендов спецтехники по индентификатору.
// @Description	Получние брендов спецтехники по индентификатору.
// @Accept			json
// @Produce		json
// @Tags			Brand
// @Param			id		path		int	true	"идентификатор"
// @Success		200		{object}	model.Brand
// @Failure		403		{object}	map[string]interface{}
// @Failure		400,404	{object}	map[string]interface{}
// @Failure		500		{object}	map[string]interface{}
// @Failure		default	{object}	map[string]interface{}
// @Router			/brand_sm/:id [get]
func (b *brand) GetByID(c *gin.Context) {
	id, err := strconv.Atoi(c.Param("id"))
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	brand, err := b.service.GetByID(id)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"brand": brand})
}

func (b *brand) Create(c *gin.Context) {
	brand := model.Brand{}

	if err := c.BindJSON(&brand); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	if err := b.service.Create(brand); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"status": "success"})
}

func (b *brand) Update(c *gin.Context) {
	brand := model.Brand{}

	if err := c.BindJSON(&brand); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	var err error
	brand.ID, err = strconv.Atoi(c.Param("id"))
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	if err := b.service.Update(brand); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"status": "success"})
}

func (b *brand) Delete(c *gin.Context) {
	id, err := strconv.Atoi(c.Param("id"))
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	if err := b.service.Delete(id); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"status": "success"})
}

// GetCM
// @Summary		Получение брендов строй материалов.
// @Description	Получение брендов строй материалов.
// @Accept			json
// @Produce		json
// @Tags			Brand
// @Success		200		{object}	[]model.ConstructionMaterialBrand
// @Failure		403		{object}	map[string]interface{}
// @Failure		400,404	{object}	map[string]interface{}
// @Failure		500		{object}	map[string]interface{}
// @Failure		default	{object}	map[string]interface{}
// @Router			/brand_cm [get]
func (b *brand) GetCM(c *gin.Context) {
	brands, err := b.serviceCM.Get(c, model.FilterConstructionMaterialBrand{})
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"brands": brands})
}

// GetCMByID
// @Summary		Получение брендов строй материалов по идентификатору.
// @Description	Получение брендов строй материалов по идентификатору.
// @Accept			json
// @Produce		json
// @Tags			Brand
// @Param			id		path		int	true	"идентификатор"
// @Success		200		{object}	model.ConstructionMaterialBrand
// @Failure		403		{object}	map[string]interface{}
// @Failure		400,404	{object}	map[string]interface{}
// @Failure		500		{object}	map[string]interface{}
// @Failure		default	{object}	map[string]interface{}
// @Router			/brand_cm/:id [get]
func (b *brand) GetCMByID(c *gin.Context) {
	id, err := strconv.Atoi(c.Param("id"))
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	brand, err := b.serviceCM.GetByID(c, id)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"brand": brand})
}

// GetService
// @Summary		Получение брендов услуг.
// @Description	Получение брендов услуг.
// @Accept			json
// @Produce		json
// @Tags			Brand
// @Success		200		{object}	[]model.ServiceBrand
// @Failure		403		{object}	map[string]interface{}
// @Failure		400,404	{object}	map[string]interface{}
// @Failure		500		{object}	map[string]interface{}
// @Failure		default	{object}	map[string]interface{}
// @Router			/brand_service [get]
func (b *brand) GetService(c *gin.Context) {
	brands, err := b.serviceBrand.Get(c, model.FilterServiceBrand{})
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"brands": brands})
}

// GetServiceByID
// @Summary		Получение брендов услуг по идентификатору.
// @Description	Получение брендов услуг по идентификатору.
// @Accept			json
// @Produce		json
// @Tags			Brand
// @Param			id		path		int	true	"идентификатор"
// @Success		200		{object}	model.ServiceBrand
// @Failure		403		{object}	map[string]interface{}
// @Failure		400,404	{object}	map[string]interface{}
// @Failure		500		{object}	map[string]interface{}
// @Failure		default	{object}	map[string]interface{}
// @Router			/brand_service/:id [get]
func (b *brand) GetServiceByID(c *gin.Context) {
	id, err := strconv.Atoi(c.Param("id"))
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	brand, err := b.serviceBrand.GetByID(c, id)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"brand": brand})
}
