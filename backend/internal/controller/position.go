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

type position struct {
	position service.IPosition
}

func NewPosition(r *gin.Engine, auth service.IAuthentication, positionService service.IPosition) {
	handler := position{position: positionService}

	m := r.Group("position")

	m.POST("", authorize(auth, model.ROLE_DRIVER, model.ROLE_OWNER, model.ROLE_ADMIN, model.ROLE_CLIENT),
		handler.SetPosition)
	m.GET("", handler.GetPosition)
}

//	@Summary	Кординаты местонахождения
//	@Security	ApiKeyAuth
//	@Accept		json
//	@Produce	json
//	@Tags		Position
//	@Param		Authorization	header		string							true	"приставка `Bearer` с пробелом и сам токен"
//	@Param		request			body		controller.SetPosition.request	true	"кординаты"
//	@Success	200				{object}	[]model.Param
//	@Failure	403				{object}	map[string]interface{}
//	@Failure	400,404			{object}	map[string]interface{}
//	@Failure	500				{object}	map[string]interface{}
//	@Failure	default			{object}	map[string]interface{}
//	@Router		/position [post]
func (h *position) SetPosition(c *gin.Context) {
	user, err := GetUserFromGin(c)
	if err != nil {
		c.JSON(http.StatusUnauthorized, gin.H{"error": err.Error()})
		return
	}

	type request struct {
		Latitude  float64 `json:"latitude"`
		Longitude float64 `json:"longitude"`
	}

	r := request{}

	if err := c.BindJSON(&r); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	err = h.position.SetPosition(c, model.Position{
		UserID:    user.ID,
		Latitude:  r.Latitude,
		Longitude: r.Longitude,
	})
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"status": "success"})
}

//	@Summary	получение Кординаты местонахождения
//	@Security	ApiKeyAuth
//	@Accept		json
//	@Produce	json
//	@Tags		Position
//	@Param		user_detail			query		bool	false	"детали полльзователя"
//	@Param		user_id				query		int		false	"фильтр по идентификатору пользователя"
//	@Param		after_created_at	query		string	false	"формат времени: `год-месяц-день час-мин` `2006-01-02 15:04`, мин время начало включительно"
//	@Param		before_created_at	query		string	false	"формат времени: `год-месяц-день час-мин` `2006-01-02 15:04`, макс время начало включительно"
//	@Success	200					{object}	[]model.Param
//	@Failure	403					{object}	map[string]interface{}
//	@Failure	400,404				{object}	map[string]interface{}
//	@Failure	500					{object}	map[string]interface{}
//	@Failure	default				{object}	map[string]interface{}
//	@Router		/position [get]
func (h *position) GetPosition(c *gin.Context) {
	f := model.FilterPosition{}

	if val, ok := c.GetQuery("user_detail"); ok {
		v, err := strconv.ParseBool(val)
		if err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"parameter": "user_detail", "error": err.Error()})
			return
		}
		f.UserDetail = &v
	}

	if v, ok := c.GetQuery("after_created_at"); ok {
		t, err := time.Parse("2006-01-02 15:04", v)
		if err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"parameter": "after_created_at", "error": err.Error()})
			return
		}
		f.AfterCreatedAt = model.Time{NullTime: sql.NullTime{Time: t, Valid: true}}
	}

	if v, ok := c.GetQuery("before_created_at"); ok {
		t, err := time.Parse("2006-01-02 15:04", v)
		if err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"parameter": "before_created_at", "error": err.Error()})
			return
		}
		f.BeforeCreatedAt = model.Time{NullTime: sql.NullTime{Time: t, Valid: true}}
	}

	if val, ok := c.GetQueryArray("user_id"); ok {
		f.UserIDs = make([]int, 0, len(val))
		for _, v := range val {
			id, err := strconv.Atoi(v)
			if err != nil {
				c.JSON(http.StatusBadRequest, gin.H{"parameter": "id", "error": err.Error()})
				return
			}
			f.UserIDs = append(f.UserIDs, id)
		}
	}

	res, err := h.position.GetPosition(c, f)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"parameter": "id", "error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"positions": res})
}
