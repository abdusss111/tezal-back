package controller

import (
	"net/http"

	"github.com/gin-gonic/gin"
	"gitlab.com/eqshare/eqshare-back/internal/service"
	"gitlab.com/eqshare/eqshare-back/model"
)

type subscription struct {
	service service.ISubscription
}

func NewSubscription(r *gin.Engine, service service.ISubscription,
	auth service.IAuthentication) {
	handler := &subscription{
		service: service,
	}

	_ = handler

	s := r.Group("subscription")

	s.GET(
		"ad/sm_client",
		authorize(auth, model.ROLE_DRIVER, model.ROLE_CLIENT, model.ROLE_OWNER, model.ROLE_ADMIN),
		handler.GetToCreateAdClientSM,
	)

	s.POST(
		"ad/sm_client",
		authorize(auth, model.ROLE_DRIVER, model.ROLE_CLIENT, model.ROLE_OWNER, model.ROLE_ADMIN),
		handler.SubscriptionToCreateAdClientSM,
	)
	s.POST(
		"ad/sm_client/unsubscription",
		authorize(auth, model.ROLE_DRIVER, model.ROLE_CLIENT, model.ROLE_OWNER, model.ROLE_ADMIN),
		handler.UnsubscriptionToCreateAdClientSM,
	)

	s.GET(
		"ad/eq_client",
		authorize(auth, model.ROLE_DRIVER, model.ROLE_CLIENT, model.ROLE_OWNER, model.ROLE_ADMIN),
		handler.GetToCreateAdClientEQ,
	)

	s.POST(
		"ad/eq_client",
		authorize(auth, model.ROLE_DRIVER, model.ROLE_CLIENT, model.ROLE_OWNER, model.ROLE_ADMIN),
		handler.SubscriptionToCreateAdClientEQ,
	)
	s.POST(
		"ad/eq_client/unsubscription",
		authorize(auth, model.ROLE_DRIVER, model.ROLE_CLIENT, model.ROLE_OWNER, model.ROLE_ADMIN),
		handler.UnsubscriptionToCreateAdClientEQ,
	)

	s.GET(
		"ad/cm_client",
		authorize(auth, model.ROLE_DRIVER, model.ROLE_CLIENT, model.ROLE_OWNER, model.ROLE_ADMIN),
		handler.GetToCreateAdClientCM,
	)

	s.POST(
		"ad/cm_client",
		authorize(auth, model.ROLE_DRIVER, model.ROLE_CLIENT, model.ROLE_OWNER, model.ROLE_ADMIN),
		handler.SubscriptionToCreateAdClientCM,
	)
	s.POST(
		"ad/cm_client/unsubscription",
		authorize(auth, model.ROLE_DRIVER, model.ROLE_CLIENT, model.ROLE_OWNER, model.ROLE_ADMIN),
		handler.UnsubscriptionToCreateAdClientCM,
	)

	s.GET(
		"ad/svc_client",
		authorize(auth, model.ROLE_DRIVER, model.ROLE_CLIENT, model.ROLE_OWNER, model.ROLE_ADMIN),
		handler.GetToCreateAdClientSVC,
	)

	s.POST(
		"ad/svc_client",
		authorize(auth, model.ROLE_DRIVER, model.ROLE_CLIENT, model.ROLE_OWNER, model.ROLE_ADMIN),
		handler.SubscriptionToCreateAdClientSVC,
	)
	s.POST(
		"ad/svc_client/unsubscription",
		authorize(auth, model.ROLE_DRIVER, model.ROLE_CLIENT, model.ROLE_OWNER, model.ROLE_ADMIN),
		handler.UnsubscriptionToCreateAdClientSVC,
	)
}

// SubscriptionToCreateAdClientSM
// @Summary	Подписка на рассылку создание объявления клиентом (модуль спецтехника).
// @Accept		json
// @Produce	json
// @Tags		Subscription (подписка на рассылку)
// @Param		request	body		controller.SubscriptionToCreateAdClientSM.request	true	"идентификатор, подкатегории"
// @Success	200		{object}	map[string]interface{}
// @Failure	403		{object}	map[string]interface{}
// @Failure	400,404	{object}	map[string]interface{}
// @Failure	500		{object}	map[string]interface{}
// @Failure	default	{object}	map[string]interface{}
// @Router		/subscription/ad/sm_client [post]
func (handler *subscription) SubscriptionToCreateAdClientSM(c *gin.Context) {
	user, err := GetUserFromGin(c)
	if err != nil {
		c.JSON(http.StatusUnauthorized, gin.H{"error": err.Error()})
		return
	}

	type request struct {
		EquipmentSubCategoryID []int `json:"sub_category_id"`
		CityID                 []int `json:"city_id"`
	}

	r := request{}

	if err := c.BindJSON(&r); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	err = handler.service.SubscriptionToCreateAdClientSM(c, user.ID, r.EquipmentSubCategoryID, r.CityID)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"reason": "success"})
}

