package service

import (
	"context"
	"strings"
	"time"

	"gitlab.com/eqshare/eqshare-back/internal/client"
	"gitlab.com/eqshare/eqshare-back/internal/elastic"
	"gitlab.com/eqshare/eqshare-back/internal/repository"
	"gitlab.com/eqshare/eqshare-back/model"
)

type ISubCategoryService interface {
	Create(ctx context.Context, sb model.SubCategory) error
	Get(ctx context.Context, sb model.SubCategory) (model.SubCategory, error)
	GetList(ctx context.Context) ([]model.SubCategory, error)
	Update(ctx context.Context, sb model.SubCategory) (model.SubCategory, error)
	Delete(ctx context.Context, sb model.SubCategory) error
	BindAlias(ctx context.Context, sb model.SubCategory) error
	UpdateAlias(ctx context.Context, sb model.SubCategory) error
	FindCategories(ctx context.Context, sb []model.SubCategory, query string) ([]model.ShortCategories, error)
}

type sbService struct {
	repo            repository.ISubCategory
	repoSubCategory repository.IType
	cloud           client.DocumentsRemote
	adSM            repository.IAdSpecializedMachinery
	elastic         elastic.ICategorySm
}

func NewSubCategoryService(repo repository.ISubCategory, cloud client.DocumentsRemote,
	repoSubCategory repository.IType, adSM repository.IAdSpecializedMachinery, elastic elastic.ICategorySm) *sbService {
	return &sbService{
		repo:            repo,
		cloud:           cloud,
		repoSubCategory: repoSubCategory,
		adSM:            adSM,
		elastic:         elastic,
	}
}

func (s *sbService) Create(ctx context.Context, sb model.SubCategory) error {
	id, err := s.repo.Create(sb)
	if err != nil {
		return err
	}

	for i := range sb.Documents {
		doc, err := s.cloud.Upload(ctx, sb.Documents[i])
		if err != nil {
			return err
		}

		sb.Documents[i] = doc
	}

	{
		sb, err := s.repo.GetByID(ctx, id)
		if err != nil {
			return err
		}

		err = s.elastic.Create(ctx, sb)
		if err != nil {
			return err
		}
	}

	return nil
}

func (s *sbService) Get(ctx context.Context, sb model.SubCategory) (model.SubCategory, error) {
	sb, err := s.repo.Get(sb)
	if err != nil {
		return sb, err
	}

	for i := range sb.Documents {
		sb.Documents[i], err = s.cloud.Share(ctx, sb.Documents[i], time.Hour)
		if err != nil {
			return sb, err
		}
	}
	return sb, nil
}

func (s *sbService) Update(ctx context.Context, sb model.SubCategory) (model.SubCategory, error) {
	sb, err := s.repo.Update(sb)
	if err != nil {
		return sb, err
	}

	for i := range sb.Documents {
		sb.Documents[i], err = s.cloud.Delete(ctx, sb.Documents[i])
		if err != nil {
			return sb, err
		}
	}

	for i := range sb.Documents {
		sb.Documents[i], err = s.cloud.Upload(ctx, sb.Documents[i])
		if err != nil {
			return sb, err
		}
	}

	err = s.elastic.Update(ctx, sb)
	if err != nil {
		return sb, err
	}

	return sb, nil
}

func (s *sbService) Delete(ctx context.Context, sb model.SubCategory) (err error) {
	if err = s.repo.Delete(sb); err != nil {
		return err
	}

	for i := range sb.Documents {
		sb.Documents[i], err = s.cloud.Delete(ctx, sb.Documents[i])
		if err != nil {
			return err
		}
	}

	err = s.elastic.Delete(ctx, sb.ID)
	if err != nil {
		return err
	}

	return nil
}

func (s *sbService) GetList(ctx context.Context) (sbs []model.SubCategory, err error) {
	sbs, err = s.repo.GetList()
	if err != nil {
		return sbs, err
	}

	for i := range sbs {
		for j := range sbs[i].Documents {
			sbs[i].Documents[j], err = s.cloud.Share(ctx, sbs[i].Documents[j], time.Hour)
			if err != nil {
				return sbs, err
			}
		}
	}

	//  Тут s *sbService правильный
	//for _, d := range sbs {
	//	err := s.elastic.Update(context.Background(), d)
	//	if err != nil {
	//		return nil, err
	//	}
	//}

	return sbs, nil
}

func (s *sbService) FindCategories(ctx context.Context, sb []model.SubCategory, query string) (shorts []model.ShortCategories, err error) {
	findWord := strings.ToLower(query)
	baseFilter := model.FilterAdSpecializedMachinery{}

	for i := range sb {
		var shortCategory model.ShortCategories
		shortCategory.Name = sb[i].Name
		shortCategory.ID = sb[i].ID

		// Get subcategories for the current category.
		subCategories, err := s.repoSubCategory.GetList(model.Type{SubCategoryID: sb[i].ID})
		if err != nil {
			return shorts, err
		}

		categoryMatched := false

		for j := range subCategories {
			// Create a temporary filter that selects items with TypeID equal to this subcategory's ID.
			tempFilter := baseFilter
			tempFilter.TypeID = &subCategories[j].ID

			// Now correctly call Get using the context.
			// (Assuming s.adSM.Get(ctx, filter) returns a slice of specialized machinery.)
			sm, _, err := s.adSM.Get(ctx, tempFilter)
			if err != nil {
				return shorts, err
			}

			shortSubCategory := model.ShortSubCategories{
				ID:   subCategories[j].ID,
				Name: subCategories[j].Name,
			}

			// Check each specialized machinery record.
			for k := range sm {
				smWord := strings.ToLower(sm[k].Name)
				if strings.Contains(smWord, findWord) {
					shortSubCategory.SpecializedMachinery = append(shortSubCategory.SpecializedMachinery, sm[k])
					categoryMatched = true
				}
			}

			if categoryMatched || strings.Contains(strings.ToLower(subCategories[j].Name), findWord) {
				shortCategory.SubCategories = append(shortCategory.SubCategories, shortSubCategory)
			}
		}

		if categoryMatched || strings.Contains(strings.ToLower(shortCategory.Name), findWord) {
			shorts = append(shorts, shortCategory)
		}
	}

	return shorts, nil
}

func (s *sbService) BindAlias(ctx context.Context, sb model.SubCategory) error {
	return s.repo.BindAlias(sb)
}

func (s *sbService) UpdateAlias(ctx context.Context, sb model.SubCategory) error {
	return s.repo.UpdateAlias(sb)
}
