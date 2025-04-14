package controller

import (
	"fmt"
	"github.com/gin-gonic/gin"
	"gitlab.com/eqshare/eqshare-back/internal/service"
	"gitlab.com/eqshare/eqshare-back/model"
	"gitlab.com/eqshare/eqshare-back/pkg/util"
	"net/http"
	"strconv"
)

type subCategory struct {
	sbCategoryService service.ISubCategoryService
	authService       service.IAuthentication
}

func NewSubCategory(sb *gin.Engine, sbCategoryService service.ISubCategoryService, authService service.IAuthentication) {
	handler := subCategory{
		sbCategoryService: sbCategoryService,
		authService:       authService,
	}

	sbCategory := sb.Group("/category")
	sbCategory.POST("", authorize(authService, model.ROLE_ADMIN), handler.Create)
	sbCategory.GET("", handler.GetList)
	sbCategory.GET("/:id", handler.Get)
	sbCategory.GET("/find", handler.GetShortCategories)
	sbCategory.PUT("", authorize(authService, model.ROLE_ADMIN), handler.Update)
	sbCategory.DELETE("/:id", authorize(authService, model.ROLE_ADMIN), handler.Delete)

	sbCategory.PUT("/:id/bind", authorize(authService, model.ROLE_ADMIN, model.ROLE_CLIENT), handler.BindAlias)
	sbCategory.PUT("/:id", authorize(authService, model.ROLE_ADMIN), handler.UpdateAlias)
}

//	@Summary		Создание подкатегории
//	@Description	Создание подкатегории
//	@Description	`В дальнейшем добавится фильтры через query параметры`
//	@Security		ApiKeyAuth
//	@Accept			json
//	@Produce		json
//	@Tags			Category
//	@Param			Authorization	header		string				true	"приставка `Bearer` с пробелом и сам токен"
//	@Param			body			formData	model.SubCategory	true	"тело подкатегории"
//	@Param			typeID			path		int					true	"идентификатор категории"
//	@Success		200				{object}	map[string]interface{}
//	@Failure		403				{object}	map[string]interface{}
//	@Failure		400,404			{object}	map[string]interface{}
//	@Failure		500				{object}	map[string]interface{}
//	@Failure		default			{object}	map[string]interface{}
//	@Router			/category [post]
func (h *subCategory) Create(ctx *gin.Context) {
	var sbCategory model.SubCategory
	if err := ctx.ShouldBind(&sbCategory); err != nil {
		ctx.JSON(http.StatusBadRequest, gin.H{"reason": err.Error()})
		return
	}

	user, err := GetUserFromGin(ctx)
	if err != nil {
		ctx.JSON(http.StatusForbidden, gin.H{"reason": err.Error()})
		return
	}

	formData, err := ctx.MultipartForm()
	if err != nil {
		ctx.JSON(http.StatusBadRequest, gin.H{"reason": fmt.Sprintf("invalid input error: %s", err.Error())})
		return
	}

	sbCategory.UserID = user.ID
	sbCategory, err = util.ParseDocuments(sbCategory, formData)
	if err != nil {
		ctx.JSON(http.StatusBadRequest, gin.H{"reason": err.Error()})
		return
	}

	if err = h.sbCategoryService.Create(ctx, sbCategory); err != nil {
		ctx.JSON(http.StatusInternalServerError, gin.H{"reason": err.Error()})
		return
	}

	ctx.JSON(http.StatusOK, gin.H{"reason": "success"})
}

//	@Summary		Получение подкатегория по идентификатору
//	@Description	Получение подкатегория по идентификатору
//	@Description	`В дальнейшем добавится фильтры через query параметры`
//	@Security		ApiKeyAuth
//	@Accept			json
//	@Produce		json
//	@Tags			Category
//	@Param			Authorization	header		string	true	"приставка `Bearer` с пробелом и сам токен"
//	@Param			id				path		int		true	"идентификатор подкатегории"
//	@Param			typeID			path		int		true	"идентификатор категории"
//	@Success		200				{object}	model.SubCategory
//	@Failure		403				{object}	map[string]interface{}
//	@Failure		400,404			{object}	map[string]interface{}
//	@Failure		500				{object}	map[string]interface{}
//	@Failure		default			{object}	map[string]interface{}
//	@Router			/category/:id [get]
func (h *subCategory) Get(ctx *gin.Context) {
	var sbCategory model.SubCategory

	sbCategory.ID, _ = strconv.Atoi(ctx.Param("id"))
	sbCategory, err := h.sbCategoryService.Get(ctx, sbCategory)
	if err != nil {
		ctx.JSON(http.StatusInternalServerError, gin.H{"reason": err.Error()})
		return
	}

	ctx.JSON(http.StatusOK, gin.H{"categories": sbCategory})
}

