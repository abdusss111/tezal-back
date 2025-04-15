package controller

import (
	"context"
	"database/sql"
	"encoding/json"
	"fmt"
	"net/http"
	"strconv"
	"time"

	"github.com/gin-gonic/gin"
	"github.com/gorilla/websocket"
	"github.com/sirupsen/logrus"
	"gitlab.com/eqshare/eqshare-back/internal/service"
	"gitlab.com/eqshare/eqshare-back/model"
	"gitlab.com/eqshare/eqshare-back/pkg/util"
)

type requestExecution struct {
	service       service.IRequestExecution
	serviceDriver service.IDriverMoveService
	authService   service.IAuthentication
}

func NewRequestExecution(r *gin.Engine, auth service.IAuthentication, service service.IRequestExecution, serviceDriver service.IDriverMoveService, middlware ...gin.HandlerFunc) {
	handler := requestExecution{service: service, serviceDriver: serviceDriver}

	re := r.Group("/re")

	re.GET("", authorize(auth, model.ROLE_CLIENT, model.ROLE_DRIVER, model.ROLE_ADMIN), handler.Get)
	re.GET(":id", authorize(auth, model.ROLE_CLIENT, model.ROLE_DRIVER, model.ROLE_ADMIN), handler.GetByID)
	re.GET("/stream_drivers", authorize(auth, model.ROLE_OWNER, model.ROLE_ADMIN), handler.streamDrivers)
	re.POST("/receive_driver", authorize(auth, model.ROLE_DRIVER, model.ROLE_ADMIN), handler.receiveDriverMessages)
	re.GET(":id/stream", authorize(auth, model.ROLE_CLIENT, model.ROLE_DRIVER, model.ROLE_ADMIN), handler.Strem)
	re.POST(":id/reassign", authorize(auth, model.ROLE_OWNER, model.ROLE_ADMIN), handler.Reassign)
	re.POST(":id/on_road", authorize(auth, model.ROLE_DRIVER, model.ROLE_OWNER, model.ROLE_ADMIN), handler.OnRoad)
	re.POST(":id/start", authorize(auth, model.ROLE_CLIENT, model.ROLE_DRIVER, model.ROLE_ADMIN), handler.Start)
	re.POST(":id/pause", authorize(auth, model.ROLE_CLIENT, model.ROLE_DRIVER, model.ROLE_ADMIN), handler.Pause)
	re.POST(":id/finish", authorize(auth, model.ROLE_CLIENT, model.ROLE_DRIVER, model.ROLE_ADMIN), handler.Finish)
	re.PUT(":id/rate", authorize(auth, model.ROLE_CLIENT), handler.RequestRate)
	re.GET(":id/history", authorize(auth, model.ROLE_ADMIN, model.ROLE_DRIVER, model.ROLE_CLIENT, model.ROLE_OWNER),
		handler.GetHistoryByID)
	re.GET(":id/history/traveled_way", authorize(auth, model.ROLE_ADMIN, model.ROLE_DRIVER, model.ROLE_CLIENT, model.ROLE_OWNER),
		handler.HistoryTraveledWay)
	re.PATCH(":id/end_lease_at", authorize(auth, model.ROLE_ADMIN, model.ROLE_DRIVER, model.ROLE_CLIENT, model.ROLE_OWNER),
		handler.UpdateEndLeaseAt)
	re.POST("without_the_client", authorize(auth, model.ROLE_ADMIN, model.ROLE_DRIVER, model.ROLE_CLIENT, model.ROLE_OWNER),
		handler.CreateRequestExecutionAssignmentWithoutClinet)
}

