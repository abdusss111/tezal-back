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

type requestAdService struct {
	requestAdServiceService service.IRequestAdService
}

func NewRequestAdService(r *gin.Engine, auth service.IAuthentication, requestAdServiceService service.IRequestAdService) {
	h := requestAdService{
		requestAdServiceService: requestAdServiceService,
	}

	ad := r.Group("service/request_ad_service")

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

// Create
// @Summary		Создание RequestAdService
// @Description	Создание заявки на объявления услуг.
// @Description	По параметру base нужно передавать все параметры в описании в формате json
// @Description	executor_id тот кто должен выполнить работу
// @Tags			RequestAdService (заявки на объявления услуг)
// @Accept			mpfd
// @Produce		json
// @Param			base	body		controller.Create.requestAdServiceRequest	true	"тело объявления, не body а formData, значение в json"
// @Param			foto	formData	file										true	"фото объявления"
// @Success		200		{object}	map[string]interface{}
// @Failure		400		{object}	map[string]interface{}
// @Failure		404		{object}	map[string]interface{}
// @Failure		500		{object}	map[string]interface{}
// @Router			/service/request_ad_service [post]
func (h *requestAdService) Create(c *gin.Context) {
	type requestAdServiceRequest struct {
		AdServiceID  int        `json:"ad_service_id"`
		StartLeaseAt model.Time `json:"start_lease_at"`
		EndLeaseAt   model.Time `json:"end_lease_at"`
		CountHour    *int       `json:"count_hour"`
		OrderAmount  *int       `json:"order_amount"`
		// ExecutorID    *int       `json:"executor_id"`
		Description string   `json:"description"`
		Address     string   `json:"address"`
		Latitude    *float64 `json:"latitude"`
		Longitude   *float64 `json:"longitude"`
	}

	r := model.RequestAdService{}

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
		radeR := requestAdServiceRequest{}

		err := json.Unmarshal([]byte(d), &radeR)
		if err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": fmt.Sprintf("invalid input in base: %s", err.Error())})
			return
		}
		{
			r.AdServiceID = radeR.AdServiceID
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

	err = h.requestAdServiceService.Create(c, r)
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

// Get
// @Summary		Получения списка RequestAdService
// @Description	Получения списка заявки на объявления услуг.
// @Tags			RequestAdService (заявки на объявления услуг)
// @Accept			json
// @Produce		json
// @Param			user_detail				query		bool	false	"детальная информация"
// @Param			executor_detail			query		bool	false	"детальная информация"
// @Param			ad_service_detail		query		bool	false	"детальная информация"
// @Param			document_detail			query		bool	false	"получение фотографии"
// @Param			unscoped				query		bool	false	"получение удаленных и не удаленных записей"
// @Param			ids						query		int		false	"можно несколько раз, фильтр по названию параметра"
// @Param			ad_service_ids		query		int		false	"можно несколько раз, идентификатор объявления"
// @Param			ad_service_user_ids	query		int		false	"можно несколько раз, идентификатор автора объявления"
// @Param			user_ids				query		int		false	"можно несколько раз, идентификатор автора заявки"
// @Param			limit					query		int		false	"лимит"
// @Param			offset					query		int		false	"оффсет"
// @Param			status					query		string	false	"фильтр по статусу"
// @Success		200						{object}	[]model.RequestAdService
// @Failure		400						{object}	map[string]interface{}
// @Failure		404						{object}	map[string]interface{}
// @Failure		500						{object}	map[string]interface{}
// @Router			/service/request_ad_service [get]
func (h *requestAdService) Get(c *gin.Context) {
	f := model.FilterRequestAdService{}

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
	if val, ok := c.GetQuery("ad_service_detail"); ok {
		v, err := strconv.ParseBool(val)
		if err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": fmt.Errorf("ad_service_detail: %w", err).Error()})
			return
		}
		f.AdServiceDetail = &v
	}
	if val, ok := c.GetQuery("unscoped"); ok {
		v, err := strconv.ParseBool(val)
		if err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": fmt.Errorf("unscoped: %w", err).Error()})
			return
		}
		f.Unscoped = &v
	}
	if values, ok := c.GetQueryArray("ad_service_user_ids"); ok {
		f.AdServiceUserIDs = make([]int, 0, len(values))
		for _, v := range values {
			id, err := strconv.Atoi(v)
			if err != nil {
				c.JSON(http.StatusBadRequest, gin.H{"error": fmt.Errorf("ad_service_user_ids: query values: %s: error:  %w", v, err).Error()})
				return
			}
			f.AdServiceUserIDs = append(f.AdServiceUserIDs, id)
		}
	}
	if values, ok := c.GetQueryArray("user_ids"); ok {
		f.UserIDs = make([]int, 0, len(values))
		for _, v := range values {
			id, err := strconv.Atoi(v)
			if err != nil {
				c.JSON(http.StatusBadRequest, gin.H{"error": fmt.Errorf("user_ids: query values: %s: error:  %w", v, err).Error()})
				return
			}
			f.UserIDs = append(f.UserIDs, id)
		}
	}
	if values, ok := c.GetQueryArray("ids"); ok {
		f.IDs = make([]int, 0, len(values))
		for _, v := range values {
			id, err := strconv.Atoi(v)
			if err != nil {
				c.JSON(http.StatusBadRequest, gin.H{"error": fmt.Errorf("ids: query values: %s: error:  %w", v, err).Error()})
				return
			}
			f.IDs = append(f.IDs, id)
		}
	}
	if values, ok := c.GetQueryArray("ad_service_ids"); ok {
		f.AdServiceIDs = make([]int, 0, len(values))
		for _, v := range values {
			id, err := strconv.Atoi(v)
			if err != nil {
				c.JSON(http.StatusBadRequest, gin.H{"error": fmt.Errorf("ad_service_ids: query values: %s: error:  %w", v, err).Error()})
				return
			}
			f.AdServiceIDs = append(f.AdServiceIDs, id)
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

	res, total, err := h.requestAdServiceService.Get(c, f)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"request_ad_services": res, "total": total})
}

