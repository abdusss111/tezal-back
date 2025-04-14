package controller

import (
	"database/sql"
	"errors"
	"fmt"
	"net/http"
	"strconv"
	"time"

	"github.com/gin-gonic/gin"
	"gitlab.com/eqshare/eqshare-back/internal/service"
	"gitlab.com/eqshare/eqshare-back/model"
	"gitlab.com/eqshare/eqshare-back/pkg/util"
)

type specializedMachineryRequest struct {
	service  service.ISpecializedMachineryRequest
	uService service.IUser
}

func NewSpecializedMachineryRequest(r *gin.Engine, auth service.IAuthentication,
	service service.ISpecializedMachineryRequest,
	uService service.IUser,
	middlware ...gin.HandlerFunc) {
	handler := &specializedMachineryRequest{
		service:  service,
		uService: uService,
	}

	adsm := r.Group("/smr")
	adsm.Use(middlware...)

	adsm.GET("/", authorize(auth, model.ROLE_CLIENT, model.ROLE_DRIVER, model.ROLE_OWNER, model.ROLE_ADMIN), handler.Get)
	adsm.GET("/:id", authorize(auth, model.ROLE_CLIENT, model.ROLE_DRIVER, model.ROLE_OWNER, model.ROLE_ADMIN), handler.GetByID)
	adsm.GET("/:id/history", authorize(auth, model.ROLE_CLIENT, model.ROLE_DRIVER, model.ROLE_OWNER, model.ROLE_ADMIN), handler.GetHistoryByID)
	adsm.POST("/", authorize(auth, model.ROLE_CLIENT), handler.Create)
	adsm.POST(":id/approve", authorize(auth, model.ROLE_DRIVER), handler.Approve)
	adsm.POST(":id/approve/assign_to", authorize(auth, model.ROLE_OWNER), handler.AssignTo)
	adsm.POST(":id/revised", authorize(auth, model.ROLE_CLIENT, model.ROLE_DRIVER), handler.Revised)
	adsm.POST(":id/canceled", authorize(auth, model.ROLE_CLIENT, model.ROLE_DRIVER), handler.Canceled)
	adsm.POST("/force_approve", authorize(auth, model.ROLE_DRIVER), handler.ForceApprove)
}

