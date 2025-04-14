package controller

import (
	"fmt"
	"net/http"
	"strconv"

	"github.com/gin-gonic/gin"
	"gitlab.com/eqshare/eqshare-back/internal/service"
	"gitlab.com/eqshare/eqshare-back/model"
)

type equipmentBrand struct {
	equipmentBrandService service.IEquipmentBrand
}

func NewEquipmentBrand(r *gin.Engine, equipmentBrandService service.IEquipmentBrand) {
	h := equipmentBrand{
		equipmentBrandService: equipmentBrandService,
	}

	b := r.Group("equipment/brand")

	b.GET("", h.Get)
	b.GET(":id", h.GetByID)

}

//	@Summary	Получение брендов оборудование.
//	@Accept		json
//	@Produce	json
//	@Tags		Equipment Brand
//	@Success	200		{object}	[]model.EquipmentBrand
//	@Failure	403		{object}	map[string]interface{}
//	@Failure	400,404	{object}	map[string]interface{}
//	@Failure	500		{object}	map[string]interface{}
//	@Failure	default	{object}	map[string]interface{}
//	@Router		/equipment/brand [get]
func (h *equipmentBrand) Get(c *gin.Context) {
	f := model.FilterEquipmentBrand{}

	res, err := h.equipmentBrandService.Get(c, f)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"brands": res})
}

//	@Summary	Получение брендов оборудование по идентификатору.
//	@Accept		json
//	@Produce	json
//	@Tags		Equipment Brand
//	@Success	200		{object}	model.EquipmentBrand
//	@Failure	403		{object}	map[string]interface{}
//	@Failure	400,404	{object}	map[string]interface{}
//	@Failure	500		{object}	map[string]interface{}
//	@Failure	default	{object}	map[string]interface{}
//	@Router		/equipment/brand/{id} [get]
func (h *equipmentBrand) GetByID(c *gin.Context) {
	id, err := strconv.Atoi(c.Param("id"))
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": fmt.Errorf("id: %w", err).Error()})
		return
	}

	b, err := h.equipmentBrandService.GetByID(c, id)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"brand": b})
}
