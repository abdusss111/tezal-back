package controller

import (
	"errors"
	"fmt"
	"net/http"
	"strconv"

	"github.com/gin-gonic/gin"
	"gitlab.com/eqshare/eqshare-back/internal/service"
	"gitlab.com/eqshare/eqshare-back/model"
	"gitlab.com/eqshare/eqshare-back/pkg/util"
)

type adClient struct {
	service  service.IAdClient
	uService service.IUser
}

func NewAdClient(r *gin.Engine, service service.IAdClient,
	auth service.IAuthentication, uService service.IUser) {
	handler := &adClient{
		service:  service,
		uService: uService,
	}

	adClientHandler := r.Group("/ad_client")
	adClientHandler.POST("/", authorize(auth, model.ROLE_CLIENT, model.ROLE_ADMIN, model.ROLE_OWNER), handler.Create)
	adClientHandler.PUT("/", authorize(auth, model.ROLE_CLIENT, model.ROLE_ADMIN, model.ROLE_OWNER), handler.Update)
	adClientHandler.GET("/", handler.GetList)
	adClientHandler.GET("/:id", handler.GetByID)
	adClientHandler.DELETE("/:id", authorize(auth, model.ROLE_CLIENT, model.ROLE_ADMIN, model.ROLE_OWNER), handler.Delete)
	adClientHandler.POST("/:id/interacted", authorize(auth, model.ROLE_DRIVER), handler.Interacted)
	adClientHandler.GET("/:id/interacted", authorize(auth, model.ROLE_CLIENT), handler.GetInteracted)

	adClientHandler.GET("favorite", authorize(auth, model.ROLE_ADMIN, model.ROLE_DRIVER, model.ROLE_OWNER, model.ROLE_CLIENT), handler.GetFavorite)
	adClientHandler.POST("/:id/favorite", authorize(auth, model.ROLE_ADMIN, model.ROLE_DRIVER, model.ROLE_OWNER, model.ROLE_CLIENT), handler.CreateFavority)
	adClientHandler.DELETE("/:id/favorite", authorize(auth, model.ROLE_ADMIN, model.ROLE_DRIVER, model.ROLE_OWNER, model.ROLE_CLIENT), handler.DeleteFavorite)

	adClientHandler.GET(":id/seen", handler.GetSeen)
	adClientHandler.POST(":id/seen", handler.IncrementSeen)

}

// @Summary		Создание объявлении клиента о работе.
// @Description	Создание объявлении клиента о работе.
// @Description	`В дальнейшем добавится фильтры через query параметры`
// @Security		ApiKeyAuth
// @Accept			multipart/form-data
// @Produce		json
// @Tags			ad_client(обьявлении клиента спецтехники)
// @Param			Authorization	header		string	true	"приставка `Bearer` с пробелом и сам токен"
// @Param			description		formData	string	true	"описание обьявлении"
// @Param			headline		formData	string	true	"заголовок обьявлении"
// @Param			price			formData	int		true	"стоимость работы"
// @Param			start_date		formData	string	true	"время начало работы"
// @Param			end_date		formData	string	true	"время окончание работы"
// @Param			documents		formData	file	true	"фотографий обьявлении"
// @Param			user_id			query		int		false	"ID пользователя, авторизующего в роли администратора для роли водителя"
// @Param			address			query		string	false	"Название вдреса"
// @Param			type_id			query		float64	false	"идентификатор подкатегории"
// @Param			city_id			query		float64	false	"идентификатор города"
// @Param			latitude		query		float64	false	"широта"
// @Param			longitude		query		float64	false	"долгота"
// @Success		200				{object}	[]model.AdClient
// @Failure		403				{object}	map[string]interface{}
// @Failure		400,404			{object}	map[string]interface{}
// @Failure		500				{object}	map[string]interface{}
// @Failure		default			{object}	map[string]interface{}
// @Router			/ad_client [post]
func (h *adClient) Create(ctx *gin.Context) {
	formData, err := ctx.MultipartForm()
	if err != nil {
		ctx.JSON(http.StatusBadRequest, gin.H{"reason": fmt.Sprintf("invalid input error: %s", err.Error())})
		return
	}

	user, err := GetUserFromGin(ctx)
	if err != nil {
		ctx.JSON(http.StatusUnauthorized, gin.H{"reason": fmt.Sprintf("client error: %s", err.Error())})
		return
	}

	if user.AccessRole == model.ROLE_ADMIN {
		user.ID, err = strconv.Atoi(ctx.Query("user_id"))

		if err != nil {
			ctx.JSON(http.StatusBadRequest, gin.H{"reason": fmt.Sprintf("invalid input error: %s", err.Error())})
			return
		}

		user, err = h.uService.GetByID(user.ID)
		if err != nil {
			ctx.JSON(http.StatusBadRequest, gin.H{"reason": fmt.Sprintf("invalid input error: %s", err.Error())})
			return
		}
	}

	adClient, err := util.AdClientFormDataParse(model.AdClient{UserID: user.ID}, formData)
	if err != nil {
		ctx.JSON(http.StatusBadRequest, gin.H{"reason": fmt.Sprintf("server error: %s", err.Error())})
		return
	}

	if err = h.service.Create(ctx, adClient); err != nil {
		ctx.JSON(http.StatusInternalServerError, gin.H{"reason": fmt.Sprintf("server error: %s", err.Error())})
		return
	}

	ctx.JSON(http.StatusOK, gin.H{"reason": "created!"})
}

