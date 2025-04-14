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
	indexCategorySvc = "index_category_svc_v8"
)

type ICategorySvc interface {
	SearchSimple(ctx context.Context, match string, subCategoryIDs []int) ([]model.ServiceCategory, error)
	Create(ctx context.Context, category model.ServiceCategory) error
	Update(ctx context.Context, ad model.ServiceCategory) error
	Delete(ctx context.Context, id int) error
}

type categorySvc struct {
	client *elasticsearch.Client
}

func NewCategorySvc(cl *elasticsearch.Client) ICategorySvc {
	return &categorySvc{
		client: cl,
	}
}

func (es *categorySvc) SearchSimple(ctx context.Context, match string, subCategoryIDs []int) ([]model.ServiceCategory, error) {
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
		// 		"construction_material_sub_categories.name": map[string]interface{}{
		// 			"query":     match,
		// 			"fuzziness": "AUTO",
		// 		},
		// 	},
		// })
	}

	if len(subCategoryIDs) != 0 {
		whereStmt = append(whereStmt, map[string]interface{}{
			"terms": map[string]interface{}{
				"id": subCategoryIDs,
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
		es.client.Search.WithIndex(indexCategorySvc),
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

	ads, err := parseHint[model.ServiceCategory](res.Body)
	if err != nil {
		return nil, fmt.Errorf("parse body: %w", err)
	}

	return ads, nil
}

func (es *categorySvc) Create(ctx context.Context, category model.ServiceCategory) error {
	data, err := json.Marshal(category)
	if err != nil {
		return err
	}

	r := bytes.NewReader(data)

	res, err := es.client.Create(indexCategorySvc, strconv.Itoa(category.ID), r)
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

func (es *categorySvc) Update(ctx context.Context, ad model.ServiceCategory) error {
	data, err := json.Marshal(ad)
	if err != nil {
		return err
	}

	r := bytes.NewReader(data)

	res, err := es.client.Index(
		indexCategorySvc,
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

	logrus.Infof("Category service updated: %d", ad.ID)

	return nil
}

func (es *categorySvc) Delete(ctx context.Context, id int) error {
	res, err := es.client.Delete(indexCategorySvc, strconv.Itoa(id), es.client.Delete.WithContext(ctx))
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
