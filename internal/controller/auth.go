package controller

import (
	"encoding/json"
	"errors"
	"github.com/gin-gonic/gin"
	"gitlab.com/eqshare/eqshare-back/internal/service"
	"gitlab.com/eqshare/eqshare-back/model"
	"gitlab.com/eqshare/eqshare-back/pkg/util"
	"net/http"
	"strings"
)

type auth struct {
	service       service.IAuthentication
	driverService service.IDriverMoveService
}

func NewAuthentication(r *gin.Engine, service service.IAuthentication) {
	handler := &auth{
		service: service,
	}

	r.POST("/signup", handler.SignUp)
	r.POST("/signup/v2", handler.SignUp2)
	r.POST("/send/code", handler.SendCode)
	r.POST("/confirm/code", handler.ConfirmCode)
	r.POST("/signin", handler.SignIn)
	r.POST("/refresh", handler.Refresh)
	r.POST("/signout", handler.SignOut)
	r.POST("/auth/:role", CheckToken(service), handler.AccessRole)
	r.POST("/admin/signin", handler.AdminSignIn)
}

// @Summary		Регистраци юзера
// @Description	`При решистрации нет валидации пароля и номера телефа!!!`
// @Accept			json
// @Produce		json
// @Tags			Auth
// @Success		200
// @Param			sign_up	body		model.SignUp			true	"нет валидации!!!"
// @Success		200		{object}	map[string]interface{}	"success"
// @Success		204		{object}	map[string]interface{}	"возврашет когда юзер с таким номером существует"
// @Failure		403		{object}	map[string]interface{}
// @Failure		400,404	{object}	map[string]interface{}
// @Failure		500		{object}	map[string]interface{}
// @Failure		default	{object}	map[string]interface{}
// @Router			/signup [post]
func (a *auth) SignUp(c *gin.Context) {
	s := model.SignUp{}

	if err := c.BindJSON(&s); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	token, err := a.service.SignUp(s)
	if err != nil {
		if errors.Is(err, model.ErrUserExists) {
			c.JSON(http.StatusNoContent, gin.H{"error": model.ErrUserExists.Error()})
		} else {
			c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		}
		return
	}

	c.JSON(http.StatusOK, gin.H{"token": token})
}

// SendCode
// @Summary		Отправка кода клиенту
// @Description	`Код для регистраций`
// @Accept			json
// @Produce		json
// @Tags			Auth
// @Success		200
// @Param			send_code	body		model.SendCode			true  "нет валидации!!!"
// @Success		200		{object}	map[string]interface{}	"send"
// @Failure		403		{object}	map[string]interface{}
// @Failure		400,404	{object}	map[string]interface{}
// @Failure		500		{object}	map[string]interface{}
// @Failure		default	{object}	map[string]interface{}
// @Router			/send/code [post]
func (a *auth) SendCode(c *gin.Context) {
	s := model.SendCode{}

	if err := c.BindJSON(&s); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	err := a.service.SendCode(s)
	if err != nil {
		if errors.Is(err, model.ErrUserExists) {
			c.JSON(http.StatusForbidden, gin.H{"error": model.ErrUserExists.Error()})
		} else if errors.Is(err, model.SmsError) {
			c.JSON(http.StatusNotAcceptable, gin.H{"error": err.Error()})
		} else {
			c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		}
		return
	}

	c.JSON(http.StatusOK, "send")
}

// ConfirmCode
// @Summary		Проверка кода
// @Description	`Проверка кода для регистраций`
// @Accept			json
// @Produce		json
// @Tags			Auth
// @Success		200
// @Param			sign_up	body		model.ConfirmCode			true "нет валидации!!!"
// @Success		200		{object}	map[string]interface{}	"success"
// @Failure		403		{object}	map[string]interface{}
// @Failure		400,404	{object}	map[string]interface{}
// @Failure		410		{object}	map[string]interface{} "code expired"
// @Failure		401		{object}	map[string]interface{} "password does not match"
// @Failure		500		{object}	map[string]interface{}
// @Failure		default	{object}	map[string]interface{}
// @Router			/confirm/code [post]
func (a *auth) ConfirmCode(c *gin.Context) {
	s := model.ConfirmCode{}

	if err := c.BindJSON(&s); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	err := a.service.ConfirmCode(s)
	if err != nil {
		if errors.Is(model.CodeExpired, err) {
			c.JSON(http.StatusGone, gin.H{"error": err.Error()})
			return
		} else if errors.Is(model.CodeMismatch, err) {
			c.JSON(http.StatusUnauthorized, gin.H{"error": err.Error()})
			return
		}
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return

	}

	c.JSON(http.StatusOK, "confirmed")
}