// GetByID
// @Summary		Получение по идентификатору RequestAdService
// @Description	Получение по идентификатору заявки на объявления услуг.
// @Tags			RequestAdService (заявки на объявления услуг)
// @Accept			json
// @Produce		json
// @Param			id	path		int	true	"идентификатор заявки"
// @Success		200	{object}	model.RequestAdService
// @Failure		400	{object}	map[string]interface{}
// @Failure		404	{object}	map[string]interface{}
// @Failure		500	{object}	map[string]interface{}
// @Router			/service/request_ad_service/{id} [get]
func (h *requestAdService) GetByID(c *gin.Context) {
	id, err := strconv.Atoi(c.Param("id"))
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": fmt.Errorf("id: %w", err).Error()})
		return
	}

	res, err := h.requestAdServiceService.GetByID(c, id)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"request_ad_service": res})
}

// ApproveByID
// @Summary		Подтверждение RequestAdService
// @Description	Подтверждение заявки со стороны водителя.
// @Tags			RequestAdService (заявки на объявления услуг)
// @Accept			json
// @Produce		json
// @Param			id		path		int								true	"идентификатор заявки"
// @Param			base	body		controller.ApproveByID.request	true	"исполнитель"
// @Success		200		{object}	map[string]interface{}
// @Failure		400		{object}	map[string]interface{}
// @Failure		404		{object}	map[string]interface{}
// @Failure		500		{object}	map[string]interface{}
// @Router			/service/request_ad_service/{id}/approve [post]
func (h *requestAdService) ApproveByID(c *gin.Context) {
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

	err = h.requestAdServiceService.ApproveByID(c, id, r.ExecutorID)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"status": "success"})
}