// @Summary		Обновление объявлении клиента о работе.
// @Description	Обновление объявлении клиента о работе.
// @Description	`В дальнейшем добавится фильтры через query параметры`
// @Security		ApiKeyAuth
// @Accept			multipart/form-data
// @Produce		json
// @Tags			ad_client(обьявлении клиента спецтехники)
// @Param			Authorization	header		string	true	"приставка `Bearer` с пробелом и сам токен"
// @Param			description		formData	string	true	"описание обьявлении"
// @Param			headline		formData	string	true	"заголовок обьявлении"
// @Param			price			formData	int		true	"стоимость работы"
// @Param			start_date		formData	string	true	"время начало работы"
// @Param			end_date		formData	string	true	"время окончание работы"
// @Param			user_id			query		int		false	"ID пользователя, авторизующего в роли администратора для роли водителя"
// @Success		200				{object}	[]model.AdClient
// @Failure		403				{object}	map[string]interface{}
// @Failure		400,404			{object}	map[string]interface{}
// @Failure		500				{object}	map[string]interface{}
// @Failure		default			{object}	map[string]interface{}
// @Router			/ad_client [put]
func (h *adClient) Update(ctx *gin.Context) {
	formData, err := ctx.MultipartForm()
	if err != nil {
		ctx.JSON(http.StatusBadRequest, gin.H{"reason": fmt.Sprintf("invalid input error: %s", err.Error())})
		return
	}

	user, err := GetUserFromGin(ctx)
	if err != nil {
		ctx.JSON(http.StatusUnauthorized, gin.H{"reason": fmt.Sprintf("client error: %s", err.Error())})
		return
	}

	if user.AccessRole == model.ROLE_ADMIN {
		id, err := strconv.Atoi(ctx.Query("user_id"))
		if err == nil {
			user.ID = id
		}

		user, err = h.uService.GetByID(user.ID)
		if err != nil {
			ctx.JSON(http.StatusBadRequest, gin.H{"reason": fmt.Sprintf("invalid input error: %s", err.Error())})
			return
		}
	}

	adClient, err := util.AdClientFormDataParse(model.AdClient{UserID: user.ID}, formData)
	if err != nil {
		ctx.JSON(http.StatusBadRequest, gin.H{"reason": fmt.Sprintf("client error: %s", err.Error())})
		return
	}

	if err = h.service.Update(ctx, adClient); err != nil {
		ctx.JSON(http.StatusInternalServerError, gin.H{"reason": fmt.Sprintf("server error: %s", err.Error())})
		return
	}

	ctx.JSON(http.StatusOK, gin.H{"reason": "updated!"})
}

