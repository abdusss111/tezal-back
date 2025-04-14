package controller

import (
	"github.com/gin-gonic/gin"
	"gitlab.com/eqshare/eqshare-back/model"
)

func setFilter(c *gin.Context, paramName string) (model.ParamMinMax, error) {
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