// SignUp2
// @Summary		Регистраци юзера
// @Description	`При решистрации нет валидации пароля и номера телефа!!!`
// @Description	"first_name, last_name, city_id, phone_number, password передать json формате, название параметра base"
// @Accept			mpfd
// @Produce		json
// @Tags			Auth
// @Success		200
// @Param			base	body		model.SignUp			true	"`formData`"
// @Param			foto	formData	file					true	"картинка профиля"
// @Success		200		{object}	map[string]interface{}	"success"
// @Success		204		{object}	map[string]interface{}	"возврашет когда юзер с таким номером существует"
// @Failure		403		{object}	map[string]interface{}
// @Failure		400,404	{object}	map[string]interface{}
// @Failure		500		{object}	map[string]interface{}
// @Failure		default	{object}	map[string]interface{}
// @Router			/signup/v2 [post]
func (a *auth) SignUp2(c *gin.Context) {
	mf, err := c.MultipartForm()
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	s := model.SignUp{}

	if val, ok := mf.Value["base"]; ok {
		if err := json.Unmarshal([]byte(val[0]), &s); err != nil {
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
			c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
			return
		}
		s.Document = &d
	}

	token, err := a.service.SignUp(s)
	if err != nil {
		if errors.Is(err, model.ErrUserExists) {
			c.JSON(http.StatusNoContent, gin.H{"error": model.ErrUserExists.Error()})
		} else {
			c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		}
		return
	}

	c.JSON(http.StatusOK, gin.H{"token": token})
}

// @Summary		Аутентификация
// @Description	Нет валидации
// @Description	Возвращает пару access refresh токен
// @Description	access испольщовать при обращения к ендпонтам требующим определенные права. срок её жизни коротки
// @Description	refresh токен одноразвый, когда ендпонтам требующим определенные права будте возращать 401 код нужно братится к ендпоинту /refresh
// @Accept			json
// @Produce		json
// @Tags			Auth
// @Success		200
// @Param			sign_in	body		model.SignIn			true	"нет валидации!!!"
// @Success		200		{object}	model.Token				"пара access refresh токен"
// @Success		204		{object}	map[string]interface{}	"возврашет когда юзер с таким номером существует"
// @Failure		401		{object}	map[string]interface{}	"возвращается когда пароль не совпадает"
// @Failure		400,404	{object}	map[string]interface{}
// @Failure		500		{object}	map[string]interface{}
// @Failure		default	{object}	map[string]interface{}
// @Router			/signin [post]
func (a *auth) SignIn(c *gin.Context) {
	s := model.SignIn{}

	if err := c.BindJSON(&s); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	token, err := a.service.SignIn(s)
	if err != nil {
		if errors.Is(model.ErrPasswordDontMatch, err) {
			c.JSON(http.StatusUnauthorized, gin.H{"error": err.Error()})
		} else if errors.Is(model.ErrNotFound, err) {
			c.JSON(http.StatusUnauthorized, gin.H{"error": err.Error()})
		} else {
			c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		}
		return
	}

	c.JSON(http.StatusOK, gin.H{"token": token})
}

