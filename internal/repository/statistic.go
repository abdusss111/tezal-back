package repository

import (
	"context"
	"fmt"
	"strings"

	"gitlab.com/eqshare/eqshare-back/model"
	"gorm.io/gorm"
)

type IStatistic interface {
	GetRequestExecutionStatistic(status string) ([]model.RequestByStatusReport, error)
	GetAdClientStatistic() ([]model.AdReport, error)
	GetAdSmStatic() ([]model.AdReport, error)
	GetClientRequestStatistic(status string) ([]model.RequestByStatusReport, error)
	GetAdSpecializedMachineryStaticByID(id int) ([]model.AdSpecializedMachineryStatByID, error)
	GetAdClientStatisticByID(id int) ([]model.AdClinetStatByID, error)
	GetRequestExecutionHistory(id int) ([]model.RequestExectionHistory, error)
	RequestExectionStatusTime(id int) (model.RequestExectionStatusTime, error)
	AdClientCountBySubCategory(f model.FilterSubCategoryCount) ([]model.SubCategoryCount, error)
	AdSpecializedMachineryCountBySubCategory(f model.FilterSubCategoryCount) ([]model.SubCategoryCount, error)
	AdSpecializedMachineryCountByCategory(f model.FilterCategoryCount) ([]model.CategoryCount, error)
	AdClientCountByCategory(f model.FilterCategoryCount) ([]model.CategoryCount, error)
	AdEquipmentClientCountByCategory(ctx context.Context, f model.FilterCategoryCount) ([]model.CategoryCount, error)
	AdEquipmentCountByCategory(ctx context.Context, f model.FilterCategoryCount) ([]model.CategoryCount, error)
	AdEquipmentClientCountBySubCategory(ctx context.Context, f model.FilterCategoryCount) ([]model.CategoryCount, error)
	AdEquipmentCountBySubCategory(ctx context.Context, f model.FilterCategoryCount) ([]model.CategoryCount, error)
	RequestExectionSumPaymentAmount(ctx context.Context, f model.FilterRequestExecution) (int, error)
}

type rRepo struct {
	db *gorm.DB
}

func NewStatisticRepository(db *gorm.DB) *rRepo {
	return &rRepo{
		db: db,
	}
}

func (r *rRepo) GetRequestExecutionStatistic(status string) (adsm []model.RequestByStatusReport, err error) {
	stmt := r.db.Raw(`
		select status as as_report_id,
			sum(order_amount) as request_amount
		from specialized_machinery_requests
		group by status
	`).Where("status = ?", status).Scan(&adsm)

	if stmt.RowsAffected == 0 {
		return adsm, gorm.ErrRecordNotFound
	}

	return adsm, nil
}

func (r *rRepo) GetAdClientStatistic() (adc []model.AdReport, err error) {
	stmt := r.db.Raw(`
	SELECT t.id AS category_id, t.name AS category_type, COALESCE(a.as_amount, 0) AS ad_amount
	FROM types t
	LEFT JOIN (	SELECT a.type_id, COUNT(*) as as_amount
				FROM ad_clients a
				GROUP BY a.type_id) a ON a.type_id = t.id`)

	if stmt.RowsAffected == 0 {
		return adc, gorm.ErrRecordNotFound
	}

	return adc, nil
}

func (r *rRepo) GetAdSmStatic() (adReports []model.AdReport, err error) {
	stmt := r.db.Raw(`
	SELECT t.id as category_id, t.name as category_type, COALESCE(a.as_amount, 0) as ad_amount
	FROM types t
	LEFT JOIN (	SELECT a.type_id, 
				COUNT(*) AS as_amount 
				FROM ad_specialized_machineries a GROUP BY a.type_id) a ON a.type_id = t.id
	`).Scan(&adReports)

	if stmt.RowsAffected == 0 {
		return adReports, gorm.ErrRecordNotFound
	}

	return adReports, nil
}

func (r *rRepo) GetClientRequestStatistic(status string) (adc []model.RequestByStatusReport, err error) {
	//stmt := r.db.Raw(`
	//	select t.id as category_id,
	//		from ad_
	//`)

	return adc, nil
}

func (r *rRepo) GetAdSpecializedMachineryStaticByID(id int) ([]model.AdSpecializedMachineryStatByID, error) {
	stat := make([]model.AdSpecializedMachineryStatByID, 0)

	err := r.db.Raw(`SELECT status, COUNT(*) as "amount"
	FROM specialized_machinery_requests
	WHERE ad_specialized_machinery_id = ?
	GROUP BY status
	ORDER BY status`, id).Scan(&stat).Error
	if err != nil {
		return nil, err
	}

	return stat, nil
}

