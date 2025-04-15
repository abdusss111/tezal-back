package repository

import (
	"context"
	"database/sql"
	"errors"
	"fmt"

	"gitlab.com/eqshare/eqshare-back/model"
	"gorm.io/gorm"
)

type IAdEquipment interface {
	Get(ctx context.Context, f model.FilterAdEquipment) ([]model.AdEquipment, int, error)
	GetByID(ctx context.Context, id int) (model.AdEquipment, error)
	Create(ctx context.Context, ad model.AdEquipment) (int, error)
	Update(ctx context.Context, ad model.AdEquipment) error
	Delete(ctx context.Context, id int) error
	GetByIDSeen(ctx context.Context, id int) (int, error)
	CreateSeen(ctx context.Context, id int) error
	IncrementSeen(ctx context.Context, id int) error
	GetCountBySubCategory(ctx context.Context) (map[int]int, error)
}

type adEquipment struct {
	db *gorm.DB
}

func NewAdEquipment(db *gorm.DB) IAdEquipment {
	return &adEquipment{db: db}
}

func (repo *adEquipment) Get(ctx context.Context, f model.FilterAdEquipment) ([]model.AdEquipment, int, error) {
	res := make([]model.AdEquipment, 0)

	stmt := repo.db.WithContext(ctx)

	if f.UserDetail != nil && *f.UserDetail {
		stmt = stmt.Preload("User")
	}
	if f.EquipmentBrandDetail != nil && *f.EquipmentBrandDetail {
		stmt = stmt.Preload("EquipmentBrand")
	}
	if f.EquipmentSubcategoryDetail != nil && *f.EquipmentSubcategoryDetail {
		stmt = stmt.Preload("EquipmentSubCategory")
	}
	if f.CityDetail != nil && *f.CityDetail {
		stmt = stmt.Preload("City")
	}
	if f.DocumentsDetail != nil && *f.DocumentsDetail {
		stmt = stmt.Preload("Documents")
	}
	if f.ParamsDetail != nil && *f.ParamsDetail {
		stmt = stmt.Preload("Params")
	}
	if f.Unscoped != nil && *f.Unscoped {
		stmt = stmt.Unscoped()
	}
	if len(f.IDs) != 0 {
		stmt = stmt.Where("id in (?)", f.IDs)
	}
	if len(f.UserIDs) != 0 {
		stmt = stmt.Where("user_id in (?)", f.UserIDs)
	}
	if len(f.CityIDs) != 0 {
		stmt = stmt.Where("city_id in (?)", f.CityIDs)
	}
	if len(f.EquipmentSubСategoryIDs) != 0 {
		stmt = stmt.Where("equipment_sub_category_id in (?)", f.EquipmentSubСategoryIDs)
	}
	if len(f.EquipmentСategoryIDs) != 0 {
		stmt = stmt.Where(`equipment_sub_category_id in (SELECT id
			FROM equipment_sub_categories
			WHERE equipment_categories_id in (?))`, f.EquipmentСategoryIDs)
	}
	if len(f.EquipmentBrandIDs) != 0 {
		stmt = stmt.Where("equipment_brand_id in (?)", f.EquipmentBrandIDs)
	}
	if f.Title != nil {
		stmt = stmt.Where("title ILIKE '%' || ? || '%'", f.Title)
	}
	if f.Description != nil {
		stmt = stmt.Where("description ILIKE '%' || ? || '%'", f.Title)
	}

	if f.HaveParamCondition {
		stmt2 := repo.db.WithContext(ctx).Table("ad_equipment_params").Select("ad_equipment_id")

		stmt2 = setFilterParamByStmt(stmt2, "weight", f.Weight)
		stmt2 = setFilterParamByStmt(stmt2, "reach", f.Reach)
		stmt2 = setFilterParamByStmt(stmt2, "height", f.Height)
		stmt2 = setFilterParamByStmt(stmt2, "lifting_height", f.LiftingHeight)
		stmt2 = setFilterParamByStmt(stmt2, "working_depth", f.WorkingDepth)
		stmt2 = setFilterParamByStmt(stmt2, "cutting_depth", f.CuttingDepth)
		stmt2 = setFilterParamByStmt(stmt2, "load_capacity_kg", f.LoadCapacityKg)
		stmt2 = setFilterParamByStmt(stmt2, "load_capacity_t", f.LoadCapacityT)
		stmt2 = setFilterParamByStmt(stmt2, "bending_diameter", f.BendingDiameter)
		stmt2 = setFilterParamByStmt(stmt2, "machining_diameter", f.MachiningDiameter)
		stmt2 = setFilterParamByStmt(stmt2, "chuck_diameter", f.ChuckDiameter)
		stmt2 = setFilterParamByStmt(stmt2, "saw_blade_diameter", f.SawBladeDiameter)
		stmt2 = setFilterParamByStmt(stmt2, "cutting_diameter", f.CuttingDiameter)
		stmt2 = setFilterParamByStmt(stmt2, "drilling_diameter", f.DrillingDiameter)
		stmt2 = setFilterParamByStmt(stmt2, "pipe_diameter", f.PipeDiameter)
		stmt2 = setFilterParamByStmt(stmt2, "angle_measuring_range", f.AngleMeasuringRange)
		stmt2 = setFilterParamByStmt(stmt2, "hose_length", f.HoseLength)
		stmt2 = setFilterParamByStmt(stmt2, "hose_diameter", f.HoseDiameter)
		stmt2 = setFilterParamByStmt(stmt2, "measuring_length", f.MeasuringLength)
		stmt2 = setFilterParamByStmt(stmt2, "saw_band_length", f.SawBandLength)
		stmt2 = setFilterParamByStmt(stmt2, "saw_band_width", f.SawBandWidth)
		stmt2 = setFilterParamByStmt(stmt2, "rope_length", f.RopeLength)
		stmt2 = setFilterParamByStmt(stmt2, "length", f.Length)
		stmt2 = setFilterParamByStmt(stmt2, "working_length", f.WorkingLength)
		stmt2 = setFilterParamByStmt(stmt2, "cutting_length", f.CuttingLength)
		stmt2 = setFilterParamByStmt(stmt2, "handle_length", f.HandleLength)
		stmt2 = setFilterParamByStmt(stmt2, "cable_length", f.CableLength)
		stmt2 = setFilterParamByStmt(stmt2, "oil_tank_capacity", f.OilTankCapacity)
		stmt2 = setFilterParamByStmt(stmt2, "fuel_tank_capacity", f.FuelTankCapacity)
		stmt2 = setFilterParamByStmt(stmt2, "number_tools", f.NumberTools)
		stmt2 = setFilterParamByStmt(stmt2, "type_of_tools", f.TypeOfTools)
		stmt2 = setFilterParamByStmt(stmt2, "number_of_axles", f.NumberOfAxles)
		stmt2 = setFilterParamByStmt(stmt2, "number_of_flasks", f.NumberOfFlasks)
		stmt2 = setFilterParamByStmt(stmt2, "max_workpiece_height", f.MaxWorkpieceHeight)
		stmt2 = setFilterParamByStmt(stmt2, "maximum_lifting_height", f.MaximumLiftingHeight)
		stmt2 = setFilterParamByStmt(stmt2, "maximum_cutting_depth_in_wood", f.MaximumCuttingDepthInWood)
		stmt2 = setFilterParamByStmt(stmt2, "maximum_cutting_depth_in_metal", f.MaximumCuttingDepthInMetal)
		stmt2 = setFilterParamByStmt(stmt2, "maximum_cutting_depth_in_plastic", f.MaximumCuttingDepthInPlastic)
		stmt2 = setFilterParamByStmt(stmt2, "maximum_cutting_depth", f.MaximumCuttingDepth)
		stmt2 = setFilterParamByStmt(stmt2, "maximum_cutting_depth_at90", f.MaximumCuttingDepthAt90)
		stmt2 = setFilterParamByStmt(stmt2, "maximum_cutting_depth_at_angular_position", f.MaximumCuttingDepthAtAngularPosition)
		stmt2 = setFilterParamByStmt(stmt2, "maximum_wheel_weight", f.MaximumWheelWeight)
		stmt2 = setFilterParamByStmt(stmt2, "maximum_power_w", f.MaximumPowerW)
		stmt2 = setFilterParamByStmt(stmt2, "maximum_power_kw", f.MaximumPowerKw)
		stmt2 = setFilterParamByStmt(stmt2, "maximum_load", f.MaximumLoad)
		stmt2 = setFilterParamByStmt(stmt2, "maximum_lifting_speed", f.MaximumLiftingSpeed)
		stmt2 = setFilterParamByStmt(stmt2, "maximum_material_thickness", f.MaximumMaterialThickness)
		stmt2 = setFilterParamByStmt(stmt2, "maximum_cutting_width", f.MaximumCuttingWidth)
		stmt2 = setFilterParamByStmt(stmt2, "maximum_force", f.MaximumForce)
		stmt2 = setFilterParamByStmt(stmt2, "maximum_wheel_diameter", f.MaximumWheelDiameter)
		stmt2 = setFilterParamByStmt(stmt2, "maximum_diameter_of_self_drilling_screw", f.MaximumDiameterOfSelfDrillingScrew)
		stmt2 = setFilterParamByStmt(stmt2, "maximum_drilling_diameter_in_wood", f.MaximumDrillingDiameterInWood)
		stmt2 = setFilterParamByStmt(stmt2, "maximum_drilling_diameter_in_metal", f.MaximumDrillingDiameterInMetal)
		stmt2 = setFilterParamByStmt(stmt2, "tube_material", f.TubeMaterial)
		stmt2 = setFilterParamByStmt(stmt2, "band_locking_mechanism", f.BandLockingMechanism)
		stmt2 = setFilterParamByStmt(stmt2, "power_w", f.PowerW)
		stmt2 = setFilterParamByStmt(stmt2, "burner_power", f.BurnerPower)
		stmt2 = setFilterParamByStmt(stmt2, "motor_power", f.MotorPower)
		stmt2 = setFilterParamByStmt(stmt2, "power_kw", f.PowerKw)
		stmt2 = setFilterParamByStmt(stmt2, "drive_power", f.DrivePower)
		stmt2 = setFilterParamByStmt(stmt2, "spindle_power", f.SpindlePower)
		stmt2 = setFilterParamByStmt(stmt2, "voltage", f.Voltage)
		stmt2 = setFilterParamByStmt(stmt2, "frequency", f.Frequency)
		stmt2 = setFilterParamByStmt(stmt2, "rated_frequency", f.RatedFrequency)
		stmt2 = setFilterParamByStmt(stmt2, "rated_voltage", f.RatedVoltage)
		stmt2 = setFilterParamByStmt(stmt2, "rated_current", f.RatedCurrent)
		stmt2 = setFilterParamByStmt(stmt2, "drum_volume", f.DrumVolume)
		stmt2 = setFilterParamByStmt(stmt2, "capacity_kgh", f.CapacityKgh)
		stmt2 = setFilterParamByStmt(stmt2, "capacity_kw", f.CapacityKw)
		stmt2 = setFilterParamByStmt(stmt2, "capacity_liters_hour", f.CapacityLitersHour)
		stmt2 = setFilterParamByStmt(stmt2, "capacity_th", f.CapacityTh)
		stmt2 = setFilterParamByStmt(stmt2, "working_pressure", f.WorkingPressure)
		stmt2 = setFilterParamByStmt(stmt2, "gas_working_pressure", f.GasWorkingPressure)
		stmt2 = setFilterParamByStmt(stmt2, "table_working_size", f.TableWorkingSize)
		stmt2 = setFilterParamByStmt(stmt2, "bending_radius_m", f.BendingRadiusM)
		stmt2 = setFilterParamByStmt(stmt2, "bending_radius_mm", f.BendingRadiusMm)
		stmt2 = setFilterParamByStmt(stmt2, "table_dimensions_mm", f.TableDimensionsMm)
		stmt2 = setFilterParamByStmt(stmt2, "table_dimensions_mm2", f.TableDimensionsMm2)
		stmt2 = setFilterParamByStmt(stmt2, "gas_supply_system", f.GasSupplySystem)
		stmt2 = setFilterParamByStmt(stmt2, "drum_rotation_speed", f.DrumRotationSpeed)
		stmt2 = setFilterParamByStmt(stmt2, "rotation_speed", f.RotationSpeed)
		stmt2 = setFilterParamByStmt(stmt2, "saw_blade_speed", f.SawBladeSpeed)
		stmt2 = setFilterParamByStmt(stmt2, "spindle_speed", f.SpindleSpeed)
		stmt2 = setFilterParamByStmt(stmt2, "belt_speed", f.BeltSpeed)
		stmt2 = setFilterParamByStmt(stmt2, "speed", f.Speed)
		stmt2 = setFilterParamByStmt(stmt2, "lifting_speed", f.LiftingSpeed)
		stmt2 = setFilterParamByStmt(stmt2, "cutting_speed", f.CuttingSpeed)
		stmt2 = setFilterParamByStmt(stmt2, "temperature_range", f.TemperatureRange)
		stmt2 = setFilterParamByStmt(stmt2, "battery_type", f.BatteryType)
		stmt2 = setFilterParamByStmt(stmt2, "display_type", f.DisplayType)
		stmt2 = setFilterParamByStmt(stmt2, "start_type", f.StartType)
		stmt2 = setFilterParamByStmt(stmt2, "measurement_type", f.MeasurementType)
		stmt2 = setFilterParamByStmt(stmt2, "type_of_gas_used", f.TypeOfGasUsed)
		stmt2 = setFilterParamByStmt(stmt2, "type_of_saws_used", f.TypeOfSawsUsed)
		stmt2 = setFilterParamByStmt(stmt2, "type_of_cable_bender", f.TypeOfCableBender)
		stmt2 = setFilterParamByStmt(stmt2, "type_of_cable_cutter", f.TypeOfCableCutter)
		stmt2 = setFilterParamByStmt(stmt2, "type_of_rope", f.TypeOfRope)
		stmt2 = setFilterParamByStmt(stmt2, "crane_type", f.CraneType)
		stmt2 = setFilterParamByStmt(stmt2, "type_of_tape", f.TypeOfTape)
		stmt2 = setFilterParamByStmt(stmt2, "pump_type", f.PumpType)
		stmt2 = setFilterParamByStmt(stmt2, "hammer_type", f.HammerType)
		stmt2 = setFilterParamByStmt(stmt2, "soldering_element_type", f.SolderingElementType)
		stmt2 = setFilterParamByStmt(stmt2, "power_supply_type", f.PowerSupplyType)
		stmt2 = setFilterParamByStmt(stmt2, "drill_type", f.DrillType)
		stmt2 = setFilterParamByStmt(stmt2, "platform_type", f.PlatformType)
		stmt2 = setFilterParamByStmt(stmt2, "bearing_type", f.BearingType)
		stmt2 = setFilterParamByStmt(stmt2, "elevator_type", f.ElevatorType)
		stmt2 = setFilterParamByStmt(stmt2, "drive_type", f.DriveType)
		stmt2 = setFilterParamByStmt(stmt2, "cutting_mechanism_type", f.CuttingMechanismType)
		stmt2 = setFilterParamByStmt(stmt2, "welding_type", f.WeldingType)
		stmt2 = setFilterParamByStmt(stmt2, "type_of_welding_machine", f.TypeOfWeldingMachine)
		stmt2 = setFilterParamByStmt(stmt2, "type_of_control_system", f.TypeOfControlSystem)
		stmt2 = setFilterParamByStmt(stmt2, "fuel_type", f.FuelType)
		stmt2 = setFilterParamByStmt(stmt2, "cable_type", f.CableType)
		stmt2 = setFilterParamByStmt(stmt2, "pipe_bender_type", f.PipeBenderType)
		stmt2 = setFilterParamByStmt(stmt2, "pipe_cutter_type", f.PipeCutterType)
		stmt2 = setFilterParamByStmt(stmt2, "control_type", f.ControlType)
		stmt2 = setFilterParamByStmt(stmt2, "filter_type", f.FilterType)
		stmt2 = setFilterParamByStmt(stmt2, "welding_current", f.WeldingCurrent)
		stmt2 = setFilterParamByStmt(stmt2, "cutting_thickness", f.CuttingThickness)
		stmt2 = setFilterParamByStmt(stmt2, "measuring_accuracy", f.MeasuringAccuracy)
		stmt2 = setFilterParamByStmt(stmt2, "cutting_accuracy", f.CuttingAccuracy)
		stmt2 = setFilterParamByStmt(stmt2, "saw_blade_tilt_angle", f.SawBladeTiltAngle)
		stmt2 = setFilterParamByStmt(stmt2, "table_tilt_angle", f.TableTiltAngle)
		stmt2 = setFilterParamByStmt(stmt2, "pressing_force", f.PressingForce)
		stmt2 = setFilterParamByStmt(stmt2, "travel_length", f.TravelLength)
		stmt2 = setFilterParamByStmt(stmt2, "saw_stroke", f.SawStroke)
		stmt2 = setFilterParamByStmt(stmt2, "stroke_of_the_press", f.StrokeOfThePress)
		stmt2 = setFilterParamByStmt(stmt2, "stroke_frequency", f.StrokeFrequency)
		stmt2 = setFilterParamByStmt(stmt2, "number_of_revolutions", f.NumberOfRevolutions)
		stmt2 = setFilterParamByStmt(stmt2, "number_of_saw_strokes_per_minute", f.NumberOfSawStrokesPerMinute)
		stmt2 = setFilterParamByStmt(stmt2, "width", f.Width)
		stmt2 = setFilterParamByStmt(stmt2, "belt_width", f.BeltWidth)
		stmt2 = setFilterParamByStmt(stmt2, "working_width", f.WorkingWidth)

		rows, err := stmt2.Rows()
		if err != nil {
			return nil, 0, fmt.Errorf("repository adEquipment `Get` `GetParam`: %w", stmt.Error)
		}

		ids := make([]int, 0)
		defer rows.Close()

		for rows.Next() {
			var id int

			if err := rows.Scan(&id); err != nil {
				return nil, 0, fmt.Errorf("repository adEquipment `Get` `GetParam` `Scan`: %w", stmt.Error)
			}

			ids = append(ids, id)
		}

		stmt = stmt.Where("id in (?)", ids)
	}

	if len(f.ASC) != 0 {
		for _, v := range f.ASC {
			stmt = stmt.Order(fmt.Sprintf("%s ASC", v))
		}
	}
	if len(f.DESC) != 0 {
		for _, v := range f.DESC {
			stmt = stmt.Order(fmt.Sprintf("%s DESC", v))
		}
	}
	if f.Limit != nil {
		stmt = stmt.Limit(*f.Limit)
	}
	if f.Offset != nil {
		stmt = stmt.Offset(*f.Offset)
	}

	stmt = setFilterParamByStmt(stmt, "price", f.Price)

	stmt = stmt.Find(&res)
	if stmt.Error != nil {
		return nil, 0, fmt.Errorf("repository adEquipment `Get` `Find`: %w", stmt.Error)
	}

	var n int64
	stmt = stmt.Limit(-1).Offset(-1)
	stmt = stmt.Count(&n)
	if stmt.Error != nil {
		return nil, 0, fmt.Errorf("repository adEquipment `Get` `Count`: %w", stmt.Error)
	}

	return res, int(n), nil
}

