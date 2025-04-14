package repository

import (
	"context"
	"fmt"
	"log"

	"gitlab.com/eqshare/eqshare-back/model"
	"gorm.io/gorm"
)

type Search interface {
	// Search(ctx context.Context, f model.FilterSearch) (model.SearchSMResult, error)
	CategoryaSM(ctx context.Context, general string) ([]model.SubCategory, error)
	CategoryaEQ(ctx context.Context, general string) ([]model.EquipmentCategory, error)
	AdSpecializedMachinerie(ctx context.Context, f model.FilterSearch) ([]model.AdSpecializedMachinery, error)
	AdClient(ctx context.Context, f model.FilterSearch) ([]model.AdClient, error)
	AdEquipment(ctx context.Context, f model.FilterSearch) ([]model.AdEquipment, error)
	AdEquipmentClient(ctx context.Context, f model.FilterSearch) ([]model.AdEquipmentClient, error)
}

type search struct {
	db *gorm.DB
}

func NewSearch(db *gorm.DB) *search {
	return &search{db: db}
}

func (repo *search) CategoryaSM(ctx context.Context, general string) ([]model.SubCategory, error) {
	c := make([]model.SubCategory, 0)
	g := make([]model.Type, 0)

	stmt := repo.db.
		Where("name ilike '%' || ? || '%' ", general).
		Or(`id in (SELECT DISTINCT type_id
			FROM type_aliases
			WHERE alias_id = (SELECT id
			FROM aliases
			WHERE name ILIKE '%' || ? || '%' ))`, general).
		Preload("Params").
		Preload("Documents").
		Find(&g)
	if err := stmt.Error; err != nil {
		return nil, fmt.Errorf("repository search: CategoryaSM: err: %w", err)
	}

	connector := make(map[int][]model.Type, 0)
	tIDs := make([]int, 0, len(g))

	for _, v := range g {
		tIDs = append(tIDs, v.SubCategoryID)
		connector[v.SubCategoryID] = append(connector[v.SubCategoryID], v)

	}

	stmt = repo.db.Where("name ilike '%' || ? || '%'  ", general).Or("id in (?)", tIDs).Preload("Documents").Find(&c)
	if err := stmt.Error; err != nil {
		return nil, fmt.Errorf("repository search: CategoryaSM: err: %w", err)
	}

	for i, v := range c {
		temp := connector[v.ID]
		r := make([]model.Type, len(temp))
		copy(r, temp)

		c[i].Types = r
	}

	return c, nil
}

func (repo *search) CategoryaEQ(ctx context.Context, general string) ([]model.EquipmentCategory, error) {
	c := make([]model.EquipmentCategory, 0)
	g := make([]model.EquipmentSubCategory, 0)

	stmt := repo.db.
		Where("name ilike '%' || ? || '%' ", general).
		Preload("Documents").
		Or(`id in (SELECT DISTINCT equipment_sub_category_id
			FROM equipment_sub_categories_aliases
			WHERE alias_id = (SELECT id
			FROM aliases
			WHERE name ILIKE '%' || ? || '%' ))`, general).
		Find(&g)
	if err := stmt.Error; err != nil {
		return nil, fmt.Errorf("repository search: CategoryaEQ: Find EquipmentSubCategory: err: %w", err)
	}

	connector := make(map[int][]model.EquipmentSubCategory, 0)
	tIDs := make([]int, 0, len(g))

	for _, v := range g {
		tIDs = append(tIDs, v.EquipmentCategoriesID)
		connector[v.EquipmentCategoriesID] = append(connector[v.EquipmentCategoriesID], v)
	}

	stmt = repo.db.Preload("Documents").Where("name ilike '%' || ? || '%'  ", general).Or("id in (?)", tIDs).Find(&c)
	if err := stmt.Error; err != nil {
		return nil, fmt.Errorf("repository search: CategoryaEQ: Find EquipmentCategory: err: %w", err)
	}

	for i, v := range c {
		temp := connector[v.ID]
		r := make([]model.EquipmentSubCategory, len(temp))
		copy(r, temp)

		c[i].EquipmentSubCategories = r
	}

	return c, nil
}

