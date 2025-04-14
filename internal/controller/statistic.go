package controller

import (
	"database/sql"
	"net/http"
	"strconv"
	"time"

	"github.com/gin-gonic/gin"
	"gitlab.com/eqshare/eqshare-back/internal/service"
	"gitlab.com/eqshare/eqshare-back/model"
)

type reports struct {
	rService    service.IStatistic
	authService service.IAuthentication
}

func NewStatistic(r *gin.Engine, rService service.IStatistic, authService service.IAuthentication) {
	handler := &reports{
		rService:    rService,
		authService: authService,
	}

	statistics := r.Group("/statistics")
	statistics.GET("request/sm", handler.GetRequestExecutionStatistics)
	statistics.GET("request/client", handler.GetClientRequestStatistics)

	statistics.GET("ad/client", handler.GetAdClientStatistics)
	statistics.GET("ad/sm", handler.GetAdSmStatistics)
	statistics.GET("ad/client/:id", handler.GetAdSpecializedMachineryStaticByID)
	statistics.GET("ad/sm/:id", handler.GetAdClientStatisticByID)

	statistics.GET("re/:id/history", handler.GetRequestExecutionHistory)
	statistics.GET("re/:id/status", handler.RequestExectionStatusTime)
	statistics.GET("re/sum_payment_amount", handler.RequestExectionSumPaymentAmount)
	// statistics.GET("sub_category", handler.AdClientCountBySubCategory)

	statistics.GET("ad/client/sub_category", handler.AdClientCountBySubCategory)
	statistics.GET("ad/sm/sub_category", handler.AdSpecializedMachineryCountBySubCategory)

	statistics.GET("ad/client/category", handler.AdClientCountByCategory)
	statistics.GET("ad/sm/category", handler.AdSpecializedMachineryCountByCategory)

	statistics.GET("ad/eq_client/category", handler.AdEquipmentClientCountByCategory)
	statistics.GET("ad/eq/category", handler.AdEquipmentCountByCategory)

	statistics.GET("ad/eq_client/sub_category", handler.AdEquipmentClientCountBySubCategory)
	statistics.GET("ad/eq/sub_category", handler.AdEquipmentCountBySubCategory)
}

// @Summary		Запрос на «Объявления о спецтехники» (общий, в разрезе статусов)
// @Description	Запрос на «Объявления о спецтехники» (общий, в разрезе статусов)
// @Description	`В дальнейшем добавится фильтры через query параметры`
// @Security		ApiKeyAuth
// @Accept			json
// @Produce		json
// @Tags			Statistics
// @Param			Authorization	header		string	true	"приставка `Bearer` с пробелом и сам токен"
// @Success		200				{array}		model.RequestByStatusReport
// @Failure		403				{object}	map[string]interface{}
// @Failure		400,404			{object}	map[string]interface{}
// @Failure		500				{object}	map[string]interface{}
// @Failure		default			{object}	map[string]interface{}
// @Router			/statistics/request/sm [get]
func (h *reports) GetRequestExecutionStatistics(r *gin.Context) {
	status := r.Query("status")

	reqExecutionStat, err := h.rService.GetRequestExecutionStatistic(status)
	if err != nil {
		r.JSON(http.StatusInternalServerError, gin.H{"reason": err.Error()})
		return
	}

	r.JSON(http.StatusOK, reqExecutionStat)
}

// @Summary		Объявления о работе клиента (общий, в разрезе категории)
// @Description	Объявления о работе клиента (общий, в разрезе категории)
// @Description	`В дальнейшем добавится фильтры через query параметры`
// @Security		ApiKeyAuth
// @Accept			json
// @Produce		json
// @Tags			Statistics
// @Param			Authorization	header		string	true	"приставка `Bearer` с пробелом и сам токен"
// @Success		200				{array}		model.AdReport
// @Failure		403				{object}	map[string]interface{}
// @Failure		400,404			{object}	map[string]interface{}
// @Failure		500				{object}	map[string]interface{}
// @Failure		default			{object}	map[string]interface{}
// @Router			/statistics/ad/client [get]
func (h *reports) GetAdClientStatistics(r *gin.Context) {
	adClientStat, err := h.rService.GetAdClientStatistic()
	if err != nil {
		r.JSON(http.StatusInternalServerError, gin.H{"reason": err.Error()})
		return
	}

	r.JSON(http.StatusOK, adClientStat)
}