// @Summary		Получние всех работы.
// @Description	Получние всех работы.
// @Description	Для разных ролей показывется разыные работы.
// @Accept			json
// @Produce		json
// @Tags			RequestExecution
// @Param			Authorization	header		string	true	"приставка `Bearer` с пробелом и сам токен"
// @Param			client_id		query		int		false	"работы связанные с идентифкатором клиента"
// @Param			driver_id		query		int		false	"работы связанные с идентифкатором водителя/владельца"
// @Param			assign_to		query		int		false	"работы назначпенные на пользовтеля с идентификатором"
// @Param			src				query		string	false	"источник"	Enums(SM, SM_CLIENT, EQ, EQ_CLIENT)
// @Param			status			query		string	false	"статус"
// @Param			limit			query		int		false	"количество элементов"
// @Param			offset			query		int		false	"свдиг"
// @Param			asc				query		string	false	"можно нескоьлко раз, по убыванию"
// @Param			desc			query		string	false	"можно нескоьлко раз, по возрастанию"
// @Param			min_updated_at	query		string	false	"формат год-месяц-день `2006-01-02`, фильтр по времени обновления, минимальная дата включительно"
// @Param			max_updated_at	query		string	false	"формат год-месяц-день `2006-01-02`, фильтр по времени обновления, максимальная дата включительно"
// @Param			document_detail	query		bool	false	"получение картинок"
// @Success		200				{object}	model.RequestExecution
// @Failure		403				{object}	map[string]interface{}
// @Failure		400,404			{object}	map[string]interface{}
// @Failure		500				{object}	map[string]interface{}
// @Failure		default			{object}	map[string]interface{}
// @Router			/re [get]
func (r *requestExecution) Get(c *gin.Context) {
	// user, err := GetUserFromGin(c)
	// if err != nil {
	// 	c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
	// 	return
	// }

	// f := model.FilterRequestExecution{}
	// switch user.AccessRole {
	// case model.ROLE_CLIENT:
	// 	f.ClientID = user.ID
	// case model.ROLE_OWNER:
	// 	fallthrough
	// case model.ROLE_DRIVER:
	// 	f.DriverID = user.ID
	// }

	f := model.FilterRequestExecution{}

	if v, ok := c.GetQuery("document_detail"); ok {
		n, err := strconv.ParseBool(v)
		if err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error query document_detail": err.Error()})
			return
		}
		f.DocumentDetail = &n
	}

	if v, ok := c.GetQuery("client_id"); ok {
		n, err := strconv.Atoi(v)
		if err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error query client_id": err.Error()})
			return
		}
		f.ClientID = &n
	}

	if v, ok := c.GetQuery("driver_id"); ok {
		n, err := strconv.Atoi(v)
		if err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error query driver_id": err.Error()})
			return
		}
		f.DriverID = &n
	}

	if v, ok := c.GetQuery("assign_to"); ok {
		n, err := strconv.Atoi(v)
		if err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error query assign_to": err.Error()})
			return
		}
		f.AssignTo = &n
	}

	if v, ok := c.GetQueryArray("status"); ok {
		f.Status = v
	}

	if v, ok := c.GetQueryArray("src"); ok {
		f.Src = v
	}
	var pageSize = model.DefaultPageSize
	f.Limit = &pageSize
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

	if v, ok := c.GetQuery("min_updated_at"); ok {
		t, err := time.Parse(time.DateOnly, v)
		if err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"parameter": "min_updated_at", "error": err.Error()})
			return
		}
		f.MinUpdatedAt = model.Time{NullTime: sql.NullTime{Time: t, Valid: true}}
	}

	if v, ok := c.GetQuery("max_updated_at"); ok {
		t, err := time.Parse(time.DateOnly, v)
		if err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"parameter": "max_updated_at", "error": err.Error()})
			return
		}
		f.MaxUpdatedAt = model.Time{NullTime: sql.NullTime{Time: t, Valid: true}}
	}

	if v, ok := c.GetQueryArray("asc"); ok {
		f.ASC = v
	}

	if v, ok := c.GetQueryArray("desc"); ok {
		f.DESC = v
	}

	res, count, err := r.service.GetDTO(f)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"request_execution": res, "total": count})
}

