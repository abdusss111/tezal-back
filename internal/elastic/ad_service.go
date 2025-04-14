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
	indexAdService = "index_ad_service_v2"
)

type IAdService interface {
	SearchSimple(ctx context.Context, match string, queryFilters []map[string]interface{}) ([]model.AdService, error)
	CountBySubCategoryID(ctx context.Context) (map[int]int, error)
	Create(ctx context.Context, ad model.AdService) error
	Update(ctx context.Context, ad model.AdService) error
	Delete(ctx context.Context, id int) error
}

type adService struct {
	clinet *elasticsearch.Client
}

func NewAdService(cl *elasticsearch.Client) IAdService {
	return &adService{
		clinet: cl,
	}
}

func (es *adService) SearchSimple(ctx context.Context, match string, queryFilters []map[string]interface{}) ([]model.AdService, error) {
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

	res, err := es.clinet.Search(
		es.clinet.Search.WithContext(ctx),
		es.clinet.Search.WithIndex(indexAdService),
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

	ads, err := parseHint[model.AdService](res.Body)
	if err != nil {
		return nil, fmt.Errorf("parse body: %w", err)
	}

	return ads, nil
}

func (es *adService) CountBySubCategoryID(ctx context.Context) (map[int]int, error) {
	var buf bytes.Buffer
	query := map[string]interface{}{
		"size": 0,
		"aggs": map[string]interface{}{
			"group_by_name": map[string]interface{}{
				"terms": map[string]interface{}{
					"field": "service_sub_category_id",
				},
			},
		},
	}
	if err := json.NewEncoder(&buf).Encode(query); err != nil {
		return nil, fmt.Errorf("error encoding query: %w", err)
	}

	res, err := es.clinet.Search(
		es.clinet.Search.WithContext(ctx),
		es.clinet.Search.WithIndex(indexAdService),
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

func (es *adService) GetByID(ctx context.Context) {

}

func (es *adService) Create(ctx context.Context, ad model.AdService) error {
	data, err := json.Marshal(ad)
	if err != nil {
		return err
	}

	r := bytes.NewReader(data)

	res, err := es.clinet.Create(indexAdService, strconv.Itoa(ad.ID), r)
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

func (es *adService) Update(ctx context.Context, ad model.AdService) error {
	data, err := json.Marshal(ad)
	if err != nil {
		return err
	}

	r := bytes.NewReader(data)

	res, err := es.clinet.Index(
		indexAdService,
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

	logrus.Infof("AdService updated: %d", ad.ID)

	return nil
}

func (es *adService) Delete(ctx context.Context, id int) error {
	res, err := es.clinet.Delete(indexAdService, strconv.Itoa(id), es.clinet.Delete.WithContext(ctx))
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