// @Summary		Объявления о спецтехники (общий, в разрезе категории)
// @Description	Объявления о спецтехники (общий, в разрезе категории)
// @Description	`В дальнейшем добавится фильтры через query параметры`
// @Security		ApiKeyAuth
// @Accept			json
// @Produce		json
// @Tags			Statistics
// @Param			Authorization	header		string	true	"приставка `Bearer` с пробелом и сам токен"
// @Success		200				{array}		model.AdReport
// @Failure		403				{object}	map[string]interface{}
// @Failure		400,404			{object}	map[string]interface{}
// @Failure		500				{object}	map[string]interface{}
// @Failure		default			{object}	map[string]interface{}
// @Router			/statistics/ad/sm [get]
func (h *reports) GetAdSmStatistics(r *gin.Context) {
	adSmStat, err := h.rService.GetAdSmStatistic()
	if err != nil {
		r.JSON(http.StatusInternalServerError, gin.H{"reason": err.Error()})
		return
	}

	r.JSON(http.StatusOK, adSmStat)
}

// @Summary		Запрос на «Объявления о работе клиента» (общий, в разрезе статусов)
// @Description	Запрос на «Объявления о работе клиента» (общий, в разрезе статусов)
// @Description	`В дальнейшем добавится фильтры через query параметры`
// @Security		ApiKeyAuth
// @Accept			json
// @Produce		json
// @Tags			Statistics
// @Param			Authorization	header		string	true	"приставка `Bearer` с пробелом и сам токен"
// @Success		200				{array}		model.RequestByStatusReport
// @Failure		403				{object}	map[string]interface{}
// @Failure		400,404			{object}	map[string]interface{}
// @Failure		500				{object}	map[string]interface{}
// @Failure		default			{object}	map[string]interface{}
// @Router			/statistics/request/client [get]
func (h *reports) GetClientRequestStatistics(r *gin.Context) {
	status := r.Query("status")

	clientReqStat, err := h.rService.GetClientRequestStatistic(status)
	if err != nil {
		r.JSON(http.StatusInternalServerError, gin.H{"reason": err.Error()})
		return
	}

	r.JSON(http.StatusOK, clientReqStat)
}

// @Summary		Количество запросов на объявления (в разрезе статусов)
// @Description	Количество запросов на объявления (в разрезе статусов)
// @Security		ApiKeyAuth
// @Accept			json
// @Produce		json
// @Tags			Statistics
// @Param			Authorization	header		string	true	"приставка `Bearer` с пробелом и сам токен"
// @Param			id				path		int		true	"идентификатор объявления"
// @Success		200				{array}		model.RequestByStatusReport
// @Failure		403				{object}	map[string]interface{}
// @Failure		400,404			{object}	map[string]interface{}
// @Failure		500				{object}	map[string]interface{}
// @Failure		default			{object}	map[string]interface{}
// @Router			/statistics/ad/client/:id [get]
func (h *reports) GetAdSpecializedMachineryStaticByID(c *gin.Context) {
	id, err := strconv.Atoi(c.Param("id"))
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	stat, err := h.rService.GetAdSpecializedMachineryStaticByID(id)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"statistic": stat})
}

