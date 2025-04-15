import 'package:eqshare_mobile/app/app_safe_change_notifier.dart';
import 'package:eqshare_mobile/src/core/data/models/category_models/category.dart';
import 'package:eqshare_mobile/src/core/data/models/category_models/sub_category.dart';
import 'package:eqshare_mobile/src/core/data/models/cities/city/city_model.dart';
import 'package:eqshare_mobile/src/core/data/repositories/user_recently_viewed_ads_repo.dart';

import 'package:eqshare_mobile/src/global_widgets/global_values.dart';
import 'package:eqshare_mobile/src/features/ad/data/classes/ad_list_row_data.dart';
import 'package:eqshare_mobile/src/features/ad/data/models/ad_contruction_models/ad_construction_model/ad_constrution_model.dart';
import 'package:eqshare_mobile/src/features/ad/data/models/ad_equipment_models/ad_equipment_model/ad_equipment.dart';
import 'package:eqshare_mobile/src/features/ad/data/models/ad_service_models/ad_service_model/ad_service_model.dart';
import 'package:eqshare_mobile/src/features/ad/data/models/ad_sm_models/ad_sm_model/ad_specialized_machinery.dart';

import 'package:eqshare_mobile/src/features/ad/data/repository/ad_construction_materials_repository.dart';
import 'package:eqshare_mobile/src/features/ad/data/repository/ad_service_repository.dart';
import 'package:eqshare_mobile/src/features/ad/presentation/screens/ad_sm/all_ad_sm/ad_client_list/parameter.dart';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../../data/repository/ad_api_client.dart';
import '../../../../../../../core/presentation/routing/app_route.dart';

class AdSMListController extends AppSafeChangeNotifier {
  AdSMListController(
      {required this.selectedServiceType,
      this.selectedCity,
      required this.userRecentlyViewedAdsRepo});

  final UserRecentlyViewedAdsRepo userRecentlyViewedAdsRepo;

  List<Parameter> parameters = [];
  Set<String> getRecentlyId = {};
  City? selectedCity;
  UniqueKey uniqueKey = UniqueKey();

  Category? selectedCategory =
      Category(name: DefaultNames.allCategories.name, id: 0);
  SubCategory? selectedSubCategory;
  var total = 0;


  List<Category> category = [];
  List<SubCategory> subCategory = [];

  RangeValues initialPriceRangeValues = const RangeValues(0.0, 100000.0);
  RangeValues priceRangeValues = const RangeValues(0.0, 100000.0);

  ServiceTypeEnum selectedServiceType = ServiceTypeEnum.MACHINARY;
  ServiceTypeEnum selectedServiceTypeForChange = ServiceTypeEnum.MACHINARY;

  bool get isLoading => _isLoading;
  bool isLoadingImage = false;
  bool hasError = false;
  bool isBlockView = true;
  var isLoadingInProgres = false;
  bool isContentEmpty = false;
  bool _isLoading = true;

  bool _isLoadingPaginator = false;
  bool get isLoadingPaginator => _isLoadingPaginator;

  String _sortAlgorithm = SortAlgorithmEnum.descCreatedAt.name;
  String get sortAlgorithm => _sortAlgorithm;


  SortAlgorithmEnum get sortAlgorithmEnum => SortAlgorithmEnum.values.firstWhere(
        (e) => e.name == _sortAlgorithm,
    orElse: () => SortAlgorithmEnum.descCreatedAt,
  );


  Map<String, TextEditingController> minControllers = {};
  Map<String, TextEditingController> maxControllers = {};

  Map<String, String> formData = {};

  final List<AdListRowData> _adsSm = <AdListRowData>[];
  final List<AdListRowData> _adsEq = <AdListRowData>[];
  final List<AdListRowData> _adsCm = <AdListRowData>[];
  final List<AdListRowData> _adsSVM = <AdListRowData>[];

  List<AdListRowData> get adsSm => List.unmodifiable(_adsSm.toList());
  List<AdListRowData> get adsCM => List.unmodifiable(_adsCm.toList());
  List<AdListRowData> get adsEq => List.unmodifiable(_adsEq.toList());
  List<AdListRowData> get adsSVM => List.unmodifiable(_adsSVM.toList());