// @Summary	Получние работы по идентификатору
// @Accept		json
// @Produce	json
// @Tags		RequestExecution
// @Param		Authorization	header		string	true	"приставка `Bearer` с пробелом и сам токен"
// @Param		id				path		int		true	"идентификатор работы"
// @Success	200				{object}	model.Coordinates
// @Failure	403				{object}	map[string]interface{}
// @Failure	400,404			{object}	map[string]interface{}
// @Failure	500				{object}	map[string]interface{}
// @Failure	default			{object}	map[string]interface{}
// @Router		/re/:id [get]
func (r *requestExecution) GetByID(c *gin.Context) {
	id, err := strconv.Atoi(c.Param("id"))
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	res, err := r.service.GetByID(id)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"request_execution": res})
}

// @Summary		Отслеживание водителей бизнеса.
// @Description Получаем последнее местоположение водителей бизнеса.
// @Accept		json
// @Produce	json
// @Tags		DriverTracking
// @Param		Authorization	header		string	true	"приставка `Bearer` с пробелом и сам токен"
// @Success	200				{array} model.DriverMove
// @Failure	403				{object}	map[string]interface{}
// @Failure	400,404			{object}	map[string]interface{}
// @Failure	500				{object}	map[string]interface{}
// @Failure	default			{object}	map[string]interface{}
// @Router		/re/stream_drivers [get]
func (r *requestExecution) streamDrivers(c *gin.Context) {
	user, err := GetUserFromGin(c)
	if err != nil || user.AccessRole != model.ROLE_OWNER {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "доступ запрещен"})
		return
	}

	logrus.Info("User ID:", user.ID)

	drivers, err := r.serviceDriver.GetDriversByOwnerID(c, user.ID)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	var driversData []model.DriverMove

	for _, driver := range drivers {
		lastCoord, err := r.serviceDriver.DriverGetStreamCoordinatesByID(c, driver.ID)
		if err != nil {
			logrus.Error("Ошибка получения последних координат водителя:", err)
			continue
		}

		driverData := model.DriverMove{
			DriverId: driver.ID,
			Name:     driver.FirstName,
			LastName: driver.LastName,
		}

		driverData.Longitude = lastCoord.Longitude
		driverData.Latitude = lastCoord.Latitude
		driverData.CreatedAt = lastCoord.CreatedAt
		driverData.Message = lastCoord.Message
		driverData.IsLocationEnabled = lastCoord.IsLocationEnabled
		driversData = append(driversData, driverData)
	}

	c.JSON(http.StatusOK, driversData)
}

// @Summary      Получение координат водителя
// @Description  Устанавливает WebSocket соединение для получения и передачи координат водителя.
//
//	Принимает входящие сообщения с координатами, сохраняет их в базе данных и отправляет подтверждение.
//
// @Accept       json
// @Produce      json
// @Tags         DriverTracking
// @Param        Authorization  header     string  true   "Bearer токен для авторизации"
// @Success      200            {object}   model.DriverMove  "Данные о координатах водителя"
// @Failure      400            {object}   map[string]interface{}  "Некорректный запрос (например, неверный id)"
// @Failure      403            {object}   map[string]interface{}  "Доступ запрещён (недостаточно прав)"
// @Failure      404            {object}   map[string]interface{}  "Ресурс не найден"
// @Failure      500            {object}   map[string]interface{}  "Внутренняя ошибка сервера"
// @Failure      default        {object}   map[string]interface{}  "Неизвестная ошибка"
// @Router       /re/receive_driver [post]
func (a *requestExecution) receiveDriverMessages(c *gin.Context) {
	user, err := GetUserFromGin(c)
	if err != nil {
		c.JSON(http.StatusUnauthorized, gin.H{"error": err.Error()})
	}

	logrus.Info(user.ID)

	isEnabled, err := a.serviceDriver.IsLocationSharingEnabled(user.ID)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to check location sharing status"})
		return
	}

	if !isEnabled {
		c.JSON(http.StatusForbidden, gin.H{"error": "Location sharing is disabled"})
		return
	}

	cord := model.DriverMove{}

	if err := c.ShouldBindJSON(&cord); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid JSON"})
		return
	}

	cord.DriverId = user.ID

	if err := a.serviceDriver.CreateDriverCoordinates(c, cord); err != nil {
		//err = conn.WriteMessage(websocket.TextMessage, []byte(fmt.Sprintf("error: %v", err.Error())))
		if err != nil {
			logrus.Error(err)
			return
		}
	}
}

