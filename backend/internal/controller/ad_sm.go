package controller

import (
	"context"
	"encoding/json"
	"errors"
	"fmt"
	"log"
	"mime/multipart"
	"net/http"
	"strconv"
	"strings"
	"time"

	"github.com/gin-gonic/gin"
	"github.com/redis/go-redis/v9"
	"gitlab.com/eqshare/eqshare-back/internal/service"
	"gitlab.com/eqshare/eqshare-back/model"
	"gitlab.com/eqshare/eqshare-back/pkg/util"
)

// adSpecializedMachinery is our controller struct for /ad_sm endpoints.
type adSpecializedMachinery struct {
	service    service.IAdSpecializedMachinery
	uService   service.IUser
	asmService service.IAdSpecializedMachinery
	cache      *redis.Client // the Redis client for caching
}

// NewAdSpecializedMachinery sets up the routes for /ad_sm and returns the controller.
func NewAdSpecializedMachinery(r *gin.Engine, auth service.IAuthentication,
	svc service.IAdSpecializedMachinery,
	uService service.IUser,
	asmService service.IAdSpecializedMachinery,
	redisClient *redis.Client,
	middleware ...gin.HandlerFunc) {
	handler := &adSpecializedMachinery{
		service:    svc,
		uService:   uService,
		asmService: asmService,
		cache:      redisClient,
	}

	adsm := r.Group("/ad_sm")
	// Register routes (ensure no duplicate GET "/" is defined elsewhere)
	adsm.PUT("/:id/rate", CheckToken(auth), handler.SMRate)
	adsm.GET("/", handler.GetAdSpecializedMachineries)
	adsm.GET("/:id", handler.GetByID)
	adsm.POST("", authorize(auth, model.ROLE_DRIVER, model.ROLE_OWNER, model.ROLE_ADMIN, model.ROLE_CLIENT), handler.Create)
	adsm.PUT("/:id/base", authorize(auth, model.ROLE_DRIVER, model.ROLE_OWNER, model.ROLE_ADMIN, model.ROLE_CLIENT), handler.UpdateBase)
	adsm.PUT("/:id/foto", authorize(auth, model.ROLE_DRIVER, model.ROLE_OWNER, model.ROLE_ADMIN, model.ROLE_CLIENT), handler.UpdateFoto)
	adsm.DELETE("/:id", authorize(auth, model.ROLE_DRIVER, model.ROLE_OWNER, model.ROLE_ADMIN, model.ROLE_CLIENT), handler.Delete)
	adsm.POST("/:id/interacted", authorize(auth, model.ROLE_CLIENT), handler.Interacted)
	adsm.GET("/:id/interacted", authorize(auth, model.ROLE_DRIVER), handler.GetInteracted)
	adsm.GET("/favorite", authorize(auth, model.ROLE_ADMIN, model.ROLE_DRIVER, model.ROLE_OWNER, model.ROLE_CLIENT), handler.GetFavorite)
	adsm.POST("/:id/favorite", authorize(auth, model.ROLE_ADMIN, model.ROLE_DRIVER, model.ROLE_OWNER, model.ROLE_CLIENT), handler.CreateFavority)
	adsm.DELETE("/:id/favorite", authorize(auth, model.ROLE_ADMIN, model.ROLE_DRIVER, model.ROLE_OWNER, model.ROLE_CLIENT), handler.DeleteFavorite)
	adsm.GET("/:id/seen", handler.GetSeen)
	adsm.POST("/:id/seen", handler.IncrementSeen)
}

