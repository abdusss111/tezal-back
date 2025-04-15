package model

import (
	"database/sql"
	"encoding/json"
	"time"
)

type Time struct {
	sql.NullTime
}

func (t Time) MarshalJSON() ([]byte, error) {
	if t.Valid {
		return json.Marshal(t.Time)
	} else {
		return json.Marshal(nil)
	}
}

func (mt *Time) UnmarshalJSON(data []byte) error {
	var t *time.Time
	if err := json.Unmarshal(data, &t); err != nil {
		return err
	}
	if t != nil {
		mt.Time = *t
		mt.Valid = true
	} else {
		mt.Valid = false
	}
	return nil
}
