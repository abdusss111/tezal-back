package controller

import (
	"encoding/json"
	"fmt"
	"github.com/gin-gonic/gin"
	"gitlab.com/eqshare/eqshare-back/internal/service"
	"gitlab.com/eqshare/eqshare-back/model"
	"gitlab.com/eqshare/eqshare-back/pkg/util"
	"net/http"
	"strconv"
)

type adEquipment struct {
	adEquipmentService service.IAdEquipment
}

func NewAdEquipment(r *gin.Engine, auth service.IAuthentication, adEquipmentService service.IAdEquipment) {
	h := adEquipment{
		adEquipmentService: adEquipmentService,
	}

	ad := r.Group("equipment/ad_equipment")

	ad.GET("", h.Get)
	ad.GET(":id", h.GetByID)
	ad.POST("", authorize(auth, model.ROLE_OWNER, model.ROLE_DRIVER, model.ROLE_CLIENT, model.ROLE_ADMIN), h.Create)
	ad.PUT(":id", authorize(auth, model.ROLE_OWNER, model.ROLE_DRIVER, model.ROLE_CLIENT, model.ROLE_ADMIN), h.Update)
	ad.DELETE(":id", authorize(auth, model.ROLE_OWNER, model.ROLE_DRIVER, model.ROLE_CLIENT, model.ROLE_ADMIN), h.Delete)

	ad.GET("favorite", authorize(auth, model.ROLE_ADMIN, model.ROLE_DRIVER, model.ROLE_OWNER, model.ROLE_CLIENT), h.GetFavorite)
	ad.POST(":id/favorite", authorize(auth, model.ROLE_ADMIN, model.ROLE_DRIVER, model.ROLE_OWNER, model.ROLE_CLIENT), h.CreateFavority)
	ad.DELETE(":id/favorite", authorize(auth, model.ROLE_ADMIN, model.ROLE_DRIVER, model.ROLE_OWNER, model.ROLE_CLIENT), h.DeleteFavorite)

	ad.GET(":id/seen", h.GetSeen)
	ad.POST(":id/seen", h.IncrementSeen)
}

// @Summary		Создание AdEquipment
// @Description	Создание оборудование.
// @Description	По параметру base нужно передавть все параметры в описании в формате json
// @Description	params заполнять поля которые нужны остальное null
// @Tags			AdEquipment (объявления оборудование)
// @Accept			mpfd
// @Produce		json
// @Param			base	body		controller.Create.adEquipmentRequest	true	"тело объявления, не body а formData, значение в json"
// @Param			foto	formData	file									true	"фото объявления"
// @Success		200		{object}	map[string]interface{}
// @Failure		400		{object}	map[string]interface{}
// @Failure		404		{object}	map[string]interface{}
// @Failure		500		{object}	map[string]interface{}
// @Router			/equipment/ad_equipment [post]
func (h *adEquipment) Create(c *gin.Context) {
	type adEquipmentRequest struct {
		EquipmentBrandID       int                     `json:"equipment_brand_id"`
		EquipmentSubСategoryID int                     `json:"equipment_sub_сategory_id"`
		CityID                 int                     `json:"city_id"`
		Price                  float64                 `json:"price"`
		Title                  string                  `json:"title"`
		Description            string                  `json:"description"`
		Address                string                  `json:"address"`
		Latitude               *float64                `json:"latitude"`
		Longitude              *float64                `json:"longitude"`
		Params                 model.AdEquipmentParams `json:"params"`
	}

	ad := model.AdEquipment{}
	user, err := GetUserFromGin(c)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": fmt.Sprintf("get user: %s", err.Error())})
		return
	}

	mf, err := c.MultipartForm()
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": fmt.Sprintf("invalid input: %s", err.Error())})
		return
	}

	ad.UserID = user.ID

	if len(mf.Value["base"]) != 0 {
		d := mf.Value["base"][0]
		adR := adEquipmentRequest{}

		err := json.Unmarshal([]byte(d), &adR)
		if err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": fmt.Sprintf("invalid input in base: %s", err.Error())})
			return
		}
		{
			ad.EquipmentBrandID = adR.EquipmentBrandID
			ad.EquipmentSubCategoryID = adR.EquipmentSubСategoryID
			ad.CityID = adR.CityID
			ad.Price = adR.Price
			ad.Title = adR.Title
			ad.Description = adR.Description
			ad.Address = adR.Address
			ad.Latitude = adR.Latitude
			ad.Longitude = adR.Longitude
			ad.Params = adR.Params
		}
	} else {
		c.JSON(http.StatusBadRequest, gin.H{"error": "don't have base"})
		return
	}

	for _, fh := range mf.File["foto"] {
		doc, err := util.ParseDocumentOnMultipart(fh)
		if err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": fmt.Errorf("parse foto: %w", err).Error()})
			return
		}
		doc.UserID = user.ID
		ad.Documents = append(ad.Documents, doc)
	}

	// ad_equipment_id,
	// weight,
	// reach,
	// height,
	// lifting_height,
	// working_depth,
	// cutting_depth,
	// load_capacity_kg,
	// load_capacity_t,
	// bending_diameter,
	// machining_diameter,
	// chuck_diameter,
	// saw_blade_diameter,
	// cutting_diameter,
	// drilling_diameter,
	// pipe_diameter,
	// angle_measuring_range,
	// hose_length,
	// hose_diameter,
	// measuring_length,
	// saw_band_length,
	// saw_band_width,
	// rope_length,
	// length,
	// working_length,
	// cutting_length,
	// handle_length,
	// cable_length
	// able_length,
	// oil_tank_capacity,
	// fuel_tank_capacity,
	// number_tools,
	// type_of_tools,
	// number_of_axles,
	// number_of_flasks,
	// max_workpiece_height,
	// maximum_lifting_height,
	// maximum_cutting_depth_in_wood,
	// maximum_cutting_depth_in_metal,
	// maximum_cutting_depth_in_plastic,
	// maximum_cutting_depth,
	// maximum_cutting_depth_at90,
	// maximum_cutting_depth_at_angular_position,
	// maximum_wheel_weight,
	// maximum_power_w,
	// maximum_power_kw,
	// maximum_load,
	// maximum_lifting_speed,
	// maximum_material_thickness,
	// maximum_cutting_width,
	// maximum_force,
	// maximum_wheel_diameter,
	// maximum_diameter_of_self_drilling_screw,
	// maximum_drilling_diameter_in_wood,
	// maximum_drilling_diameter_in_metal,
	// tube_material,
	// band_locking_mechanism,
	// power_w,
	// burner_power,
	// motor_power,
	// power_kw,
	// drive_power,
	// spindle_power,
	// voltage,
	// frequency,
	// rated_frequency,
	// rated_voltage,
	// rated_current,
	// drum_volume,
	// capacity_kgh,
	// capacity_kw,
	// capacity_liters_hour,
	// capacity_th,
	// working_pressure,
	// gas_working_pressure,
	// table_working_size,
	// bending_radius_m,
	// bending_radius_mm,
	// table_dimensions_mm,
	// table_dimensions_mm2,
	// gas_supply_system,
	// drum_rotation_speed,
	// rotation_speed,
	// saw_blade_speed,
	// spindle_speed,
	// belt_speed,
	// speed,
	// lifting_speed,
	// cutting_speed,
	// temperature_range,
	// battery_type,
	// display_type,
	// start_type,
	// measurement_type,
	// type_of_gas_used,
	// type_of_saws_used,
	// type_of_cable_bender,
	// type_of_cable_cutter,
	// type_of_rope,
	// crane_type,
	// type_of_tape,
	// pump_type,
	// hammer_type,
	// soldering_element_type,
	// power_supply_type,
	// drill_type,
	// platform_type,
	// bearing_type,
	// elevator_type,
	// drive_type,
	// cutting_mechanism_type,
	// welding_type,
	// type_of_welding_machine,
	// type_of_control_system,
	// fuel_type,
	// cable_type,
	// pipe_bender_type,
	// pipe_cutter_type,
	// control_type,
	// filter_type,
	// welding_current,
	// cutting_thickness,
	// measuring_accuracy,
	// cutting_accuracy,
	// saw_blade_tilt_angle,
	// table_tilt_angle,
	// pressing_force,
	// travel_length,
	// saw_stroke,
	// stroke_of_the_press,
	// stroke_frequency,
	// number_of_revolutions,
	// number_of_saw_strokes_per_minute,
	// width,
	// belt_width,
	// working_width

	err = h.adEquipmentService.Create(c, ad)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"status": "success"})
}

