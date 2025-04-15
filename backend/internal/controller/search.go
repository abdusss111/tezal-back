package controller

import (
	"fmt"
	"log"
	"net/http"
	"strconv"
	"strings"

	"github.com/gin-gonic/gin"
	"gitlab.com/eqshare/eqshare-back/internal/service"
	"gitlab.com/eqshare/eqshare-back/model"
)

type search struct {
	searchS service.ISearch
}

func NewSearch(r *gin.Engine, searchS service.ISearch) {
	h := search{searchS: searchS}

	s := r.Group("search")

	s.GET("", h.Search)
	s.GET("sm", h.SearchSM)
}

// SearchSM
// @Summary		Redirect to search endpoint
// @Description	Redirects to the search endpoint with status code 301
// @Success		301
// @Router			/search/sm [get]
func (h *search) SearchSM(c *gin.Context) {
	c.Redirect(http.StatusMovedPermanently, "")
}

// Search
// @Summary		Поиск общий
// @Description	Поиск происходит по: категориям спецтехники, подкатегориям спецтехники, категориям оборудование, подкатегориям оборудование,
// @Description	титулу объявления спецтехники, титулу объявления клиента спецтехники, титулу объявления оборудование, титулу объявления клиента оборудование
// @Description	титулу объявления строй материалов, титулу объявления клиента строй материалов.
// @Description	титулу объявления услуг, титулу объявления клиента услуг.
// @Description	Поиск по титулу объявления происходит по принципу сравнение строки с подстрокой без учета регистра.
// @Description	Поиск по категориям и подкатегориям происходит по принципу сравнение строки с подстрокой без учета регистра.
// @Description	При нахождении в подкатегориях совпадения возвращается категория и внутри результат нахождения.
// @Description	При помощи query можно проводить поиск по конкретным модулям
// @Security		ApiKeyAuth
// @Accept			json
// @Produce		json
// @Tags			Search
// @Param			general								query		string	true	"поиск будет поводится по этому слову"
// @Param			category_sm_detail					query		bool	false	"поиск по категориям и подкатегориям модуля спецтехники"	default(true)
// @Param			category_eq_detail					query		bool	false	"поиск по категориям и подкатегориям модуля оборудование"	default(true)
// @Param			ad_specialized_machineries_detail	query		bool	false	"поиск по объявлениям спецтехники"							default(true)
// @Param			ad_clients_detail					query		bool	false	"поиск по объявлениям клиента спецтехники"					default(true)
// @Param			ad_equipments_detail				query		bool	false	"поиск по объявлениям оборудование"							default(true)
// @Param			ad_equipment_clients_detail			query		bool	false	"поиск по объявлениям клиента оборудование"					default(true)
// @Param			ad_construction_material_detail				query		bool	false	"поиск по объявлениям строй материалов"							default(true)
// @Param			ad_construction_material_clients_detail			query		bool	false	"поиск по объявлениям клиента строй материалов"					default(true)
// @Param			city_id								query		int		false	"фильтр города, если не передавать по поиск будет проходит по всем городам"
// @Param			limit								query		int		false	"лимит, работает только на объявления"
// @Param			offset								query		int		false	"сдвиг, работает только на объявления"
// @Success		200									{object}	model.SearchSMResult
// @Failure		403									{object}	map[string]interface{}
// @Failure		400,404								{object}	map[string]interface{}
// @Failure		500									{object}	map[string]interface{}
// @Failure		default								{object}	map[string]interface{}
// @Router			/search [get]
func (h *search) Search(c *gin.Context) {
	f := model.FilterSearch{}

	if general, ok := c.GetQuery("general"); ok {
		f.General = general
	} else {
		c.JSON(http.StatusBadRequest, gin.H{"general": "empty"})
		return
	}

	if v, ok := c.GetQuery("limit"); ok {
		n, err := strconv.Atoi(v)
		if err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error query limit": err.Error()})
			return
		}
		f.Limit = &n
		log.Println("controller")

		log.Println(*f.Limit)

	}

	if v, ok := c.GetQuery("offset"); ok {
		n, err := strconv.Atoi(v)
		if err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error query offset": err.Error()})
			return
		}
		f.Offset = &n
	}

	paramFilters := map[string]string{
		"price_min":                        "params.price",
		"price_max":                        "params.price",
		"body_height_min":                  "params.body_height",
		"body_height_max":                  "params.body_height",
		"lift_height_min":                  "params.lift_height",
		"lift_height_max":                  "params.lift_height",
		"blade_cutting_depth_min":          "params.blade_cutting_depth",
		"blade_cutting_depth_max":          "params.blade_cutting_depth",
		"fence_depth_min":                  "params.fence_depth",
		"fence_depth_max":                  "params.fence_depth",
		"grip_depth_min":                   "params.grip_depth",
		"grip_depth_max":                   "params.grip_depth",
		"digging_depth_min":                "params.digging_depth",
		"digging_depth_max":                "params.digging_depth",
		"load_capacity_min":                "params.load_capacity",
		"load_capacity_max":                "params.load_capacity",
		"air_pressure_min":                 "params.air_pressure",
		"air_pressure_max":                 "params.air_pressure",
		"drilling_diameter_min":            "params.drilling_diameter",
		"drilling_diameter_max":            "params.drilling_diameter",
		"roller_diameter_min":              "params.roller_diameter",
		"roller_diameter_max":              "params.roller_diameter",
		"body_length_min":                  "params.body_length",
		"body_length_max":                  "params.body_length",
		"platform_length_min":              "params.platform_length",
		"platform_length_max":              "params.platform_length",
		"boom_length_min":                  "params.boom_length",
		"boom_length_max":                  "params.boom_length",
		"ground_clearance_min":             "params.ground_clearance",
		"ground_clearance_max":             "params.ground_clearance",
		"fuel_tank_capacity_min":           "params.fuel_tank_capacity",
		"fuel_tank_capacity_max":           "params.fuel_tank_capacity",
		"number_of_rollers_min":            "params.number_of_rollers",
		"number_of_rollers_max":            "params.number_of_rollers",
		"number_of_axles_min":              "params.number_of_axles",
		"number_of_axles_max":              "params.number_of_axles",
		"maximum_drilling_depth_min":       "params.maximum_drilling_depth",
		"maximum_drilling_depth_max":       "params.maximum_drilling_depth",
		"engine_power_min":                 "params.engine_power",
		"engine_power_max":                 "params.engine_power",
		"voltage_min":                      "params.voltage",
		"voltage_max":                      "params.voltage",
		"water_tank_volume_min":            "params.water_tank_volume",
		"water_tank_volume_max":            "params.water_tank_volume",
		"bucket_volume_min":                "params.bucket_volume",
		"bucket_volume_max":                "params.bucket_volume",
		"body_volume_min":                  "params.body_volume",
		"body_volume_max":                  "params.body_volume",
		"tank_volume_min":                  "params.tank_volume",
		"tank_volume_max":                  "params.tank_volume",
		"operating_pressure_min":           "params.operating_pressure",
		"operating_pressure_max":           "params.operating_pressure",
		"unloading_radius_min":             "params.unloading_radius",
		"unloading_radius_max":             "params.unloading_radius",
		"turning_radius_min":               "params.turning_radius",
		"turning_radius_max":               "params.turning_radius",
		"refrigerator_temperature_min_min": "params.refrigerator_temperature_min",
		"refrigerator_temperature_min_max": "params.refrigerator_temperature_min",
		"refrigerator_temperature_max_min": "params.refrigerator_temperature_max",
		"refrigerator_temperature_max_max": "params.refrigerator_temperature_max",
		"temperature_range_min":            "params.temperature_range",
		"temperature_range_max":            "params.temperature_range",
		"roller_type_min":                  "params.roller_type",
		"roller_type_max":                  "params.roller_type",
		"body_type_min":                    "params.body_type",
		"body_type_max":                    "params.body_type",
		"pump_type_min":                    "params.pump_type",
		"pump_type_max":                    "params.pump_type",
		"platform_type_min":                "params.platform_type",
		"platform_type_max":                "params.platform_type",
		"welding_source_type_min":          "params.welding_source_type",
		"welding_source_type_max":          "params.welding_source_type",
		"undercarriage_type_min":           "params.undercarriage_type",
		"undercarriage_type_max":           "params.undercarriage_type",
		"blade_tilt_angle_min":             "params.blade_tilt_angle",
		"blade_tilt_angle_max":             "params.blade_tilt_angle",
		"frequency_min":                    "params.frequency",
		"frequency_max":                    "params.frequency",
		"roller_width_min":                 "params.roller_width",
		"roller_width_max":                 "params.roller_width",
		"grip_width_min":                   "params.grip_width",
		"grip_width_max":                   "params.grip_width",
		"digging_width_min":                "params.digging_width",
		"digging_width_max":                "params.digging_width",
		"body_width_min":                   "params.body_width",
		"body_width_max":                   "params.body_width",
		"platform_width_min":               "params.platform_width",
		"platform_width_max":               "params.platform_width",
		"unloading_gap_width_min":          "params.unloading_gap_width",
		"unloading_gap_width_max":          "params.unloading_gap_width",
		"laying_width_min":                 "params.laying_width",
		"laying_width_max":                 "params.laying_width",
		"milling_width_min":                "params.milling_width",
		"milling_width_max":                "params.milling_width",
		"weight_min":                       "params.weight",
		"weight_max":                       "params.weight",
		"reach_min":                        "params.reach",
		"reach_max":                        "params.reach",
		"height_min":                       "params.height",
		"height_max":                       "params.height",
		"lifting_height_min":               "params.lifting_height",
		"lifting_height_max":               "params.lifting_height",
		"working_depth_min":                "params.working_depth",
		"working_depth_max":                "params.working_depth",
		"cutting_depth_min":                "params.cutting_depth",
		"cutting_depth_max":                "params.cutting_depth",
		"load_capacity_kg_min":             "params.load_capacity_kg",
		"load_capacity_kg_max":             "params.load_capacity_kg",
		"load_capacity_t_min":              "params.load_capacity_t",
		"load_capacity_t_max":              "params.load_capacity_t",
		"bending_diameter_min":             "params.bending_diameter",
		"bending_diameter_max":             "params.bending_diameter",
		"machining_diameter_min":           "params.machining_diameter",
		"machining_diameter_max":           "params.machining_diameter",
		"chuck_diameter_min":               "params.chuck_diameter",
		"chuck_diameter_max":               "params.chuck_diameter",
		"saw_blade_diameter_min":           "params.saw_blade_diameter",
		"saw_blade_diameter_max":           "params.saw_blade_diameter",
		"cutting_diameter_min":             "params.cutting_diameter",
		"cutting_diameter_max":             "params.cutting_diameter",
		"pipe_diameter_min":                "params.pipe_diameter",
		"pipe_diameter_max":                "params.pipe_diameter",
		"angle_measuring_range_min":        "params.angle_measuring_range",
		"angle_measuring_range_max":        "params.angle_measuring_range",
		"hose_length_min":                  "params.hose_length",
		"hose_length_max":                  "params.hose_length",
		"hose_diameter_min":                "params.hose_diameter",
		"hose_diameter_max":                "params.hose_diameter",
		"measuring_length_min":             "params.measuring_length",
		"measuring_length_max":             "params.measuring_length",
		"saw_band_length_min":              "params.saw_band_length",
		"saw_band_length_max":              "params.saw_band_length",
		"saw_band_width_min":               "params.saw_band_width",
		"saw_band_width_max":               "params.saw_band_width",
	}

	queryFilters := []map[string]interface{}{}

	if cityID, ok := c.GetQuery("city_id"); ok {
		id, err := strconv.Atoi(cityID)
		if err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": fmt.Sprintf("Invalid city_id: %v", err)})
			return
		}
		queryFilters = append(queryFilters, map[string]interface{}{
			"term": map[string]interface{}{
				"city_id": id,
			},
		})
	}

	for queryParam, field := range paramFilters {
		if value := c.Query(queryParam); value != "" {
			floatValue, err := strconv.ParseFloat(value, 64)
			if err != nil {
				c.JSON(http.StatusBadRequest, gin.H{"error": fmt.Sprintf("Invalid value for %s: %v", queryParam, err)})
				return
			}

			filterType := "gte" // Default to greater than or equal
			if strings.HasSuffix(queryParam, "_max") {
				filterType = "lte" // Change to less than or equal for max
			}

			queryFilters = append(queryFilters, map[string]interface{}{
				"range": map[string]interface{}{
					field: map[string]interface{}{
						filterType: floatValue,
					},
				},
			})
		}
	}

	if val, ok := c.GetQuery("category_sm_detail"); ok {
		v, err := strconv.ParseBool(val)
		if err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"category_sm_detail": err.Error()})
			return
		}
		f.CategorySmDetail = &v
	}
	if val, ok := c.GetQuery("category_eq_detail"); ok {
		v, err := strconv.ParseBool(val)
		if err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"category_eq_detail": err.Error()})
			return
		}
		f.CategoryEqDetail = &v
	}
	if val, ok := c.GetQuery("ad_specialized_machineries_detail"); ok {
		v, err := strconv.ParseBool(val)
		if err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"ad_specialized_machineries_detail": err.Error()})
			return
		}
		f.AdSpecializedMachineriesDetail = &v
	}
	if val, ok := c.GetQuery("ad_clients_detail"); ok {
		v, err := strconv.ParseBool(val)
		if err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"ad_clients_detail": err.Error()})
			return
		}
		f.AdClientsDetail = &v
	}
	if val, ok := c.GetQuery("ad_equipments_detail"); ok {
		v, err := strconv.ParseBool(val)
		if err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"ad_equipments_detail": err.Error()})
			return
		}
		f.AdEquipmentsDetail = &v
	}
	if val, ok := c.GetQuery("ad_equipment_clients_detail"); ok {
		v, err := strconv.ParseBool(val)
		if err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"ad_equipment_clients_detail": err.Error()})
			return
		}
		f.AdEquipmentClientsDetail = &v
	}

	if val, ok := c.GetQuery("ad_construction_material_detail"); ok {
		v, err := strconv.ParseBool(val)
		if err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"ad_construction_material_detail": err.Error()})
			return
		}
		f.AdConstructionMaterialDetail = &v
	}
	if val, ok := c.GetQuery("ad_construction_material_clients_detail"); ok {
		v, err := strconv.ParseBool(val)
		if err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"ad_construction_material_clients_detail": err.Error()})
			return
		}
		f.AdConstructionMaterialClientsDetail = &v
	}

	if val, ok := c.GetQuery("ad_service_detail"); ok {
		v, err := strconv.ParseBool(val)
		if err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"ad_service_detail": err.Error()})
			return
		}
		f.AdServiceDetail = &v
	}
	if val, ok := c.GetQuery("ad_service_clients_detail"); ok {
		v, err := strconv.ParseBool(val)
		if err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"ad_service_clients_detail": err.Error()})
			return
		}
		f.AdServiceClientsDetail = &v
	}

	res, errs := h.searchS.Find(c, f, queryFilters)
	if errs != nil {
		errors := make([]string, 0, len(errs))
		for _, err := range errs {
			errors = append(errors, err.Error())
		}
		c.JSON(http.StatusInternalServerError, gin.H{"errors": errors})
		return
	}

	c.JSON(http.StatusOK, gin.H{"result": res})
}