func (r *rRepo) GetAdClientStatisticByID(id int) ([]model.AdClinetStatByID, error) {
	stat := make([]model.AdClinetStatByID, 0)

	err := r.db.Raw(`SELECT status, COUNT(*) as "amount"
	FROM requests
	WHERE ad_client_id = ?
	GROUP BY status
	ORDER BY status`, id).Scan(&stat).Error
	if err != nil {
		return nil, err
	}

	return stat, nil
}

func (r *rRepo) GetRequestExecutionHistory(id int) ([]model.RequestExectionHistory, error) {
	res := make([]model.RequestExectionHistory, 0)
	err := r.db.Raw(`WITH a AS (SELECT h.id,
						  h.updated_at,
						  h.status,
						  LAG(status) OVER (ORDER BY h.updated_at)               AS prev_status,
						  LAG(updated_at, -1, NULL) OVER (ORDER BY h.updated_at) AS prev_time,
						  h.work_started_at,
						  h.work_end_at,
						  h.assign_to,
						  h.rate
				   FROM request_executions_histories h
				   WHERE id = ?)
		SELECT a.id,
			   a.status,
			   a.updated_at               AS start_status_at,
			   a.prev_time                AS end_status_at,
			   a.work_started_at,
			   a.work_end_at,
			   a.rate
		FROM a`, id).
		Scan(&res).Error
	if err != nil {
		return nil, err
	}

	for i, tr := range res {
		if tr.EndStatusAt.Valid {
			res[i].Duration = int(tr.EndStatusAt.Time.Sub(tr.StartStatusAt.Time))
		}
	}

	return res, nil
}

func (r *rRepo) RequestExectionStatusTime(id int) (model.RequestExectionStatusTime, error) {
	ret := model.RequestExectionStatusTime{}

	rows, err := r.db.Raw(`SELECT 
			h.status,
			h.updated_at,
			LAG(updated_at, -1, NULL) OVER (ORDER BY h.updated_at) AS prev_time
		FROM request_executions_histories h
		WHERE id = ?`, id).
		Rows()
	if err != nil {
		return ret, err
	}
	defer rows.Close()

	for rows.Next() {
		var (
			Status    string
			UpdatedAt model.Time
			PrevAt    model.Time
		)

		if err := rows.Scan(&Status, &UpdatedAt, &PrevAt); err != nil {
			return ret, err
		}

		dur := PrevAt.Time.Sub(UpdatedAt.Time)

		if dur < 0 {
			continue
		}

		switch Status {
		case "AWAITS_START":
			ret.AwaitsStart += int(dur)
		case "WORKING":
			ret.Working += int(dur)
		case "PAUSE":
			ret.Pause += int(dur)
		case "FINISHED":
			ret.Finished += int(dur)
		case "ON_ROAD":
			ret.OnRoad += int(dur)
		}
	}

	return ret, nil
}

func (r *rRepo) AdClientCountBySubCategory(f model.FilterSubCategoryCount) ([]model.SubCategoryCount, error) {
	sqlForman := `WITH a AS (SELECT type_id, COUNT(type_id) AS sum
		FROM ad_specialized_machineries
		%s
		GROUP BY type_id),
	b AS (SELECT id, name
		FROM types
		WHERE deleted_at IS NULL
		%s)
	SELECT b.id, b.name, COALESCE(a.sum, 0)
	FROM b
	LEFT JOIN a ON a.type_id = b.id`

	clauseWhere := ""
	clauseWhere2 := ""
	filterStrings1 := make([]string, 0, 10)

	args := make([]interface{}, 0)

	if f.CityID != nil {
		args = append(args, f.CityID)
		filterStrings1 = append(filterStrings1, "city_id = ?")
	}

	if len(f.IDs) != 0 {
		args = append(args, f.IDs)
		args = append(args, f.IDs)
		filterStrings1 = append(filterStrings1, "id IN (?)")
		clauseWhere2 = "AND id IN (?)"
	}

	if len(filterStrings1) != 0 {
		clauseWhere = fmt.Sprintf("WHERE %s", strings.Join(filterStrings1, " AND "))
	}

	sqlForman = fmt.Sprintf(sqlForman, clauseWhere, clauseWhere2)

	rows, err := r.db.Raw(sqlForman, args...).Rows()
	if err != nil {
		return nil, err
	}

	res := make([]model.SubCategoryCount, 0)
	defer rows.Close()
	for rows.Next() {
		c := model.SubCategoryCount{}
		if err := rows.Scan(&c.ID, &c.Name, &c.Count); err != nil {
			return nil, err
		}

		res = append(res, c)
	}

	return res, nil
}