// @Summary		Количество запросов на объявления (в разрезе статусов)
// @Description	Количество запросов на объявления (в разрезе статусов)
// @Security		ApiKeyAuth
// @Accept			json
// @Produce		json
// @Tags			Statistics
// @Param			Authorization	header		string	true	"приставка `Bearer` с пробелом и сам токен"
// @Param			id				path		int		true	"идентификатор объявления"
// @Success		200				{array}		model.RequestByStatusReport
// @Failure		403				{object}	map[string]interface{}
// @Failure		400,404			{object}	map[string]interface{}
// @Failure		500				{object}	map[string]interface{}
// @Failure		default			{object}	map[string]interface{}
// @Router			/statistics/ad/sm/:id [get]
func (h *reports) GetAdClientStatisticByID(c *gin.Context) {
	id, err := strconv.Atoi(c.Param("id"))
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	stat, err := h.rService.GetAdClientStatisticByID(id)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"statistic": stat})
}

// @Summary		История выполнения работы
// @Description	В порядке начало работы до концца
// @Description	При случае когда rate заполнен клиент поставил оценку
// @Description	При статусе status = FINISHED время (duration) означает время ожидания оценки
// @Description	duration(время потраченное на выполнение отрезка статуса) исчесляется в наносекунде (nanosecond)
// @Description	В порядке начало работы до концца
// @Security		ApiKeyAuth
// @Accept			json
// @Produce		json
// @Tags			Statistics
// @Tags			RequestExecution
// @Param			Authorization	header		string	true	"приставка `Bearer` с пробелом и сам токен"
// @Param			id				path		int		true	"идентификатор объявления"
// @Success		200				{object}	[]model.RequestExectionHistory
// @Failure		403				{object}	map[string]interface{}
// @Failure		400,404			{object}	map[string]interface{}
// @Failure		500				{object}	map[string]interface{}
// @Failure		default			{object}	map[string]interface{}
// @Router			/statisticsre/:id/history [get]
func (h *reports) GetRequestExecutionHistory(c *gin.Context) {
	id, err := strconv.Atoi(c.Param("id"))
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	res, err := h.rService.GetRequestExecutionHistory(id)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"statistic": res})
}

// @Summary	Расчет общего количестов времени потраченного на работу в разреве статустов
// @Security	ApiKeyAuth
// @Accept		json
// @Produce	json
// @Tags		Statistics
// @Tags		RequestExecution
// @Param		Authorization	header		string	true	"приставка `Bearer` с пробелом и сам токен"
// @Param		id				path		int		true	"идентификатор объявления"
// @Success	200				{object}	model.RequestExectionStatusTime
// @Failure	403				{object}	map[string]interface{}
// @Failure	400,404			{object}	map[string]interface{}
// @Failure	500				{object}	map[string]interface{}
// @Failure	default			{object}	map[string]interface{}
// @Router		/statistics/re/:id/status [get]
func (h *reports) RequestExectionStatusTime(c *gin.Context) {
	id, err := strconv.Atoi(c.Param("id"))
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	res, err := h.rService.RequestExectionStatusTime(id)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"statistic": res})
}

// @Summary	Количество объявлений клиента спецтехники в разрезе подкатегорий
// @Security	ApiKeyAuth
// @Accept		json
// @Produce	json
// @Tags		Statistics
// @Param		id		query		int	false	"можно несколько раз, идентификатор объявления"
// @Param		city_id	query		int	false	"идентификатор города"
// @Success	200		{object}	model.CategoryCount
// @Failure	403		{object}	map[string]interface{}
// @Failure	400,404	{object}	map[string]interface{}
// @Failure	500		{object}	map[string]interface{}
// @Failure	default	{object}	map[string]interface{}
// @Router		/statistics/ad/client/sub_category [get]
func (h *reports) AdClientCountBySubCategory(c *gin.Context) {
	f := model.FilterSubCategoryCount{}

	if idsStr, ok := c.GetQueryArray("id"); ok {
		f.IDs = make([]int, 0, len(idsStr))
		for _, v := range idsStr {
			id, err := strconv.Atoi(v)
			if err != nil {
				c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
				return
			}
			f.IDs = append(f.IDs, id)
		}
	}

	if idStr, ok := c.GetQuery("city_id"); ok {
		id, err := strconv.Atoi(idStr)
		if err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
			return
		}
		if model.Kazakstan != id {
			f.CityID = &id
		}
	}

	res, err := h.rService.AdClientCountBySubCategory(f)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"statistics": res})
}

