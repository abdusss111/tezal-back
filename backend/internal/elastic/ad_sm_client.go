package elastic

import (
	"bytes"
	"context"
	"encoding/json"
	"errors"
	"fmt"
	"io"
	"strconv"

	"github.com/sirupsen/logrus"

	"github.com/elastic/go-elasticsearch/v7"
	"gitlab.com/eqshare/eqshare-back/model"
)

const (
	indexAdSmClient = "index_ad_sm_client_v2"
)

type IAdSpecializedMachineryClient interface {
	SearchSimple(ctx context.Context, match string, queryFilters []map[string]interface{}) ([]model.AdClient, error)
	CountBySubCategoryID(ctx context.Context) (map[int]int, error)
	Create(ctx context.Context, ad model.AdClient) error
	Update(ctx context.Context, ad model.AdClient) error
	Delete(ctx context.Context, id int) error
}

type adSpecializedMachineryClient struct {
	clinet *elasticsearch.Client
}

func NewAdSpecializedMachineryClient(cl *elasticsearch.Client) IAdSpecializedMachineryClient {
	return &adSpecializedMachineryClient{
		clinet: cl,
	}
}

func (es *adSpecializedMachineryClient) SearchSimple(ctx context.Context, match string, queryFilters []map[string]interface{}) ([]model.AdClient, error) {
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

	res, err := es.clinet.Search(
		es.clinet.Search.WithContext(ctx),
		es.clinet.Search.WithIndex(indexAdSmClient),
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

	ads, err := parseHint[model.AdClient](res.Body)
	if err != nil {
		return nil, fmt.Errorf("parse body: %w", err)
	}

	return ads, nil
}

func (es *adSpecializedMachineryClient) CountBySubCategoryID(ctx context.Context) (map[int]int, error) {
	var buf bytes.Buffer
	query := map[string]interface{}{
		"size": 0,
		"aggs": map[string]interface{}{
			"group_by_name": map[string]interface{}{
				"terms": map[string]interface{}{
					"field": "equipment_sub_category_id",
				},
			},
		},
	}
	if err := json.NewEncoder(&buf).Encode(query); err != nil {
		return nil, fmt.Errorf("error encoding query: %w", err)
	}

	res, err := es.clinet.Search(
		es.clinet.Search.WithContext(ctx),
		es.clinet.Search.WithIndex(indexAdEq),
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

	counts, err := parseCount(res.Body)
	if err != nil {
		return nil, err
	}

	return counts, nil
}

func (es *adSpecializedMachineryClient) GetByID(ctx context.Context) {

}

func (es *adSpecializedMachineryClient) Create(ctx context.Context, ad model.AdClient) error {
	data, err := json.Marshal(ad)
	if err != nil {
		return err
	}

	r := bytes.NewReader(data)

	res, err := es.clinet.Create(indexAdSmClient, strconv.Itoa(ad.ID), r)
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

func (es *adSpecializedMachineryClient) Update(ctx context.Context, ad model.AdClient) error {
	data, err := json.Marshal(ad)
	if err != nil {
		return err
	}

	r := bytes.NewReader(data)

	res, err := es.clinet.Index(
		indexAdSmClient,
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

	logrus.Infof("AdSpecializedMachineryClient updated: %d", ad.ID)

	return nil
}

func (es *adSpecializedMachineryClient) Delete(ctx context.Context, id int) error {
	res, err := es.clinet.Delete(indexAdSmClient, strconv.Itoa(id), es.clinet.Delete.WithContext(ctx))
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
