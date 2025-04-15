package controller

import (
	"database/sql"
	"encoding/json"
	"fmt"
	"net/http"
	"strconv"
	"time"

	"github.com/gin-gonic/gin"
	"gitlab.com/eqshare/eqshare-back/internal/service"
	"gitlab.com/eqshare/eqshare-back/model"
	"gitlab.com/eqshare/eqshare-back/pkg/util"
)

type adEquipmentClient struct {
	adEquipmentClientSservice service.IAdEquipmentClient
}

func NewAdEquipmentClient(r *gin.Engine, auth service.IAuthentication, adEquipmentClientSservice service.IAdEquipmentClient) {
	h := adEquipmentClient{
		adEquipmentClientSservice: adEquipmentClientSservice,
	}

	ad := r.Group("equipment/ad_equipment_client")

	ad.GET("", h.Get)
	ad.GET(":id", h.GetByID)
	ad.POST("", authorize(auth, model.ROLE_DRIVER, model.ROLE_CLIENT, model.ROLE_OWNER, model.ROLE_ADMIN), h.Create)
	ad.PUT(":id", authorize(auth, model.ROLE_DRIVER, model.ROLE_CLIENT, model.ROLE_OWNER, model.ROLE_ADMIN), h.Update)
	ad.DELETE(":id", authorize(auth, model.ROLE_DRIVER, model.ROLE_CLIENT, model.ROLE_OWNER, model.ROLE_ADMIN), h.Delete)

	ad.GET("favorite", authorize(auth, model.ROLE_ADMIN, model.ROLE_DRIVER, model.ROLE_OWNER, model.ROLE_CLIENT), h.GetFavorite)
	ad.POST(":id/favorite", authorize(auth, model.ROLE_ADMIN, model.ROLE_DRIVER, model.ROLE_OWNER, model.ROLE_CLIENT), h.CreateFavority)
	ad.DELETE(":id/favorite", authorize(auth, model.ROLE_ADMIN, model.ROLE_DRIVER, model.ROLE_OWNER, model.ROLE_CLIENT), h.DeleteFavorite)

	ad.GET(":id/seen", h.GetSeen)
	ad.POST(":id/seen", h.IncrementSeen)
}

// @Summary		Создание AdEquipment
// @Description	Создание оборудование.
// @Description	По параметру base нужно передавть все параметры в описании в формате json
// @Tags			AdEquipmentClient (объявления оборудование клиента)
// @Accept			mpfd
// @Produce		json
// @Param			base	body		controller.Create.adEquipmentClientsRequest	true	"тело объявления, не body а formData, значение в json"
// @Param			foto	formData	file										true	"фото объявления"
// @Success		200		{object}	map[string]interface{}
// @Failure		400		{object}	map[string]interface{}
// @Failure		404		{object}	map[string]interface{}
// @Failure		500		{object}	map[string]interface{}
// @Router			/equipment/ad_equipment_client [post]
func (h *adEquipmentClient) Create(c *gin.Context) {
	type adEquipmentClientsRequest struct {
		CityID                 int        `json:"city_id"`
		EquipmentSubcategoryID int        `json:"equipment_subcategory_id"`
		Status                 string     `json:"status"`
		Title                  string     `json:"title"`
		Description            string     `json:"description"`
		Price                  *float64   `json:"price"`
		StartLeaseAt           model.Time `json:"start_lease_date"`
		EndLeaseAt             model.Time `json:"end_lease_date"`
		Address                string     `json:"address"`
		Latitude               *float64   `json:"latitude"`
		Longitude              *float64   `json:"longitude"`
	}

	ad := model.AdEquipmentClient{}
	user, err := GetUserFromGin(c)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": fmt.Sprintf("get user error: %s", err.Error())})
		return
	}

	mf, err := c.MultipartForm()
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": fmt.Sprintf("invalid input error: %s", err.Error())})
		return
	}

	ad.UserID = user.ID

	if len(mf.Value["base"]) != 0 {
		d := mf.Value["base"][0]
		adR := adEquipmentClientsRequest{}
		err := json.Unmarshal([]byte(d), &adR)
		if err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": fmt.Sprintf("invalid input in base error: %s", err.Error())})
			return
		}
		{
			ad.CityID = adR.CityID
			ad.EquipmentSubCategoryID = adR.EquipmentSubcategoryID
			ad.Status = adR.Status
			ad.Title = adR.Title
			ad.Description = adR.Description
			ad.Price = adR.Price
			ad.StartLeaseAt = adR.StartLeaseAt
			ad.EndLeaseAt = adR.EndLeaseAt
			ad.Address = adR.Address
			ad.Latitude = adR.Latitude
			ad.Longitude = adR.Longitude
		}
	} else {
		c.JSON(http.StatusBadRequest, gin.H{"error": "don't have base"})
		return
	}

	for _, fh := range mf.File["foto"] {
		doc, err := util.ParseDocumentOnMultipart(fh)
		if err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": fmt.Errorf("parse foto error: %w", err).Error()})
			return
		}
		doc.UserID = user.ID
		ad.Documents = append(ad.Documents, doc)
	}

	err = h.adEquipmentClientSservice.Create(c, ad)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"status": "success"})
}