// @Summary	Получение списка AdEquipment
// @Tags		AdEquipment (объявления оборудование)
// @Accept		mpfd
// @Produce	json
// @Param		asc											query		string	false	"сортировка по возрастанию, принимает названия параметров `можно передавать несколько раз`"
// @Param		desc										query		string	false	"сортировка по убыванию, принимает названия параметров `можно передавать несколько раз`"
// @Param		user_detail									query		bool	false	"при значении true дает полную информацию параметра"
// @Param		equipment_brand_detail						query		bool	false	"при значении true дает полную информацию параметра"
// @Param		equipment_subcategory_detail				query		bool	false	"при значении true дает полную информацию параметра"
// @Param		city_detail									query		bool	false	"при значении true дает полную информацию параметра"
// @Param		documents_detail							query		bool	false	"при значении true дает полную информацию параметра"
// @Param		params_detail								query		bool	false	"при значении true дает полную информацию параметра"
// @Param		unscoped									query		bool	false	"при значении true дает дает удаленные и не удаленные данные"
// @Param		offset										query		integer	false	"сдвиг получение данных"
// @Param		limit										query		integer	false	"лимит получение данных"
// @Param		id											query		integer	false	"филтры по идентификаторам параметров `можно передавать несколько раз`"
// @Param		user_id										query		integer	false	"филтры по идентификаторам параметров `можно передавать несколько раз`"
// @Param		equipment_brand_id							query		integer	false	"филтры по идентификаторам параметров `можно передавать несколько раз`"
// @Param		equipment_subcategory_id					query		integer	false	"филтры по идентификаторам параметров `можно передавать несколько раз`"
// @Param		equipment_category_id						query		integer	false	"филтры по категориям `можно передавать несколько раз`"
// @Param		city_id										query		integer	false	"филтры по идентификаторам параметров `можно передавать несколько раз`"
// @Param		title										query		string	false	"ишет совпадение в названии параметра"
// @Param		description									query		string	false	"ишет совпадение в названии параметра"
// @Param		price										query		float64	false	"фильтр диапазона, формат записи: {дробное или натуральное число или *}-{дробное или натуральное число или *}"
// @Param		weight										query		float64	false	"фильтр диапазона, формат записи: {дробное или натуральное число или *}-{дробное или натуральное число или *}"
// @Param		reach										query		float64	false	"фильтр диапазона, формат записи: {дробное или натуральное число или *}-{дробное или натуральное число или *}"
// @Param		height										query		float64	false	"фильтр диапазона, формат записи: {дробное или натуральное число или *}-{дробное или натуральное число или *}"
// @Param		lifting_height								query		float64	false	"фильтр диапазона, формат записи: {дробное или натуральное число или *}-{дробное или натуральное число или *}"
// @Param		working_depth								query		float64	false	"фильтр диапазона, формат записи: {дробное или натуральное число или *}-{дробное или натуральное число или *}"
// @Param		cutting_depth								query		float64	false	"фильтр диапазона, формат записи: {дробное или натуральное число или *}-{дробное или натуральное число или *}"
// @Param		load_capacity_kg							query		float64	false	"фильтр диапазона, формат записи: {дробное или натуральное число или *}-{дробное или натуральное число или *}"
// @Param		load_capacity_t								query		float64	false	"фильтр диапазона, формат записи: {дробное или натуральное число или *}-{дробное или натуральное число или *}"
// @Param		bending_diameter							query		float64	false	"фильтр диапазона, формат записи: {дробное или натуральное число или *}-{дробное или натуральное число или *}"
// @Param		machining_diameter							query		float64	false	"фильтр диапазона, формат записи: {дробное или натуральное число или *}-{дробное или натуральное число или *}"
// @Param		chuck_diameter								query		float64	false	"фильтр диапазона, формат записи: {дробное или натуральное число или *}-{дробное или натуральное число или *}"
// @Param		saw_blade_diameter							query		float64	false	"фильтр диапазона, формат записи: {дробное или натуральное число или *}-{дробное или натуральное число или *}"
// @Param		cutting_diameter							query		float64	false	"фильтр диапазона, формат записи: {дробное или натуральное число или *}-{дробное или натуральное число или *}"
// @Param		drilling_diameter							query		float64	false	"фильтр диапазона, формат записи: {дробное или натуральное число или *}-{дробное или натуральное число или *}"
// @Param		pipe_diameter								query		float64	false	"фильтр диапазона, формат записи: {дробное или натуральное число или *}-{дробное или натуральное число или *}"
// @Param		angle_measuring_range						query		float64	false	"фильтр диапазона, формат записи: {дробное или натуральное число или *}-{дробное или натуральное число или *}"
// @Param		hose_length									query		float64	false	"фильтр диапазона, формат записи: {дробное или натуральное число или *}-{дробное или натуральное число или *}"
// @Param		hose_diameter								query		float64	false	"фильтр диапазона, формат записи: {дробное или натуральное число или *}-{дробное или натуральное число или *}"
// @Param		measuring_length							query		float64	false	"фильтр диапазона, формат записи: {дробное или натуральное число или *}-{дробное или натуральное число или *}"
// @Param		saw_band_length								query		float64	false	"фильтр диапазона, формат записи: {дробное или натуральное число или *}-{дробное или натуральное число или *}"
// @Param		saw_band_width								query		float64	false	"фильтр диапазона, формат записи: {дробное или натуральное число или *}-{дробное или натуральное число или *}"
// @Param		rope_length									query		float64	false	"фильтр диапазона, формат записи: {дробное или натуральное число или *}-{дробное или натуральное число или *}"
// @Param		length										query		float64	false	"фильтр диапазона, формат записи: {дробное или натуральное число или *}-{дробное или натуральное число или *}"
// @Param		working_length								query		float64	false	"фильтр диапазона, формат записи: {дробное или натуральное число или *}-{дробное или натуральное число или *}"
// @Param		cutting_length								query		float64	false	"фильтр диапазона, формат записи: {дробное или натуральное число или *}-{дробное или натуральное число или *}"
// @Param		handle_length								query		float64	false	"фильтр диапазона, формат записи: {дробное или натуральное число или *}-{дробное или натуральное число или *}"
// @Param		cable_length								query		float64	false	"фильтр диапазона, формат записи: {дробное или натуральное число или *}-{дробное или натуральное число или *}"
// @Param		oil_tank_capacity							query		float64	false	"фильтр диапазона, формат записи: {дробное или натуральное число или *}-{дробное или натуральное число или *}"
// @Param		fuel_tank_capacity							query		float64	false	"фильтр диапазона, формат записи: {дробное или натуральное число или *}-{дробное или натуральное число или *}"
// @Param		number_tools								query		float64	false	"фильтр диапазона, формат записи: {дробное или натуральное число или *}-{дробное или натуральное число или *}"
// @Param		type_of_tools								query		float64	false	"фильтр диапазона, формат записи: {дробное или натуральное число или *}-{дробное или натуральное число или *}"
// @Param		number_of_axles								query		float64	false	"фильтр диапазона, формат записи: {дробное или натуральное число или *}-{дробное или натуральное число или *}"
// @Param		number_of_flasks							query		float64	false	"фильтр диапазона, формат записи: {дробное или натуральное число или *}-{дробное или натуральное число или *}"
// @Param		max_workpiece_height						query		float64	false	"фильтр диапазона, формат записи: {дробное или натуральное число или *}-{дробное или натуральное число или *}"
// @Param		maximum_lifting_height						query		float64	false	"фильтр диапазона, формат записи: {дробное или натуральное число или *}-{дробное или натуральное число или *}"
// @Param		maximum_cutting_depth_in_wood				query		float64	false	"фильтр диапазона, формат записи: {дробное или натуральное число или *}-{дробное или натуральное число или *}"
// @Param		maximum_cutting_depth_in_metal				query		float64	false	"фильтр диапазона, формат записи: {дробное или натуральное число или *}-{дробное или натуральное число или *}"
// @Param		maximum_cutting_depth_in_plastic			query		float64	false	"фильтр диапазона, формат записи: {дробное или натуральное число или *}-{дробное или натуральное число или *}"
// @Param		maximum_cutting_depth						query		float64	false	"фильтр диапазона, формат записи: {дробное или натуральное число или *}-{дробное или натуральное число или *}"
// @Param		maximum_cutting_depth_at90					query		float64	false	"фильтр диапазона, формат записи: {дробное или натуральное число или *}-{дробное или натуральное число или *}"
// @Param		maximum_cutting_depth_at_angular_position	query		float64	false	"фильтр диапазона, формат записи: {дробное или натуральное число или *}-{дробное или натуральное число или *}"
// @Param		maximum_wheel_weight						query		float64	false	"фильтр диапазона, формат записи: {дробное или натуральное число или *}-{дробное или натуральное число или *}"
// @Param		maximum_power_w								query		float64	false	"фильтр диапазона, формат записи: {дробное или натуральное число или *}-{дробное или натуральное число или *}"
// @Param		maximum_power_kw							query		float64	false	"фильтр диапазона, формат записи: {дробное или натуральное число или *}-{дробное или натуральное число или *}"
// @Param		maximum_load								query		float64	false	"фильтр диапазона, формат записи: {дробное или натуральное число или *}-{дробное или натуральное число или *}"
// @Param		maximum_lifting_speed						query		float64	false	"фильтр диапазона, формат записи: {дробное или натуральное число или *}-{дробное или натуральное число или *}"
// @Param		maximum_material_thickness					query		float64	false	"фильтр диапазона, формат записи: {дробное или натуральное число или *}-{дробное или натуральное число или *}"
// @Param		maximum_cutting_width						query		float64	false	"фильтр диапазона, формат записи: {дробное или натуральное число или *}-{дробное или натуральное число или *}"
// @Param		maximum_force								query		float64	false	"фильтр диапазона, формат записи: {дробное или натуральное число или *}-{дробное или натуральное число или *}"
// @Param		maximum_wheel_diameter						query		float64	false	"фильтр диапазона, формат записи: {дробное или натуральное число или *}-{дробное или натуральное число или *}"
// @Param		maximum_diameter_of_self_drilling_screw		query		float64	false	"фильтр диапазона, формат записи: {дробное или натуральное число или *}-{дробное или натуральное число или *}"
// @Param		maximum_drilling_diameter_in_wood			query		float64	false	"фильтр диапазона, формат записи: {дробное или натуральное число или *}-{дробное или натуральное число или *}"
// @Param		maximum_drilling_diameter_in_metal			query		float64	false	"фильтр диапазона, формат записи: {дробное или натуральное число или *}-{дробное или натуральное число или *}"
// @Param		tube_material								query		float64	false	"фильтр диапазона, формат записи: {дробное или натуральное число или *}-{дробное или натуральное число или *}"
// @Param		band_locking_mechanism						query		float64	false	"фильтр диапазона, формат записи: {дробное или натуральное число или *}-{дробное или натуральное число или *}"
// @Param		power_w										query		float64	false	"фильтр диапазона, формат записи: {дробное или натуральное число или *}-{дробное или натуральное число или *}"
// @Param		burner_power								query		float64	false	"фильтр диапазона, формат записи: {дробное или натуральное число или *}-{дробное или натуральное число или *}"
// @Param		motor_power									query		float64	false	"фильтр диапазона, формат записи: {дробное или натуральное число или *}-{дробное или натуральное число или *}"
// @Param		power_kw									query		float64	false	"фильтр диапазона, формат записи: {дробное или натуральное число или *}-{дробное или натуральное число или *}"
// @Param		drive_power									query		float64	false	"фильтр диапазона, формат записи: {дробное или натуральное число или *}-{дробное или натуральное число или *}"
// @Param		spindle_power								query		float64	false	"фильтр диапазона, формат записи: {дробное или натуральное число или *}-{дробное или натуральное число или *}"
// @Param		voltage										query		float64	false	"фильтр диапазона, формат записи: {дробное или натуральное число или *}-{дробное или натуральное число или *}"
// @Param		frequency									query		float64	false	"фильтр диапазона, формат записи: {дробное или натуральное число или *}-{дробное или натуральное число или *}"
// @Param		rated_frequency								query		float64	false	"фильтр диапазона, формат записи: {дробное или натуральное число или *}-{дробное или натуральное число или *}"
// @Param		rated_voltage								query		float64	false	"фильтр диапазона, формат записи: {дробное или натуральное число или *}-{дробное или натуральное число или *}"
// @Param		rated_current								query		float64	false	"фильтр диапазона, формат записи: {дробное или натуральное число или *}-{дробное или натуральное число или *}"
// @Param		drum_volume									query		float64	false	"фильтр диапазона, формат записи: {дробное или натуральное число или *}-{дробное или натуральное число или *}"
// @Param		capacity_kgh								query		float64	false	"фильтр диапазона, формат записи: {дробное или натуральное число или *}-{дробное или натуральное число или *}"
// @Param		capacity_kw									query		float64	false	"фильтр диапазона, формат записи: {дробное или натуральное число или *}-{дробное или натуральное число или *}"
// @Param		capacity_liters_hour						query		float64	false	"фильтр диапазона, формат записи: {дробное или натуральное число или *}-{дробное или натуральное число или *}"
// @Param		capacity_th									query		float64	false	"фильтр диапазона, формат записи: {дробное или натуральное число или *}-{дробное или натуральное число или *}"
// @Param		working_pressure							query		float64	false	"фильтр диапазона, формат записи: {дробное или натуральное число или *}-{дробное или натуральное число или *}"
// @Param		gas_working_pressure						query		float64	false	"фильтр диапазона, формат записи: {дробное или натуральное число или *}-{дробное или натуральное число или *}"
// @Param		table_working_size							query		float64	false	"фильтр диапазона, формат записи: {дробное или натуральное число или *}-{дробное или натуральное число или *}"
// @Param		bending_radius_m							query		float64	false	"фильтр диапазона, формат записи: {дробное или натуральное число или *}-{дробное или натуральное число или *}"
// @Param		bending_radius_mm							query		float64	false	"фильтр диапазона, формат записи: {дробное или натуральное число или *}-{дробное или натуральное число или *}"
// @Param		table_dimensions_mm							query		float64	false	"фильтр диапазона, формат записи: {дробное или натуральное число или *}-{дробное или натуральное число или *}"
// @Param		table_dimensions_mm2						query		float64	false	"фильтр диапазона, формат записи: {дробное или натуральное число или *}-{дробное или натуральное число или *}"
// @Param		gas_supply_system							query		float64	false	"фильтр диапазона, формат записи: {дробное или натуральное число или *}-{дробное или натуральное число или *}"
// @Param		drum_rotation_speed							query		float64	false	"фильтр диапазона, формат записи: {дробное или натуральное число или *}-{дробное или натуральное число или *}"
// @Param		rotation_speed								query		float64	false	"фильтр диапазона, формат записи: {дробное или натуральное число или *}-{дробное или натуральное число или *}"
// @Param		saw_blade_speed								query		float64	false	"фильтр диапазона, формат записи: {дробное или натуральное число или *}-{дробное или натуральное число или *}"
// @Param		spindle_speed								query		float64	false	"фильтр диапазона, формат записи: {дробное или натуральное число или *}-{дробное или натуральное число или *}"
// @Param		belt_speed									query		float64	false	"фильтр диапазона, формат записи: {дробное или натуральное число или *}-{дробное или натуральное число или *}"
// @Param		speed										query		float64	false	"фильтр диапазона, формат записи: {дробное или натуральное число или *}-{дробное или натуральное число или *}"
// @Param		lifting_speed								query		float64	false	"фильтр диапазона, формат записи: {дробное или натуральное число или *}-{дробное или натуральное число или *}"
// @Param		cutting_speed								query		float64	false	"фильтр диапазона, формат записи: {дробное или натуральное число или *}-{дробное или натуральное число или *}"
// @Param		temperature_range							query		float64	false	"фильтр диапазона, формат записи: {дробное или натуральное число или *}-{дробное или натуральное число или *}"
// @Param		battery_type								query		float64	false	"фильтр диапазона, формат записи: {дробное или натуральное число или *}-{дробное или натуральное число или *}"
// @Param		display_type								query		float64	false	"фильтр диапазона, формат записи: {дробное или натуральное число или *}-{дробное или натуральное число или *}"
// @Param		start_type									query		float64	false	"фильтр диапазона, формат записи: {дробное или натуральное число или *}-{дробное или натуральное число или *}"
// @Param		measurement_type							query		float64	false	"фильтр диапазона, формат записи: {дробное или натуральное число или *}-{дробное или натуральное число или *}"
// @Param		type_of_gas_used							query		float64	false	"фильтр диапазона, формат записи: {дробное или натуральное число или *}-{дробное или натуральное число или *}"
// @Param		type_of_saws_used							query		float64	false	"фильтр диапазона, формат записи: {дробное или натуральное число или *}-{дробное или натуральное число или *}"
// @Param		type_of_cable_bender						query		float64	false	"фильтр диапазона, формат записи: {дробное или натуральное число или *}-{дробное или натуральное число или *}"
// @Param		type_of_cable_cutter						query		float64	false	"фильтр диапазона, формат записи: {дробное или натуральное число или *}-{дробное или натуральное число или *}"
// @Param		type_of_rope								query		float64	false	"фильтр диапазона, формат записи: {дробное или натуральное число или *}-{дробное или натуральное число или *}"
// @Param		crane_type									query		float64	false	"фильтр диапазона, формат записи: {дробное или натуральное число или *}-{дробное или натуральное число или *}"
// @Param		type_of_tape								query		float64	false	"фильтр диапазона, формат записи: {дробное или натуральное число или *}-{дробное или натуральное число или *}"
// @Param		pump_type									query		float64	false	"фильтр диапазона, формат записи: {дробное или натуральное число или *}-{дробное или натуральное число или *}"
// @Param		hammer_type									query		float64	false	"фильтр диапазона, формат записи: {дробное или натуральное число или *}-{дробное или натуральное число или *}"
// @Param		soldering_element_type						query		float64	false	"фильтр диапазона, формат записи: {дробное или натуральное число или *}-{дробное или натуральное число или *}"
// @Param		power_supply_type							query		float64	false	"фильтр диапазона, формат записи: {дробное или натуральное число или *}-{дробное или натуральное число или *}"
// @Param		drill_type									query		float64	false	"фильтр диапазона, формат записи: {дробное или натуральное число или *}-{дробное или натуральное число или *}"
// @Param		platform_type								query		float64	false	"фильтр диапазона, формат записи: {дробное или натуральное число или *}-{дробное или натуральное число или *}"
// @Param		bearing_type								query		float64	false	"фильтр диапазона, формат записи: {дробное или натуральное число или *}-{дробное или натуральное число или *}"
// @Param		elevator_type								query		float64	false	"фильтр диапазона, формат записи: {дробное или натуральное число или *}-{дробное или натуральное число или *}"
// @Param		drive_type									query		float64	false	"фильтр диапазона, формат записи: {дробное или натуральное число или *}-{дробное или натуральное число или *}"
// @Param		cutting_mechanism_type						query		float64	false	"фильтр диапазона, формат записи: {дробное или натуральное число или *}-{дробное или натуральное число или *}"
// @Param		welding_type								query		float64	false	"фильтр диапазона, формат записи: {дробное или натуральное число или *}-{дробное или натуральное число или *}"
// @Param		type_of_welding_machine						query		float64	false	"фильтр диапазона, формат записи: {дробное или натуральное число или *}-{дробное или натуральное число или *}"
// @Param		type_of_control_system						query		float64	false	"фильтр диапазона, формат записи: {дробное или натуральное число или *}-{дробное или натуральное число или *}"
// @Param		fuel_type									query		float64	false	"фильтр диапазона, формат записи: {дробное или натуральное число или *}-{дробное или натуральное число или *}"
// @Param		cable_type									query		float64	false	"фильтр диапазона, формат записи: {дробное или натуральное число или *}-{дробное или натуральное число или *}"
// @Param		pipe_bender_type							query		float64	false	"фильтр диапазона, формат записи: {дробное или натуральное число или *}-{дробное или натуральное число или *}"
// @Param		pipe_cutter_type							query		float64	false	"фильтр диапазона, формат записи: {дробное или натуральное число или *}-{дробное или натуральное число или *}"
// @Param		control_type								query		float64	false	"фильтр диапазона, формат записи: {дробное или натуральное число или *}-{дробное или натуральное число или *}"
// @Param		filter_type									query		float64	false	"фильтр диапазона, формат записи: {дробное или натуральное число или *}-{дробное или натуральное число или *}"
// @Param		welding_current								query		float64	false	"фильтр диапазона, формат записи: {дробное или натуральное число или *}-{дробное или натуральное число или *}"
// @Param		cutting_thickness							query		float64	false	"фильтр диапазона, формат записи: {дробное или натуральное число или *}-{дробное или натуральное число или *}"
// @Param		measuring_accuracy							query		float64	false	"фильтр диапазона, формат записи: {дробное или натуральное число или *}-{дробное или натуральное число или *}"
// @Param		cutting_accuracy							query		float64	false	"фильтр диапазона, формат записи: {дробное или натуральное число или *}-{дробное или натуральное число или *}"
// @Param		saw_blade_tilt_angle						query		float64	false	"фильтр диапазона, формат записи: {дробное или натуральное число или *}-{дробное или натуральное число или *}"
// @Param		table_tilt_angle							query		float64	false	"фильтр диапазона, формат записи: {дробное или натуральное число или *}-{дробное или натуральное число или *}"
// @Param		pressing_force								query		float64	false	"фильтр диапазона, формат записи: {дробное или натуральное число или *}-{дробное или натуральное число или *}"
// @Param		travel_length								query		float64	false	"фильтр диапазона, формат записи: {дробное или натуральное число или *}-{дробное или натуральное число или *}"
// @Param		saw_stroke									query		float64	false	"фильтр диапазона, формат записи: {дробное или натуральное число или *}-{дробное или натуральное число или *}"
// @Param		stroke_of_the_press							query		float64	false	"фильтр диапазона, формат записи: {дробное или натуральное число или *}-{дробное или натуральное число или *}"
// @Param		stroke_frequency							query		float64	false	"фильтр диапазона, формат записи: {дробное или натуральное число или *}-{дробное или натуральное число или *}"
// @Param		number_of_revolutions						query		float64	false	"фильтр диапазона, формат записи: {дробное или натуральное число или *}-{дробное или натуральное число или *}"
// @Param		number_of_saw_strokes_per_minute			query		float64	false	"фильтр диапазона, формат записи: {дробное или натуральное число или *}-{дробное или натуральное число или *}"
// @Param		width										query		float64	false	"фильтр диапазона, формат записи: {дробное или натуральное число или *}-{дробное или натуральное число или *}"
// @Param		belt_width									query		float64	false	"фильтр диапазона, формат записи: {дробное или натуральное число или *}-{дробное или натуральное число или *}"
// @Param		working_width								query		float64	false	"фильтр диапазона, формат записи: {дробное или натуральное число или *}-{дробное или натуральное число или *}"
// @Success	200											{object}	map[string]interface{}
// @Failure	400											{object}	map[string]interface{}
// @Failure	404											{object}	map[string]interface{}
// @Failure	500											{object}	map[string]interface{}
// @Router		/equipment/ad_equipment [get]
func (h *adEquipment) Get(c *gin.Context) {
	f := model.FilterAdEquipment{}

	if val, ok := c.GetQuery("user_detail"); ok {
		v, err := strconv.ParseBool(val)
		if err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": fmt.Errorf("user_detail: %w", err).Error()})
			return
		}
		f.UserDetail = &v
	}
	if val, ok := c.GetQuery("equipment_brand_detail"); ok {
		v, err := strconv.ParseBool(val)
		if err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": fmt.Errorf("equipment_brand_detail: %w", err).Error()})
			return
		}
		f.EquipmentBrandDetail = &v
	}
	if val, ok := c.GetQuery("equipment_subcategory_detail"); ok {
		v, err := strconv.ParseBool(val)
		if err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": fmt.Errorf("equipment_subcategory_detail: %w", err).Error()})
			return
		}
		f.EquipmentSubcategoryDetail = &v
	}
	if val, ok := c.GetQuery("city_detail"); ok {
		v, err := strconv.ParseBool(val)
		if err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": fmt.Errorf("city_detail: %w", err).Error()})
			return
		}
		f.CityDetail = &v
	}
	if val, ok := c.GetQuery("documents_detail"); ok {
		v, err := strconv.ParseBool(val)
		if err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": fmt.Errorf("documents_detail: %w", err).Error()})
			return
		}
		f.DocumentsDetail = &v
	}
	if val, ok := c.GetQuery("params_detail"); ok {
		v, err := strconv.ParseBool(val)
		if err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": fmt.Errorf("params_detail: %w", err).Error()})
			return
		}
		f.ParamsDetail = &v
	}

	if val, ok := c.GetQuery("unscoped"); ok {
		v, err := strconv.ParseBool(val)
		if err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": fmt.Errorf("unscoped: %w", err).Error()})
			return
		}
		f.Unscoped = &v
	}
	if val, ok := c.GetQuery("limit"); ok {
		id, err := strconv.Atoi(val)
		if err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": fmt.Errorf("limit: %w", err).Error()})
			return
		}
		f.Limit = &id
	}
	if val, ok := c.GetQuery("offset"); ok {
		id, err := strconv.Atoi(val)
		if err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": fmt.Errorf("offset: %w", err).Error()})
			return
		}
		f.Offset = &id
	}
	if vals, ok := c.GetQueryArray("id"); ok {
		f.IDs = make([]int, 0, len(vals))
		for _, v := range vals {
			id, err := strconv.Atoi(v)
			if err != nil {
				c.JSON(http.StatusBadRequest, gin.H{"error": fmt.Errorf("ids: query values: %s: error:  %w", v, err).Error()})
				return
			}
			f.IDs = append(f.IDs, id)
		}
	}
	if vals, ok := c.GetQueryArray("user_id"); ok {
		f.UserIDs = make([]int, 0, len(vals))
		for _, v := range vals {
			id, err := strconv.Atoi(v)
			if err != nil {
				c.JSON(http.StatusBadRequest, gin.H{"error": fmt.Errorf("user_ids: query values: %s: error:  %w", v, err).Error()})
				return
			}
			f.UserIDs = append(f.UserIDs, id)
		}
	}
	if vals, ok := c.GetQueryArray("equipment_brand_id"); ok {
		f.EquipmentBrandIDs = make([]int, 0, len(vals))
		for _, v := range vals {
			id, err := strconv.Atoi(v)
			if err != nil {
				c.JSON(http.StatusBadRequest, gin.H{"error": fmt.Errorf("equipment_brand_ids: query values: %s: error:  %w", v, err).Error()})
				return
			}
			f.EquipmentBrandIDs = append(f.EquipmentBrandIDs, id)
		}
	}
	if vals, ok := c.GetQueryArray("equipment_subcategory_id"); ok {
		f.EquipmentSubСategoryIDs = make([]int, 0, len(vals))
		for _, v := range vals {
			id, err := strconv.Atoi(v)
			if err != nil {
				c.JSON(http.StatusBadRequest, gin.H{"error": fmt.Errorf("equipment_subcategory_ids: query values: %s: error:  %w", v, err).Error()})
				return
			}
			f.EquipmentSubСategoryIDs = append(f.EquipmentSubСategoryIDs, id)
		}
	}
	if vals, ok := c.GetQueryArray("equipment_category_id"); ok {
		f.EquipmentСategoryIDs = make([]int, 0, len(vals))
		for _, v := range vals {
			id, err := strconv.Atoi(v)
			if err != nil {
				c.JSON(http.StatusBadRequest, gin.H{"error": fmt.Errorf("equipment_category_ids: query values: %s: error:  %w", v, err).Error()})
				return
			}
			f.EquipmentСategoryIDs = append(f.EquipmentСategoryIDs, id)
		}
	}
	if vals, ok := c.GetQueryArray("city_id"); ok {
		f.CityIDs = make([]int, 0, len(vals))
		for _, v := range vals {
			id, err := strconv.Atoi(v)
			if err != nil {
				c.JSON(http.StatusBadRequest, gin.H{"error": fmt.Errorf("city_ids: query values: %s: error:  %w", v, err).Error()})
				return
			}
			if model.Kazakstan != id {
				f.CityIDs = append(f.CityIDs, id)
			}
		}
	}
	if val, ok := c.GetQuery("title"); ok {
		f.Title = &val
	}
	if val, ok := c.GetQuery("description"); ok {
		f.Description = &val
	}
	p, err := setFilter(c, "price")
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": fmt.Errorf("price:  %w", err).Error()})
		return
	} else {
		f.Price = p
	}
	if val, ok := c.GetQueryArray("asc"); ok {
		f.ASC = val
	}
	if val, ok := c.GetQueryArray("desc"); ok {
		f.DESC = val
	}

	{
		if f.Weight, err = setFilter(c, "weight"); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error parse query weight": err})
			f.HaveParamCondition = true
			return
		}
		if f.Reach, err = setFilter(c, "reach"); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error parse query reach": err})
			f.HaveParamCondition = true
			return
		}
		if f.Height, err = setFilter(c, "height"); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error parse query height": err})
			f.HaveParamCondition = true
			return
		}
		if f.LiftingHeight, err = setFilter(c, "lifting_height"); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error parse query lifting_height": err})
			f.HaveParamCondition = true
			return
		}
		if f.WorkingDepth, err = setFilter(c, "working_depth"); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error parse query working_depth": err})
			f.HaveParamCondition = true
			return
		}
		if f.CuttingDepth, err = setFilter(c, "cutting_depth"); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error parse query cutting_depth": err})
			f.HaveParamCondition = true
			return
		}
		if f.LoadCapacityKg, err = setFilter(c, "load_capacity_kg"); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error parse query load_capacity_kg": err})
			f.HaveParamCondition = true
			return
		}
		if f.LoadCapacityT, err = setFilter(c, "load_capacity_t"); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error parse query load_capacity_t": err})
			f.HaveParamCondition = true
			return
		}
		if f.BendingDiameter, err = setFilter(c, "bending_diameter"); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error parse query bending_diameter": err})
			f.HaveParamCondition = true
			return
		}
		if f.MachiningDiameter, err = setFilter(c, "machining_diameter"); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error parse query machining_diameter": err})
			f.HaveParamCondition = true
			return
		}
		if f.ChuckDiameter, err = setFilter(c, "chuck_diameter"); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error parse query chuck_diameter": err})
			f.HaveParamCondition = true
			return
		}
		if f.SawBladeDiameter, err = setFilter(c, "saw_blade_diameter"); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error parse query saw_blade_diameter": err})
			f.HaveParamCondition = true
			return
		}
		if f.CuttingDiameter, err = setFilter(c, "cutting_diameter"); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error parse query cutting_diameter": err})
			f.HaveParamCondition = true
			return
		}
		if f.DrillingDiameter, err = setFilter(c, "drilling_diameter"); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error parse query drilling_diameter": err})
			f.HaveParamCondition = true
			return
		}
		if f.PipeDiameter, err = setFilter(c, "pipe_diameter"); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error parse query pipe_diameter": err})
			f.HaveParamCondition = true
			return
		}
		if f.AngleMeasuringRange, err = setFilter(c, "angle_measuring_range"); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error parse query angle_measuring_range": err})
			f.HaveParamCondition = true
			return
		}
		if f.HoseLength, err = setFilter(c, "hose_length"); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error parse query hose_length": err})
			f.HaveParamCondition = true
			return
		}
		if f.HoseDiameter, err = setFilter(c, "hose_diameter"); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error parse query hose_diameter": err})
			f.HaveParamCondition = true
			return
		}
		if f.MeasuringLength, err = setFilter(c, "measuring_length"); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error parse query measuring_length": err})
			f.HaveParamCondition = true
			return
		}
		if f.SawBandLength, err = setFilter(c, "saw_band_length"); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error parse query saw_band_length": err})
			f.HaveParamCondition = true
			return
		}
		if f.SawBandWidth, err = setFilter(c, "saw_band_width"); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error parse query saw_band_width": err})
			f.HaveParamCondition = true
			return
		}
		if f.RopeLength, err = setFilter(c, "rope_length"); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error parse query rope_length": err})
			f.HaveParamCondition = true
			return
		}
		if f.Length, err = setFilter(c, "length"); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error parse query length": err})
			f.HaveParamCondition = true
			return
		}
		if f.WorkingLength, err = setFilter(c, "working_length"); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error parse query working_length": err})
			f.HaveParamCondition = true
			return
		}
		if f.CuttingLength, err = setFilter(c, "cutting_length"); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error parse query cutting_length": err})
			f.HaveParamCondition = true
			return
		}
		if f.HandleLength, err = setFilter(c, "handle_length"); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error parse query handle_length": err})
			f.HaveParamCondition = true
			return
		}
		if f.CableLength, err = setFilter(c, "cable_length"); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error parse query cable_length": err})
			f.HaveParamCondition = true
			return
		}
		if f.OilTankCapacity, err = setFilter(c, "oil_tank_capacity"); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error parse query oil_tank_capacity": err})
			f.HaveParamCondition = true
			return
		}
		if f.FuelTankCapacity, err = setFilter(c, "fuel_tank_capacity"); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error parse query fuel_tank_capacity": err})
			f.HaveParamCondition = true
			return
		}
		if f.NumberTools, err = setFilter(c, "number_tools"); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error parse query number_tools": err})
			f.HaveParamCondition = true
			return
		}
		if f.TypeOfTools, err = setFilter(c, "type_of_tools"); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error parse query type_of_tools": err})
			f.HaveParamCondition = true
			return
		}
		if f.NumberOfAxles, err = setFilter(c, "number_of_axles"); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error parse query number_of_axles": err})
			f.HaveParamCondition = true
			return
		}
		if f.NumberOfFlasks, err = setFilter(c, "number_of_flasks"); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error parse query number_of_flasks": err})
			f.HaveParamCondition = true
			return
		}
		if f.MaxWorkpieceHeight, err = setFilter(c, "max_workpiece_height"); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error parse query max_workpiece_height": err})
			f.HaveParamCondition = true
			return
		}
		if f.MaximumLiftingHeight, err = setFilter(c, "maximum_lifting_height"); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error parse query maximum_lifting_height": err})
			f.HaveParamCondition = true
			return
		}
		if f.MaximumCuttingDepthInWood, err = setFilter(c, "maximum_cutting_depth_in_wood"); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error parse query maximum_cutting_depth_in_wood": err})
			f.HaveParamCondition = true
			return
		}
		if f.MaximumCuttingDepthInMetal, err = setFilter(c, "maximum_cutting_depth_in_metal"); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error parse query maximum_cutting_depth_in_metal": err})
			f.HaveParamCondition = true
			return
		}
		if f.MaximumCuttingDepthInPlastic, err = setFilter(c, "maximum_cutting_depth_in_plastic"); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error parse query maximum_cutting_depth_in_plastic": err})
			f.HaveParamCondition = true
			return
		}
		if f.MaximumCuttingDepth, err = setFilter(c, "maximum_cutting_depth"); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error parse query maximum_cutting_depth": err})
			f.HaveParamCondition = true
			return
		}
		if f.MaximumCuttingDepthAt90, err = setFilter(c, "maximum_cutting_depth_at90"); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error parse query maximum_cutting_depth_at90": err})
			f.HaveParamCondition = true
			return
		}
		if f.MaximumCuttingDepthAtAngularPosition, err = setFilter(c, "maximum_cutting_depth_at_angular_position"); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error parse query maximum_cutting_depth_at_angular_position": err})
			f.HaveParamCondition = true
			return
		}
		if f.MaximumWheelWeight, err = setFilter(c, "maximum_wheel_weight"); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error parse query maximum_wheel_weight": err})
			f.HaveParamCondition = true
			return
		}
		if f.MaximumPowerW, err = setFilter(c, "maximum_power_w"); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error parse query maximum_power_w": err})
			f.HaveParamCondition = true
			return
		}
		if f.MaximumPowerKw, err = setFilter(c, "maximum_power_kw"); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error parse query maximum_power_kw": err})
			f.HaveParamCondition = true
			return
		}
		if f.MaximumLoad, err = setFilter(c, "maximum_load"); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error parse query maximum_load": err})
			f.HaveParamCondition = true
			return
		}
		if f.MaximumLiftingSpeed, err = setFilter(c, "maximum_lifting_speed"); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error parse query maximum_lifting_speed": err})
			f.HaveParamCondition = true
			return
		}
		if f.MaximumMaterialThickness, err = setFilter(c, "maximum_material_thickness"); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error parse query maximum_material_thickness": err})
			f.HaveParamCondition = true
			return
		}
		if f.MaximumCuttingWidth, err = setFilter(c, "maximum_cutting_width"); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error parse query maximum_cutting_width": err})
			f.HaveParamCondition = true
			return
		}
		if f.MaximumForce, err = setFilter(c, "maximum_force"); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error parse query maximum_force": err})
			f.HaveParamCondition = true
			return
		}
		if f.MaximumWheelDiameter, err = setFilter(c, "maximum_wheel_diameter"); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error parse query maximum_wheel_diameter": err})
			f.HaveParamCondition = true
			return
		}
		if f.MaximumDiameterOfSelfDrillingScrew, err = setFilter(c, "maximum_diameter_of_self_drilling_screw"); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error parse query maximum_diameter_of_self_drilling_screw": err})
			f.HaveParamCondition = true
			return
		}
		if f.MaximumDrillingDiameterInWood, err = setFilter(c, "maximum_drilling_diameter_in_wood"); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error parse query maximum_drilling_diameter_in_wood": err})
			f.HaveParamCondition = true
			return
		}
		if f.MaximumDrillingDiameterInMetal, err = setFilter(c, "maximum_drilling_diameter_in_metal"); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error parse query maximum_drilling_diameter_in_metal": err})
			f.HaveParamCondition = true
			return
		}
		if f.TubeMaterial, err = setFilter(c, "tube_material"); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error parse query tube_material": err})
			f.HaveParamCondition = true
			return
		}
		if f.BandLockingMechanism, err = setFilter(c, "band_locking_mechanism"); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error parse query band_locking_mechanism": err})
			f.HaveParamCondition = true
			return
		}
		if f.PowerW, err = setFilter(c, "power_w"); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error parse query power_w": err})
			f.HaveParamCondition = true
			return
		}
		if f.BurnerPower, err = setFilter(c, "burner_power"); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error parse query burner_power": err})
			f.HaveParamCondition = true
			return
		}
		if f.MotorPower, err = setFilter(c, "motor_power"); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error parse query motor_power": err})
			f.HaveParamCondition = true
			return
		}
		if f.PowerKw, err = setFilter(c, "power_kw"); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error parse query power_kw": err})
			f.HaveParamCondition = true
			return
		}
		if f.DrivePower, err = setFilter(c, "drive_power"); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error parse query drive_power": err})
			f.HaveParamCondition = true
			return
		}
		if f.SpindlePower, err = setFilter(c, "spindle_power"); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error parse query spindle_power": err})
			f.HaveParamCondition = true
			return
		}
		if f.Voltage, err = setFilter(c, "voltage"); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error parse query voltage": err})
			f.HaveParamCondition = true
			return
		}
		if f.Frequency, err = setFilter(c, "frequency"); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error parse query frequency": err})
			f.HaveParamCondition = true
			return
		}
		if f.RatedFrequency, err = setFilter(c, "rated_frequency"); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error parse query rated_frequency": err})
			f.HaveParamCondition = true
			return
		}
		if f.RatedVoltage, err = setFilter(c, "rated_voltage"); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error parse query rated_voltage": err})
			f.HaveParamCondition = true
			return
		}
		if f.RatedCurrent, err = setFilter(c, "rated_current"); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error parse query rated_current": err})
			f.HaveParamCondition = true
			return
		}
		if f.DrumVolume, err = setFilter(c, "drum_volume"); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error parse query drum_volume": err})
			f.HaveParamCondition = true
			return
		}
		if f.CapacityKgh, err = setFilter(c, "capacity_kgh"); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error parse query capacity_kgh": err})
			f.HaveParamCondition = true
			return
		}
		if f.CapacityKw, err = setFilter(c, "capacity_kw"); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error parse query capacity_kw": err})
			f.HaveParamCondition = true
			return
		}
		if f.CapacityLitersHour, err = setFilter(c, "capacity_liters_hour"); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error parse query capacity_liters_hour": err})
			f.HaveParamCondition = true
			return
		}
		if f.CapacityTh, err = setFilter(c, "capacity_th"); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error parse query capacity_th": err})
			f.HaveParamCondition = true
			return
		}
		if f.WorkingPressure, err = setFilter(c, "working_pressure"); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error parse query working_pressure": err})
			f.HaveParamCondition = true
			return
		}
		if f.GasWorkingPressure, err = setFilter(c, "gas_working_pressure"); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error parse query gas_working_pressure": err})
			f.HaveParamCondition = true
			return
		}
		if f.TableWorkingSize, err = setFilter(c, "table_working_size"); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error parse query table_working_size": err})
			f.HaveParamCondition = true
			return
		}
		if f.BendingRadiusM, err = setFilter(c, "bending_radius_m"); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error parse query bending_radius_m": err})
			f.HaveParamCondition = true
			return
		}
		if f.BendingRadiusMm, err = setFilter(c, "bending_radius_mm"); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error parse query bending_radius_mm": err})
			f.HaveParamCondition = true
			return
		}
		if f.TableDimensionsMm, err = setFilter(c, "table_dimensions_mm"); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error parse query table_dimensions_mm": err})
			f.HaveParamCondition = true
			return
		}
		if f.TableDimensionsMm2, err = setFilter(c, "table_dimensions_mm2"); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error parse query table_dimensions_mm2": err})
			f.HaveParamCondition = true
			return
		}
		if f.GasSupplySystem, err = setFilter(c, "gas_supply_system"); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error parse query gas_supply_system": err})
			f.HaveParamCondition = true
			return
		}
		if f.DrumRotationSpeed, err = setFilter(c, "drum_rotation_speed"); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error parse query drum_rotation_speed": err})
			f.HaveParamCondition = true
			return
		}
		if f.RotationSpeed, err = setFilter(c, "rotation_speed"); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error parse query rotation_speed": err})
			f.HaveParamCondition = true
			return
		}
		if f.SawBladeSpeed, err = setFilter(c, "saw_blade_speed"); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error parse query saw_blade_speed": err})
			f.HaveParamCondition = true
			return
		}
		if f.SpindleSpeed, err = setFilter(c, "spindle_speed"); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error parse query spindle_speed": err})
			f.HaveParamCondition = true
			return
		}
		if f.BeltSpeed, err = setFilter(c, "belt_speed"); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error parse query belt_speed": err})
			f.HaveParamCondition = true
			return
		}
		if f.Speed, err = setFilter(c, "speed"); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error parse query speed": err})
			f.HaveParamCondition = true
			return
		}
		if f.LiftingSpeed, err = setFilter(c, "lifting_speed"); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error parse query lifting_speed": err})
			f.HaveParamCondition = true
			return
		}
		if f.CuttingSpeed, err = setFilter(c, "cutting_speed"); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error parse query cutting_speed": err})
			f.HaveParamCondition = true
			return
		}
		if f.TemperatureRange, err = setFilter(c, "temperature_range"); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error parse query temperature_range": err})
			f.HaveParamCondition = true
			return
		}
		if f.BatteryType, err = setFilter(c, "battery_type"); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error parse query battery_type": err})
			f.HaveParamCondition = true
			return
		}
		if f.DisplayType, err = setFilter(c, "display_type"); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error parse query display_type": err})
			f.HaveParamCondition = true
			return
		}
		if f.StartType, err = setFilter(c, "start_type"); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error parse query start_type": err})
			f.HaveParamCondition = true
			return
		}
		if f.MeasurementType, err = setFilter(c, "measurement_type"); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error parse query measurement_type": err})
			f.HaveParamCondition = true
			return
		}
		if f.TypeOfGasUsed, err = setFilter(c, "type_of_gas_used"); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error parse query type_of_gas_used": err})
			f.HaveParamCondition = true
			return
		}
		if f.TypeOfSawsUsed, err = setFilter(c, "type_of_saws_used"); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error parse query type_of_saws_used": err})
			f.HaveParamCondition = true
			return
		}
		if f.TypeOfCableBender, err = setFilter(c, "type_of_cable_bender"); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error parse query type_of_cable_bender": err})
			f.HaveParamCondition = true
			return
		}
		if f.TypeOfCableCutter, err = setFilter(c, "type_of_cable_cutter"); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error parse query type_of_cable_cutter": err})
			f.HaveParamCondition = true
			return
		}
		if f.TypeOfRope, err = setFilter(c, "type_of_rope"); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error parse query type_of_rope": err})
			f.HaveParamCondition = true
			return
		}
		if f.CraneType, err = setFilter(c, "crane_type"); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error parse query crane_type": err})
			f.HaveParamCondition = true
			return
		}
		if f.TypeOfTape, err = setFilter(c, "type_of_tape"); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error parse query type_of_tape": err})
			f.HaveParamCondition = true
			return
		}
		if f.PumpType, err = setFilter(c, "pump_type"); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error parse query pump_type": err})
			f.HaveParamCondition = true
			return
		}
		if f.HammerType, err = setFilter(c, "hammer_type"); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error parse query hammer_type": err})
			f.HaveParamCondition = true
			return
		}
		if f.SolderingElementType, err = setFilter(c, "soldering_element_type"); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error parse query soldering_element_type": err})
			f.HaveParamCondition = true
			return
		}
		if f.PowerSupplyType, err = setFilter(c, "power_supply_type"); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error parse query power_supply_type": err})
			f.HaveParamCondition = true
			return
		}
		if f.DrillType, err = setFilter(c, "drill_type"); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error parse query drill_type": err})
			f.HaveParamCondition = true
			return
		}
		if f.PlatformType, err = setFilter(c, "platform_type"); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error parse query platform_type": err})
			f.HaveParamCondition = true
			return
		}
		if f.BearingType, err = setFilter(c, "bearing_type"); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error parse query bearing_type": err})
			f.HaveParamCondition = true
			return
		}
		if f.ElevatorType, err = setFilter(c, "elevator_type"); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error parse query elevator_type": err})
			f.HaveParamCondition = true
			return
		}
		if f.DriveType, err = setFilter(c, "drive_type"); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error parse query drive_type": err})
			f.HaveParamCondition = true
			return
		}
		if f.CuttingMechanismType, err = setFilter(c, "cutting_mechanism_type"); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error parse query cutting_mechanism_type": err})
			f.HaveParamCondition = true
			return
		}
		if f.WeldingType, err = setFilter(c, "welding_type"); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error parse query welding_type": err})
			f.HaveParamCondition = true
			return
		}
		if f.TypeOfWeldingMachine, err = setFilter(c, "type_of_welding_machine"); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error parse query type_of_welding_machine": err})
			f.HaveParamCondition = true
			return
		}
		if f.TypeOfControlSystem, err = setFilter(c, "type_of_control_system"); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error parse query type_of_control_system": err})
			f.HaveParamCondition = true
			return
		}
		if f.FuelType, err = setFilter(c, "fuel_type"); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error parse query fuel_type": err})
			f.HaveParamCondition = true
			return
		}
		if f.CableType, err = setFilter(c, "cable_type"); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error parse query cable_type": err})
			f.HaveParamCondition = true
			return
		}
		if f.PipeBenderType, err = setFilter(c, "pipe_bender_type"); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error parse query pipe_bender_type": err})
			f.HaveParamCondition = true
			return
		}
		if f.PipeCutterType, err = setFilter(c, "pipe_cutter_type"); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error parse query pipe_cutter_type": err})
			f.HaveParamCondition = true
			return
		}
		if f.ControlType, err = setFilter(c, "control_type"); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error parse query control_type": err})
			f.HaveParamCondition = true
			return
		}
		if f.FilterType, err = setFilter(c, "filter_type"); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error parse query filter_type": err})
			f.HaveParamCondition = true
			return
		}
		if f.WeldingCurrent, err = setFilter(c, "welding_current"); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error parse query welding_current": err})
			f.HaveParamCondition = true
			return
		}
		if f.CuttingThickness, err = setFilter(c, "cutting_thickness"); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error parse query cutting_thickness": err})
			f.HaveParamCondition = true
			return
		}
		if f.MeasuringAccuracy, err = setFilter(c, "measuring_accuracy"); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error parse query measuring_accuracy": err})
			f.HaveParamCondition = true
			return
		}
		if f.CuttingAccuracy, err = setFilter(c, "cutting_accuracy"); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error parse query cutting_accuracy": err})
			f.HaveParamCondition = true
			return
		}
		if f.SawBladeTiltAngle, err = setFilter(c, "saw_blade_tilt_angle"); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error parse query saw_blade_tilt_angle": err})
			f.HaveParamCondition = true
			return
		}
		if f.TableTiltAngle, err = setFilter(c, "table_tilt_angle"); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error parse query table_tilt_angle": err})
			f.HaveParamCondition = true
			return
		}
		if f.PressingForce, err = setFilter(c, "pressing_force"); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error parse query pressing_force": err})
			f.HaveParamCondition = true
			return
		}
		if f.TravelLength, err = setFilter(c, "travel_length"); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error parse query travel_length": err})
			f.HaveParamCondition = true
			return
		}
		if f.SawStroke, err = setFilter(c, "saw_stroke"); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error parse query saw_stroke": err})
			f.HaveParamCondition = true
			return
		}
		if f.StrokeOfThePress, err = setFilter(c, "stroke_of_the_press"); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error parse query stroke_of_the_press": err})
			f.HaveParamCondition = true
			return
		}
		if f.StrokeFrequency, err = setFilter(c, "stroke_frequency"); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error parse query stroke_frequency": err})
			f.HaveParamCondition = true
			return
		}
		if f.NumberOfRevolutions, err = setFilter(c, "number_of_revolutions"); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error parse query number_of_revolutions": err})
			f.HaveParamCondition = true
			return
		}
		if f.NumberOfSawStrokesPerMinute, err = setFilter(c, "number_of_saw_strokes_per_minute"); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error parse query number_of_saw_strokes_per_minute": err})
			f.HaveParamCondition = true
			return
		}
		if f.Width, err = setFilter(c, "width"); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error parse query width": err})
			f.HaveParamCondition = true
			return
		}
		if f.BeltWidth, err = setFilter(c, "belt_width"); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error parse query belt_width": err})
			f.HaveParamCondition = true
			return
		}
		if f.WorkingWidth, err = setFilter(c, "working_width"); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error parse query working_width": err})
			f.HaveParamCondition = true
			return
		}
	}

	res, total, err := h.adEquipmentService.Get(c, f)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"ad_equipments": res, "total": total})
}

