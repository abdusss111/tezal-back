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

type requestAdConstructionMaterialClinet struct {
	requestAdConstructionMaterialClient service.IRequestAdConstructionMaterialClient
}

func NewRequestAdConstructionMaterialClient(r *gin.Engine,
	auth service.IAuthentication,
	requestAdConstructionMaterialClient service.IRequestAdConstructionMaterialClient,
) {
	h := requestAdConstructionMaterialClinet{
		requestAdConstructionMaterialClient: requestAdConstructionMaterialClient,
	}

	ad := r.Group("construction_material/request_ad_construction_material_client")

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
// @Summary		Создание RequestAdConstructionMaterialClient
// @Description	Создание заявки на объявления оборудование клиента.
// @Description	По параметру base нужно передавать все параметры в описании в формате json
// @Description	executor_id тот кто должен выполнить работу
// @Tags			RequestAdConstructionMaterialClient (заявки на объявления строй материала клиента)
// @Accept			json
// @Produce		json
// @Param			base	body		controller.Create.requestAdConstructionMaterialClientRequest	true	"тело"
// @Success		200		{object}	map[string]interface{}
// @Failure		400		{object}	map[string]interface{}
// @Failure		404		{object}	map[string]interface{}
// @Failure		500		{object}	map[string]interface{}
// @Router			/construction_material/request_ad_construction_material_client [post]
func (h *requestAdConstructionMaterialClinet) Create(c *gin.Context) {
	type requestAdConstructionMaterialClientRequest struct {
		AdConstructionMaterialClientID int    `json:"ad_construction_material_client_id"`
		ExecutorID                     int    `json:"executor_id"`
		Description                    string `json:"description"`
	}

	radec := model.RequestAdConstructionMaterialClient{}
	r := requestAdConstructionMaterialClientRequest{}

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

	radec.AdConstructionMaterialClientID = r.AdConstructionMaterialClientID
	radec.ExecutorID = &r.ExecutorID
	radec.Description = r.Description

	err = h.requestAdConstructionMaterialClient.Create(c, radec)
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
// @Summary		Получения списка RequestAdConstructionMaterialClient
// @Description	Получения списка заявки на объявления оборудование клиента.
// @Tags			RequestAdConstructionMaterialClient (заявки на объявления строй материала клиента)
// @Accept			json
// @Produce		json
// @Param			ad_construction_material_client_document_detail	query		bool	false	"получение фотографии объявления"
// @Param			ad_construction_material_client_detail			query		bool	false	"детальная информация по названию параметра"
// @Param			user_detail							query		bool	false	"детальная информация по названию параметра"
// @Param			executor_detail						query		bool	false	"детальная информация по названию параметра"
// @Param			unscoped							query		bool	false	"получение удаленных и не удаленных записей"
// @Param			id									query		int		false	"можно несколько раз, фильтр по названию параметра"
// @Param			ad_construction_material_client_ids				query		int		false	"можно несколько раз, фильтр по названию параметра"
// @Param			executor_id							query		int		false	"можно несколько раз, фильтр по названию параметра"
// @Param			limit								query		int		false	"лимит"
// @Param			offset								query		int		false	"оффсет"
// @Param			status								query		string	false	"фильтр по статусу"
// @Success		200									{object}	[]model.RequestAdConstructionMaterialClient
// @Failure		400									{object}	map[string]interface{}
// @Failure		404									{object}	map[string]interface{}
// @Failure		500									{object}	map[string]interface{}
// @Router			/construction_material/request_ad_construction_material_client [get]
func (h *requestAdConstructionMaterialClinet) Get(c *gin.Context) {
	f := model.FilterRequestAdConstructionMaterialClient{}

	if val, ok := c.GetQuery("ad_construction_material_client_document_detail"); ok {
		v, err := strconv.ParseBool(val)
		if err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": fmt.Errorf("ad_construction_material_client_document_detail: %w", err).Error()})
			return
		}
		f.AdConstructionMaterialClientDocumentDetail = &v
	}
	if val, ok := c.GetQuery("ad_construction_material_client_detail"); ok {
		v, err := strconv.ParseBool(val)
		if err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": fmt.Errorf("ad_construction_material_client_detail: %w", err).Error()})
			return
		}
		f.AdConstructionMaterialClientDetail = &v
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
	if values, ok := c.GetQueryArray("ad_construction_material_client_ids"); ok {
		f.AdConstructionMaterialClientIDs = make([]int, 0, len(values))
		for _, v := range values {
			id, err := strconv.Atoi(v)
			if err != nil {
				c.JSON(http.StatusBadRequest,
					gin.H{
						"error": fmt.Errorf("ad_construction_material_client_ids: query values: %s: error:  %w", v, err).Error(),
					})
				return
			}
			f.AdConstructionMaterialClientIDs = append(f.AdConstructionMaterialClientIDs, id)
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

	res, total, err := h.requestAdConstructionMaterialClient.Get(c, f)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"request_ad_construction_material_clients": res, "total": total})
}

// GetByID
// @Summary		Получение по идентификатору RequestAdConstructionMaterialClient
// @Description	Получение по идентификатору заявки на объявления оборудование клиента.
// @Tags			RequestAdConstructionMaterialClient (заявки на объявления строй материала клиента)
// @Accept			json
// @Produce		json
// @Param			id	path		int	true	"идентификатор заявки"
// @Success		200	{object}	model.RequestAdConstructionMaterialClient
// @Failure		400	{object}	map[string]interface{}
// @Failure		404	{object}	map[string]interface{}
// @Failure		500	{object}	map[string]interface{}
// @Router			/construction_material/request_ad_construction_material_client/{id} [get]
func (h *requestAdConstructionMaterialClinet) GetByID(c *gin.Context) {
	id, err := strconv.Atoi(c.Param("id"))
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": fmt.Errorf("id: %w", err).Error()})
		return
	}

	res, err := h.requestAdConstructionMaterialClient.GetByID(c, id)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"request_ad_construction_material": res})
}