// SubscriptionToCreateAdClientEQ
// @Summary	Подписка на рассылку создание объявления клиентом (модуль оборудовании).
// @Accept		json
// @Produce	json
// @Tags		Subscription (подписка на рассылку)
// @Param		request	body		controller.SubscriptionToCreateAdClientEQ.request	true	"идентификатор, подкатегории"
// @Success	200		{object}	map[string]interface{}
// @Failure	403		{object}	map[string]interface{}
// @Failure	400,404	{object}	map[string]interface{}
// @Failure	500		{object}	map[string]interface{}
// @Failure	default	{object}	map[string]interface{}
// @Router		/subscription/ad/eq_client [post]
func (handler *subscription) SubscriptionToCreateAdClientEQ(c *gin.Context) {
	user, err := GetUserFromGin(c)
	if err != nil {
		c.JSON(http.StatusUnauthorized, gin.H{"error": err.Error()})
		return
	}

	type request struct {
		EquipmentSubCategoryID []int `json:"sub_category_id"`
		CityID                 []int `json:"city_id"`
	}

	r := request{}

	if err := c.BindJSON(&r); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	err = handler.service.SubscriptionToCreateAdClientEQ(c, user.ID, r.EquipmentSubCategoryID, r.CityID)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"reason": "success"})
}

// UnsubscriptionToCreateAdClientSM
// @Summary	Отписка на рассылку создание объявления клиентом (модуль спецтехника).
// @Accept		json
// @Produce	json
// @Tags		Subscription (подписка на рассылку)
// @Param		request	body		controller.UnsubscriptionToCreateAdClientSM.request	true	"идентификатор, подкатегории"
// @Success	200		{object}	map[string]interface{}
// @Failure	403		{object}	map[string]interface{}
// @Failure	400,404	{object}	map[string]interface{}
// @Failure	500		{object}	map[string]interface{}
// @Failure	default	{object}	map[string]interface{}
// @Router		/subscription/ad/sm_client/unsubscription [post]
func (handler *subscription) UnsubscriptionToCreateAdClientSM(c *gin.Context) {
	user, err := GetUserFromGin(c)
	if err != nil {
		c.JSON(http.StatusUnauthorized, gin.H{"error": err.Error()})
		return
	}

	type request struct {
		EquipmentSubCategoryID []int `json:"sub_category_id"`
	}

	r := request{}

	if err := c.BindJSON(&r); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	err = handler.service.UnsubscriptionToCreateAdClientSM(c, user.ID, r.EquipmentSubCategoryID)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"reason": "success"})
}

// UnsubscriptionToCreateAdClientEQ
// @Summary	Отписка на рассылку создание объявления клиентом (модуль оборудовании).
// @Accept		json
// @Produce	json
// @Tags		Subscription (подписка на рассылку)
// @Param		request	body		controller.UnsubscriptionToCreateAdClientEQ.request	true	"идентификатор, подкатегории"
// @Success	200		{object}	map[string]interface{}
// @Failure	403		{object}	map[string]interface{}
// @Failure	400,404	{object}	map[string]interface{}
// @Failure	500		{object}	map[string]interface{}
// @Failure	default	{object}	map[string]interface{}
// @Router		/subscription/ad/eq_client/unsubscription [post]
func (handler *subscription) UnsubscriptionToCreateAdClientEQ(c *gin.Context) {
	user, err := GetUserFromGin(c)
	if err != nil {
		c.JSON(http.StatusUnauthorized, gin.H{"error": err.Error()})
		return
	}

	type request struct {
		EquipmentSubCategoryID []int `json:"sub_category_id"`
	}

	r := request{}

	if err := c.BindJSON(&r); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	err = handler.service.UnsubscriptionToCreateAdClientEQ(c, user.ID, r.EquipmentSubCategoryID)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"reason": "success"})

}

