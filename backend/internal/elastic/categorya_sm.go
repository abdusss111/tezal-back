package elastic

import (
	"bytes"
	"context"
	"encoding/json"
	"errors"
	"fmt"
	"github.com/sirupsen/logrus"
	"io"
	"strconv"

	"github.com/elastic/go-elasticsearch/v7"
	"gitlab.com/eqshare/eqshare-back/model"
)

const (
	indexCategorySm = "index_category_sm_v2"
)

type ICategorySm interface {
	SearchSimple(ctx context.Context, match string, typeIDs []int) ([]model.SubCategory, error)
	Create(ctx context.Context, category model.SubCategory) error
	Update(ctx context.Context, ad model.SubCategory) error
	Update1(ctx context.Context, category model.Type) error
	Delete(ctx context.Context, id int) error
}

type categoryaSm struct {
	clinet *elasticsearch.Client
}

func NewCategoryaSm(cl *elasticsearch.Client) ICategorySm {
	return &categoryaSm{
		clinet: cl,
	}
}

func (es *categoryaSm) SearchSimple(ctx context.Context, match string, typeIDs []int) ([]model.SubCategory, error) {
	var buf bytes.Buffer
	whereStmt := make([]map[string]interface{}, 0)

	{
		whereStmt = append(whereStmt, map[string]interface{}{
			"match": map[string]interface{}{
				"name": map[string]interface{}{
					"query": match,
					// "fuzziness": "AUTO",
				},
			},
		})

		// whereStmt = append(whereStmt, map[string]interface{}{
		// 	"match": map[string]interface{}{
		// 		"equipment_sub_categories.name": map[string]interface{}{
		// 			"query":     match,
		// 			"fuzziness": "AUTO",
		// 		},
		// 	},
		// })
	}

	if len(typeIDs) != 0 {
		whereStmt = append(whereStmt, map[string]interface{}{
			"terms": map[string]interface{}{
				"id": typeIDs,
			},
		})
	}

	query := map[string]interface{}{
		//"size": 10000,
		"query": map[string]interface{}{
			"bool": map[string]interface{}{
				"should": whereStmt,
			},
		},
	}
	if err := json.NewEncoder(&buf).Encode(query); err != nil {
		return nil, fmt.Errorf("error encoding query: %w", err)
	}

	res, err := es.clinet.Search(
		es.clinet.Search.WithContext(ctx),
		es.clinet.Search.WithIndex(indexCategorySm),
		es.clinet.Search.WithBody(&buf),
		es.clinet.Search.WithTrackTotalHits(true),
		es.clinet.Search.WithPretty(),
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

	ads, err := parseHint[model.SubCategory](res.Body)
	if err != nil {
		return nil, fmt.Errorf("parse body: %w", err)
	}

	return ads, nil
}

func (es *categoryaSm) Create(ctx context.Context, category model.SubCategory) error {
	data, err := json.Marshal(category)
	if err != nil {
		return err
	}

	r := bytes.NewReader(data)

	res, err := es.clinet.Create(indexCategorySm, strconv.Itoa(category.ID), r)
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

func (es *categoryaSm) Update(ctx context.Context, ad model.SubCategory) error {
	data, err := json.Marshal(ad)
	if err != nil {
		return err
	}

	r := bytes.NewReader(data)

	res, err := es.clinet.Index(
		indexCategorySm,
		r,
		es.clinet.Index.WithContext(ctx),
		es.clinet.Index.WithDocumentID(strconv.Itoa(ad.ID)),
		es.clinet.Index.WithRefresh("true"),
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

	logrus.Infof("Родитель updated: %d", ad.ID)

	return nil
}

func (es *categoryaSm) Update1(ctx context.Context, ad model.Type) error {
	data, err := json.Marshal(ad)
	if err != nil {
		return err
	}

	r := bytes.NewReader(data)

	res, err := es.clinet.Index(
		"index_sub_category_sm_v2",
		r,
		es.clinet.Index.WithContext(ctx),
		es.clinet.Index.WithDocumentID(strconv.Itoa(ad.ID)),
		es.clinet.Index.WithRefresh("true"),
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

	logrus.Infof("Дочерняя updated: %d", ad.ID)

	return nil
}

func (es *categoryaSm) Delete(ctx context.Context, id int) error {
	res, err := es.clinet.Delete(indexCategorySm, strconv.Itoa(id), es.clinet.Delete.WithContext(ctx))
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