func (repo *search) AdSpecializedMachinerie(ctx context.Context, f model.FilterSearch) ([]model.AdSpecializedMachinery, error) {
	ads := make([]model.AdSpecializedMachinery, 0)

	stmt := repo.db.WithContext(ctx).Preload("Document")

	if f.Limit != nil {
		stmt = stmt.Limit(*f.Limit)
		log.Println("AdSpecializedMachinerie")

		log.Println(*f.Limit)
	} else {
		stmt = stmt.Limit(15)
	}

	if f.Offset != nil {
		stmt = stmt.Offset(*f.Offset)
	}

	if f.CityID != nil && *f.CityID != 92 {
		stmt = stmt.Where("city_id = ?", f.CityID)
	}

	stmt = stmt.Where("name ilike '%' || ? || '%'", f.General)

	stmt = stmt.Find(&ads)
	if stmt.Error != nil {
		return nil, fmt.Errorf("repository AdSpecializedMachinerie: err: %w", stmt.Error)

	}

	return ads, nil
}

func (repo *search) AdClient(ctx context.Context, f model.FilterSearch) ([]model.AdClient, error) {
	ads := make([]model.AdClient, 0)

	stmt := repo.db.WithContext(ctx).Preload("Documents")

	if f.Limit != nil {
		stmt = stmt.Limit(*f.Limit)
		log.Println("AdClient")

		log.Println(*f.Limit)
	} else {
		stmt = stmt.Limit(15)
	}

	if f.Offset != nil {
		stmt = stmt.Offset(*f.Offset)
	}

	if f.CityID != nil && *f.CityID != 92 {
		stmt = stmt.Where("city_id = ?", f.CityID)
	}

	stmt = stmt.Where("headline ilike '%' || ? || '%'", f.General)

	stmt = stmt.Find(&ads)
	if stmt.Error != nil {
		return nil, fmt.Errorf("repository AdClient: err: %w", stmt.Error)

	}

	return ads, nil
}

func (repo *search) AdEquipment(ctx context.Context, f model.FilterSearch) ([]model.AdEquipment, error) {
	ads := make([]model.AdEquipment, 0)

	stmt := repo.db.WithContext(ctx).Preload("Documents")

	if f.Limit != nil {
		stmt = stmt.Limit(*f.Limit)
		log.Println("AdEquipment")

		log.Println(*f.Limit)
	} else {
		stmt = stmt.Limit(15)
	}

	if f.Offset != nil {
		stmt = stmt.Offset(*f.Offset)
	}

	if f.CityID != nil && *f.CityID != 92 {
		stmt = stmt.Where("city_id = ?", f.CityID)
	}

	stmt = stmt.Where("title ilike '%' || ? || '%'", f.General)

	stmt = stmt.Find(&ads)
	if stmt.Error != nil {
		return nil, fmt.Errorf("repository AdEquipment: err: %w", stmt.Error)

	}

	return ads, nil
}

func (repo *search) AdEquipmentClient(ctx context.Context, f model.FilterSearch) ([]model.AdEquipmentClient, error) {
	ads := make([]model.AdEquipmentClient, 0)

	stmt := repo.db.WithContext(ctx).Preload("Documents")

	if f.Limit != nil {
		stmt = stmt.Limit(*f.Limit)
		log.Println("AdEquipmentClient")

		log.Println(*f.Limit)
	} else {
		stmt = stmt.Limit(15)
	}

	if f.Offset != nil {
		stmt = stmt.Offset(*f.Offset)
	}

	if f.CityID != nil && *f.CityID != 92 {
		stmt = stmt.Where("city_id = ?", f.CityID)
	}

	stmt = stmt.Where("title ilike '%' || ? || '%'", f.General)

	stmt = stmt.Find(&ads)
	if stmt.Error != nil {
		return nil, fmt.Errorf("repository AdEquipmentClient: err: %w", stmt.Error)

	}

	return ads, nil
}
