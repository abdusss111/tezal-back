// Dear programmer.
// When I wrote this code, only god and I knew how it worked.
// Now, only god knows it.
//
// Therefore, if you are trying to optimize
// this routine and it fails (most surely),
// please increase this counter as
// a warning for the next person:
//
// total hours wasted here = 372
package main

import (
	"context"
	"errors"
	"fmt"
	"io"
	"log"
	"net/http"
	"os"
	"os/signal"
	"syscall"
	"time"

	firebase "firebase.google.com/go/v4"
	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/aws/credentials"
	"github.com/aws/aws-sdk-go/aws/session"
	"github.com/aws/aws-sdk-go/service/s3"
	"github.com/elastic/go-elasticsearch/v7"
	"github.com/gin-gonic/gin"
	"github.com/go-co-op/gocron/v2"
	"github.com/redis/go-redis/v9"
	"github.com/sirupsen/logrus"
	"gitlab.com/eqshare/eqshare-back/config"
	"gitlab.com/eqshare/eqshare-back/docs"
	"google.golang.org/api/option"

	"gitlab.com/eqshare/eqshare-back/internal/client"
	"gitlab.com/eqshare/eqshare-back/internal/controller"
	"gitlab.com/eqshare/eqshare-back/internal/elastic"
	"gitlab.com/eqshare/eqshare-back/internal/repository"
	"gitlab.com/eqshare/eqshare-back/internal/service"
	"gorm.io/driver/postgres"
	"gorm.io/gorm"
)

func init() {
	almatyTimeZone, err := time.LoadLocation("Asia/Almaty")
	if err != nil {
		log.Panicln("Ошибка при загрузке часового пояса Алматы:", err)
	}
	time.Local = almatyTimeZone

	docs.SwaggerInfo.BasePath = "/"
}

