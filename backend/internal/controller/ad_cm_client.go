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

type adConstructionMaterialClient struct {
	adConstructionMaterialClientService service.IAdConstructionMaterialClient
}

func NewAdConstructionMaterialClient(r *gin.Engine, auth service.IAuthentication, adConstructionMaterialClientSservice service.IAdConstructionMaterialClient) {
	h := adConstructionMaterialClient{
		adConstructionMaterialClientService: adConstructionMaterialClientSservice,
	}

	ad := r.Group("construction_material/ad_construction_material_client")

	ad.GET("", h.Get)
	ad.GET(":id", h.GetByID)
	ad.POST("", authorize(auth, model.ROLE_DRIVER, model.ROLE_CLIENT, model.ROLE_OWNER, model.ROLE_ADMIN), h.Create)
	ad.PUT(":id", authorize(auth, model.ROLE_DRIVER, model.ROLE_CLIENT, model.ROLE_OWNER, model.ROLE_ADMIN), h.Update)
	ad.DELETE(":id", authorize(auth, model.ROLE_DRIVER, model.ROLE_CLIENT, model.ROLE_OWNER, model.ROLE_ADMIN), h.Delete)

	ad.GET("favorite", authorize(auth, model.ROLE_ADMIN, model.ROLE_DRIVER, model.ROLE_OWNER, model.ROLE_CLIENT), h.GetFavorite)
	ad.POST(":id/favorite", authorize(auth, model.ROLE_ADMIN, model.ROLE_DRIVER, model.ROLE_OWNER, model.ROLE_CLIENT), h.CreateFavorite)
	ad.DELETE(":id/favorite", authorize(auth, model.ROLE_ADMIN, model.ROLE_DRIVER, model.ROLE_OWNER, model.ROLE_CLIENT), h.DeleteFavorite)

	ad.GET(":id/seen", h.GetSeen)
	ad.POST(":id/seen", h.IncrementSeen)
}

// Create
// @Summary		Создание AdConstructionMaterial
// @Description	Создание оборудование.
// @Description	По параметру base нужно передавть все параметры в описании в формате json
// @Tags			AdConstructionMaterialClient (объявления строй материалов клиента)
// @Accept			mpfd
// @Produce		json
// @Param			base	body		controller.Create.adConstructionMaterialClientsRequest	true	"тело объявления, не body а formData, значение в json"
// @Param			foto	formData	file										true	"фото объявления"
// @Success		200		{object}	map[string]interface{}
// @Failure		400		{object}	map[string]interface{}
// @Failure		404		{object}	map[string]interface{}
// @Failure		500		{object}	map[string]interface{}
// @Router			/construction_material/ad_construction_material_client [post]
func (h *adConstructionMaterialClient) Create(c *gin.Context) {
	type adConstructionMaterialClientsRequest struct {
		CityID                            int        `json:"city_id"`
		ConstructionMaterialSubcategoryID int        `json:"construction_material_subcategory_id"`
		Status                            string     `json:"status"`
		Title                             string     `json:"title"`
		Description                       string     `json:"description"`
		Price                             *float64   `json:"price"`
		StartLeaseAt                      model.Time `json:"start_lease_date"`
		EndLeaseAt                        model.Time `json:"end_lease_date"`
		Address                           string     `json:"address"`
		Latitude                          *float64   `json:"latitude"`
		Longitude                         *float64   `json:"longitude"`
	}

	ad := model.AdConstructionMaterialClient{}
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
		adR := adConstructionMaterialClientsRequest{}
		err := json.Unmarshal([]byte(d), &adR)
		if err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": fmt.Sprintf("invalid input in base error: %s", err.Error())})
			return
		}
		{
			ad.CityID = adR.CityID
			ad.ConstructionMaterialSubCategoryID = adR.ConstructionMaterialSubcategoryID
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

	err = h.adConstructionMaterialClientService.Create(c, ad)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"status": "success"})
}

