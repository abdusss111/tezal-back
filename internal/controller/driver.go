package controller

import (
	"encoding/json"
	"fmt"
	"net/http"
	"strconv"

	"github.com/gin-gonic/gin"
	"github.com/sirupsen/logrus"
	"gitlab.com/eqshare/eqshare-back/internal/service"
	"gitlab.com/eqshare/eqshare-back/model"
	"gitlab.com/eqshare/eqshare-back/pkg/util"
)

type driver struct {
	dService     service.IDriver
	uService     service.IUser
	authService  service.IAuthentication
	ownerService service.IOwner
	dMoveService service.IDriverMoveService
}

func NewDriver(c *gin.Engine, dService service.IDriver, uService service.IUser, authService service.IAuthentication, ownerService service.IOwner, dMoveService service.IDriverMoveService) {
	handler := &driver{
		dService:     dService,
		uService:     uService,
		authService:  authService,
		ownerService: ownerService,
		dMoveService: dMoveService,
	}

	d := c.Group("/driver")

	d.POST("/", authorize(authService, model.ROLE_CLIENT, model.ROLE_ADMIN, model.ROLE_DRIVER), handler.driverAuth)
	d.GET("/:docID", authorize(authService, model.ROLE_CLIENT, model.ROLE_ADMIN, model.ROLE_DRIVER), handler.readDocument)
	d.PUT("/", authorize(authService, model.ROLE_CLIENT, model.ROLE_ADMIN, model.ROLE_DRIVER), handler.updateDocument)
	d.DELETE("/:docID", authorize(authService, model.ROLE_CLIENT, model.ROLE_ADMIN, model.ROLE_DRIVER), handler.deleteDocument)
	d.DELETE("/quit_owner", authorize(authService, model.ROLE_ADMIN, model.ROLE_DRIVER), handler.quitOwner)
	d.POST("/location_status", authorize(authService, model.ROLE_ADMIN, model.ROLE_DRIVER), handler.UpdateLocationSharingStatus)
	d.GET("/location_status", authorize(authService, model.ROLE_ADMIN, model.ROLE_DRIVER), handler.GetLocationSharingStatus)
	d.POST("/driver/respond/:id", authorize(authService, model.ROLE_ADMIN, model.ROLE_DRIVER), handler.RespondToAddWorkerRequest)
}

// @Summary		Для авторизации в качестве водителя необходимо предоставить соответствующие документы и пройти процедуру проверки
// @Description	Водительское удостоверение и другие необходимые документы для подтверждения вашей квалификации.
// @Description	После успешной авторизации вы сможете получить доступ к услугам и функциям, доступным водителям.
// @Description	'Если админ авторизовывает пользователя как водитель тогда требуется передать id выбранного пользователя в URL REQUEST'.
// @Accept			multipart/form-data
// @Produce		json
// @Tags			Driver (водитель спецтехники)
// @Param			Authorization	header		string					true	"приставка `Bearer` с пробелом и сам токен"
// @Param			file			formData	file					true	"driver license photos"
// @Param			Driver			formData	model.Document			true	"тело водителя спецтехники"
// @Param			user_id			path		int						false	"ID пользователя, авторизующего в роли администратора для роли водителя"
// @Success		200				{object}	map[string]interface{}	"success"
// @Failure		403				{object}	map[string]interface{}
// @Failure		400,404			{object}	map[string]interface{}
// @Failure		500				{object}	map[string]interface{}
// @Failure		default			{object}	map[string]interface{}
// @Router			/driver [post]
func (h *driver) driverAuth(ctx *gin.Context) {
	var user model.User

	formData, err := ctx.MultipartForm()
	if err != nil {
		ctx.JSON(http.StatusBadRequest, gin.H{"reason": fmt.Sprintf("invalid input error: %s", err.Error())})
		return
	}

	user, err = GetUserFromGin(ctx)
	if err != nil {
		ctx.JSON(http.StatusInternalServerError, gin.H{"reason": fmt.Sprintf("server error: %s", err.Error())})
		return
	}

	if user.AccessRole == model.ROLE_ADMIN {
		user.ID, _ = strconv.Atoi(ctx.Query("user_id"))
		user, err = h.uService.GetByID(user.ID)
		if err != nil {
			ctx.JSON(http.StatusBadRequest, gin.H{"reason": fmt.Sprintf("invalid input error: %s", err.Error())})
			return
		}
	}

	user, err = util.FormDataParse(user, formData)
	if err != nil {
		ctx.JSON(http.StatusBadRequest, gin.H{"reason": fmt.Sprintf("invalid input error: %s", err.Error())})
		return
	}

	if err = h.dService.DriverAuth(ctx, user); err != nil {
		ctx.JSON(http.StatusInternalServerError, gin.H{"reason": err.Error()})
		return
	}

	ctx.JSON(http.StatusOK, gin.H{"reason": "authorized as a driver successfully!"})
}

