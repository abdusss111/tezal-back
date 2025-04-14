package controller

import (
	"errors"
	"fmt"
	"net/http"
	"strconv"

	"github.com/gin-gonic/gin"
	"gitlab.com/eqshare/eqshare-back/internal/service"
	"gitlab.com/eqshare/eqshare-back/model"
)

type requestAdServiceClient struct {
	requestAdServiceClientService service.IRequestAdServiceClient
}

func NewRequestAdServiceClient(r *gin.Engine,
	auth service.IAuthentication,
	requestAdServiceClientService service.IRequestAdServiceClient,
) {
	h := requestAdServiceClient{
		requestAdServiceClientService: requestAdServiceClientService,
	}

	ad := r.Group("service/request_ad_service_client")

	ad.GET("", h.Get)
	ad.GET(":id", h.GetByID)
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
// @Summary		Создание RequestAdServiceClient
// @Description	Создание заявки на объявления оборудование клиента.
// @Description	По параметру base нужно передавать все параметры в описании в формате json
// @Description	executor_id тот кто должен выполнить работу
// @Tags			RequestAdServiceClient (заявки на объявления услуг клиента)
// @Accept			json
// @Produce		json
// @Param			base	body		controller.Create.requestAdServiceClientServiceRequest	true	"тело"
// @Success		200		{object}	map[string]interface{}
// @Failure		400		{object}	map[string]interface{}
// @Failure		404		{object}	map[string]interface{}
// @Failure		500		{object}	map[string]interface{}
// @Router			/service/request_ad_service_client [post]
func (h *requestAdServiceClient) Create(c *gin.Context) {
	type requestAdServiceClientServiceRequest struct {
		AdServiceClientID int    `json:"ad_service_client_id"`
		ExecutorID        int    `json:"executor_id"`
		Description       string `json:"description"`
	}

	radec := model.RequestAdServiceClient{}
	r := requestAdServiceClientServiceRequest{}

	user, err := GetUserFromGin(c)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	radec.UserID = user.ID

	if err := c.BindJSON(&r); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	radec.AdServiceClientID = r.AdServiceClientID
	radec.ExecutorID = &r.ExecutorID
	radec.Description = r.Description

	err = h.requestAdServiceClientService.Create(c, radec)
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
// @Summary		Получения списка RequestAdServiceClient
// @Description	Получения списка заявки на объявления оборудование клиента.
// @Tags			RequestAdServiceClient (заявки на объявления услуг клиента)
// @Accept			json
// @Produce		json
// @Param			ad_service_client_document_detail	query		bool	false	"получение фотографии объявления"
// @Param			ad_service_client_detail			query		bool	false	"детальная информация по названию параметра"
// @Param			user_detail							query		bool	false	"детальная информация по названию параметра"
// @Param			executor_detail						query		bool	false	"детальная информация по названию параметра"
// @Param			unscoped							query		bool	false	"получение удаленных и не удаленных записей"
// @Param			id									query		int		false	"можно несколько раз, фильтр по названию параметра"
// @Param			executor_id							query		int		false	"можно несколько раз, фильтр по названию параметра"
// @Param			ad_service_client_ids				query		int		false	"можно несколько раз, фильтр по названию параметра"
// @Param			limit								query		int		false	"лимит"
// @Param			offset								query		int		false	"оффсет"
// @Param			status								query		string	false	"фильтр по статусу"
// @Success		200									{object}	[]model.RequestAdServiceClient
// @Failure		400									{object}	map[string]interface{}
// @Failure		404									{object}	map[string]interface{}
// @Failure		500									{object}	map[string]interface{}
// @Router			/service/request_ad_service_client [get]
func (h *requestAdServiceClient) Get(c *gin.Context) {
	f := model.FilterRequestAdServiceClient{}

	if val, ok := c.GetQuery("ad_service_client_document_detail"); ok {
		v, err := strconv.ParseBool(val)
		if err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": fmt.Errorf("ad_service_client_document_detail: %w", err).Error()})
			return
		}
		f.AdServiceClientDocumentDetail = &v
	}
	if val, ok := c.GetQuery("ad_service_client_detail"); ok {
		v, err := strconv.ParseBool(val)
		if err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": fmt.Errorf("ad_service_client_detail: %w", err).Error()})
			return
		}
		f.AdServiceClientDetail = &v
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
	if val, ok := c.GetQuery("unscoped"); ok {
		v, err := strconv.ParseBool(val)
		if err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": fmt.Errorf("unscoped: %w", err).Error()})
			return
		}
		f.Unscoped = &v
	}

	if values, ok := c.GetQueryArray("executor_id"); ok {
		f.ExecutorIDs = make([]int, 0, len(values))
		for _, v := range values {
			id, err := strconv.Atoi(v)
			if err != nil {
				c.JSON(http.StatusBadRequest,
					gin.H{
						"error": fmt.Errorf("executor_ids: query values: %s: error:  %w", v, err).Error(),
					})
				return
			}
			f.ExecutorIDs = append(f.ExecutorIDs, id)
		}
	}

	if values, ok := c.GetQueryArray("id"); ok {
		f.IDs = make([]int, 0, len(values))
		for _, v := range values {
			id, err := strconv.Atoi(v)
			if err != nil {
				c.JSON(http.StatusBadRequest,
					gin.H{
						"error": fmt.Errorf("ids: query values: %s: error:  %w", v, err).Error(),
					})
				return
			}
			f.IDs = append(f.IDs, id)
		}
	}
	if values, ok := c.GetQueryArray("user_id"); ok {
		f.UserIDs = make([]int, 0, len(values))
		for _, v := range values {
			id, err := strconv.Atoi(v)
			if err != nil {
				c.JSON(http.StatusBadRequest,
					gin.H{
						"error": fmt.Errorf("ids: query values: %s: error:  %w", v, err).Error(),
					})
				return
			}
			f.UserIDs = append(f.UserIDs, id)
		}
	}
	if values, ok := c.GetQueryArray("ad_service_client_ids"); ok {
		f.AdServiceClientIDs = make([]int, 0, len(values))
		for _, v := range values {
			id, err := strconv.Atoi(v)
			if err != nil {
				c.JSON(http.StatusBadRequest,
					gin.H{
						"error": fmt.Errorf("ad_service_client_ids: query values: %s: error:  %w", v, err).Error(),
					})
				return
			}
			f.AdServiceClientIDs = append(f.AdServiceClientIDs, id)
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

	res, total, err := h.requestAdServiceClientService.Get(c, f)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"request_ad_service_clients": res, "total": total})
}