func (repo *adEquipment) GetByID(ctx context.Context, id int) (model.AdEquipment, error) {
	res := model.AdEquipment{}

	err := repo.db.WithContext(ctx).
		Unscoped().
		Preload("User").
		Preload("EquipmentBrand").
		Preload("EquipmentSubCategory").
		Preload("City").
		Preload("Documents").
		Find(&res, id).Error
	if err != nil {
		return res, fmt.Errorf("repository adEquipment `GetByID` `Find`: %w", err)
	}

	return res, nil
}

func (repo *adEquipment) Create(ctx context.Context, ad model.AdEquipment) (int, error) {
	tx := repo.db.Begin()

	err := tx.Omit("Params", "count_rate", "rating").Create(&ad).Error
	if err != nil {
		tx.Rollback()
		return 0, fmt.Errorf("repository adEquipment: Create: Create base: %w", err)
	}

	ad.Params.AdEquipmentID = ad.ID

	err = tx.Create(&ad.Params).Error
	if err != nil {
		tx.Rollback()
		return 0, fmt.Errorf("repository adEquipment: Create: Create params: %w", err)
	}

	tx.Commit()
	return ad.ID, nil
}

func (repo *adEquipment) Update(ctx context.Context, ad model.AdEquipment) error {
	value := map[string]interface{}{
		"user_id":                   ad.UserID,
		"equipment_brand_id":        ad.EquipmentBrandID,
		"equipment_sub_category_id": ad.EquipmentSubCategoryID,
		"city_id":                   ad.CityID,
		"price":                     ad.Price,
		"title":                     ad.Title,
		"description":               ad.Description,
		"address":                   ad.Address,
		"latitude":                  ad.Latitude,
		"longitude":                 ad.Longitude,
	}

	err := repo.db.WithContext(ctx).Model(&model.AdEquipment{}).Where("id = ?", ad.ID).Updates(value).Error
	if err != nil {
		return fmt.Errorf("repository adEquipment `Update` `Updates`: %w", err.Error())
	}

	return nil
}