// GetToCreateAdClientSM
// @Summary	Получения списка подписок на рассылку создание объявления клиентом (модуль оборудовании).
// @Accept		json
// @Produce	json
// @Tags		Subscription (подписка на рассылку)
// @Success	200		{object}	[]model.AdClientCreationSubscription
// @Failure	403		{object}	map[string]interface{}
// @Failure	400,404	{object}	map[string]interface{}
// @Failure	500		{object}	map[string]interface{}
// @Failure	default	{object}	map[string]interface{}
// @Router		/subscription/ad/sm_client [get]
func (handler *subscription) GetToCreateAdClientSM(c *gin.Context) {

	user, err := GetUserFromGin(c)
	if err != nil {
		c.JSON(http.StatusUnauthorized, gin.H{"error": err.Error()})
		return
	}

	subs, err := handler.service.GetToCreateAdClientSM(c, user.ID)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"subscriptions": subs})
}

// GetToCreateAdClientEQ
// @Summary	Получения списка подписок на рассылку создание объявления клиентом (модуль оборудовании).
// @Accept		json
// @Produce	json
// @Tags		Subscription (подписка на рассылку)
// @Success	200		{object}	[]model.AdClientCreationSubscription
// @Failure	403		{object}	map[string]interface{}
// @Failure	400,404	{object}	map[string]interface{}
// @Failure	500		{object}	map[string]interface{}
// @Failure	default	{object}	map[string]interface{}
// @Router		/subscription/ad/eq_client [get]
func (handler *subscription) GetToCreateAdClientEQ(c *gin.Context) {

	user, err := GetUserFromGin(c)
	if err != nil {
		c.JSON(http.StatusUnauthorized, gin.H{"error": err.Error()})
		return
	}

	subs, err := handler.service.GetToCreateAdClientEQ(c, user.ID)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"subscriptions": subs})
}

// GetToCreateAdClientCM
// @Summary	Получения списка подписок на рассылку создание объявления клиентом (модуль строй материалы).
// @Accept		json
// @Produce	json
// @Tags		Subscription (подписка на рассылку)
// @Success	200		{object}	[]model.AdClientCreationSubscription
// @Failure	403		{object}	map[string]interface{}
// @Failure	400,404	{object}	map[string]interface{}
// @Failure	500		{object}	map[string]interface{}
// @Failure	default	{object}	map[string]interface{}
// @Router		/subscription/ad/cm_client [get]
func (handler *subscription) GetToCreateAdClientCM(c *gin.Context) {

	user, err := GetUserFromGin(c)
	if err != nil {
		c.JSON(http.StatusUnauthorized, gin.H{"error": err.Error()})
		return
	}

	subs, err := handler.service.GetToCreateAdClientCM(c, user.ID)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"subscriptions": subs})
}

// SubscriptionToCreateAdClientCM
// @Summary	Подписка на рассылку создание объявления клиентом (модуль строй материалы).
// @Accept		json
// @Produce	json
// @Tags		Subscription (подписка на рассылку)
// @Param		request	body		controller.SubscriptionToCreateAdClientCM.request	true	"идентификатор, подкатегории"
// @Success	200		{object}	map[string]interface{}
// @Failure	403		{object}	map[string]interface{}
// @Failure	400,404	{object}	map[string]interface{}
// @Failure	500		{object}	map[string]interface{}
// @Failure	default	{object}	map[string]interface{}
// @Router		/subscription/ad/cm_client [post]
func (handler *subscription) SubscriptionToCreateAdClientCM(c *gin.Context) {
	user, err := GetUserFromGin(c)
	if err != nil {
		c.JSON(http.StatusUnauthorized, gin.H{"error": err.Error()})
		return
	}

	type request struct {
		SubCategoryID []int `json:"sub_category_id"`
		CityID        []int `json:"city_id"`
	}

	r := request{}

	if err := c.BindJSON(&r); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	err = handler.service.SubscriptionToCreateAdClientCM(c, user.ID, r.SubCategoryID, r.CityID)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"reason": "success"})
}