// Get
// @Summary	Получение списка AdConstructionMaterial
// @Tags		AdConstructionMaterialClient (объявления строй материалов клиента)
// @Accept		mpfd
// @Produce	json
// @Param		user_detail						query		bool	false	"при значении true дает полную информацию параметра"
// @Param		construction_material_subcategory_detail	query		bool	false	"при значении true дает полную информацию параметра"
// @Param		city_detail						query		bool	false	"при значении true дает полную информацию параметра"
// @Param		documents_detail				query		bool	false	"при значении true дает полную информацию параметра"
// @Param		unscoped						query		bool	false	"при значении true дает дает удаленные и не удаленные данные"
// @Param		offset							query		integer	false	"сдвиг получение данных"
// @Param		limit							query		integer	false	"лимит получение данных"
// @Param		ids								query		integer	false	"можно передавать несколько раз. филтры по идентификаторам параметров"
// @Param		user_id							query		integer	false	"можно передавать несколько раз. филтры по идентификаторам параметров"
// @Param		construction_material_brand_id				query		integer	false	"можно передавать несколько раз. филтры по идентификаторам параметров"
// @Param		construction_material_subcategory_id		query		integer	false	"можно передавать несколько раз. филтры по идентификаторам параметров"
// @Param		construction_material_category_id			query		integer	false	"можно передавать несколько раз. филтры по идентификаторам подкатегориям"
// @Param		city_ids						query		integer	false	"можно передавать несколько раз. филтры по идентификаторам параметров"
// @Param		status							query		string	false	"ишет совпадение в названии параметра"
// @Param		title							query		string	false	"ишет совпадение в названии параметра"
// @Param		description						query		string	false	"ишет совпадение в названии параметра"
// @Param		price							query		float64	false	"фильтр диапазона, формат записи: {дробное или натуральное число или *}-{дробное или натуральное число или *}"
// @Success	200								{object}	map[string]interface{}
// @Failure	400								{object}	map[string]interface{}
// @Failure	404								{object}	map[string]interface{}
// @Failure	500								{object}	map[string]interface{}
// @Router		/construction_material/ad_construction_material_client [get]
func (h *adConstructionMaterialClient) Get(c *gin.Context) {
	f := model.FilterAdConstructionMaterialClients{}

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

	if val, ok := c.GetQuery("construction_material_subcategory_detail"); ok {
		val, err := strconv.ParseBool(val)
		if err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": fmt.Errorf("construction_material_subcategory_detail: %w", err).Error()})
			return
		}
		f.ConstructionMaterialSubСategoryDetail = &val
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
	if vals, ok := c.GetQueryArray("construction_material_subcategory_id"); ok {
		f.ConstructionMaterialSubСategoryIDs = make([]int, 0, len(vals))
		for _, v := range vals {
			id, err := strconv.Atoi(v)
			if err != nil {
				c.JSON(http.StatusBadRequest, gin.H{"error": fmt.Errorf("construction_material_subcategory_id: %w", err).Error()})
				return
			}
			f.ConstructionMaterialSubСategoryIDs = append(f.ConstructionMaterialSubСategoryIDs, id)
		}
	}
	if vals, ok := c.GetQueryArray("construction_material_category_id"); ok {
		f.ConstructionMaterialСategoryIDs = make([]int, 0, len(vals))
		for _, v := range vals {
			id, err := strconv.Atoi(v)
			if err != nil {
				c.JSON(http.StatusBadRequest, gin.H{"error": fmt.Errorf("construction_material_category_id: %w", err).Error()})
				return
			}
			f.ConstructionMaterialСategoryIDs = append(f.ConstructionMaterialСategoryIDs, id)
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
		c.JSON(http.StatusBadRequest, gin.H{"error": fmt.Errorf("construction_material_subcategory_ids: %w", err).Error()})
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

	res, total, err := h.adConstructionMaterialClientService.Get(c, f)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"ad_construction_material_clients": res, "total": total})
}