// GetByID
// @Summary		Получение по идентификатору RequestAdServiceClient
// @Description	Получение по идентификатору заявки на объявления оборудование клиента.
// @Tags			RequestAdServiceClient (заявки на объявления услуг клиента)
// @Accept			json
// @Produce		json
// @Param			id	path		int	true	"идентификатор заявки"
// @Success		200	{object}	model.RequestAdServiceClient
// @Failure		400	{object}	map[string]interface{}
// @Failure		404	{object}	map[string]interface{}
// @Failure		500	{object}	map[string]interface{}
// @Router			/service/request_ad_service_client/{id} [get]
func (h *requestAdServiceClient) GetByID(c *gin.Context) {
	id, err := strconv.Atoi(c.Param("id"))
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": fmt.Errorf("id: %w", err).Error()})
		return
	}

	res, err := h.requestAdServiceClientService.GetByID(c, id)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"request_ad_service": res})
}

// ApproveByID
// @Summary		Подтверждение RequestAdServiceClient
// @Description	Подтверждение заявки со стороны клиента.
// @Tags			RequestAdServiceClient (заявки на объявления услуг клиента)
// @Accept			json
// @Produce		json
// @Param			id	path		int	true	"идентификатор заявки"
// @Success		200	{object}	map[string]interface{}
// @Failure		400	{object}	map[string]interface{}
// @Failure		404	{object}	map[string]interface{}
// @Failure		500	{object}	map[string]interface{}
// @Router			/service/request_ad_service_client/{id}/approve [post]
func (h *requestAdServiceClient) ApproveByID(c *gin.Context) {
	id, err := strconv.Atoi(c.Param("id"))
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": fmt.Errorf("id: %w", err).Error()})
		return
	}

	approvedBy, err := GetUserFromGin(c)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	err = h.requestAdServiceClientService.ApproveByID(c, id, approvedBy)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"status": "success"})
}