// UnsubscriptionToCreateAdClientCM
// @Summary	Отписка на рассылку создание объявления клиентом (модуль строй материалы).
// @Accept		json
// @Produce	json
// @Tags		Subscription (подписка на рассылку)
// @Param		request	body		controller.UnsubscriptionToCreateAdClientCM.request	true	"идентификатор, подкатегории"
// @Success	200		{object}	map[string]interface{}
// @Failure	403		{object}	map[string]interface{}
// @Failure	400,404	{object}	map[string]interface{}
// @Failure	500		{object}	map[string]interface{}
// @Failure	default	{object}	map[string]interface{}
// @Router		/subscription/ad/cm_client/unsubscription [post]
func (handler *subscription) UnsubscriptionToCreateAdClientCM(c *gin.Context) {
	user, err := GetUserFromGin(c)
	if err != nil {
		c.JSON(http.StatusUnauthorized, gin.H{"error": err.Error()})
		return
	}

	type request struct {
		SubCategoryID []int `json:"sub_category_id"`
	}

	r := request{}

	if err := c.BindJSON(&r); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	err = handler.service.UnsubscriptionToCreateAdClientEQ(c, user.ID, r.SubCategoryID)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"reason": "success"})

}

// GetToCreateAdClientSVC
// @Summary	Получения списка подписок на рассылку создание объявления клиентом (модуль услуг).
// @Accept		json
// @Produce	json
// @Tags		Subscription (подписка на рассылку)
// @Success	200		{object}	[]model.AdClientCreationSubscription
// @Failure	403		{object}	map[string]interface{}
// @Failure	400,404	{object}	map[string]interface{}
// @Failure	500		{object}	map[string]interface{}
// @Failure	default	{object}	map[string]interface{}
// @Router		/subscription/ad/svc_client [get]
func (handler *subscription) GetToCreateAdClientSVC(c *gin.Context) {

	user, err := GetUserFromGin(c)
	if err != nil {
		c.JSON(http.StatusUnauthorized, gin.H{"error": err.Error()})
		return
	}

	subs, err := handler.service.GetToCreateAdClientSVC(c, user.ID)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"subscriptions": subs})
}

// SubscriptionToCreateAdClientSVC
// @Summary	Подписка на рассылку создание объявления клиентом (модуль услуги).
// @Accept		json
// @Produce	json
// @Tags		Subscription (подписка на рассылку)
// @Param		request	body		controller.SubscriptionToCreateAdClientSVC.request	true	"идентификатор, подкатегории"
// @Success	200		{object}	map[string]interface{}
// @Failure	403		{object}	map[string]interface{}
// @Failure	400,404	{object}	map[string]interface{}
// @Failure	500		{object}	map[string]interface{}
// @Failure	default	{object}	map[string]interface{}
// @Router		/subscription/ad/svc_client [post]
func (handler *subscription) SubscriptionToCreateAdClientSVC(c *gin.Context) {
	user, err := GetUserFromGin(c)
	if err != nil {
		c.JSON(http.StatusUnauthorized, gin.H{"error": err.Error()})
		return
	}

	type request struct {
		SubCategoryID []int `json:"sub_category_id"`
		CityID        []int `json:"city_id"`
	}

	r := request{}

	if err := c.BindJSON(&r); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	err = handler.service.SubscriptionToCreateAdClientSVC(c, user.ID, r.SubCategoryID, r.CityID)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"reason": "success"})
}

// UnsubscriptionToCreateAdClientSVC
// @Summary	Отписка на рассылку создание объявления клиентом (модуль услугу).
// @Accept		json
// @Produce	json
// @Tags		Subscription (подписка на рассылку)
// @Param		request	body		controller.UnsubscriptionToCreateAdClientSVC.request	true	"идентификатор, подкатегории"
// @Success	200		{object}	map[string]interface{}
// @Failure	403		{object}	map[string]interface{}
// @Failure	400,404	{object}	map[string]interface{}
// @Failure	500		{object}	map[string]interface{}
// @Failure	default	{object}	map[string]interface{}
// @Router		/subscription/ad/svc_client/unsubscription [post]
func (handler *subscription) UnsubscriptionToCreateAdClientSVC(c *gin.Context) {
	user, err := GetUserFromGin(c)
	if err != nil {
		c.JSON(http.StatusUnauthorized, gin.H{"error": err.Error()})
		return
	}

	type request struct {
		SubCategoryID []int `json:"sub_category_id"`
	}

	r := request{}

	if err := c.BindJSON(&r); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	err = handler.service.UnsubscriptionToCreateAdClientSVC(c, user.ID, r.SubCategoryID)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"reason": "success"})

}
