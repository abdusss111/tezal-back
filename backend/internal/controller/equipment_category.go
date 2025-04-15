package controller

import (
	"encoding/json"
	"fmt"
	"net/http"
	"strconv"

	"github.com/gin-gonic/gin"
	"gitlab.com/eqshare/eqshare-back/internal/service"
	"gitlab.com/eqshare/eqshare-back/model"
	"gitlab.com/eqshare/eqshare-back/pkg/util"
)

type equipmentCategory struct {
	equipmentCategoryService    service.IEquipmentCategory
	equipmentSubCategoryService service.IEquipmentSubCategory
}

func NewEquipmentCategory(r *gin.Engine,
	equipmentCategoryService service.IEquipmentCategory,
	equipmentSubCategoryService service.IEquipmentSubCategory,
) {
	h := equipmentCategory{
		equipmentCategoryService:    equipmentCategoryService,
		equipmentSubCategoryService: equipmentSubCategoryService,
	}

	group := r.Group("equipment/category")

	group.GET("", h.CategoryGet)
	group.GET(":id", h.CategoryGetByID)
	group.POST("", h.CategoryCreate)
	group.PUT(":id", h.UpdateCategory)

	group.GET("/sub_category", h.SubCategoryGetList)
	group.GET(":id/sub_category", h.SubCategoryGet)
	group.GET(":id/sub_category/:id_sub", h.SubCategoryGetByID)
	group.PUT(":id/sub_category/:id_sub", h.UpdateFotoSubCategory)

	group.POST(":id/sub_category/:id_sub/param", h.SetParamSubCategory)
	group.DELETE(":id/sub_category/:id_sub/param/:id_param", h.DeleteParamSubCategory)

}

// @Summary	Получние категории оборудование.
// @Accept		json
// @Produce	json
// @Tags		Equipment Category
// @Param		document_detail								query		bool	false	"получение путь до картинок категории"		default(true)
// @Param		equipment_sub_categories_documents_detail	query		bool	false	"получение путь до картинок подкатегории"	default(true)
// @Param		equipment_sub_categories_detail				query		bool	false	"получение данных о подкатегориях"			default(true)
// @Success	200											{object}	[]model.EquipmentCategory
// @Failure	403											{object}	map[string]interface{}
// @Failure	400,404										{object}	map[string]interface{}
// @Failure	500											{object}	map[string]interface{}
// @Failure	default										{object}	map[string]interface{}
// @Router		/equipment/category [get]
func (h *equipmentCategory) CategoryGet(c *gin.Context) {
	f := model.FilterEquipmentCategory{}

	if val, ok := c.GetQuery("document_detail"); ok {
		v, err := strconv.ParseBool(val)
		if err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"name": "document_detail", "error": err.Error()})
			return
		}
		f.DocumentsDetail = &v
	} else {
		b := true
		f.DocumentsDetail = &b
	}

	if val, ok := c.GetQuery("equipment_sub_categories_documents_detail"); ok {
		v, err := strconv.ParseBool(val)
		if err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"name": "equipment_sub_categories_documents_detail", "error": err.Error()})
			return
		}
		f.SubCategoriesDocumentsDetail = &v
	} else {
		b := true
		f.SubCategoriesDocumentsDetail = &b
	}

	if val, ok := c.GetQuery("equipment_sub_categories_detail"); ok {
		v, err := strconv.ParseBool(val)
		if err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": fmt.Errorf("equipment_sub_categories_datail: %w", err).Error()})
			return
		}
		f.SubCategoriesDatail = &v
	} else {
		b := true
		f.SubCategoriesDatail = &b
	}

	if val, ok := c.GetQuery("count_ad_detail"); ok {
		v, err := strconv.ParseBool(val)
		if err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": fmt.Errorf("count_ad_detail: %w", err).Error()})
			return
		}
		f.CountAdDetail = &v
	} else {
		b := true
		f.CountAdDetail = &b
	}

	if val, ok := c.GetQuery("count_ad_client_detail"); ok {
		v, err := strconv.ParseBool(val)
		if err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": fmt.Errorf("count_ad_client_detail: %w", err).Error()})
			return
		}
		f.CountAdClientDetail = &v
	} else {
		b := true
		f.CountAdClientDetail = &b
	}

	if val, ok := c.GetQuery("sub_category_count_ad_detail"); ok {
		v, err := strconv.ParseBool(val)
		if err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": fmt.Errorf("count_ad_detail: %w", err).Error()})
			return
		}
		f.CountAdDetail = &v
	} else {
		b := true
		f.CountAdDetail = &b
	}

	if val, ok := c.GetQuery("sub_category_count_ad_client_detail"); ok {
		v, err := strconv.ParseBool(val)
		if err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": fmt.Errorf("count_ad_client_detail: %w", err).Error()})
			return
		}
		f.CountAdClientDetail = &v
	} else {
		b := true
		f.CountAdClientDetail = &b
	}

	res, err := h.equipmentCategoryService.Get(c, f)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"categories": res})
}

