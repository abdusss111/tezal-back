package controller

import (
	"net/http"
	"strconv"

	"github.com/gin-gonic/gin"
	"gitlab.com/eqshare/eqshare-back/internal/service"
	"gitlab.com/eqshare/eqshare-back/model"
)

type report struct {
	reportService service.IReport
}

func NewReport(r *gin.Engine, auth service.IAuthentication, reportService service.IReport) {
	handlers := report{
		reportService: reportService,
	}

	report := r.Group("report")
	{
		report.GET("reasons/ad", handlers.GetReason)
		report.GET("reasons/system", handlers.GetReasonSystem)
	}

	sys := report.Group("system")
	{
		sys.GET("", handlers.GetSystem)
		sys.GET(":id", handlers.GetByIDSystem)
		sys.POST("",
			authorize(auth, model.ROLE_ADMIN, model.ROLE_DRIVER, model.ROLE_OWNER, model.ROLE_CLIENT),
			handlers.CreateSystem)
		sys.DELETE(":id",
			authorize(auth, model.ROLE_ADMIN, model.ROLE_DRIVER, model.ROLE_OWNER, model.ROLE_CLIENT),
			handlers.DeleteSystem)
	}

	sm := report.Group("ad/sm")
	{
		sm.GET("", handlers.GetAdSpecializedMachineries)
		sm.GET(":id", handlers.GetByIDAdSpecializedMachineries)
		sm.POST("",
			authorize(auth, model.ROLE_ADMIN, model.ROLE_DRIVER, model.ROLE_OWNER, model.ROLE_CLIENT),
			handlers.CreateAdSpecializedMachineries)
		sm.DELETE(":id",
			authorize(auth, model.ROLE_ADMIN),
			handlers.DeleteAdSpecializedMachineries)
	}

	eq := report.Group("ad/eq")
	{
		eq.GET("", handlers.GetAdEquipments)
		eq.GET(":id", handlers.GetByIDAdEquipments)
		eq.POST("",
			authorize(auth, model.ROLE_ADMIN, model.ROLE_DRIVER, model.ROLE_OWNER, model.ROLE_CLIENT),
			handlers.CreateAdEquipments)
		eq.DELETE(":id",
			authorize(auth, model.ROLE_ADMIN),
			handlers.DeleteAdEquipments)
	}

	sm_client := report.Group("ad/sm_client")
	{
		sm_client.GET("", handlers.GetAdSpecializedMachineriesClient)
		sm_client.GET(":id", handlers.GetByIDAdSpecializedMachineriesClient)
		sm_client.POST("",
			authorize(auth, model.ROLE_ADMIN, model.ROLE_DRIVER, model.ROLE_OWNER, model.ROLE_CLIENT),
			handlers.CreateAdSpecializedMachineriesClient)
		sm_client.DELETE(":id",
			authorize(auth, model.ROLE_ADMIN),
			handlers.DeleteAdSpecializedMachineriesClient)
	}

	eq_client := report.Group("ad/eq_client")
	{
		eq_client.GET("", handlers.GetAdEquipmentsClient)
		eq_client.GET(":id", handlers.GetByIDAdEquipmentsClient)
		eq_client.POST("",
			authorize(auth, model.ROLE_ADMIN, model.ROLE_DRIVER, model.ROLE_OWNER, model.ROLE_CLIENT),
			handlers.CreateAdEquipmentsClient)
		eq_client.DELETE(":id",
			authorize(auth, model.ROLE_ADMIN),
			handlers.DeleteAdEquipmentsClient)
	}

	cm := report.Group("ad/cm")
	{
		cm.GET("", handlers.GetAdConstructionMaterial)
		cm.GET(":id", handlers.GetByIDAdConstructionMaterial)
		cm.POST("",
			authorize(auth, model.ROLE_ADMIN, model.ROLE_DRIVER, model.ROLE_OWNER, model.ROLE_CLIENT),
			handlers.CreateAdSpecializedMachineries)
		cm.DELETE(":id",
			authorize(auth, model.ROLE_ADMIN),
			handlers.DeleteAdSpecializedMachineries)
	}

	svc := report.Group("ad/svc")
	{
		svc.GET("", handlers.GetAdService)
		svc.GET(":id", handlers.GetByIDAdService)
		svc.POST("",
			authorize(auth, model.ROLE_ADMIN, model.ROLE_DRIVER, model.ROLE_OWNER, model.ROLE_CLIENT),
			handlers.CreateAdServices)
		svc.DELETE(":id",
			authorize(auth, model.ROLE_ADMIN),
			handlers.DeleteAdServices)
	}
	cm_client := report.Group("ad/cm_client")
	{
		cm_client.GET("", handlers.GetAdConstructionMaterialsClient)
		cm_client.GET(":id", handlers.GetByIDAdConstructionMaterialsClient)
		cm_client.POST("",
			authorize(auth, model.ROLE_ADMIN, model.ROLE_DRIVER, model.ROLE_OWNER, model.ROLE_CLIENT),
			handlers.CreateAdConstructionMaterialsClient)
		cm_client.DELETE(":id",
			authorize(auth, model.ROLE_ADMIN),
			handlers.DeleteAdConstructionMaterialsClient)
	}

	svc_client := report.Group("ad/svc_client")
	{
		svc_client.GET("", handlers.GetAdServicesClient)
		svc_client.GET(":id", handlers.GetByIDAdServicesClient)
		svc_client.POST("",
			authorize(auth, model.ROLE_ADMIN, model.ROLE_DRIVER, model.ROLE_OWNER, model.ROLE_CLIENT),
			handlers.CreateAdServicesClient)
		svc_client.DELETE(":id",
			authorize(auth, model.ROLE_ADMIN),
			handlers.DeleteAdConstructionMaterials)
	}
}

// @Summary	Получени причин жалоб объявлении
// @Tags		Report (жалобы)
// @Accept		json
// @Produce	json
// @Success	200	{object}	model.ReportReason
// @Failure	400	{object}	map[string]interface{}
// @Failure	404	{object}	map[string]interface{}
// @Failure	500	{object}	map[string]interface{}
// @Router		/report/reasons/ad [get]
func (h *report) GetReason(c *gin.Context) {
	res, err := h.reportService.GetReason(c)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"reason": res})
}

// @Summary	Подача жалоб на спецтехнику
// @Summary	Только Авторизованный человек может сделать жалобу
// @Tags		Report (жалобы)
// @Accept		json
// @Produce	json
// @Param		body	body		controller.CreateAdSpecializedMachineries.request	true	"описание запроса"
// @Success	200		{object}	map[string]interface{}
// @Failure	400		{object}	map[string]interface{}
// @Failure	404		{object}	map[string]interface{}
// @Failure	500		{object}	map[string]interface{}
// @Router		/report/ad/sm [post]
func (h *report) CreateAdSpecializedMachineries(c *gin.Context) {
	user, err := GetUserFromGin(c)
	if err != nil {
		c.JSON(http.StatusUnauthorized, gin.H{"error": err.Error()})
		return
	}

	type request struct {
		ReportReasonsID          int    `json:"report_reasons_id"`
		AdSpecializedMachineryID int    `json:"ad_specialized_machinery_id"`
		Description              string `json:"description"`
	}

	r := request{}

	if err := c.BindJSON(&r); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	err = h.reportService.CreateAdSpecializedMachineries(c, model.ReportAdSpecializedMachineries{
		UserID:                   user.ID,
		ReportReasonsID:          r.ReportReasonsID,
		AdSpecializedMachineryID: r.AdSpecializedMachineryID,
		Description:              r.Description,
	})
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"status": "success"})
}