// @Summary		Получение объявлении клиента о работе по идентификатору.
// @Description	Создание объявлении клиента о работе по идентификатору.
// @Description	`В дальнейшем добавится фильтры через query параметры`
// @Security		ApiKeyAuth
// @Accept			json
// @Produce		json
// @Tags			ad_client(обьявлении клиента спецтехники)
// @Param			Authorization	header		string	true	"приставка `Bearer` с пробелом и сам токен"
// @Param			id				path		int		true	"идентификатор обьявлении"
// @Param			user_id			query		int		false	"ID пользователя, авторизующего в роли администратора для роли водителя"
// @Success		200				{object}	[]model.AdClient
// @Failure		403				{object}	map[string]interface{}
// @Failure		400,404			{object}	map[string]interface{}
// @Failure		500				{object}	map[string]interface{}
// @Failure		default			{object}	map[string]interface{}
// @Router			/ad_client/:id [get]
func (h *adClient) GetByID(ctx *gin.Context) {
	var (
		id     int
		userID int
		err    error
	)
	id, err = strconv.Atoi(ctx.Param("id"))
	if err != nil {
		ctx.JSON(http.StatusBadRequest, gin.H{"reason": fmt.Sprintf("invalid input error: %s", err.Error())})
		return
	}

	if idStr, ok := ctx.GetQuery("user_id"); ok {
		userID, err = strconv.Atoi(idStr)
		if err != nil {
			ctx.JSON(http.StatusBadRequest, gin.H{"reason": fmt.Sprintf("invalid input error: %s", err.Error())})
			return
		}
	}

	adClient, err := h.service.GetByID(ctx, model.AdClient{UserID: userID, ID: id})
	if err != nil {
		ctx.JSON(http.StatusInternalServerError, gin.H{"reason": fmt.Sprintf("server error: %s", err.Error())})
		return
	}

	ctx.JSON(http.StatusOK, gin.H{"ad_client": adClient})
}

// @Summary		Получение список объявлении клиента о работе.
// @Description	Получение список объявлении клиента о работе.
// @Description	`В дальнейшем добавится фильтры через query параметры`
// @Security		ApiKeyAuth
// @Accept			json
// @Produce		json
// @Tags			ad_client(обьявлении клиента спецтехники)
// @Param			Authorization	header		string	true	"приставка `Bearer` с пробелом и сам токен"
// @Param			user_id			query		int		false	"ID пользователя, авторизующего в роли администратора для роли водителя"
// @Param			unscoped		query		bool	false	"если админу потребуется вывести весь список включая удаленных записей"
// @Param			deleted			query		bool	false	"получение только удаленные записи"
// @Param			type_id			query		int		false	"идентификатор подкатегории спецтехники"
// @Param			category_id		query		int		false	"основная категория"
// @Param			city_id			query		int		false	"идентификатор города"
// @Param			status			query		int		false	"стаутс"
// @Param			limit			query		int		false	"лимит"
// @Param			offset			query		int		false	"сдвиг"
// @Success		200				{object}	[]model.AdClient
// @Failure		403				{object}	map[string]interface{}
// @Failure		400,404			{object}	map[string]interface{}
// @Failure		500				{object}	map[string]interface{}
// @Failure		default			{object}	map[string]interface{}
// @Router			/ad_client [get]
func (h *adClient) GetList(c *gin.Context) {
	var f model.FilterAdClient
	if unscopedStr, ok := c.GetQuery("unscoped"); ok {
		unscoped, err := strconv.ParseBool(unscopedStr)
		if err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error": fmt.Sprintf("query user_id: %v", err.Error())})
			return
		}
		f.Unscoped = &unscoped
	}

	if val, ok := c.GetQueryArray("ASC"); ok {
		f.ASC = val
	}

	if val, ok := c.GetQueryArray("DESC"); ok {
		f.DESC = val
	}

	if n, ok := c.GetQuery("type_id"); ok {
		n, err := strconv.Atoi(n)
		if err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": fmt.Sprintf("query type_id: %v", err.Error())})
			return
		}
		f.TypeID = &n
	}

	if n, ok := c.GetQuery("category_id"); ok {
		n, err := strconv.Atoi(n)
		if err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": fmt.Sprintf("query category_id: %v", err.Error())})
			return
		}
		f.SubCategoryID = &n
	}

	if n, ok := c.GetQuery("city_id"); ok {
		n, err := strconv.Atoi(n)
		if err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": fmt.Sprintf("query city_id: %v", err.Error())})
			return
		}
		if n != model.Kazakstan {
			f.CityID = &n
		}
	}

	if v, ok := c.GetQuery("deleted"); ok {
		temp, err := strconv.ParseBool(v)
		if err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": fmt.Sprintf("query deleted: %v", err.Error())})
			return
		}
		f.Deleted = &temp
	}

	if v, ok := c.GetQuery("status"); ok {
		f.Status = &v
	}

	id, err := strconv.Atoi(c.Query("user_id"))
	if err == nil {
		f.UserID = &id
	}

	if val, ok := c.GetQuery("limit"); ok {
		id, err := strconv.Atoi(val)
		if err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": fmt.Errorf("limit: %w", err).Error()})
			return
		}
		f.Limit = &id
	}
	if val, ok := c.GetQuery("offset"); ok {
		id, err := strconv.Atoi(val)
		if err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": fmt.Errorf("offset: %w", err).Error()})
			return
		}
		f.Offset = &id
	}

	var (
		adClients []model.AdClient
		total     int
	)

	adClients, total, err = h.service.GetList(c, f)
	if err != nil {
		if errors.Is(model.ErrNotFound, err) {
			c.JSON(http.StatusNoContent, gin.H{"reason": fmt.Sprintf("server error: %s", err.Error())})
			return
		}
		c.JSON(http.StatusInternalServerError, gin.H{"reason": fmt.Sprintf("server error: %s", err.Error())})
		return
	}

	c.JSON(http.StatusOK, gin.H{"ad_client": adClients, "total": total})
}

