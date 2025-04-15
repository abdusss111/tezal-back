package config

import (
	firebase "firebase.google.com/go/v4"
	"github.com/aws/aws-sdk-go/service/s3"
	"os"
	"strconv"

	"github.com/joho/godotenv"
	"github.com/sirupsen/logrus"
)

type AppConfigs struct {
	Port               string
	LogLevel           string
	JWT                JWT
	Database           *Postgre
	ObjectStorage      *ObjectStorage
	S3                 *s3.S3
	FirebaseConfigPath string
	MessageApp         *firebase.App
	SMTP               SMTP
	SMS                SMS
	Elastic            Elastic
}

type ObjectStorage struct {
	Endpoint     string
	Bucket       string
	ClientName   string
	ClientSecret string
	ClientKey    string
}

type JWT struct {
	KeyAccess      []byte
	KeyRefresh     []byte
	ExpiredAccess  float64
	ExpiredRefresh float64
}

type Postgre struct {
	Host     string
	Port     string
	Username string
	Password string
	DBName   string
	SSLMode  string
}

type SMTP struct {
	Host     string
	Port     int
	Username string
	Password string
	From     string
}

type SMS struct {
	ApiKey    string
	IsSMSMock bool
}

type Elastic struct {
	URL string
}

func InitConfigs() AppConfigs {
	err := godotenv.Load(".env")
	if err != nil {
		logrus.Error("Error loading .env file")
	}

	database := &Postgre{
		Host:     os.Getenv("DB_HOST"),
		Port:     os.Getenv("DB_PORT"),
		Username: os.Getenv("DB_USERNAME"),
		Password: os.Getenv("DB_PASSWORD"),
		DBName:   os.Getenv("DB_NAME"),
		SSLMode:  os.Getenv("DB_SSL_MODE"),
	}

	expRefresh, err := strconv.ParseFloat(os.Getenv("JWT_EXPIRED_REFRESH"), 64)
	if err != nil {
		logrus.Fatalln(err)
	}

	expAccess, err := strconv.ParseFloat(os.Getenv("JWT_EXPIRED_ACCESS"), 64)
	if err != nil {
		logrus.Fatalln(err)
	}

	jwt := JWT{
		KeyAccess:      []byte(os.Getenv("JWT_KEY_ACCESS")),
		KeyRefresh:     []byte(os.Getenv("JWT_KEY_REFRESH")),
		ExpiredAccess:  expAccess,
		ExpiredRefresh: expRefresh,
	}

	objectStorage := &ObjectStorage{
		Endpoint:     os.Getenv("SPACES_ENDPOINT"),
		Bucket:       os.Getenv("SPACES_BUCKET"),
		ClientName:   os.Getenv("SPACES_CLIENT_NAME"),
		ClientSecret: os.Getenv("SPACES_CLIENT_SECRET"),
		ClientKey:    os.Getenv("SPACES_CLIENT_KEY"),
	}

	smtpPort, err := strconv.Atoi(os.Getenv("SMTP_PORT"))
	if err != nil {
		logrus.Fatalln(err)
	}
	smtp := SMTP{
		Host:     os.Getenv("SMTP_HOST"),
		Port:     smtpPort,
		Username: os.Getenv("SMTP_USERNAME"),
		Password: os.Getenv("SMTP_PASSWORD"),
	}

	isSMSMock, err := strconv.ParseBool(os.Getenv("IS_SMS_MOCK"))
	if err != nil {
		logrus.Fatalln(err)
	}
	sms := SMS{
		ApiKey:    os.Getenv("SMS_API_KEY"),
		IsSMSMock: isSMSMock,
	}

	elastic := Elastic{
		URL: os.Getenv("ELASTIC_URL"),
	}

	return AppConfigs{
		Port:               os.Getenv("PORT"),
		LogLevel:           os.Getenv("LOG_LEVEL"),
		JWT:                jwt,
		Database:           database,
		ObjectStorage:      objectStorage,
		FirebaseConfigPath: os.Getenv("FIREBASE_CONFIG_PATH"),
		SMTP:               smtp,
		SMS:                sms,
		Elastic:            elastic,
	}
}