// @Summary	Получени жалоб на спецтехнику
// @Tags		Report (жалобы)
// @Accept		json
// @Produce	json
// @Param		report_reasons_detail						query		bool	false	"получение деталей о причине жалобы"
// @Param		ad_specialized_machinery_detail				query		bool	false	"получение деталей о объявления спецтехники"
// @Param		ad_specialized_machinery_document_detail	query		bool	false	"получение фотографии в объявлени спецтехники"
// @Param		ids											query		int		false	"фильтр по идентификатору, можно несколько раз"
// @Param		report_reasons_ids							query		int		false	"фильтр по идентификатору причин жалобы, можно несколько раз"
// @Param		ad_specialized_machinery_ids				query		int		false	"фильтр по идентификатору объявлени спецтехники, можно несколько раз"
// @Param		limit										query		int		false	"лимит"
// @Param		offset										query		int		false	"сдвиг"
// @Success	200											{object}	[]model.ReportAdSpecializedMachineries
// @Failure	400											{object}	map[string]interface{}
// @Failure	404											{object}	map[string]interface{}
// @Failure	500											{object}	map[string]interface{}
// @Router		/report/ad/sm [get]
func (h *report) GetAdSpecializedMachineries(c *gin.Context) {
	f := model.FilterReportAdSpecializedMachineries{}

	if vals, ok := c.GetQuery("report_reasons_detail"); ok {
		v, err := strconv.ParseBool(vals)
		if err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"name": "report_reasons_detail", "error": err.Error()})
			return
		}
		f.ReportReasonsDetail = &v
	}

	if vals, ok := c.GetQuery("ad_specialized_machinery_detail"); ok {
		v, err := strconv.ParseBool(vals)
		if err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"name": "ad_specialized_machinery_detail", "error": err.Error()})
			return
		}
		f.AdSpecializedMachineryDetail = &v
	}

	if vals, ok := c.GetQuery("ad_specialized_machinery_document_detail"); ok {
		v, err := strconv.ParseBool(vals)
		if err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"name": "ad_specialized_machinery_document_detail", "error": err.Error()})
			return
		}
		f.AdSpecializedMachineryDocumentDetail = &v
	}

	if vals, ok := c.GetQueryArray("ids"); ok {
		f.IDs = make([]int, 0, len(vals))
		for _, v := range vals {
			id, err := strconv.Atoi(v)
			if err != nil {
				c.JSON(http.StatusBadRequest, gin.H{"name": "ids", "value": v, "error": err.Error()})
				return
			}
			f.IDs = append(f.IDs, id)
		}
	}

	if vals, ok := c.GetQueryArray("report_reasons_ids"); ok {
		f.ReportReasonsIDs = make([]int, 0, len(vals))
		for _, v := range vals {
			id, err := strconv.Atoi(v)
			if err != nil {
				c.JSON(http.StatusBadRequest, gin.H{"name": "report_reasons_ids", "value": v, "error": err.Error()})
				return
			}
			f.ReportReasonsIDs = append(f.ReportReasonsIDs, id)
		}
	}

	if vals, ok := c.GetQueryArray("ad_specialized_machinery_ids"); ok {
		f.AdSpecializedMachineryIDs = make([]int, 0, len(vals))
		for _, v := range vals {
			id, err := strconv.Atoi(v)
			if err != nil {
				c.JSON(http.StatusBadRequest, gin.H{"name": "ad_specialized_machinery_ids", "value": v, "error": err.Error()})
				return
			}
			f.AdSpecializedMachineryIDs = append(f.AdSpecializedMachineryIDs, id)
		}
	}

	if vals, ok := c.GetQuery("limit"); ok {
		n, err := strconv.Atoi(vals)
		if err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"name": "limit", "error": err.Error()})
			return
		}
		f.Limit = &n
	}

	if vals, ok := c.GetQuery("offset"); ok {
		n, err := strconv.Atoi(vals)
		if err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"name": "offset", "error": err.Error()})
			return
		}
		f.Offset = &n
	}

	res, count, err := h.reportService.GetAdSpecializedMachineries(c, f)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"reports": res, "count": count})
}

// @Summary	Получени жалоб на спецтехнику по идентификатору
// @Tags		Report (жалобы)
// @Accept		json
// @Produce	json
// @Param		id	path		int	true	"идентификатор"
// @Success	200	{object}	model.ReportAdSpecializedMachineries
// @Failure	400	{object}	map[string]interface{}
// @Failure	404	{object}	map[string]interface{}
// @Failure	500	{object}	map[string]interface{}
// @Router		/report/ad/sm/{id} [get]
func (h *report) GetByIDAdSpecializedMachineries(c *gin.Context) {
	id, err := strconv.Atoi(c.Param("id"))
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"name": "id", "error": err.Error()})
		return
	}

	res, err := h.reportService.GetByIDAdSpecializedMachineries(c, id)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"report": res})
}

// @Summary	Удаление жалоб на спецтехнику по идентификатору
// @Summary	Только администратор может удалить
// @Tags		Report (жалобы)
// @Accept		json
// @Produce	json
// @Param		id	path		int	true	"идентификатор"
// @Success	200	{object}	map[string]interface{}
// @Failure	400	{object}	map[string]interface{}
// @Failure	404	{object}	map[string]interface{}
// @Failure	500	{object}	map[string]interface{}
// @Router		/report/ad/sm/{id} [delete]
func (h *report) DeleteAdSpecializedMachineries(c *gin.Context) {
	id, err := strconv.Atoi(c.Param("id"))
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"name": "id", "error": err.Error()})
		return
	}

	err = h.reportService.DeleteAdSpecializedMachineries(c, id)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"status": "success"})
}

// @Summary	Подача жалоб на объявления клиента на спецтехники
// @Summary	Только Авторизованный человек может сделать жалобу
// @Tags		Report (жалобы)
// @Accept		json
// @Produce	json
// @Param		body	body		controller.CreateAdSpecializedMachineriesClient.request	true	"описание запроса"
// @Success	200		{object}	map[string]interface{}
// @Failure	400		{object}	map[string]interface{}
// @Failure	404		{object}	map[string]interface{}
// @Failure	500		{object}	map[string]interface{}
// @Router		/report/ad/sm_client [post]
func (h *report) CreateAdSpecializedMachineriesClient(c *gin.Context) {
	user, err := GetUserFromGin(c)
	if err != nil {
		c.JSON(http.StatusUnauthorized, gin.H{"error": err.Error()})
		return
	}

	type request struct {
		ReportReasonsID int    `json:"report_reasons_id"`
		AdClientID      int    `json:"ad_client_id"`
		Description     string `json:"description"`
	}

	r := request{}

	if err := c.BindJSON(&r); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	err = h.reportService.CreateAdSpecializedMachineriesClient(c, model.ReportAdSpecializedMachineriesClient{
		UserID:          user.ID,
		ReportReasonsID: r.ReportReasonsID,
		AdClientID:      r.AdClientID,
		Description:     r.Description,
	})
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"status": "success"})
}

// @Summary	Получени жалоб на объявления клиента на спецтехники
// @Tags		Report (жалобы)
// @Accept		json
// @Produce	json
// @Param		report_reasons_detail		query		bool	false	"получение деталей о причине жалобы"
// @Param		ad_client_detail			query		bool	false	"получение деталей о объявления спецтехники"
// @Param		ad_client_document_detail	query		bool	false	"получение фотографии в объявлени спецтехники"
// @Param		ids							query		int		false	"фильтр по идентификатору, можно несколько раз"
// @Param		report_reasons_ids			query		int		false	"фильтр по идентификатору причин жалобы, можно несколько раз"
// @Param		ad_client_ids				query		int		false	"фильтр по идентификатору объявления клиента на спецтехники, можно несколько раз"
// @Param		limit						query		int		false	"лимит"
// @Param		offset						query		int		false	"сдвиг"
// @Success	200							{object}	[]model.ReportAdSpecializedMachineriesClient
// @Failure	400							{object}	map[string]interface{}
// @Failure	404							{object}	map[string]interface{}
// @Failure	500							{object}	map[string]interface{}
// @Router		/report/ad/sm_client [get]
func (h *report) GetAdSpecializedMachineriesClient(c *gin.Context) {
	f := model.FilterReportAdSpecializedMachineriesClient{}

	if vals, ok := c.GetQuery("report_reasons_detail"); ok {
		v, err := strconv.ParseBool(vals)
		if err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"name": "report_reasons_detail", "error": err.Error()})
			return
		}
		f.ReportReasonsDetail = &v
	}

	if vals, ok := c.GetQuery("ad_client_detail"); ok {
		v, err := strconv.ParseBool(vals)
		if err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"name": "ad_client_detail", "error": err.Error()})
			return
		}
		f.AdClientDetail = &v
	}

	if vals, ok := c.GetQuery("ad_client_document_detail"); ok {
		v, err := strconv.ParseBool(vals)
		if err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"name": "ad_client_document_detail", "error": err.Error()})
			return
		}
		f.AdClientDocumentDetail = &v
	}

	if vals, ok := c.GetQueryArray("ids"); ok {
		f.IDs = make([]int, 0, len(vals))
		for _, v := range vals {
			id, err := strconv.Atoi(v)
			if err != nil {
				c.JSON(http.StatusBadRequest, gin.H{"name": "ids", "value": v, "error": err.Error()})
				return
			}
			f.IDs = append(f.IDs, id)
		}
	}

	if vals, ok := c.GetQueryArray("report_reasons_ids"); ok {
		f.ReportReasonsIDs = make([]int, 0, len(vals))
		for _, v := range vals {
			id, err := strconv.Atoi(v)
			if err != nil {
				c.JSON(http.StatusBadRequest, gin.H{"name": "report_reasons_ids", "value": v, "error": err.Error()})
				return
			}
			f.ReportReasonsIDs = append(f.ReportReasonsIDs, id)
		}
	}

	if vals, ok := c.GetQueryArray("ad_client_ids"); ok {
		f.AdClientIDs = make([]int, 0, len(vals))
		for _, v := range vals {
			id, err := strconv.Atoi(v)
			if err != nil {
				c.JSON(http.StatusBadRequest, gin.H{"name": "ad_client_ids", "value": v, "error": err.Error()})
				return
			}
			f.AdClientIDs = append(f.AdClientIDs, id)
		}
	}

	if vals, ok := c.GetQuery("limit"); ok {
		n, err := strconv.Atoi(vals)
		if err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"name": "limit", "error": err.Error()})
			return
		}
		f.Limit = &n
	}

	if vals, ok := c.GetQuery("offset"); ok {
		n, err := strconv.Atoi(vals)
		if err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"name": "offset", "error": err.Error()})
			return
		}
		f.Offset = &n
	}

	res, count, err := h.reportService.GetAdSpecializedMachineriesClient(c, f)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"reports": res, "count": count})
}