// @Summary		Открывает WebSocket соединения для передачи кординат.
// @Description	При обращении от роли драйвера вы должны передавать каждые 2 секунды кординаты
// @Description	При обращении от роли клиента вы получаете кординаты машины.
// @Accept			json
// @Produce		json
// @Tags			RequestExecution
// @Param			Authorization	header		string	true	"приставка `Bearer` с пробелом и сам токен"
// @Param			user_id			query		int		true	"ID пользователя, авторизующего в роли администратора для роли водителя/клиента"
// @Param			is_driver		query		bool	false	"со стороны владельца спецтехники параметр обязательный, при значении true сторона бека начинает принимать кординаты для стриминга, при значении false начинает высылать кординаты как для клиента"
// @Param			id				path		int		true	"идентификатор работы"
// @Success		200				{object}	model.Coordinates
// @Failure		403				{object}	map[string]interface{}
// @Failure		400,404			{object}	map[string]interface{}
// @Failure		500				{object}	map[string]interface{}
// @Failure		default			{object}	map[string]interface{}
// @Router			/re/:id/stream [get]
func (r *requestExecution) Strem(c *gin.Context) {
	user, err := GetUserFromGin(c)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	switch user.AccessRole {
	case model.ROLE_OWNER:
		v, ok := c.GetQuery("is_driver")
		if !ok {
			c.JSON(http.StatusBadRequest, gin.H{"error": "dont have is_driver"})
			return
		}
		val, err := strconv.ParseBool(v) // заполняется только когда владелец выходит на свою работу
		if err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
			return
		}
		if val {
			r.stremDriver(c)
		} else {
			r.streamClinet(c)
		}
	case model.ROLE_CLIENT:
		r.streamClinet(c)
	case model.ROLE_DRIVER:
		r.stremDriver(c)
	default:
		c.JSON(http.StatusUnauthorized, gin.H{"error": model.ErrInvalidStatus.Error()})
		return
	}
}

func (r *requestExecution) streamClinet(c *gin.Context) {
	var upgrader = websocket.Upgrader{
		ReadBufferSize:  1024,
		WriteBufferSize: 1024,
	}

	conn, err := upgrader.Upgrade(c.Writer, c.Request, nil)
	if err != nil {
		logrus.Error(err)
		return
	}
	defer conn.Close()

	id, err := strconv.Atoi(c.Param("id"))
	if err != nil {
		conn.WriteMessage(websocket.TextMessage, []byte("bad request id"))
		return
	}

	ctx, cancel := context.WithCancel(context.Background())
	defer cancel()

	ch, err := r.service.ClientGetStremCoordinatesByID(ctx, id)
	if err != nil {
		conn.WriteJSON(gin.H{"status": err.Error()})
		return
	}

	go func() {
		_, _, err := conn.ReadMessage()
		if websocket.IsCloseError(err,
			websocket.CloseNormalClosure,
			websocket.CloseGoingAway,
			websocket.CloseProtocolError,
			websocket.CloseUnsupportedData,
			websocket.CloseNoStatusReceived,
			websocket.CloseAbnormalClosure,
			websocket.CloseInvalidFramePayloadData,
			websocket.ClosePolicyViolation,
			websocket.CloseMessageTooBig,
			websocket.CloseMandatoryExtension,
			websocket.CloseInternalServerErr,
			websocket.CloseServiceRestart,
			websocket.CloseTryAgainLater,
			websocket.CloseTLSHandshake,
		) {
			conn.Close()
			logrus.Info("close conn")
			return
		}
	}()
	//aldick
	for {
		coor, ok := <-ch
		if !ok {
			conn.WriteJSON(gin.H{"status": ""})
			return
		}

		err := conn.WriteJSON(coor)
		if err != nil {
			conn.WriteJSON(gin.H{"err": err.Error()})
			return
		}

		time.Sleep(time.Second * 5)
	}
}

