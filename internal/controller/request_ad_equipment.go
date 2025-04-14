package controller

import (
	"encoding/json"
	"errors"
	"fmt"
	"net/http"
	"strconv"

	"github.com/gin-gonic/gin"
	"gitlab.com/eqshare/eqshare-back/internal/service"
	"gitlab.com/eqshare/eqshare-back/model"
	"gitlab.com/eqshare/eqshare-back/pkg/util"
)

type requestAdEquipment struct {
	requestAdEquipmentService service.IRequestAdEquipment
}

func NewRequestAdEquipment(r *gin.Engine, auth service.IAuthentication, requestAdEquipmentService service.IRequestAdEquipment) {
	h := requestAdEquipment{
		requestAdEquipmentService: requestAdEquipmentService,
	}

	ad := r.Group("equipment/request_ad_equipment")

	ad.GET("",
		h.Get,
	)
	ad.GET(":id",
		h.GetByID,
	)
	ad.GET(":id/history",
		h.History,
	)
	ad.POST("",
		authorize(auth, model.ROLE_ADMIN, model.ROLE_DRIVER, model.ROLE_OWNER, model.ROLE_CLIENT),
		h.Create,
	)
	ad.POST(":id/approve",
		authorize(auth, model.ROLE_ADMIN, model.ROLE_DRIVER, model.ROLE_OWNER, model.ROLE_CLIENT),
		h.ApproveByID,
	)
	ad.POST(":id/canceled",
		authorize(auth, model.ROLE_ADMIN, model.ROLE_DRIVER, model.ROLE_OWNER, model.ROLE_CLIENT),
		h.CanceledByID,
	)
	ad.PATCH(":id/executor",
		authorize(auth, model.ROLE_ADMIN, model.ROLE_DRIVER, model.ROLE_OWNER, model.ROLE_CLIENT),
		h.UpdateExecutor,
	)
}

//	@Summary		Создание RequestAdEquipment
//	@Description	Создание заявки на объявления оборудование.
//	@Description	По параметру base нужно передавть все параметры в описании в формате json
//	@Description	executor_id тот кто должен выполнить работу
//	@Tags			RequestAdEquipment (заявки на объявления оборудование)
//	@Accept			mpfd
//	@Produce		json
//	@Param			base	body		controller.Create.requestAdEquipmentRequest	true	"тело объявления, не body а formData, значение в json"
//	@Param			foto	formData	file										true	"фото объявления"
//	@Success		200		{object}	map[string]interface{}
//	@Failure		400		{object}	map[string]interface{}
//	@Failure		404		{object}	map[string]interface{}
//	@Failure		500		{object}	map[string]interface{}
//	@Router			/equipment/request_ad_equipment [post]
func (h *requestAdEquipment) Create(c *gin.Context) {
	type requestAdEquipmentRequest struct {
		AdEquipmentID int        `json:"ad_equipment_id"`
		StartLeaseAt  model.Time `json:"start_lease_at"`
		EndLeaseAt    model.Time `json:"end_lease_at"`
		CountHour     *int       `json:"count_hour"`
		OrderAmount   *int       `json:"order_amount"`
		// ExecutorID    *int       `json:"executor_id"`
		Description string   `json:"description"`
		Address     string   `json:"address"`
		Latitude    *float64 `json:"latitude"`
		Longitude   *float64 `json:"longitude"`
	}

	r := model.RequestAdEquipment{}

	user, err := GetUserFromGin(c)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	r.UserID = user.ID

	mf, err := c.MultipartForm()
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	if len(mf.Value["base"]) != 0 {
		d := mf.Value["base"][0]
		radeR := requestAdEquipmentRequest{}

		err := json.Unmarshal([]byte(d), &radeR)
		if err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": fmt.Sprintf("invalid input in base: %s", err.Error())})
			return
		}
		{
			r.AdEquipmentID = radeR.AdEquipmentID
			r.StartLeaseAt = radeR.StartLeaseAt
			r.EndLeaseAt = radeR.EndLeaseAt
			r.CountHour = radeR.CountHour
			r.OrderAmount = radeR.OrderAmount
			r.Description = radeR.Description
			r.Address = radeR.Address
			r.Latitude = radeR.Latitude
			r.Longitude = radeR.Longitude
			// r.ExecutorID = radeR.ExecutorID
		}
	} else {
		c.JSON(http.StatusBadRequest, gin.H{"error": "don't have base"})
		return
	}

	for _, fh := range mf.File["foto"] {
		doc, err := util.ParseDocumentOnMultipart(fh)
		if err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
			return
		}
		doc.UserID = user.ID
		r.Document = append(r.Document, doc)
	}

	err = h.requestAdEquipmentService.Create(c, r)
	if err != nil {
		if errors.Is(err, model.ErrInvalidTimeRange) {
			c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
			return
		}
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"status": "success"})
}

