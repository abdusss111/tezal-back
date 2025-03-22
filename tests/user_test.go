package tests

import (
	"bytes"
	"net/http"
	"net/http/httptest"
	"testing"

	"github.com/abdusss111/go-user-service_test-task/internal/handlers"
	"github.com/stretchr/testify/assert"
)

func TestCreateUser(t *testing.T) {
	req, _ := http.NewRequest("POST", "/users", bytes.NewBuffer([]byte(`{"name": "John", "email": "john@example.com", "age": 30}`)))
	rr := httptest.NewRecorder()

	handler := &handlers.UserHandler{}
	handler.CreateUser(rr, req)

	assert.Equal(t, http.StatusCreated, rr.Code)
}