func (r *rRepo) AdSpecializedMachineryCountBySubCategory(f model.FilterSubCategoryCount) ([]model.SubCategoryCount, error) {
	sqlForman := `WITH a AS (SELECT type_id, COUNT(type_id) AS sum
		FROM ad_specialized_machineries
		%s
		GROUP BY type_id),
	b AS (SELECT id, name
		FROM types
		WHERE deleted_at IS NULL
		%s)
	SELECT b.id, b.name, COALESCE(a.sum, 0)
	FROM b
	LEFT JOIN a ON a.type_id = b.id`

	clauseWhere := ""
	clauseWhere2 := ""
	filterStrings1 := make([]string, 0, 10)

	args := make([]interface{}, 0)

	if f.CityID != nil {
		args = append(args, f.CityID)
		filterStrings1 = append(filterStrings1, "city_id = ?")
	}

	if len(f.IDs) != 0 {
		args = append(args, f.IDs)
		args = append(args, f.IDs)
		filterStrings1 = append(filterStrings1, "id IN (?)")
		clauseWhere2 = "AND id IN (?)"
	}

	if len(filterStrings1) != 0 {
		clauseWhere = fmt.Sprintf("WHERE %s", strings.Join(filterStrings1, " AND "))
	}

	sqlForman = fmt.Sprintf(sqlForman, clauseWhere, clauseWhere2)

	rows, err := r.db.Raw(sqlForman, args...).Rows()
	if err != nil {
		return nil, err
	}

	res := make([]model.SubCategoryCount, 0)
	defer rows.Close()
	for rows.Next() {
		c := model.SubCategoryCount{}
		if err := rows.Scan(&c.ID, &c.Name, &c.Count); err != nil {
			return nil, err
		}

		res = append(res, c)
	}

	return res, nil
}

func (r *rRepo) AdSpecializedMachineryCountByCategory(f model.FilterCategoryCount) ([]model.CategoryCount, error) {
	sql := `WITH a AS (SELECT s.id, COUNT(s.id) AS count
				FROM ad_clients ad
						LEFT JOIN types t ON t.id = ad.type_id
						LEFT JOIN sub_categories s ON s.id = t.sub_category_id
						%s
				GROUP BY s.id)
			SELECT s.id, s.name, COALESCE(a.count, 0) AS count
			FROM sub_categories s
			LEFT JOIN a ON a.id = s.id
			%s`

	arg := make([]interface{}, 0)
	cityClause := ""
	idClause := ""

	if f.CityID != nil {
		arg = append(arg, f.CityID)
		cityClause = "WHERE city_id = ?"
	}

	if len(f.IDs) != 0 {
		arg = append(arg, f.IDs)
		idClause = "WHERE a.id in (?)"
	}

	sql = fmt.Sprintf(sql, cityClause, idClause)

	rows, err := r.db.Raw(sql, arg...).Rows()
	if err != nil {
		return nil, err
	}

	res := make([]model.CategoryCount, 0)
	defer rows.Close()
	for rows.Next() {
		c := model.CategoryCount{}

		if err := rows.Scan(&c.ID, &c.Name, &c.Count); err != nil {
			return nil, err
		}

		res = append(res, c)
	}

	return res, nil
}

func (r *rRepo) AdClientCountByCategory(f model.FilterCategoryCount) ([]model.CategoryCount, error) {
	sql := `WITH a AS (SELECT s.id, COUNT(s.id) AS count
				FROM ad_specialized_machineries ad
						LEFT JOIN types t ON t.id = ad.type_id
						LEFT JOIN sub_categories s ON s.id = t.sub_category_id
						%s
				GROUP BY s.id)
			SELECT s.id, s.name, COALESCE(a.count, 0) AS count
			FROM sub_categories s
			LEFT JOIN a ON a.id = s.id
			%s`

	arg := make([]interface{}, 0)
	cityClause := ""
	idClause := ""

	if f.CityID != nil {
		arg = append(arg, f.CityID)
		cityClause = "WHERE city_id = ?"
	}

	if len(f.IDs) != 0 {
		arg = append(arg, f.IDs)
		idClause = "WHERE a.id in (?)"
	}

	sql = fmt.Sprintf(sql, cityClause, idClause)

	rows, err := r.db.Raw(sql, arg...).Rows()
	if err != nil {
		return nil, err
	}

	res := make([]model.CategoryCount, 0)
	defer rows.Close()
	for rows.Next() {
		c := model.CategoryCount{}

		if err := rows.Scan(&c.ID, &c.Name, &c.Count); err != nil {
			return nil, err
		}

		res = append(res, c)
	}

	return res, nil
}