  final _adApiClient = AdApiClient();
  final adCMRepo = AdConstructionMaterialsRepository();
  final adSCVMRepo = AdServiceRepository();

  List<AdListRowData> getAdListRowDataFromSelectedAdServiceType() {
    switch (selectedServiceType) {
      case ServiceTypeEnum.CM:
        return adsCM;
      case ServiceTypeEnum.SVM:
        return adsSVM;
      case ServiceTypeEnum.EQUIPMENT:
        return adsEq;
      case ServiceTypeEnum.MACHINARY:
        return adsSm;
      default:
        return adsSm;
    }
  }


  void setIsLoadingPaginator() {
    _isLoadingPaginator = true;
    notifyListeners();
  }

  void updateFormData(String paramName, String value) {
    formData[paramName] = value;
  }

  void setIsBlockView() {
    isBlockView = !isBlockView;
    notifyListeners();
  }

  void setPriceRangeValues(RangeValues values) {
    priceRangeValues = values;
    notifyListeners();
  }

  void setSelectedServiceType(ServiceTypeEnum value) {
    selectedServiceType = value;
    notifyListeners();
  }

  void setselectedServiceTypeForChange(ServiceTypeEnum value) {
    selectedServiceTypeForChange = value;
    notifyListeners();
  }

  void setSelectedCategory(Category? value) {
    selectedCategory = value;
    notifyListeners();
  }

  void setSelectedCity(City? value) {
    selectedCity = value;
    notifyListeners();
  }

  void setSelectedSubCategory(SubCategory? value) {
    selectedSubCategory = value;
    notifyListeners();
  }

  void setSortAlgorithm(String value) {
    _sortAlgorithm = value;
    notifyListeners();
  }

  void setMinParam(Parameter param, String value) {
    param.minValue = double.tryParse(value) ?? param.minValue;
  }

  void setMaxParam(Parameter param, String value) {
    param.maxValue = double.tryParse(value) ?? param.maxValue;
  }


  Future<void> loadSortedAds(SortAlgorithmEnum sortAlgorithm, int? cityId) async {
    _isLoading = true;
    notifyListeners(); // Уведомление UI о начале загрузки

    try {
      // Запрос данных с сортировкой
      final response = await _adApiClient.getAdSMListWithPagination(
        limit: 10,
        offset: 0,
        sortAlgorithm: sortAlgorithm,
        cityId: cityId,
      );

      // Проверка и получение данных из ответа
      final List<AdSpecializedMachinery> adList =
          response?[0] as List<AdSpecializedMachinery>? ?? [];

      print('Received Ads: ${adList.map((ad) => ad.name).toList()}');

      // Очистка старых данных и добавление новых
      _adsSm
        ..clear()
        ..addAll(adList.map(
              (ad) => AdSpecializedMachinery.getAdListRowDataFromSM(ad),
        ));

      notifyListeners(); // Уведомление UI об обновлении данных
    } catch (error) {
      print('Ошибка при загрузке объявлений: $error');
    } finally {
      _isLoading = false;
      notifyListeners(); // Уведомление UI о завершении загрузки
    }
  }


  Future<void> setupAdsAfterFilter(int? cityId) async {
    isContentEmpty = false;
    _isLoading = true;
    _isLoadingPaginator = false;

    selectedServiceType = selectedServiceTypeForChange;
    _adsSm.clear();
    _adsEq.clear();
    _adsCm.clear();
    _adsSVM.clear();

    notifyListeners();

    await fetchAllCategory();

    await _loadAds(cityId);
    notifyListeners();
  }

  void loadMoreData(int? cityId) {
    _isLoadingPaginator = false;
    notifyListeners();
    _loadAdsForPaginator(serviceTypeEnum: selectedServiceType, cityId: cityId);
  }
  void updateCityId(int newCityId) {
    _adsSm.clear(); // Очищаем старые данные
    _adsEq.clear();
    _adsCm.clear();
    _adsSVM.clear();
    setupAds(cityId: newCityId); // Перезапускаем загрузку объявлений с новым cityId
    notifyListeners();
  }
  Future<void> setupAds(
      {City? selectedCity,
      Category? category,
        int? cityId,
      SubCategory? subCategory,
      ServiceTypeEnum? serviceTypeEnum}) async {
    isContentEmpty = false;
    _isLoading = true;
    setSelectedCity(selectedCity);
    print('CITY ID: $cityId');
    getRecentlyId = (userRecentlyViewedAdsRepo.getData() ?? []).toSet();
    if (serviceTypeEnum != null) {
      selectedServiceType = serviceTypeEnum;
      selectedServiceTypeForChange = serviceTypeEnum;
    }
    notifyListeners();
    await fetchAllCategory();

    await _loadAds(cityId);
    notifyListeners();
  }

