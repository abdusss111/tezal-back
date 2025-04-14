package elastic

import (
	"encoding/json"
	"fmt"
	"io"
)

func parseHint[T any](body io.ReadCloser) ([]T, error) {
	type hint struct {
		Took     int  `json:"took"`
		TimedOut bool `json:"timed_out"`
		Shards   struct {
			Total      int `json:"total"`
			Successful int `json:"successful"`
			Skipped    int `json:"skipped"`
			Failed     int `json:"failed"`
		} `json:"_shards"`
		Hits struct {
			Total struct {
				Value    int    `json:"value"`
				Relation string `json:"relation"`
			} `json:"total"`
			MaxScore float64 `json:"max_score"`
			Hits     []struct {
				Index  string  `json:"_index"`
				Type   string  `json:"_type"`
				ID     string  `json:"_id"`
				Score  float64 `json:"_score"`
				Source T       `json:"_source"`
			} `json:"hits"`
		} `json:"hits"`
	}

	var r hint

	if err := json.NewDecoder(body).Decode(&r); err != nil {
		return nil, fmt.Errorf("error parsing the response body: %w", err)
	}

	hits := make([]T, 0)

	for _, v := range r.Hits.Hits {
		hits = append(hits, v.Source)
	}

	return hits, nil
}

func parseCount(body io.ReadCloser) (map[int]int, error) {
	type response struct {
		Aggregations struct {
			GroupByName struct {
				DocCountErrorUpperBound int `json:"doc_count_error_upper_bound"`
				SumOtherDocCount        int `json:"sum_other_doc_count"`
				Buckets                 []struct {
					Key      int `json:"key"`
					DocCount int `json:"doc_count"`
				} `json:"buckets"`
			} `json:"group_by_name"`
		} `json:"aggregations"`
	}

	var r response

	if err := json.NewDecoder(body).Decode(&r); err != nil {
		return nil, fmt.Errorf("error parsing the response body: %w", err)
	}

	counts := make(map[int]int, 0)

	for _, buckets := range r.Aggregations.GroupByName.Buckets {
		counts[buckets.Key] = buckets.DocCount
	}

	return counts, nil
}