// @Summary	Получени жалоб на объявления клиента на спецтехники по идентификатору
// @Tags		Report (жалобы)
// @Accept		json
// @Produce	json
// @Param		id	path		int	true	"идентификатор"
// @Success	200	{object}	model.ReportAdSpecializedMachineriesClient
// @Failure	400	{object}	map[string]interface{}
// @Failure	404	{object}	map[string]interface{}
// @Failure	500	{object}	map[string]interface{}
// @Router		/report/ad/sm_client/{id} [get]
func (h *report) GetByIDAdSpecializedMachineriesClient(c *gin.Context) {
	id, err := strconv.Atoi(c.Param("id"))
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"name": "id", "error": err.Error()})
		return
	}

	res, err := h.reportService.GetByIDAdSpecializedMachineriesClient(c, id)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"report": res})
}

// @Summary	Удаление жалоб на объявления клиента на спецтехники по идентификатору
// @Summary	Только администратор может удалить
// @Tags		Report (жалобы)
// @Accept		json
// @Produce	json
// @Param		id	path		int	true	"идентификатор"
// @Success	200	{object}	map[string]interface{}
// @Failure	400	{object}	map[string]interface{}
// @Failure	404	{object}	map[string]interface{}
// @Failure	500	{object}	map[string]interface{}
// @Router		/report/ad/sm_client/{id} [delete]
func (h *report) DeleteAdSpecializedMachineriesClient(c *gin.Context) {
	id, err := strconv.Atoi(c.Param("id"))
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"name": "id", "error": err.Error()})
		return
	}

	err = h.reportService.DeleteAdSpecializedMachineriesClient(c, id)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"status": "success"})
}

// @Summary	Подача жалоб на оборудование
// @Summary	Только Авторизованный человек может сделать жалобу
// @Tags		Report (жалобы)
// @Accept		json
// @Produce	json
// @Param		body	body		controller.CreateAdEquipments.request	true	"описание запроса"
// @Success	200		{object}	map[string]interface{}
// @Failure	400		{object}	map[string]interface{}
// @Failure	404		{object}	map[string]interface{}
// @Failure	500		{object}	map[string]interface{}
// @Router		/report/ad/eq [post]
func (h *report) CreateAdEquipments(c *gin.Context) {
	user, err := GetUserFromGin(c)
	if err != nil {
		c.JSON(http.StatusUnauthorized, gin.H{"error": err.Error()})
		return
	}

	type request struct {
		ReportReasonsID int    `json:"report_reasons_id"`
		AdEquipmentID   int    `json:"ad_equipment_id"`
		Description     string `json:"description"`
	}

	r := request{}

	if err := c.BindJSON(&r); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	err = h.reportService.CreateAdEquipments(c, model.ReportAdEquipments{
		UserID:          user.ID,
		ReportReasonsID: r.ReportReasonsID,
		AdEquipmentID:   r.AdEquipmentID,
		Description:     r.Description,
	})
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"status": "success"})
}

// @Summary	Получени жалоб на оборудование
// @Tags		Report (жалобы)
// @Accept		json
// @Produce	json
// @Param		report_reasons_detail			query		bool	false	"получение деталей о причине жалобы"
// @Param		ad_equipment_detail				query		bool	false	"получение деталей о объявления оборудование"
// @Param		ad_equipment_document_detail	query		bool	false	"получение фотографии в объявлени оборудование"
// @Param		ids								query		int		false	"фильтр по идентификатору, можно несколько раз"
// @Param		report_reasons_ids				query		int		false	"фильтр по идентификатору причин жалобы, можно несколько раз"
// @Param		ad_equipment_ids				query		int		false	"фильтр по идентификатору объявлени оборудование, можно несколько раз"
// @Param		limit							query		int		false	"лимит"
// @Param		offset							query		int		false	"сдвиг"
// @Success	200								{object}	[]model.ReportAdEquipments
// @Failure	400								{object}	map[string]interface{}
// @Failure	404								{object}	map[string]interface{}
// @Failure	500								{object}	map[string]interface{}
// @Router		/report/ad/eq [get]
func (h *report) GetAdEquipments(c *gin.Context) {
	f := model.FilterReportAdEquipments{}

	if vals, ok := c.GetQuery("report_reasons_detail"); ok {
		v, err := strconv.ParseBool(vals)
		if err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"name": "report_reasons_detail", "error": err.Error()})
			return
		}
		f.ReportReasonsDetail = &v
	}

	if vals, ok := c.GetQuery("ad_equipment_detail"); ok {
		v, err := strconv.ParseBool(vals)
		if err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"name": "ad_equipment_detail", "error": err.Error()})
			return
		}
		f.AdEquipmentDetail = &v
	}

	if vals, ok := c.GetQuery("ad_equipment_document_detail"); ok {
		v, err := strconv.ParseBool(vals)
		if err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"name": "ad_equipment_document_detail", "error": err.Error()})
			return
		}
		f.AdEquipmentDocumentDetail = &v
	}

	if vals, ok := c.GetQueryArray("ids"); ok {
		f.IDs = make([]int, 0, len(vals))
		for _, v := range vals {
			id, err := strconv.Atoi(v)
			if err != nil {
				c.JSON(http.StatusBadRequest, gin.H{"name": "ids", "value": v, "error": err.Error()})
				return
			}
			f.IDs = append(f.IDs, id)
		}
	}

	if vals, ok := c.GetQueryArray("report_reasons_ids"); ok {
		f.ReportReasonsIDs = make([]int, 0, len(vals))
		for _, v := range vals {
			id, err := strconv.Atoi(v)
			if err != nil {
				c.JSON(http.StatusBadRequest, gin.H{"name": "report_reasons_ids", "value": v, "error": err.Error()})
				return
			}
			f.ReportReasonsIDs = append(f.ReportReasonsIDs, id)
		}
	}

	if vals, ok := c.GetQueryArray("ad_equipment_ids"); ok {
		f.AdEquipmentIDs = make([]int, 0, len(vals))
		for _, v := range vals {
			id, err := strconv.Atoi(v)
			if err != nil {
				c.JSON(http.StatusBadRequest, gin.H{"name": "ad_equipment_ids", "value": v, "error": err.Error()})
				return
			}
			f.AdEquipmentIDs = append(f.AdEquipmentIDs, id)
		}
	}

	if vals, ok := c.GetQuery("limit"); ok {
		n, err := strconv.Atoi(vals)
		if err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"name": "limit", "error": err.Error()})
			return
		}
		f.Limit = &n
	}

	if vals, ok := c.GetQuery("offset"); ok {
		n, err := strconv.Atoi(vals)
		if err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"name": "offset", "error": err.Error()})
			return
		}
		f.Offset = &n
	}

	res, count, err := h.reportService.GetAdEquipments(c, f)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"reports": res, "count": count})
}