// @Summary		Удаление обьявлении клиента по идентификатору.
// @Description	Удаление обьявлении клиента по идентификатору.
// @Accept			json
// @Produce		json
// @Tags			Request
// @Param			Authorization	header		string			true	"приставка `Bearer` с пробелом и сам токен"
// @Param			id				query		int				true	"идентификатор заказа клиента"
// @Param			user_id			query		int				false	"ID пользователя, авторизующего в роли администратора для роли водителя"
// @Success		200				{array}		model.Request	"тело заказа"
// @Failure		403				{object}	map[string]interface{}
// @Failure		400,404			{object}	map[string]interface{}
// @Failure		500				{object}	map[string]interface{}
// @Failure		default			{object}	map[string]interface{}
// @Router			/ad_client/:id [delete]
func (h *adClient) Delete(c *gin.Context) {
	id, err := strconv.Atoi(c.Param("id"))
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	user, err := GetUserFromGin(c)
	if err != nil {
		c.JSON(http.StatusUnauthorized, gin.H{"reason": fmt.Sprintf("client error: %s", err.Error())})
		return
	}

	if err := h.service.Delete(c, model.AdClient{ID: id, UserID: user.ID}); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"status": "success"})
}

// @Summary	Для сохранения взаимодействия с объявлением.
// @Accept		json
// @Produce	json
// @Tags		Request
// @Param		Authorization	header		string	true	"`клиент` приставка `Bearer` с пробелом и сам токен"
// @Param		id				query		int		true	"идентификатор объявления  клиента"
// @Success	200				{array}		map[string]interface{}
// @Failure	403				{object}	map[string]interface{}
// @Failure	400,404			{object}	map[string]interface{}
// @Failure	500				{object}	map[string]interface{}
// @Failure	default			{object}	map[string]interface{}
// @Router		/ad_client/:id/interacted [post]
func (h *adClient) Interacted(c *gin.Context) {
	user, err := GetUserFromGin(c)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	id, err := strconv.Atoi(c.Param("id"))
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	if err := h.service.CreateInteracted(id, user.ID); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"status": "success"})
}

// @Summary	Для получения взаимодействия с объявлением.
// @Accept		json
// @Produce	json
// @Tags		Request
// @Param		Authorization	header		string	true	"`клиент` приставка `Bearer` с пробелом и сам токен"
// @Param		id				query		int		true	"идентификатор объявления клиента"
// @Success	200				{array}		model.AdClientInteracted
// @Failure	403				{object}	map[string]interface{}
// @Failure	400,404			{object}	map[string]interface{}
// @Failure	500				{object}	map[string]interface{}
// @Failure	default			{object}	map[string]interface{}
// @Router		/ad_client/:id/interacted [get]
func (h *adClient) GetInteracted(c *gin.Context) {
	id, err := strconv.Atoi(c.Param("id"))
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	adcs, err := h.service.GetInteracted(id)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"ad_client_interacted": adcs})
}

