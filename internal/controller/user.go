package controller

import (
	"encoding/json"
	"fmt"
	"log"
	"net/http"
	"strconv"

	"github.com/gin-gonic/gin"
	"gitlab.com/eqshare/eqshare-back/internal/service"
	"gitlab.com/eqshare/eqshare-back/model"
	"gitlab.com/eqshare/eqshare-back/pkg/util"
)

type user struct {
	service service.IUser
}

func NewUser(r *gin.Engine, auth service.IAuthentication, service service.IUser) {
	handler := &user{service: service}

	r.GET("/user", authorize(auth, model.ROLE_CLIENT, model.ROLE_DRIVER, model.ROLE_ADMIN), handler.Get)
	r.GET("/user/:id", handler.GetByID)
	r.POST("/user", authorize(auth, model.ROLE_ADMIN), handler.Create)
	r.POST("/user/v2", authorize(auth, model.ROLE_ADMIN), handler.Create2)
	r.PUT("/user/:id", authorize(auth, model.ROLE_ADMIN), handler.Update)
	r.PUT("/user/profile", authorize(auth, model.ROLE_ADMIN, model.ROLE_CLIENT, model.ROLE_DRIVER), handler.UpdateProfile)
	r.PUT("/user/:id/name", authorize(auth, model.ROLE_ADMIN, model.ROLE_CLIENT, model.ROLE_DRIVER), handler.UpdateName)
	r.PUT("/user/:id/nick_name", authorize(auth, model.ROLE_ADMIN, model.ROLE_OWNER), handler.UpdateNickName)
	r.PATCH("/user/:id/foto", authorize(auth, model.ROLE_CLIENT, model.ROLE_DRIVER, model.ROLE_OWNER, model.ROLE_ADMIN), handler.UpdateFoto)
	r.PATCH("/user/:id/custom_foto", authorize(auth, model.ROLE_CLIENT, model.ROLE_DRIVER, model.ROLE_OWNER, model.ROLE_ADMIN), handler.UpdateCustomFoto)
	r.DELETE("/user/:id", authorize(auth, model.ROLE_CLIENT, model.ROLE_ADMIN, model.ROLE_DRIVER), handler.Delete)
	r.POST("/user/reset/password", handler.ResetPassword)
}

type username struct {
	FirstName string `json:"first_name"`
	LastName  string `json:"last_name"`
}

// @Summary		Получние всех пользователей.
// @Description	Получние всех пользователей. Не все поля возврашаются. К примеру прова.
// @Description	TODO добавить фильтр для получения удаленных пользователей
// @Accept			json
// @Produce		json
// @Tags			User
// @Success		200
// @Param			can_driver		query		string	false	"получение пользователей по роли"
// @Param			document_detail	query		bool	false	"получение фотографии"
// @Success		200				{object}	[]model.User
// @Failure		403				{object}	map[string]interface{}
// @Failure		400,404			{object}	map[string]interface{}
// @Failure		500				{object}	map[string]interface{}
// @Failure		default			{object}	map[string]interface{}
// @Router			/user [get]
func (h *user) Get(c *gin.Context) {
	f := model.FilterUser{}

	if val, ok := c.GetQuery("document_detail"); ok {
		v, err := strconv.ParseBool(val)
		if err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": fmt.Sprintf("document_detail: %v", err.Error())})
			return
		}
		f.DocumentDetail = &v
	}

	if val, ok := c.GetQuery("can_driver"); ok {
		v, err := strconv.ParseBool(val)
		if err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": fmt.Sprintf("can_driver: %v", err.Error())})
			return
		}
		f.CanDriver = &v
	}

	if val, ok := c.GetQuery("can_owner"); ok {
		v, err := strconv.ParseBool(val)
		if err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": fmt.Sprintf("can_owner: %v", err.Error())})
			return
		}
		f.CanOwner = &v
	}

	if val, ok := c.GetQuery("phone_number"); ok {
		// TODO валидация номера
		f.PhoneNumber = &val
	}

	if val, ok := c.GetQuery("owner_id"); ok {
		f.OwnerID = &val
	}

	users, err := h.service.Get(f)
	if err != nil {
		c.JSON(http.StatusInternalServerError, err.Error())
		return
	}

	c.JSON(http.StatusOK, gin.H{"users": users})
}