// @Summary		Получние заявки на объявление.
// @Description	В зависимости какая роль обращается с ендпоинту выдает разные результаты.
// @Description	При обращении клиента дает заявки которые он сделал на объявления.
// @Description	При обращении водителя дает обращения которые сделал сделаны были на его объявления.
// @Security		ApiKeyAuth
// @Description	`В дальнейшем добавится фильтры через query параметры`
// @Description	`Не все параметры возврщаются`
// @Accept			json
// @Produce		json
// @Tags			SpecializedMachineryRequest
// @Param			Authorization						header		string	true	"приставка `Bearer` с пробелом и сам токен"
// @Param			ad_specialized_machinery_user_id	query		int		false	"для получения заявок автора обявления по идентификаттору пользователя"
// @Param			ad_specialized_machinery_id			query		int		false	"заявки по идентификатору, можно повторять"
// @Param			user_id								query		int		false	"идентификатор, пользователя который создал заявку"
// @Param			city_id								query		int		false	"идентификатор города"
// @Param			status								query		string	false	"статус"
// @Param			limit								query		int		false	"количество возвращаемых элементов"
// @Param			offset								query		int		false	"количество здвига"
// @Param			user_detail							query		bool	false	"детали автора заявки"
// @Success		200									{object}	[]model.SpecializedMachineryRequest
// @Failure		403									{object}	map[string]interface{}
// @Failure		400,404								{object}	map[string]interface{}
// @Failure		500									{object}	map[string]interface{}
// @Failure		default								{object}	map[string]interface{}
// @Router			/smr [get]
func (s *specializedMachineryRequest) Get(c *gin.Context) {
	// user, err := GetUserFromGin(c)
	// if err != nil {
	// 	c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
	// 	return
	// }

	// if user.AccessRole == model.ROLE_ADMIN {
	// 	user.ID, _ = strconv.Atoi(c.Query("user_id"))
	// 	user, err = s.uService.GetByID(user.ID)
	// 	if err != nil {
	// 		c.JSON(http.StatusBadRequest, gin.H{"reason": fmt.Sprintf("invalid input error: %s", err.Error())})
	// 		return
	// 	}
	// }

	f := model.FilterSpecializedMachineryRequest{}

	if v, ok := c.GetQuery("user_detail"); ok {
		n, err := strconv.ParseBool(v)
		if err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error query user_detail": err.Error()})
			return
		}
		f.UserDetail = &n
	}

	if v, ok := c.GetQuery("ad_specialized_machinery_user_id"); ok {
		n, err := strconv.Atoi(v)
		if err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error query ad_specialized_machinery_user_id": err.Error()})
			return
		}
		f.AdSpecializedMachineryUserID = &n
	}

	if v, ok := c.GetQuery("ad_specialized_machinery_id"); ok {
		n, err := strconv.Atoi(v)
		if err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error query ad_specialized_machinery_id": err.Error()})
			return
		}
		f.AdSpecializedMachineryUserID = &n
	}

	if v, ok := c.GetQuery("user_id"); ok {
		n, err := strconv.Atoi(v)
		if err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error query user_id": err.Error()})
			return
		}
		f.UserID = &n
	}

	if v, ok := c.GetQuery("city_id"); ok {
		n, err := strconv.Atoi(v)
		if err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error query city_id": err.Error()})
			return
		}
		if model.Kazakstan != n {
			f.CityID = &n
		}
	}

	if v, ok := c.GetQuery("limit"); ok {
		n, err := strconv.Atoi(v)
		if err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error query limit": err.Error()})
			return
		}
		f.Limit = &n
	}

	if v, ok := c.GetQuery("offset"); ok {
		n, err := strconv.Atoi(v)
		if err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error query offset": err.Error()})
			return
		}
		f.Offset = &n
	}

	if v, ok := c.GetQuery("status"); ok {
		f.Status = &v
	}

	res, count, err := s.service.Get(f)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"specialized_machinery_requests": res, "total": count})
}

// @Summary		Получние заявки на объявление по индентификатору.
// @Description	Получние заявки на объявление по индентификатору. Возможно не нужен будет.
// @Security		ApiKeyAuth
// @Accept			json
// @Produce		json
// @Tags			SpecializedMachineryRequest
// @Param			Authorization	header		string	true	"приставка `Bearer` с пробелом и сам токен"
// @Param			id				path		int		true	"идентификатор заявки на объявления"
// @Param			user_id			query		int		true	"ID пользователя, авторизующего в роли администратора для роли водителя/клиента"
// @Success		200				{object}	[]model.SpecializedMachineryRequest
// @Failure		403				{object}	map[string]interface{}
// @Failure		400,404			{object}	map[string]interface{}
// @Failure		500				{object}	map[string]interface{}
// @Failure		default			{object}	map[string]interface{}
// @Router			/smr/:id [get]
func (s *specializedMachineryRequest) GetByID(c *gin.Context) {
	var user model.User

	id, err := strconv.Atoi(c.Param("id"))
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	if user.AccessRole == model.ROLE_ADMIN {
		user.ID, _ = strconv.Atoi(c.Query("user_id"))
		user, err = s.uService.GetByID(user.ID)
		if err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"reason": fmt.Sprintf("invalid input error: %s", err.Error())})
			return
		}
	}

	smr, err := s.service.GetByID(id)
	if err != nil {
		// возможно стоит добавить если по такому идентификатору не сузществует
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"specialized_machinery_request": smr})
}