  Future<void> _loadAds(int? cityId) async {
    _isLoading = true;
    notifyListeners();
    final queryParams = <String, String>{};
    for (var param in parameters) {
      queryParams[param.nameEng] = '${param.minValue}-${param.maxValue}';
    }

    final currentOffset = getAdListRowDataFromSelectedAdServiceType().length;

    if (selectedServiceType == ServiceTypeEnum.MACHINARY) {
      final result = await _adApiClient.getAdSMListWithPagination(
        subCategoryId: selectedSubCategory?.id,
        categoryId: selectedCategory?.id,
        map: queryParams..addAll(keyValueForSortAlgorithmEnum(_sortAlgorithm)),
        offset: currentOffset,
        limit: 10,
        sortAlgorithm: getSortAlgorithmEnumFromString(_sortAlgorithm),
        cityId: cityId, // Убедитесь, что cityId передается
      );

      total = result?[1] ?? 0;
      final data = result?[0] as List<AdSpecializedMachinery>? ?? <AdSpecializedMachinery>[];

      final Set<int> idKeys = _adsSm.map((e) => e.id ?? 0).toSet();
      for (var element in data) {
        if (idKeys.add(element.id!)) {
          _adsSm.add(_makeRowData(element));
        }
      }
    } else if (selectedServiceType == ServiceTypeEnum.EQUIPMENT) {
      var result = await _adApiClient.getAdEquipmentListWithPaginator(
        subCategoryId: selectedSubCategory?.id,
        categoryId: selectedCategory?.id,
        min: priceRangeValues.start,
        max: priceRangeValues.end,
        sortAlgorithm: sortAlgorithm,
        parameterQueryParams: queryParams
          ..addAll(keyValueForSortAlgorithmEnum(_sortAlgorithm, needToLowerCase: true))
          ..addAll({
            if (cityId != null) 'city_id': cityId.toString() // Передаем cityId
          }),
        offset: currentOffset,
      );
      total = result?[1] ?? 0;
      final data = result?[0] as List<AdEquipment>? ?? <AdEquipment>[];

      final Set<int> idKeys = _adsSm.map((e) => e.id ?? 0).toSet();
      for (var element in data) {
        if (idKeys.add(element.id)) {
          _adsEq.add(_makeRowDataEq(element));
        }
      }
    } else if (selectedServiceType == ServiceTypeEnum.CM) {
      final result = await adCMRepo.getAdConstructionMaterialListForClientWithPaginator(
        queryParametersFromPage: {
          if (selectedSubCategory != null && selectedSubCategory?.id != 0)
            'construction_material_subcategory_id': selectedSubCategory?.id,
          if (selectedCategory != null && selectedCategory?.id != 0)
            'construction_material_category_id': selectedCategory?.id.toString(),
          "price": "${priceRangeValues.start}-${priceRangeValues.end}",
          'offset': currentOffset.toString(),
          'documents_detail': 'true',
          if (cityId != null) 'city_id': cityId.toString() // Передаем cityId
        }..addAll(keyValueForSortAlgorithmEnum(_sortAlgorithm, needToLowerCase: true))
          ..addAll(queryParams),
      );

      total = result?[1] ?? 0;
      final data = result?[0] as List<AdConstrutionModel>? ?? <AdConstrutionModel>[];

      final Set<int> idKeys = _adsSm.map((e) => e.id ?? 0).toSet();
      for (var element in data) {
        if (idKeys.add(element.id!)) {
          _adsCm.add(_makeRowDataCM(element));
        }
      }
    } else {
      var result = await adSCVMRepo.getAdServiceListForClientWithPaginator(
        queryParametersFromPage: {
          if (selectedSubCategory != null && selectedSubCategory?.id != 0)
            'service_subcategory_id': selectedSubCategory?.id,
          "price": "${priceRangeValues.start}-${priceRangeValues.end}",
          'offset': currentOffset,
          'documents_detail': 'true',
          if (selectedCategory != null && selectedCategory?.id != 0)
            'service_category_id': selectedCategory?.id,
          if (cityId != null) 'city_id': cityId.toString() // Передаем cityId
        }..addAll(keyValueForSortAlgorithmEnum(_sortAlgorithm, needToLowerCase: true))
          ..addAll(queryParams),
      );

      total = result?[1] ?? 0;
      final data = result?[0] as List<AdServiceModel>? ?? <AdServiceModel>[];

      final Set<int> idKeys = _adsSm.map((e) => e.id ?? 0).toSet();
      for (var element in data) {
        if (idKeys.add(element.id!)) {
          _adsSVM.add(_makeRowDataSVM(element));
        }
      }
    }
    if (total == 0) {
      isContentEmpty = true;
      notifyListeners();
    }
    _isLoading = false;
    _isLoadingPaginator = false;
    notifyListeners();
  }
  Future<void> _loadAdsForPaginator({ServiceTypeEnum? serviceTypeEnum, int? cityId}) async {
    _isLoadingPaginator = true;
    notifyListeners();
    final queryParams = <String, String>{};
    for (var param in parameters) {
      queryParams[param.nameEng] = '${param.minValue}-${param.maxValue}';
    }
    if (serviceTypeEnum != null) {
      selectedServiceType = serviceTypeEnum;
    } else {
      selectedServiceType = selectedServiceTypeForChange;
    }
    final currentOffset = getAdListRowDataFromSelectedAdServiceType().length;

    if (currentOffset == total) {
      _isLoadingPaginator = false;
      notifyListeners();
      return;
    }
    if (selectedServiceType == ServiceTypeEnum.MACHINARY) {
      final result = await _adApiClient.getAdSMListWithPagination(
          subCategoryId: selectedSubCategory?.id,
          categoryId: selectedCategory?.id,
          map: queryParams
            ..addAll(keyValueForSortAlgorithmEnum(_sortAlgorithm)),
          offset: currentOffset,
          limit: 10,
          sortAlgorithm: getSortAlgorithmEnumFromString(_sortAlgorithm),  // Добавляем сортировку

          cityId: cityId);


      total = result?[1] ?? 0;
      final data = result?[0] as List<AdSpecializedMachinery>? ??
          <AdSpecializedMachinery>[];

      final Set<int> idKeys = _adsSm.map((e) => e.id ?? 0).toSet();
      for (var element in data) {
        if (idKeys.add(element.id!)) {
          _adsSm.add(_makeRowData(element));
        }
      }
    } else if (selectedServiceType == ServiceTypeEnum.EQUIPMENT) {
      var result = await _adApiClient.getAdEquipmentListWithPaginator(
        subCategoryId: selectedSubCategory?.id,
        categoryId: selectedCategory?.id,
        min: priceRangeValues.start,
        max: priceRangeValues.end,
        sortAlgorithm: sortAlgorithm,
        parameterQueryParams: queryParams
          ..addAll(keyValueForSortAlgorithmEnum(_sortAlgorithm,
              needToLowerCase: true))
          ..addAll({
            if (cityId != null) 'city_id': cityId.toString()
          }),
        offset: currentOffset,
      );
      total = result?[1] ?? 0;
      final data = result?[0] as List<AdEquipment>? ?? <AdEquipment>[];

      final Set<int> idKeys = _adsSm.map((e) => e.id ?? 0).toSet();
      for (var element in data) {
        if (idKeys.add(element.id)) {
          _adsEq.add(_makeRowDataEq(element));
        }
      }
    } else if (selectedServiceType == ServiceTypeEnum.CM) {
      final result =
          await adCMRepo.getAdConstructionMaterialListForClientWithPaginator(
              queryParametersFromPage: {
        if (selectedSubCategory != null && selectedSubCategory?.id != 0)
          'construction_material_subcategory_id': selectedSubCategory?.id,
        if (selectedCategory != null && selectedCategory?.id != 0)
          'construction_material_category_id': selectedCategory?.id.toString(),
        "price": "${priceRangeValues.start}-${priceRangeValues.end}",
        // 'limit': 10,
        'offset': currentOffset.toString(),
        'documents_detail': 'true',
        if (cityId != null) 'city_id': cityId.toString()
      }..addAll(keyValueForSortAlgorithmEnum(_sortAlgorithm,
                  needToLowerCase: true)
                ..addAll(queryParams)));

      total = result?[1] ?? 0;
      final data =
          result?[0] as List<AdConstrutionModel>? ?? <AdConstrutionModel>[];

      final Set<int> idKeys = _adsSm.map((e) => e.id ?? 0).toSet();
      for (var element in data) {
        if (idKeys.add(element.id!)) {
          _adsCm.add(_makeRowDataCM(element));
        }
      }
    } else {
      var result = await adSCVMRepo.getAdServiceListForClientWithPaginator(
          queryParametersFromPage: {
        if (selectedSubCategory != null && selectedSubCategory?.id != 0)
          'service_subcategory_id': selectedSubCategory?.id,
        "price": "${priceRangeValues.start}-${priceRangeValues.end}",
        'offset': currentOffset,
        'documents_detail': 'true',
        if (selectedCategory != null && selectedCategory?.id != 0)
          'service_category_id': selectedCategory?.id,
        if (cityId != null) 'city_id': cityId.toString()
      }..addAll(keyValueForSortAlgorithmEnum(_sortAlgorithm,
              needToLowerCase: true)
            ..addAll(queryParams)));

      total = result?[1] ?? 0;
      final data = result?[0] as List<AdServiceModel>? ?? <AdServiceModel>[];

      final Set<int> idKeys = _adsSm.map((e) => e.id ?? 0).toSet();
      for (var element in data) {
        if (idKeys.add(element.id!)) {
          _adsSVM.add(_makeRowDataSVM(element));
        }
      }
    }
    if (total == 0) {
      isContentEmpty = true;
      notifyListeners();
    }
    _isLoadingPaginator = false;
    notifyListeners();
  }