// @Summary	Получени жалоб на оборудование по идентификатору
// @Tags		Report (жалобы)
// @Accept		json
// @Produce	json
// @Param		id	path		int	true	"идентификатор"
// @Success	200	{object}	model.ReportAdEquipments
// @Failure	400	{object}	map[string]interface{}
// @Failure	404	{object}	map[string]interface{}
// @Failure	500	{object}	map[string]interface{}
// @Router		/report/ad/eq/{id} [get]
func (h *report) GetByIDAdEquipments(c *gin.Context) {
	id, err := strconv.Atoi(c.Param("id"))
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"name": "id", "error": err.Error()})
		return
	}

	res, err := h.reportService.GetByIDAdEquipments(c, id)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"report": res})
}

// @Summary	Удаление жалоб на оборудование по идентификатору
// @Summary	Только администратор может удалить
// @Tags		Report (жалобы)
// @Accept		json
// @Produce	json
// @Param		id	path		int	true	"идентификатор"
// @Success	200	{object}	map[string]interface{}
// @Failure	400	{object}	map[string]interface{}
// @Failure	404	{object}	map[string]interface{}
// @Failure	500	{object}	map[string]interface{}
// @Router		/report/ad/eq/{id} [delete]
func (h *report) DeleteAdEquipments(c *gin.Context) {
	id, err := strconv.Atoi(c.Param("id"))
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"name": "id", "error": err.Error()})
		return
	}

	err = h.reportService.DeleteAdEquipments(c, id)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"status": "success"})
}

// @Summary	Подача жалоб на оборудование клиенита
// @Summary	Только Авторизованный человек может сделать жалобу
// @Tags		Report (жалобы)
// @Accept		json
// @Produce	json
// @Param		body	body		controller.CreateAdEquipmentsClient.request	true	"описание запроса"
// @Success	200		{object}	map[string]interface{}
// @Failure	400		{object}	map[string]interface{}
// @Failure	404		{object}	map[string]interface{}
// @Failure	500		{object}	map[string]interface{}
// @Router		/report/ad/eq_client [post]
func (h *report) CreateAdEquipmentsClient(c *gin.Context) {
	user, err := GetUserFromGin(c)
	if err != nil {
		c.JSON(http.StatusUnauthorized, gin.H{"error": err.Error()})
		return
	}

	type request struct {
		ReportReasonsID     int    `json:"report_reasons_id"`
		AdEquipmentClientID int    `json:"ad_equipment_client_id"`
		Description         string `json:"description"`
	}

	r := request{}

	if err := c.BindJSON(&r); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	err = h.reportService.CreateAdEquipmentsClient(c, model.ReportAdEquipmentClient{
		UserID:              user.ID,
		ReportReasonsID:     r.ReportReasonsID,
		AdEquipmentClientID: r.AdEquipmentClientID,
		Description:         r.Description,
	})
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"status": "success"})
}

// @Summary	Получени жалоб на оборудование клиента
// @Tags		Report (жалобы)
// @Accept		json
// @Produce	json
// @Param		report_reasons_detail			query		bool	false	"получение деталей о причине жалобы"
// @Param		ad_equipment_detail				query		bool	false	"получение деталей о объявления оборудование"
// @Param		ad_equipment_document_detail	query		bool	false	"получение фотографии в объявлени оборудование"
// @Param		ids								query		int		false	"фильтр по идентификатору, можно несколько раз"
// @Param		report_reasons_ids				query		int		false	"фильтр по идентификатору причин жалобы, можно несколько раз"
// @Param		ad_equipment_ids				query		int		false	"фильтр по идентификатору объявлени оборудование, можно несколько раз"
// @Param		limit							query		int		false	"лимит"
// @Param		offset							query		int		false	"сдвиг"
// @Success	200								{object}	[]model.ReportAdEquipments
// @Failure	400								{object}	map[string]interface{}
// @Failure	404								{object}	map[string]interface{}
// @Failure	500								{object}	map[string]interface{}
// @Router		/report/ad/eq_client [get]
func (h *report) GetAdEquipmentsClient(c *gin.Context) {
	f := model.FilterReportAdEquipments{}

	if vals, ok := c.GetQuery("report_reasons_detail"); ok {
		v, err := strconv.ParseBool(vals)
		if err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"name": "report_reasons_detail", "error": err.Error()})
			return
		}
		f.ReportReasonsDetail = &v
	}

	if vals, ok := c.GetQuery("ad_equipment_detail"); ok {
		v, err := strconv.ParseBool(vals)
		if err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"name": "ad_equipment_detail", "error": err.Error()})
			return
		}
		f.AdEquipmentDetail = &v
	}

	if vals, ok := c.GetQuery("ad_equipment_document_detail"); ok {
		v, err := strconv.ParseBool(vals)
		if err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"name": "ad_equipment_document_detail", "error": err.Error()})
			return
		}
		f.AdEquipmentDocumentDetail = &v
	}

	if vals, ok := c.GetQueryArray("ids"); ok {
		f.IDs = make([]int, 0, len(vals))
		for _, v := range vals {
			id, err := strconv.Atoi(v)
			if err != nil {
				c.JSON(http.StatusBadRequest, gin.H{"name": "ids", "value": v, "error": err.Error()})
				return
			}
			f.IDs = append(f.IDs, id)
		}
	}

	if vals, ok := c.GetQueryArray("report_reasons_ids"); ok {
		f.ReportReasonsIDs = make([]int, 0, len(vals))
		for _, v := range vals {
			id, err := strconv.Atoi(v)
			if err != nil {
				c.JSON(http.StatusBadRequest, gin.H{"name": "report_reasons_ids", "value": v, "error": err.Error()})
				return
			}
			f.ReportReasonsIDs = append(f.ReportReasonsIDs, id)
		}
	}

	if vals, ok := c.GetQueryArray("ad_equipment_ids"); ok {
		f.AdEquipmentIDs = make([]int, 0, len(vals))
		for _, v := range vals {
			id, err := strconv.Atoi(v)
			if err != nil {
				c.JSON(http.StatusBadRequest, gin.H{"name": "ad_equipment_ids", "value": v, "error": err.Error()})
				return
			}
			f.AdEquipmentIDs = append(f.AdEquipmentIDs, id)
		}
	}

	if vals, ok := c.GetQuery("limit"); ok {
		n, err := strconv.Atoi(vals)
		if err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"name": "limit", "error": err.Error()})
			return
		}
		f.Limit = &n
	}

	if vals, ok := c.GetQuery("offset"); ok {
		n, err := strconv.Atoi(vals)
		if err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"name": "offset", "error": err.Error()})
			return
		}
		f.Offset = &n
	}

	res, count, err := h.reportService.GetAdEquipments(c, f)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"reports": res, "count": count})
}

// @Summary	Получени жалоб на оборудование по идентификатору
// @Tags		Report (жалобы)
// @Accept		json
// @Produce	json
// @Param		id	path		int	true	"идентификатор"
// @Success	200	{object}	model.ReportAdEquipments
// @Failure	400	{object}	map[string]interface{}
// @Failure	404	{object}	map[string]interface{}
// @Failure	500	{object}	map[string]interface{}
// @Router		/report/ad/eq_client/{id} [get]
func (h *report) GetByIDAdEquipmentsClient(c *gin.Context) {
	id, err := strconv.Atoi(c.Param("id"))
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"name": "id", "error": err.Error()})
		return
	}

	res, err := h.reportService.GetByIDAdEquipments(c, id)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"report": res})
}

// @Summary	Удаление жалоб на оборудование по идентификатору
// @Summary	Только администратор может удалить
// @Tags		Report (жалобы)
// @Accept		json
// @Produce	json
// @Param		id	path		int	true	"идентификатор"
// @Success	200	{object}	map[string]interface{}
// @Failure	400	{object}	map[string]interface{}
// @Failure	404	{object}	map[string]interface{}
// @Failure	500	{object}	map[string]interface{}
// @Router		/report/ad/eq_client/{id} [delete]
func (h *report) DeleteAdEquipmentsClient(c *gin.Context) {
	id, err := strconv.Atoi(c.Param("id"))
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"name": "id", "error": err.Error()})
		return
	}

	err = h.reportService.DeleteAdEquipments(c, id)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"status": "success"})
}