// @Summary		Создание заявки на объявление по индентификатору.
// @Description	Создание заявки на объявление по индентификатору.
// @Description	Время работы и стоимость работы вычисляются в беке. (Возможно стоит вычисление сделать на фронте)
// @Security		ApiKeyAuth
// @Accept			json
// @Produce		json
// @Tags			SpecializedMachineryRequest
// @Param			Authorization				header		string	true	"клиент, приставка `Bearer` с пробелом и сам токен"
// @Param			ad_specialized_machinery_id	formData	int		true	"идентификатор объявления о спецтехнике"
// @Param			start_lease_at				formData	string	true	"время в формате RFC3339 начало работы"
// @Param			end_lease_at				formData	string	true	"время в формате RFC3339 конец работы"
// @Param			address						formData	int		true	"адрес работы"
// @Param			latitude					formData	float64	true	"широта работы"
// @Param			longitude					formData	float64	true	"долгота работы"
// @Param			description					formData	int		true	"описание работы"
// @Param			foto						formData	file	true	"фотографии, нет валидации, сделай валидацию на минимальное кол фото и макс"
// @Param			user_id						query		int		true	"ID пользователя, авторизующего в роли администратора для роли водителя/клиента"
// @Success		200							{object}	map[string]interface{}
// @Failure		403							{object}	map[string]interface{}
// @Failure		400,404						{object}	map[string]interface{}
// @Failure		500							{object}	map[string]interface{}
// @Failure		default						{object}	map[string]interface{}
// @Router			/smr [post]
func (s *specializedMachineryRequest) Create(c *gin.Context) {
	smr := model.SpecializedMachineryRequest{}

	// мидлвар должен возвращать юзера
	user, err := GetUserFromGin(c)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	if user.AccessRole == model.ROLE_ADMIN {
		user.ID, _ = strconv.Atoi(c.Query("user_id"))
		user, err = s.uService.GetByID(user.ID)
		if err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"reason": fmt.Sprintf("invalid input error: %s", err.Error())})
			return
		}
	}

	smr.UserID = user.ID

	mf, err := c.MultipartForm()
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	if len(mf.Value["ad_specialized_machinery_id"]) != 0 {
		id, err := strconv.Atoi(mf.Value["ad_specialized_machinery_id"][0])
		if err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
			return
		}
		smr.AdSpecializedMachineryID = id
	} else {
		c.JSON(http.StatusBadRequest, gin.H{"error": "ad_specialized_machinery_id: null"})
		return
	}

	if len(mf.Value["start_lease_at"]) != 0 {
		smr.StartLeaseAt, err = time.Parse(time.RFC3339, mf.Value["start_lease_at"][0])
		if err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": fmt.Sprintf("start_lease_at: %v", err.Error())})
			return
		}
	} else {
		c.JSON(http.StatusBadRequest, gin.H{"error": "start_lease_at: null"})
		return
	}

	if len(mf.Value["end_lease_at"]) != 0 {
		t, err := time.Parse(time.RFC3339, mf.Value["end_lease_at"][0])
		if err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": fmt.Sprintf("end_lease_at: %v", err.Error())})
			return
		}
		smr.EndLeaseAt = model.Time{NullTime: sql.NullTime{Time: t, Valid: true}}
	}

	if len(mf.Value["address"]) != 0 {
		smr.Address = mf.Value["address"][0]
	}

	if len(mf.Value["latitude"]) != 0 {
		n, err := strconv.ParseFloat(mf.Value["latitude"][0], 64)
		if err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": fmt.Sprintf("latitude: %v", err.Error())})
			return
		}
		smr.Latitude = &n
	}

	if len(mf.Value["longitude"]) != 0 {
		n, err := strconv.ParseFloat(mf.Value["longitude"][0], 64)
		if err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": fmt.Sprintf("longitude: %v", err.Error())})
			return
		}
		smr.Longitude = &n
	}

	// if len(mf.Value["count_hour"]) != 0 {
	// 	smr.CountHour, err = strconv.Atoi(mf.Value["count_hour"][0])
	// 	if err != nil {
	// 		c.JSON(http.StatusBadRequest, gin.H{"error": fmt.Sprintf("count_hour: %v", err.Error())})
	// 		return
	// 	}
	// } else {
	// 	c.JSON(http.StatusBadRequest, gin.H{"error": "count_hour: null"})
	// 	return
	// }

	// order_amount не нужно получать из фронта
	// if len(mf.Value["order_amount"]) != 0 {
	// 	smr.OrderAmount, err = strconv.ParseFloat(mf.Value["order_amount"][0], 64)
	// 	if err != nil {
	// 		c.JSON(http.StatusBadRequest, gin.H{"error": fmt.Sprintf("count_hour: %v", err.Error())})
	// 		return
	// 	}
	// } else {
	// 	c.JSON(http.StatusBadRequest, gin.H{"error": "order_amount: null"})
	// 	return
	// }

	if len(mf.Value["description"]) != 0 {
		smr.Description = mf.Value["description"][0]
	} else {
		c.JSON(http.StatusBadRequest, gin.H{"error": "description: null"})
		return
	}

	for _, fh := range mf.File["foto"] {
		doc, err := util.ParseDocumentOnMultipart(fh)
		if err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
			return
		}
		doc.UserID = user.ID
		smr.Document = append(smr.Document, doc)
	}

	// if err := c.BindJSON(&smr); err != nil {
	// 	c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
	// 	return
	// }

	id, err := s.service.Create(c, smr)
	if err != nil {
		if errors.Is(err, model.ErrInvalidTimeRange) {
			c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
			return
		}
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	// на всякий случай
	_ = id

	c.JSON(http.StatusOK, gin.H{"status": "success"})
}