  void onAdTap(BuildContext context, int index) async {
    // final recentlyViewedAdsRepo =
    //     Provider.of<UserRecentlyViewedAdsRepo>(context, listen: false); //17.7
    if (selectedServiceType == ServiceTypeEnum.MACHINARY) {
      final id = adsSm.toList()[index].id.toString();
      // recentlyViewedAdsRepo
      //     .saveViewedAd(AllServiceTypeEnum.MACHINARY, id: id)
      //     .then((value) {
      //   updateRecentlyViewedList(value);
      // });

      await context.pushNamed(
        AppRouteNames.adSMDetail,
        extra: {'id': id},
      );
    } else if (selectedServiceType == ServiceTypeEnum.EQUIPMENT) {
      final id = adsEq.toList()[index].id.toString();
      // recentlyViewedAdsRepo
      //     .saveViewedAd(AllServiceTypeEnum.EQUIPMENT, id: id)
      //     .then((value) {
      //   updateRecentlyViewedList(value);
      // });
      await context.pushNamed(
        AppRouteNames.adEquipmentDetail,
        extra: {'id': id},
      );
    } else if (selectedServiceType == ServiceTypeEnum.CM) {
      final id = adsCM.toList()[index].id.toString();
      // recentlyViewedAdsRepo
      //     .saveViewedAd(AllServiceTypeEnum.CM, id: id)
      //     .then((value) {
      //   updateRecentlyViewedList(value);
      // });
      await context.pushNamed(
        AppRouteNames.adConstructionDetail,
        extra: {'id': id},
      );
    } else {
      final id = adsSVM.toList()[index].id.toString();
      // recentlyViewedAdsRepo
      //     .saveViewedAd(AllServiceTypeEnum.SVM, id: id)
      //     .then((value) {
      //   updateRecentlyViewedList(value);
      // });
      await context.pushNamed(
        AppRouteNames.adServiceDetailScreen,
        extra: {'id': id},
      );
    }
  }

