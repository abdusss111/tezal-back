package model

import "errors"

var (
	ErrNotFound          = errors.New("not found")
	ErrDeleted           = errors.New("deleted")
	ErrDonValidToken     = errors.New("dont valid token")
	ErrPasswordDontMatch = errors.New("password doesn't match")
	ErrClaimDontCast     = errors.New("claim dont cast")
	ErrInvalidTimeRange  = errors.New("invalid time range")
	ErrInvalidStatus     = errors.New("invalid status")
	ErrUserExists        = errors.New("user exists")
	ErrAccessDenied      = errors.New("access denied")
	ErrHaveOwner         = errors.New("worker have owner")
	ErrCreatingYourAd     = errors.New("creating an request for your ad")
)