// @Summary		Получение истории изменения заявки на объявления.
// @Description	Получение истории изменения заявки на объявления.
// @Security		ApiKeyAuth
// @Accept			json
// @Produce		json
// @Tags			SpecializedMachineryRequest
// @Param			Authorization	header		string	true	"приставка `Bearer` с пробелом и сам токен"
// @Param			id				path		int		true	"идентификатор заявки на объявления"
// @Param			user_id			query		int		true	"ID пользователя, авторизующего в роли администратора для роли водителя/клиента"
// @Success		200				{object}	[]model.SpecializedMachineryRequest
// @Failure		403				{object}	map[string]interface{}
// @Failure		400,404			{object}	map[string]interface{}
// @Failure		500				{object}	map[string]interface{}
// @Failure		default			{object}	map[string]interface{}
// @Router			/smr/:id/history [get]
func (s *specializedMachineryRequest) GetHistoryByID(c *gin.Context) {
	var user model.User

	id, err := strconv.Atoi(c.Param("id"))
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	if user.AccessRole == model.ROLE_ADMIN {
		user.ID, _ = strconv.Atoi(c.Query("user_id"))
		user, err = s.uService.GetByID(user.ID)
		if err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"reason": fmt.Sprintf("invalid input error: %s", err.Error())})
			return
		}
	}

	smrs, err := s.service.GetHistoryByID(id)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"specialized_machinery_request_histories": smrs})
}

// @Summary		Подтверждения заявки на объявления.
// @Description	Подтверждения заявки на объявления делает только водитель.
// @Security		ApiKeyAuth
// @Accept			json
// @Produce		json
// @Tags			SpecializedMachineryRequest
// @Param			Authorization	header		string	true	"водитель, приставка `Bearer` с пробелом и сам токен"
// @Param			id				path		int		true	"идентификатор заявки на объявления"
// @Param			user_id			query		int		true	"ID пользователя, авторизующего в роли администратора для роли водителя/клиента"
// @Success		200				{object}	[]model.SpecializedMachineryRequest
// @Failure		403				{object}	map[string]interface{}
// @Failure		400,404			{object}	map[string]interface{}
// @Failure		500				{object}	map[string]interface{}
// @Failure		default			{object}	map[string]interface{}
// @Router			/smr/:id/approve [post]
func (s *specializedMachineryRequest) Approve(c *gin.Context) {
	var user model.User

	id, err := strconv.Atoi(c.Param("id"))
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	if user.AccessRole == model.ROLE_ADMIN {
		user.ID, _ = strconv.Atoi(c.Query("user_id"))
		user, err = s.uService.GetByID(user.ID)
		if err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"reason": fmt.Sprintf("invalid input error: %s", err.Error())})
			return
		}
	}

	if err := s.service.DriverApproveByID(c, id); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"status": "success"})
}