// @Summary	Получние категории оборудование по идентификатору.
// @Accept		json
// @Produce	json
// @Tags		Equipment Category
// @Success	200		{object}	model.EquipmentCategory
// @Failure	403		{object}	map[string]interface{}
// @Failure	400,404	{object}	map[string]interface{}
// @Failure	500		{object}	map[string]interface{}
// @Failure	default	{object}	map[string]interface{}
// @Router		/equipment/category/{id} [get]
func (h *equipmentCategory) CategoryGetByID(c *gin.Context) {
	id, err := strconv.Atoi(c.Param("id"))
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	res, err := h.equipmentCategoryService.GetByID(c, id)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"category": res})
}

func (h *equipmentCategory) CategoryCreate(c *gin.Context) {
	type request struct {
		Name string `json:"name"`
	}

	mf, err := c.MultipartForm()
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": fmt.Sprintf("invalid input error: %s", err.Error())})
		return
	}

	ec := model.EquipmentCategory{}

	if len(mf.Value["base"]) != 0 {
		r := request{}
		err := json.Unmarshal([]byte(mf.Value["base"][0]), &r)
		if err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": fmt.Sprintf("invalid input base error: %s", err.Error())})
			return
		}
		ec.Name = r.Name
	} else {
		c.JSON(http.StatusBadRequest, gin.H{"error": "don't have base"})
		return
	}

	if len(mf.File["foto"]) != 1 {
		doc, err := util.ParseDocumentOnMultipart(mf.File["foto"][0])
		if err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": fmt.Errorf("parse foto error: %w", err).Error()})
			return
		}
		doc.UserID = 1
		ec.Documents = append(ec.Documents, doc)
	} else {
		c.JSON(http.StatusBadRequest, gin.H{"error": "there should be 1 foto file"})
		return
	}

	err = h.equipmentCategoryService.Create(c, ec)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"reason": "success"})
}

func (h *equipmentCategory) SubCategoryGetList(c *gin.Context) {
	res, err := h.equipmentSubCategoryService.GetAll(c)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"sub_categories": res})
}

// @Summary	Получние подкатегории оборудование.
// @Accept		json
// @Produce	json
// @Tags		Equipment Category
// @Param		id						query		int		path	"идентификатор категории"
// @Param		equipment_categories_id	query		int		false	"фильтр по идентификатору"
// @Param		document_detail			query		bool	false	"получение путь до картинок категории"	default(true)
// @Success	200						{object}	[]model.EquipmentSubCategory
// @Failure	403						{object}	map[string]interface{}
// @Failure	400,404					{object}	map[string]interface{}
// @Failure	500						{object}	map[string]interface{}
// @Failure	default					{object}	map[string]interface{}
// @Router		/equipment/category/{id}/sub_category [get]
func (h *equipmentCategory) SubCategoryGet(c *gin.Context) {
	f := model.FilterEquipmentSubCategory{}

	id, err := strconv.Atoi(c.Param("id"))
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"name": "id", "error": err.Error()})
		return
	}

	f.EquipmentCategoryIDs = append(f.EquipmentCategoryIDs, id)

	if val, ok := c.GetQuery("document_detail"); ok {
		v, err := strconv.ParseBool(val)
		if err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"name": "document_detail", "error": err.Error()})
			return
		}
		f.DocumentsDetail = &v
	} else {
		b := true
		f.DocumentsDetail = &b
	}

	if val, ok := c.GetQueryArray("equipment_categories_id"); ok {
		f.EquipmentCategoryIDs = make([]int, 0, len(val))
		for _, v := range val {
			id, err := strconv.Atoi(v)
			if err != nil {
				c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
				return
			}
			f.EquipmentCategoryIDs = append(f.EquipmentCategoryIDs, id)
		}
	}

	res, err := h.equipmentSubCategoryService.Get(c, f)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"sub_categories": res})
}

