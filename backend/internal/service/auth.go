package service

import (
	"context"
	"errors"
	"fmt"
	"gitlab.com/eqshare/eqshare-back/internal/client"
	"gitlab.com/eqshare/eqshare-back/internal/client/sms"
	"gitlab.com/eqshare/eqshare-back/pkg/util"
	"strconv"
	"time"

	"github.com/golang-jwt/jwt/v5"
	"github.com/google/uuid"
	"gitlab.com/eqshare/eqshare-back/config"
	"gitlab.com/eqshare/eqshare-back/internal/repository"
	"gitlab.com/eqshare/eqshare-back/model"
	"golang.org/x/crypto/bcrypt"
)

const iss = "eqshare"

type IAuthentication interface {
	SignUp(signUp model.SignUp) (model.Token, error)
	SignIn(auth model.SignIn) (model.Token, error)
	SignOut()
	Refresh(token string) (model.Token, error)
	AccessRole(ctx context.Context, token, role string) (model.Token, error)
	VerifyToken(token string) (model.User, error)
	AdminSignIn(signin model.SignIn) (model.Token, error)
	SendCode(input model.SendCode) error
	ConfirmCode(input model.ConfirmCode) error
}

var _ IAuthentication = (*auth)(nil)

type auth struct {
	authRepo repository.IAuthentication
	userRepo repository.IUser
	// roleRepo  repository.IRole
	// docRepo   repository.IDocument
	docDriver repository.IDriverLicense
	jwtConfig config.JWT
	ownerRepo repository.IOwner
	sms       client.SMSClient
	smsConfig config.SMS
}

func NewAuthenticationService(
	aR repository.IAuthentication,
	UR repository.IUser,
	c config.JWT,
	docDriver repository.IDriverLicense,
	ownerRepo repository.IOwner,
	sms client.SMSClient,
	smsConfig config.SMS) *auth {
	return &auth{
		authRepo:  aR,
		userRepo:  UR,
		jwtConfig: c,
		docDriver: docDriver,
		ownerRepo: ownerRepo,
		sms:       sms,
		smsConfig: smsConfig,
	}
}

func (a *auth) VerifyToken(token string) (model.User, error) {
	jwtToken, err := jwt.ParseWithClaims(
		token,
		jwt.MapClaims{},
		func(t *jwt.Token) (interface{}, error) {
			claim, ok := t.Claims.(jwt.MapClaims)
			if !ok {
				return nil, model.ErrClaimDontCast
			}

			if jti, ok := claim["jti"].(string); ok && jti != "" {
				return a.jwtConfig.KeyRefresh, nil
			}

			return a.jwtConfig.KeyAccess, nil
		},
	)
	if err != nil {
		return model.User{}, err
	}

	if !jwtToken.Valid {
		return model.User{}, model.ErrDonValidToken
	}

	sub, err := jwtToken.Claims.GetSubject()
	if err != nil {
		return model.User{}, err
	}

	l, err := jwtToken.Claims.GetAudience()
	if err != nil {
		return model.User{}, err
	}

	if len(l) != 1 {
		return model.User{}, model.ErrDonValidToken
	}

	id, err := strconv.Atoi(sub)
	if err != nil {
		return model.User{}, err
	}

	user, err := a.userRepo.GetByID(id)
	if err != nil {
		return model.User{}, err
	}

	user.Password = ""
	user.AccessRole = l[0]
	return user, nil
}

