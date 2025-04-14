package controller

import (
	"fmt"
	"net/http"
	"strconv"

	"github.com/sirupsen/logrus"
	"gitlab.com/eqshare/eqshare-back/pkg/util"

	"github.com/gin-gonic/gin"
	"gitlab.com/eqshare/eqshare-back/internal/service"
	"gitlab.com/eqshare/eqshare-back/model"
)

type typeSM struct {
	service     service.IType
	authService service.IAuthentication
}

func NewType(r *gin.Engine, service service.IType,
	authService service.IAuthentication) {
	handler := &typeSM{
		service:     service,
		authService: authService,
	}

	r.GET("/category_sm", handler.Get)
	r.GET("/:categoryID/sub_category/:typeID", handler.GetCategoryByID)
	r.POST("/:categoryID/sub_category", authorize(authService, model.ROLE_ADMIN), handler.CreateCategory)
	r.GET("/:categoryID/sub_category", handler.GetListCategories)
	r.PUT("/:categoryID/sub_category", authorize(authService, model.ROLE_ADMIN), handler.UpdateCategoryID)
	r.DELETE("/:categoryID/sub_category/:typeID", authorize(authService, model.ROLE_ADMIN), handler.Delete)

	r.POST("/:categoryID/sub_category/:typeID/param", authorize(authService, model.ROLE_ADMIN), handler.SetParamSubCategory)
	r.DELETE("/:categoryID/sub_category/:typeID/param/:paramID", authorize(authService, model.ROLE_ADMIN), handler.DeleteParamSubCategory)

	r.PUT("/:categoryID/sub_category/:typeID/bind", authorize(authService, model.ROLE_ADMIN), handler.BindAlias)
	r.PUT("/:categoryID/sub_category/:typeID", authorize(authService, model.ROLE_ADMIN), handler.UpdateAlias)
}

// @Summary		Получние кетегории спецтехники.
// @Description	Получние кетегории спецтехники.
// @Accept		json
// @Produce		json
// @Tags			Category
// @Success		200		{object}	model.Type
// @Failure		403		{object}	map[string]interface{}
// @Failure		400,404	{object}	map[string]interface{}
// @Failure		500		{object}	map[string]interface{}
// @Failure		default	{object}	map[string]interface{}
// @Router			/category_sm [get]
func (t *typeSM) Get(c *gin.Context) {
	types, err := t.service.Get(model.FilterType{})
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"categories": types})
}

// @Summary		Загружение файлов кетегории спецтехники.
// @Description	Загружение файлов кетегории спецтехники.
// @Accept			json
// @Produce		json
// @Tags			Sub category(под категория)
// @Param			file		formData	file		true	"photos"
// @Param			category	formData	model.Type	true	"тело категории"
// @Success		200			{object}	map[string]interface{}
// @Failure		403			{object}	map[string]interface{}
// @Failure		400,404		{object}	map[string]interface{}
// @Failure		500			{object}	map[string]interface{}
// @Failure		default		{object}	map[string]interface{}
// @Router			/:categoryID/sub_category [post]
func (t *typeSM) CreateCategory(c *gin.Context) {
	catID, err := strconv.Atoi(c.Param("categoryID"))
	if err != nil {
		logrus.Errorf("[validaton error] - %+v", err)
		c.JSON(http.StatusBadRequest, gin.H{"reason": err.Error()})
		return
	}

	user, err := GetUserFromGin(c)
	if err != nil {
		logrus.Errorf("[validaton error] - %+v", err)
		c.JSON(http.StatusUnauthorized, gin.H{"reason": err.Error()})
		return
	}

	formData, err := c.MultipartForm()
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"reason": fmt.Sprintf("invalid input error: %s", err.Error())})
		return
	}

	ct := model.Type{
		UserID:        user.ID,
		SubCategoryID: catID,
	}
	ct, err = util.CategoryParse(ct, formData)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"reason": fmt.Sprintf("invalid input error: %s", err.Error())})
		return
	}

	typeSMs, err := t.service.CreateCategory(c, ct)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"category": typeSMs})
}