//func (h *equipmentCategory) SubCategoryGetList(c *gin.Context) {
//	f := model.FilterEquipmentSubCategory{}
//
//	res, err := h.equipmentSubCategoryService.Get(c, f)
//	if err != nil {
//		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
//		return
//	}
//
//	c.JSON(http.StatusOK, gin.H{"sub_categories": res})
//}

// @Summary	Получние подкатегории оборудование по идентификатору.
// @Accept		json
// @Produce	json
// @Tags		Equipment Category
// @Success	200		{object}	model.EquipmentSubCategory
// @Failure	403		{object}	map[string]interface{}
// @Failure	400,404	{object}	map[string]interface{}
// @Failure	500		{object}	map[string]interface{}
// @Failure	default	{object}	map[string]interface{}
// @Router		/equipment/category/{id}/sub_category/{id} [get]
func (h *equipmentCategory) SubCategoryGetByID(c *gin.Context) {
	id, err := strconv.Atoi(c.Param("id_sub"))
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	res, err := h.equipmentSubCategoryService.GetByID(c, id)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"sub_category": res})
}

func (h *equipmentCategory) SubCategoryCreate(c *gin.Context) {
	type request struct {
		Name string `json:"name"`
	}

	mf, err := c.MultipartForm()
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": fmt.Sprintf("invalid input error: %s", err.Error())})
		return
	}

	ec := model.EquipmentSubCategory{}

	if len(mf.Value["base"]) != 0 {
		r := request{}
		err := json.Unmarshal([]byte(mf.Value["base"][0]), &r)
		if err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": fmt.Sprintf("invalid input base error: %s", err.Error())})
			return
		}
		ec.Name = r.Name
	} else {
		c.JSON(http.StatusBadRequest, gin.H{"error": "don't have base"})
		return
	}

	if len(mf.File["foto"]) != 1 {
		doc, err := util.ParseDocumentOnMultipart(mf.File["foto"][0])
		if err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": fmt.Errorf("parse foto error: %w", err).Error()})
			return
		}
		doc.UserID = 1
		ec.Documents = append(ec.Documents, doc)
	} else {
		c.JSON(http.StatusBadRequest, gin.H{"error": "there should be 1 foto file"})
		return
	}

	err = h.equipmentSubCategoryService.Create(c, ec)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"reason": "success"})
}

// @Summary	Обновление данных о категории
// @Accept		json
// @Produce	json
// @Tags		Equipment Category
// @Accept		mpfd
// @Param		id		path		int		true	"идентификатор категории"
// @Param		name	formData	string	false	"названия категории"
// @Param		foto	formData	file	false	"фотографии категории"
// @Success	200		{object}	model.EquipmentCategory
// @Failure	403		{object}	map[string]interface{}
// @Failure	400,404	{object}	map[string]interface{}
// @Failure	500		{object}	map[string]interface{}
// @Failure	default	{object}	map[string]interface{}
// @Router		/equipment/category/{id} [put]
func (h *equipmentCategory) UpdateCategory(c *gin.Context) {
	ec := model.EquipmentCategory{}

	id, err := strconv.Atoi(c.Param("id"))
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	ec.ID = id

	mf, err := c.MultipartForm()
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	if val, ok := mf.Value["name"]; ok {
		ec.Name = val[0]
	}

	if val, ok := mf.File["foto"]; ok && len(val) != 0 {
		doc, err := util.ParseDocumentOnMultipart(val[0])
		if err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": fmt.Errorf("parse foto: %w", err).Error()})
			return
		}
		doc.UserID = 1 // TODO заглушка
		ec.Documents = append(ec.Documents, doc)
	}

	if err := h.equipmentCategoryService.Update(c, ec); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"status": "success"})
}

