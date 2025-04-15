package elastic

import (
	"bytes"
	"context"
	"encoding/json"
	"errors"
	"fmt"
	"io"
	"strconv"

	"github.com/elastic/go-elasticsearch/v7"
	"github.com/sirupsen/logrus"
	"gitlab.com/eqshare/eqshare-back/model"
)

const (
	indexCategoryEq = "index_category_eq_v8"
)

type ICategoryEq interface {
	SearchSimple(ctx context.Context, match string, subCategoryIDs []int) ([]model.EquipmentCategory, error)
	Create(ctx context.Context, category model.EquipmentCategory) error
	Update(ctx context.Context, ad model.EquipmentCategory) error
	Update1(ctx context.Context, ad model.EquipmentSubCategory) error
	Delete(ctx context.Context, id int) error
}

type categoryEq struct {
	client *elasticsearch.Client
}

func NewCategoryEq(cl *elasticsearch.Client) ICategoryEq {
	return &categoryEq{
		client: cl,
	}
}

func (es *categoryEq) SearchSimple(ctx context.Context, match string, subCategoryIDs []int) ([]model.EquipmentCategory, error) {
	var buf bytes.Buffer

	whereStmt := make([]map[string]interface{}, 0)

	{
		whereStmt = append(whereStmt, map[string]interface{}{
			"match": map[string]interface{}{
				"name": map[string]interface{}{
					"query":     match,
					"fuzziness": "AUTO", // Позволяет находить слова с опечатками
				},
			},
		})
		whereStmt = append(whereStmt, map[string]interface{}{
			"wildcard": map[string]interface{}{
				"name": map[string]interface{}{
					"value":            fmt.Sprintf("*%s*", match),
					"case_insensitive": true, // Игнорирует регистр
				},
			},
		})

		whereStmt = append(whereStmt, map[string]interface{}{
			"prefix": map[string]interface{}{
				"name": match, // Например, "авт" найдет "автокран"
			},
		})

		//whereStmt = append(whereStmt, map[string]interface{}{
		//	"match": map[string]interface{}{
		//		"equipment_sub_categories.name": map[string]interface{}{
		//			"query":     match,
		//			"fuzziness": "AUTO",
		//		},
		//	},
		//})
	}

	if len(subCategoryIDs) != 0 {

		//whereStmt = append(whereStmt, map[string]interface{}{
		//	"terms": map[string]interface{}{
		//		"id": subCategoryIDs,
		//	},
		//})
	}

	query := map[string]interface{}{
		//"size": 10000,
		"query": map[string]interface{}{
			"bool": map[string]interface{}{
				"should": whereStmt,
			},
		},
	}

	data, err := json.Marshal(query)
	if err != nil {
		logrus.Fatal(err)
	}

	fmt.Printf("data: %v\n", string(data))

	// fmt.Printf("queryNew: %v\n", query)
	if err := json.NewEncoder(&buf).Encode(query); err != nil {
		return nil, fmt.Errorf("error encoding query: %w", err)
	}

	res, err := es.client.Search(
		es.client.Search.WithContext(ctx),
		es.client.Search.WithIndex(indexCategoryEq),
		es.client.Search.WithBody(&buf),
		es.client.Search.WithTrackTotalHits(true),
		es.client.Search.WithPretty(),
	)
	if err != nil {
		return nil, fmt.Errorf("%w", err)
	}
	defer res.Body.Close()

	if res.IsError() {
		var e map[string]interface{}
		if err := json.NewDecoder(res.Body).Decode(&e); err != nil {
			return nil, fmt.Errorf("error parsing the response body: %w", err)
		} else {
			return nil, fmt.Errorf("[%s] %s: %s", res.Status(), e["error"].(map[string]interface{})["type"], e["error"].(map[string]interface{})["reason"])
		}
	}

	ads, err := parseHint[model.EquipmentCategory](res.Body)
	if err != nil {
		return nil, fmt.Errorf("parse body: %w", err)
	}

	return ads, nil
}

func (es *categoryEq) Create(ctx context.Context, category model.EquipmentCategory) error {
	data, err := json.Marshal(category)
	if err != nil {
		return err
	}

	r := bytes.NewReader(data)

	res, err := es.client.Create(indexCategoryEq, strconv.Itoa(category.ID), r)
	if err != nil {
		return err
	}

	if res.StatusCode != 201 {
		data, err := io.ReadAll(res.Body)
		if err != nil {
			return err
		}

		return errors.New(string(data))
	}

	return nil
}

func (es *categoryEq) Update(ctx context.Context, ad model.EquipmentCategory) error {
	data, err := json.Marshal(ad)
	if err != nil {
		return err
	}

	r := bytes.NewReader(data)

	res, err := es.client.Index(
		indexCategoryEq,
		r,
		es.client.Index.WithContext(ctx),
		es.client.Index.WithDocumentID(strconv.Itoa(ad.ID)),
		es.client.Index.WithRefresh("true"),
	)
	if err != nil {
		return err
	}

	if res.IsError() {
		data, err := io.ReadAll(res.Body)
		if err != nil {
			return err
		}
		return errors.New(string(data))
	}

	logrus.Infof("Parent category equipment updated: %d", ad.ID)

	return nil
}

func (es *categoryEq) Update1(ctx context.Context, ad model.EquipmentSubCategory) error {
	data, err := json.Marshal(ad)
	if err != nil {
		return err
	}

	r := bytes.NewReader(data)

	res, err := es.client.Index(
		"index_sub_category_eq_v2",
		r,
		es.client.Index.WithContext(ctx),
		es.client.Index.WithDocumentID(strconv.Itoa(ad.ID)),
		es.client.Index.WithRefresh("true"),
	)
	if err != nil {
		return err
	}

	if res.IsError() {
		data, err := io.ReadAll(res.Body)
		if err != nil {
			return err
		}
		return errors.New(string(data))
	}

	logrus.Infof("Sub category equipment updated: %d", ad.ID)

	return nil
}

func (es *categoryEq) Delete(ctx context.Context, id int) error {
	res, err := es.client.Delete(indexCategoryEq, strconv.Itoa(id), es.client.Delete.WithContext(ctx))
	if err != nil {
		return err
	}

	if res.StatusCode != 200 {
		data, err := io.ReadAll(res.Body)
		if err != nil {
			return err
		}
		return errors.New(string(data))
	}

	return nil
}