// @Summary	Получение списка AdEquipment
// @Tags		AdEquipmentClient (объявления оборудование клиента)
// @Accept		mpfd
// @Produce	json
// @Param		user_detail						query		bool	false	"при значении true дает полную информацию параметра"
// @Param		equipment_subcategory_detail	query		bool	false	"при значении true дает полную информацию параметра"
// @Param		city_detail						query		bool	false	"при значении true дает полную информацию параметра"
// @Param		documents_detail				query		bool	false	"при значении true дает полную информацию параметра"
// @Param		unscoped						query		bool	false	"при значении true дает дает удаленные и не удаленные данные"
// @Param		offset							query		integer	false	"сдвиг получение данных"
// @Param		limit							query		integer	false	"лимит получение данных"
// @Param		ids								query		integer	false	"можно передавать несколько раз. филтры по идентификаторам параметров"
// @Param		user_id							query		integer	false	"можно передавать несколько раз. филтры по идентификаторам параметров"
// @Param		equipment_brand_id				query		integer	false	"можно передавать несколько раз. филтры по идентификаторам параметров"
// @Param		equipment_subcategory_id		query		integer	false	"можно передавать несколько раз. филтры по идентификаторам параметров"
// @Param		equipment_category_id			query		integer	false	"можно передавать несколько раз. филтры по идентификаторам подкатегориям"
// @Param		city_ids						query		integer	false	"можно передавать несколько раз. филтры по идентификаторам параметров"
// @Param		status							query		string	false	"ишет совпадение в названии параметра"
// @Param		title							query		string	false	"ишет совпадение в названии параметра"
// @Param		description						query		string	false	"ишет совпадение в названии параметра"
// @Param		price							query		float64	false	"фильтр диапазона, формат записи: {дробное или натуральное число или *}-{дробное или натуральное число или *}"
// @Success	200								{object}	map[string]interface{}
// @Failure	400								{object}	map[string]interface{}
// @Failure	404								{object}	map[string]interface{}
// @Failure	500								{object}	map[string]interface{}
// @Router		/equipment/ad_equipment_client [get]
func (h *adEquipmentClient) Get(c *gin.Context) {
	f := model.FilterAdEquipmentClients{}

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
	if val, ok := c.GetQuery("unscoped"); ok {
		val, err := strconv.ParseBool(val)
		if err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": fmt.Errorf("unscoped: %w", err).Error()})
			return
		}
		f.Unscoped = &val
	}
	if val, ok := c.GetQuery("user_detail"); ok {
		val, err := strconv.ParseBool(val)
		if err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": fmt.Errorf("user_detail: %w", err).Error()})
			return
		}
		f.UserDetail = &val
	}

	if val, ok := c.GetQuery("city_detail"); ok {
		val, err := strconv.ParseBool(val)
		if err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": fmt.Errorf("city_detail: %w", err).Error()})
			return
		}
		f.CityDetail = &val
	}

	if val, ok := c.GetQuery("equipment_subcategory_detail"); ok {
		val, err := strconv.ParseBool(val)
		if err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": fmt.Errorf("equipment_subcategory_detail: %w", err).Error()})
			return
		}
		f.EquipmentSubСategoryDetail = &val
	}

	if val, ok := c.GetQuery("documents_detail"); ok {
		val, err := strconv.ParseBool(val)
		if err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": fmt.Errorf("documents_detail: %w", err).Error()})
			return
		}
		f.DocumentsDetail = &val
	}
	if vals, ok := c.GetQueryArray("id"); ok {
		f.IDs = make([]int, 0, len(vals))
		for _, v := range vals {
			id, err := strconv.Atoi(v)
			if err != nil {
				c.JSON(http.StatusBadRequest, gin.H{"error": fmt.Errorf("id: %w", err).Error()})
				return
			}
			f.IDs = append(f.IDs, id)
		}
	}
	if vals, ok := c.GetQueryArray("user_id"); ok {
		f.UserIDs = make([]int, 0, len(vals))
		for _, v := range vals {
			id, err := strconv.Atoi(v)
			if err != nil {
				c.JSON(http.StatusBadRequest, gin.H{"error": fmt.Errorf("user_id: %w", err).Error()})
				return
			}
			f.UserIDs = append(f.UserIDs, id)
		}
	}
	if vals, ok := c.GetQueryArray("city_id"); ok {
		f.CityIDs = make([]int, 0, len(vals))
		for _, v := range vals {
			id, err := strconv.Atoi(v)
			if err != nil {
				c.JSON(http.StatusBadRequest, gin.H{"error": fmt.Errorf("city_id: %w", err).Error()})
				return
			}
			if model.Kazakstan != id {
				f.CityIDs = append(f.CityIDs, id)
			}
		}
	}
	if vals, ok := c.GetQueryArray("equipment_subcategory_id"); ok {
		f.EquipmentSubСategoryIDs = make([]int, 0, len(vals))
		for _, v := range vals {
			id, err := strconv.Atoi(v)
			if err != nil {
				c.JSON(http.StatusBadRequest, gin.H{"error": fmt.Errorf("equipment_subcategory_id: %w", err).Error()})
				return
			}
			f.EquipmentSubСategoryIDs = append(f.EquipmentSubСategoryIDs, id)
		}
	}
	if vals, ok := c.GetQueryArray("equipment_category_id"); ok {
		f.EquipmentСategoryIDs = make([]int, 0, len(vals))
		for _, v := range vals {
			id, err := strconv.Atoi(v)
			if err != nil {
				c.JSON(http.StatusBadRequest, gin.H{"error": fmt.Errorf("equipment_category_id: %w", err).Error()})
				return
			}
			f.EquipmentСategoryIDs = append(f.EquipmentСategoryIDs, id)
		}
	}
	if val, ok := c.GetQuery("status"); ok {
		f.Status = &val
	}
	if val, ok := c.GetQuery("title"); ok {
		f.Title = &val
	}
	if val, ok := c.GetQuery("description"); ok {
		f.Description = &val
	}

	if p, err := setFilter(c, "price"); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": fmt.Errorf("equipment_subcategory_ids: %w", err).Error()})
		return
	} else {
		f.Price = p
	}
	if val, ok := c.GetQueryArray("asc"); ok {
		f.ASC = val
	}
	if val, ok := c.GetQueryArray("desc"); ok {
		f.DESC = val
	}

	res, total, err := h.adEquipmentClientSservice.Get(c, f)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"ad_equipment_clients": res, "total": total})
}