// @Summary		Отправка на доработку заявки.
// @Description	Отправка на доработку заявки когда водитель не сгласен с работой отправляет измененную версию работы.
// @Description	Клиент должени подвердить или изменить свою очередь заявку. Соглашаться на работу может только водитель.
// @Description	В зависимости от роил логика ендпоинта меняется.
// @Security		ApiKeyAuth
// @Accept			json
// @Produce		json
// @Tags			SpecializedMachineryRequest
// @Param			Authorization	header		string	true	"приставка `Bearer` с пробелом и сам токен"
// @Param			id				path		int		true	"идентификатор заявки на объявления"
// @Success		200				{object}	[]model.SpecializedMachineryRequest
// @Failure		403				{object}	map[string]interface{}
// @Failure		400,404			{object}	map[string]interface{}
// @Failure		500				{object}	map[string]interface{}
// @Failure		default			{object}	map[string]interface{}
// @Router			/smr/:id/revised [post]
func (s *specializedMachineryRequest) Revised(c *gin.Context) {
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

	smr := model.SpecializedMachineryRequest{}

	if err := c.BindJSON(&smr); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	smr.ID = id

	switch user.AccessRole {
	case model.ROLE_CLIENT:
		err = s.service.ClientRevisedByID(smr)
	case model.ROLE_OWNER:
		fallthrough
	case model.ROLE_DRIVER:
		err = s.service.DriverRevisedByID(smr)
	default:
		c.JSON(http.StatusUnauthorized, gin.H{"error": model.ErrInvalidStatus.Error()})
		return
	}

	if err != nil {
		c.JSON(http.StatusUnauthorized, gin.H{"error": model.ErrInvalidStatus.Error()})
		return
	}

	c.JSON(http.StatusInternalServerError, gin.H{"status": "success"})
}

// @Summary		Отмена заявки.
// @Description	Отменить заявку может водитель и клиент.
// @Description	Водитель может отменять когда сама заявка поступает к нему.
// @Description	Клиент может отменить когда водитель отправляет на доработку.
// @Description	В зависимости от роли меняется логика работы.
// @Security		ApiKeyAuth
// @Accept			json
// @Produce		json
// @Tags			SpecializedMachineryRequest
// @Param			Authorization	header		string	true	"приставка `Bearer` с пробелом и сам токен"
// @Param			id				path		int		true	"идентификатор заявки на объявления"
// @Param			user_id			query		int		true	"ID пользователя, авторизующего в роли администратора для роли водителя/клиента"
// @Success		200				{object}	[]model.SpecializedMachineryRequest
// @Failure		403				{object}	map[string]interface{}
// @Failure		400,404			{object}	map[string]interface{}
// @Failure		500				{object}	map[string]interface{}
// @Failure		default			{object}	map[string]interface{}
// @Router			/smr/:id/canceled [post]
func (s *specializedMachineryRequest) Canceled(c *gin.Context) {
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

	switch user.AccessRole {
	case model.ROLE_CLIENT:
		err = s.service.ClientCanceledByID(id, user.ID)
	case model.ROLE_OWNER:
		fallthrough
	case model.ROLE_DRIVER:
		err = s.service.DriverCanceledByID(id, user.ID)
	default:
		c.JSON(http.StatusUnauthorized, gin.H{"error": model.ErrInvalidStatus.Error()})
		return
	}

	if err != nil {
		c.JSON(http.StatusUnauthorized, gin.H{"error": model.ErrInvalidStatus.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"status": "success"})
}

// @Summary		Назначение работы на работника.
// @Description	Создается заявка с статусом APPROVED и работа на вополнение (request_execution).
// @Description	У request_execution параметр assign_to будет заполнен тем кто кого передадите.
// @Security		ApiKeyAuth
// @Accept			json
// @Produce		json
// @Tags			SpecializedMachineryRequest
// @Param			Authorization	header		string						true	"`владелец` приставка `Bearer` с пробелом и сам токен"
// @Param			id				path		int							true	"идентификатор заявки на объявления"
// @Param			worker			body		controller.AssignTo.request	true	"идентификатор работника"
// @Success		200				{object}	map[string]interface{}
// @Failure		403				{object}	map[string]interface{}
// @Failure		400,404			{object}	map[string]interface{}
// @Failure		500				{object}	map[string]interface{}
// @Failure		default			{object}	map[string]interface{}
// @Router			/smr/:id/approve/assign_to [post]
func (s *specializedMachineryRequest) AssignTo(c *gin.Context) {
	id, err := strconv.Atoi(c.Param("id"))
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	type request struct {
		WorkerID int `json:"worker_id"`
	}

	r := request{}

	if err := c.BindJSON(&r); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	if err := s.service.AssignTo(id, r.WorkerID); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"status": "success"})
}