// @Summary		Получение пользователя по идентификатору
// @Description	Получение пользователя по идентификатору. В случае если если роль по идентифиатору нет вернут 500 ошибку.
// @Description	TODO сделать так что бы возврашал 204
// @Accept			json
// @Produce		json
// @Tags			User
// @Success		200
// @Param			id		path		int	true	"идентификатор польователя"
// @Success		200		{object}	model.User
// @Failure		403		{object}	map[string]interface{}
// @Failure		400,404	{object}	map[string]interface{}
// @Failure		500		{object}	map[string]interface{}
// @Failure		default	{object}	map[string]interface{}
// @Router			/user/:id [get]
func (h *user) GetByID(c *gin.Context) {
	id, err := strconv.Atoi(c.Param("id"))
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	if id <= 0 {
		c.JSON(http.StatusBadRequest, gin.H{"error": "don't correct id"})
		return
	}

	user, err := h.service.GetByID(id)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"user": user})
}

// @Summary		Создание пользователя.
// @Description	Создается обеъект пользоватлье.
// @Description	Параметр roles нужно заполнять `только` идентификатор id.
// @Accept			json
// @Produce		json
// @Tags			User
// @Success		200
// @Param			rigth	body		controller.Create.requestUser	true	"тело пользователя"
// @Success		200		{object}	map[string]interface{}			"success"
// @Failure		403		{object}	map[string]interface{}
// @Failure		400,404	{object}	map[string]interface{}
// @Failure		500		{object}	map[string]interface{}
// @Failure		default	{object}	map[string]interface{}
// @Router			/user [post]
func (h *user) Create(c *gin.Context) {
	type requestUser struct {
		FirsName    string `json:"first_name"`
		LastName    string `json:"last_name"`
		PhoneNumber string `json:"phone_number"`
		Password    string `json:"password"`
		Roles       []int  `json:"roles_id"`
		CityID      int    `json:"city_id"`
		Email       string `json:"email"`
	}

	userR := requestUser{}

	if err := c.BindJSON(&userR); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	roles := make([]model.Role, 0, len(userR.Roles))

	for _, id := range userR.Roles {
		roles = append(roles, model.Role{
			ID: id,
		})
	}

	user, err := h.service.Create(
		model.User{
			FirstName:   userR.FirsName,
			LastName:    userR.LastName,
			PhoneNumber: userR.PhoneNumber,
			Password:    userR.Password,
			Roles:       roles,
			CityID:      uint(userR.CityID),
			Email:       userR.Email,
		},
	)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"reason": user})
}

// @Summary		Создание пользователя.
// @Description	Создается обеъект пользоватлье.
// @Description	Параметр roles нужно заполнять `только` идентификатор id.
// @Accept			json
// @Produce		json
// @Tags			User
// @Success		200
// @Param			rigth	body		controller.Create.requestUser	true	"тело пользователя"
// @Success		200		{object}	map[string]interface{}			"success"
// @Failure		403		{object}	map[string]interface{}
// @Failure		400,404	{object}	map[string]interface{}
// @Failure		500		{object}	map[string]interface{}
// @Failure		default	{object}	map[string]interface{}
// @Router			/user/v2 [post]
func (h *user) Create2(c *gin.Context) {
	u := model.User{}

	mf, err := c.MultipartForm()
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	type requestUser struct {
		FirsName    string `json:"first_name"`
		LastName    string `json:"last_name"`
		PhoneNumber string `json:"phone_number"`
		Password    string `json:"password"`
		Roles       []int  `json:"roles_id"`
		CityID      int    `json:"city_id"`
		Email       string `json:"email"`
	}

	userR := requestUser{}

	if val, ok := mf.Value["base"]; ok && len(val) != 0 {
		if err := json.Unmarshal([]byte(val[0]), &userR); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
			return
		}
	} else {
		c.JSON(http.StatusBadRequest, gin.H{"error": "base is empty"})
		return
	}

	if val, ok := mf.File["foto"]; ok {
		d, err := util.ParseDocumentOnMultipart(val[0])
		if err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"parameter": "foto", "error": err.Error()})
			return
		}
		d.UserID = 1
		u.Document = &d
	}

	roles := make([]model.Role, 0, len(userR.Roles))

	for _, id := range userR.Roles {
		roles = append(roles, model.Role{
			ID: id,
		})
	}

	u.FirstName = userR.FirsName
	u.LastName = userR.LastName
	u.PhoneNumber = userR.PhoneNumber
	u.Password = userR.Password
	u.Roles = roles
	u.CityID = uint(userR.CityID)
	u.Email = userR.Email

	user, err := h.service.Create(u)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"reason": user})
}

