# User Service

A simple user management service built with Golang and PostgreSQL.

## Features
- User registration and authentication
- CRUD operations for user management
- REST API with JSON responses

## Technologies Used
- **Golang** (Backend)
- **PostgreSQL** (Database)
- **Docker & Docker Compose** (Containerization)
- **Gorilla Mux** (Router)
- **SQLX** (Database interactions)

## Prerequisites
- [Go 1.22+](https://go.dev/doc/install)
- [Docker & Docker Compose](https://www.docker.com/get-started)
- [PostgreSQL](https://www.postgresql.org/download/) (if running without Docker)

## Setup & Installation

### 1. Run with Docker (Recommended)
```sh
docker-compose up --build
```
The service should start on `http://localhost:8080`.

### 2. Run without Docker
1. Create a `.env` file:
   ```sh
   DATABASE_URL=postgres://user:password@localhost:5432/usersdb?sslmode=disable
   ```
2. Start PostgreSQL manually and create the database:
   ```sh
   createdb -U user usersdb
   ```
3. Run the application:
   ```sh
  go run .
   ```

## API Endpoints

| Method | Endpoint        | Description             |
|--------|---------------|-------------------------|
| GET    | `/users`       | Get all users          |
| GET    | `/users/{id}`  | Get a single user      |
| POST   | `/users`       | Create a new user      |
| PUT    | `/users/{id}`  | Update user details    |
| DELETE | `/users/{id}`  | Delete a user          |

### Example API Call
```sh
curl -X GET http://localhost:8080/users
```

## Database Schema
```sql
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    password TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

## Running Tests
```sh
go test ./...
```

## Notes
- Make sure PostgreSQL is running before starting the app.
- If using Docker, ensure no other services are using port `5432`.

---
Enjoy coding! 🚀