  void updateKey() {
    uniqueKey = UniqueKey();
    getRecentlyId.clear();
    notifyListeners();
  }

  void updateRecentlyViewedList(String type) {
    getRecentlyId.add(type);
    uniqueKey = UniqueKey();
    notifyListeners();
  }

  AdListRowData _makeRowData(AdSpecializedMachinery adSM) {
    return AdSpecializedMachinery.getAdListRowDataFromSM(adSM);
  }

  AdListRowData _makeRowDataEq(AdEquipment adSM) {
    return AdEquipment.getAdListRowDataFromSM(adSM);
  }

  AdListRowData _makeRowDataCM(AdConstrutionModel adSM) {
    return AdConstrutionModel.getAdListRowDataFromSM(adSM);
  }

  AdListRowData _makeRowDataSVM(AdServiceModel adSM) {
    return AdServiceModel.getAdListRowDataFromSM(adSM);
  }

  Future<void> resetFilter() async {
    if (_isLoading) return;
    _isLoading = true;
    selectedCategory = Category(name: DefaultNames.allCategories.name, id: 0);
    selectedSubCategory =
        SubCategory(name: DefaultNames.allSubCategories.name, id: 0);
    category.clear();
    subCategory.clear();
    await fetchAllCategory();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> reset({ServiceTypeEnum? serviceTypeEnum}) async {
    if (_isLoading) return;
    if (serviceTypeEnum != null) {
      selectedServiceTypeForChange = serviceTypeEnum;
    } else {
      selectedServiceTypeForChange = ServiceTypeEnum.MACHINARY;
    }
    _isLoading = true;
    selectedCategory = Category(name: DefaultNames.allCategories.name, id: 0);
    selectedSubCategory =
        SubCategory(name: DefaultNames.allSubCategories.name, id: 0);
    category.clear();
    subCategory.clear();
    parameters.clear();
    priceRangeValues = const RangeValues(0, 100000);
    _isLoading = false;
    selectedServiceType = ServiceTypeEnum.MACHINARY;
    notifyListeners();
  }

  Future<void> fetchAllCategory() async {
    try {
      dynamic response;
      if (selectedServiceTypeForChange == ServiceTypeEnum.EQUIPMENT) {
        response = await _adApiClient.getEqCategoryList();
      } else if (selectedServiceTypeForChange == ServiceTypeEnum.MACHINARY) {
        response = await _adApiClient.getSMCategoryList();
      } else if (selectedServiceTypeForChange == ServiceTypeEnum.CM) {
        response = await _adApiClient.getCMCategoryList();
      } else {
        response = await _adApiClient.getSVMCategoryList();
      }

      if (response != null) {
        if (category.isNotEmpty) {
          category.clear();
        }
        category.addAll(response);
        category.sort((a, b) => (a.name ?? '').compareTo(b.name ?? ''));
        category.insert(
            0, Category(id: 0, name: DefaultNames.allCategories.name));
        notifyListeners();
      } else {
        throw Exception('Response or adSpecializedMachinery is null');
      }
    } catch (e) {
      debugPrint('Error fetching data: $e');
    }
  }

  Future<void> fetchAllSubCategory(
      int? categoryId, BuildContext context) async {
    try {
      selectedSubCategory = SubCategory(name: 'Все подкатегории', id: 0);
      subCategory.clear();
      dynamic response;
      if (selectedServiceTypeForChange == ServiceTypeEnum.EQUIPMENT) {
        response = await _adApiClient.getEqSubCategoryList('$categoryId');
      } else if (selectedServiceTypeForChange == ServiceTypeEnum.MACHINARY) {
        response =
            await _adApiClient.getSmSubCategoryList(categoryId.toString());
      } else if (selectedServiceTypeForChange == ServiceTypeEnum.CM) {
        response =
            await _adApiClient.getCMSubCategoryList(categoryId.toString());
      } else {
        response =
            await _adApiClient.getSVMSubCategoryList(categoryId.toString());
      }

      if (response != null) {
        subCategory.addAll(response);
        subCategory.sort((a, b) => (a.name ?? '').compareTo(b.name ?? ''));

        subCategory.insert(0, SubCategory(id: 0, name: 'Все подкатегории'));
        selectedSubCategory = subCategory.first;

        _isLoadingPaginator = false;

        notifyListeners();
      } else {
        throw Exception('Response or adSpecializedMachinery is null');
      }
    } catch (e) {
      debugPrint('Error fetching data: $e');
    }
  }
}