// Update
// @Summary		Измение пользователя.
// @Description	Изменение объект пользователя.
// @Accept			json
// @Produce		json
// @Tags			User
// @Success		200
// @Param			id		path		int								true	"идентификатор пользователя"
// @Param			rigth	body		controller.Update.requestUser	true	"тело право, `id` и `created_at` не заполнять"
// @Success		200		{object}	map[string]interface{}			"success"
// @Failure		403		{object}	map[string]interface{}
// @Failure		400,404	{object}	map[string]interface{}
// @Failure		500		{object}	map[string]interface{}
// @Failure		default	{object}	map[string]interface{}
// @Router			/user/:id [put]
func (h *user) Update(c *gin.Context) {
	id, err := strconv.Atoi(c.Param("id"))
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	if id <= 0 {
		c.JSON(http.StatusBadRequest, gin.H{"error": "don't correct id"})
		return
	}

	type requestUser struct {
		FirsName string `json:"first_name"`
		LastName string `json:"last_name"`
		Password string `json:"password"`
		Roles    []int  `json:"roles_id"`
		CityID   int    `json:"city_id"`
		Email    string `json:"email"`
	}

	userR := requestUser{}

	roles := make([]model.Role, 0, len(userR.Roles))

	if err := c.BindJSON(&userR); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	for _, id := range userR.Roles {
		roles = append(roles, model.Role{
			ID: id,
		})
	}

	user := model.User{}

	user.ID = id
	user.FirstName = userR.FirsName
	user.LastName = userR.LastName
	user.Password = userR.Password
	user.Roles = roles
	user.CityID = uint(userR.CityID)
	user.Email = userR.Email

	if err := h.service.Update(user); err != nil {
		c.JSON(http.StatusInternalServerError, err.Error())
		return
	}

	c.JSON(http.StatusOK, gin.H{"status": "success"})
}

// UpdateProfile
// @Summary		Измение пользователя.
// @Description	Изменение объект пользователя.
// @Accept			json
// @Produce		json
// @Tags			User
// @Success		200
// @Param			rigth	body		controller.UpdateProfile.requestUser	true	"тело право, `id` и `created_at` не заполнять"
// @Success		200		{object}	map[string]interface{}			"success"
// @Failure		403		{object}	map[string]interface{}
// @Failure		400,404	{object}	map[string]interface{}
// @Failure		500		{object}	map[string]interface{}
// @Failure		default	{object}	map[string]interface{}
// @Router			/user/profile [put]
func (h *user) UpdateProfile(c *gin.Context) {
	userFromToken, ok := c.Get(gin.AuthUserKey)
	if !ok {
		c.JSON(http.StatusBadRequest, gin.H{"error": "user does not exist"})
		return
	}

	userCasted := userFromToken.(model.User)

	if userCasted.ID <= 0 {
		c.JSON(http.StatusBadRequest, gin.H{"error": "don't correct id"})
		return
	}

	type requestUser struct {
		FirsName string `json:"first_name"`
		LastName string `json:"last_name"`
		Password string `json:"password"`
		Roles    []int  `json:"roles_id"`
		CityID   int    `json:"city_id"`
		Email    string `json:"email"`
	}

	userR := requestUser{}

	roles := make([]model.Role, 0, len(userR.Roles))

	if err := c.BindJSON(&userR); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	for _, id := range userR.Roles {
		roles = append(roles, model.Role{
			ID: id,
		})
	}
	user := model.User{}

	user.ID = userCasted.ID
	user.FirstName = userR.FirsName
	user.LastName = userR.LastName
	user.Password = userR.Password
	user.Roles = roles
	user.CityID = uint(userR.CityID)
	user.Email = userR.Email

	if err := h.service.Update(user); err != nil {
		c.JSON(http.StatusInternalServerError, err.Error())
		return
	}

	c.JSON(http.StatusOK, gin.H{"status": "success"})
}

