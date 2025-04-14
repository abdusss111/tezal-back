package controller

import (
	"errors"
	"net/http"

	"github.com/gin-gonic/gin"
	"gitlab.com/eqshare/eqshare-back/internal/service"
	"gitlab.com/eqshare/eqshare-back/model"
)

// проверяет только access токен
func CheckToken(auth service.IAuthentication) gin.HandlerFunc {
	return func(c *gin.Context) {
		token := c.GetHeader("Authorization")

		// Проверка, что токен начинается с "Bearer "
		const bearerPrefix = "Bearer "
		if !(len(token) > len(bearerPrefix) && token[:len(bearerPrefix)] == bearerPrefix) {
			c.JSON(http.StatusUnauthorized, gin.H{"error": "Invalid Bearer Token"})
			c.Abort()
			return
		}

		// Извлечение токена без префикса
		token = token[len(bearerPrefix):]

		user, err := auth.VerifyToken(token)
		if err != nil {
			c.JSON(http.StatusUnauthorized, gin.H{"error": err.Error()})
			c.Abort()
			return
		}

		c.Set(gin.AuthUserKey, user)

		// Передача управления следующему обработчику
		c.Next()
	}
}

// При работе с водительскими методами необходимо выполнить проверку на роль пользователя.
// Данный middleware служит для этой задач
func authorize(auth service.IAuthentication, requiredRoles ...string) gin.HandlerFunc {
	return func(c *gin.Context) {
		token := c.GetHeader("Authorization")

		// Проверка, что токен начинается с "Bearer "
		const bearerPrefix = "Bearer "
		if !(len(token) > len(bearerPrefix) && token[:len(bearerPrefix)] == bearerPrefix) {
			c.JSON(http.StatusUnauthorized, gin.H{"error": "Invalid Bearer Token"})
			c.Abort()
			return
		}

		// Извлечение токена без префикса
		token = token[len(bearerPrefix):]

		user, err := auth.VerifyToken(token)
		if err != nil {
			c.JSON(http.StatusUnauthorized, gin.H{"error": err.Error()})
			c.Abort()
			return
		}

		contains := func(arr []string, value string) bool {
			for _, v := range arr {
				if v == model.ROLE_DRIVER {
					arr = append(arr, model.ROLE_OWNER)
				}
			}

			for _, v := range arr {
				if v == value {
					return true
				}
			}
			return false
		}

		if len(requiredRoles) != 0 && !contains(requiredRoles, user.AccessRole) {
			c.JSON(http.StatusForbidden, gin.H{"reason": "Access denied!"})
			c.Abort()
			return
		}

		c.Set(gin.AuthUserKey, user)
		// Передача управления следующему обработчику
		c.Next()
	}
}

func GetUserFromGin(c *gin.Context) (model.User, error) {
	userI, ok := c.Get(gin.AuthUserKey)
	if !ok {
		return model.User{}, model.ErrNotFound
	}

	user, ok := userI.(model.User)
	if !ok {
		return model.User{}, errors.New("can't cast user")
	}

	return user, nil
}

func CORSMiddleware() gin.HandlerFunc {
	return func(c *gin.Context) {
		c.Writer.Header().Set("Content-Type", "application/json")
		c.Writer.Header().Set("Access-Control-Allow-Origin", "*")
		c.Writer.Header().Set("Access-Control-Allow-Methods", "GET,PUT,POST,DELETE,PATCH,OPTIONS")
		c.Writer.Header().Set("Access-Control-Allow-Credentials", "true")
		c.Writer.Header().Set("Access-Control-Allow-Headers", "Content-Type, Content-Length, Accept-Encoding, X-CSRF-Token, Authorization, auth")

		if c.Request.Method == "OPTIONS" {
			c.AbortWithStatus(200)
			return
		}

		c.Next()
	}
}