// GetAdSpecializedMachineries handles GET /ad_sm with caching.
func (a *adSpecializedMachinery) GetAdSpecializedMachineries(c *gin.Context) {
	// Log the raw query string for later analysis.
	log.Printf("Received GET /ad_sm request with query: %s", c.Request.URL.RawQuery)

	// Parse filters and log them.
	f, err := a.parseFilters(c)
	if err != nil {
		log.Printf("Error parsing filters: %v", err)
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	log.Printf("Parsed filters: %+v", f)

	// Build a caching key based on the query parameters.
	cacheKey := a.buildCacheKey(f)
	log.Printf("Using cache key: %s", cacheKey)

	// Try to retrieve from Redis.
	val, err := a.cache.Get(context.Background(), cacheKey).Bytes()
	if err == nil && len(val) > 0 {
		log.Printf("Cache hit for key: %s", cacheKey)
		c.Data(http.StatusOK, "application/json", val)
		return
	}
	log.Printf("Cache miss for key: %s", cacheKey)

	// Fetch from DB via the service.
	adMachineries, total, err := a.asmService.Get(c.Request.Context(), f)
	if err != nil {
		log.Printf("Error fetching ads from service: %v", err)
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	log.Printf("Retrieved %d ads (total: %d)", len(adMachineries), total)

	// Construct and cache the response.
	resp := gin.H{
		"ad_specialized_machinery": adMachineries,
		"total":                    total,
	}
	jsonData, err := json.Marshal(resp)
	if err == nil {
		a.cache.Set(context.Background(), cacheKey, jsonData, 5*time.Minute)
	}
	c.JSON(http.StatusOK, resp)
}

// parseFilters extracts query parameters into a FilterAdSpecializedMachinery struct.
func (a *adSpecializedMachinery) parseFilters(c *gin.Context) (model.FilterAdSpecializedMachinery, error) {
	var f model.FilterAdSpecializedMachinery

	// Parse limit
	if v := c.Query("limit"); v != "" {
		if num, err := strconv.Atoi(v); err == nil {
			f.Limit = &num
		} else {
			return f, fmt.Errorf("invalid limit param: %v", err)
		}
	}

	// Parse offset
	if v := c.Query("offset"); v != "" {
		if num, err := strconv.Atoi(v); err == nil {
			f.Offset = &num
		} else {
			return f, fmt.Errorf("invalid offset param: %v", err)
		}
	}

	// Parse boolean flags.
	if b, err := parseBoolParam(c, "user_detail"); err == nil && b != nil {
		f.UserDetail = b
	}
	if b, err := parseBoolParam(c, "brand_detail"); err == nil && b != nil {
		f.BrandDetail = b
	}
	if b, err := parseBoolParam(c, "type_detail"); err == nil && b != nil {
		f.TypeDetail = b
	}
	if b, err := parseBoolParam(c, "city_detail"); err == nil && b != nil {
		f.CityDetail = b
	}
	if b, err := parseBoolParam(c, "document_detail"); err == nil && b != nil {
		f.DocumentDetail = b
	}
	if b, err := parseBoolParam(c, "unscoped"); err == nil && b != nil {
		f.Unscoped = b
	}

	// Parse city_id
	if cid := c.Query("city_id"); cid != "" {
		if num, err := strconv.Atoi(cid); err == nil {
			f.CityID = &num
		} else {
			return f, fmt.Errorf("invalid city_id param: %v", err)
		}
	}

	// Parse type_id
	if tid := c.Query("type_id"); tid != "" {
		if num, err := strconv.Atoi(tid); err == nil {
			f.TypeID = &num
		} else {
			return f, fmt.Errorf("invalid type_id param: %v", err)
		}
	}

	// Parse sub_category_id
	if scid := c.Query("sub_category_id"); scid != "" {
		if num, err := strconv.Atoi(scid); err == nil {
			f.SubCategoryID = &num
		} else {
			return f, fmt.Errorf("invalid sub_category_id: %v", err)
		}
	}

	// Parse ASC and DESC arrays
	if ascArr, ok := c.GetQueryArray("ASC"); ok && len(ascArr) > 0 {
		f.ASC = ascArr
	}
	if descArr, ok := c.GetQueryArray("DESC"); ok && len(descArr) > 0 {
		f.DESC = descArr
	}

	// Parse user_id array
	if uidArr, ok := c.GetQueryArray("user_id"); ok && len(uidArr) > 0 {
		for _, s := range uidArr {
			if num, err := strconv.Atoi(s); err == nil {
				f.UserID = append(f.UserID, num)
			}
		}
	}

	// Parse name and description for partial matching
	if name := c.Query("name"); name != "" {
		f.Name = &name
	}
	if desc := c.Query("description"); desc != "" {
		f.Description = &desc
	}

	// (Parsing numeric parameter ranges like price, body_height, etc. is omitted for brevity.)

	return f, nil
}

// buildCacheKey constructs a cache key string from filter values.
func (a *adSpecializedMachinery) buildCacheKey(f model.FilterAdSpecializedMachinery) string {
	var sb strings.Builder
	sb.WriteString("ad_sm:")
	if f.CityID != nil {
		sb.WriteString(fmt.Sprintf("city_%d:", *f.CityID))
	}
	if f.TypeID != nil {
		sb.WriteString(fmt.Sprintf("type_%d:", *f.TypeID))
	}
	if f.SubCategoryID != nil {
		sb.WriteString(fmt.Sprintf("sub_%d:", *f.SubCategoryID))
	}
	if len(f.UserID) > 0 {
		sb.WriteString(fmt.Sprintf("users_%v:", f.UserID))
	}
	if f.Name != nil {
		sb.WriteString(fmt.Sprintf("name_%s:", *f.Name))
	}
	if f.Description != nil {
		sb.WriteString(fmt.Sprintf("desc_%s:", *f.Description))
	}
	if f.Limit != nil {
		sb.WriteString(fmt.Sprintf("limit_%d:", *f.Limit))
	}
	if f.Offset != nil {
		sb.WriteString(fmt.Sprintf("offset_%d:", *f.Offset))
	}
	key := sb.String()
	if strings.HasSuffix(key, ":") {
		key = key[:len(key)-1]
	}
	if key == "ad_sm" {
		key = "ad_sm:all"
	}
	return key
}

// parseBoolParam is a helper to parse boolean query parameters.
func parseBoolParam(c *gin.Context, param string) (*bool, error) {
	val := c.Query(param)
	if val == "" {
		return nil, nil
	}
	b, err := strconv.ParseBool(val)
	if err != nil {
		return nil, err
	}
	return &b, nil
}

// setFilter is a helper to parse numeric range filters (using your model.Parse).
func (a *adSpecializedMachinery) setFilter(c *gin.Context, paramName string) (model.ParamMinMax, error) {
	v, ok := c.GetQuery(paramName)
	if !ok {
		return model.ParamMinMax{}, nil
	}
	p, err := model.Parse(v)
	if err != nil {
		return model.ParamMinMax{}, err
	}
	return p, nil
}

// GetByID returns a single adSpecializedMachinery by its ID.
func (a *adSpecializedMachinery) GetByID(c *gin.Context) {
	id, err := strconv.Atoi(c.Param("id"))
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	adsm, err := a.service.GetByID(id)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusOK, gin.H{"ad_specialized_machinery": adsm})
}

// Create creates a new adSpecializedMachinery.
func (a *adSpecializedMachinery) Create(c *gin.Context) {
	adsm := model.AdSpecializedMachinery{}
	user, err := GetUserFromGin(c)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	if user.AccessRole == model.ROLE_ADMIN {
		user.ID, _ = strconv.Atoi(c.Query("user_id"))
		user, err = a.uService.GetByID(user.ID)
		if err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"reason": fmt.Sprintf("invalid input error: %s", err.Error())})
			return
		}
	}
	adsm.UserID = user.ID

	mf, err := c.MultipartForm()
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	if len(mf.Value["name"]) != 0 {
		adsm.Name = mf.Value["name"][0]
	}
	if len(mf.Value["brand_id"]) != 0 {
		id, err := strconv.Atoi(mf.Value["brand_id"][0])
		if err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
			return
		}
		adsm.BrandID = id
	}
	if len(mf.Value["type_id"]) != 0 {
		id, err := strconv.Atoi(mf.Value["type_id"][0])
		if err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
			return
		}
		adsm.TypeID = id
	}
	if len(mf.Value["city_id"]) != 0 {
		id, err := strconv.Atoi(mf.Value["city_id"][0])
		if err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
			return
		}
		if model.Kazakstan != id {
			adsm.CityID = id
		}
	}
	if len(mf.Value["price"]) != 0 {
		price, err := strconv.ParseFloat(mf.Value["price"][0], 64)
		if err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
			return
		}
		adsm.Price = price
	}
	if len(mf.Value["description"]) != 0 {
		adsm.Description = mf.Value["description"][0]
	}
	if len(mf.Value["address"]) != 0 {
		adsm.Address = mf.Value["address"][0]
	}
	if len(mf.Value["latitude"]) != 0 {
		n, err := strconv.ParseFloat(mf.Value["latitude"][0], 64)
		if err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": "latitude: " + err.Error()})
			return
		}
		adsm.Latitude = &n
	}
	if len(mf.Value["longitude"]) != 0 {
		n, err := strconv.ParseFloat(mf.Value["longitude"][0], 64)
		if err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": "longitude: " + err.Error()})
			return
		}
		adsm.Longitude = &n
	}
	p, err := a.parseParamByMF(mf)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	adsm.Params = p
	for _, fh := range mf.File["foto"] {
		doc, err := util.ParseDocumentOnMultipart(fh)
		if err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
			return
		}
		doc.UserID = user.ID
		adsm.Document = append(adsm.Document, doc)
	}
	id, err := a.service.Create(c, adsm)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	_ = id
	c.JSON(http.StatusOK, gin.H{"status": "success"})
}