// @Summary		Получение файлов кетегории по индентификатору пользователя и документа.
// @Description	Получение файлов кетегории по индентификатору пользователя и документа.
// @Accept			json
// @Produce		json
// @Tags			Sub category(под категория)
// @Param			typeID	path		int	true	"идентификатор категории"
// @Success		200		{object}	model.Type
// @Failure		403		{object}	map[string]interface{}
// @Failure		400,404	{object}	map[string]interface{}
// @Failure		500		{object}	map[string]interface{}
// @Failure		default	{object}	map[string]interface{}
// @Router			/:categoryID/sub_category/:typeID [get]
func (t *typeSM) GetCategoryByID(c *gin.Context) {
	catID, err := strconv.Atoi(c.Param("categoryID"))
	if err != nil {
		logrus.Errorf("[validaton error] - %+v", err)
		c.JSON(http.StatusBadRequest, gin.H{"reason": err.Error()})
		return
	}

	typeIDStr := c.Param("typeID")
	typeID, _ := strconv.Atoi(typeIDStr)

	ct := model.Type{
		ID: typeID,
		// UserID:        user.ID,
		SubCategoryID: catID,
	}

	stored, err := t.service.GetCategoryByID(c, ct)
	if err != nil {
		logrus.Errorf("[service error] - %+v", err)
		c.JSON(http.StatusInternalServerError, gin.H{"reason": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"categories": stored})
}

// @Summary		Получение всех файлов(json) кетегории по индентификатору пользователя.
// @Description	Получение всех файлов(json) кетегории по индентификатору пользователя.
// @Accept			json
// @Produce		json
// @Tags			Sub category(под категория)
// @Success		200		{array}		model.Type
// @Failure		403		{object}	map[string]interface{}
// @Failure		400,404	{object}	map[string]interface{}
// @Failure		500		{object}	map[string]interface{}
// @Failure		default	{object}	map[string]interface{}
// @Router			/:categoryID/sub_category [get]
func (t *typeSM) GetListCategories(c *gin.Context) {
	catID, err := strconv.Atoi(c.Param("categoryID"))
	if err != nil {
		logrus.Errorf("[validaton error] - %+v", err)
		c.JSON(http.StatusBadRequest, gin.H{"reason": err.Error()})
		return
	}

	stored, err := t.service.GetListCategory(c, model.Type{SubCategoryID: catID})
	if err != nil {
		logrus.Errorf("[service error] - %+v", err)
		c.JSON(http.StatusInternalServerError, gin.H{"reason": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"categories": stored})
}

// @Summary		Обновление кетегории по индентификатору.
// @Description	Обновление кетегории по индентификатору.
// @Accept			json
// @Produce		json
// @Tags			Sub category(под категория)
// @Param			file		formData	file		true	"photos"
// @Param			category	formData	model.Type	true	"тело категории"
// @Success		200			{object}	map[string]interface{}
// @Failure		403			{object}	map[string]interface{}
// @Failure		400,404		{object}	map[string]interface{}
// @Failure		500			{object}	map[string]interface{}
// @Failure		default		{object}	map[string]interface{}
// @Router			/:categoryID/sub_category [put]
func (t *typeSM) UpdateCategoryID(c *gin.Context) {
	user, err := GetUserFromGin(c)
	if err != nil {
		logrus.Errorf("[validaton error] - %+v", err)
		c.JSON(http.StatusUnauthorized, gin.H{"reason": err.Error()})
		return
	}

	catID, err := strconv.Atoi(c.Param("categoryID"))
	if err != nil {
		logrus.Errorf("[validaton error] - %+v", err)
		c.JSON(http.StatusBadRequest, gin.H{"reason": err.Error()})
		return
	}

	formData, err := c.MultipartForm()
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"reason": fmt.Sprintf("invalid input error: %s", err.Error())})
		return
	}

	ct := model.Type{
		UserID:        user.ID,
		SubCategoryID: catID,
	}
	ct, err = util.CategoryParse(ct, formData)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"reason": fmt.Sprintf("invalid input error: %s", err.Error())})
		return
	}

	_, err = t.service.Update(c, ct)
	if err != nil {
		logrus.Errorf("[service error] - %+v", err)
		c.JSON(http.StatusInternalServerError, gin.H{"reason": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"category": "updated!"})
}

// @Summary		Удаление кетегории по индентификатору.
// @Description	Удаление кетегории по индентификатору.
// @Accept			json
// @Produce		json
// @Tags			Sub category(под категория)
// @Param			typeID	path		int	true	"идентификатор категории"
// @Success		200		{object}	map[string]interface{}
// @Failure		403		{object}	map[string]interface{}
// @Failure		400,404	{object}	map[string]interface{}
// @Failure		500		{object}	map[string]interface{}
// @Failure		default	{object}	map[string]interface{}
// @Router			/:categoryID/sub_category/:typeID [delete]
func (t *typeSM) Delete(c *gin.Context) {
	catID, err := strconv.Atoi(c.Param("categoryID"))
	if err != nil {
		logrus.Errorf("[validaton error] - %+v", err)
		c.JSON(http.StatusBadRequest, gin.H{"reason": err.Error()})
		return
	}

	typeIDStr := c.Param("typeID")
	typeID, _ := strconv.Atoi(typeIDStr)

	user, err := GetUserFromGin(c)
	if err != nil {
		logrus.Errorf("[validaton error] - %+v", err)
		c.JSON(http.StatusUnauthorized, gin.H{"reason": err.Error()})
		return
	}

	ct := model.Type{
		ID:            typeID,
		UserID:        user.ID,
		SubCategoryID: catID,
	}

	if err = t.service.DeleteByID(c, ct); err != nil {
		logrus.Errorf("[validaton error] - %+v", err)
		c.JSON(http.StatusInternalServerError, gin.H{"reason": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"reason": "deleted!"})
}

// @Summary		Прикрепление параметров на подкетегории
// @Description	Прикрепление параметров на подкетегории
// @Accept			json
// @Produce		json
// @Tags			Sub category(под категория)
// @Param			categoryID	path		int										true	"идентификатор категории"
// @Param			typeID		path		int										true	"идентификатор категории"
// @Param			params		body		controller.SetParamSubCategory.request	true	"идентификатор категории"
// @Success		200			{object}	map[string]interface{}
// @Failure		403			{object}	map[string]interface{}
// @Failure		400,404		{object}	map[string]interface{}
// @Failure		500			{object}	map[string]interface{}
// @Failure		default		{object}	map[string]interface{}
// @Router			/:categoryID/sub_category/:typeID/param [post]
func (t *typeSM) SetParamSubCategory(c *gin.Context) {
	typeID, err := strconv.Atoi(c.Param("typeID"))
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error typeID": err.Error()})
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

	tps := make([]model.TypesParams, 0, len(r.ParamIDs))

	for _, p := range r.ParamIDs {
		tps = append(tps, model.TypesParams{
			TypeID:  typeID,
			ParamID: p,
		})
	}

	if err := t.service.SetParamSubCategory(c, tps); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"status": "success"})
}

