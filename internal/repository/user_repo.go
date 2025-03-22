package repository

import (
	"github.com/abdusss111/go-user-service_test-task/internal/models"
	"github.com/jmoiron/sqlx"
)

type UserRepository struct {
	DB *sqlx.DB
}

func (repo *UserRepository) CreateUser(user models.User) error {
	_, err := repo.DB.Exec("INSERT INTO users (name, email, age) VALUES ($1, $2, $3)", user.Name, user.Email, user.Age)
	return err
}

func (repo *UserRepository) GetUser(id int) (models.User, error) {
	var user models.User
	err := repo.DB.Get(&user, "SELECT * FROM users WHERE id=$1", id)
	return user, err
}

func (repo *UserRepository) UpdateUser(user models.User) error {
	_, err := repo.DB.Exec("UPDATE users SET name=$1, email=$2, age=$3 WHERE id=$4", user.Name, user.Email, user.Age, user.ID)
	return err
}