func (a *auth) SignUp(signUp model.SignUp) (model.Token, error) {
	// проверка есть ли юзер в базе, номер может быть занят или удален

	// при случаее когда юзер удален нужно возвращать опреденный код
	// TODO написать метод и для востонавления юзера
	_, err := a.userRepo.GetByPhoneNumber(signUp.PhoneNumber)
	if err != nil && !errors.Is(err, model.ErrNotFound) {
		return model.Token{}, err
	} else if err == nil {
		return model.Token{}, model.ErrUserExists
	}

	hashedPass, err := hashPassword(signUp.Password)
	if err != nil {
		return model.Token{}, errors.New("failed to hash password")
	}

	u := model.User{
		FirstName:   signUp.FirstName,
		LastName:    signUp.LastName,
		PhoneNumber: signUp.PhoneNumber,
		Password:    hashedPass,
		CityID:      signUp.CityID,
		AccessRole:  model.ROLE_CLIENT,
		CanDriver:   true,         //заглушка в обход проверки на доументы водителя
		Email:       signUp.Email, //заглушка в обход проверки на доументы водителя
	}

	if signUp.Document != nil {
		u.Document = signUp.Document
	}

	user, err := a.userRepo.Create(u)

	if err != nil {
		return model.Token{}, err
	}

	now := time.Now()

	tokenA, err := a.newToken(
		model.ROLE_CLIENT,
		now.Add(time.Second*time.Duration(a.jwtConfig.ExpiredAccess)).Unix(),
		"",
		now.Unix(),
		iss,
		now.Unix(),
		strconv.Itoa(user.ID),
	)
	if err != nil {
		return model.Token{}, err
	}

	uuid := uuid.New().String()

	tokenR, err := a.newToken(
		model.ROLE_CLIENT,
		now.Add(time.Second*time.Duration(a.jwtConfig.ExpiredRefresh)).Unix(),
		uuid,
		now.Unix(),
		iss,
		now.Unix(),
		strconv.Itoa(user.ID),
	)
	if err != nil {
		return model.Token{}, err
	}

	//сохранить в базе, удаояется при рефреш операции
	if err = a.authRepo.SaveToken(user.ID, uuid, tokenR); err != nil {
		return model.Token{}, err
	}

	return model.Token{
		Access:  tokenA,
		Refresh: tokenR,
	}, nil
}

func (a *auth) SignIn(auth model.SignIn) (token model.Token, err error) {
	user, err := a.userRepo.GetByPhoneNumber(auth.PhoneNumber)
	if err != nil {
		return token, model.ErrNotFound
	}

	if err := bcrypt.CompareHashAndPassword([]byte(user.Password), []byte(auth.Password)); err != nil {
		if errors.Is(err, bcrypt.ErrMismatchedHashAndPassword) {
			return token, model.ErrPasswordDontMatch
		}
		return token, err
	}

	now := time.Now()

	//logrus.Info("Acces role: ", user.AccessRole)

	tokenA, err := a.newToken(
		user.AccessRole,
		now.Add(time.Second*time.Duration(a.jwtConfig.ExpiredAccess)).Unix(),
		"",
		now.Unix(),
		iss,
		now.Unix(),
		strconv.Itoa(user.ID),
	)
	if err != nil {
		return token, err
	}

	uuid := uuid.New().String()

	tokenR, err := a.newToken(
		user.AccessRole,
		now.Add(time.Second*time.Duration(a.jwtConfig.ExpiredRefresh)).Unix(),
		uuid,
		now.Unix(),
		iss,
		now.Unix(),
		strconv.Itoa(user.ID),
	)
	if err != nil {
		return token, err
	}

	//сохранить в базе, удаояется при рефреш операции
	if err := a.authRepo.SaveToken(user.ID, uuid, tokenR); err != nil {
		return token, err
	}

	return model.Token{
		Access:  tokenA,
		Refresh: tokenR,
	}, nil
}

func (a *auth) newToken(aud any, exp int64, jti string, iat int64, iss string, nbf int64, sub any) (string, error) {
	mC := jwt.MapClaims{}
	var key []byte

	// aud (Аудитория): Определяет получателя или аудиторию, для которой токен предназначен.
	if aud.(string) != "" {
		mC["aud"] = aud
	}
	// exp (Время истечения): Указывает время истечения токена. После этого времени токен считается недействительным.
	if exp != 0 {
		mC["exp"] = exp
	}
	// jti (Уникальный идентификатор токена): Предоставляет уникальный идентификатор для токена.
	// Этот идентификатор может использоваться для предотвращения повторного использования токена.
	if jti != "" {
		mC["jti"] = jti
		key = a.jwtConfig.KeyRefresh
	} else {
		key = a.jwtConfig.KeyAccess
	}
	// iat (Время выдачи): Указывает время создания токена.
	if iat != 0 {
		mC["iat"] = iat
	}
	// iss (Издатель): Указывает издателя токена, т.е. того, кто выдал токен.
	if iss != "" {
		mC["iss"] = iss
	}
	// nbf (Время начала действия): Определяет время, до которого токен не должен быть принят в работу.
	if nbf != 0 {
		mC["nbf"] = nbf
	}
	// sub (Субъект): Определяет субъект токена, т.е. объект, о котором идет речь в токене.
	if sub != 0 {
		mC["sub"] = sub
	}

	t := jwt.NewWithClaims(jwt.SigningMethodHS256, mC)

	token, err := t.SignedString(key)
	if err != nil {
		return "", err
	}

	return token, nil
}