func (h *adSpecializedMachinery) parseParamByMF(mf *multipart.Form) (model.AdSpecializedMachinerieParams, error) {
	p := model.AdSpecializedMachinerieParams{}
	// Example parsing for one field; add others as needed.
	if len(mf.Value["body_height"]) != 0 {
		v, err := strconv.ParseFloat(mf.Value["body_height"][0], 64)
		if err != nil {
			return p, fmt.Errorf("parse body_height: %w", err)
		}
		p.BodyHeight = &v
	}
	// ... (parse other numeric parameters similarly)
	return p, nil
}

func (a *adSpecializedMachinery) UpdateBase(c *gin.Context) {
	adsm := model.AdSpecializedMachinery{}
	id, err := strconv.Atoi(c.Param("id"))
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	adsm.ID = id
	user, err := GetUserFromGin(c)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	if user.AccessRole == model.ROLE_ADMIN {
		user.ID, _ = strconv.Atoi(c.Query("user_id"))
		user, err = a.uService.GetByID(user.ID)
		if err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"reason": fmt.Sprintf("invalid input: %s", err.Error())})
			return
		}
	}
	adsm.UserID = user.ID
	mf, err := c.MultipartForm()
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	if len(mf.Value["name"]) != 0 {
		adsm.Name = mf.Value["name"][0]
	}
	if len(mf.Value["brand_id"]) != 0 {
		id, err := strconv.Atoi(mf.Value["brand_id"][0])
		if err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
			return
		}
		adsm.BrandID = id
	}
	if len(mf.Value["type_id"]) != 0 {
		id, err := strconv.Atoi(mf.Value["type_id"][0])
		if err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
			return
		}
		adsm.TypeID = id
	}
	if len(mf.Value["city_id"]) != 0 {
		id, err := strconv.Atoi(mf.Value["city_id"][0])
		if err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
			return
		}
		if model.Kazakstan != id {
			adsm.CityID = id
		}
	}
	if len(mf.Value["price"]) != 0 {
		price, err := strconv.ParseFloat(mf.Value["price"][0], 64)
		if err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
			return
		}
		adsm.Price = price
	}
	if len(mf.Value["description"]) != 0 {
		adsm.Description = mf.Value["description"][0]
	}
	for _, fh := range mf.File["foto"] {
		doc, err := util.ParseDocumentOnMultipart(fh)
		if err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
			return
		}
		doc.UserID = user.ID
		adsm.Document = append(adsm.Document, doc)
	}
	if err := a.service.Update(adsm); err != nil {
		if errors.Is(err, model.ErrAccessDenied) {
			c.JSON(http.StatusForbidden, gin.H{"error": fmt.Sprintf("user is not the author: %v", err.Error())})
			return
		}
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusOK, gin.H{"status": "success"})
}