// @Summary	Получение списка AdEquipment
// @Tags		AdEquipment (объявления оборудование)
// @Accept		mpfd
// @Produce	json
// @Param		id	query		integer	true	"идентификатор оборудование"
// @Success	200	{object}	map[string]interface{}
// @Failure	400	{object}	map[string]interface{}
// @Failure	404	{object}	map[string]interface{}
// @Failure	500	{object}	map[string]interface{}
// @Router		/equipment/ad_equipment/{id} [get]
func (h *adEquipment) GetByID(c *gin.Context) {
	id, err := strconv.Atoi(c.Param("id"))
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": fmt.Errorf("id: %w", err).Error()})
		return
	}

	res, err := h.adEquipmentService.GetByID(c, id)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"ad_equipment": res})
}

// Update
// @Summary		Update AdEquipment
// @Description	Update an AdEquipment with new details
// @Tags			AdEquipment (объявления оборудование)
// @Accept			json
// @Produce		json
// @Param			id	path		integer	true	"ad equipment  ID"
// @Param			body	body		controller.Update.adEquipmentUpdateRequest	true	"Update details"
// @Success		200	{object}	map[string]interface{}
// @Failure		400	{object}	map[string]interface{}
// @Failure		404	{object}	map[string]interface{}
// @Failure		500	{object}	map[string]interface{}
// @Router			/equipment/ad_equipment/{id} [put]
func (h *adEquipment) Update(c *gin.Context) {
	type adEquipmentUpdateRequest struct {
		UserID                 int      `json:"user_id"`
		EquipmentBrandID       int      `json:"equipment_brand_id"`
		EquipmentSubСategoryID int      `json:"equipment_sub_сategory_id"`
		CityID                 int      `json:"city_id"`
		Price                  float64  `json:"price"`
		Title                  string   `json:"title"`
		Description            string   `json:"description"`
		Address                string   `json:"address"`
		Latitude               *float64 `json:"latitude"`
		Longitude              *float64 `json:"longitude"`
	}

	idParam := c.Param("id")
	if idParam == "" {
		c.JSON(http.StatusBadRequest, gin.H{"error": "missing id"})
		return
	}
	id, err := strconv.Atoi(idParam)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "wrong id format"})
		return
	}

	adR := adEquipmentUpdateRequest{}
	if err := c.ShouldBindJSON(&adR); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": fmt.Sprintf("invalid input: %s", err.Error())})
		return
	}

	updateAdEquipment := model.AdEquipment{
		ID:                     id,
		UserID:                 adR.UserID,
		EquipmentBrandID:       adR.EquipmentBrandID,
		EquipmentSubCategoryID: adR.EquipmentSubСategoryID,
		CityID:                 adR.CityID,
		Price:                  adR.Price,
		Title:                  adR.Title,
		Description:            adR.Description,
		Address:                adR.Address,
		Latitude:               adR.Latitude,
		Longitude:              adR.Longitude,
	}

	err = h.adEquipmentService.Update(c, updateAdEquipment)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"status": "success"})
}