// CanceledByID
// @Summary		Отклонение RequestAdServiceClient
// @Description	Отклонение заявки со стороны клиента.
// @Tags			RequestAdServiceClient (заявки на объявления услуг клиента)
// @Accept			json
// @Produce		json
// @Param			id	path		int	true	"идентификатор заявки"
// @Success		200	{object}	map[string]interface{}
// @Failure		400	{object}	map[string]interface{}
// @Failure		404	{object}	map[string]interface{}
// @Failure		500	{object}	map[string]interface{}
// @Router			/service/request_ad_service_client/{id}/canceled [post]
func (h *requestAdServiceClient) CanceledByID(c *gin.Context) {
	id, err := strconv.Atoi(c.Param("id"))
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": fmt.Errorf("id: %w", err).Error()})
		return
	}

	err = h.requestAdServiceClientService.CanceledByID(c, id)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"status": "success"})
}

// History
// @Summary		Получения списка истории RequestAdServiceClient
// @Description	Получения списка истории заявки на объявления оборудование клиента.
// @Tags			RequestAdServiceClient (заявки на объявления услуг клиента)
// @Accept			json
// @Produce		json
// @Param			id							path		int		false	"идентификатор"
// @Param			ad_service_client_detail	query		bool	false	"детальная информация по названию параметра"
// @Param			user_detail					query		bool	false	"детальная информация по названию параметра"
// @Param			executor_detail				query		bool	false	"детальная информация по названию параметра"
// @Param			unscoped					query		bool	false	"получение удаленных и не удаленных записей"
// @Param			ad_service_client_ids		query		int		false	"можно несколько раз, фильтр по названию параметра"
// @Param			limit						query		int		false	"лимит"
// @Param			offset						query		int		false	"оффсет"
// @Param			status						query		string	false	"фильтр по статусу"
// @Success		200							{object}	[]model.RequestAdServiceClient
// @Failure		400							{object}	map[string]interface{}
// @Failure		404							{object}	map[string]interface{}
// @Failure		500							{object}	map[string]interface{}
// @Router			/service/request_ad_service_client/{id}/history [get]
func (h *requestAdServiceClient) History(c *gin.Context) {
	f := model.FilterRequestAdServiceClient{}

	id, err := strconv.Atoi(c.Param("id"))
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": fmt.Errorf("id: %w", err).Error()})
		return
	}

	f.IDs = []int{id}

	if val, ok := c.GetQuery("ad_service_client_detail"); ok {
		v, err := strconv.ParseBool(val)
		if err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": fmt.Errorf("ad_service_client_detail: %w", err).Error()})
			return
		}
		f.AdServiceClientDetail = &v
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
	if val, ok := c.GetQuery("unscoped"); ok {
		v, err := strconv.ParseBool(val)
		if err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": fmt.Errorf("unscoped: %w", err).Error()})
			return
		}
		f.Unscoped = &v
	}

	if values, ok := c.GetQueryArray("ad_service_client_ids"); ok {
		f.AdServiceClientIDs = make([]int, 0, len(values))
		for _, v := range values {
			id, err := strconv.Atoi(v)
			if err != nil {
				c.JSON(http.StatusBadRequest,
					gin.H{
						"error": fmt.Errorf("ad_service_client_ids: query values: %s: error:  %w", v, err).Error(),
					})
				return
			}
			f.AdServiceClientIDs = append(f.AdServiceClientIDs, id)
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

	res, total, err := h.requestAdServiceClientService.GetHistoryByID(c, f)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"request_ad_service_clients": res, "total": total})
}

// UpdateExecutor
// @Summary	Изменить исполнителя работы RequestAdServiceClient
// @Tags		RequestAdServiceClient (заявки на объявления услуг клиента)
// @Accept		json
// @Produce	json
// @Param		base	body		controller.UpdateExecutor.request	true	"исполнитель"
// @Success	200		{object}	map[string]interface{}
// @Failure	400		{object}	map[string]interface{}
// @Failure	404		{object}	map[string]interface{}
// @Failure	500		{object}	map[string]interface{}
// @Router		/service/request_ad_service_client/{id}/executor [patch]
func (h *requestAdServiceClient) UpdateExecutor(c *gin.Context) {
	type request struct {
		ExecutorID int `json:"executor_id"`
	}

	id, err := strconv.Atoi(c.Param("id"))
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": fmt.Errorf("id: %w", err).Error()})
		return
	}

	_ = id

	r := request{}

	if err := c.BindJSON(&r); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": fmt.Errorf("id: %w", err).Error()})
		return
	}

	err = h.requestAdServiceClientService.UpdateExecutorID(c, model.RequestAdServiceClient{
		ID:         id,
		ExecutorID: &r.ExecutorID,
	})
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"status": "success"})
}
