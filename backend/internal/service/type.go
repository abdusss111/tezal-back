package service

import (
	"context"
	"errors"
	"time"

	"gitlab.com/eqshare/eqshare-back/internal/client"
	"gitlab.com/eqshare/eqshare-back/internal/elastic"
	"gitlab.com/eqshare/eqshare-back/internal/repository"
	"gitlab.com/eqshare/eqshare-back/model"
	"gorm.io/gorm"
)

type IType interface {
	Get(f model.FilterType) ([]model.Type, error)
	CreateCategory(ctx context.Context, ct model.Type) (model.Type, error)
	Update(ctx context.Context, ct model.Type) (model.Type, error)
	DeleteByID(ctx context.Context, ct model.Type) error
	GetCategoryByID(ctx context.Context, ct model.Type) (model.Type, error)
	GetListCategory(ctx context.Context, ct model.Type) ([]model.Type, error)
	SetParamSubCategory(ctx context.Context, tps []model.TypesParams) error
	DeleteParamSubCategory(ctx context.Context, tps model.TypesParams) error
	BindAlias(ctx context.Context, ct model.Type) error
	UpdateAlias(ctx context.Context, ct model.Type) error
}

type typeSM struct {
	repo            repository.IType
	docRepo         repository.IDocument
	remoteRepo      client.DocumentsRemote
	repoTypeParam   repository.ITypeParams
	subCategoryRepo repository.ISubCategory
	elastic         elastic.ICategorySm
}

func NewType(repo repository.IType,
	docRepo repository.IDocument,
	remoteRepo client.DocumentsRemote,
	repoTypeParam repository.ITypeParams,
	subCategoryRepo repository.ISubCategory,
	elastic elastic.ICategorySm) *typeSM {
	return &typeSM{
		repo:            repo,
		docRepo:         docRepo,
		remoteRepo:      remoteRepo,
		repoTypeParam:   repoTypeParam,
		subCategoryRepo: subCategoryRepo,
		elastic:         elastic,
	}
}

func (t *typeSM) Get(f model.FilterType) ([]model.Type, error) {

	cts, err := t.repo.Get(f)
	if err != nil {
		return nil, err
	}

	// t *typeSM надо поменять!!!!!!!!
	// стоит не тот elastic interface
	// should be elastic  typeof elastic.ISubCategorySm

	//logrus.Infof("Total %d", len(cts))
	//for _, d := range cts {
	//	logrus.Info("sub category: ", d.Name, d.SubCategoryID)
	//
	//	err := t.elastic.Update1(context.Background(), d)
	//	if err != nil {
	//		return nil, err
	//	}
	//}

	return cts, nil
}

func (t *typeSM) CreateCategory(ctx context.Context, ct model.Type) (model.Type, error) {
	ct, err := t.repo.Create(ct)
	if err != nil {
		return ct, err
	}

	for i, document := range ct.Documents {
		document.UserID = ct.UserID
		ct.Documents[i], err = t.remoteRepo.Upload(ctx, document)
		if err != nil {
			return ct, err
		}
	}

	sb, err := t.subCategoryRepo.GetByID(ctx, ct.SubCategoryID)
	if err != nil {
		return ct, err
	}

	err = t.elastic.Update(ctx, sb)
	if err != nil {
		return ct, err
	}

	return ct, nil
}

func (t *typeSM) GetCategoryByID(ctx context.Context, ct model.Type) (model.Type, error) {
	stored, err := t.repo.GetByID(ct)
	if err != nil {
		return ct, err
	}

	for i := range stored.Documents {
		stored.Documents[i], err = t.remoteRepo.Share(ctx, stored.Documents[i], time.Hour)
		if err != nil {
			return ct, err
		}
	}

	return stored, nil
}

func (t *typeSM) GetListCategory(ctx context.Context, ct model.Type) ([]model.Type, error) {
	cts, err := t.repo.GetList(ct)
	if err != nil {
		return cts, err
	}

	for i := range cts {
		for j := range cts[i].Documents {
			cts[i].Documents[j], err = t.remoteRepo.Share(ctx, cts[i].Documents[j], time.Hour*1)
			if err != nil {
				return cts, err
			}
		}
	}

	return cts, nil
}

func (t *typeSM) Update(ctx context.Context, ct model.Type) (cts model.Type, err error) {
	ct, err = t.repo.Update(ct)
	if err != nil {
		return ct, err
	}

	for i := range ct.Documents {
		ct.Documents[i], err = t.remoteRepo.Delete(ctx, ct.Documents[i])
		if err != nil {
			return ct, err
		}
	}

	for i := range ct.Documents {
		ct.Documents[i], err = t.remoteRepo.Upload(ctx, ct.Documents[i])
		if err != nil {
			return ct, err
		}
	}

	sb, err := t.subCategoryRepo.GetByID(ctx, ct.SubCategoryID)
	if err != nil {
		return ct, err
	}

	err = t.elastic.Update(ctx, sb)
	if err != nil {
		return ct, err
	}

	return ct, nil
}

func (t *typeSM) DeleteByID(ctx context.Context, ct model.Type) (err error) {
	if err = t.repo.Delete(ct); err != nil {
		return err
	}

	if err = t.docRepo.Delete(ctx, ct.Documents); err != nil && !errors.Is(err, gorm.ErrRecordNotFound) {
		return err
	}

	sb, err := t.subCategoryRepo.GetByID(ctx, ct.SubCategoryID)
	if err != nil {
		return err
	}

	err = t.elastic.Update(ctx, sb)
	if err != nil {
		return err
	}

	return nil
}

func (tp *typeSM) SetParamSubCategory(ctx context.Context, tps []model.TypesParams) error {
	if len(tps) == 0 {
		return nil
	}
	return tp.repoTypeParam.Set(ctx, tps)
}

func (tp *typeSM) DeleteParamSubCategory(ctx context.Context, tps model.TypesParams) error {
	return tp.repoTypeParam.Delete(ctx, tps)
}

func (tp *typeSM) BindAlias(ctx context.Context, ct model.Type) error {
	return tp.repo.BindAlias(ct)
}

func (tp *typeSM) UpdateAlias(ctx context.Context, ct model.Type) error {
	return tp.repo.UpdateAlias(ct)
}