func (h *driver) readDocument(ctx *gin.Context) {
	docIDStr := ctx.Param("docID")
	userStr := ctx.GetHeader(gin.AuthUserKey)
	var user model.User
	err := json.Unmarshal([]byte(userStr), &user)
	if err != nil {
		fmt.Println("Ошибка при распарсивании JSON:", err)
		return
	}

	_, download := ctx.GetQuery("download")

	docID, _ := strconv.ParseUint(docIDStr, 10, 64)
	document := model.Document{ID: int(docID), UserID: user.ID}

	stored, err := h.dService.GetDriverDocument(ctx, document, download)
	if err != nil {
		logrus.Errorf("[service error] - %+v", err)
		ctx.JSON(http.StatusInternalServerError, gin.H{"reason": err.Error()})
		return
	}

	if download {
		ctx.Header("Content-Disposition", fmt.Sprintf("attachment; filename=%s", stored.Title+stored.Extension))
		ctx.Data(http.StatusOK, "application/octet-stream", stored.ResponseContent)
		return
	}

	ctx.JSON(http.StatusOK, stored)
}

func (h *driver) updateDocument(ctx *gin.Context) {
	userStr := ctx.GetHeader(gin.AuthUserKey)
	var user model.User
	err := json.Unmarshal([]byte(userStr), &user)
	if err != nil {
		fmt.Println("Ошибка при распарсивании JSON:", err)
		return
	}

	var doc model.Document
	if err := ctx.ShouldBind(&doc); err != nil {
		logrus.Errorf("[validaton error] - %+v", err)
		ctx.JSON(http.StatusBadRequest, gin.H{"reason": err.Error()})
		return
	}

	doc.UserID = user.ID

	updated, err := h.dService.UpdateDriverDocument(ctx, doc)
	if err != nil {
		logrus.Errorf("[service error] - %+v", err)
		ctx.JSON(http.StatusInternalServerError, gin.H{"reason": err.Error()})
		return
	}

	ctx.JSON(http.StatusOK, updated)
}

func (h *driver) deleteDocument(ctx *gin.Context) {
	docIDStr := ctx.Param("docID")
	userStr := ctx.GetHeader(gin.AuthUserKey)
	var user model.User
	err := json.Unmarshal([]byte(userStr), &user)
	if err != nil {
		fmt.Println("Ошибка при распарсивании JSON:", err)
		return
	}

	docID, _ := strconv.ParseUint(docIDStr, 10, 64)
	document := model.Document{ID: int(docID), UserID: user.ID}

	deleted, err := h.dService.DeleteDriverDocument(ctx, document)
	if err != nil {
		logrus.Errorf("[service error] - %+v", err)
		ctx.JSON(http.StatusInternalServerError, gin.H{"reason": err.Error()})
		return
	}

	ctx.JSON(http.StatusOK, deleted)
}

