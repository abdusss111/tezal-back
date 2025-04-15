package controller

import (
	"errors"
	"fmt"
	"github.com/sirupsen/logrus"
	"net/http"
	"strconv"

	"github.com/gin-gonic/gin"
	"gitlab.com/eqshare/eqshare-back/internal/service"
	"gitlab.com/eqshare/eqshare-back/model"
)

type owner struct {
	ownerService service.IOwner
}

func NewOwner(r *gin.Engine, auth service.IAuthentication, ownerService service.IOwner) {
	handler := owner{ownerService: ownerService}

	r.GET("/owner", authorize(auth, model.ROLE_DRIVER, model.ROLE_OWNER, model.ROLE_ADMIN), handler.Get)
	r.GET("/owner/:id", authorize(auth, model.ROLE_DRIVER, model.ROLE_OWNER, model.ROLE_ADMIN), handler.GetByUserID)
	r.POST("/owner", authorize(auth, model.ROLE_DRIVER, model.ROLE_ADMIN), handler.BeOwner)
	r.POST("/owner/:id/worker", authorize(auth, model.ROLE_OWNER, model.ROLE_ADMIN), handler.AddWorker)
	r.POST("/owner/:id/send_worker", authorize(auth, model.ROLE_OWNER, model.ROLE_ADMIN), handler.SendWorker)
	r.DELETE("/owner/:id/worker/:worker_id", authorize(auth, model.ROLE_OWNER, model.ROLE_ADMIN), handler.DeleteWorker)
	r.DELETE("/owner/:id", authorize(auth, model.ROLE_OWNER, model.ROLE_ADMIN), handler.Delete)
}

// @Summary		Получние всех владельцев.
// @Description	Получние всех владельцев.
// @Accept			json
// @Produce		json
// @Tags			Owner
// @Param			Authorization	header		string	true	"`водитель, владелец, админ` приставка `Bearer` с пробелом и сам токен"
// @Param			user_id			query		int		true	"ID владельца, можно дублировать, посик будет проходить по всем"
// @Success		200				{object}	[]model.Owner
// @Failure		403				{object}	map[string]interface{}
// @Failure		400,404			{object}	map[string]interface{}
// @Failure		500				{object}	map[string]interface{}
// @Failure		default			{object}	map[string]interface{}
// @Router			/owner [get]
func (o *owner) Get(c *gin.Context) {
	f := model.FilterOwner{}

	if vals, ok := c.GetQueryArray("user_id"); ok {
		ids := make([]int, 0, len(vals))
		for _, v := range vals {
			id, err := strconv.Atoi(v)
			if err != nil {
				c.JSON(http.StatusBadRequest, gin.H{"error": fmt.Errorf("query user id %v", err.Error())})
				return
			}
			ids = append(ids, id)
		}
		f.UserIDs = ids
	}

	owners, err := o.ownerService.Get(f)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"owners": owners})
}

// @Summary		Получние по идентификатору владельцы.
// @Description	Получние по идентификатору владельцы.
// @Accept			json
// @Produce		json
// @Tags			Owner
// @Param			Authorization	header		string	true	"`водитель, владелец, админ` приставка `Bearer` с пробелом и сам токен"
// @Param			id				path		int		true	"ID владельца, можно дублировать, посик будет проходить по всем"
// @Success		200				{object}	[]model.Owner
// @Failure		403				{object}	map[string]interface{}
// @Failure		400,404			{object}	map[string]interface{}
// @Failure		500				{object}	map[string]interface{}
// @Failure		default			{object}	map[string]interface{}
// @Router			/owner/:id [get]
func (o *owner) GetByUserID(c *gin.Context) {
	id, err := strconv.Atoi(c.Param("id"))
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	owner, err := o.ownerService.GetByID(id)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"owner": owner})
}

// @Summary		Добавить пользователя в список владельцев.
// @Description	Добавить пользователя в список владельцев.
// @Description	Можно добавить только тех пользовател которые на данный момент не являются работниками и владельцем.
// @Description	`у объекта User если параметр owner_id равано null/nil`
// @Description	Использует идентификатор пользователя с токена
// @Accept			json
// @Produce		json
// @Tags			Owner
// @Param			Authorization	header		string	true	"`водитель, админ` приставка `Bearer` с пробелом и сам токен"
// @Param			user_id			query		int		false	"доступен только оот роли администрации, для симуляции исполнение команды от имени других пользователей"
// @Success		200				{object}	map[string]interface{}
// @Failure		403				{object}	map[string]interface{}
// @Failure		400,404			{object}	map[string]interface{}
// @Failure		500				{object}	map[string]interface{}
// @Failure		default			{object}	map[string]interface{}
// @Router			/owner [post]
func (o *owner) BeOwner(c *gin.Context) {
	user, err := GetUserFromGin(c)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	if user.AccessRole == model.ROLE_ADMIN {
		if strID, ok := c.GetQuery("user_id"); ok {
			user.ID, err = strconv.Atoi(strID)
			if err != nil {
				c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
				return
			}
		}
	}

	if err := o.ownerService.BeOwner(user.ID); err != nil {
		if errors.Is(err, model.ErrAccessDenied) {
			c.JSON(http.StatusForbidden, gin.H{"error": err.Error()})
			return
		}
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"status": "success"})
}