// @Summary	Количество объявлений спецтехники в разрезе подкатегорий
// @Security	ApiKeyAuth
// @Accept		json
// @Produce	json
// @Tags		Statistics
// @Param		id		query		int	false	"можно несколько раз, идентификатор объявления"
// @Param		city_id	query		int	false	"идентификатор города"
// @Success	200		{object}	model.CategoryCount
// @Failure	403		{object}	map[string]interface{}
// @Failure	400,404	{object}	map[string]interface{}
// @Failure	500		{object}	map[string]interface{}
// @Failure	default	{object}	map[string]interface{}
// @Router		/statistics/ad/sm/sub_category [get]
func (h *reports) AdSpecializedMachineryCountBySubCategory(c *gin.Context) {
	f := model.FilterSubCategoryCount{}

	if idsStr, ok := c.GetQueryArray("id"); ok {
		f.IDs = make([]int, 0, len(idsStr))
		for _, v := range idsStr {
			id, err := strconv.Atoi(v)
			if err != nil {
				c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
				return
			}
			f.IDs = append(f.IDs, id)
		}
	}

	if idStr, ok := c.GetQuery("city_id"); ok {
		id, err := strconv.Atoi(idStr)
		if err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
			return
		}
		if model.Kazakstan != id {
			f.CityID = &id
		}
	}

	res, err := h.rService.AdSpecializedMachineryCountBySubCategory(f)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"statistics": res})
}

// @Summary	Количество объявлений клиента спецтехники в разрезе категорий
// @Security	ApiKeyAuth
// @Accept		json
// @Produce	json
// @Tags		Statistics
// @Param		id		query		int	false	"можно несколько раз, идентификатор объявления"
// @Param		city_id	query		int	false	"идентификатор города"
// @Success	200		{object}	model.CategoryCount
// @Failure	403		{object}	map[string]interface{}
// @Failure	400,404	{object}	map[string]interface{}
// @Failure	500		{object}	map[string]interface{}
// @Failure	default	{object}	map[string]interface{}
// @Router		/statistics/ad/client/category [get]
func (h *reports) AdClientCountByCategory(c *gin.Context) {
	f := model.FilterCategoryCount{}

	if idsStr, ok := c.GetQueryArray("id"); ok {
		f.IDs = make([]int, 0, len(idsStr))
		for _, v := range idsStr {
			id, err := strconv.Atoi(v)
			if err != nil {
				c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
				return
			}
			f.IDs = append(f.IDs, id)
		}
	}

	if idStr, ok := c.GetQuery("city_id"); ok {
		id, err := strconv.Atoi(idStr)
		if err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
			return
		}
		if model.Kazakstan != id {
			f.CityID = &id
		}
	}

	res, err := h.rService.AdClientCountByCategory(f)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"statistics": res})
}

// @Summary	Количество объявлений спецтехники в разрезе категорий
// @Security	ApiKeyAuth
// @Accept		json
// @Produce	json
// @Tags		Statistics
// @Param		id		query		int	false	"можно несколько раз, идентификатор объявления"
// @Param		city_id	query		int	false	"идентификатор города"
// @Success	200		{object}	model.CategoryCount
// @Failure	403		{object}	map[string]interface{}
// @Failure	400,404	{object}	map[string]interface{}
// @Failure	500		{object}	map[string]interface{}
// @Failure	default	{object}	map[string]interface{}
// @Router		/statistics/ad/sm/category [get]
func (h *reports) AdSpecializedMachineryCountByCategory(c *gin.Context) {
	f := model.FilterCategoryCount{}

	if idsStr, ok := c.GetQueryArray("id"); ok {
		f.IDs = make([]int, 0, len(idsStr))
		for _, v := range idsStr {
			id, err := strconv.Atoi(v)
			if err != nil {
				c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
				return
			}
			f.IDs = append(f.IDs, id)
		}
	}

	if idStr, ok := c.GetQuery("city_id"); ok {
		id, err := strconv.Atoi(idStr)
		if err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
			return
		}
		if model.Kazakstan != id {
			f.CityID = &id
		}
	}

	res, err := h.rService.AdSpecializedMachineryCountByCategory(f)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"statistics": res})
}