// @Summary	Получени причин жалоб системы
// @Tags		Report (жалобы)
// @Accept		json
// @Produce	json
// @Success	200	{object}	model.ReportReasonSystem
// @Failure	400	{object}	map[string]interface{}
// @Failure	404	{object}	map[string]interface{}
// @Failure	500	{object}	map[string]interface{}
// @Router		/report/reasons/system [get]
func (h *report) GetReasonSystem(c *gin.Context) {
	res, err := h.reportService.GetReasonSystem(c)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"reason": res})
}

// @Summary		Получение жалоб на систему по идентификатору
// @Description	Только Авторизованный человек может сделать жалобу
// @Tags			Report (жалобы)
// @Accept			json
// @Produce		json
// @Param			user_detail					query		bool	true	"детали пользователя"
// @Param			report_reason_system_detail	query		bool	true	"детали причин жалобы"
// @Param			ids							query		int		true	"идентификатор запроса"
// @Param			user_id						query		int		true	"идентификатор пользователя"
// @Param			report_reason_system_id		query		int		true	"идентификатор причин жалобы"
// @Param			limit						query		int		true	"лимит"
// @Param			offset						query		int		true	"сдвиг"
// @Success		200							{object}	model.ReportSystem
// @Failure		400							{object}	map[string]interface{}
// @Failure		404							{object}	map[string]interface{}
// @Failure		500							{object}	map[string]interface{}
// @Router			/report/system [get]
func (h *report) GetSystem(c *gin.Context) {
	f := model.FilterReportSystem{}

	if vals, ok := c.GetQuery("user_detail"); ok {
		v, err := strconv.ParseBool(vals)
		if err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"name": "user_detail", "error": err.Error()})
			return
		}
		f.UserDetail = &v
	}

	if vals, ok := c.GetQuery("report_reason_system_detail"); ok {
		v, err := strconv.ParseBool(vals)
		if err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"name": "report_reason_system_detail", "error": err.Error()})
			return
		}
		f.ReportReasonSystemDetail = &v
	}

	if vals, ok := c.GetQueryArray("ids"); ok {
		f.ID = make([]int, 0, len(vals))
		for _, v := range vals {
			id, err := strconv.Atoi(v)
			if err != nil {
				c.JSON(http.StatusBadRequest, gin.H{"name": "ids", "value": v, "error": err.Error()})
				return
			}
			f.ID = append(f.ID, id)
		}
	}

	if vals, ok := c.GetQueryArray("user_id"); ok {
		f.UserID = make([]int, 0, len(vals))
		for _, v := range vals {
			id, err := strconv.Atoi(v)
			if err != nil {
				c.JSON(http.StatusBadRequest, gin.H{"name": "user_id", "value": v, "error": err.Error()})
				return
			}
			f.UserID = append(f.UserID, id)
		}
	}

	if vals, ok := c.GetQueryArray("report_reason_system_id"); ok {
		f.ReportReasonSystemID = make([]int, 0, len(vals))
		for _, v := range vals {
			id, err := strconv.Atoi(v)
			if err != nil {
				c.JSON(http.StatusBadRequest, gin.H{"name": "report_reason_system_id", "value": v, "error": err.Error()})
				return
			}
			f.ReportReasonSystemID = append(f.ReportReasonSystemID, id)
		}
	}

	if vals, ok := c.GetQuery("limit"); ok {
		n, err := strconv.Atoi(vals)
		if err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"name": "limit", "error": err.Error()})
			return
		}
		f.Limit = &n
	}

	if vals, ok := c.GetQuery("offset"); ok {
		n, err := strconv.Atoi(vals)
		if err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"name": "offset", "error": err.Error()})
			return
		}
		f.Offset = &n
	}

	res, count, err := h.reportService.GetSystem(c, f)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"reports": res, "count": count})
}

// @Summary		Получение жалоб на систему по идентификатору
// @Description	Только Авторизованный человек может сделать жалобу
// @Tags			Report (жалобы)
// @Accept			json
// @Produce		json
// @Param			id	path		int	true	"идентификатор запроса"
// @Success		200	{object}	model.ReportSystem
// @Failure		400	{object}	map[string]interface{}
// @Failure		404	{object}	map[string]interface{}
// @Failure		500	{object}	map[string]interface{}
// @Router			/report/system/{id} [get]
func (h *report) GetByIDSystem(c *gin.Context) {
	id, err := strconv.Atoi(c.Param("id"))
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"name": "id", "error": err.Error()})
		return
	}

	res, err := h.reportService.GetByIDSystem(c, id)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"reason": res})
}

// @Summary		Подача жалоб на систему
// @Description	Только Авторизованный человек может сделать жалобу
// @Tags			Report (жалобы)
// @Accept			json
// @Produce		json
// @Param			body	body		controller.CreateSystem.request	true	"описание запроса"
// @Success		200		{object}	map[string]interface{}
// @Failure		400		{object}	map[string]interface{}
// @Failure		404		{object}	map[string]interface{}
// @Failure		500		{object}	map[string]interface{}
// @Router			/report/system [post]
func (h *report) CreateSystem(c *gin.Context) {
	user, err := GetUserFromGin(c)
	if err != nil {
		c.JSON(http.StatusUnauthorized, gin.H{"error": err.Error()})
		return
	}

	type request struct {
		ReportReasonSystemID int    `json:"report_reason_system_id"`
		Description          string `json:"description"`
	}

	r := request{}

	if err := c.BindJSON(&r); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	err = h.reportService.CreateSystem(c, model.ReportSystem{
		UserID:               user.ID,
		ReportReasonSystemID: r.ReportReasonSystemID,
		Description:          r.Description,
	})
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"status": "success"})
}

// @Summary		Удалени жалоб на систему
// @Description	Только админ человек может сделать жалобу
// @Tags			Report (жалобы)
// @Accept			json
// @Produce		json
// @Param			id	path		int	true	"идентификатор запроса"
// @Success		200	{object}	map[string]interface{}
// @Failure		400	{object}	map[string]interface{}
// @Failure		404	{object}	map[string]interface{}
// @Failure		500	{object}	map[string]interface{}
// @Router			/report/system/{id} [delete]
func (h *report) DeleteSystem(c *gin.Context) {
	id, err := strconv.Atoi(c.Param("id"))
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"name": "id", "error": err.Error()})
		return
	}

	err = h.reportService.DeleteSystem(c, id)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"status": "success"})
}

// GetAdConstructionMaterial
// @Summary	Получение жалоб на строй материалы
// @Tags		Report (жалобы)
// @Accept		json
// @Produce	json
// @Param		report_reasons_detail						query		bool	false	"получение деталей о причине жалобы"
// @Param		ad_construction_material_detail				query		bool	false	"получение деталей о объявления строй материалов"
// @Param		ad_construction_material_document_detail	query		bool	false	"получение фотографии в объявление строй материалов"
// @Param		ids											query		int		false	"фильтр по идентификатору, можно несколько раз"
// @Param		report_reasons_ids							query		int		false	"фильтр по идентификатору причин жалобы, можно несколько раз"
// @Param		ad_construction_material_ids				query		int		false	"фильтр по идентификатору объявление строй материалов, можно несколько раз"
// @Param		limit										query		int		false	"лимит"
// @Param		offset										query		int		false	"сдвиг"
// @Success	200											{object}	[]model.ReportAdConstructionMaterials
// @Failure	400											{object}	map[string]interface{}
// @Failure	404											{object}	map[string]interface{}
// @Failure	500											{object}	map[string]interface{}
// @Router		/report/ad/cm [get]
func (h *report) GetAdConstructionMaterial(c *gin.Context) {
	f := model.FilterReportAdConstructionMaterials{}

	if vals, ok := c.GetQuery("report_reasons_detail"); ok {
		v, err := strconv.ParseBool(vals)
		if err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"name": "report_reasons_detail", "error": err.Error()})
			return
		}
		f.ReportReasonsDetail = &v
	}

	if vals, ok := c.GetQuery("ad_construction_material_detail"); ok {
		v, err := strconv.ParseBool(vals)
		if err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"name": "ad_construction_material_detail", "error": err.Error()})
			return
		}
		f.AdConstructionMaterialDetail = &v
	}

	if vals, ok := c.GetQuery("ad_construction_material_document_detail"); ok {
		v, err := strconv.ParseBool(vals)
		if err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"name": "ad_construction_material_document_detail", "error": err.Error()})
			return
		}
		f.AdConstructionMaterialDocumentDetail = &v
	}

	if vals, ok := c.GetQueryArray("ids"); ok {
		f.IDs = make([]int, 0, len(vals))
		for _, v := range vals {
			id, err := strconv.Atoi(v)
			if err != nil {
				c.JSON(http.StatusBadRequest, gin.H{"name": "ids", "value": v, "error": err.Error()})
				return
			}
			f.IDs = append(f.IDs, id)
		}
	}

	if vals, ok := c.GetQueryArray("report_reasons_ids"); ok {
		f.ReportReasonsIDs = make([]int, 0, len(vals))
		for _, v := range vals {
			id, err := strconv.Atoi(v)
			if err != nil {
				c.JSON(http.StatusBadRequest, gin.H{"name": "report_reasons_ids", "value": v, "error": err.Error()})
				return
			}
			f.ReportReasonsIDs = append(f.ReportReasonsIDs, id)
		}
	}

	if vals, ok := c.GetQueryArray("ad_construction_material_ids"); ok {
		f.AdConstructionMaterialIDs = make([]int, 0, len(vals))
		for _, v := range vals {
			id, err := strconv.Atoi(v)
			if err != nil {
				c.JSON(http.StatusBadRequest, gin.H{"name": "ad_construction_material_ids", "value": v, "error": err.Error()})
				return
			}
			f.AdConstructionMaterialIDs = append(f.AdConstructionMaterialIDs, id)
		}
	}

	if vals, ok := c.GetQuery("limit"); ok {
		n, err := strconv.Atoi(vals)
		if err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"name": "limit", "error": err.Error()})
			return
		}
		f.Limit = &n
	}

	if vals, ok := c.GetQuery("offset"); ok {
		n, err := strconv.Atoi(vals)
		if err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"name": "offset", "error": err.Error()})
			return
		}
		f.Offset = &n
	}

	res, count, err := h.reportService.GetAdConstructionMaterials(c, f)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"reports": res, "count": count})
}