// Выполняет refresh операцию над токеном
func (a *auth) Refresh(token string) (model.Token, error) {
	var oldUUID string

	jwtToken, err := jwt.ParseWithClaims(
		token,
		jwt.MapClaims{},
		func(t *jwt.Token) (interface{}, error) {
			claim, ok := t.Claims.(jwt.MapClaims)
			if !ok {
				return nil, model.ErrClaimDontCast
			}

			jti, ok := claim["jti"]
			if !ok {
				return nil, errors.New("cliam dont have jti")
			}

			uuid, ok := jti.(string)
			if !ok {
				return nil, errors.New("jti dont cast to string")
			}

			oldUUID = uuid

			tokenStr, err := a.authRepo.GetTokenByUUID(uuid)
			if err != nil {
				return nil, err
			}

			if tokenStr != token {
				return nil, errors.New("the token in the database doesn't match")
			}

			return a.jwtConfig.KeyRefresh, nil
		},
	)
	if err != nil {
		return model.Token{}, err
	}

	if !jwtToken.Valid {
		return model.Token{}, model.ErrDonValidToken
	}

	sub, err := jwtToken.Claims.GetSubject()
	if err != nil {
		return model.Token{}, err
	}

	userID, err := strconv.Atoi(sub)
	if err != nil {
		return model.Token{}, err
	}

	user, err := a.userRepo.GetByID(userID)
	if err != nil {
		return model.Token{}, err
	}

	now := time.Now()

	tokenA, err := a.newToken(
		user.AccessRole,
		now.Add(time.Second*time.Duration(a.jwtConfig.ExpiredAccess)).Unix(),
		"",
		now.Unix(),
		iss,
		now.Unix(),
		strconv.Itoa(user.ID),
	)
	if err != nil {
		return model.Token{}, err
	}

	uuid := uuid.New().String()

	tokenR, err := a.newToken(
		user.AccessRole,
		now.Add(time.Second*time.Duration(a.jwtConfig.ExpiredRefresh)).Unix(),
		uuid,
		now.Unix(),
		iss,
		now.Unix(),
		strconv.Itoa(user.ID),
	)
	if err != nil {
		return model.Token{}, err
	}

	if err := a.authRepo.DeleteTokenByUUID(oldUUID); err != nil {
		return model.Token{}, err
	}

	//сохранить в базе, удаояется при рефреш операции
	if err := a.authRepo.SaveToken(user.ID, uuid, tokenR); err != nil {
		return model.Token{}, err
	}

	return model.Token{
		Access:  tokenA,
		Refresh: tokenR,
	}, nil
}

func (a *auth) AccessRole(ctx context.Context, token, role string) (model.Token, error) {
	// добавить owner роль
	user, err := a.VerifyToken(token)
	if err != nil {
		return model.Token{}, err
	}

	switch role {
	case model.ROLE_DRIVER:
		// if _, err = a.docDriver.GetDriverByUserID(model.DriverLicense{UserID: user.ID}); err != nil {
		// 	if errors.Is(err, gorm.ErrRecordNotFound) {
		// 		return model.Token{}, errors.New("access denied")
		// 	}

		// 	return model.Token{}, err
		// }
	case model.ROLE_OWNER:
		_, err := a.ownerRepo.GetByID(user.ID)
		if err != nil {
			if errors.Is(err, model.ErrNotFound) {
				return model.Token{}, errors.New("access denied")
			}
			return model.Token{}, err
		}
	}

	oldUUID, err := a.authRepo.GetUUIDByUserID(user.ID)
	if err != nil {
		return model.Token{}, err
	}

	tokenA, err := a.newToken(
		role,
		time.Now().Add(time.Second*time.Duration(a.jwtConfig.ExpiredAccess)).Unix(),
		"",
		time.Now().Unix(),
		iss,
		time.Now().Unix(),
		strconv.Itoa(user.ID),
	)
	if err != nil {
		return model.Token{}, err
	}

	uuid := uuid.New().String()

	tokenR, err := a.newToken(
		role,
		time.Now().Add(time.Second*time.Duration(a.jwtConfig.ExpiredRefresh)).Unix(),
		uuid,
		time.Now().Unix(),
		iss,
		time.Now().Unix(),
		strconv.Itoa(user.ID),
	)
	if err != nil {
		return model.Token{}, err
	}

	user.AccessRole = role

	if err := a.authRepo.DeleteTokenByUUID(oldUUID); err != nil {
		return model.Token{}, err
	}

	//сохранить в базе, удаояется при рефреш операции
	if err = a.authRepo.SaveToken(user.ID, uuid, tokenR); err != nil {
		return model.Token{}, err
	}

	if err = a.userRepo.UpdateAccessRole(user); err != nil {
		return model.Token{}, err
	}

	return model.Token{
		Access:  tokenA,
		Refresh: tokenR,
	}, nil
}