// @Summary	Получение списка AdEquipment
// @Tags		AdEquipmentClient (объявления оборудование клиента)
// @Accept		mpfd
// @Produce	json
// @Param		id	query		integer	true	"идентификатор оборудование"
// @Success	200	{object}	map[string]interface{}
// @Failure	400	{object}	map[string]interface{}
// @Failure	404	{object}	map[string]interface{}
// @Failure	500	{object}	map[string]interface{}
// @Router		/equipment/ad_equipment_client/{id} [get]
func (h *adEquipmentClient) GetByID(c *gin.Context) {
	id, err := strconv.Atoi(c.Param("id"))
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": fmt.Errorf("id: %w", err).Error()})
		return
	}

	res, err := h.adEquipmentClientSservice.GetByID(c, id)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"ad_equipment_client": res})
}

// @Summary		Обновление AdEquipmentClient
// @Description	Обновление AdEquipmentClient
// @Tags			AdEquipmentClient (объявления оборудование клиента)
// @Accept			json
// @Produce		json
// @Param			id		path		int	true	"ad Equipment client ID"
// @Param			data	body		controller.Update.adEquipmentClientUpdateRequest	true	"AdEquipmentClient Update Payload"
// @Success		200	{object}	map[string]interface{}
// @Failure		400	{object}	map[string]interface{}
// @Failure		404	{object}	map[string]interface{}
// @Failure		500	{object}	map[string]interface{}
// @Router			/equipment/ad_equipment_client/{id} [put]
func (h *adEquipmentClient) Update(c *gin.Context) {
	type adEquipmentClientUpdateRequest struct {
		UserID                 int      `json:"user_id"`
		CityID                 int      `json:"city_id"`
		EquipmentSubСategoryID int      `json:"equipment_subcategory_id"`
		Status                 string   `json:"status"`
		Price                  *float64 `json:"price"`
		Title                  string   `json:"title"`
		Description            string   `json:"description"`
		StartLeaseDate         string   `json:"start_lease_date"`
		EndLeaseDate           string   `json:"end_lease_date"`
		Address                string   `json:"address"`
		Latitude               *float64 `json:"latitude"`
		Longitude              *float64 `json:"longitude"`
	}

	idParam := c.Param("id")
	if idParam == "" {
		c.JSON(http.StatusBadRequest, gin.H{"error": "missing id"})
		return
	}
	id, err := strconv.Atoi(idParam)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "wrong id format"})
		return
	}

	adR := adEquipmentClientUpdateRequest{}
	if err := c.ShouldBindJSON(&adR); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": fmt.Sprintf("invalid input: %s", err.Error())})
		return
	}

	startLeaseDate, err := time.Parse("2006-01-02 15:04:05.000000", adR.StartLeaseDate)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": fmt.Sprintf("invalid start lease date expected format 2006-01-02 15:04:05.000000: %s", err.Error())})
		return
	}

	endLeaseDate, err := time.Parse("2006-01-02 15:04:05.000000", adR.EndLeaseDate)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": fmt.Sprintf("invalid end lease date expected 2006-01-02 15:04:05.000000: %s", err.Error())})
		return
	}

	updateAdEquipmentClient := model.AdEquipmentClient{
		ID:                     id,
		UserID:                 adR.UserID,
		CityID:                 adR.CityID,
		EquipmentSubCategoryID: adR.EquipmentSubСategoryID,
		Status:                 adR.Status,
		Price:                  adR.Price,
		Title:                  adR.Title,
		Description:            adR.Description,
		StartLeaseAt: model.Time{
			NullTime: sql.NullTime{
				Time:  startLeaseDate,
				Valid: true,
			},
		},
		EndLeaseAt: model.Time{
			NullTime: sql.NullTime{
				Time:  endLeaseDate,
				Valid: true,
			},
		},
		Address:   adR.Address,
		Latitude:  adR.Latitude,
		Longitude: adR.Longitude,
	}

	err = h.adEquipmentClientSservice.Update(c, updateAdEquipmentClient)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"status": "success"})
}