func (r *requestExecution) stremDriver(c *gin.Context) {
	var upgrader = websocket.Upgrader{
		ReadBufferSize:  1024,
		WriteBufferSize: 1024,
	}

	conn, err := upgrader.Upgrade(c.Writer, c.Request, nil)
	if err != nil {
		logrus.Error(err)
		return
	}
	defer conn.Close()

	id, err := strconv.Atoi(c.Param("id"))
	if err != nil {
		conn.WriteMessage(websocket.TextMessage, []byte("bad request id"))
		return
	}

	// if err := r.service.DriverSetOnRoad(id); err != nil {
	// 	if err := conn.WriteJSON(gin.H{"error": err.Error()}); err != nil {
	// 		logrus.Error(err)
	// 	}
	// 	return
	// }

	for {
		messageType, message, err := conn.ReadMessage()
		if err != nil || messageType < 0 {
			err = conn.WriteMessage(websocket.TextMessage, []byte(fmt.Sprintf("error: %v", err.Error())))
			if err != nil {
				logrus.Error(err)
				return
			}
		}

		cord := model.RequestExecutionMove{}

		if err := json.Unmarshal(message, &cord); err != nil {
			return
		}
		cord.RequestExectionID = id

		if err := r.service.DriverStremCoordinatesByID(c, cord); err != nil {
			err = conn.WriteMessage(websocket.TextMessage, []byte(fmt.Sprintf("error: %v", err.Error())))
			if err != nil {
				logrus.Error(err)
				return
			}
		}

		// if err := conn.WriteJSON(gin.H{"status": "success"}); err != nil {
		// 	err = conn.WriteMessage(websocket.TextMessage, []byte(fmt.Sprintf("error: %v", err.Error())))
		// 	if err != nil {
		// 		logrus.Error(err)
		// 		return
		// 	}
		// 	return
		// }
	}
}

// @Summary		Смена статуса работы на `WORKING`
// @Description	Для смены статуса начало работы должны подвтвердить обе стороны.
// @Description	Когда две оли обратяться произайдет смена стаутса и фиксация времени начало работы.
// @Accept			json
// @Produce		json
// @Tags			RequestExecution
// @Param			Authorization	header		string	true	"приставка `Bearer` с пробелом и сам токен"
// @Param			id				path		int		true	"идентификатор работы"
// @Success		200				{object}	model.Coordinates
// @Failure		403				{object}	map[string]interface{}
// @Failure		400,404			{object}	map[string]interface{}
// @Failure		500				{object}	map[string]interface{}
// @Failure		default			{object}	map[string]interface{}
// @Router			/re/:id/stream [post]
func (r *requestExecution) Start(c *gin.Context) {
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
		err = r.service.ClientConfirmStartWork(c, id)
	case model.ROLE_OWNER:
		fallthrough
	case model.ROLE_DRIVER:
		err = r.service.DriverConfirmStartWork(c, id)
	default:
		c.JSON(http.StatusUnauthorized, gin.H{"error": model.ErrInvalidStatus.Error()})
		return
	}

	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"status": "success"})
}

