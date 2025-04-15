import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:eqshare_mobile/src/core/data/models/category_models/category.dart';
import 'package:eqshare_mobile/src/core/data/models/category_models/sub_category.dart';
import 'package:eqshare_mobile/src/global_widgets/global_values.dart';
import 'package:eqshare_mobile/src/features/ad/data/models/ad_contruction_models/ad_construction_model/ad_constrution_model.dart';
import 'package:eqshare_mobile/src/features/ad/data/models/ad_equipment_models/ad_equipment_model/ad_equipment.dart';

import 'package:eqshare_mobile/src/features/ad/data/models/ad_service_models/ad_service_model/ad_service_model.dart';
import 'package:eqshare_mobile/src/features/ad/data/models/ad_sm_models/ad_sm_model/ad_specialized_machinery.dart';

import 'package:eqshare_mobile/src/features/main/location/sm_list_map_repository.dart';

import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../home/home_controller.dart';

part 'sm_list_map_event.dart';
part 'sm_list_map_state.dart';

class SmListMapBloc extends Bloc<SmListMapEvent, SmListMapState> {
  final SmListMapRepository _smListMapRepository;
  final HomeController _homeController; // Добавляем HomeController

  SmListMapBloc({
    required SmListMapRepository smListMapRepository,
    required HomeController homeController, // Принимаем HomeController
  })  : _smListMapRepository = smListMapRepository,
        _homeController = homeController,
        super(const SmListMapState()) {


    on<FetchInitialData>((event, emit) async {
      await _onFetchInitialData(emit);
    });

    on<FetchData>((event, emit) async {
      await _onFetchData(event, emit);
    });

    on<FetchDataWithSearch>((event, emit) async {
      final key = state.pickedServiceType;
      final cityId = _homeController.selectedCity?.id; // Получаем city_id

      final data = await _smListMapRepository.getSearchListData(
        key,
        searchQuery: event.searchQuery,
        cityId: cityId ?? 0, // Передаем в запрос
      );

      switch (key) {
        case ServiceTypeEnum.MACHINARY:
          emit(SMADMapListState(
              adSpecializedMachinery: (data as List<AdSpecializedMachinery>),
              pageStatus: PageStatus.success,
              categories: state.categories,
              pickedServiceType: key,
              subCategories: state.subCategories,
              idPickedSubCategory: state.idPickedMainCategory,
              idPickedMainCategory: state.idPickedMainCategory));
        case ServiceTypeEnum.EQUIPMENT:
          emit(EQADMapListState(
              equipments: (data as List<AdEquipment>),
              pageStatus: PageStatus.success,
              categories: state.categories,
              pickedServiceType: key,
              subCategories: state.subCategories,
              idPickedSubCategory: state.idPickedMainCategory,
              idPickedMainCategory: state.idPickedMainCategory));
        case ServiceTypeEnum.CM:
          emit(CMADMapListState(
              adContructions: (data as List<AdConstrutionModel>),
              pageStatus: PageStatus.success,
              pickedServiceType: key,
              categories: state.categories,
              subCategories: state.subCategories,
              idPickedSubCategory: state.idPickedMainCategory,
              idPickedMainCategory: state.idPickedMainCategory));
        case ServiceTypeEnum.SVM:
          emit(SVMADMapListState(
              adServices: (data as List<AdServiceModel>),
              pageStatus: PageStatus.success,
              pickedServiceType: key,
              subCategories: state.subCategories,
              categories: state.categories,
              idPickedSubCategory: state.idPickedMainCategory,
              idPickedMainCategory: state.idPickedMainCategory));
        default:
          emit(SMADMapListState(
              idPickedSubCategory: state.idPickedMainCategory,
              idPickedMainCategory: state.idPickedMainCategory,
              subCategories: state.subCategories,
              pickedServiceType: key,
              categories: state.categories,
              adSpecializedMachinery: (data as List<AdSpecializedMachinery>),
              pageStatus: PageStatus.success));
      }
    });

    on<FetchDataWithMainCategory>((event, emit) async {
      final key = state.pickedServiceType;
      final cityId = _homeController.selectedCity?.id ?? 0; // Добавляем city_id

      final data = (await _smListMapRepository.getData(
        key,
        categoryID: event.categoryId,
        subCategoryID: event.subCategoryID,
        cityID: cityId, // Передаем cityId
      )) ?? [];

      switch (key) {
        case ServiceTypeEnum.MACHINARY:
          emit(SMADMapListState(
              adSpecializedMachinery: (data as List<AdSpecializedMachinery>),
              pageStatus: PageStatus.success,
              categories: state.categories,
              subCategories: state.subCategories,
              idPickedSubCategory: event.subCategoryID ?? 0,
              idPickedMainCategory: event.categoryId ?? 0));
        case ServiceTypeEnum.EQUIPMENT:
          emit(EQADMapListState(
              equipments: (data as List<AdEquipment>),
              pageStatus: PageStatus.success,
              categories: state.categories,
              subCategories: state.subCategories,
              idPickedSubCategory: event.subCategoryID ?? 0,
              idPickedMainCategory: event.categoryId ?? 0));
        case ServiceTypeEnum.CM:
          emit(CMADMapListState(
              adContructions: (data as List<AdConstrutionModel>),
              pageStatus: PageStatus.success,
              idPickedSubCategory: event.subCategoryID ?? 0,
              categories: state.categories,
              subCategories: state.subCategories,
              idPickedMainCategory: event.categoryId ?? 0));
        case ServiceTypeEnum.SVM:
          emit(SVMADMapListState(
              adServices: (data as List<AdServiceModel>),
              pageStatus: PageStatus.success,
              subCategories: state.subCategories,
              categories: state.categories,
              idPickedSubCategory: event.subCategoryID ?? 0,
              idPickedMainCategory: event.categoryId ?? 0));
        default:
          emit(SMADMapListState(
              idPickedSubCategory: event.subCategoryID ?? 0,
              subCategories: state.subCategories,
              categories: state.categories,
              adSpecializedMachinery: (data as List<AdSpecializedMachinery>),
              pageStatus: PageStatus.success,
              idPickedMainCategory: event.categoryId ?? 0));
      }
    });
  }