func (a *auth) SignOut() {}

func (a *auth) AdminSignIn(signin model.SignIn) (model.Token, error) {
	// PhoneNumber вместо логина
	adminOld, err := a.userRepo.GetByPhoneNumber(signin.PhoneNumber)
	if err != nil {
		return model.Token{}, err
	}

	if err := bcrypt.CompareHashAndPassword([]byte(adminOld.Password), []byte(signin.Password)); err != nil {
		if errors.Is(err, bcrypt.ErrMismatchedHashAndPassword) {
			return model.Token{}, model.ErrPasswordDontMatch
		}
		return model.Token{}, err
	}

	now := time.Now()

	tokenA, err := a.newToken(
		model.ROLE_ADMIN,
		now.Add(time.Second*time.Duration(a.jwtConfig.ExpiredAccess)).Unix(),
		"",
		now.Unix(),
		iss,
		now.Unix(),
		strconv.Itoa(adminOld.ID),
	)
	if err != nil {
		return model.Token{}, err
	}

	uuid := uuid.New().String()

	tokenR, err := a.newToken(
		model.ROLE_ADMIN,
		now.Add(time.Second*time.Duration(a.jwtConfig.ExpiredRefresh)).Unix(),
		uuid,
		now.Unix(),
		iss,
		now.Unix(),
		strconv.Itoa(adminOld.ID),
	)
	if err != nil {
		return model.Token{}, err
	}

	if err := a.authRepo.SaveToken(1, uuid, tokenR); err != nil {
		return model.Token{}, err
	}

	return model.Token{
		Access:  tokenA,
		Refresh: tokenR,
	}, nil
}

func (a *auth) SendCode(input model.SendCode) error {
	user, err := a.userRepo.GetByPhoneNumber(input.PhoneNumber)
	if err != nil {
		if !errors.Is(err, model.ErrNotFound) {
			return fmt.Errorf("send code - get by phone number - error %v", err)
		}
	}
	if user.ID != 0 {
		return model.ErrUserExists
	}

	//lastCodeTime, err := a.userRepo.CheckLastCodeTime(input.PhoneNumber)
	//if err != nil {
	//	return fmt.Errorf("check last code time %v", err)
	//}
	//
	//lastCodeTimeInFixedZone := time.Date(
	//	lastCodeTime.Year(), lastCodeTime.Month(), lastCodeTime.Day(),
	//	lastCodeTime.Hour(), lastCodeTime.Minute(), lastCodeTime.Second(),
	//	lastCodeTime.Nanosecond(), util.TimeZone)
	//
	//if time.Since(lastCodeTimeInFixedZone) < time.Hour {
	//	return errors.New("too many tries, please try again later")
	//}

	code := util.GenerateConfirmationCode()

	if a.smsConfig.IsSMSMock {
		code = 111111
	} else {
		message := fmt.Sprintf(sms.SendAuthCodeSMSMessage, code)
		err = a.sms.SendSingle(input.PhoneNumber, message)
		if err != nil {
			return fmt.Errorf("%w: %v", model.SmsError, err)
		}
	}

	err = a.userRepo.SaveCode(input.PhoneNumber, code)
	if err != nil {
		return fmt.Errorf("send code - save code %v", err)
	}

	return nil
}

func (a *auth) ConfirmCode(input model.ConfirmCode) error {
	userCode, err := a.userRepo.GetCode(input.PhoneNumber)
	if err != nil {
		return fmt.Errorf("confirm code %v", err)
	}

	if time.Since(userCode.CreatedAt) > time.Hour {
		return model.CodeExpired
	}

	if userCode.Code != input.Code {
		return model.CodeMismatch
	}

	return nil
}

// ---- helper

func hashPassword(password string) (string, error) {
	hashedPassword, err := bcrypt.GenerateFromPassword([]byte(password), bcrypt.DefaultCost)
	if err != nil {
		return "", err
	}
	return string(hashedPassword), nil
}