// @Summary	Количество объявлений клиента оборудовании в разрезе категорий
// @Security	ApiKeyAuth
// @Accept		json
// @Produce	json
// @Tags		Statistics
// @Param		id		query		int	false	"можно несколько раз, идентификатор объявления"
// @Param		city_id	query		int	false	"идентификатор города"
// @Success	200		{object}	model.CategoryCount
// @Failure	403		{object}	map[string]interface{}
// @Failure	400,404	{object}	map[string]interface{}
// @Failure	500		{object}	map[string]interface{}
// @Failure	default	{object}	map[string]interface{}
// @Router		/statistics/ad/eq_client/category [get]
func (h *reports) AdEquipmentClientCountByCategory(c *gin.Context) {
	f := model.FilterCategoryCount{}

	if idsStr, ok := c.GetQueryArray("id"); ok {
		f.IDs = make([]int, 0, len(idsStr))
		for _, v := range idsStr {
			id, err := strconv.Atoi(v)
			if err != nil {
				c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
				return
			}
			f.IDs = append(f.IDs, id)
		}
	}

	if idStr, ok := c.GetQuery("city_id"); ok {
		id, err := strconv.Atoi(idStr)
		if err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
			return
		}
		if model.Kazakstan != id {
			f.CityID = &id
		}
	}

	res, err := h.rService.AdEquipmentClientCountByCategory(c, f)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"statistics": res})
}

// @Summary	Количество объявлений оборудовании в разрезе категорий
// @Security	ApiKeyAuth
// @Accept		json
// @Produce	json
// @Tags		Statistics
// @Param		id		query		int	false	"можно несколько раз, идентификатор объявления"
// @Param		city_id	query		int	false	"идентификатор города"
// @Success	200		{object}	model.CategoryCount
// @Failure	403		{object}	map[string]interface{}
// @Failure	400,404	{object}	map[string]interface{}
// @Failure	500		{object}	map[string]interface{}
// @Failure	default	{object}	map[string]interface{}
// @Router		/statistics/ad/eq/category [get]
func (h *reports) AdEquipmentCountByCategory(c *gin.Context) {
	f := model.FilterCategoryCount{}

	if idsStr, ok := c.GetQueryArray("id"); ok {
		f.IDs = make([]int, 0, len(idsStr))
		for _, v := range idsStr {
			id, err := strconv.Atoi(v)
			if err != nil {
				c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
				return
			}
			f.IDs = append(f.IDs, id)
		}
	}

	if idStr, ok := c.GetQuery("city_id"); ok {
		id, err := strconv.Atoi(idStr)
		if err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
			return
		}
		if model.Kazakstan != id {
			f.CityID = &id
		}
	}

	res, err := h.rService.AdEquipmentCountByCategory(c, f)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"statistics": res})
}