// ApproveByID
// @Summary		Подтверждение RequestAdConstructionMaterialClient
// @Description	Подтверждение заявки со стороны клиента.
// @Tags			RequestAdConstructionMaterialClient (заявки на объявления строй материала клиента)
// @Accept			json
// @Produce		json
// @Param			id	path		int	true	"идентификатор заявки"
// @Success		200	{object}	map[string]interface{}
// @Failure		400	{object}	map[string]interface{}
// @Failure		404	{object}	map[string]interface{}
// @Failure		500	{object}	map[string]interface{}
// @Router			/construction_material/request_ad_construction_material_client/{id}/approve [post]
func (h *requestAdConstructionMaterialClinet) ApproveByID(c *gin.Context) {
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

	err = h.requestAdConstructionMaterialClient.ApproveByID(c, id, approvedBy)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"status": "success"})
}

// CanceledByID
// @Summary		Отклонение RequestAdConstructionMaterialClient
// @Description	Отклонение заявки со стороны клиента.
// @Tags			RequestAdConstructionMaterialClient (заявки на объявления строй материала клиента)
// @Accept			json
// @Produce		json
// @Param			id	path		int	true	"идентификатор заявки"
// @Success		200	{object}	map[string]interface{}
// @Failure		400	{object}	map[string]interface{}
// @Failure		404	{object}	map[string]interface{}
// @Failure		500	{object}	map[string]interface{}
// @Router			/construction_material/request_ad_construction_material_client/{id}/canceled [post]
func (h *requestAdConstructionMaterialClinet) CanceledByID(c *gin.Context) {
	id, err := strconv.Atoi(c.Param("id"))
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": fmt.Errorf("id: %w", err).Error()})
		return
	}

	err = h.requestAdConstructionMaterialClient.CanceledByID(c, id)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"status": "success"})
}

// History
// @Summary		Получения списка истории RequestAdConstructionMaterialClient
// @Description	Получения списка истории заявки на объявления оборудование клиента.
// @Tags			RequestAdConstructionMaterialClient (заявки на объявления строй материала клиента)
// @Accept			json
// @Produce		json
// @Param			id							path		int		false	"идентификатор"
// @Param			ad_construction_material_client_detail	query		bool	false	"детальная информация по названию параметра"
// @Param			user_detail					query		bool	false	"детальная информация по названию параметра"
// @Param			executor_detail				query		bool	false	"детальная информация по названию параметра"
// @Param			unscoped					query		bool	false	"получение удаленных и не удаленных записей"
// @Param			ad_construction_material_client_ids		query		int		false	"можно несколько раз, фильтр по названию параметра"
// @Param			limit						query		int		false	"лимит"
// @Param			offset						query		int		false	"оффсет"
// @Param			status						query		string	false	"фильтр по статусу"
// @Success		200							{object}	[]model.RequestAdConstructionMaterialClient
// @Failure		400							{object}	map[string]interface{}
// @Failure		404							{object}	map[string]interface{}
// @Failure		500							{object}	map[string]interface{}
// @Router			/construction_material/request_ad_construction_material_client/{id}/history [get]
func (h *requestAdConstructionMaterialClinet) History(c *gin.Context) {
	f := model.FilterRequestAdConstructionMaterialClient{}

	id, err := strconv.Atoi(c.Param("id"))
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": fmt.Errorf("id: %w", err).Error()})
		return
	}

	f.IDs = []int{id}

	if val, ok := c.GetQuery("ad_construction_material_client_detail"); ok {
		v, err := strconv.ParseBool(val)
		if err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": fmt.Errorf("ad_construction_material_client_detail: %w", err).Error()})
			return
		}
		f.AdConstructionMaterialClientDetail = &v
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

	if values, ok := c.GetQueryArray("ad_construction_material_client_ids"); ok {
		f.AdConstructionMaterialClientIDs = make([]int, 0, len(values))
		for _, v := range values {
			id, err := strconv.Atoi(v)
			if err != nil {
				c.JSON(http.StatusBadRequest,
					gin.H{
						"error": fmt.Errorf("ad_construction_material_client_ids: query values: %s: error:  %w", v, err).Error(),
					})
				return
			}
			f.AdConstructionMaterialClientIDs = append(f.AdConstructionMaterialClientIDs, id)
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

	res, total, err := h.requestAdConstructionMaterialClient.GetHistoryByID(c, f)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"request_ad_construction_material_clients": res, "total": total})
}

// UpdateExecutor
// @Summary	Изменить исполнителя работы RequestAdConstructionMaterialClient
// @Tags		RequestAdConstructionMaterialClient (заявки на объявления строй материала клиента)
// @Accept		json
// @Produce	json
// @Param		base	body		controller.UpdateExecutor.request	true	"исполнитель"
// @Success	200		{object}	map[string]interface{}
// @Failure	400		{object}	map[string]interface{}
// @Failure	404		{object}	map[string]interface{}
// @Failure	500		{object}	map[string]interface{}
// @Router		/construction_material/request_ad_construction_material_client/{id}/executor [patch]
func (h *requestAdConstructionMaterialClinet) UpdateExecutor(c *gin.Context) {
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

	err = h.requestAdConstructionMaterialClient.UpdateExecutorID(c, model.RequestAdConstructionMaterialClient{
		ID:         id,
		ExecutorID: &r.ExecutorID,
	})
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"status": "success"})
}