// @Summary		Уволиться от владельца.
// @Description	Водитель освобождается от владельца.
// @Accept			json
// @Produce		json
// @Tags			Owner
// @Param			Authorization	header		string	true	"`водитель` приставка `Bearer` с пробелом и сам токен"
// @Success		200				{object}	map[string]interface{}
// @Failure		403				{object}	map[string]interface{}
// @Failure		400,404			{object}	map[string]interface{}
// @Failure		500				{object}	map[string]interface{}
// @Failure		default			{object}	map[string]interface{}
// @Router			/quit_owner [delete]
func (h *driver) quitOwner(ctx *gin.Context) {
	user, err := GetUserFromGin(ctx)
	if err != nil {
		ctx.JSON(http.StatusInternalServerError, gin.H{"reason": err.Error()})
		return
	}

	if err := h.ownerService.DeleteWorker(*user.OwnerID, user.ID); err != nil {
		ctx.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	ctx.JSON(http.StatusOK, gin.H{"status": "success"})
}

// UpdateLocationSharingStatus @Summary	Обновление статуса геолокации водителя.
// @Description	true значит включить, false выключить.
// @Accept			multipart/form-data
// @Produce		json
// @Tags			Driver (водитель спецтехники)
// @Param			Authorization	header		string					true	"приставка `Bearer` с пробелом и токен водителя"
// @Param			is_enabled	header		bool					true	"Статус геолокации. Для выключения false, для включения true"
// @Success		200				{object}	map[string]interface{}	"success"
// @Failure		403				{object}	map[string]interface{}
// @Failure		400,404			{object}	map[string]interface{}
// @Failure		500				{object}	map[string]interface{}
// @Failure		default			{object}	map[string]interface{}
// @Router			/location_status [post]
func (a *driver) UpdateLocationSharingStatus(c *gin.Context) {
	user, err := GetUserFromGin(c)
	if err != nil {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "Unauthorized"})
		return
	}

	var req struct {
		IsEnabled bool `json:"is_enabled"`
	}

	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid JSON"})
		return
	}

	// Обновляем статус в базе данных
	if err := a.dService.UpdateLocationStatus(user.ID, req.IsEnabled); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to update status"})
		return
	}

	c.JSON(http.StatusOK, gin.H{"status": "Location sharing status updated"})
}

// GetLocationSharingStatus  @Summary     Получение статуса общего доступа к геолокации водителя.
// @Description   Возвращает статус, указывающий, включен ли общий доступ к геолокации водителя.
// @Accept        json
// @Produce       json
// @Tags          Driver (водитель спецтехники)
// @Param         Authorization   header    string                  true   "приставка `Bearer` с пробелом и токен водителя"
// @Success       200             {object}  map[string]interface{}  "Статус геолокации"
// @Failure       401             {object}  map[string]interface{}  "Unauthorized"
// @Failure       500             {object}  map[string]interface{}  "Failed to check location sharing status"
// @Router        /location_status [get]
func (a *driver) GetLocationSharingStatus(c *gin.Context) {
	user, err := GetUserFromGin(c)
	if err != nil {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "Unauthorized"})
		return
	}

	logrus.Info(user.ID)

	isEnabled, err := a.dMoveService.IsLocationSharingEnabled(user.ID)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to check location sharing status"})
		return
	}

	if isEnabled {
		c.JSON(http.StatusOK, gin.H{
			"status":  "enabled",
			"message": "Location sharing is currently enabled",
		})
	} else {
		c.JSON(http.StatusOK, gin.H{
			"status":  "disabled",
			"message": "Location sharing is currently disabled",
		})
	}
}

// @Summary      Ответить на запрос добавления в водители
// @Description  Водитель принимает или отклоняет запрос от владельца.
// @Tags         Driver
// @Accept       json
// @Produce      json
// @Param        Authorization  header    string  true  "Bearer токен"
// @Param        id       path      int     true  "ID владельца"
// @Param        accept         query      bool    true  "Принять или отклонить запрос"
// @Success      200            {object}  map[string]interface{}       "Успешно"
// @Failure      400,401,500    {object}  map[string]interface{}       "Ошибка"
// @Router       /driver/respond/:id [post]
func (d *driver) RespondToAddWorkerRequest(ctx *gin.Context) {
	driver, err := GetUserFromGin(ctx)
	if err != nil {
		ctx.JSON(http.StatusUnauthorized, gin.H{"error": "Unauthorized"})
		return
	}

	ownerID, err := strconv.Atoi(ctx.Param("id"))
	if err != nil {
		ctx.JSON(http.StatusBadRequest, gin.H{"error": "Invalid owner ID"})
		return
	}

	acceptParam := ctx.Query("accept")
	if acceptParam == "" {
		ctx.JSON(http.StatusBadRequest, gin.H{"error": "Missing 'accept' parameter"})
		return
	}

	accept, err := strconv.ParseBool(acceptParam)
	if err != nil {
		ctx.JSON(http.StatusBadRequest, gin.H{"error": "Invalid 'accept' parameter"})
		return
	}

	err = d.dService.RespondToAddWorkerRequest(driver.ID, ownerID, accept)
	if err != nil {
		ctx.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	ctx.JSON(http.StatusOK, gin.H{"status": "success"})
}