// GetByID
// @Summary	Получение списка AdConstructionMaterial
// @Tags		AdConstructionMaterialClient (объявления строй материалов клиента)
// @Accept		mpfd
// @Produce	json
// @Param		id	query		integer	true	"идентификатор оборудование"
// @Success	200	{object}	map[string]interface{}
// @Failure	400	{object}	map[string]interface{}
// @Failure	404	{object}	map[string]interface{}
// @Failure	500	{object}	map[string]interface{}
// @Router		/construction_material/ad_construction_material_client/{id} [get]
func (h *adConstructionMaterialClient) GetByID(c *gin.Context) {
	id, err := strconv.Atoi(c.Param("id"))
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": fmt.Errorf("id: %w", err).Error()})
		return
	}

	res, err := h.adConstructionMaterialClientService.GetByID(c, id)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"ad_construction_material_client": res})
}

// Update
// @Summary		Обновление AdConstructionMaterial
// @Description	В плане выполнения. Ещё не сделано.
// @Tags			AdConstructionMaterialClient (объявления строй материалов клиента)
//
//	@Accept			json
//	@Produce		json
//	@Param			id		path		int	true	"ad Construction Material client ID"
//	@Param			data	body		controller.Update.adConstructionMaterialClientUpdateRequest	true	"adConstructionMaterialClient Update Payload"
//
// @Success		200	{object}	map[string]interface{}
// @Failure		400	{object}	map[string]interface{}
// @Failure		404	{object}	map[string]interface{}
// @Failure		500	{object}	map[string]interface{}
// @Router			/construction_material/ad_construction_material_client/{id} [put]
func (h *adConstructionMaterialClient) Update(c *gin.Context) {
	type adConstructionMaterialClientUpdateRequest struct {
		UserID                            int      `json:"user_id"`
		CityID                            int      `json:"city_id"`
		ConstructionMaterialSubCategoryID int      `json:"construction_material_sub_category_id"`
		Status                            string   `json:"status"`
		Price                             *float64 `json:"price"`
		Title                             string   `json:"title"`
		Description                       string   `json:"description"`
		StartLeaseDate                    string   `json:"start_lease_date"`
		EndLeaseDate                      string   `json:"end_lease_date"`
		Address                           string   `json:"address"`
		Latitude                          *float64 `json:"latitude"`
		Longitude                         *float64 `json:"longitude"`
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

	adR := adConstructionMaterialClientUpdateRequest{}
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

	updateAdServiceClient := model.AdConstructionMaterialClient{
		ID:                                id,
		UserID:                            adR.UserID,
		CityID:                            adR.CityID,
		ConstructionMaterialSubCategoryID: adR.ConstructionMaterialSubCategoryID,
		Status:                            adR.Status,
		Price:                             adR.Price,
		Title:                             adR.Title,
		Description:                       adR.Description,
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

	err = h.adConstructionMaterialClientService.Update(c, updateAdServiceClient)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"status": "success"})
}

// Delete
// @Summary	Удаление AdConstructionMaterial
// @Tags		AdConstructionMaterialClient (объявления строй материалов клиента)
// @Accept		mpfd
// @Produce	json
// @Param		id	query		integer	true	"идентификатор оборудование"
// @Success	200	{object}	map[string]interface{}
// @Failure	400	{object}	map[string]interface{}
// @Failure	404	{object}	map[string]interface{}
// @Failure	500	{object}	map[string]interface{}
// @Router		/construction_material/ad_construction_material_client/{id} [delete]
func (h *adConstructionMaterialClient) Delete(c *gin.Context) {
	id, err := strconv.Atoi(c.Param("id"))
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": fmt.Errorf("id: %w", err).Error()})
		return
	}

	if err := h.adConstructionMaterialClientService.Delete(c, id); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"status": "success"})
}

// GetFavorite
// @Summary	Получение список избранных
// @Tags		AdConstructionMaterialClient (объявления строй материалов клиента)
// @Accept		json
// @Produce	json
// @Param		Authorization	header		string	true	"приставка `Bearer` с пробелом и сам токен"
// @Success	200				{object}	[]model.FavoriteAdConstructionMaterial
// @Failure	400				{object}	map[string]interface{}
// @Failure	404				{object}	map[string]interface{}
// @Failure	500				{object}	map[string]interface{}
// @Router		/construction_material/ad_construction_material_client/favorite [get]
func (h *adConstructionMaterialClient) GetFavorite(c *gin.Context) {
	user, err := GetUserFromGin(c)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	fav, err := h.adConstructionMaterialClientService.GetFavorite(c, user.ID)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"favorites": fav})
}

