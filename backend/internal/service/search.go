package service

import (
	"context"
	"errors"
	"fmt"

	"sync"
	"time"

	"github.com/sirupsen/logrus"
	client2 "gitlab.com/eqshare/eqshare-back/internal/client"
	"gitlab.com/eqshare/eqshare-back/internal/elastic"
	"gitlab.com/eqshare/eqshare-back/internal/repository"
	"gitlab.com/eqshare/eqshare-back/model"
)

type ISearch interface {
	Find(ctx context.Context, f model.FilterSearch, queryFilters []map[string]interface{}) (model.SearchSMResult, []error)
}

type search struct {
	searchR                repository.Search
	remotes                client2.DocumentsRemote
	adEqElastic            elastic.IAdEquipment
	adEqClientElastic      elastic.IAdEquipmentClient
	adCMElastic            elastic.IAdConstructionMaterial
	adCMClientElastic      elastic.IAdConstructionMaterialClient
	adService              elastic.IAdService
	adServiceClientElastic elastic.IAdServiceClient
	adsmClientElastic      elastic.IAdSpecializedMachineryClient
	adsmElastic            elastic.IAdSpecializedMachinery
	categoryaEq            elastic.ICategoryEq
	subCategoryaEq         elastic.ISubCategoryEq
	categoryaSm            elastic.ICategorySm
	subCategoryaSm         elastic.ISubCategorySm
	documentRepository     repository.IDocument
}

func NewSearch(
	searchR repository.Search,
	remotes client2.DocumentsRemote,
	adEqElastic elastic.IAdEquipment,
	adEqClientElastic elastic.IAdEquipmentClient,
	adsmClientElastic elastic.IAdSpecializedMachineryClient,
	adsmElastic elastic.IAdSpecializedMachinery,
	adCMElastic elastic.IAdConstructionMaterial,
	adCMClientElastic elastic.IAdConstructionMaterialClient,
	categoryaEq elastic.ICategoryEq,
	categoryaSm elastic.ICategorySm,
	subCategoryaEq elastic.ISubCategoryEq,
	subCategoryaSm elastic.ISubCategorySm,
	adServiceElastic elastic.IAdService,
	adServiceClientElastic elastic.IAdServiceClient,
	documentRepository repository.IDocument,

) *search {
	return &search{
		searchR:                searchR,
		remotes:                remotes,
		adEqElastic:            adEqElastic,
		adEqClientElastic:      adEqClientElastic,
		adsmClientElastic:      adsmClientElastic,
		adCMElastic:            adCMElastic,
		adCMClientElastic:      adCMClientElastic,
		adsmElastic:            adsmElastic,
		categoryaEq:            categoryaEq,
		categoryaSm:            categoryaSm,
		subCategoryaEq:         subCategoryaEq,
		subCategoryaSm:         subCategoryaSm,
		adService:              adServiceElastic,
		adServiceClientElastic: adServiceClientElastic,
		documentRepository:     documentRepository,
	}
}