// @Summary	Удаление AdEquipment
// @Tags		AdEquipment (объявления оборудование)
// @Accept		mpfd
// @Produce	json
// @Param		id	query		integer	true	"идентификатор оборудование"
// @Success	200	{object}	map[string]interface{}
// @Failure	400	{object}	map[string]interface{}
// @Failure	404	{object}	map[string]interface{}
// @Failure	500	{object}	map[string]interface{}
// @Router		/equipment/ad_equipment/{id} [delete]
func (h *adEquipment) Delete(c *gin.Context) {
	id, err := strconv.Atoi(c.Param("id"))
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": fmt.Errorf("id: %w", err).Error()})
		return
	}

	if err := h.adEquipmentService.Delete(c, id); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"status": "success"})
}

// @Summary	Получение список избранных
// @Tags		AdEquipment (объявления оборудование)
// @Accept		json
// @Produce	json
// @Param		Authorization	header		string	true	"приставка `Bearer` с пробелом и сам токен"
// @Success	200				{object}	[]model.FavoriteAdEquipment
// @Failure	400				{object}	map[string]interface{}
// @Failure	404				{object}	map[string]interface{}
// @Failure	500				{object}	map[string]interface{}
// @Router		/equipment/ad_equipment/favorite [get]
func (h *adEquipment) GetFavorite(c *gin.Context) {
	user, err := GetUserFromGin(c)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	fav, err := h.adEquipmentService.GetFavorite(c, user.ID)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"favorites": fav})
}