//	@Summary		Получение список подкатегории
//	@Description	Получение список подкатегория
//	@Description	`В дальнейшем добавится фильтры через query параметры`
//	@Security		ApiKeyAuth
//	@Accept			json
//	@Produce		json
//	@Tags			Category
//	@Param			Authorization		header		string	true	"приставка `Bearer` с пробелом и сам токен"
//	@Param			sub_category_type	query		string	true	"символ подкатегории"
//	@Param			typeID				path		int		true	"идентификатор категории"
//	@Success		200					{array}		model.SubCategory
//	@Failure		403					{object}	map[string]interface{}
//	@Failure		400,404				{object}	map[string]interface{}
//	@Failure		500					{object}	map[string]interface{}
//	@Failure		default				{object}	map[string]interface{}
//	@Router			/category [get]
func (h *subCategory) GetList(ctx *gin.Context) {
	sbs, err := h.sbCategoryService.GetList(ctx)
	if err != nil {
		ctx.JSON(http.StatusInternalServerError, gin.H{"reason": err.Error()})
		return
	}

	ctx.JSON(http.StatusOK, gin.H{"categories": sbs})
}

//	@Summary		Получение список подкатегории только с именами и идентификатору
//	@Description	Получение список подкатегория с именами и идентификатору
//	@Description	`В дальнейшем добавится фильтры через query параметры`
//	@Security		ApiKeyAuth
//	@Accept			json
//	@Produce		json
//	@Tags			Category
//	@Param			Authorization	header		string	true	"приставка `Bearer` с пробелом и сам токен"
//	@Param			name			query		string	true	"префикс слов категории или подкатегории"
//	@Param			cityID			query		int		false	"локация поиска"
//	@Success		200				{array}		model.ShortCategories
//	@Failure		403				{object}	map[string]interface{}
//	@Failure		400,404			{object}	map[string]interface{}
//	@Failure		500				{object}	map[string]interface{}
//	@Failure		default			{object}	map[string]interface{}
//	@Router			/category/find [get]
func (h *subCategory) GetShortCategories(ctx *gin.Context) {
	categories, err := h.sbCategoryService.GetList(ctx)
	if err != nil {
		ctx.JSON(http.StatusInternalServerError, gin.H{"reason": err.Error()})
		return
	}

	query := ctx.Query("name")
	shorts, err := h.sbCategoryService.FindCategories(ctx, categories, query)
	if err != nil {
		ctx.JSON(http.StatusInternalServerError, gin.H{"reason": err.Error()})
		return
	}

	ctx.JSON(http.StatusOK, gin.H{"categories": shorts})
}

//	@Summary		Обновление подкатегории
//	@Description	Обновление подкатегории
//	@Description	`В дальнейшем добавится фильтры через query параметры`
//	@Security		ApiKeyAuth
//	@Accept			json
//	@Produce		json
//	@Tags			Category
//	@Param			Authorization	header		string				true	"приставка `Bearer` с пробелом и сам токен"
//	@Param			body			formData	model.SubCategory	true	"тело подкатегории"
//	@Param			typeID			path		int					true	"идентификатор категории"
//	@Success		200				{object}	model.SubCategory
//	@Failure		403				{object}	map[string]interface{}
//	@Failure		400,404			{object}	map[string]interface{}
//	@Failure		500				{object}	map[string]interface{}
//	@Failure		default			{object}	map[string]interface{}
//	@Router			/category [put]
func (h *subCategory) Update(ctx *gin.Context) {
	var sbCategory model.SubCategory
	if err := ctx.ShouldBind(&sbCategory); err != nil {
		ctx.JSON(http.StatusBadRequest, gin.H{"reason": err.Error()})
		return
	}

	user, err := GetUserFromGin(ctx)
	if err != nil {
		ctx.JSON(http.StatusForbidden, gin.H{"reason": err.Error()})
		return
	}

	formData, err := ctx.MultipartForm()
	if err != nil {
		ctx.JSON(http.StatusBadRequest, gin.H{"reason": fmt.Sprintf("invalid input error: %s", err.Error())})
		return
	}

	sbCategory.UserID = user.ID
	sbCategory, err = util.ParseDocuments(sbCategory, formData)
	if err != nil {
		ctx.JSON(http.StatusBadRequest, gin.H{"reason": err.Error()})
		return
	}

	sbCategory, err = h.sbCategoryService.Update(ctx, sbCategory)
	if err != nil {
		ctx.JSON(http.StatusInternalServerError, gin.H{"reason": err.Error()})
		return
	}

	ctx.JSON(http.StatusOK, sbCategory)
}