func (service *search) Find(ctx context.Context, f model.FilterSearch, queryFilters []map[string]interface{}) (model.SearchSMResult, []error) {
	if f.General == "" {
		return model.SearchSMResult{}, nil
	}
	logrus.Infof("filterLimit: %+v", *f.Limit)

	logrus.Infof("filter: %+v", f)

	res := model.SearchSMResult{}
	errCh := make(chan error, 40)

	wg := sync.WaitGroup{}

	if f.CategorySmDetail == nil || (f.CategorySmDetail != nil && *f.CategorySmDetail) {
		logrus.Info("hii")
		wg.Add(1)
		go func() {
			defer wg.Done()
			wgIn := sync.WaitGroup{}

			adEqClientCountCh := make(chan map[int]int, 1)
			adEqCountCh := make(chan map[int]int, 1)
			errChIn := make(chan error, 2)

			wgIn.Add(2)

			go func() {
				defer wgIn.Done()
				count, err := service.adsmClientElastic.CountBySubCategoryID(ctx)
				if err != nil {
					adEqClientCountCh <- nil
					errChIn <- fmt.Errorf("service searchhhhhhhh: CategoryaEQ: err: %w", err)
					return
				}
				adEqClientCountCh <- count
			}()

			go func() {
				defer wgIn.Done()
				count, err := service.adsmElastic.CountByTypeID(ctx)
				if err != nil {
					adEqCountCh <- nil
					errChIn <- fmt.Errorf("service searchaaaaaaa: CategoryaEQ: err: %w", err)
					return
				}
				adEqCountCh <- count
			}()

			wgIn.Wait()
			close(errChIn)

			for err := range errChIn {
				if err != nil {
					errCh <- err
				}
			}

			adEqClientSubCategoryCounts := <-adEqClientCountCh
			adEqSubCategoryCounts := <-adEqCountCh

			if adEqClientSubCategoryCounts == nil {
				errCh <- fmt.Errorf("service searchccccc: CategoryaEQ: err: %w", errors.New("cant find count by sub category id"))
				return
			}
			if adEqSubCategoryCounts == nil {
				errCh <- fmt.Errorf("service searchqqqqqq: CategoryaEQ: err: %w", errors.New("cant find count by sub category id"))
				return
			}

			// тут надо получить сперва дочерние категории, example: 1)Автовоз; 2)Эвакутор машина и тд
			subCategories, err := service.subCategoryaSm.SearchSimple(ctx, f.General)

			if err != nil {
				errCh <- fmt.Errorf("service searchllllll: CategoryaEQ: err: %w", err) // 1 error
				return
			}

			for _, sb := range subCategories {
				logrus.Info(sb.SubCategoryID, "subCategories", sb.ID)
			}

			categoryFindID := make(map[int][]model.Type, 0)

			for _, sb := range subCategories {
				categoryFindID[sb.SubCategoryID] = append(categoryFindID[sb.SubCategoryID], sb)
			}

			uniqIDs := make([]int, 0)

			for id := range categoryFindID {
				uniqIDs = append(uniqIDs, id)
			}

			//categories, err := service.searchR.CategoryaSM(ctx, f.General)
			categories, err := service.categoryaSm.SearchSimple(ctx, f.General, uniqIDs)
			if err != nil {
				errCh <- fmt.Errorf("service searchuuuuu: CategoryaSM: err: %w", err)
				return
			}

			for i, cat := range categories {
				subCat, ok := categoryFindID[cat.ID]
				if ok {
					categories[i].Types = subCat
				}
			}

			for i, c := range categories {
				categories[i].UrlDocument = make([]string, 0, len(c.Documents))
				for _, d := range c.Documents {
					d, err = service.remotes.Share(ctx, d, time.Hour)
					if err != nil {
						errCh <- fmt.Errorf("service search: CategoryaSM: err: %w", err)
						return
					}
					categories[i].UrlDocument = append(categories[i].UrlDocument, d.ShareLink)
				}

				var (
					adEqSubCategorySumCount        int
					adEqClientSubCategoryCSumounts int
				)

				for j, t := range c.Types {
					categories[i].Types[j].UrlDocument = make([]string, 0, len(t.Documents))
					for _, d := range t.Documents {
						d, err = service.remotes.Share(ctx, d, time.Hour)
						if err != nil {
							errCh <- fmt.Errorf("service search: CategoryaSM: err: %w", err)
							return
						}
						categories[i].Types[j].UrlDocument = append(categories[i].Types[j].UrlDocument, d.ShareLink)
					}
					adEqSubCategoryCount := adEqSubCategoryCounts[t.ID]
					categories[i].Types[j].CountAd = &adEqSubCategoryCount
					adEqSubCategorySumCount += adEqSubCategoryCount

					adEqClientSubCategoryCounts := adEqClientSubCategoryCounts[t.ID]
					categories[i].Types[j].CountAdClinet = &adEqClientSubCategoryCounts
					adEqClientSubCategoryCSumounts += adEqClientSubCategoryCounts
				}

				categories[i].CountAd = &adEqSubCategorySumCount
				categories[i].CountAdClinet = &adEqClientSubCategoryCSumounts
			}

			res.SubCategories = categories
		}()
	}

	if f.CategoryEqDetail == nil || (f.CategoryEqDetail != nil && *f.CategoryEqDetail) {
		wg.Add(1)
		go func() {
			defer wg.Done()
			wgIn := sync.WaitGroup{}

			adEqClientCountCh := make(chan map[int]int, 1)
			adEqCountCh := make(chan map[int]int, 1)

			wgIn.Add(2)

			go func() {
				defer wgIn.Done()
				count, err := service.adEqClientElastic.CountBySubCategoryID(ctx)
				if err != nil {
					adEqClientCountCh <- nil
					errCh <- fmt.Errorf("service search: CategoryaEQ: err: %w", err)
					return
				}
				adEqClientCountCh <- count
			}()

			go func() {
				defer wgIn.Done()
				count, err := service.adEqElastic.CountBySubCategoryID(ctx)
				if err != nil {
					adEqCountCh <- nil
					errCh <- fmt.Errorf("service search: CategoryaEQ: err: %w", err)
					return
				}
				adEqCountCh <- count
			}()

			wgIn.Wait()

			adEqClientSubCategoryCounts := <-adEqClientCountCh
			adEqSubCategoryCounts := <-adEqCountCh

			if adEqClientSubCategoryCounts == nil {
				errCh <- fmt.Errorf("service search: CategoryaEQ: err: %w", errors.New("cant find count by sub category id"))
				return
			}
			if adEqSubCategoryCounts == nil {
				errCh <- fmt.Errorf("service search: CategoryaEQ: err: %w", errors.New("cant find count by sub category id"))
				return
			}

			subCategories, err := service.subCategoryaEq.SearchSimple(ctx, f.General)
			if err != nil {
				errCh <- fmt.Errorf("service searchllllll: CategoryaEQ: err: %w", err)
				return
			}

			categoryFindID := make(map[int][]model.EquipmentSubCategory, 0)

			for _, sb := range subCategories {
				categoryFindID[sb.EquipmentCategoriesID] = append(categoryFindID[sb.EquipmentCategoriesID], sb)
			}

			uniqIDs := make([]int, 0)

			for id := range categoryFindID {
				uniqIDs = append(uniqIDs, id)
			}

			categories, err := service.categoryaEq.SearchSimple(ctx, f.General, uniqIDs)
			if err != nil {
				errCh <- fmt.Errorf("service search: CategoryaEQ: err: %w", err)
				return
			}

			for i, cat := range categories {
				subCat, ok := categoryFindID[cat.ID]
				if ok {
					categories[i].EquipmentSubCategories = subCat
				}
			}

			for i, c := range categories {
				categories[i].UrlDocuments = make([]string, 0, len(c.Documents))
				for _, d := range c.Documents {
					d, err = service.remotes.Share(ctx, d, time.Hour)
					if err != nil {
						errCh <- fmt.Errorf("service search: CategoryaEQ: err: %w", err)
						return
					}
					categories[i].UrlDocuments = append(categories[i].UrlDocuments, d.ShareLink)
				}
				var (
					adEqSubCategorySumCount        int
					adEqClientSubCategoryCSumounts int
				)

				for j, t := range c.EquipmentSubCategories {
					categories[i].EquipmentSubCategories[j].UrlDocuments = make([]string, 0, len(t.Documents))
					for _, d := range t.Documents {
						d, err = service.remotes.Share(ctx, d, time.Hour)
						if err != nil {
							errCh <- fmt.Errorf("service search: CategoryaEQ: err: %w", err)
							return
						}
						categories[i].EquipmentSubCategories[j].UrlDocuments = append(categories[i].EquipmentSubCategories[j].UrlDocuments, d.ShareLink)
					}

					adEqSubCategoryCount := adEqSubCategoryCounts[t.ID]
					categories[i].EquipmentSubCategories[j].CountAd = &adEqSubCategoryCount
					adEqSubCategorySumCount += adEqSubCategoryCount

					adEqClientSubCategoryCounts := adEqClientSubCategoryCounts[t.ID]
					categories[i].EquipmentSubCategories[j].CountAdClinet = &adEqClientSubCategoryCounts
					adEqClientSubCategoryCSumounts += adEqClientSubCategoryCounts
				}

				categories[i].CountAd = &adEqSubCategorySumCount
				categories[i].CountAdClinet = &adEqClientSubCategoryCSumounts
			}

			res.EquipmentCategories = categories
		}()
	}

	if f.AdSpecializedMachineriesDetail == nil || (f.AdSpecializedMachineriesDetail != nil && *f.AdSpecializedMachineriesDetail) {
		wg.Add(1)
		go func() {
			defer wg.Done()
			//ad, err := service.searchR.AdSpecializedMachinerie(ctx, f)
			logrus.Infof("adsmElastic.SearchSimple: %+v", queryFilters)

			ad, err := service.adsmElastic.SearchSimple(ctx, f.General, queryFilters, f)
			if err != nil {
				errCh <- fmt.Errorf("service search: AdSpecializedMachinerie: err: %w", err)
				return
			}

			for i, v := range ad {
				doc, err := service.documentRepository.GetByID(ctx, ad[i].ID, "ad_specialized_machinery")
				if err != nil {
					logrus.Warnf("Document not found for ad ID %d: %v", ad[i].ID, err)

					continue
				}
				d, err := service.remotes.Share(ctx, doc, time.Hour*1)
				if err != nil {
					errCh <- fmt.Errorf("service search: AdSpecializedMachinerie: Share doc: err: %w", err)
					return
				}
				ad[i].UrlDocument = append(v.UrlDocument, d.ShareLink)
			}
			res.AdSpecializedMachineries = ad
		}()
	}
	//done

	if f.AdClientsDetail == nil || (f.AdClientsDetail != nil && *f.AdClientsDetail) {
		wg.Add(1)
		go func() {
			defer wg.Done()
			// ad, err := service.searchR.AdClient(ctx, f)
			// logrus.Infof("adsmClientElastic.SearchSimple: %+v", queryFilters)
			ad, err := service.adsmClientElastic.SearchSimple(ctx, f.General, queryFilters)
			if err != nil {
				errCh <- fmt.Errorf("service search: AdClient: err: %w", err)
				return
			}

			for i, v := range ad {
				doc, err := service.documentRepository.GetByID(ctx, ad[i].ID, "ad_clients")
				if err != nil {
					logrus.Warnf("Document not found for ad ID %d: %v", ad[i].ID, err)
					continue
				}
				d, err := service.remotes.Share(ctx, doc, time.Hour*1)
				if err != nil {
					errCh <- fmt.Errorf("service search: AdSpecializedMachinerie: Share doc: err: %w", err)
					return
				}
				ad[i].UrlDocuments = append(v.UrlDocuments, d.ShareLink)
			}
			res.AdClients = ad
		}()
	}

	//done

	if f.AdEquipmentsDetail == nil || (f.AdEquipmentsDetail != nil && *f.AdEquipmentsDetail) {
		wg.Add(1)
		go func() {
			defer wg.Done()
			//ad, err := service.searchR.AdEquipment(ctx, f)
			ad, err := service.adEqElastic.SearchSimple(ctx, f.General, queryFilters)
			if err != nil {
				errCh <- fmt.Errorf("service search: AdEquipment: err: %w", err)
				return
			}

			for i, v := range ad {
				doc, err := service.documentRepository.GetByID(ctx, ad[i].ID, "ad_equipments")
				if err != nil {
					logrus.Warnf("Document not found for ad ID %d: %v", ad[i].ID, err)
					continue
				}
				d, err := service.remotes.Share(ctx, doc, time.Hour*1)
				if err != nil {
					errCh <- fmt.Errorf("service search: AdSpecializedMachinerie: Share doc: err: %w", err)
					return
				}
				ad[i].UrlDocument = append(v.UrlDocument, d.ShareLink)
			}
			res.AdEquipments = ad
		}()
	}

	//done

	if f.AdEquipmentClientsDetail == nil || (f.AdEquipmentClientsDetail != nil && *f.AdEquipmentClientsDetail) {
		wg.Add(1)
		go func() {
			defer wg.Done()
			// ad, err := service.searchR.AdEquipmentClient(ctx, f)
			ad, err := service.adEqClientElastic.SearchSimple(ctx, f.General, queryFilters)
			if err != nil {
				errCh <- fmt.Errorf("service search: AdEquipmentClient: err: %w", err)
				return
			}

			for i, v := range ad {
				doc, err := service.documentRepository.GetByID(ctx, ad[i].ID, "ad_equipments_client")
				if err != nil {
					logrus.Warnf("Document not found for ad ID %d: %v", ad[i].ID, err)
					continue
				}
				d, err := service.remotes.Share(ctx, doc, time.Hour*1)
				if err != nil {
					errCh <- fmt.Errorf("service search: AdSpecializedMachinerie: Share doc: err: %w", err)
					return
				}
				ad[i].UrlDocument = append(v.UrlDocument, d.ShareLink)
			}
			res.AdEquipmentClients = ad
		}()
	}

	//done

	if f.AdConstructionMaterialDetail == nil || (f.AdConstructionMaterialDetail != nil && *f.AdConstructionMaterialDetail) {
		wg.Add(1)
		go func() {
			defer wg.Done()

			//params := f.AdConstructionMaterialParams

			// ad, err := service.searchR.AdEquipment(ctx, f)
			ad, err := service.adCMElastic.SearchSimple(ctx, f.General, queryFilters)
			if err != nil {
				errCh <- fmt.Errorf("service search: AdConstructionMaterial: err: %w", err)
				return
			}

			for i, v := range ad {
				doc, err := service.documentRepository.GetByID(ctx, ad[i].ID, "ad_construction_material")
				if err != nil {
					logrus.Warnf("Document not found for ad ID %d: %v", ad[i].ID, err)
					continue
				}
				d, err := service.remotes.Share(ctx, doc, time.Hour*1)
				if err != nil {
					errCh <- fmt.Errorf("service search: AdSpecializedMachinerie: Share doc: err: %w", err)
					return
				}
				ad[i].UrlDocument = append(v.UrlDocument, d.ShareLink)
			}
			res.AdConstructionMaterial = ad
		}()
	}

	//done

	if f.AdConstructionMaterialClientsDetail == nil || (f.AdConstructionMaterialClientsDetail != nil && *f.AdConstructionMaterialClientsDetail) {
		wg.Add(1)
		go func() {
			defer wg.Done()
			// ad, err := service.searchR.AdEquipmentClient(ctx, f)
			ad, err := service.adCMClientElastic.SearchSimple(ctx, f.General, queryFilters)
			if err != nil {
				errCh <- fmt.Errorf("service search: AdConstructionMaterialClient: err: %w", err)
				return
			}

			for i, v := range ad {
				doc, err := service.documentRepository.GetByID(ctx, ad[i].ID, "ad_construction_material_clients")
				if err != nil {
					logrus.Warnf("Document not found for ad ID %d: %v", ad[i].ID, err)
					continue
				}
				d, err := service.remotes.Share(ctx, doc, time.Hour*1)
				if err != nil {
					errCh <- fmt.Errorf("service search: AdSpecializedMachinerie: Share doc: err: %w", err)
					return
				}
				ad[i].UrlDocument = append(v.UrlDocument, d.ShareLink)
			}
			res.AdConstructionMaterialClients = ad
		}()
	}

	//done

	if f.AdServiceDetail == nil || (f.AdServiceDetail != nil && *f.AdServiceDetail) {
		wg.Add(1)
		go func() {
			defer wg.Done()
			// ad, err := service.searchR.AdEquipment(ctx, f)
			ad, err := service.adService.SearchSimple(ctx, f.General, queryFilters)
			if err != nil {
				errCh <- fmt.Errorf("service search: AdService: err: %w", err)
				return
			}

			for i, v := range ad {
				if len(v.Documents) == 0 {
					continue
				}
				d, err := service.remotes.Share(ctx, v.Documents[0], time.Hour*1)
				if err != nil {
					errCh <- fmt.Errorf("service search: AdService: Share doc: err: %w", err)
					return
				}
				ad[i].UrlDocument = append(v.UrlDocument, d.ShareLink)
			}
			res.AdService = ad
		}()
	}

	//done

	if f.AdServiceClientsDetail == nil || (f.AdServiceClientsDetail != nil && *f.AdServiceClientsDetail) {
		wg.Add(1)
		go func() {
			defer wg.Done()
			// ad, err := service.searchR.AdEquipmentClient(ctx, f)
			ad, err := service.adServiceClientElastic.SearchSimple(ctx, f.General, queryFilters)
			if err != nil {
				errCh <- fmt.Errorf("service search: AdServicelClient: err: %w", err)
				return
			}

			for i, v := range ad {
				if len(v.Documents) == 0 {
					continue
				}
				d, err := service.remotes.Share(ctx, v.Documents[0], time.Hour*1)
				if err != nil {
					errCh <- fmt.Errorf("service search: AdServiceClients: Share doc: err: %w", err)
					return
				}
				ad[i].UrlDocument = append(v.UrlDocument, d.ShareLink)
			}
			res.AdServiceClients = ad
		}()
	}

	//done

	wg.Wait()
	close(errCh)

	errs := make([]error, 0, 6)

	for err := range errCh {
		errs = append(errs, err)
	}

	if len(errs) != 0 {
		return model.SearchSMResult{}, errs
	}

	return res, nil
}