// GetByIDAdConstructionMaterial
// @Summary	Получение жалоб на строй материалы по идентификатору
// @Tags		Report (жалобы)
// @Accept		json
// @Produce	json
// @Param		id	path		int	true	"идентификатор"
// @Success	200	{object}	model.ReportAdConstructionMaterials
// @Failure	400	{object}	map[string]interface{}
// @Failure	404	{object}	map[string]interface{}
// @Failure	500	{object}	map[string]interface{}
// @Router		/report/ad/cm/{id} [get]
func (h *report) GetByIDAdConstructionMaterial(c *gin.Context) {
	id, err := strconv.Atoi(c.Param("id"))
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"name": "id", "error": err.Error()})
		return
	}

	res, err := h.reportService.GetByIDAdConstructionMaterials(c, id)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"report": res})
}

// CreateAdConstructionMaterials
// @Summary	Подача жалоб на строй материалы
// @Summary	Только Авторизованный человек может сделать жалобу
// @Tags		Report (жалобы)
// @Accept		json
// @Produce	json
// @Param		body	body		controller.CreateAdConstructionMaterials.request	true	"описание запроса"
// @Success	200		{object}	map[string]interface{}
// @Failure	400		{object}	map[string]interface{}
// @Failure	404		{object}	map[string]interface{}
// @Failure	500		{object}	map[string]interface{}
// @Router		/report/ad/cm [post]
func (h *report) CreateAdConstructionMaterials(c *gin.Context) {
	user, err := GetUserFromGin(c)
	if err != nil {
		c.JSON(http.StatusUnauthorized, gin.H{"error": err.Error()})
		return
	}

	type request struct {
		ReportReasonsID          int    `json:"report_reasons_id"`
		AdConstructionMaterialID int    `json:"ad_construction_material_id"`
		Description              string `json:"description"`
	}

	r := request{}

	if err := c.BindJSON(&r); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	err = h.reportService.CreateAdConstructionMaterials(c, model.ReportAdConstructionMaterials{
		UserID:                   user.ID,
		ReportReasonsID:          r.ReportReasonsID,
		AdConstructionMaterialID: r.AdConstructionMaterialID,
		Description:              r.Description,
	})
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"status": "success"})
}

// DeleteAdConstructionMaterials
// @Summary	Удаление жалоб на строй материалы по идентификатору
// @Summary	Только администратор может удалить
// @Tags		Report (жалобы)
// @Accept		json
// @Produce	json
// @Param		id	path		int	true	"идентификатор"
// @Success	200	{object}	map[string]interface{}
// @Failure	400	{object}	map[string]interface{}
// @Failure	404	{object}	map[string]interface{}
// @Failure	500	{object}	map[string]interface{}
// @Router		/report/ad/cm/{id} [delete]
func (h *report) DeleteAdConstructionMaterials(c *gin.Context) {
	id, err := strconv.Atoi(c.Param("id"))
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"name": "id", "error": err.Error()})
		return
	}

	err = h.reportService.DeleteAdConstructionMaterials(c, id)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"status": "success"})
}

// GetAdService
// @Summary	Получение жалоб на строй материалы
// @Tags		Report (жалобы)
// @Accept		json
// @Produce	json
// @Param		report_reasons_detail						query		bool	false	"получение деталей о причине жалобы"
// @Param		ad_service_detail				query		bool	false	"получение деталей о объявления строй материалов"
// @Param		ad_service_document_detail	query		bool	false	"получение фотографии в объявление строй материалов"
// @Param		ids											query		int		false	"фильтр по идентификатору, можно несколько раз"
// @Param		report_reasons_ids							query		int		false	"фильтр по идентификатору причин жалобы, можно несколько раз"
// @Param		ad_service_ids				query		int		false	"фильтр по идентификатору объявление строй материалов, можно несколько раз"
// @Param		limit										query		int		false	"лимит"
// @Param		offset										query		int		false	"сдвиг"
// @Success	200											{object}	[]model.ReportAdServices
// @Failure	400											{object}	map[string]interface{}
// @Failure	404											{object}	map[string]interface{}
// @Failure	500											{object}	map[string]interface{}
// @Router		/report/ad/svc [get]
func (h *report) GetAdService(c *gin.Context) {
	f := model.FilterReportAdServices{}

	if vals, ok := c.GetQuery("report_reasons_detail"); ok {
		v, err := strconv.ParseBool(vals)
		if err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"name": "report_reasons_detail", "error": err.Error()})
			return
		}
		f.ReportReasonsDetail = &v
	}

	if vals, ok := c.GetQuery("ad_service_detail"); ok {
		v, err := strconv.ParseBool(vals)
		if err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"name": "ad_service_detail", "error": err.Error()})
			return
		}
		f.AdServiceDetail = &v
	}

	if vals, ok := c.GetQuery("ad_service_document_detail"); ok {
		v, err := strconv.ParseBool(vals)
		if err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"name": "ad_service_document_detail", "error": err.Error()})
			return
		}
		f.AdServiceDocumentDetail = &v
	}

	if vals, ok := c.GetQueryArray("ids"); ok {
		f.IDs = make([]int, 0, len(vals))
		for _, v := range vals {
			id, err := strconv.Atoi(v)
			if err != nil {
				c.JSON(http.StatusBadRequest, gin.H{"name": "ids", "value": v, "error": err.Error()})
				return
			}
			f.IDs = append(f.IDs, id)
		}
	}

	if vals, ok := c.GetQueryArray("report_reasons_ids"); ok {
		f.ReportReasonsIDs = make([]int, 0, len(vals))
		for _, v := range vals {
			id, err := strconv.Atoi(v)
			if err != nil {
				c.JSON(http.StatusBadRequest, gin.H{"name": "report_reasons_ids", "value": v, "error": err.Error()})
				return
			}
			f.ReportReasonsIDs = append(f.ReportReasonsIDs, id)
		}
	}

	if vals, ok := c.GetQueryArray("ad_service_ids"); ok {
		f.AdServiceIDs = make([]int, 0, len(vals))
		for _, v := range vals {
			id, err := strconv.Atoi(v)
			if err != nil {
				c.JSON(http.StatusBadRequest, gin.H{"name": "ad_service_ids", "value": v, "error": err.Error()})
				return
			}
			f.AdServiceIDs = append(f.AdServiceIDs, id)
		}
	}

	if vals, ok := c.GetQuery("limit"); ok {
		n, err := strconv.Atoi(vals)
		if err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"name": "limit", "error": err.Error()})
			return
		}
		f.Limit = &n
	}

	if vals, ok := c.GetQuery("offset"); ok {
		n, err := strconv.Atoi(vals)
		if err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"name": "offset", "error": err.Error()})
			return
		}
		f.Offset = &n
	}

	res, count, err := h.reportService.GetAdServices(c, f)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"reports": res, "count": count})
}