// @Summary	Удаление AdEquipment
// @Tags		AdEquipmentClient (объявления оборудование клиента)
// @Accept		mpfd
// @Produce	json
// @Param		id	query		integer	true	"идентификатор оборудование"
// @Success	200	{object}	map[string]interface{}
// @Failure	400	{object}	map[string]interface{}
// @Failure	404	{object}	map[string]interface{}
// @Failure	500	{object}	map[string]interface{}
// @Router		/equipment/ad_equipment_client/{id} [delete]
func (h *adEquipmentClient) Delete(c *gin.Context) {
	id, err := strconv.Atoi(c.Param("id"))
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": fmt.Errorf("id: %w", err).Error()})
		return
	}

	if err := h.adEquipmentClientSservice.Delete(c, id); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"status": "success"})
}

// @Summary	Получение список избранных
// @Tags		AdEquipmentClient (объявления оборудование)
// @Accept		json
// @Produce	json
// @Param		Authorization	header		string	true	"приставка `Bearer` с пробелом и сам токен"
// @Success	200				{object}	[]model.FavoriteAdEquipment
// @Failure	400				{object}	map[string]interface{}
// @Failure	404				{object}	map[string]interface{}
// @Failure	500				{object}	map[string]interface{}
// @Router		/equipment/ad_equipment_client/favorite [get]
func (h *adEquipmentClient) GetFavorite(c *gin.Context) {
	user, err := GetUserFromGin(c)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	fav, err := h.adEquipmentClientSservice.GetFavorite(c, user.ID)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"favorites": fav})
}

