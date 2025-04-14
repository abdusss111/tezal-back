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
	indexAdCMClient = "index_ad_cm_client"
)

type IAdConstructionMaterialClient interface {
	SearchSimple(ctx context.Context, match string, queryFilters []map[string]interface{}) ([]model.AdConstructionMaterialClient, error)
	CountBySubCategoryID(ctx context.Context) (map[int]int, error)
	Create(ctx context.Context, ad model.AdConstructionMaterialClient) error
	Update(ctx context.Context, ad model.AdConstructionMaterialClient) error
	Delete(ctx context.Context, id int) error
}

type adConstructionMaterialClient struct {
	client *elasticsearch.Client
}

func NewAdConstructionMaterialClient(cl *elasticsearch.Client) IAdConstructionMaterialClient {
	return &adConstructionMaterialClient{
		client: cl,
	}
}

func (es *adConstructionMaterialClient) SearchSimple(ctx context.Context, match string, queryFilters []map[string]interface{}) ([]model.AdConstructionMaterialClient, error) {
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
	// 		// "match": map[string]interface{}{
	// 		// 	// "user.name": map[string]interface{}{
	// 		// 	// 	"query": "Алтынбек",
	// 		// 	// },

	// 		// 	"user.first_name": match,
	// 		// },
	// 		// "multi_match": map[string]interface{}{
	// 		// 	"query":     "Алтынбек",
	// 		// 	"fuzziness": "AUTO",
	// 		// 	"fields": []interface{}{
	// 		// 		"user.name",
	// 		// 		"name",
	// 		// 		"description",
	// 		// 	},
	// 		// },
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
		es.client.Search.WithIndex(indexAdCMClient),
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

	ads, err := parseHint[model.AdConstructionMaterialClient](res.Body)
	if err != nil {
		return nil, fmt.Errorf("parse body: %w", err)
	}

	return ads, nil
}

func (es *adConstructionMaterialClient) CountBySubCategoryID(ctx context.Context) (map[int]int, error) {
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
		es.client.Search.WithIndex(indexAdCMClient),
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

func (es *adConstructionMaterialClient) GetByID(ctx context.Context) {

}

func (es *adConstructionMaterialClient) Create(ctx context.Context, ad model.AdConstructionMaterialClient) error {
	data, err := json.Marshal(ad)
	if err != nil {
		return err
	}

	r := bytes.NewReader(data)

	res, err := es.client.Create(indexAdCMClient, strconv.Itoa(ad.ID), r)
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

func (es *adConstructionMaterialClient) Update(ctx context.Context, ad model.AdConstructionMaterialClient) error {
	data, err := json.Marshal(ad)
	if err != nil {
		return err
	}

	r := bytes.NewReader(data)

	res, err := es.client.Index(
		indexAdCMClient,
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

	logrus.Infof("AdConsMaterialCLient updated: %d", ad.ID)

	return nil
}

func (es *adConstructionMaterialClient) Delete(ctx context.Context, id int) error {
	res, err := es.client.Delete(indexAdCMClient, strconv.Itoa(id), es.client.Delete.WithContext(ctx))
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