// @Summary		Открипление параметров на подкетегории
// @Description	Открипление параметров на подкетегории
// @Accept			json
// @Produce		json
// @Tags			Sub category(под категория)
// @Param			categoryID	path		int	true	"идентификатор категории"
// @Param			typeID		path		int	true	"идентификатор категории"
// @Param			paramIDa	path		int	true	"идентификатор категории"
// @Success		200			{object}	map[string]interface{}
// @Failure		403			{object}	map[string]interface{}
// @Failure		400,404		{object}	map[string]interface{}
// @Failure		500			{object}	map[string]interface{}
// @Failure		default		{object}	map[string]interface{}
// @Router			/:categoryID/sub_category/:typeID/param/:paramID [delete]
func (t *typeSM) DeleteParamSubCategory(c *gin.Context) {
	typeID, err := strconv.Atoi(c.Param("typeID"))
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error typeID": err.Error()})
		return
	}

	paramID, err := strconv.Atoi(c.Param("paramID"))
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error paramID": err.Error()})
		return
	}

	if err := t.service.DeleteParamSubCategory(c, model.TypesParams{TypeID: typeID, ParamID: paramID}); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"status": "success"})
}

// @Summary		Добавление псевдонимов подкатегории
// @Description	Добавление псевдонимов подкатегории
// @Description	`В дальнейшем добавится фильтры через query параметры`
// @Security		ApiKeyAuth
// @Accept			json
// @Produce		json
// @Tags			Sub category(под категория)
// @Param			Authorization	header		string			true	"приставка `Bearer` с пробелом и сам токен"
// @Param			id				path		int				true	"идентификатор подкатегории"
// @Param			body			body		[]model.Alias	true	"тело псевдонима"
// @Success		200				{object}	map[string]interface{}
// @Failure		403				{object}	map[string]interface{}
// @Failure		400,404			{object}	map[string]interface{}
// @Failure		500				{object}	map[string]interface{}
// @Failure		default			{object}	map[string]interface{}
// @Router			/:categoryID/sub_category/:typeID/bind [put]
func (t *typeSM) BindAlias(c *gin.Context) {
	var category model.Type

	category.SubCategoryID, _ = strconv.Atoi(c.Param("categoryID"))
	category.ID, _ = strconv.Atoi(c.Param("typeID"))
	if err := c.ShouldBind(&category.Alias); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	if err := t.service.BindAlias(c, category); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"status": "success"})
}

// @Summary		Обновление псевдонимов подкатегории
// @Description	Обновление псевдонимов подкатегории
// @Description	`В дальнейшем добавится фильтры через query параметры`
// @Security		ApiKeyAuth
// @Accept			json
// @Produce		json
// @Tags			Sub category(под категория)
// @Param			Authorization	header		string			true	"приставка `Bearer` с пробелом и сам токен"
// @Param			id				path		int				true	"идентификатор подкатегории"
// @Param			body			body		[]model.Alias	true	"тело псевдонима"
// @Success		200				{object}	map[string]interface{}
// @Failure		403				{object}	map[string]interface{}
// @Failure		400,404			{object}	map[string]interface{}
// @Failure		500				{object}	map[string]interface{}
// @Failure		default			{object}	map[string]interface{}
// @Router			/:categoryID/sub_category/:typeID [put]
func (t *typeSM) UpdateAlias(c *gin.Context) {
	var category model.Type

	category.ID, _ = strconv.Atoi(c.Param(":typeID"))
	if err := c.ShouldBind(&category.Alias); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	if err := t.service.UpdateAlias(c, category); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"status": "success"})
}