// @Summary		Удаление пользователя.
// @Description	Удаление пользователя прооиходит мягко.
// @Accept			json
// @Produce		json
// @Tags			User
// @Success		200
// @Param			id		path		int						true	"идентификатор право"
// @Success		200		{object}	map[string]interface{}	"success"
// @Failure		403		{object}	map[string]interface{}
// @Failure		400,404	{object}	map[string]interface{}
// @Failure		500		{object}	map[string]interface{}
// @Failure		default	{object}	map[string]interface{}
// @Router			/user/:id [delete]
func (h *user) Delete(c *gin.Context) {
	id, err := strconv.Atoi(c.Param("id"))
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	if id <= 0 {
		c.JSON(http.StatusBadRequest, gin.H{"error": "don't correct id"})
		return
	}

	if err := h.service.Delete(id); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"status": "success"})
}

// @Summary		Обновление имени пользователя.
// @Description	Обновление имени пользователя.
// @Accept			json
// @Produce		json
// @Tags			User
// @Success		200
// @Param			id		path		int						true	"идентификатор пользователя"
// @Param			body	body		username				true	"имя пользователя"
// @Success		200		{object}	map[string]interface{}	"success"
// @Failure		403		{object}	map[string]interface{}
// @Failure		400,404	{object}	map[string]interface{}
// @Failure		500		{object}	map[string]interface{}
// @Failure		default	{object}	map[string]interface{}
// @Router			/user/:id/name [put]
func (h *user) UpdateName(c *gin.Context) {
	var fio username
	if err := c.ShouldBind(&fio); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"reason": err.Error()})
		return
	}

	user, err := GetUserFromGin(c)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"reason": err.Error()})
		return
	}

	user.FirstName = fio.FirstName
	user.LastName = fio.LastName

	if err := h.service.UpdateUserName(user); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"reason": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"reason": "succeed"})
}

type UpdateNickNameRequest struct { //just for swagger
	Nickname string `json:"nick_name" example:"s1mple"`
}

// @Summary		Обновление никнейма пользователя.
// @Description	Обновление никнейма пользователя.
// @Accept			json
// @Produce		json
// @Tags			User
// @Success		200
// @Param			Authorization	header		string	true	"приставка `Bearer` с пробелом и сам токен"
// @Param			body	body		UpdateNickNameRequest	true	"Тело запроса для обновления никнейма"
// @Success		200		{object}	map[string]interface{}	"success"
// @Failure		403		{object}	map[string]interface{}
// @Failure		400,404	{object}	map[string]interface{}
// @Failure		500		{object}	map[string]interface{}
// @Failure		default	{object}	map[string]interface{}
// @Router			/user/:id/nick_name [put]
func (h *user) UpdateNickName(c *gin.Context) {
	var usr struct {
		Nickname string `json:"nick_name"`
	}

	if err := c.ShouldBind(&usr); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"reason": err.Error()})
		return
	}

	//user, err := GetUserFromGin(c)
	//if err != nil {
	//	c.JSON(http.StatusInternalServerError, gin.H{"reason": err.Error()})
	//	return
	//}

	id, err := strconv.Atoi(c.Param("id"))
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"reason": err.Error()})
		return
	}

	user, err := h.service.GetByID(id)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"reason": err.Error()})
		return
	}

	user.NickName = usr.Nickname

	if err := h.service.UpdateNickName(user); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"reason": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"reason": "succeed"})
}