func (r *rRepo) AdEquipmentClientCountByCategory(ctx context.Context, f model.FilterCategoryCount) ([]model.CategoryCount, error) {
	sql := `
	WITH ad_eq as (SELECT eqc.id, count(*)
	               FROM ad_equipment_clients ad
	               LEFT JOIN equipment_sub_categories eqsc  on eqsc.id = ad.equipment_sub_category_id
	               LEFT JOIN equipment_categories eqc on eqsc.equipment_categories_id = eqc.id
				   %s
	               GROUP BY eqc.id
	)
	SELECT eqc.id, eqc.name, coalesce(ad_eq.count, 0)
	FROM equipment_categories eqc
	LEFT JOIN  ad_eq on ad_eq.id =  eqc.id
	WHERE eqc.deleted_at IS NULL %s`

	arg := make([]interface{}, 0)
	cityClause := ""
	idClause := ""

	if f.CityID != nil {
		arg = append(arg, f.CityID)
		cityClause = "WHERE ad.city_id = ?"
	}

	if len(f.IDs) != 0 {
		arg = append(arg, f.IDs)
		idClause = "AND eqc.id in (?)"
	}

	sql = fmt.Sprintf(sql, cityClause, idClause)

	rows, err := r.db.Raw(sql, arg...).Rows()
	if err != nil {
		return nil, err
	}

	res := make([]model.CategoryCount, 0)
	defer rows.Close()
	for rows.Next() {
		c := model.CategoryCount{}

		if err := rows.Scan(&c.ID, &c.Name, &c.Count); err != nil {
			return nil, err
		}

		res = append(res, c)
	}

	return res, nil
}

func (r *rRepo) AdEquipmentCountByCategory(ctx context.Context, f model.FilterCategoryCount) ([]model.CategoryCount, error) {
	sql := `
	WITH ad_eq as (SELECT eqc.id, count(*)
	               FROM ad_equipments ad
	               LEFT JOIN equipment_sub_categories eqsc  on eqsc.id = ad.equipment_sub_category_id
	               LEFT JOIN equipment_categories eqc on eqsc.equipment_categories_id = eqc.id
				   %s
	               GROUP BY eqc.id
	)
	SELECT eqc.id, eqc.name, coalesce(ad_eq.count, 0)
	FROM equipment_categories eqc
	LEFT JOIN  ad_eq on ad_eq.id =  eqc.id
	WHERE eqc.deleted_at IS NULL %s`

	arg := make([]interface{}, 0)
	cityClause := ""
	idClause := ""

	if f.CityID != nil {
		arg = append(arg, f.CityID)
		cityClause = "WHERE ad.city_id = ?"
	}

	if len(f.IDs) != 0 {
		arg = append(arg, f.IDs)
		idClause = "AND eqc.id in (?)"
	}

	sql = fmt.Sprintf(sql, cityClause, idClause)

	rows, err := r.db.Raw(sql, arg...).Rows()
	if err != nil {
		return nil, err
	}

	res := make([]model.CategoryCount, 0)
	defer rows.Close()
	for rows.Next() {
		c := model.CategoryCount{}

		if err := rows.Scan(&c.ID, &c.Name, &c.Count); err != nil {
			return nil, err
		}

		res = append(res, c)
	}

	return res, nil
}

