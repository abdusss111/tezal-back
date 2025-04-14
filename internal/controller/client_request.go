package controller

import (
	"net/http"
	"strconv"

	"github.com/gin-gonic/gin"
	"github.com/sirupsen/logrus"
	"gitlab.com/eqshare/eqshare-back/internal/service"
	"gitlab.com/eqshare/eqshare-back/model"
)

type request struct {
	service service.IRequest
}

func NewRequest(r *gin.Engine,
	auth service.IAuthentication, requ service.IRequest) {

	handler := &request{
		service: requ,
	}

	r.GET("/client_request", authorize(auth, model.ROLE_CLIENT, model.ROLE_DRIVER), handler.Get)
	r.GET("/client_request/:id", authorize(auth, model.ROLE_CLIENT, model.ROLE_DRIVER), handler.GetByID)
	r.POST("/client_request", authorize(auth, model.ROLE_DRIVER), handler.Create)
	//r.POST("/client_request/assign_to", authorize(auth, model.ROLE_DRIVER), handler.AssignTo)
	r.POST("/client_request/:id/approve", authorize(auth, model.ROLE_CLIENT), handler.Approve)
	r.POST("/client_request/:id/canceled", authorize(auth, model.ROLE_CLIENT), handler.Canceled)
	r.POST("/client_request/force_approve", authorize(auth, model.ROLE_CLIENT), handler.ForceApprove)
	r.POST("/client_request/:id/assign_to", authorize(auth, model.ROLE_DRIVER, model.ROLE_OWNER), handler.AssignTo)
	r.POST("/client_request/:id/history", authorize(auth, model.ROLE_DRIVER, model.ROLE_OWNER), handler.GetHistoryByID)
}

// Get @Summary		Получение всех заявок на объявлении клиента.
// @Description	Получение всех заявок на объявлении клиента.
// @Description	`В дальнейшем добавится фильтры через query параметры`
// @Description	`Не все параметры возврщаются`
// @Security		ApiKeyAuth
// @Accept			json
// @Produce		json
// @Tags			AdClientRequest
// @Param			Authorization		header		string	true	"приставка `Bearer` с пробелом и сам токен"
// @Param			ad_client			query		int		false	"идентификатор объявления клиента, модно дублировать"
// @Param			ad_client_user_id	query		int		false	"идентификатор автора объявления клиента, дает все запросы связанные с автором объявления"
// @Param			user_id				query		int		false	"идентификатор автора заявки"
// @Param			limit				query		int		false	"количество заявок"
// @Param			offset				query		int		false	"сдвиг"
// @Param			status				query		int		false	"статус заявки"
// @Param			user_detail			query		bool	false	"детали автора заявки"
// @Param			user_assigned		query		bool	false	"детали assigned user"
// @Success		200					{object}	[]model.Request
// @Failure		403					{object}	map[string]interface{}
// @Failure		400,404				{object}	map[string]interface{}
// @Failure		500					{object}	map[string]interface{}
// @Failure		default				{object}	map[string]interface{}
// @Router			/client_request [get]
func (h *request) Get(c *gin.Context) {
	f := model.FilterRequest{}

	if v, ok := c.GetQueryArray("ad_client"); ok {
		f.AdClient = make([]int, 0, len(v))
		for _, v2 := range v {
			n, err := strconv.Atoi(v2)
			if err != nil {
				c.JSON(http.StatusInternalServerError, gin.H{"error query ad_client": err.Error()})
				return
			}
			f.AdClient = append(f.AdClient, n)
		}
	}

	if v, ok := c.GetQuery("ad_client_user_id"); ok {
		n, err := strconv.Atoi(v)
		if err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error query ad_client_user_id": err.Error()})
			return
		}
		f.AdClientUserID = &n
	}

	if v, ok := c.GetQuery("user_detail"); ok {
		n, err := strconv.ParseBool(v)
		if err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error query user_detail": err.Error()})
			return
		}
		f.UserDetail = &n
	}

	if v, ok := c.GetQuery("user_assigned"); ok {
		n, err := strconv.ParseBool(v)
		if err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error query user_assigned": err.Error()})
			return
		}
		f.UserAssigned = &n
	}

	if v, ok := c.GetQuery("user_id"); ok {
		n, err := strconv.Atoi(v)
		if err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error query user_id": err.Error()})
			return
		}
		f.UserID = &n
	}

	if v, ok := c.GetQuery("limit"); ok {
		n, err := strconv.Atoi(v)
		if err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error query limit": err.Error()})
			return
		}
		f.Limit = &n
	}

	if v, ok := c.GetQuery("offset"); ok {
		n, err := strconv.Atoi(v)
		if err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error query offset": err.Error()})
			return
		}
		f.Offset = &n
	}

	if v, ok := c.GetQuery("status"); ok {
		f.Status = &v

	}

	requests, count, err := h.service.Get(f)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"requests": requests, "total": count})
}

func (r *request) GetByID(c *gin.Context) {
	id, err := strconv.Atoi(c.Param("id"))
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error id": err.Error()})
		return
	}

	re, err := r.service.GetByID(id)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"client_request": re})
}

// @Summary		Создание заявоки на объявлении клиента.
// @Description	`ad_client_id`, `comment` должны быть заполнеными и только
// @Security		ApiKeyAuth
// @Accept			json
// @Produce		json
// @Tags			AdClientRequest
// @Param			Authorization	header		string			true	"`водитель` приставка `Bearer` с пробелом и сам токен"
// @Param			ad_client		body		model.Request	true	"тело запроса"
// @Success		200				{object}	map[string]interface{}
// @Failure		403				{object}	map[string]interface{}
// @Failure		400,404			{object}	map[string]interface{}
// @Failure		500				{object}	map[string]interface{}
// @Failure		default			{object}	map[string]interface{}
// @Router			/client_request [post]
func (h *request) Create(c *gin.Context) {
	user, err := GetUserFromGin(c)
	if err != nil {
		c.JSON(http.StatusUnauthorized, gin.H{"error": err.Error()})
		return
	}

	r := model.Request{}

	if err := c.BindJSON(&r); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	r.UserID = user.ID

	logrus.Info(r)
	req, err := h.service.Create(c, r)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"id": req.ID})
}