// @Summary	Сохранение в список избранных
// @Tags		AdEquipment (объявления оборудование)
// @Accept		json
// @Produce	json
// @Param		Authorization	header		string	true	"приставка `Bearer` с пробелом и сам токен"
// @Param		id				path		string	true	"идентификатор объявления"
// @Success	200				{object}	map[string]interface{}
// @Failure	400				{object}	map[string]interface{}
// @Failure	404				{object}	map[string]interface{}
// @Failure	500				{object}	map[string]interface{}
// @Router		/equipment/ad_equipment/:id/favorite [post]
func (h *adEquipment) CreateFavority(c *gin.Context) {
	user, err := GetUserFromGin(c)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	f := model.FavoriteAdEquipment{}

	id, err := strconv.Atoi(c.Param("id"))
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	f.UserID = user.ID
	f.AdEquipmentID = id

	if err := h.adEquipmentService.CreateFavorite(c, f); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"status": "success"})
}

// @Summary	Удаление из списока избранных
// @Tags		AdEquipment (объявления оборудование)
// @Accept		json
// @Produce	json
// @Param		Authorization	header		string	true	"приставка `Bearer` с пробелом и сам токен"
// @Param		id				path		string	true	"идентификатор объявления"
// @Success	200				{object}	map[string]interface{}
// @Failure	400				{object}	map[string]interface{}
// @Failure	404				{object}	map[string]interface{}
// @Failure	500				{object}	map[string]interface{}
// @Router		/equipment/ad_equipment/:id/favorite [delete]
func (h *adEquipment) DeleteFavorite(c *gin.Context) {
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

	if err := h.adEquipmentService.DeleteFavorite(c, model.FavoriteAdEquipment{
		UserID:        user.ID,
		AdEquipmentID: id,
	}); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"status": "success"})
}

