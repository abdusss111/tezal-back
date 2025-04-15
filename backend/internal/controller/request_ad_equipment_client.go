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

type requestAdEquipmentClinet struct {
	requestAdEquipmentClient service.IRequestAdEquipmentClient
}

func NewRequestAdEquipmentClient(r *gin.Engine,
	auth service.IAuthentication,
	requestAdEquipmentClient service.IRequestAdEquipmentClient,
) {
	h := requestAdEquipmentClinet{
		requestAdEquipmentClient: requestAdEquipmentClient,
	}

	ad := r.Group("equipment/request_ad_equipment_client")

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

// @Summary		Создание RequestAdEquipmentClient
// @Description	Создание заявки на объявления оборудование клиента.
// @Description	По параметру base нужно передавть все параметры в описании в формате json
// @Description	executor_id тот кто должен выполнить работу
// @Tags			RequestAdEquipmentClient (заявки на объявления оборудование клиента)
// @Accept			json
// @Produce		json
// @Param			base	body		controller.Create.requestAdEquipmentClientRequest	true	"тело"
// @Success		200		{object}	map[string]interface{}
// @Failure		400		{object}	map[string]interface{}
// @Failure		404		{object}	map[string]interface{}
// @Failure		500		{object}	map[string]interface{}
// @Router			/equipment/request_ad_equipment_client [post]
func (h *requestAdEquipmentClinet) Create(c *gin.Context) {
	type requestAdEquipmentClientRequest struct {
		AdEquipmentClientID int    `json:"ad_equipment_client_id"`
		ExecutorID          int    `json:"executor_id"`
		Description         string `json:"description"`
	}

	radec := model.RequestAdEquipmentClient{}
	r := requestAdEquipmentClientRequest{}

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

	radec.AdEquipmentClientID = r.AdEquipmentClientID
	radec.ExecutorID = &r.ExecutorID
	radec.Description = r.Description

	err = h.requestAdEquipmentClient.Create(c, radec)
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
// @Summary		Получения списка RequestAdEquipmentClient
// @Description	Получения списка заявки на объявления оборудование клиента.
// @Tags			RequestAdEquipmentClient (заявки на объявления оборудование клиента)
// @Accept			json
// @Produce		json
// @Param			ad_equipment_client_document_detail	query		bool	false	"получение фотографии обявления"
// @Param			ad_equipment_client_detail			query		bool	false	"детальная информация по названию параметра"
// @Param			user_detail							query		bool	false	"детальная информация по названию параметра"
// @Param			executor_detail						query		bool	false	"детальная информация по названию параметра"
// @Param			unscoped							query		bool	false	"получени удаленных и не удаленных записей"
// @Param			id									query		int		false	"можно несколько раз, фильтр по названию параметра"
// @Param			ad_equipment_client_ids				query		int		false	"можно несколько раз, фильтр по названию параметра"
// @Param			executor_id							query		int		false	"можно несколько раз, фильтр по названию параметра"
// @Param			limit								query		int		false	"лимит"
// @Param			offset								query		int		false	"оффсет"
// @Param			status								query		string	false	"фильтр по статусу"
// @Success		200									{object}	[]model.RequestAdEquipmentClient
// @Failure		400									{object}	map[string]interface{}
// @Failure		404									{object}	map[string]interface{}
// @Failure		500									{object}	map[string]interface{}
// @Router			/equipment/request_ad_equipment_client [get]
func (h *requestAdEquipmentClinet) Get(c *gin.Context) {
	f := model.FilterRequestAdEquipmentClient{}

	if val, ok := c.GetQuery("ad_equipment_client_document_detail"); ok {
		v, err := strconv.ParseBool(val)
		if err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": fmt.Errorf("ad_equipment_client_document_detail: %w", err).Error()})
			return
		}
		f.AdEquipmentClientDocumentDetail = &v
	}
	if val, ok := c.GetQuery("ad_equipment_client_detail"); ok {
		v, err := strconv.ParseBool(val)
		if err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": fmt.Errorf("ad_equipment_client_detail: %w", err).Error()})
			return
		}
		f.AdEquipmentClientDetail = &v
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

	if vals, ok := c.GetQueryArray("executor_id"); ok {
		f.ExecutorIDs = make([]int, 0, len(vals))
		for _, v := range vals {
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

	if val, ok := c.GetQuery("unscoped"); ok {
		v, err := strconv.ParseBool(val)
		if err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": fmt.Errorf("unscoped: %w", err).Error()})
			return
		}
		f.Unscoped = &v
	}
	if vals, ok := c.GetQueryArray("id"); ok {
		f.IDs = make([]int, 0, len(vals))
		for _, v := range vals {
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
	if vals, ok := c.GetQueryArray("user_id"); ok {
		f.UserIDs = make([]int, 0, len(vals))
		for _, v := range vals {
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
	if vals, ok := c.GetQueryArray("ad_equipment_client_ids"); ok {
		f.AdEquipmentClientIDs = make([]int, 0, len(vals))
		for _, v := range vals {
			id, err := strconv.Atoi(v)
			if err != nil {
				c.JSON(http.StatusBadRequest,
					gin.H{
						"error": fmt.Errorf("ad_equipment_client_ids: query values: %s: error:  %w", v, err).Error(),
					})
				return
			}
			f.AdEquipmentClientIDs = append(f.AdEquipmentClientIDs, id)
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

	res, total, err := h.requestAdEquipmentClient.Get(c, f)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"request_ad_equipment_clients": res, "total": total})
}

// GetByID
// @Summary		Получени по идентификатору RequestAdEquipmentClient
// @Description	Получени по идентификатору заявки на объявления оборудование клиента.
// @Tags			RequestAdEquipmentClient (заявки на объявления оборудование клиента)
// @Accept			json
// @Produce		json
// @Param			id	path		int	true	"идентификатор заявки"
// @Success		200	{object}	model.RequestAdEquipmentClient
// @Failure		400	{object}	map[string]interface{}
// @Failure		404	{object}	map[string]interface{}
// @Failure		500	{object}	map[string]interface{}
// @Router			/equipment/request_ad_equipment_client/{id} [get]
func (h *requestAdEquipmentClinet) GetByID(c *gin.Context) {
	id, err := strconv.Atoi(c.Param("id"))
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": fmt.Errorf("id: %w", err).Error()})
		return
	}

	res, err := h.requestAdEquipmentClient.GetByID(c, id)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"request_ad_equipment": res})
}

// @Summary		Потверждение RequestAdEquipmentClient
// @Description	Потверждение заявки со стороны клиента.
// @Tags			RequestAdEquipmentClient (заявки на объявления оборудование клиента)
// @Accept			json
// @Produce		json
// @Param			id	path		int	true	"идентификатор заявки"
// @Success		200	{object}	map[string]interface{}
// @Failure		400	{object}	map[string]interface{}
// @Failure		404	{object}	map[string]interface{}
// @Failure		500	{object}	map[string]interface{}
// @Router			/equipment/request_ad_equipment_client/{id}/approve [post]
func (h *requestAdEquipmentClinet) ApproveByID(c *gin.Context) {
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

	err = h.requestAdEquipmentClient.ApproveByID(c, id, approvedBy)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"status": "success"})
}

// @Summary		Отклонение RequestAdEquipmentClient
// @Description	Отклонение заявки со стороны клиента.
// @Tags			RequestAdEquipmentClient (заявки на объявления оборудование клиента)
// @Accept			json
// @Produce		json
// @Param			id	path		int	true	"идентификатор заявки"
// @Success		200	{object}	map[string]interface{}
// @Failure		400	{object}	map[string]interface{}
// @Failure		404	{object}	map[string]interface{}
// @Failure		500	{object}	map[string]interface{}
// @Router			/equipment/request_ad_equipment_client/{id}/canceled [post]
func (h *requestAdEquipmentClinet) CanceledByID(c *gin.Context) {
	id, err := strconv.Atoi(c.Param("id"))
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": fmt.Errorf("id: %w", err).Error()})
		return
	}

	err = h.requestAdEquipmentClient.CanceledByID(c, id)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"status": "success"})
}