// @Summary		Смена статуса работы на `FINISHED`
// @Description	Для смены статуса начало работы должны подвтвердить обе стороны.
// @Description	Когда две оли обратяться произайдет смена стаутса и фиксация времени начало работы.
// @Accept			json
// @Produce		json
// @Tags			RequestExecution
// @Param			Authorization	header		string						true	"приставка `Bearer` с пробелом и сам токен"
// @Param			id				path		int							true	"идентификатор работы"
// @Param			request			body		controller.Finish.request	true	"сумма сколько заплатили"
// @Success		200				{object}	model.Coordinates
// @Failure		403				{object}	map[string]interface{}
// @Failure		400,404			{object}	map[string]interface{}
// @Failure		500				{object}	map[string]interface{}
// @Failure		default			{object}	map[string]interface{}
// @Router			/re/:id/finish [post]
func (r *requestExecution) Finish(c *gin.Context) {
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

	type request struct {
		PaymentAmount int `json:"payment_amount"`
	}

	req := request{}

	if err := c.BindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	switch user.AccessRole {
	case model.ROLE_CLIENT:
		err = r.service.ClientFinishWork(c, id, req.PaymentAmount)
	case model.ROLE_OWNER:
		fallthrough
	case model.ROLE_DRIVER:
		err = r.service.DriverFinishWork(c, id, req.PaymentAmount)
	default:
		c.JSON(http.StatusUnauthorized, gin.H{"error": model.ErrInvalidStatus.Error()})
		return
	}

	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"status": "success"})
}

// @Summary		Смена статуса работы на `PAUSE`
// @Description	Для смены статуса начало работы должны подвтвердить обе стороны.
// @Description	Когда две оли обратяться произайдет смена стаутса и фиксация времени начало работы.
// @Accept			json
// @Produce		json
// @Tags			RequestExecution
// @Param			Authorization	header		string	true	"приставка `Bearer` с пробелом и сам токен"
// @Param			id				path		int		true	"идентификатор работы"
// @Success		200				{object}	model.Coordinates
// @Failure		403				{object}	map[string]interface{}
// @Failure		400,404			{object}	map[string]interface{}
// @Failure		500				{object}	map[string]interface{}
// @Failure		default			{object}	map[string]interface{}
// @Router			/re/:id/pause [post]
func (r *requestExecution) Pause(c *gin.Context) {
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
		err = r.service.ClientPauseWork(c, id)
	case model.ROLE_OWNER:
		fallthrough
	case model.ROLE_DRIVER:
		err = r.service.DriverPauseWork(c, id)
	default:
		c.JSON(http.StatusUnauthorized, gin.H{"error": model.ErrInvalidStatus.Error()})
		return
	}

	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"status": "success"})
}

// OnRoad
// @Summary		Смена статуса работы на `ON_ROAD`
// @Description	Смена статуса работы на `ON_ROAD`
// @Accept			json
// @Produce		json
// @Tags			RequestExecution
// @Param			Authorization	header		string	true	"приставка `Bearer` с пробелом и сам токен"
// @Param			id				path		int		true	"идентификатор работы"
// @Success		200				string	 string
// @Failure		403				{object}	map[string]interface{}
// @Failure		400,404			{object}	map[string]interface{}
// @Failure		500				{object}	map[string]interface{}
// @Failure		default			{object}	map[string]interface{}
// @Router			/re/:id/on_road [post]
func (r *requestExecution) OnRoad(c *gin.Context) {
	id, err := strconv.Atoi(c.Param("id"))
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	if err := r.service.DriverSetOnRoad(c, id); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"status": "success"})
}

// @Summary		Перенозначение работы работникам.
// @Description	Перенозначение работы работникам.
// @Accept			json
// @Produce		json
// @Tags			RequestExecution
// @Param			Authorization	header		string						true	"`админ, владелец` приставка `Bearer` с пробелом и сам токен"
// @Param			id				path		int							true	"идентификатор работы"
// @Param			worker			body		controller.Reassign.request	true	"идентификатор работника"
// @Success		200				{object}	model.Coordinates
// @Failure		403				{object}	map[string]interface{}
// @Failure		400,404			{object}	map[string]interface{}
// @Failure		500				{object}	map[string]interface{}
// @Failure		default			{object}	map[string]interface{}
// @Router			/re/:id/reassign [post]
func (r *requestExecution) Reassign(c *gin.Context) {
	id, err := strconv.Atoi(c.Param("id"))
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	type request struct {
		WorkerID *int `json:"worker_id"`
	}

	req := request{}

	if err := c.BindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	if err := r.service.Reassign(id, req.WorkerID); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"status": "success"})
}

