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
	indexAdCM = "index_ad_cm2"
)

type IAdConstructionMaterial interface {
	SearchSimple(ctx context.Context, match string, queryFilters []map[string]interface{}) ([]model.AdConstructionMaterial, error)
	CountBySubCategoryID(ctx context.Context) (map[int]int, error)
	Create(ctx context.Context, ad model.AdConstructionMaterial) error
	Update(ctx context.Context, ad model.AdConstructionMaterial) error
	Delete(ctx context.Context, id int) error
}

type adConstructionMaterial struct {
	client *elasticsearch.Client
}

func NewAdConstructionMaterial(cl *elasticsearch.Client) IAdConstructionMaterial {
	return &adConstructionMaterial{
		client: cl,
	}
}

func (es *adConstructionMaterial) SearchSimple(ctx context.Context, match string, queryFilters []map[string]interface{}) ([]model.AdConstructionMaterial, error) {
	var buf bytes.Buffer
	// query := map[string]interface{}{
	// 	"query": map[string]interface{}{
	// 		"multi_match": map[string]interface{}{
	// 			"query":     match,
	// 			"fuzziness": "AUTO",
	// 			"fields": []interface{}{
	// 				"headline",
	// 				"description",
	// 			},
	// 		},
	// 	},
	// }

	query := map[string]interface{}{
		//"size": 10000,
		"query": map[string]interface{}{
			"bool": map[string]interface{}{
				"must": []map[string]interface{}{
					{
						"multi_match": map[string]interface{}{
							"query":     match,
							"fuzziness": "AUTO",
							"fields":    []string{"title", "description"},
						},
					},
				},
				"filter": queryFilters, // Фильтры добавляются здесь
				"should": []map[string]interface{}{
					{
						"wildcard": map[string]interface{}{
							"headline": map[string]interface{}{
								"value":            fmt.Sprintf("*%s*", match),
								"case_insensitive": false,
							},
						},
					},
					{
						"wildcard": map[string]interface{}{
							"description": map[string]interface{}{
								"value":            fmt.Sprintf("*%s*", match),
								"case_insensitive": false,
							},
						},
					},
				},
			},
		},
	}

	if err := json.NewEncoder(&buf).Encode(query); err != nil {
		return nil, fmt.Errorf("error encoding query: %w", err)
	}

	res, err := es.client.Search(
		es.client.Search.WithContext(ctx),
		es.client.Search.WithIndex(indexAdCM),
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

	ads, err := parseHint[model.AdConstructionMaterial](res.Body)
	if err != nil {
		return nil, fmt.Errorf("parse body: %w", err)
	}

	return ads, nil
}

func (es *adConstructionMaterial) CountBySubCategoryID(ctx context.Context) (map[int]int, error) {
	var buf bytes.Buffer
	query := map[string]interface{}{
		"size": 0,
		"aggs": map[string]interface{}{
			"group_by_name": map[string]interface{}{
				"terms": map[string]interface{}{
					"field": "construction_material_sub_category_id",
				},
			},
		},
	}
	if err := json.NewEncoder(&buf).Encode(query); err != nil {
		return nil, fmt.Errorf("error encoding query: %w", err)
	}

	res, err := es.client.Search(
		es.client.Search.WithContext(ctx),
		es.client.Search.WithIndex(indexAdCM),
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

	counts, err := parseCount(res.Body)
	if err != nil {
		return nil, err
	}

	return counts, nil
}

func (es *adConstructionMaterial) GetByID(ctx context.Context) {

}

func (es *adConstructionMaterial) Create(ctx context.Context, ad model.AdConstructionMaterial) error {
	data, err := json.Marshal(ad)
	if err != nil {
		return err
	}

	r := bytes.NewReader(data)

	res, err := es.client.Create(indexAdCM, strconv.Itoa(ad.ID), r)
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

func (es *adConstructionMaterial) Update(ctx context.Context, ad model.AdConstructionMaterial) error {
	data, err := json.Marshal(ad)
	if err != nil {
		return err
	}

	r := bytes.NewReader(data)

	res, err := es.client.Index(
		indexAdCM,
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

	logrus.Infof("AdConsMaterial updated: %d", ad.ID)

	return nil
}

func (es *adConstructionMaterial) Delete(ctx context.Context, id int) error {
	res, err := es.client.Delete(indexAdCM, strconv.Itoa(id), es.client.Delete.WithContext(ctx))
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
