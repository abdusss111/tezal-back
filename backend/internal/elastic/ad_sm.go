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
	indexAdSm = "index_ad_sm_v2"
)

type IAdSpecializedMachinery interface {
	SearchSimple(ctx context.Context, match string, queryFilters []map[string]interface{}, f model.FilterSearch) ([]model.AdSpecializedMachinery, error)
	CountByTypeID(ctx context.Context) (map[int]int, error)
	Create(ctx context.Context, ad model.AdSpecializedMachinery) error
	Update(ctx context.Context, ad model.AdSpecializedMachinery) error
	Delete(ctx context.Context, id int) error
}

type adSpecializedMachinery struct {
	clinet *elasticsearch.Client
}

func NewAdSpecializedMachinery(cl *elasticsearch.Client) IAdSpecializedMachinery {
	return &adSpecializedMachinery{
		clinet: cl,
	}
}

func (es *adSpecializedMachinery) SearchSimple(ctx context.Context, match string, queryFilters []map[string]interface{}, f model.FilterSearch) ([]model.AdSpecializedMachinery, error) {
	var buf bytes.Buffer
	// query := map[string]interface{}{
	// 	"query": map[string]interface{}{
	// 		"multi_match": map[string]interface{}{
	// 			"query":     match,
	// 			"fuzziness": "AUTO",
	// 			"fields": []interface{}{
	// 				"name",
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
	size := 10000
	if f.Limit != nil {
		size = *f.Limit
	}
	query := map[string]interface{}{
		"size": size, // Use dynamic size
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
		es.clinet.Search.WithIndex(indexAdSm),
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

	ads, err := parseHint[model.AdSpecializedMachinery](res.Body)
	if err != nil {
		return nil, fmt.Errorf("parse body: %w", err)
	}
	logrus.Infof("SearchSimple: %+v", query)
	return ads, nil
}

func (es *adSpecializedMachinery) CountByTypeID(ctx context.Context) (map[int]int, error) {
	var buf bytes.Buffer
	query := map[string]interface{}{
		"size": 0,
		"aggs": map[string]interface{}{
			"group_by_name": map[string]interface{}{
				"terms": map[string]interface{}{
					"field": "type_id",
				},
			},
		},
	}
	if err := json.NewEncoder(&buf).Encode(query); err != nil {
		return nil, fmt.Errorf("error encoding query: %w", err)
	}

	res, err := es.clinet.Search(
		es.clinet.Search.WithContext(ctx),
		es.clinet.Search.WithIndex(indexAdSm),
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

func (es *adSpecializedMachinery) GetByID(ctx context.Context) {

}

func (es *adSpecializedMachinery) Create(ctx context.Context, ad model.AdSpecializedMachinery) error {
	data, err := json.Marshal(ad)
	if err != nil {
		return err
	}

	r := bytes.NewReader(data)

	res, err := es.clinet.Create(indexAdSm, strconv.Itoa(ad.ID), r)
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

func (es *adSpecializedMachinery) Update(ctx context.Context, ad model.AdSpecializedMachinery) error {
	data, err := json.Marshal(ad)
	if err != nil {
		return err
	}
	r := bytes.NewReader(data)

	res, err := es.clinet.Index(
		indexAdSm,
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

	logrus.Infof("AdSpecializedMachinery updated: %s", ad.ID)

	return nil
}

func (es *adSpecializedMachinery) Delete(ctx context.Context, id int) error {
	res, err := es.clinet.Delete(indexAdSm, strconv.Itoa(id), es.clinet.Delete.WithContext(ctx))
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

// 	"key": 30	"doc_count": 2
// 	"key": 17	"doc_count": 1
// 	"key": 19	"doc_count": 1
// 	"key": 23	"doc_count": 1
// 	"key": 29	"doc_count": 1
// 	"key": 37	"doc_count": 1
// 	"key": 38	"doc_count": 1
// 	"key": 45	"doc_count": 1
// 	"key": 48	"doc_count": 1
// 	"key": 49	"doc_count": 1

// "type_id": 30, "count": 2
// "type_id": 29, "count": 1
// "type_id": 51, "count": 1
// "type_id": 49, "count": 1
// "type_id": 97, "count": 1
// "type_id": 17, "count": 1
// "type_id": 37, "count": 1
// "type_id": 53, "count": 1
// "type_id": 135, "count": 1
// "type_id": 133, "count": 1
// "type_id": 45, "count": 1
// "type_id": 104, "count": 1
// "type_id": 38, "count": 1
// "type_id": 107, "count": 1
// "type_id": 48, "count": 1
// "type_id": 130, "count": 1
// "type_id": 137, "count": 1
// "type_id": 19, "count": 1
// "type_id": 23, "count": 1