func (a *adSpecializedMachinery) UpdateFoto(c *gin.Context) {
	adsm := model.AdSpecializedMachinery{}
	id, err := strconv.Atoi(c.Param("id"))
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	adsm.ID = id
	user, err := GetUserFromGin(c)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	if user.AccessRole == model.ROLE_ADMIN {
		user.ID, _ = strconv.Atoi(c.Query("user_id"))
		user, err = a.uService.GetByID(user.ID)
		if err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"reason": fmt.Sprintf("invalid input: %s", err.Error())})
			return
		}
	}
	adsm.UserID = user.ID
	mf, err := c.MultipartForm()
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	for _, fh := range mf.File["foto"] {
		doc, err := util.ParseDocumentOnMultipart(fh)
		if err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
			return
		}
		doc.UserID = user.ID
		adsm.Document = append(adsm.Document, doc)
	}
	if err := a.service.UpdateFoto(adsm); err != nil {
		if errors.Is(err, model.ErrAccessDenied) {
			c.JSON(http.StatusForbidden, gin.H{"error": fmt.Sprintf("user is not the author: %v", err.Error())})
			return
		}
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusOK, gin.H{"status": "success"})
}

func (a *adSpecializedMachinery) Delete(c *gin.Context) {
	id, err := strconv.Atoi(c.Param("id"))
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	if err := a.service.Delete(id); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusOK, gin.H{"status": "success"})
}