// @Summary		Оценки на запрос.
// @Description	Оценки на запрос.
// @Accept			json
// @Produce		json
// @Tags			RequestExecution
// @Success		200
// @Param			id		path		int								true	"идентификатор работы"
// @Param			request	body		controller.RequestRate.request	true	"оценка на работу"
// @Success		200		{object}	map[string]interface{}			"success"
// @Failure		403		{object}	map[string]interface{}
// @Failure		400,404	{object}	map[string]interface{}
// @Failure		500		{object}	map[string]interface{}
// @Failure		default	{object}	map[string]interface{}
// @Router			/re/:id/rate [put]
func (h *requestExecution) RequestRate(c *gin.Context) {
	type request struct {
		Rate    int    `json:"rate"`
		Comment string `json:"comment"`
	}

	var (
		req model.RequestExecution
		err error
	)

	req.ID, err = strconv.Atoi(c.Param("id"))
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"name": "id", "error": err.Error()})
		return
	}

	r := request{}

	if err := c.BindJSON(&r); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"name": "request", "error": err.Error()})
		return
	}

	if err := h.service.RequestRate(req, r.Rate, r.Comment); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"reason": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"reason": "success"})
}

// @Summary		История изменение заявки по идентификатору
// @Description	История изменение заявки по идентификатору
// @Accept			json
// @Produce		json
// @Tags			RequestExecution
// @Success		200
// @Param			id		path		int	true	"идентификатор работы"
// @Success		200		{object}	[]model.RequestExecution
// @Failure		403		{object}	map[string]interface{}
// @Failure		400,404	{object}	map[string]interface{}
// @Failure		500		{object}	map[string]interface{}
// @Failure		default	{object}	map[string]interface{}
// @Router			/re/:id/history [get]
func (r *requestExecution) GetHistoryByID(c *gin.Context) {
	id, err := strconv.Atoi(c.Param("id"))
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	res, err := r.service.GetHistoryByID(id)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"reason": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"request_executions_histories": res})
}

// @Summary	История прохождение пути водителя
// @Accept		json
// @Produce	json
// @Tags		RequestExecution
// @Success	200
// @Param		id		path		int	true	"идентификатор работы"
// @Success	200		{object}	[]model.RequestExecution
// @Failure	403		{object}	map[string]interface{}
// @Failure	400,404	{object}	map[string]interface{}
// @Failure	500		{object}	map[string]interface{}
// @Failure	default	{object}	map[string]interface{}
// @Router		/re/:id/history/traveled_way [get]
func (r *requestExecution) HistoryTraveledWay(c *gin.Context) {
	id, err := strconv.Atoi(c.Param("id"))
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	cord, err := r.service.HistoryTraveledWay(c, id)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"history_traveled_way": cord})
}

// @Summary	Изменение времени окончания работы
// @Accept		json
// @Produce	json
// @Tags		RequestExecution
// @Success	200
// @Param		id		path		int									true	"идентификатор работы"
// @Param		request	body		controller.UpdateEndLeaseAt.request	true	"время окончвния"
// @Success	200		{object}	map[string]interface{}
// @Failure	403		{object}	map[string]interface{}
// @Failure	400,404	{object}	map[string]interface{}
// @Failure	500		{object}	map[string]interface{}
// @Failure	default	{object}	map[string]interface{}
// @Router		/re/:id/end_lease_at [patch]
func (r *requestExecution) UpdateEndLeaseAt(c *gin.Context) {
	id, err := strconv.Atoi(c.Param("id"))
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	type request struct {
		EndLeaseAt model.Time `json:"end_lease_at"`
	}

	req := request{}

	if err := c.BindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	if err := r.service.UpdateEndLeaseAt(c, id, req.EndLeaseAt); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"reason": "success"})
}