// GetByIDAdService
// @Summary	Получение жалоб на строй материалы по идентификатору
// @Tags		Report (жалобы)
// @Accept		json
// @Produce	json
// @Param		id	path		int	true	"идентификатор"
// @Success	200	{object}	model.ReportAdServices
// @Failure	400	{object}	map[string]interface{}
// @Failure	404	{object}	map[string]interface{}
// @Failure	500	{object}	map[string]interface{}
// @Router		/report/ad/svc/{id} [get]
func (h *report) GetByIDAdService(c *gin.Context) {
	id, err := strconv.Atoi(c.Param("id"))
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"name": "id", "error": err.Error()})
		return
	}

	res, err := h.reportService.GetByIDAdServices(c, id)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"report": res})
}

// CreateAdServices
// @Summary	Подача жалоб на строй материалы
// @Summary	Только Авторизованный человек может сделать жалобу
// @Tags		Report (жалобы)
// @Accept		json
// @Produce	json
// @Param		body	body		controller.CreateAdServices.request	true	"описание запроса"
// @Success	200		{object}	map[string]interface{}
// @Failure	400		{object}	map[string]interface{}
// @Failure	404		{object}	map[string]interface{}
// @Failure	500		{object}	map[string]interface{}
// @Router		/report/ad/svc [post]
func (h *report) CreateAdServices(c *gin.Context) {
	user, err := GetUserFromGin(c)
	if err != nil {
		c.JSON(http.StatusUnauthorized, gin.H{"error": err.Error()})
		return
	}

	type request struct {
		ReportReasonsID int    `json:"report_reasons_id"`
		AdServiceID     int    `json:"ad_service_id"`
		Description     string `json:"description"`
	}

	r := request{}

	if err := c.BindJSON(&r); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	err = h.reportService.CreateAdServices(c, model.ReportAdServices{
		UserID:          user.ID,
		ReportReasonsID: r.ReportReasonsID,
		AdServiceID:     r.AdServiceID,
		Description:     r.Description,
	})
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"status": "success"})
}

// DeleteAdServices
// @Summary	Удаление жалоб на строй материалы по идентификатору
// @Summary	Только администратор может удалить
// @Tags		Report (жалобы)
// @Accept		json
// @Produce	json
// @Param		id	path		int	true	"идентификатор"
// @Success	200	{object}	map[string]interface{}
// @Failure	400	{object}	map[string]interface{}
// @Failure	404	{object}	map[string]interface{}
// @Failure	500	{object}	map[string]interface{}
// @Router		/report/ad/svc/{id} [delete]
func (h *report) DeleteAdServices(c *gin.Context) {
	id, err := strconv.Atoi(c.Param("id"))
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"name": "id", "error": err.Error()})
		return
	}

	err = h.reportService.DeleteAdServices(c, id)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"status": "success"})
}

// GetAdConstructionMaterialsClient
// @Summary	Получение жалоб на строй материалы клиента
// @Tags		Report (жалобы)
// @Accept		json
// @Produce	json
// @Param		report_reasons_detail			query		bool	false	"получение деталей о причине жалобы"
// @Param		ad_construction_material_detail				query		bool	false	"получение деталей о объявления строй материалы"
// @Param		ad_construction_material_document_detail	query		bool	false	"получение фотографии в объявлени строй материалы"
// @Param		ids								query		int		false	"фильтр по идентификатору, можно несколько раз"
// @Param		report_reasons_ids				query		int		false	"фильтр по идентификатору причин жалобы, можно несколько раз"
// @Param		ad_construction_material_ids				query		int		false	"фильтр по идентификатору объявлени строй материалы, можно несколько раз"
// @Param		limit							query		int		false	"лимит"
// @Param		offset							query		int		false	"сдвиг"
// @Success	200								{object}	[]model.ReportAdConstructionMaterialClient
// @Failure	400								{object}	map[string]interface{}
// @Failure	404								{object}	map[string]interface{}
// @Failure	500								{object}	map[string]interface{}
// @Router		/report/ad/cm_client [get]
func (h *report) GetAdConstructionMaterialsClient(c *gin.Context) {
	f := model.FilterReportAdConstructionMaterialsClient{}

	if vals, ok := c.GetQuery("report_reasons_detail"); ok {
		v, err := strconv.ParseBool(vals)
		if err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"name": "report_reasons_detail", "error": err.Error()})
			return
		}
		f.ReportReasonsDetail = &v
	}

	if vals, ok := c.GetQuery("ad_construction_material_detail"); ok {
		v, err := strconv.ParseBool(vals)
		if err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"name": "ad_construction_material_detail", "error": err.Error()})
			return
		}
		f.AdConstructionMaterialClientDetail = &v
	}

	if vals, ok := c.GetQuery("ad_construction_material_document_detail"); ok {
		v, err := strconv.ParseBool(vals)
		if err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"name": "ad_construction_material_document_detail", "error": err.Error()})
			return
		}
		f.AdConstructionMaterialClientDetail = &v
	}

	if vals, ok := c.GetQueryArray("ids"); ok {
		f.IDs = make([]int, 0, len(vals))
		for _, v := range vals {
			id, err := strconv.Atoi(v)
			if err != nil {
				c.JSON(http.StatusBadRequest, gin.H{"name": "ids", "value": v, "error": err.Error()})
				return
			}
			f.IDs = append(f.IDs, id)
		}
	}

	if vals, ok := c.GetQueryArray("report_reasons_ids"); ok {
		f.ReportReasonsIDs = make([]int, 0, len(vals))
		for _, v := range vals {
			id, err := strconv.Atoi(v)
			if err != nil {
				c.JSON(http.StatusBadRequest, gin.H{"name": "report_reasons_ids", "value": v, "error": err.Error()})
				return
			}
			f.ReportReasonsIDs = append(f.ReportReasonsIDs, id)
		}
	}

	if vals, ok := c.GetQueryArray("ad_construction_material_ids"); ok {
		f.AdConstructionMaterialClientIDs = make([]int, 0, len(vals))
		for _, v := range vals {
			id, err := strconv.Atoi(v)
			if err != nil {
				c.JSON(http.StatusBadRequest, gin.H{"name": "ad_construction_material_ids", "value": v, "error": err.Error()})
				return
			}
			f.AdConstructionMaterialClientIDs = append(f.AdConstructionMaterialClientIDs, id)
		}
	}

	if vals, ok := c.GetQuery("limit"); ok {
		n, err := strconv.Atoi(vals)
		if err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"name": "limit", "error": err.Error()})
			return
		}
		f.Limit = &n
	}

	if vals, ok := c.GetQuery("offset"); ok {
		n, err := strconv.Atoi(vals)
		if err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"name": "offset", "error": err.Error()})
			return
		}
		f.Offset = &n
	}

	res, count, err := h.reportService.GetAdConstructionMaterialsClient(c, f)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"reports": res, "count": count})
}

// GetByIDAdConstructionMaterialsClient
// @Summary	Получени жалоб на строй материалы по идентификатору
// @Tags		Report (жалобы)
// @Accept		json
// @Produce	json
// @Param		id	path		int	true	"идентификатор"
// @Success	200	{object}	model.ReportAdConstructionMaterialClient
// @Failure	400	{object}	map[string]interface{}
// @Failure	404	{object}	map[string]interface{}
// @Failure	500	{object}	map[string]interface{}
// @Router		/report/ad/cm_client/{id} [get]
func (h *report) GetByIDAdConstructionMaterialsClient(c *gin.Context) {
	id, err := strconv.Atoi(c.Param("id"))
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"name": "id", "error": err.Error()})
		return
	}

	res, err := h.reportService.GetByIDAdConstructionMaterialsClient(c, id)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"report": res})
}

// DeleteAdConstructionMaterialsClient
// @Summary	Удаление жалоб на строй материалы по идентификатору
// @Summary	Только администратор может удалить
// @Tags		Report (жалобы)
// @Accept		json
// @Produce	json
// @Param		id	path		int	true	"идентификатор"
// @Success	200	{object}	map[string]interface{}
// @Failure	400	{object}	map[string]interface{}
// @Failure	404	{object}	map[string]interface{}
// @Failure	500	{object}	map[string]interface{}
// @Router		/report/ad/cm_client/{id} [delete]
func (h *report) DeleteAdConstructionMaterialsClient(c *gin.Context) {
	id, err := strconv.Atoi(c.Param("id"))
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"name": "id", "error": err.Error()})
		return
	}

	err = h.reportService.DeleteAdConstructionMaterialsClient(c, id)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"status": "success"})
}