func (repo *adEquipment) Delete(ctx context.Context, id int) error {
	err := repo.db.WithContext(ctx).Delete(&model.AdEquipment{}, id).Error
	if err != nil {
		return fmt.Errorf("repository adEquipment `Delete` `Delete`: %w", err)
	}

	return nil
}

func (repo *adEquipment) GetByIDSeen(ctx context.Context, id int) (int, error) {
	stmt := repo.db.WithContext(ctx).Table("ad_equipment_seen")

	rows := stmt.Where("ad_equipments_id = ?", id).Select("count").Row()
	if rows.Err() != nil {
		return 0, fmt.Errorf("repository adEquipment `GetByIDSeen`: %w", rows.Err())
	}

	count := 0

	err := rows.Scan(&count)
	if err != nil {
		if errors.Is(err, sql.ErrNoRows) {
			return 0, fmt.Errorf("repository adEquipment `GetByIDSeen`: %w", model.ErrNotFound)
		}
		return 0, fmt.Errorf("repository adEquipment `GetByIDSeen`: %w", err)
	}

	return count, nil
}

func (repo *adEquipment) CreateSeen(ctx context.Context, id int) error {
	stmt := repo.db.WithContext(ctx).Table("ad_equipment_seen")

	stmt = stmt.Exec(`INSERT INTO ad_equipment_seen (ad_equipments_id)
	VALUES (?)`, id)
	if stmt.Error != nil {
		return fmt.Errorf("repository adEquipment `CreateSeen`: %w", stmt.Error)
	}

	return nil
}