// @Summary		Рефреш операция
// @Description	Возвращает пару access refresh токен
// @Description	access испольщовать при обращения к ендпонтам требующим определенные права. срок её жизни коротки
// @Description	refresh токен одноразвый, когда ендпонтам требующим определенные права будте возращать 401 код нужно братится к ендпоинту /refresh
// @Accept			json
// @Produce		json
// @Tags			Auth
// @Success		200
// @Param			Authorization	header		string					true	"Bearer должен быть, refresh токен"
// @Success		200				{object}	model.Token				"пара access refresh токен"
// @Success		204				{object}	map[string]interface{}	"возврашет когда юзер с таким номером существует"
// @Failure		401				{object}	map[string]interface{}	"возвращается когда токен не действительный"
// @Failure		400,404			{object}	map[string]interface{}
// @Failure		500				{object}	map[string]interface{}
// @Failure		default			{object}	map[string]interface{}
// @Router			/refresh [post]
func (a *auth) Refresh(c *gin.Context) {
	token := c.GetHeader("Authorization")

	// Проверка, что токен начинается с "Bearer "
	const bearerPrefix = "Bearer "
	if !(len(token) > len(bearerPrefix) && token[:len(bearerPrefix)] == bearerPrefix) {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "Invalid Bearer Token"})
		return
	}

	// Извлечение токена без префикса
	token = token[len(bearerPrefix):]

	newToken, err := a.service.Refresh(token)
	if err != nil {
		if errors.Is(err, model.ErrDonValidToken) {
			c.JSON(http.StatusUnauthorized, gin.H{"error": err.Error()})
			return
		}
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"token": newToken})
}

// @Summary		Signout
// @Description	TODO
// @Accept			json
// @Produce		json
// @Tags			Auth
// @Success		200
// @Param			Authorization	header		string					true	"Bearer должен быть"
// @Success		200				{object}	model.Token				"пара access refresh токен"
// @Success		204				{object}	map[string]interface{}	"возврашет когда юзер с таким номером существует"
// @Failure		401				{object}	map[string]interface{}	"возвращается когда токен не действительный"
// @Failure		400,404			{object}	map[string]interface{}
// @Failure		500				{object}	map[string]interface{}
// @Failure		default			{object}	map[string]interface{}
// @Router			/signout [post]
func (a *auth) SignOut(c *gin.Context) {
	c.JSON(http.StatusOK, gin.H{"status": "TODO"})
}

// @Summary		Переключение роля пользователя
// @Description	Переключение роля пользователя
// @Description	если у пользователя не хватает доступа стать водитель тогда возвращает `Access denied`
// @Description	Возвращает пару access refresh токен
// @Accept			json
// @Produce		json
// @Tags			Auth
// @Success		200
// @Param			Authorization	header		string					true	"Bearer должен быть, refresh токен"
// @Success		200				{object}	model.Token				"пара access refresh токен"
// @Success		204				{object}	map[string]interface{}	"возврашет когда юзер с таким номером существует"
// @Failure		401				{object}	map[string]interface{}	"возвращается когда токен не действительный"
// @Failure		400,404			{object}	map[string]interface{}
// @Failure		500				{object}	map[string]interface{}
// @Failure		default			{object}	map[string]interface{}
// @Router			/auth/:role [post]
func (a *auth) AccessRole(c *gin.Context) {
	accessRole := c.Param("role")
	accessRole = strings.ToUpper(accessRole)

	token := c.GetHeader("Authorization")
	const bearerPrefix = "Bearer "
	if !(len(token) > len(bearerPrefix) && token[:len(bearerPrefix)] == bearerPrefix) {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "Invalid Bearer Token"})
		return
	}

	token = token[len(bearerPrefix):]

	_, ok := model.ListRole[accessRole]
	if !ok {
		c.JSON(http.StatusBadRequest, gin.H{"error": "invalid role"})
		return
	}

	newToken, err := a.service.AccessRole(c, token, accessRole)
	if err != nil {
		c.JSON(http.StatusForbidden, gin.H{"reason": "Access denied", "error": err})
		return
	}

	c.JSON(http.StatusOK, gin.H{"Authorization": newToken})

}

func (a *auth) AdminSignIn(c *gin.Context) {
	s := model.SignIn{}

	if err := c.BindJSON(&s); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	token, err := a.service.AdminSignIn(s)
	if err != nil {
		if errors.Is(err, model.ErrDonValidToken) {
			c.JSON(http.StatusUnauthorized, gin.H{"error": err.Error()})
			return
		}
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"token": token})
}