//	@Summary		Получения списка RequestAdEquipment
//	@Description	Получения списка заявки на объявления оборудование.
//	@Tags			RequestAdEquipment (заявки на объявления оборудование)
//	@Accept			json
//	@Produce		json
//	@Param			user_detail				query		bool	false	"детальная информация"
//	@Param			executor_detail			query		bool	false	"детальная информация"
//	@Param			ad_equipment_detail		query		bool	false	"детальная информация"
//	@Param			document_detail			query		bool	false	"получение фотографии"
//	@Param			unscoped				query		bool	false	"получени удаленных и не удаленных записей"
//	@Param			ids						query		int		false	"можно несколько раз, фильтр по названию параметра"
//	@Param			ad_equipment_ids		query		int		false	"можно несколько раз, идентификатор объявления"
//	@Param			ad_equipment_user_ids	query		int		false	"можно несколько раз, идентификатор автора объявления"
//	@Param			user_ids				query		int		false	"можно несколько раз, идентификатор автора заявки"
//	@Param			limit					query		int		false	"лимит"
//	@Param			offset					query		int		false	"оффсет"
//	@Param			status					query		string	false	"фильтр по статусу"
//	@Success		200						{object}	[]model.RequestAdEquipment
//	@Failure		400						{object}	map[string]interface{}
//	@Failure		404						{object}	map[string]interface{}
//	@Failure		500						{object}	map[string]interface{}
//	@Router			/equipment/request_ad_equipment [get]
func (h *requestAdEquipment) Get(c *gin.Context) {
	f := model.FilterRequestAdEquipment{}

	if val, ok := c.GetQuery("document_detail"); ok {
		v, err := strconv.ParseBool(val)
		if err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": fmt.Errorf("document_detail: %w", err).Error()})
			return
		}
		f.DocumentDetail = &v
	}
	if val, ok := c.GetQuery("user_detail"); ok {
		v, err := strconv.ParseBool(val)
		if err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": fmt.Errorf("user_detail: %w", err).Error()})
			return
		}
		f.UserDetail = &v
	}
	if val, ok := c.GetQuery("executor_detail"); ok {
		v, err := strconv.ParseBool(val)
		if err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": fmt.Errorf("executor_detail: %w", err).Error()})
			return
		}
		f.ExecutorDetail = &v
	}
	if val, ok := c.GetQuery("ad_equipment_detail"); ok {
		v, err := strconv.ParseBool(val)
		if err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": fmt.Errorf("ad_equipment_detail: %w", err).Error()})
			return
		}
		f.AdEquipmentDetail = &v
	}
	if val, ok := c.GetQuery("unscoped"); ok {
		v, err := strconv.ParseBool(val)
		if err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": fmt.Errorf("unscoped: %w", err).Error()})
			return
		}
		f.Unscoped = &v
	}
	if vals, ok := c.GetQueryArray("ad_equipment_user_ids"); ok {
		f.AdEquipmentUserIDs = make([]int, 0, len(vals))
		for _, v := range vals {
			id, err := strconv.Atoi(v)
			if err != nil {
				c.JSON(http.StatusBadRequest, gin.H{"error": fmt.Errorf("ad_equipment_user_ids: query values: %s: error:  %w", v, err).Error()})
				return
			}
			f.AdEquipmentUserIDs = append(f.AdEquipmentUserIDs, id)
		}
	}
	if vals, ok := c.GetQueryArray("user_ids"); ok {
		f.UserIDs = make([]int, 0, len(vals))
		for _, v := range vals {
			id, err := strconv.Atoi(v)
			if err != nil {
				c.JSON(http.StatusBadRequest, gin.H{"error": fmt.Errorf("user_ids: query values: %s: error:  %w", v, err).Error()})
				return
			}
			f.UserIDs = append(f.UserIDs, id)
		}
	}
	if vals, ok := c.GetQueryArray("ids"); ok {
		f.IDs = make([]int, 0, len(vals))
		for _, v := range vals {
			id, err := strconv.Atoi(v)
			if err != nil {
				c.JSON(http.StatusBadRequest, gin.H{"error": fmt.Errorf("ids: query values: %s: error:  %w", v, err).Error()})
				return
			}
			f.IDs = append(f.IDs, id)
		}
	}
	if vals, ok := c.GetQueryArray("ad_equipment_ids"); ok {
		f.AdEquipmentIDs = make([]int, 0, len(vals))
		for _, v := range vals {
			id, err := strconv.Atoi(v)
			if err != nil {
				c.JSON(http.StatusBadRequest, gin.H{"error": fmt.Errorf("ad_equipment_ids: query values: %s: error:  %w", v, err).Error()})
				return
			}
			f.AdEquipmentIDs = append(f.AdEquipmentIDs, id)
		}
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
	if val, ok := c.GetQuery("status"); ok {
		f.Status = &val
	}

	res, total, err := h.requestAdEquipmentService.Get(c, f)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"request_ad_equipments": res, "total": total})
}

