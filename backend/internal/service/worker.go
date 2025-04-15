package service

import (
	"context"
	"database/sql"
	"errors"
	"fmt"
	"sync"
	"time"

	"github.com/sirupsen/logrus"
	client2 "gitlab.com/eqshare/eqshare-back/internal/client"
	"gitlab.com/eqshare/eqshare-back/internal/repository"
	"gitlab.com/eqshare/eqshare-back/model"
)

type IWorker interface {
	NoticeAfter(dur time.Duration) error
	NoticeForgotToStart() error
	NoticeForgotToEnd() error
}

type worker struct {
	requestExecutionService IRequestExecution
	notificationRepo        repository.INotification
	messageClient           client2.NotificationClient
}

func NewWorker(requestExecutionService IRequestExecution,
	notificationRepo repository.INotification,
	messageClient client2.NotificationClient,
) IWorker {
	return &worker{
		requestExecutionService: requestExecutionService,
		notificationRepo:        notificationRepo,
		messageClient:           messageClient,
	}
}

func (w *worker) NoticeAfter(dur time.Duration) error {
	now := time.Now()

	f := false
	res, _, err := w.requestExecutionService.Get(model.FilterRequestExecution{
		Status:             []string{model.STATUS_AWAITS_START, model.STATUS_ON_ROAD},
		AfterStartLeaseAt:  model.Time{NullTime: sql.NullTime{Time: now.Add(-dur), Valid: true}},
		BeforeStartLeaseAt: model.Time{NullTime: sql.NullTime{Time: now, Valid: true}},
		PostNotification:   &f,
	})
	if err != nil {
		return err
	}

	wg := sync.WaitGroup{}
	errCh := make(chan error, len(res))
	ids := make([]int, 0, len(res))

	for _, re := range res {
		re := re
		ids = append(ids, re.ID)
		wg.Add(1)
		go func() {
			defer wg.Done()
			if re.AssignTo != nil {
				{
					tokens, err := w.notificationRepo.GetDeviceToken(model.DeviceToken{UserID: *re.AssignTo})
					if err != nil {
						errCh <- err
						return
					}
					if len(tokens) == 0 {
						return
					}

					err = w.messageClient.Send(context.Background(), model.Notification{
						DeviceTokens: tokens,
						Message:      fmt.Sprintf("Напоминаем, что у вас есть заказ, %s, назначенный на время %s", re.Title, re.StartLeaseAt.Time.Format(time.TimeOnly)),
						Tittle:       "Напоминание о заказе",
						Data:         map[string]string{},
					})
					if err != nil {
						errCh <- err
						return
					}
				}
				{
					tokens, err := w.notificationRepo.GetDeviceToken(model.DeviceToken{UserID: *re.DriverID})
					if err != nil {
						errCh <- err
						return
					}
					if len(tokens) == 0 {
						return
					}

					err = w.messageClient.Send(context.Background(), model.Notification{
						DeviceTokens: tokens,
						Message:      fmt.Sprintf("Напоминаем, что у вашего водителя есть заказ, %s, назначенный на время %s", re.Title, re.StartLeaseAt.Time.Format(time.TimeOnly)),
						Tittle:       "Напоминание о заказе",
						Data:         map[string]string{},
					})
					if err != nil {
						errCh <- err
						return
					}
				}
			} else if re.DriverID != nil {
				{
					tokens, err := w.notificationRepo.GetDeviceToken(model.DeviceToken{UserID: *re.DriverID})
					if err != nil {
						errCh <- err
						return
					}
					if len(tokens) == 0 {
						return
					}

					err = w.messageClient.Send(context.Background(), model.Notification{
						DeviceTokens: tokens,
						Message:      fmt.Sprintf("Напоминаем, что у вас есть заказ, %s, назначенный на время %s", re.Title, re.StartLeaseAt.Time.Format(time.TimeOnly)),
						Tittle:       "Напоминание о заказе",
						Data:         map[string]string{},
					})
					if err != nil {
						errCh <- err
						return
					}
				}
			} else {
				errCh <- errors.New("vse ploha logica slomalas")
				return
			}
		}()
	}
	wg.Wait()

	close(errCh)

	for err := range errCh {
		if err != nil {
			return err
		}
	}

	err = w.requestExecutionService.UpdatePostNotificationOnTrue(context.Background(), ids...)
	if err != nil {
		return err
	}

	return nil
}