// @Summary	Количество объявлений клиента оборудовании в разрезе подкатегорий
// @Security	ApiKeyAuth
// @Accept		json
// @Produce	json
// @Tags		Statistics
// @Param		id		query		int	false	"можно несколько раз, идентификатор объявления"
// @Param		city_id	query		int	false	"идентификатор города"
// @Success	200		{object}	model.CategoryCount
// @Failure	403		{object}	map[string]interface{}
// @Failure	400,404	{object}	map[string]interface{}
// @Failure	500		{object}	map[string]interface{}
// @Failure	default	{object}	map[string]interface{}
// @Router		/statistics/ad/eq_client/sub_category [get]
func (h *reports) AdEquipmentClientCountBySubCategory(c *gin.Context) {
	f := model.FilterCategoryCount{}

	if idsStr, ok := c.GetQueryArray("id"); ok {
		f.IDs = make([]int, 0, len(idsStr))
		for _, v := range idsStr {
			id, err := strconv.Atoi(v)
			if err != nil {
				c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
				return
			}
			f.IDs = append(f.IDs, id)
		}
	}

	if idStr, ok := c.GetQuery("city_id"); ok {
		id, err := strconv.Atoi(idStr)
		if err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
			return
		}
		if model.Kazakstan != id {
			f.CityID = &id
		}
	}

	res, err := h.rService.AdEquipmentClientCountBySubCategory(c, f)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"statistics": res})
}

// @Summary	Количество объявлений оборудовании в разрезе подкатегорий
// @Security	ApiKeyAuth
// @Accept		json
// @Produce	json
// @Tags		Statistics
// @Param		id		query		int	false	"можно несколько раз, идентификатор объявления"
// @Param		city_id	query		int	false	"идентификатор города"
// @Success	200		{object}	model.CategoryCount
// @Failure	403		{object}	map[string]interface{}
// @Failure	400,404	{object}	map[string]interface{}
// @Failure	500		{object}	map[string]interface{}
// @Failure	default	{object}	map[string]interface{}
// @Router		/statistics/ad/eq/sub_category [get]
func (h *reports) AdEquipmentCountBySubCategory(c *gin.Context) {
	f := model.FilterCategoryCount{}

	if idsStr, ok := c.GetQueryArray("id"); ok {
		f.IDs = make([]int, 0, len(idsStr))
		for _, v := range idsStr {
			id, err := strconv.Atoi(v)
			if err != nil {
				c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
				return
			}
			f.IDs = append(f.IDs, id)
		}
	}

	if idStr, ok := c.GetQuery("city_id"); ok {
		id, err := strconv.Atoi(idStr)
		if err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
			return
		}
		if model.Kazakstan != id {
			f.CityID = &id
		}
	}

	res, err := h.rService.AdEquipmentCountBySubCategory(c, f)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"statistics": res})
}

// @Summary	Сумма полученного дохода в выполнение работы
// @Security	ApiKeyAuth
// @Accept		json
// @Produce	json
// @Tags		Statistics
// @Param		status			query		string	false	"статус"
// @Param		asc				query		string	false	"можно нескоьлко раз, по убыванию"
// @Param		desc			query		string	false	"можно нескоьлко раз, по возрастанию"
// @Param		src				query		string	false	"источник"	Enums(SM, SM_CLIENT, EQ, EQ_CLIENT)
// @Param		client_id		query		int		false	"работы связанные с идентифкатором клиента"
// @Param		driver_id		query		int		false	"работы связанные с идентифкатором водителя/владельца"
// @Param		assign_to		query		int		false	"работы назначпенные на пользовтеля с идентификатором"
// @Param		src				query		string	false	"источник"	Enums(SM, SM_CLIENT, EQ, EQ_CLIENT)
// @Param		min_updated_at	query		string	false	"формат год-месяц-день `2006-01-02`, фильтр по времени обновления, минимальная дата включительно"
// @Param		max_updated_at	query		string	false	"формат год-месяц-день `2006-01-02`, фильтр по времени обновления, максимальная дата включительно"
// @Success	200				{object}	map[string]interface{}
// @Failure	403				{object}	map[string]interface{}
// @Failure	400,404			{object}	map[string]interface{}
// @Failure	500				{object}	map[string]interface{}
// @Failure	default			{object}	map[string]interface{}
// @Router		/statistics/re/sum_payment_amount [get]
func (h *reports) RequestExectionSumPaymentAmount(c *gin.Context) {

	f := model.FilterRequestExecution{}

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

	sum, err := h.rService.RequestExectionSumPaymentAmount(c, f)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"sum_payment_amount": sum})
}