//	@Summary		Получени по идентификатору RequestAdEquipment
//	@Description	Получени по идентификатору заявки на объявления оборудование.
//	@Tags			RequestAdEquipment (заявки на объявления оборудование)
//	@Accept			json
//	@Produce		json
//	@Param			id	path		int	true	"идентификатор заявки"
//	@Success		200	{object}	model.RequestAdEquipment
//	@Failure		400	{object}	map[string]interface{}
//	@Failure		404	{object}	map[string]interface{}
//	@Failure		500	{object}	map[string]interface{}
//	@Router			/equipment/request_ad_equipment/{id} [get]
func (h *requestAdEquipment) GetByID(c *gin.Context) {
	id, err := strconv.Atoi(c.Param("id"))
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": fmt.Errorf("id: %w", err).Error()})
		return
	}

	res, err := h.requestAdEquipmentService.GetByID(c, id)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"request_ad_equipment": res})
}

//	@Summary		Потверждение RequestAdEquipment
//	@Description	Потверждение заявки со стороны водителя.
//	@Tags			RequestAdEquipment (заявки на объявления оборудование)
//	@Accept			json
//	@Produce		json
//	@Param			id		path		int								true	"идентификатор заявки"
//	@Param			base	body		controller.ApproveByID.request	true	"исполнитель"
//	@Success		200		{object}	map[string]interface{}
//	@Failure		400		{object}	map[string]interface{}
//	@Failure		404		{object}	map[string]interface{}
//	@Failure		500		{object}	map[string]interface{}
//	@Router			/equipment/request_ad_equipment/{id}/approve [post]
func (h *requestAdEquipment) ApproveByID(c *gin.Context) {
	type request struct {
		ExecutorID *int `json:"executor_id"`
	}

	id, err := strconv.Atoi(c.Param("id"))
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": fmt.Errorf("id: %w", err).Error()})
		return
	}

	r := request{}

	if err := c.BindJSON(&r); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": fmt.Errorf("body: %w", err).Error()})
		return
	}

	err = h.requestAdEquipmentService.ApproveByID(c, id, r.ExecutorID)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"status": "success"})
}

//	@Summary		Отклонение RequestAdEquipment
//	@Description	Отклонение заявки со стороны водителя.
//	@Tags			RequestAdEquipment (заявки на объявления оборудование)
//	@Accept			json
//	@Produce		json
//	@Param			id	path		int	true	"идентификатор заявки"
//	@Success		200	{object}	map[string]interface{}
//	@Failure		400	{object}	map[string]interface{}
//	@Failure		404	{object}	map[string]interface{}
//	@Failure		500	{object}	map[string]interface{}
//	@Router			/equipment/request_ad_equipment/{id}/canceled [post]
func (h *requestAdEquipment) CanceledByID(c *gin.Context) {
	id, err := strconv.Atoi(c.Param("id"))
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": fmt.Errorf("id: %w", err).Error()})
		return
	}

	err = h.requestAdEquipmentService.CanceledByID(c, id)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"status": "success"})
}