// @Summary	Получение количество просмотров
// @Tags		AdEquipment (объявления оборудование)
// @Accept		json
// @Produce	json
// @Param		id	path		string	true	"идентификатор объявления"
// @Success	200	{object}	map[string]int
// @Failure	400	{object}	map[string]interface{}
// @Failure	404	{object}	map[string]interface{}
// @Failure	500	{object}	map[string]interface{}
// @Router		/equipment/ad_equipment/:id/seen [get]
func (h *adEquipment) GetSeen(c *gin.Context) {
	id, err := strconv.Atoi(c.Param("id"))
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"parameter": "id", "error": err.Error()})
		return
	}

	count, err := h.adEquipmentService.GetSeen(c, id)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"count": count})
}

// @Summary	Инкремент просмотра количество
// @Tags		AdEquipment (объявления оборудование)
// @Accept		json
// @Produce	json
// @Param		id	path		string	true	"идентификатор объявления"
// @Success	200	{object}	map[string]interface{}
// @Failure	400	{object}	map[string]interface{}
// @Failure	404	{object}	map[string]interface{}
// @Failure	500	{object}	map[string]interface{}
// @Router		/equipment/ad_equipment/:id/seen [post]
func (h *adEquipment) IncrementSeen(c *gin.Context) {
	id, err := strconv.Atoi(c.Param("id"))
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"parameter": "id", "error": err.Error()})
		return
	}

	err = h.adEquipmentService.IncrementSeen(c, id)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"status": "success"})
}