// CreateFavorite
// @Summary	Сохранение в список избранных
// @Tags		AdConstructionMaterialClient (объявления строй материалов клиента)
// @Accept		json
// @Produce	json
// @Param		Authorization	header		string	true	"приставка `Bearer` с пробелом и сам токен"
// @Param		id				path		string	true	"идентификатор объявления"
// @Success	200				{object}	map[string]interface{}
// @Failure	400				{object}	map[string]interface{}
// @Failure	404				{object}	map[string]interface{}
// @Failure	500				{object}	map[string]interface{}
// @Router		/construction_material/ad_construction_material_client/:id/favorite [post]
func (h *adConstructionMaterialClient) CreateFavorite(c *gin.Context) {
	user, err := GetUserFromGin(c)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	f := model.FavoriteAdConstructionMaterialClient{}

	id, err := strconv.Atoi(c.Param("id"))
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	f.UserID = user.ID
	f.AdConstructionMaterialClientID = id

	if err := h.adConstructionMaterialClientService.CreateFavorite(c, f); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"status": "success"})
}

// DeleteFavorite
// @Summary	Удаление из списка избранных
// @Tags		AdConstructionMaterialClient (объявления строй материалов клиента)
// @Accept		json
// @Produce	json
// @Param		Authorization	header		string	true	"приставка `Bearer` с пробелом и сам токен"
// @Param		id				path		string	true	"идентификатор объявления"
// @Success	200				{object}	map[string]interface{}
// @Failure	400				{object}	map[string]interface{}
// @Failure	404				{object}	map[string]interface{}
// @Failure	500				{object}	map[string]interface{}
// @Router		/construction_material/ad_construction_material_client/:id/favorite [delete]
func (h *adConstructionMaterialClient) DeleteFavorite(c *gin.Context) {
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

	if err := h.adConstructionMaterialClientService.DeleteFavorite(c, model.FavoriteAdConstructionMaterialClient{
		UserID:                         user.ID,
		AdConstructionMaterialClientID: id,
	}); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"status": "success"})
}

// GetSeen
// @Summary	Получение количество просмотров
// @Tags		AdConstructionMaterialClient (объявления строй материалов клиента)
// @Accept		json
// @Produce	json
// @Param		id	path		string	true	"идентификатор объявления"
// @Success	200	{object}	map[string]int
// @Failure	400	{object}	map[string]interface{}
// @Failure	404	{object}	map[string]interface{}
// @Failure	500	{object}	map[string]interface{}
// @Router		/construction_material/ad_construction_material_client/:id/seen [get]
func (h *adConstructionMaterialClient) GetSeen(c *gin.Context) {
	id, err := strconv.Atoi(c.Param("id"))
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"parameter": "id", "error": err.Error()})
		return
	}

	count, err := h.adConstructionMaterialClientService.GetSeen(c, id)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"count": count})
}

// IncrementSeen
// @Summary	Инкремент просмотра количество
// @Tags		AdConstructionMaterialClient (объявления строй материалов клиента)
// @Accept		json
// @Produce	json
// @Param		id	path		string	true	"идентификатор объявления"
// @Success	200	{object}	map[string]interface{}
// @Failure	400	{object}	map[string]interface{}
// @Failure	404	{object}	map[string]interface{}
// @Failure	500	{object}	map[string]interface{}
// @Router		/construction_material/ad_construction_material_client/:id/seen [post]
func (h *adConstructionMaterialClient) IncrementSeen(c *gin.Context) {
	id, err := strconv.Atoi(c.Param("id"))
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"parameter": "id", "error": err.Error()})
		return
	}

	err = h.adConstructionMaterialClientService.IncrementSeen(c, id)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"status": "success"})
}