// @Summary		Подтверждения заявоки на объявлении клиента.
// @Description	`Объявление удаляется!` при успешном выполнении
// @Security		ApiKeyAuth
// @Accept			json
// @Produce		json
// @Tags			AdClientRequest
// @Param			Authorization	header		string	true	"`клиент` приставка `Bearer` с пробелом и сам токен"
// @Param			id				path		int		true	"идентификатор запроса"
// @Success		200				{object}	map[string]interface{}
// @Failure		403				{object}	map[string]interface{}
// @Failure		400,404			{object}	map[string]interface{}
// @Failure		500				{object}	map[string]interface{}
// @Failure		default			{object}	map[string]interface{}
// @Router			/client_request/:id/approve [post]
func (h *request) Approve(c *gin.Context) {
	user, err := GetUserFromGin(c)
	if err != nil {
		c.JSON(http.StatusUnauthorized, gin.H{"error": err.Error()})
		return
	}

	id, err := strconv.Atoi(c.Param("id"))
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	if err := h.service.Approve(c, model.Request{ID: id, UserID: user.ID}); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"status": "success"})
}

// @Summary	Отмена заявоки на объявлении клиента.
// @Security	ApiKeyAuth
// @Accept		json
// @Produce	json
// @Tags		AdClientRequest
// @Param		Authorization	header		string	true	"`клиент` приставка `Bearer` с пробелом и сам токен"
// @Param		id				path		int		true	"идентификатор запроса"
// @Success	200				{object}	map[string]interface{}
// @Failure	403				{object}	map[string]interface{}
// @Failure	400,404			{object}	map[string]interface{}
// @Failure	500				{object}	map[string]interface{}
// @Failure	default			{object}	map[string]interface{}
// @Router		/client_request/:id/canceled [post]
func (h *request) Canceled(c *gin.Context) {
	id, err := strconv.Atoi(c.Param("id"))
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	if err := h.service.Canceled(c, id); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"status": "success"})
}

// @Summary		Быстрое потверждение объявления.
// @Description	user_id идентификатор человека который хочет взять работу
// @Description	Создается заявка с статусом APPROVED, после создается `работа`
// @Description	`Объявление удаляется!`
// @Security		ApiKeyAuth
// @Accept			json
// @Produce		json
// @Tags			AdClientRequest
// @Param			Authorization	header		string				true	"`клиент` приставка `Bearer` с пробелом и сам токен"
// @Param			req				body		model.ForceRequest	true	"тело"
// @Success		200				{object}	map[string]interface{}
// @Failure		403				{object}	map[string]interface{}
// @Failure		400,404			{object}	map[string]interface{}
// @Failure		500				{object}	map[string]interface{}
// @Failure		default			{object}	map[string]interface{}
// @Router			/client_request/force_approve [post]
func (h *request) ForceApprove(c *gin.Context) {
	fr := model.ForceRequest{}

	if err := c.BindJSON(&fr); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	if err := h.service.ForceApprove(c, fr); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"status": "success"})
}

// @Summary		Назначаем водителя чтобы выполнить работу.
// @Description	Обновляется заявка с статусом APPROVED.
// @Description	У request параметр assign_to будет заполнен тем кто кого передадите.
// @Description	`Объявление обновляется!`
// @Security		ApiKeyAuth
// @Accept			json
// @Produce		json
// @Tags			AdClientRequest
// @Param			Authorization	header		string						true	"`клиент` приставка `Bearer` с пробелом и сам токен"
// @Param			worker			body		controller.AssignTo.request	true	"идентификатор работника"
// @Param			id				path		int							true	"идентификатор запроса"
// @Success		200				{object}	map[string]interface{}
// @Failure		403				{object}	map[string]interface{}
// @Failure		400,404			{object}	map[string]interface{}
// @Failure		500				{object}	map[string]interface{}
// @Failure		default			{object}	map[string]interface{}
// @Router			/client_request/:id/assign_to [post]
func (h *request) AssignTo(c *gin.Context) {
	id, err := strconv.Atoi(c.Param("id"))
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	type request struct {
		WorkerID int `json:"worker_id"`
	}

	r := request{}

	if err = c.BindJSON(&r); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	if err = h.service.AssignTo(c, id, r.WorkerID); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"reason": "success"})
}

// @Summary		Получение истории изменении по идентификатору.
// @Description	Получение истории изменении по идентификатору.
// @Security		ApiKeyAuth
// @Accept			json
// @Produce		json
// @Tags			AdClientRequest
// @Param			Authorization	header		string	true	"`клиент` приставка `Bearer` с пробелом и сам токен"
// @Param			id				path		int		true	"идентификатор запроса"
// @Success		200				{object}	[]model.Request
// @Failure		403				{object}	map[string]interface{}
// @Failure		400,404			{object}	map[string]interface{}
// @Failure		500				{object}	map[string]interface{}
// @Failure		default			{object}	map[string]interface{}
// @Router			/client_request/:id/history [get]
func (h *request) GetHistoryByID(c *gin.Context) {
	id, err := strconv.Atoi(c.Param("id"))
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	res, err := h.service.GetHistoryByID(id)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"client_requests_histories": res})
}