// GetAdServicesClient
// @Summary	Получени жалоб на услуги клиента
// @Tags		Report (жалобы)
// @Accept		json
// @Produce	json
// @Param		report_reasons_detail			query		bool	false	"получение деталей о причине жалобы"
// @Param		ad_service_detail				query		bool	false	"получение деталей о объявления услуги"
// @Param		ad_service_document_detail	query		bool	false	"получение фотографии в объявлени услуги"
// @Param		ids								query		int		false	"фильтр по идентификатору, можно несколько раз"
// @Param		report_reasons_ids				query		int		false	"фильтр по идентификатору причин жалобы, можно несколько раз"
// @Param		ad_service_ids				query		int		false	"фильтр по идентификатору объявлени услуги, можно несколько раз"
// @Param		limit							query		int		false	"лимит"
// @Param		offset							query		int		false	"сдвиг"
// @Success	200								{object}	[]model.ReportAdServiceClient
// @Failure	400								{object}	map[string]interface{}
// @Failure	404								{object}	map[string]interface{}
// @Failure	500								{object}	map[string]interface{}
// @Router		/report/ad/svc_client [get]
func (h *report) GetAdServicesClient(c *gin.Context) {
	f := model.FilterReportAdServicesClient{}

	if vals, ok := c.GetQuery("report_reasons_detail"); ok {
		v, err := strconv.ParseBool(vals)
		if err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"name": "report_reasons_detail", "error": err.Error()})
			return
		}
		f.ReportReasonsDetail = &v
	}

	if vals, ok := c.GetQuery("ad_service_detail"); ok {
		v, err := strconv.ParseBool(vals)
		if err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"name": "ad_service_detail", "error": err.Error()})
			return
		}
		f.AdServiceClientDetail = &v
	}

	if vals, ok := c.GetQuery("ad_service_document_detail"); ok {
		v, err := strconv.ParseBool(vals)
		if err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"name": "ad_service_document_detail", "error": err.Error()})
			return
		}
		f.AdServiceClientDocumentDetail = &v
	}

	if vals, ok := c.GetQueryArray("ids"); ok {
		f.IDs = make([]int, 0, len(vals))
		for _, v := range vals {
			id, err := strconv.Atoi(v)
			if err != nil {
				c.JSON(http.StatusBadRequest, gin.H{"name": "ids", "value": v, "error": err.Error()})
				return
			}
			f.IDs = append(f.IDs, id)
		}
	}

	if vals, ok := c.GetQueryArray("report_reasons_ids"); ok {
		f.ReportReasonsIDs = make([]int, 0, len(vals))
		for _, v := range vals {
			id, err := strconv.Atoi(v)
			if err != nil {
				c.JSON(http.StatusBadRequest, gin.H{"name": "report_reasons_ids", "value": v, "error": err.Error()})
				return
			}
			f.ReportReasonsIDs = append(f.ReportReasonsIDs, id)
		}
	}

	if vals, ok := c.GetQueryArray("ad_service_ids"); ok {
		f.AdServiceClientIDs = make([]int, 0, len(vals))
		for _, v := range vals {
			id, err := strconv.Atoi(v)
			if err != nil {
				c.JSON(http.StatusBadRequest, gin.H{"name": "ad_service_ids", "value": v, "error": err.Error()})
				return
			}
			f.AdServiceClientIDs = append(f.AdServiceClientIDs, id)
		}
	}

	if vals, ok := c.GetQuery("limit"); ok {
		n, err := strconv.Atoi(vals)
		if err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"name": "limit", "error": err.Error()})
			return
		}
		f.Limit = &n
	}

	if vals, ok := c.GetQuery("offset"); ok {
		n, err := strconv.Atoi(vals)
		if err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"name": "offset", "error": err.Error()})
			return
		}
		f.Offset = &n
	}

	res, count, err := h.reportService.GetAdServicesClient(c, f)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"reports": res, "count": count})
}

// GetByIDAdServicesClient
// @Summary	Получени жалоб на услуги по идентификатору
// @Tags		Report (жалобы)
// @Accept		json
// @Produce	json
// @Param		id	path		int	true	"идентификатор"
// @Success	200	{object}	model.ReportAdServiceClient
// @Failure	400	{object}	map[string]interface{}
// @Failure	404	{object}	map[string]interface{}
// @Failure	500	{object}	map[string]interface{}
// @Router		/report/ad/svc_client/{id} [get]
func (h *report) GetByIDAdServicesClient(c *gin.Context) {
	id, err := strconv.Atoi(c.Param("id"))
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"name": "id", "error": err.Error()})
		return
	}

	res, err := h.reportService.GetByIDAdServicesClient(c, id)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"report": res})
}

// DeleteAdServicesClient
// @Summary	Удаление жалоб на услуг по идентификатору
// @Summary	Только администратор может удалить
// @Tags		Report (жалобы)
// @Accept		json
// @Produce	json
// @Param		id	path		int	true	"идентификатор"
// @Success	200	{object}	map[string]interface{}
// @Failure	400	{object}	map[string]interface{}
// @Failure	404	{object}	map[string]interface{}
// @Failure	500	{object}	map[string]interface{}
// @Router		/report/ad/svc_client/{id} [delete]
func (h *report) DeleteAdServicesClient(c *gin.Context) {
	id, err := strconv.Atoi(c.Param("id"))
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"name": "id", "error": err.Error()})
		return
	}

	err = h.reportService.DeleteAdServicesClient(c, id)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"status": "success"})
}

// CreateAdServicesClient
// @Summary	Подача жалоб на услуги клиенита
// @Summary	Только Авторизованный человек может сделать жалобу
// @Tags		Report (жалобы)
// @Accept		json
// @Produce	json
// @Param		body	body		controller.CreateAdServicesClient.request	true	"описание запроса"
// @Success	200		{object}	map[string]interface{}
// @Failure	400		{object}	map[string]interface{}
// @Failure	404		{object}	map[string]interface{}
// @Failure	500		{object}	map[string]interface{}
// @Router		/report/ad/svc_client [post]
func (h *report) CreateAdServicesClient(c *gin.Context) {
	user, err := GetUserFromGin(c)
	if err != nil {
		c.JSON(http.StatusUnauthorized, gin.H{"error": err.Error()})
		return
	}

	type request struct {
		ReportReasonsID   int    `json:"report_reasons_id"`
		AdServiceClientID int    `json:"ad_service_client_id"`
		Description       string `json:"description"`
	}

	r := request{}

	if err := c.BindJSON(&r); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	err = h.reportService.CreateAdServicesClient(c, model.ReportAdServiceClient{
		UserID:            user.ID,
		ReportReasonsID:   r.ReportReasonsID,
		AdServiceClientID: r.AdServiceClientID,
		Description:       r.Description,
	})
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"status": "success"})
}

// CreateAdConstructionMaterialsClient
// @Summary	Подача жалоб на строй материалы  клиенита
// @Summary	Только Авторизованный человек может сделать жалобу
// @Tags		Report (жалобы)
// @Accept		json
// @Produce	json
// @Param		body	body		controller.CreateAdConstructionMaterialsClient.request	true	"описание запроса"
// @Success	200		{object}	map[string]interface{}
// @Failure	400		{object}	map[string]interface{}
// @Failure	404		{object}	map[string]interface{}
// @Failure	500		{object}	map[string]interface{}
// @Router		/report/ad/cm_client [post]
func (h *report) CreateAdConstructionMaterialsClient(c *gin.Context) {
	user, err := GetUserFromGin(c)
	if err != nil {
		c.JSON(http.StatusUnauthorized, gin.H{"error": err.Error()})
		return
	}

	type request struct {
		ReportReasonsID                int    `json:"report_reasons_id"`
		AdConstructionMaterialClientID int    `json:"ad_construction_material_client_id"`
		Description                    string `json:"description"`
	}

	r := request{}

	if err := c.BindJSON(&r); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	err = h.reportService.CreateAdConstructionMaterialsClient(c, model.ReportAdConstructionMaterialClient{
		UserID:                         user.ID,
		ReportReasonsID:                r.ReportReasonsID,
		AdConstructionMaterialClientID: r.AdConstructionMaterialClientID,
		Description:                    r.Description,
	})
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"status": "success"})
}