// @Summary		Создание выполнение работы без участия клиента
// @Description	если создает водитель у которого есть владелец то выполнение работа назначается на работника кто создает
// @Description	а владельцем заявки на выполнение работы назначается сам водитель (в этом случаее поле assigned должен быть заполнен id выполнителя работы)
// @Description
// @Description	base передаь в form-data
// @Description
// @Description	`wtc_full_name_client, wtc_phone_number, wtc_description` поля об информации клиента, валидации на заполнения нет, wtc_phone_number не должен быть пустым
// @Accept			mpfd
// @Produce		json
// @Tags			RequestExecution
// @Success		200
// @Param			base	body		controller.CreateRequestExecutionAssignmentWithoutClinet.request	true	"тело выполнения работы"
// @Param			foto	formData	file																true	"фотография"
// @Success		200		{object}	map[string]interface{}
// @Failure		403		{object}	map[string]interface{}
// @Failure		400,404	{object}	map[string]interface{}
// @Failure		500		{object}	map[string]interface{}
// @Failure		default	{object}	map[string]interface{}
// @Router			/re/without_the_client [post]
func (r *requestExecution) CreateRequestExecutionAssignmentWithoutClinet(c *gin.Context) {
	user, err := GetUserFromGin(c)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	mf, err := c.MultipartForm()
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	type request struct {
		Src               string           `json:"src"`
		AssignTo          *int             `json:"assigned"`
		DriverID          *int             `json:"driver_id"`
		Title             string           `json:"title"`
		FinishAddress     *string          `json:"finish_address"`
		FinishLatitude    *float64         `json:"finish_latitude"`
		FinishLongitude   *float64         `json:"finish_longitude"`
		StartLeaseAt      model.Time       `json:"start_lease_at"`
		EndLeaseAt        model.Time       `json:"end_lease_at"`
		Document          []model.Document `json:"-" swaggerignore:"true"`
		WTCFullNameClient *string          `json:"wtc_full_name_client"`
		WTCPhoneNumber    string           `json:"wtc_phone_number"`
		WTCDescription    *string          `json:"wtc_description"`
	}

	req := request{}

	if len(mf.Value["base"]) != 0 {
		val := mf.Value["base"][0]

		if err := json.Unmarshal([]byte(val), &req); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
			return
		}

		// if req.DriverID != &user.ID {
		// 	c.JSON(http.StatusBadRequest, gin.H{"error": "the driver is no match for the person who makes her"})
		// 	return
		// }

		if req.WTCPhoneNumber == "" {
			c.JSON(http.StatusBadRequest, gin.H{"error": "wtc_phone_number empty"})
			return
		}

	} else {
		c.JSON(http.StatusBadRequest, gin.H{"error": "dont have base"})
		return
	}

	req.Document = make([]model.Document, 0, len(mf.File["foto"]))

	for _, val := range mf.File["foto"] {
		d, err := util.ParseDocumentOnMultipart(val)
		if err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
			return
		}

		d.UserID = user.ID
		req.Document = append(req.Document, d)
	}

	err = r.service.CreateRequestExecutionAssignmentWithoutClinet(c, model.RequestExecution{
		Src:               req.Src,
		AssignTo:          req.AssignTo,
		DriverID:          req.DriverID,
		Title:             req.Title,
		FinishAddress:     req.FinishAddress,
		FinishLatitude:    req.FinishLatitude,
		FinishLongitude:   req.FinishLongitude,
		StartLeaseAt:      req.StartLeaseAt,
		EndLeaseAt:        req.EndLeaseAt,
		Documents:         req.Document,
		WTCFullNameClient: req.WTCFullNameClient,
		WTCPhoneNumber:    &req.WTCPhoneNumber,
		WTCDescription:    req.WTCDescription,
	})
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err})
		return
	}

	c.JSON(http.StatusOK, gin.H{"reason": "success"})
}