func (a *adSpecializedMachinery) Interacted(c *gin.Context) {
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
	if err := a.service.Interacted(id, user.ID); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusOK, gin.H{"status": "success"})
}

func (a *adSpecializedMachinery) GetInteracted(c *gin.Context) {
	id, err := strconv.Atoi(c.Param("id"))
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	interacts, err := a.service.GetInteracted(id)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusOK, gin.H{"ad_service_interacted": interacts})
}

func (a *adSpecializedMachinery) SMRate(ctx *gin.Context) {
	var sbCategory model.AdSpecializedMachinery
	sbCategory.ID, _ = strconv.Atoi(ctx.Param("id"))
	rate, _ := strconv.Atoi(ctx.Query("rate"))
	if err := a.service.SMRate(rate, sbCategory); err != nil {
		ctx.JSON(http.StatusInternalServerError, gin.H{"reason": err.Error()})
		return
	}
	ctx.JSON(http.StatusOK, gin.H{"reason": "success"})
}

func (a *adSpecializedMachinery) CreateFavority(c *gin.Context) {
	user, err := GetUserFromGin(c)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	f := model.FavoriteAdSpecializedMachinery{}
	id, err := strconv.Atoi(c.Param("id"))
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	f.UserID = user.ID
	f.AdSpecializedMachineryID = id
	if err := a.service.CreateFavorite(c, f); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusOK, gin.H{"status": "success"})
}

func (a *adSpecializedMachinery) GetFavorite(c *gin.Context) {
	user, err := GetUserFromGin(c)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	fav, err := a.service.GetFavorite(c, user.ID)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusOK, gin.H{"favorites": fav})
}

func (a *adSpecializedMachinery) DeleteFavorite(c *gin.Context) {
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
	if err := a.service.DeleteFavorite(c, model.FavoriteAdSpecializedMachinery{
		UserID:                   user.ID,
		AdSpecializedMachineryID: id,
	}); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusOK, gin.H{"status": "success"})
}

func (h *adSpecializedMachinery) GetSeen(c *gin.Context) {
	id, err := strconv.Atoi(c.Param("id"))
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"parameter": "id", "error": err.Error()})
		return
	}
	count, err := h.service.GetSeen(c, id)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusOK, gin.H{"count": count})
}

func (h *adSpecializedMachinery) IncrementSeen(c *gin.Context) {
	id, err := strconv.Atoi(c.Param("id"))
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"parameter": "id", "error": err.Error()})
		return
	}
	err = h.service.IncrementSeen(c, id)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusOK, gin.H{"status": "success"})
}