//	@Summary		Получения списка истории изменении RequestAdEquipment
//	@Description	Получения списка истории изменении заявки на объявления оборудование.
//	@Tags			RequestAdEquipment (заявки на объявления оборудование)
//	@Accept			json
//	@Produce		json
//	@Param			user_detail			query		bool	false	"детальная информация"
//	@Param			executor_detail		query		bool	false	"детальная информация"
//	@Param			ad_equipment_detail	query		bool	false	"детальная информация"
//	@Param			unscoped			query		bool	false	"получени удаленных и не удаленных записей"
//	@Param			ad_equipment_ids	query		int		false	"можно несколько раз, фильтр по названию параметра"
//	@Param			limit				query		int		false	"лимит"
//	@Param			offset				query		int		false	"оффсет"
//	@Param			status				query		string	false	"фильтр по статусу"
//	@Success		200					{object}	[]model.RequestAdEquipment
//	@Failure		400					{object}	map[string]interface{}
//	@Failure		404					{object}	map[string]interface{}
//	@Failure		500					{object}	map[string]interface{}
//	@Router			/equipment/request_ad_equipment/{id}/history [get]
func (h *requestAdEquipment) History(c *gin.Context) {
	f := model.FilterRequestAdEquipment{}

	id, err := strconv.Atoi(c.Param("id"))
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": fmt.Errorf("id: %w", err).Error()})
		return
	}

	f.IDs = []int{id}

	if val, ok := c.GetQuery("user_detail"); ok {
		v, err := strconv.ParseBool(val)
		if err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": fmt.Errorf("user_detail: %w", err).Error()})
			return
		}
		f.UserDetail = &v
	}
	if val, ok := c.GetQuery("executor_detail"); ok {
		v, err := strconv.ParseBool(val)
		if err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": fmt.Errorf("executor_detail: %w", err).Error()})
			return
		}
		f.ExecutorDetail = &v
	}
	if val, ok := c.GetQuery("ad_equipment_detail"); ok {
		v, err := strconv.ParseBool(val)
		if err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": fmt.Errorf("ad_equipment_detail: %w", err).Error()})
			return
		}
		f.AdEquipmentDetail = &v
	}
	if val, ok := c.GetQuery("unscoped"); ok {
		v, err := strconv.ParseBool(val)
		if err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": fmt.Errorf("unscoped: %w", err).Error()})
			return
		}
		f.Unscoped = &v
	}
	if vals, ok := c.GetQueryArray("ad_equipment_ids"); ok {
		f.AdEquipmentIDs = make([]int, 0, len(vals))
		for _, v := range vals {
			id, err := strconv.Atoi(v)
			if err != nil {
				c.JSON(http.StatusBadRequest, gin.H{"error": fmt.Errorf("ad_equipment_ids: query values: %s: error:  %w", v, err).Error()})
				return
			}
			f.AdEquipmentIDs = append(f.AdEquipmentIDs, id)
		}
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
	if val, ok := c.GetQuery("status"); ok {
		f.Status = &val
	}

	res, total, err := h.requestAdEquipmentService.GetHistoryByID(c, f)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"request_ad_equipments": res, "total": total})
}

//	@Summary	Изменить исполнителя работы RequestAdEquipment
//	@Tags		RequestAdEquipment (заявки на объявления оборудование)
//	@Accept		json
//	@Produce	json
//	@Param		base	body		controller.UpdateExecutor.request	true	"исполнитель"
//	@Success	200		{object}	map[string]interface{}
//	@Failure	400		{object}	map[string]interface{}
//	@Failure	404		{object}	map[string]interface{}
//	@Failure	500		{object}	map[string]interface{}
//	@Router		/equipment/request_ad_equipment/{id}/executor [patch]
func (h *requestAdEquipment) UpdateExecutor(c *gin.Context) {
	type request struct {
		ExecutorID int `json:"executor_id"`
	}

	id, err := strconv.Atoi(c.Param("id"))
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": fmt.Errorf("id: %w", err).Error()})
		return
	}

	r := request{}

	if err := c.BindJSON(&r); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": fmt.Errorf("id: %w", err).Error()})
		return
	}

	err = h.requestAdEquipmentService.UpdateExecutorID(c, model.RequestAdEquipment{
		ID:         id,
		ExecutorID: &r.ExecutorID,
	})
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"status": "success"})
}