// @Summary	Обновление аватарки пользователя.
// @Accept		mpfd
// @Produce	json
// @Tags		User
// @Success	200
// @Param		Authorization	header		string					true	"`клиент` приставка `Bearer` с пробелом и сам токен"
// @Param		id				path		int						true	"идентификатор пользователя"
// @Param		foto			formData	file					true	"имя пользователя"
// @Success	200				{object}	map[string]interface{}	"аватврка"
// @Failure	403				{object}	map[string]interface{}
// @Failure	400,404			{object}	map[string]interface{}
// @Failure	500				{object}	map[string]interface{}
// @Failure	default			{object}	map[string]interface{}
// @Router		/user/:id/foto [patch]
func (h *user) UpdateFoto(c *gin.Context) {
	user, err := GetUserFromGin(c)
	if err != nil {
		c.JSON(http.StatusUnauthorized, gin.H{"error": err.Error()})
		return
	}

	id, err := strconv.Atoi(c.Param("id"))
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"parameter": "id", "error": err.Error()})
		return
	}

	f, err := c.FormFile("foto")
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"parameter": "foto", "error": err.Error()})
		return
	}

	d, err := util.ParseDocumentOnMultipart(f)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"invalid input": "foto", "error": err.Error()})
		return
	}

	if user.ID == 1 {
		d.UserID = id
	} else {
		d.UserID = user.ID
	}

	// Логируем входные данные перед вызовом функции UpdateFoto
	log.Println("UpdateCustomFoto: Received document:", d)

	// Здесь мы получаем URL документа, если успешно обновлено
	response := h.service.UpdateFoto(model.User{
		ID:             id,
		CustomDocument: &d,
	}, true)

	// Логируем результат ответа
	if response == nil {
		log.Println("UpdateFoto returned nil URL")
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to update foto"})
		return
	}

	log.Println("UpdateFoto succeeded. Returning URL:", *response)
	c.JSON(http.StatusOK, gin.H{"url": *response}) // Возвращаем URL документа
}

// @Summary	Обновление аватарки пользователя для владельца бизнеса.
// @Accept		mpfd
// @Produce	json
// @Tags		User
// @Success	200
// @Param		Authorization	header		string					true	"`клиент` приставка `Bearer` с пробелом и сам токен"
// @Param		id				path		int						true	"идентификатор пользователя"
// @Param		foto			formData	file					true	"имя пользователя"
// @Success	200				{object}	map[string]interface{}	"аватврка"
// @Failure	403				{object}	map[string]interface{}
// @Failure	400,404			{object}	map[string]interface{}
// @Failure	500				{object}	map[string]interface{}
// @Failure	default			{object}	map[string]interface{}
// @Router		/user/:id/custom_foto [patch]
func (h *user) UpdateCustomFoto(c *gin.Context) {
	user, err := GetUserFromGin(c)
	if err != nil {
		c.JSON(http.StatusUnauthorized, gin.H{"error": err.Error()})
		return
	}

	id, err := strconv.Atoi(c.Param("id"))
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"parameter": "id", "error": err.Error()})
		return
	}

	f, err := c.FormFile("foto")
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"parameter": "foto", "error": err.Error()})
		return
	}

	d, err := util.ParseDocumentOnMultipart(f)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"invalid input": "foto", "error": err.Error()})
		return
	}

	if user.ID == 1 {
		d.UserID = id
	} else {
		d.UserID = user.ID
	}

	response := h.service.UpdateFoto(model.User{
		ID:             id,
		CustomDocument: &d,
	}, true)

	if response == nil {
		log.Println("UpdateFoto returned nil URL")
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to update foto"})
		return
	}

	log.Println("UpdateFoto succeeded. Returning URL:", *response)
	c.JSON(http.StatusOK, gin.H{"url": *response}) // Возвращаем URL документа
}

// ResetPassword
// @Summary	Сброс пароля для пользователя
// @Accept		json
// @Produce	json
// @Tags		User
// @Success	200
// @Param		data	body		controller.ResetPassword.resetRequest	true	"передается одно из двух, либо email либо номер"
// @Success	200				{object}	map[string]interface{}
// @Failure	403				{object}	map[string]interface{}
// @Failure	400,404			{object}	map[string]interface{}
// @Failure	500				{object}	map[string]interface{}
// @Failure	default			{object}	map[string]interface{}
// @Router		/user/reset/password [post]
func (h *user) ResetPassword(c *gin.Context) {
	type resetRequest struct {
		Email string `json:"email"`
		Phone string `json:"phone"`
	}

	userR := resetRequest{}

	err := c.BindJSON(&userR)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	if userR.Email == "" && userR.Phone == "" {
		c.JSON(http.StatusBadRequest, gin.H{"error": "email or phone is required"})
		return
	}

	err = h.service.ResetPassword(userR.Email, userR.Phone)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"status": "success"})
}