// @Summary	Сохранение в список избранных
// @Accept		json
// @Produce	json
// @Tags		Request
// @Tags		Favorite
// @Param		Authorization	header		string	true	"`клиент` приставка `Bearer` с пробелом и сам токен"
// @Param		id				query		int		true	"идентификатор объявления клиента"
// @Failure	200				{object}	map[string]interface{}
// @Failure	403				{object}	map[string]interface{}
// @Failure	400,404			{object}	map[string]interface{}
// @Failure	500				{object}	map[string]interface{}
// @Failure	default			{object}	map[string]interface{}
// @Router		/ad_client/:id/favorite [post]
func (h *adClient) CreateFavority(c *gin.Context) {
	user, err := GetUserFromGin(c)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	f := model.FavoriteAdClient{}

	id, err := strconv.Atoi(c.Param("id"))
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	f.UserID = user.ID
	f.AdClientID = id

	if err := h.service.CreateFavorite(c, f); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"status": "success"})
}

// @Summary	Получение список избранных
// @Accept		json
// @Produce	json
// @Tags		Request
// @Tags		Favorite
// @Param		Authorization	header		string	true	"`клиент` приставка `Bearer` с пробелом и сам токен"
// @Param		id				query		int		true	"идентификатор объявления клиента"
// @Failure	200				{object}	[]model.FavoriteAdClient
// @Failure	403				{object}	map[string]interface{}
// @Failure	400,404			{object}	map[string]interface{}
// @Failure	500				{object}	map[string]interface{}
// @Failure	default			{object}	map[string]interface{}
// @Router		/ad_client/favorite [get]
func (h *adClient) GetFavorite(c *gin.Context) {
	user, err := GetUserFromGin(c)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	fav, err := h.service.GetFavorite(c, user.ID)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"favorites": fav})
}

// @Summary	Удаление из списока избранных
// @Accept		json
// @Produce	json
// @Tags		Request
// @Tags		Favorite
// @Param		Authorization	header		string	true	"`клиент` приставка `Bearer` с пробелом и сам токен"
// @Param		id				query		int		true	"идентификатор объявления клиента"
// @Failure	200				{object}	map[string]interface{}
// @Failure	403				{object}	map[string]interface{}
// @Failure	400,404			{object}	map[string]interface{}
// @Failure	500				{object}	map[string]interface{}
// @Failure	default			{object}	map[string]interface{}
// @Router		/ad_client/:id/favorite [delete]
func (h *adClient) DeleteFavorite(c *gin.Context) {
	user, err := GetUserFromGin(c)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	id, err := strconv.Atoi(c.Param("id"))
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	if err := h.service.DeleteFavorite(c, model.FavoriteAdClient{
		UserID:     user.ID,
		AdClientID: id,
	}); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"status": "success"})
}

// @Summary	Получение количество просмотров
// @Tags		AdEquipmentClient
// @Accept		json
// @Produce	json
// @Param		id	path		string	true	"идентификатор объявления"
// @Success	200	{object}	map[string]int
// @Failure	400	{object}	map[string]interface{}
// @Failure	404	{object}	map[string]interface{}
// @Failure	500	{object}	map[string]interface{}
// @Router		/ad_client/:id/seen [get]
func (h *adClient) GetSeen(c *gin.Context) {
	id, err := strconv.Atoi(c.Param("id"))
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"parameter": "id", "error": err.Error()})
		return
	}

	count, err := h.service.GetSeen(c, id)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"count": count})
}

// @Summary	Инкремент просмотра количество
// @Tags		AdEquipmentClient
// @Accept		json
// @Produce	json
// @Param		id	path		string	true	"идентификатор объявления"
// @Success	200	{object}	map[string]interface{}
// @Failure	400	{object}	map[string]interface{}
// @Failure	404	{object}	map[string]interface{}
// @Failure	500	{object}	map[string]interface{}
// @Router		/ad_client/:id/seen [post]
func (h *adClient) IncrementSeen(c *gin.Context) {
	id, err := strconv.Atoi(c.Param("id"))
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"parameter": "id", "error": err.Error()})
		return
	}

	err = h.service.IncrementSeen(c, id)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"status": "success"})
}