func (repo *adEquipment) IncrementSeen(ctx context.Context, id int) error {
	stmt := repo.db.WithContext(ctx).Table("ad_equipment_seen")

	stmt = stmt.Exec(`UPDATE ad_equipment_seen
	SET count = count + 1
	WHERE ad_equipments_id = ?`, id)
	if stmt.Error != nil {
		if errors.Is(stmt.Error, gorm.ErrRecordNotFound) {
			return fmt.Errorf("repository adEquipment `IncrementSeen`: %w", model.ErrNotFound)
		}
		return fmt.Errorf("repository adEquipment `IncrementSeen`: %w", stmt.Error)
	}

	return nil
}

func (repo *adEquipment) GetCountBySubCategory(ctx context.Context) (map[int]int, error) {
	rows, err := repo.db.Raw(`
		SELECT equipment_sub_category_id, count(equipment_sub_category_id)
		FROM ad_equipments
		WHERE deleted_at IS NULL
		GROUP BY equipment_sub_category_id
		ORDER BY count(equipment_sub_category_id) DESC`).
		Rows()
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	countById := make(map[int]int, 0)

	for rows.Next() {
		var (
			id    int
			count int
		)
		if err := rows.Scan(&id, &count); err != nil {
			return nil, err
		}

		countById[id] = count
	}

	return countById, nil
}
