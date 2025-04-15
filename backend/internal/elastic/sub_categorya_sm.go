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
	indexSubCategorySm = "index_sub_category_sm_v2"
)

type ISubCategorySm interface {
	SearchSimple(ctx context.Context, match string) ([]model.Type, error)
	Create(ctx context.Context, category model.Type) error
	Update(ctx context.Context, ad model.Type) error
	Delete(ctx context.Context, id int) error
}

type subCategorySm struct {
	clinet *elasticsearch.Client
}

func NewSubCategorySm(cl *elasticsearch.Client) ISubCategorySm {
	return &subCategorySm{
		clinet: cl,
	}
}

func (es *subCategorySm) SearchSimple(ctx context.Context, match string) ([]model.Type, error) {
	var buf bytes.Buffer
	query := map[string]interface{}{
		//"size": 10000,
		"query": map[string]interface{}{
			"bool": map[string]interface{}{
				"should": []map[string]interface{}{
					{
						"match": map[string]interface{}{
							"name": map[string]interface{}{
								"query": match,
								// "fuzziness": "AUTO",
							},
						},
					},
					{
						"match": map[string]interface{}{
							"sub_categories.alias": map[string]interface{}{
								"query": match,
								// "fuzziness": "AUTO",
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
		es.clinet.Search.WithIndex(indexSubCategorySm),
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

	ads, err := parseHint[model.Type](res.Body)
	if err != nil {
		return nil, fmt.Errorf("parse body: %w", err)
	}

	return ads, nil
}

func (es *subCategorySm) Create(ctx context.Context, category model.Type) error {
	data, err := json.Marshal(category)
	if err != nil {
		return err
	}

	r := bytes.NewReader(data)

	res, err := es.clinet.Create(indexSubCategorySm, strconv.Itoa(category.ID), r)
	if err != nil {
		return err
	}

	if res.StatusCode != 201 {
		_, err := io.ReadAll(res.Body)
		if err != nil {
			return err
		}

		//return errors.New(string(data))
	}

	return nil
}

func (es *subCategorySm) Update(ctx context.Context, ad model.Type) error {
	data, err := json.Marshal(ad)
	if err != nil {
		return err
	}

	r := bytes.NewReader(data)

	res, err := es.clinet.Index(
		indexSubCategorySm,
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

func (es *subCategorySm) Delete(ctx context.Context, id int) error {
	res, err := es.clinet.Delete(indexSubCategorySm, strconv.Itoa(id), es.clinet.Delete.WithContext(ctx))
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