// @Summary		Добавить работника в список владельца.
// @Description	Добавить работника в список владельца.
// @Description	Можно добавить только тех пользовател которые на данный момент не являются работниками и не влабельцем.
// @Description	`у объекта User (работник) если параметр owner_id равано null/nil`
// @Description	Использует идентификатор пользователя с токена
// @Accept			json
// @Produce		json
// @Tags			Owner
// @Param			Authorization	header		string						true	"`водитель, админ` приставка `Bearer` с пробелом и сам токен"
// @Param			id				path		int							true	"Идентификатор владельца"
// @Param			worker			body		controller.AddWorker.worker	true	"Идентификатор владельца"
// @Success		200				{object}	map[string]interface{}
// @Failure		403				{object}	map[string]interface{}
// @Failure		400,404			{object}	map[string]interface{}
// @Failure		500				{object}	map[string]interface{}
// @Failure		default			{object}	map[string]interface{}
// @Router			/owner/:id/worker [post]
func (o *owner) AddWorker(c *gin.Context) {
	id, err := strconv.Atoi(c.Param("id"))
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	type worker struct {
		WorkerID int `json:"worker_id"`
	}

	w := worker{}

	if err := c.BindJSON(&w); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	if err := o.ownerService.AddWorker(id, w.WorkerID); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"status": "success"})
}

// @Summary		Отправить заявку на водителя для добавления.
// @Description	Отправить заявку на водителя для добавления.
// @Description	Можно добавить только тех пользователей которые на данный момент не являются работниками и не владельцем.
// @Description	`у объекта User (работник) если параметр owner_id равно null/nil`
// @Description	Использует идентификатор пользователя с токена
// @Accept			json
// @Produce		json
// @Tags			Owner
// @Param			Authorization	header		string						true	"`водитель, админ` приставка `Bearer` с пробелом и сам токен"
// @Param			id				path		int							true	"Идентификатор владельца"
// @Param			worker			body		controller.AddWorker.worker	true	"Идентификатор владельца"
// @Success		200				{object}	map[string]interface{}
// @Failure		403				{object}	map[string]interface{}
// @Failure		400,404			{object}	map[string]interface{}
// @Failure		500				{object}	map[string]interface{}
// @Failure		default			{object}	map[string]interface{}
// @Router			/owner/:id/send_worker [post]
func (o *owner) SendWorker(c *gin.Context) {
	id, err := strconv.Atoi(c.Param("id"))
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	type worker struct {
		WorkerID int `json:"worker_id"`
	}

	w := worker{}

	if err := c.BindJSON(&w); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	owner, err := o.ownerService.GetByID(id)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
	}

	logrus.Info("Owner: ", owner.UserID, owner.User.ID, owner.User.FirstName, owner.User.LastName)

	if err := o.ownerService.SendAddWorkerRequest(id, w.WorkerID, owner.User.FirstName, owner.User.LastName); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"status": "success"})
}

// @Summary		Удалить работника у владельца.
// @Description	Удалить работника у владельца.
// @Accept			json
// @Produce		json
// @Tags			Owner
// @Param			Authorization	header		string	true	"`водитель, админ` приставка `Bearer` с пробелом и сам токен"
// @Param			id				path		int		true	"Идентификатор владельца"
// @Param			worker_id		path		int		true	"Идентификатор работника"
// @Success		200				{object}	map[string]interface{}
// @Failure		403				{object}	map[string]interface{}
// @Failure		400,404			{object}	map[string]interface{}
// @Failure		500				{object}	map[string]interface{}
// @Failure		default			{object}	map[string]interface{}
// @Router			/owner/:id/worker/:worker_id [delete]
func (o *owner) DeleteWorker(c *gin.Context) {
	id, err := strconv.Atoi(c.Param("id"))
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	workerID, err := strconv.Atoi(c.Param("worker_id"))
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	if err := o.ownerService.DeleteWorker(id, workerID); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"status": "success"})
}

// @Summary		Удалить работника из списка.
// @Description	Удалить работника из списка.
// @Accept			json
// @Produce		json
// @Tags			Owner
// @Param			Authorization	header		string	true	"`водитель, админ` приставка `Bearer` с пробелом и сам токен"
// @Param			id				path		int		true	"Идентификатор владельца"
// @Success		200				{object}	map[string]interface{}
// @Failure		403				{object}	map[string]interface{}
// @Failure		400,404			{object}	map[string]interface{}
// @Failure		500				{object}	map[string]interface{}
// @Failure		default			{object}	map[string]interface{}
// @Router			/owner/:id [delete]
func (o *owner) Delete(c *gin.Context) {
	id, err := strconv.Atoi(c.Param("id"))
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	if err := o.ownerService.DeleteOWner(id); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"status": "success"})
}