// @Summary	Обновление данных о подкатегории
// @Accept		json
// @Produce	json
// @Tags		Equipment Category
// @Accept		mpfd
// @Param		id		path		int		true	"идентификатор категории"
// @Param		id_sub	path		int		true	"идентификатор подкатегории"
// @Param		name	formData	string	false	"названия категории"
// @Param		foto	formData	file	false	"фотографии категории"
// @Success	200		{object}	model.EquipmentCategory
// @Failure	403		{object}	map[string]interface{}
// @Failure	400,404	{object}	map[string]interface{}
// @Failure	500		{object}	map[string]interface{}
// @Failure	default	{object}	map[string]interface{}
// @Router		/equipment/category/{id}/sub_category/{id_sub} [put]
func (h *equipmentCategory) UpdateFotoSubCategory(c *gin.Context) {
	ec := model.EquipmentSubCategory{}

	id, err := strconv.Atoi(c.Param("id"))
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	idSub, err := strconv.Atoi(c.Param("id_sub"))
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	ec.EquipmentCategoriesID = id
	ec.ID = idSub

	mf, err := c.MultipartForm()
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	if val, ok := mf.Value["name"]; ok {
		ec.Name = val[0]
	}

	if val, ok := mf.File["foto"]; ok && len(val) != 0 {
		doc, err := util.ParseDocumentOnMultipart(val[0])
		if err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": fmt.Errorf("parse foto: %w", err).Error()})
			return
		}
		doc.UserID = 1 // TODO заглушка
		ec.Documents = append(ec.Documents, doc)
	}

	if err := h.equipmentSubCategoryService.Update(c, ec); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"status": "success"})
}

// @Summary	Прикрепление параметров на подкетегории
// @Tags		Equipment Category
// @Accept		json
// @Produce	json
// @Param		id_sub	path		int										true	"идентификатор подкатегории"
// @Param		id		path		int										true	"идентификатор категории"
// @Param		params	body		controller.SetParamSubCategory.request	true	"идентификатор категории"
// @Success	200		{object}	model.EquipmentCategory
// @Failure	403		{object}	map[string]interface{}
// @Failure	400,404	{object}	map[string]interface{}
// @Failure	500		{object}	map[string]interface{}
// @Failure	default	{object}	map[string]interface{}
// @Router		/equipment/category/{id}/sub_category/{id_sub}/param [post]
func (h *equipmentCategory) SetParamSubCategory(c *gin.Context) {
	subCategoryID, err := strconv.Atoi(c.Param("id_sub"))
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error id_sub": err.Error()})
		return
	}

	type request struct {
		ParamIDs []int `json:"param_ids"`
	}

	r := request{}

	if err := c.BindJSON(&r); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error param body": err.Error()})
		return
	}

	tps := make([]model.EquipmentSubCategoriesParams, 0, len(r.ParamIDs))

	for _, p := range r.ParamIDs {
		tps = append(tps, model.EquipmentSubCategoriesParams{
			// CategoryID:    categoryID,
			EquipmentSubCategoryID: subCategoryID,
			ParamID:                p,
		})
	}

	if err := h.equipmentSubCategoryService.SetParamSubCategory(c, tps); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"status": "success"})
}

// @Summary	Удаление параметров на подкетегории
// @Tags		Equipment Category
// @Accept		json
// @Produce	json
// @Param		id_sub		path		int	true	"идентификатор подкатегории"
// @Param		id			path		int	true	"идентификатор категории"
// @Param		id_param	path		int	true	"идентификатор параметра"
// @Success	200			{object}	model.EquipmentCategory
// @Failure	403			{object}	map[string]interface{}
// @Failure	400,404		{object}	map[string]interface{}
// @Failure	500			{object}	map[string]interface{}
// @Failure	default		{object}	map[string]interface{}
// @Router		/equipment/category/{id}/sub_category/{id_sub}/param/{id_param} [delete]
func (h *equipmentCategory) DeleteParamSubCategory(c *gin.Context) {
	subCategoryID, err := strconv.Atoi(c.Param("id_sub"))
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error id_sub": err.Error()})
		return
	}

	paramID, err := strconv.Atoi(c.Param("id_param"))
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error id_param": err.Error()})
		return
	}

	if err := h.equipmentSubCategoryService.DeleteParamSubCategory(c, model.EquipmentSubCategoriesParams{EquipmentSubCategoryID: subCategoryID, ParamID: paramID}); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"status": "success"})
}