func (w *worker) NoticeForgotToStart() error {
	now := time.Now()

	f := false
	res, _, err := w.requestExecutionService.Get(model.FilterRequestExecution{
		Status:             []string{model.STATUS_AWAITS_START, model.STATUS_ON_ROAD},
		BeforeStartLeaseAt: model.Time{NullTime: sql.NullTime{Time: now, Valid: true}},
		ForgotToStart:      &f,
	})
	if err != nil {
		return err
	}

	wg := sync.WaitGroup{}
	errCh := make(chan error, len(res))

	for _, re := range res {
		if !re.WorkStartedAt.Valid {
			continue
		}
		re := re
		wg.Add(1)
		go func() {
			defer wg.Done()
			re := re
			if re.AssignTo != nil {
				{
					tokens, err := w.notificationRepo.GetDeviceToken(model.DeviceToken{UserID: *re.AssignTo})
					if err != nil {
						errCh <- err
						return
					}
					if len(tokens) == 0 {
						return
					}

					err = w.messageClient.Send(context.Background(), model.Notification{
						DeviceTokens: tokens,
						Message:      fmt.Sprintf("Напоминаем, что заказ, который должен был начаться в %s, ещё не активирован. Пожалуйста, активируйте его как можно скорее.", re.WorkStartedAt.Time.Format(time.DateTime)),
						Tittle:       "Напоминание о заказе",
						Data:         map[string]string{},
					})
					if err != nil {
						errCh <- err
						return
					}
				}
				{
					tokens, err := w.notificationRepo.GetDeviceToken(model.DeviceToken{UserID: *re.DriverID})
					if err != nil {
						errCh <- err
						return
					}
					if len(tokens) == 0 {
						return
					}

					err = w.messageClient.Send(context.Background(), model.Notification{
						DeviceTokens: tokens,
						Message:      fmt.Sprintf("Напоминаем, что заказ, который должен был начаться в %s, ещё не активирован. Пожалуйста, активируйте его как можно скорее.", re.WorkStartedAt.Time.Format(time.DateTime)),
						Tittle:       "Напоминание о заказе",
						Data:         map[string]string{},
					})
					if err != nil {
						errCh <- err
						return
					}
				}
				re.ForgotToStart = true
				err = w.requestExecutionService.Update(context.Background(), re)
				if err != nil {
					errCh <- err
					return
				}
			} else if re.DriverID != nil {
				{
					tokens, err := w.notificationRepo.GetDeviceToken(model.DeviceToken{UserID: *re.DriverID})
					if err != nil {
						errCh <- err
						return
					}
					if len(tokens) == 0 {
						return
					}

					err = w.messageClient.Send(context.Background(), model.Notification{
						DeviceTokens: tokens,
						Message:      fmt.Sprintf("Напоминаем, что заказ, который должен был начаться в %s, ещё не активирован. Пожалуйста, активируйте его как можно скорее.", re.WorkStartedAt.Time.Format(time.DateTime)),
						Tittle:       "Напоминание о заказе",
						Data:         map[string]string{},
					})
					if err != nil {
						errCh <- err
						return
					}

					re.ForgotToStart = true
					err = w.requestExecutionService.Update(context.Background(), re)
					if err != nil {
						errCh <- err
						return
					}
				}
			} else {
				errCh <- errors.New("vse ploha logica slomalas")
				return
			}
		}()
	}
	wg.Wait()

	close(errCh)

	for err := range errCh {
		if err != nil {
			logrus.Error(err)
			return err
		}
	}

	// err = w.requestExecutionService.UpdatePostNotificationOnTrue(context.Background(), ids...)
	// if err != nil {
	// 	logrus.Error(err)
	// 	return err
	// }
	return nil
}

func (w *worker) NoticeForgotToEnd() error {
	now := time.Now()

	t := false
	res, _, err := w.requestExecutionService.Get(model.FilterRequestExecution{
		Status:           []string{model.STATUS_WORKING},
		BeforeEndLeaseAt: model.Time{NullTime: sql.NullTime{Time: now, Valid: true}},
		AfterEndLeaseAt:  model.Time{NullTime: sql.NullTime{Time: now.Add(-(time.Minute * 30)), Valid: true}},
		ForgotToEnd:      &t,
	})
	if err != nil {
		return err
	}

	for _, re := range res {
		if !re.EndLeaseAt.Valid {
			continue
		}

		tokens := make([]string, 0)

		switch {
		case re.AssignTo != nil:
			tokenA, err := w.notificationRepo.GetDeviceToken(model.DeviceToken{UserID: *re.AssignTo})
			if err != nil {
				return err
			}
			tokens = append(tokens, tokenA...)
			fallthrough
		case re.DriverID != nil:
			tokensD, err := w.notificationRepo.GetDeviceToken(model.DeviceToken{UserID: *re.DriverID})
			if err != nil {
				return err
			}

			tokens = append(tokens, tokensD...)
		default:
			return err
		}

		go func() {
			err = w.messageClient.Send(context.Background(), model.Notification{
				Tittle: "Наступило о завершении заказа",
				Message: fmt.Sprintf("Напоминаем, что время окончания заказа было запланировано на %s",
					re.EndLeaseAt.Time.Format("2006-01-02 15:04")),
				DeviceTokens: tokens,
			})
			if err != nil {
				logrus.Error(err)
			}
		}()

		re.ForgotToEnd = true

		err = w.requestExecutionService.Update(context.Background(), re)
		if err != nil {
			return err
		}
	}

	return nil
}
