package main

import (
	"log"
	"net/http"

	"github.com/abdusss111/go-user-service_test-task/config"
	"github.com/abdusss111/go-user-service_test-task/internal/handlers"
	"github.com/abdusss111/go-user-service_test-task/internal/repository"
	"github.com/abdusss111/go-user-service_test-task/pkg/db"
	"github.com/gorilla/mux"
)

func main() {
	cfg := config.LoadConfig()
	db.InitDB(cfg)

	repo := &repository.UserRepository{DB: db.DB}
	handler := &handlers.UserHandler{Repo: repo}

	r := mux.NewRouter()
	r.HandleFunc("/users", handler.CreateUser).Methods("POST")
	r.HandleFunc("/users/{id:[0-9]+}", handler.GetUser).Methods("GET")
	r.HandleFunc("/users", handler.UpdateUser).Methods("PUT")

	log.Println("Server is running on port 8080")
	http.ListenAndServe("0.0.0.0:8080", r)
}