// @Summary		Создание работы на отклик.
// @Description	Использовать водитель и клиент поговорили по телефону и хочет сразу создать работу на выполнеие.
// @Description	Создается заявка с статусом APPROVED.
// @Description	Создается request_execution.
// @Security		ApiKeyAuth
// @Accept			json
// @Produce		json
// @Tags			SpecializedMachineryRequest
// @Param			Authorization				header		string	true	"`владелец` приставка `Bearer` с пробелом и сам токен"
// @Param			ad_specialized_machinery_id	formData	int		true	"идентификатор объявления о спецтехнике"
// @Param			start_lease_at				formData	string	true	"время в формате RFC3339 начало работы"
// @Param			end_lease_at				formData	string	false	"время в формате RFC3339 конец работы"
// @Param			address						formData	int		true	"адрес работы"
// @Param			latitude					formData	float64	true	"широта работы"
// @Param			longitude					formData	float64	true	"долгота работы"
// @Param			description					formData	int		true	"описание работы"
// @Param			foto						formData	file	true	"фотографии, нет валидации, сделай валидацию на минимальное кол фото и макс"
// @Success		200							{object}	map[string]interface{}
// @Failure		403							{object}	map[string]interface{}
// @Failure		400,404						{object}	map[string]interface{}
// @Failure		500							{object}	map[string]interface{}
// @Failure		default						{object}	map[string]interface{}
// @Router			/smr/force_approve [post]
func (s *specializedMachineryRequest) ForceApprove(c *gin.Context) {
	smr := model.SpecializedMachineryRequest{}

	// мидлвар должен возвращать юзера
	user, err := GetUserFromGin(c)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	smr.UserID = user.ID

	mf, err := c.MultipartForm()
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	if len(mf.Value["ad_specialized_machinery_id"]) != 0 {
		id, err := strconv.Atoi(mf.Value["ad_specialized_machinery_id"][0])
		if err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
			return
		}
		smr.AdSpecializedMachineryID = id
	} else {
		c.JSON(http.StatusBadRequest, gin.H{"error": "ad_specialized_machinery_id: null"})
		return
	}

	if len(mf.Value["start_lease_at"]) != 0 {
		smr.StartLeaseAt, err = time.Parse(time.RFC3339, mf.Value["start_lease_at"][0])
		if err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": fmt.Sprintf("start_lease_at: %v", err.Error())})
			return
		}
	} else {
		c.JSON(http.StatusBadRequest, gin.H{"error": "start_lease_at: null"})
		return
	}

	if len(mf.Value["end_lease_at"]) != 0 {
		t, err := time.Parse(time.RFC3339, mf.Value["end_lease_at"][0])
		if err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": fmt.Sprintf("end_lease_at: %v", err.Error())})
			return
		}
		smr.EndLeaseAt = model.Time{NullTime: sql.NullTime{Time: t, Valid: true}}
	} else {
		c.JSON(http.StatusBadRequest, gin.H{"error": "end_lease_at: null"})
		return
	}

	if len(mf.Value["address"]) != 0 {
		smr.Address = mf.Value["address"][0]
	}

	if len(mf.Value["latitude"]) != 0 {
		n, err := strconv.ParseFloat(mf.Value["latitude"][0], 64)
		if err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": fmt.Sprintf("latitude: %v", err.Error())})
			return
		}
		smr.Latitude = &n
	}

	if len(mf.Value["longitude"]) != 0 {
		n, err := strconv.ParseFloat(mf.Value["longitude"][0], 64)
		if err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": fmt.Sprintf("longitude: %v", err.Error())})
			return
		}
		smr.Longitude = &n
	}

	if len(mf.Value["description"]) != 0 {
		smr.Description = mf.Value["description"][0]
	} else {
		c.JSON(http.StatusBadRequest, gin.H{"error": "description: null"})
		return
	}

	for _, fh := range mf.File["foto"] {
		doc, err := util.ParseDocumentOnMultipart(fh)
		if err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
			return
		}
		doc.UserID = user.ID
		smr.Document = append(smr.Document, doc)
	}

	if err := s.service.ForceApprove(smr); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"status": "success"})
}