// CanceledByID
// @Summary		Отклонение RequestAdService
// @Description	Отклонение заявки со стороны водителя.
// @Tags			RequestAdService (заявки на объявления услуг)
// @Accept			json
// @Produce		json
// @Param			id	path		int	true	"идентификатор заявки"
// @Success		200	{object}	map[string]interface{}
// @Failure		400	{object}	map[string]interface{}
// @Failure		404	{object}	map[string]interface{}
// @Failure		500	{object}	map[string]interface{}
// @Router			/service/request_ad_service/{id}/canceled [post]
func (h *requestAdService) CanceledByID(c *gin.Context) {
	id, err := strconv.Atoi(c.Param("id"))
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": fmt.Errorf("id: %w", err).Error()})
		return
	}

	err = h.requestAdServiceService.CanceledByID(c, id)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"status": "success"})
}

// History
// @Summary		Получения списка истории изменении RequestAdService
// @Description	Получения списка истории изменении заявки на объявления услуг.
// @Tags			RequestAdService (заявки на объявления услуг)
// @Accept			json
// @Produce		json
// @Param			user_detail			query		bool	false	"детальная информация"
// @Param			executor_detail		query		bool	false	"детальная информация"
// @Param			ad_service_detail	query		bool	false	"детальная информация"
// @Param			unscoped			query		bool	false	"получение удаленных и не удаленных записей"
// @Param			ad_service_ids	query		int		false	"можно несколько раз, фильтр по названию параметра"
// @Param			limit				query		int		false	"лимит"
// @Param			offset				query		int		false	"оффсет"
// @Param			status				query		string	false	"фильтр по статусу"
// @Success		200					{object}	[]model.RequestAdService
// @Failure		400					{object}	map[string]interface{}
// @Failure		404					{object}	map[string]interface{}
// @Failure		500					{object}	map[string]interface{}
// @Router			/service/request_ad_service/{id}/history [get]
func (h *requestAdService) History(c *gin.Context) {
	f := model.FilterRequestAdService{}

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
	if val, ok := c.GetQuery("ad_service_detail"); ok {
		v, err := strconv.ParseBool(val)
		if err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": fmt.Errorf("ad_service_detail: %w", err).Error()})
			return
		}
		f.AdServiceDetail = &v
	}
	if val, ok := c.GetQuery("unscoped"); ok {
		v, err := strconv.ParseBool(val)
		if err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": fmt.Errorf("unscoped: %w", err).Error()})
			return
		}
		f.Unscoped = &v
	}
	if values, ok := c.GetQueryArray("ad_service_ids"); ok {
		f.AdServiceIDs = make([]int, 0, len(values))
		for _, v := range values {
			id, err := strconv.Atoi(v)
			if err != nil {
				c.JSON(http.StatusBadRequest, gin.H{"error": fmt.Errorf("ad_service_ids: query values: %s: error:  %w", v, err).Error()})
				return
			}
			f.AdServiceIDs = append(f.AdServiceIDs, id)
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

	res, total, err := h.requestAdServiceService.GetHistoryByID(c, f)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"request_ad_services": res, "total": total})
}

// UpdateExecutor
// @Summary	Изменить исполнителя работы RequestAdService
// @Tags		RequestAdService (заявки на объявления услуг)
// @Accept		json
// @Produce	json
// @Param		base	body		controller.UpdateExecutor.request	true	"исполнитель"
// @Success	200		{object}	map[string]interface{}
// @Failure	400		{object}	map[string]interface{}
// @Failure	404		{object}	map[string]interface{}
// @Failure	500		{object}	map[string]interface{}
// @Router		/service/request_ad_service/{id}/executor [patch]
func (h *requestAdService) UpdateExecutor(c *gin.Context) {
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

	err = h.requestAdServiceService.UpdateExecutorID(c, model.RequestAdService{
		ID:         id,
		ExecutorID: &r.ExecutorID,
	})
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"status": "success"})
}