// @title						Equipment Share
// @version					1.0
// @description				API Server for TodoList Application
// @host						localhost:8080
// @BasePath					/
// @securityDefinitions.apikey	ApiKeyAuth Bearer
// @in							header
// @name						Authorization
func main() {
	ctx := context.Background()

	logrus.SetFormatter(&logrus.TextFormatter{})

	logrus.Info("Read config...")

	config := config.InitConfigs()

	objectStorageConfig := &aws.Config{
		Credentials: credentials.NewStaticCredentials(
			config.ObjectStorage.ClientKey,
			config.ObjectStorage.ClientSecret,
			""),
		Endpoint:         aws.String(config.ObjectStorage.Endpoint),
		Region:           aws.String("us-east-1"),
		DisableSSL:       aws.Bool(true),
		S3ForcePathStyle: aws.Bool(false),
	}

	newSession, err := session.NewSession(objectStorageConfig)
	if err != nil {
		fmt.Println(err.Error())
		return
	}

	s3Client := s3.New(newSession)
	config.S3 = s3Client

	logrus.Infof("Set log level: %s", config.LogLevel)

	switch config.LogLevel {
	case "PANIC":
		logrus.SetLevel(logrus.PanicLevel)
	case "FATAL":
		logrus.SetLevel(logrus.FatalLevel)
	case "ERROR":
		logrus.SetLevel(logrus.ErrorLevel)
	case "WARN":
		logrus.SetLevel(logrus.WarnLevel)
	case "INFO":
		logrus.SetLevel(logrus.InfoLevel)
	case "DEBUG":
		logrus.SetLevel(logrus.DebugLevel)
	case "TRACE":
		logrus.SetLevel(logrus.TraceLevel)
	default:
		logrus.Debug(logrus.DebugLevel)
	}

	dsn := fmt.Sprintf("host=%s user=%s password=%s dbname=%s port=%s sslmode=%s",
		config.Database.Host,
		config.Database.Username,
		config.Database.Password,
		config.Database.DBName,
		config.Database.Port,
		config.Database.SSLMode,
	)

	logrus.Info("Connect PostgreSQL...")
	db, err := gorm.Open(postgres.Open(dsn))
	if err != nil {
		log.Fatal(err)
	}

	rootDB, err := db.DB()
	if err != nil {
		logrus.Fatal(err)
	}

	logrus.Info("Ping db...")
	if err := rootDB.Ping(); err != nil {
		logrus.Fatal(err)
	}

	//db.AutoMigrate(&model.OwnerDriverRequests{})

	opt := option.WithCredentialsFile(config.FirebaseConfigPath)

	app, err := firebase.NewApp(ctx, nil, opt)
	if err != nil {
		logrus.Fatal(err)
	}

	config.MessageApp = app

	remote := client.NewRemote(config.S3, config.ObjectStorage, app, config.SMTP, config.SMS)

	sheduler, err := gocron.NewScheduler()
	if err != nil {
		logrus.Fatal(err)
	}

	cfg := elasticsearch.Config{
		Addresses: []string{
			config.Elastic.URL,
		},
	}
	es, err := elasticsearch.NewClient(cfg)
	if err != nil {
		logrus.Fatal(err)
	}

	req, err := es.Ping()
	if err != nil {
		logrus.Fatal(err)
	}

	if req.StatusCode != 200 {
		logrus.Fatal("dont connect elastic")
	}

	readBody := func(body io.Reader) error {
		data, err := io.ReadAll(body)
		if err != nil {
			return err
		}
		fmt.Printf("%v\n", string(data))
		return nil
	}

	redisClient := redis.NewClient(&redis.Options{
		Addr:     "localhost:6379", // change to your Redis server address
		Password: "",               // no password set
		DB:       0,                // use default DB
	})
	_ = readBody

	logrus.Info("Create elastic right...")
	adEquipment := elastic.NewAdEquipment(es)
	adEquipmentClient := elastic.NewAdEquipmentClient(es)
	adSpecializedMachinery := elastic.NewAdSpecializedMachinery(es)
	adSpecializedMachineryClient := elastic.NewAdSpecializedMachineryClient(es)
	categoryEqClient := elastic.NewCategoryEq(es)
	categoryaSmClient := elastic.NewCategoryaSm(es)
	subCategoryaEqClient := elastic.NewSubCategoryEq(es)
	subCategoryaSmClient := elastic.NewSubCategorySm(es)
	adConstructionMaterialElastic := elastic.NewAdConstructionMaterial(es)
	adConstructionMaterialClientElastic := elastic.NewAdConstructionMaterialClient(es)
	adConstructionMaterialCategoryElastic := elastic.NewCategoryCm(es)
	adServiceElastic := elastic.NewAdService(es)
	adServiceClientElastic := elastic.NewAdServiceClient(es)
	adServiceCategoryElastic := elastic.NewCategorySvc(es)

	logrus.Info("Create repository right...")
	rightRepository := repository.NewRight(db)
	roleRepository := repository.NewRole(db)
	userRepository := repository.NewUser(db)
	authRepository := repository.NewAuthentication(db)
	adsmRepository := repository.NewAdSpecializedMachinery(db)
	brandRepository := repository.NewBrand(db)
	typeRepository := repository.NewType(db)
	cityRepository := repository.NewCity(db)
	requestRepository := repository.NewRequestRepository(db)
	driverLicense := repository.NewDriverLicenseRepository(db)
	documentRepository := repository.NewDocumentRepository(db)
	smrRepository := repository.NewSpecializedMachineryRequest(db)
	seRepository := repository.NewRequestExecution(db)
	adClientRepository := repository.NewAdClientRepository(db)
	statRepository := repository.NewStatisticRepository(db)
	sbCategoryRepository := repository.NewSubCategoryRepository(db)
	notificationRepository := repository.NewNotificationRepository(db)
	logsRepository := repository.NewAdminLogsRepository(db)
	oRepository := repository.NewOwner(db)
	tpRepository := repository.NewTypeParams(db)
	paramRepository := repository.NewParam(db)
	favoriteRepository := repository.NewFavorite(db)
	searchRepository := repository.NewSearch(db)
	adEquipmentClientRepository := repository.NewAdEquipmentClient(db)
	equipmentCategoryRepo := repository.NewEquipmentCategory(db)
	equipmentSubCategoryRepo := repository.NewEquipmentSubCategory(db)
	adEquipmentRepo := repository.NewAdEquipment(db)
	equipmentBrandRepo := repository.NewEquipmentBrand(db)
	requestAdEquipmentRepo := repository.NewRequestAdEquipment(db)
	requestAdEquipmentClientRepo := repository.NewRequestAdEquipmentClient(db)
	reportReasonsRepo := repository.NewReportReasons(db)
	reportAdSpecializedMachineryRepo := repository.NewReportAdSpecializedMachinery(db)
	reportAdSpecializedMachineryClientRepo := repository.NewReportAdSpecializedMachineryClient(db)
	reportAdConstructionMaterialRepo := repository.NewReportAdConstructionMaterial(db)
	reportAdConstructionMaterialClientRepo := repository.NewReportAdConstructionMaterialClient(db)
	reportAdServiceRepo := repository.NewReportAdService(db)
	reportAdServiceClientRepo := repository.NewReportAdServiceClient(db)
	reportAdEquipmentRepo := repository.NewReportAdEquipment(db)
	reportAdEquipmentClientRepo := repository.NewReportAdEquipmentClient(db)
	positionRepo := repository.NewPosition(db)
	equipmentSubCategoryParamsRepo := repository.NewEquipmentSubCategoryParams(db)
	reportSysytemRepo := repository.NewReportSysytem(db)
	subscriptionRepo := repository.NewSubscription(db)
	adConstructionMaterialRepo := repository.NewAdConstructionMaterials(db)
	adConstructionMaterialClientRepo := repository.NewAdConstructionMaterialClient(db)
	constructionMaterialCategoryRepo := repository.NewConstructionMaterialCategory(db)
	constructionMaterialSubCategoryRepo := repository.NewConstructionMaterialSubCategory(db)
	constructionMaterialSubCategoryParamsRepo := repository.NewConstructionMaterialSubCategoryParams(db)
	adConstructionMaterialBrandRepo := repository.NewConstructionMaterialBrand(db)
	requestAdConstructionMaterialRepo := repository.NewRequestAdConstructionMaterial(db)
	requestAdConstructionMaterialClientRepo := repository.NewRequestAdConstructionMaterialClient(db)
	adServiceRepo := repository.NewAdService(db)
	adServiceClientRepo := repository.NewAdServiceClient(db)
	adServiceBrandRepo := repository.NewServiceBrand(db)
	serviceCategoryRepo := repository.NewServiceCategory(db)
	serviceSubCategoryRepo := repository.NewServiceSubCategory(db)
	serviceSubCategoryParamsRepo := repository.NewServiceSubCategoryParams(db)
	requestAdServiceRepo := repository.NewRequestAdService(db)
	requestAdServiceClientRepo := repository.NewRequestAdServiceClient(db)
	driverMoveRepo := repository.NewDriverMove(db)

	subscriptionService := service.NewSubscription(subscriptionRepo, remote)
	adClientService := service.NewAdClientService(
		adClientRepository, documentRepository, remote, userRepository,
		logsRepository, favoriteRepository, adSpecializedMachineryClient, subscriptionService)
	rightService := service.NewRight(rightRepository)
	roleService := service.NewRole(roleRepository)
	userService := service.NewUser(userRepository, remote, remote.SMTPClient, remote.SMSClient)
	adsmService := service.NewAdSpecializedMachinery(
		adsmRepository, documentRepository, remote, smrRepository, seRepository,
		logsRepository, userRepository, favoriteRepository, adSpecializedMachinery)
	brandService := service.NewBrand(brandRepository)
	typeService := service.NewType(typeRepository, documentRepository, remote, tpRepository, sbCategoryRepository, categoryaSmClient)
	cityService := service.NewCity(cityRepository)
	driverMoveService := service.NewDriverMoveService(driverMoveRepo)
	reService := service.NewRequestExecution(
		seRepository, remote, remote, notificationRepository, smrRepository,
		logsRepository, adsmRepository, adClientRepository, requestAdEquipmentRepo, userRepository)
	requestService := service.NewRequestService(
		requestRepository, *reService, adClientRepository, remote,
		notificationRepository, userRepository, logsRepository, remote)
	smrService := service.NewSpecializedMachineryRequest(
		smrRepository, adsmRepository, reService, remote,
		remote, notificationRepository, userRepository)
	ownerService := service.NewOwner(oRepository, userRepository, remote, notificationRepository)
	authService := service.NewAuthenticationService(
		authRepository, userRepository,
		config.JWT, driverLicense, oRepository, remote.SMSClient, config.SMS)
	statService := service.NewStatisticService(statRepository)
	subCategoryService := service.NewSubCategoryService(sbCategoryRepository, remote, typeRepository, adsmRepository, categoryaSmClient)
	notificationService := service.NewNotificationService(notificationRepository)
	logsService := service.NewAdminLogs(logsRepository)
	paramService := service.NewParam(paramRepository)
	searchService := service.NewSearch(searchRepository, remote,
		adEquipment,
		adEquipmentClient,
		adSpecializedMachineryClient,
		adSpecializedMachinery,
		adConstructionMaterialElastic,
		adConstructionMaterialClientElastic,
		categoryEqClient,
		categoryaSmClient,
		subCategoryaEqClient,
		subCategoryaSmClient,
		adServiceElastic,
		adServiceClientElastic,
		documentRepository,
	)
	driverService := service.NewDocumentService(documentRepository, remote, userRepository, driverLicense, driverMoveRepo, oRepository, remote, notificationRepository)
	adEquipmentClientService := service.NewAdEquipmentClient(adEquipmentClientRepository, remote, favoriteRepository, adEquipmentClient, subscriptionService)
	equipmentCategoryService := service.NewEquipmentCategory(equipmentCategoryRepo, adEquipmentRepo, adEquipmentClientRepository, remote, categoryEqClient)
	equipmentSubCategoryService := service.NewEquipmentSubCategory(equipmentSubCategoryRepo,
		equipmentSubCategoryParamsRepo, remote, equipmentCategoryService, categoryEqClient)
	adEquipmentService := service.NewAdEquipment(adEquipmentRepo, remote, favoriteRepository, adEquipment)
	equipmentBrandService := service.NewEquipmentBrand(equipmentBrandRepo)
	requestAdEquipmentService := service.NewRequestAdEquipment(
		requestAdEquipmentRepo, remote, reService, adEquipmentService,
		notificationRepository, remote, userRepository)
	requestAdEquipmentClientService := service.NewRequestAdEquipmentClient(
		requestAdEquipmentClientRepo, remote, reService, adEquipmentClientService,
		notificationRepository, remote, userRepository)
	positionService := service.NewPosition(positionRepo)
	reportService := service.NewReport(
		reportReasonsRepo,
		reportAdSpecializedMachineryRepo,
		reportAdEquipmentRepo,
		reportSysytemRepo,
		reportAdSpecializedMachineryClientRepo,
		reportAdEquipmentClientRepo,
		remote,
		reportAdConstructionMaterialRepo,
		reportAdConstructionMaterialClientRepo,
		reportAdServiceRepo,
		reportAdServiceClientRepo,
	)
	adConstructionMaterialService := service.NewAdConstructionMaterial(
		adConstructionMaterialRepo,
		remote,
		favoriteRepository,
		adConstructionMaterialElastic,
	)
	adConstructionMaterialBrandService := service.NewConstructionMaterialBrand(adConstructionMaterialBrandRepo)
	adConstructionMaterialClientService := service.NewAdConstructionMaterialClient(
		adConstructionMaterialClientRepo,
		remote,
		favoriteRepository,
		adConstructionMaterialClientElastic,
		subscriptionService,
	)
	constructionMaterialCategoryService := service.NewConstructionMaterialCategory(
		constructionMaterialCategoryRepo,
		adConstructionMaterialRepo,
		adConstructionMaterialClientRepo,
		remote,
		adConstructionMaterialCategoryElastic,
	)
	constructionMaterialSubCategoryService := service.NewConstructionMaterialSubCategory(
		constructionMaterialSubCategoryRepo,
		constructionMaterialSubCategoryParamsRepo,
		remote,
		constructionMaterialCategoryService,
		adConstructionMaterialCategoryElastic,
	)
	requestAdConstructionMaterialService := service.NewRequestAdConstructionMaterial(
		requestAdConstructionMaterialRepo, remote, reService, adConstructionMaterialService,
		notificationRepository, remote, userRepository)
	requestAdConstructionMaterialClientService := service.NewRequestAdConstructionMaterialClient(
		requestAdConstructionMaterialClientRepo, remote, reService, adConstructionMaterialClientService,
		notificationRepository, remote, userRepository)
	adServiceService := service.NewAdService(
		adServiceRepo,
		remote,
		favoriteRepository,
		adServiceElastic,
	)
	adServiceClientService := service.NewAdServiceClient(
		adServiceClientRepo,
		remote,
		favoriteRepository,
		adServiceClientElastic,
		subscriptionService,
	)
	adServiceBrandService := service.NewServiceBrand(adServiceBrandRepo)
	serviceCategoryService := service.NewServiceCategory(
		serviceCategoryRepo,
		adServiceRepo,
		adServiceClientRepo,
		remote,
		adServiceCategoryElastic,
	)
	serviceSubCategoryService := service.NewServiceSubCategory(
		serviceSubCategoryRepo,
		serviceSubCategoryParamsRepo,
		remote,
		serviceCategoryService,
		adServiceCategoryElastic,
	)
	requestAdServiceService := service.NewRequestAdService(
		requestAdServiceRepo, remote, reService, adServiceService,
		notificationRepository, remote, userRepository)
	requestAdServiceClientService := service.NewRequestAdServiceClient(
		requestAdServiceClientRepo, remote, reService, adServiceClientService,
		notificationRepository, remote, userRepository)
	requestNotification := service.NewRequestNotification(oRepository, userRepository, remote, notificationRepository)

	workerService := service.NewWorker(reService, notificationRepository, remote)
	{
		_, err = sheduler.NewJob(
			gocron.DurationJob(
				30*time.Second,
			),
			gocron.NewTask(
				workerService.NoticeAfter,
				10*time.Minute,
			),
		)
		if err != nil {
			logrus.Fatal(err)
		}

		_, err = sheduler.NewJob(
			gocron.DurationJob(
				10*time.Minute,
			),
			gocron.NewTask(
				workerService.NoticeForgotToStart,
			),
		)
		if err != nil {
			logrus.Fatal(err)
		}

		_, err = sheduler.NewJob(
			gocron.DurationJob(
				10*time.Minute,
			),
			gocron.NewTask(
				workerService.NoticeForgotToEnd,
			),
		)
		if err != nil {
			logrus.Fatal(err)
		}
	}

	r := gin.New()
	r.Use(
		gin.Recovery(),
		gin.Logger(),
		controller.CORSMiddleware(),
	)

	controller.NewEquipmentCategory(r, equipmentCategoryService, equipmentSubCategoryService)
	controller.NewRigth(r, rightService, authService)
	controller.NewRole(r, roleService, authService)
	controller.NewUser(r, authService, userService)
	controller.NewAuthentication(r, authService)
	controller.NewAdSpecializedMachinery(r, authService, adsmService, userService, adsmService, redisClient)
	controller.NewBrand(r, brandService, authService, adConstructionMaterialBrandService, adServiceBrandService)
	controller.NewType(r, typeService, authService)
	controller.NewCity(r, cityService, authService)
	controller.NewSpecializedMachineryRequest(r, authService, smrService, userService)
	controller.NewDriver(r, driverService, userService, authService, ownerService, driverMoveService)
	controller.NewRequestExecution(r, authService, reService, driverMoveService)
	controller.NewAdClient(r, adClientService, authService, userService)
	controller.NewRequest(r, authService, requestService)
	controller.NewStatistic(r, statService, authService)
	controller.NewOwner(r, authService, ownerService)
	controller.NewSubCategory(r, subCategoryService, authService)
	controller.NewNotification(r, authService, notificationService)
	controller.NewLogs(r, logsService)
	controller.NewParam(r, authService, paramService)
	controller.InitSwagger(r)
	controller.NewSearch(r, searchService)
	controller.NewAdEquipmentClient(r, authService, adEquipmentClientService)
	controller.NewAdEquipment(r, authService, adEquipmentService)
	controller.NewEquipmentBrand(r, equipmentBrandService)
	controller.NewRequestAdEquipment(r, authService, requestAdEquipmentService)
	controller.NewRequestAdEquipmentClient(r, authService, requestAdEquipmentClientService)
	controller.NewReport(r, authService, reportService)
	controller.NewPosition(r, authService, positionService)
	controller.NewSubscription(r, subscriptionService, authService)
	controller.NewAdConstructionMaterial(r, authService, adConstructionMaterialService)
	controller.NewAdConstructionMaterialClient(r, authService, adConstructionMaterialClientService)
	controller.NewConstructionMaterialCategory(r, constructionMaterialCategoryService, constructionMaterialSubCategoryService)
	controller.NewRequestAdConstructionMaterial(r, authService, requestAdConstructionMaterialService)
	controller.NewRequestAdConstructionMaterialClient(r, authService, requestAdConstructionMaterialClientService)
	controller.NewAdService(r, authService, adServiceService)
	controller.NewAdServiceClient(r, authService, adServiceClientService)
	controller.NewServiceCategory(r, serviceCategoryService, serviceSubCategoryService)
	controller.NewRequestAdService(r, authService, requestAdServiceService)
	controller.NewRequestAdServiceClient(r, authService, requestAdServiceClientService)
	controller.NewRequestNotification(r, authService, requestNotification)

	//TEST ONLY
	controller.NewTest(r, *remote)

	srv := http.Server{Addr: config.Port, Handler: r}

	go func() {
		logrus.Infof("Start work server on: localhost:%v", config.Port)
		if err := srv.ListenAndServe(); err != nil && !errors.Is(err, http.ErrServerClosed) {
			logrus.Fatalf("Error run server: %v", err)
		}
	}()

	go func() {
		sheduler.Start()
	}()

	quit := make(chan os.Signal, 1)
	signal.Notify(quit, syscall.SIGINT, syscall.SIGTERM)
	<-quit
	log.Println("Shutdown Server...")

	ctx, cancel := context.WithTimeout(context.Background(), 1*time.Second)
	defer cancel()
	if err := srv.Shutdown(ctx); err != nil {
		log.Fatal("Server Shutdown:", err)
	}

	err = sheduler.Shutdown()
	if err != nil {
		logrus.Fatal(err)
	}

	<-ctx.Done()
	log.Println("timeout of 2 seconds.")

	log.Println("Server exiting")
}