// @Summary	Сохранение в список избранных
// @Tags		AdEquipmentClient (объявления оборудование)
// @Accept		json
// @Produce	json
// @Param		Authorization	header		string	true	"приставка `Bearer` с пробелом и сам токен"
// @Param		id				path		string	true	"идентификатор объявления"
// @Success	200				{object}	map[string]interface{}
// @Failure	400				{object}	map[string]interface{}
// @Failure	404				{object}	map[string]interface{}
// @Failure	500				{object}	map[string]interface{}
// @Router		/equipment/ad_equipment_client/:id/favorite [post]
func (h *adEquipmentClient) CreateFavority(c *gin.Context) {
	user, err := GetUserFromGin(c)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	f := model.FavoriteAdEquipmentClient{}

	id, err := strconv.Atoi(c.Param("id"))
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	f.UserID = user.ID
	f.AdEquipmentClientID = id

	if err := h.adEquipmentClientSservice.CreateFavorite(c, f); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"status": "success"})
}

// @Summary	Удаление из списока избранных
// @Tags		AdEquipmentClient (объявления оборудование)
// @Accept		json
// @Produce	json
// @Param		Authorization	header		string	true	"приставка `Bearer` с пробелом и сам токен"
// @Param		id				path		string	true	"идентификатор объявления"
// @Success	200				{object}	map[string]interface{}
// @Failure	400				{object}	map[string]interface{}
// @Failure	404				{object}	map[string]interface{}
// @Failure	500				{object}	map[string]interface{}
// @Router		/equipment/ad_equipment_client/:id/favorite [delete]
func (h *adEquipmentClient) DeleteFavorite(c *gin.Context) {
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

	if err := h.adEquipmentClientSservice.DeleteFavorite(c, model.FavoriteAdEquipmentClient{
		UserID:              user.ID,
		AdEquipmentClientID: id,
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
// @Router		/equipment/ad_equipment_client/:id/seen [get]
func (h *adEquipmentClient) GetSeen(c *gin.Context) {
	id, err := strconv.Atoi(c.Param("id"))
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"parameter": "id", "error": err.Error()})
		return
	}

	count, err := h.adEquipmentClientSservice.GetSeen(c, id)
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
// @Router		/equipment/ad_equipment_client/:id/seen [post]
func (h *adEquipmentClient) IncrementSeen(c *gin.Context) {
	id, err := strconv.Atoi(c.Param("id"))
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"parameter": "id", "error": err.Error()})
		return
	}

	err = h.adEquipmentClientSservice.IncrementSeen(c, id)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"status": "success"})
}
