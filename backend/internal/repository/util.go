package repository

import (
	"fmt"
	"gitlab.com/eqshare/eqshare-back/model"
	"gorm.io/gorm"
)

func setFilterParamByStmt(stmt *gorm.DB, paramName string, param model.ParamMinMax) *gorm.DB {
	if !param.Valid {
		return stmt
	}

	if param.Max == nil {
		stmt = stmt.Where(fmt.Sprintf("%s >= ? OR %s IS NULL ", paramName, paramName), param.Min)
	} else {
		stmt = stmt.Where(fmt.Sprintf("%s BETWEEN ? AND ? OR %s IS NULL", paramName, paramName), param.Min, param.Max)
	}

	return stmt
}