  Future<void> _onFetchInitialData(Emitter<SmListMapState> emit) async {
    try {
      // Ждем, пока появится selectedCity
      while (_homeController.selectedCity == null) {
        await Future.delayed(const Duration(milliseconds: 100));
      }
      final cityId = _homeController.selectedCity!.id;
      print('FETCH INIT $cityId');
      final adSpecializedMachinery = await _fetchInitialAd(cityId);
      final List<Category> listCategories = await _smListMapRepository
          .getAllCategories(ServiceTypeEnum.MACHINARY) ?? [];

      emit(SMADMapListState(
          adSpecializedMachinery:
          adSpecializedMachinery as List<AdSpecializedMachinery>,
          categories: listCategories..insert(0, _allCategories),
          pageStatus: PageStatus.success,
          subCategories: [_allSubCategories]));
    } on Exception catch (e) {
      log('Happen error: $e ',
          name: 'Error on FetchInitialData in SmListBloc : ');
    }
  }


  Future<void> _onFetchData(FetchData event, Emitter<SmListMapState> emit) async {
    if (!event.forceReload &&
        state.pickedServiceType == event.serviceTypeEnum &&
        state.idPickedMainCategory == event.categoryId &&
        state.idPickedSubCategory == event.subCategoryId) {
      // Если данные уже загружены и не требуется принудительная перезагрузка, выходим
      return;
    }

    final key = event.serviceTypeEnum;
    final cityId = _homeController.selectedCity?.id ?? 0; // Добавляем city_id

    final data = (await _smListMapRepository.getData(
      key,
      categoryID: event.categoryId,
      subCategoryID: event.subCategoryId,
      cityID: cityId, // Передаем cityId
    )) ?? [];
    final category = await _smListMapRepository.getAllCategories(key) ?? [_allCategories];
    final categories = await _smListMapRepository.getAllSubCategories(key,
        mainCategoryID: event.categoryId ?? 0) ??
        [_allSubCategories];

    category.insert(0, _allCategories);
    categories.insert(0, _allSubCategories);

    log(categories.toString(), name: 'Categories');
    switch (key) {
      case ServiceTypeEnum.MACHINARY:
        emit(SMADMapListState(
            adSpecializedMachinery: (data as List<AdSpecializedMachinery>),
            subCategories: categories,
            categories: category,
            pickedServiceType: event.serviceTypeEnum,
            pageStatus: PageStatus.success,
            idPickedSubCategory: event.subCategoryId ?? 0,
            idPickedMainCategory: event.categoryId ?? 0));
      case ServiceTypeEnum.EQUIPMENT:
        emit(EQADMapListState(
            equipments: (data as List<AdEquipment>),
            subCategories: categories,
            categories: category,
            pickedServiceType: event.serviceTypeEnum,
            pageStatus: PageStatus.success,
            idPickedSubCategory: event.subCategoryId ?? 0,
            idPickedMainCategory: event.categoryId ?? 0));
      case ServiceTypeEnum.CM:
        emit(CMADMapListState(
            adContructions: (data as List<AdConstrutionModel>),
            subCategories: categories,
            categories: category,
            pickedServiceType: event.serviceTypeEnum,
            pageStatus: PageStatus.success,
            idPickedSubCategory: event.subCategoryId ?? 0,
            idPickedMainCategory: event.categoryId ?? 0));
      case ServiceTypeEnum.SVM:
        emit(SVMADMapListState(
            adServices: (data as List<AdServiceModel>),
            subCategories: categories,
            pageStatus: PageStatus.success,
            pickedServiceType: event.serviceTypeEnum,
            categories: category,
            idPickedMainCategory: event.categoryId ?? 0));
      default:
        emit(SMADMapListState(
            adSpecializedMachinery: (data as List<AdSpecializedMachinery>),
            subCategories: categories,
            pageStatus: PageStatus.success,
            pickedServiceType: event.serviceTypeEnum,
            idPickedSubCategory: event.subCategoryId ?? 0,
            idPickedMainCategory: event.categoryId ?? 0));
    }
  }

  Future<List<dynamic>?> _fetchInitialAd(int cityId) async {
    final data = await _smListMapRepository.getData(ServiceTypeEnum.MACHINARY,cityID: cityId,);
    return data;
  }

  final _allCategories = Category(name: 'Все категории', id: 0);
  final _allSubCategories = SubCategory(name: 'Все подкатегории', id: 0);
}