// @Summary		Получения списка истории RequestAdEquipmentClient
// @Description	Получения списка истории заявки на объявления оборудование клиента.
// @Tags			RequestAdEquipmentClient (заявки на объявления оборудование клиента)
// @Accept			json
// @Produce		json
// @Param			id							path		int		false	"идентификатор"
// @Param			ad_equipment_client_detail	query		bool	false	"детальная информация по названию параметра"
// @Param			user_detail					query		bool	false	"детальная информация по названию параметра"
// @Param			executor_detail				query		bool	false	"детальная информация по названию параметра"
// @Param			unscoped					query		bool	false	"получени удаленных и не удаленных записей"
// @Param			ad_equipment_client_ids		query		int		false	"можно несколько раз, фильтр по названию параметра"
// @Param			limit						query		int		false	"лимит"
// @Param			offset						query		int		false	"оффсет"
// @Param			status						query		string	false	"фильтр по статусу"
// @Success		200							{object}	[]model.RequestAdEquipmentClient
// @Failure		400							{object}	map[string]interface{}
// @Failure		404							{object}	map[string]interface{}
// @Failure		500							{object}	map[string]interface{}
// @Router			/equipment/request_ad_equipment_client/{id}/history [get]
func (h *requestAdEquipmentClinet) History(c *gin.Context) {
	f := model.FilterRequestAdEquipmentClient{}

	id, err := strconv.Atoi(c.Param("id"))
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": fmt.Errorf("id: %w", err).Error()})
		return
	}

	f.IDs = []int{id}

	if val, ok := c.GetQuery("ad_equipment_client_detail"); ok {
		v, err := strconv.ParseBool(val)
		if err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": fmt.Errorf("ad_equipment_client_detail: %w", err).Error()})
			return
		}
		f.AdEquipmentClientDetail = &v
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

	if vals, ok := c.GetQueryArray("ad_equipment_client_ids"); ok {
		f.AdEquipmentClientIDs = make([]int, 0, len(vals))
		for _, v := range vals {
			id, err := strconv.Atoi(v)
			if err != nil {
				c.JSON(http.StatusBadRequest,
					gin.H{
						"error": fmt.Errorf("ad_equipment_client_ids: query values: %s: error:  %w", v, err).Error(),
					})
				return
			}
			f.AdEquipmentClientIDs = append(f.AdEquipmentClientIDs, id)
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

	res, total, err := h.requestAdEquipmentClient.GetHistoryByID(c, f)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"request_ad_equipment_clients": res, "total": total})
}

// @Summary	Изменить исполнителя работы RequestAdEquipmentClient
// @Tags		RequestAdEquipmentClient (заявки на объявления оборудование клиента)
// @Accept		json
// @Produce	json
// @Param		base	body		controller.UpdateExecutor.request	true	"исполнитель"
// @Success	200		{object}	map[string]interface{}
// @Failure	400		{object}	map[string]interface{}
// @Failure	404		{object}	map[string]interface{}
// @Failure	500		{object}	map[string]interface{}
// @Router		/equipment/request_ad_equipment_client/{id}/executor [patch]
func (h *requestAdEquipmentClinet) UpdateExecutor(c *gin.Context) {
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

	err = h.requestAdEquipmentClient.UpdateExecutorID(c, model.RequestAdEquipmentClient{
		ID:         id,
		ExecutorID: &r.ExecutorID,
	})
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"status": "success"})
}