//	@Summary		Удаление подкатегории
//	@Description	Удаление подкатегории
//	@Description	`В дальнейшем добавится фильтры через query параметры`
//	@Security		ApiKeyAuth
//	@Accept			json
//	@Produce		json
//	@Tags			Category
//	@Param			Authorization	header		string	true	"приставка `Bearer` с пробелом и сам токен"
//	@Param			id				path		int		true	"идентификатор подкатегории"
//	@Param			typeID			path		int		true	"идентификатор категории"
//	@Success		200				{object}	map[string]interface{}
//	@Failure		403				{object}	map[string]interface{}
//	@Failure		400,404			{object}	map[string]interface{}
//	@Failure		500				{object}	map[string]interface{}
//	@Failure		default			{object}	map[string]interface{}
//	@Router			/category/:id [delete]
func (h *subCategory) Delete(ctx *gin.Context) {
	var sbCategory model.SubCategory

	sbCategory.ID, _ = strconv.Atoi(ctx.Param("id"))
	if err := h.sbCategoryService.Delete(ctx, sbCategory); err != nil {
		ctx.JSON(http.StatusInternalServerError, gin.H{"reason": err.Error()})
		return
	}

	ctx.JSON(http.StatusOK, gin.H{"reason": "success"})
}

//	@Summary		Добавление псевдонимов категории
//	@Description	Добавление псевдонимов категории
//	@Description	`В дальнейшем добавится фильтры через query параметры`
//	@Security		ApiKeyAuth
//	@Accept			json
//	@Produce		json
//	@Tags			Category
//	@Param			Authorization	header		string			true	"приставка `Bearer` с пробелом и сам токен"
//	@Param			id				path		int				true	"идентификатор подкатегории"
//	@Param			body			body		[]model.Alias	true	"тело псевдонима"
//	@Success		200				{object}	map[string]interface{}
//	@Failure		403				{object}	map[string]interface{}
//	@Failure		400,404			{object}	map[string]interface{}
//	@Failure		500				{object}	map[string]interface{}
//	@Failure		default			{object}	map[string]interface{}
//	@Router			/category/:id/bind [put]
func (h *subCategory) BindAlias(ctx *gin.Context) {
	var sbCategory model.SubCategory

	sbCategory.ID, _ = strconv.Atoi(ctx.Param("id"))
	if err := ctx.ShouldBind(&sbCategory.Alias); err != nil {
		ctx.JSON(http.StatusBadRequest, gin.H{"reason": err.Error()})
		return
	}

	if err := h.sbCategoryService.BindAlias(ctx, sbCategory); err != nil {
		ctx.JSON(http.StatusInternalServerError, gin.H{"reason": err.Error()})
		return
	}

	ctx.JSON(http.StatusOK, gin.H{"categories": sbCategory})
}

//	@Summary		Обновление псевдонимов категории
//	@Description	Обновление псевдонимов категории
//	@Description	`В дальнейшем добавится фильтры через query параметры`
//	@Security		ApiKeyAuth
//	@Accept			json
//	@Produce		json
//	@Tags			Category
//	@Param			Authorization	header		string			true	"приставка `Bearer` с пробелом и сам токен"
//	@Param			id				path		int				true	"идентификатор подкатегории"
//	@Param			body			body		[]model.Alias	true	"тело псевдонима"
//	@Success		200				{object}	map[string]interface{}
//	@Failure		403				{object}	map[string]interface{}
//	@Failure		400,404			{object}	map[string]interface{}
//	@Failure		500				{object}	map[string]interface{}
//	@Failure		default			{object}	map[string]interface{}
//	@Router			/category/:id [put]
func (h *subCategory) UpdateAlias(ctx *gin.Context) {
	var sbCategory model.SubCategory

	sbCategory.ID, _ = strconv.Atoi(ctx.Param("id"))
	if err := ctx.ShouldBind(&sbCategory.Alias); err != nil {
		ctx.JSON(http.StatusBadRequest, gin.H{"reason": err.Error()})
		return
	}

	if err := h.sbCategoryService.UpdateAlias(ctx, sbCategory); err != nil {
		ctx.JSON(http.StatusInternalServerError, gin.H{"reason": err.Error()})
		return
	}

	ctx.JSON(http.StatusOK, gin.H{"categories": sbCategory})
}