func (r *rRepo) AdEquipmentClientCountBySubCategory(ctx context.Context, f model.FilterCategoryCount) ([]model.CategoryCount, error) {
	sql := `
	WITH ad_eq as (SELECT ad.equipment_sub_category_id, count(*)
				FROM ad_equipment_clients ad
					%s
				GROUP BY ad.equipment_sub_category_id
	)
	SELECT eqc.id, eqc.name, coalesce(ad_eq.count, 0)
	FROM equipment_sub_categories eqc
	LEFT JOIN  ad_eq on ad_eq.equipment_sub_category_id =  eqc.id
	WHERE eqc.deleted_at IS NULL %s`

	arg := make([]interface{}, 0)
	cityClause := ""
	idClause := ""

	if f.CityID != nil {
		arg = append(arg, f.CityID)
		cityClause = "WHERE ad.city_id = ?"
	}

	if len(f.IDs) != 0 {
		arg = append(arg, f.IDs)
		idClause = "AND eqc.equipment_sub_category_id in (?)"
	}

	sql = fmt.Sprintf(sql, cityClause, idClause)

	rows, err := r.db.Raw(sql, arg...).Rows()
	if err != nil {
		return nil, err
	}

	res := make([]model.CategoryCount, 0)
	defer rows.Close()
	for rows.Next() {
		c := model.CategoryCount{}

		if err := rows.Scan(&c.ID, &c.Name, &c.Count); err != nil {
			return nil, err
		}

		res = append(res, c)
	}

	return res, nil
}

func (r *rRepo) AdEquipmentCountBySubCategory(ctx context.Context, f model.FilterCategoryCount) ([]model.CategoryCount, error) {
	sql := `
	WITH ad_eq as (SELECT ad.equipment_sub_category_id, count(*)
				FROM ad_equipments ad
					%s
				GROUP BY ad.equipment_sub_category_id)
	SELECT eqc.id, eqc.name, coalesce(ad_eq.count, 0)
	FROM equipment_sub_categories eqc
	LEFT JOIN  ad_eq on ad_eq.equipment_sub_category_id =  eqc.id
	WHERE eqc.deleted_at IS NULL %s`

	arg := make([]interface{}, 0)
	cityClause := ""
	idClause := ""

	if f.CityID != nil {
		arg = append(arg, f.CityID)
		cityClause = "WHERE ad.city_id = ?"
	}

	if len(f.IDs) != 0 {
		arg = append(arg, f.IDs)
		idClause = "AND eqc.equipment_sub_category_id in (?)"
	}

	sql = fmt.Sprintf(sql, cityClause, idClause)

	rows, err := r.db.Raw(sql, arg...).Rows()
	if err != nil {
		return nil, err
	}

	res := make([]model.CategoryCount, 0)
	defer rows.Close()
	for rows.Next() {
		c := model.CategoryCount{}

		if err := rows.Scan(&c.ID, &c.Name, &c.Count); err != nil {
			return nil, err
		}

		res = append(res, c)
	}

	return res, nil
}

func (r *rRepo) RequestExectionSumPaymentAmount(ctx context.Context, f model.FilterRequestExecution) (int, error) {
	stmt := r.db.Model(&model.RequestExecution{})

	if f.ClientID != nil {
		stmt = stmt.Where("clinet_id = ?", f.ClientID)
	}

	if f.DriverID != nil {
		stmt = stmt.Where("driver_id = ?", f.DriverID)
	}

	if f.AssignTo != nil {
		stmt = stmt.Where(`assign_to = ?`, f.AssignTo)
	}

	if f.Status != nil {
		stmt = stmt.Where(`status in (?)`, f.Status)
	}

	if f.Src != nil {
		stmt = stmt.Where(`src in (?)`, f.Src)
	}

	if f.MinUpdatedAt.Valid {
		stmt = stmt.Where("updated_at >= ?", f.MinUpdatedAt)
	}

	if f.MaxUpdatedAt.Valid {
		stmt = stmt.Where("updated_at <= ?", f.MaxUpdatedAt)
	}

	if len(f.ASC) != 0 {
		temp := make([]string, 0, len(f.ASC))
		for _, val := range f.ASC {
			temp = append(temp, fmt.Sprintf("%s ASC", val))
		}

		stmt = stmt.Order(strings.Join(temp, ", "))
	}

	if len(f.DESC) != 0 {
		temp := make([]string, 0, len(f.DESC))
		for _, val := range f.DESC {
			temp = append(temp, fmt.Sprintf("%s DESC", val))
		}

		stmt = stmt.Order(strings.Join(temp, ", "))
	}

	res := stmt.Select("coalesce(sum(driver_payment_amount), 0)").Row()
	if err := res.Err(); err != nil {
		return 0, err
	}

	sum := 0

	if err := res.Scan(&sum); err != nil {
		return 0, err
	}

	return sum, nil
}
