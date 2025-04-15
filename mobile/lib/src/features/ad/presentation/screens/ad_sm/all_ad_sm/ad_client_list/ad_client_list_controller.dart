import 'package:eqshare_mobile/app/app_safe_change_notifier.dart';
import 'package:eqshare_mobile/src/core/data/models/category_models/category.dart';
import 'package:eqshare_mobile/src/core/data/models/category_models/sub_category.dart';
import 'package:eqshare_mobile/src/core/data/models/cities/city/city_model.dart';

import 'package:eqshare_mobile/src/core/data/services/network/api_client/network_client.dart';
import 'package:eqshare_mobile/src/core/presentation/routing/app_route.dart';
import 'package:eqshare_mobile/app/app_change_notifier.dart';
import 'package:eqshare_mobile/src/global_widgets/global_values.dart';
import 'package:eqshare_mobile/src/features/ad/data/classes/ad_list_row_data.dart';
import 'package:eqshare_mobile/src/features/ad/data/models/ad_contruction_models/ad_construction_client_model.dart/ad_construction_client_model.dart';
import 'package:eqshare_mobile/src/features/ad/data/models/ad_equipment_models/ad_equipment_client_model/ad_equipment_client.dart';

import 'package:eqshare_mobile/src/features/ad/data/models/ad_service_models/ad_service_client_model/ad_service_client_model.dart';

import 'package:eqshare_mobile/src/features/ad/data/models/ad_sm_models/ad_sm_client_model/ad_client.dart';

import 'package:eqshare_mobile/src/features/ad/data/repository/ad_construction_materials_repository.dart';
import 'package:eqshare_mobile/src/features/ad/data/repository/ad_service_repository.dart';

import 'package:eqshare_mobile/src/features/ad/presentation/screens/ad_sm/all_ad_sm/ad_client_list/parameter.dart';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../data/models/ad_sm_models/ad_sm_model/ad_specialized_machinery.dart';
import '../../../../../data/repository/ad_api_client.dart';

class AdClientListController extends AppSafeChangeNotifier {
  AdClientListController(
      {required this.selectedServiceType, this.selectedCity});

  Map<String, String> formData = {};

  final adServiceRepo = AdServiceRepository();
  final adCmRepo = AdConstructionMaterialsRepository();
  int? selectedCityId;

  SubCategory? selectedSubCategoryModel;
  Category? selectedCategoryModel;
  City? selectedCity;

  ServiceTypeEnum? selectedServiceType = ServiceTypeEnum.MACHINARY;
  ServiceTypeEnum? selectedServiceTypeForChange = ServiceTypeEnum.MACHINARY;

  RangeValues initialPriceRangeValues = const RangeValues(0.0, 100000.0);
  RangeValues priceRangeValues = const RangeValues(0.0, 100000.0);

  void changeCategory(Category? category, BuildContext context) async {
    selectedCategoryModel = category;
    notifyListeners();
  }

  void changeSubCategory(SubCategory? categoty) {
    selectedSubCategoryModel = categoty;
    notifyListeners();
  }


  void updateFormData(String paramName, String value) {
    formData[paramName] = value;
  }

  void setPriceRangeValues(RangeValues values) {
    priceRangeValues = values;
    notifyListeners();
  }

  void setSelectedServiceTypeForChange(ServiceTypeEnum? value) {
    selectedServiceTypeForChange = value;
    notifyListeners();
  }

  void setSelectedServiceType(ServiceTypeEnum value) {
    selectedServiceType = value;
    notifyListeners();
  }

  void setSelectedCategory(Category value) {
    selectedCategoryModel = value;
    notifyListeners();
  }

  void setSelectedCity(City? value) {
    selectedCity = value;
    notifyListeners();
  }

  void setSelectedSubCategory(SubCategory value) {
    selectedSubCategoryModel = value;

    notifyListeners();
  }

  bool _isLoading = true;
  bool _isLoadingPaginator = false;
  final _adApiClient = AdApiClient();
  final _networkClient = NetworkClient();
  final List<AdListRowData> _ads = <AdListRowData>[];
  final List<AdListRowData> _adsEq = <AdListRowData>[];
  final List<AdListRowData> _adsCM = <AdListRowData>[];
  final List<AdListRowData> _adsSVM = <AdListRowData>[];

  List<Category> category = [];
  List<SubCategory> subCategory = [];
  var isLoadingInProgres = false;
  bool isContentEmpty = false;

  bool get isLoading => _isLoading;
  bool get isLoadingPaginator => _isLoadingPaginator;
  bool isLoadingImage = false;
  bool hasError = false;
  List<AdClient>? adsResponse;
  String _sortAlgorithm = SortAlgorithmEnum.descCreatedAt.name;
  Map<String, TextEditingController> minControllers = {};
  Map<String, TextEditingController> maxControllers = {};
  bool _isBlockView = true;

  String get sortAlgorithm => _sortAlgorithm;

  SortAlgorithmEnum get sortAlgorithmEnum => SortAlgorithmEnum.values.firstWhere(
        (e) => e.name == _sortAlgorithm,
    orElse: () => SortAlgorithmEnum.descCreatedAt,
  );


  List<AdListRowData> get ads => List.unmodifiable(_ads.toList());
  List<AdListRowData> get adsEq => List.unmodifiable(_adsEq.toList());
  List<AdListRowData> get adsCm => List.unmodifiable(_adsCM.toList());
  List<AdListRowData> get adsSVM => List.unmodifiable(_adsSVM.toList());

  List<AdListRowData> getAdListRowDataFromSelectedAdServiceType() {
    switch (selectedServiceType) {
      case ServiceTypeEnum.CM:
        return adsCm;
      case ServiceTypeEnum.SVM:
        return adsSVM;
      case ServiceTypeEnum.EQUIPMENT:
        return adsEq;
      case ServiceTypeEnum.MACHINARY:
        return ads;
      default:
        return ads;
    }
  }
  void updateCityId(int newCityId) {
    selectedCityId = newCityId;

    _ads.clear(); // Очищаем старые данные
    _adsEq.clear();
    _adsCM.clear();
    _adsSVM.clear();
    notifyListeners();

    setupAds(cityId: newCityId); // Перезапускаем загрузку объявлений с новым cityId
  }
  void setSortAlgorithm(String value) {
    _sortAlgorithm = value;
    notifyListeners();
  }

  bool get isBlockView => _isBlockView;

  void setIsBlockView(bool value) {
    _isBlockView = value;
    notifyListeners();
  }

  void setMinParam(Parameter param, String value) {
    param.minValue = double.tryParse(value) ?? param.minValue;
    notifyListeners();
  }

  void setMaxParam(Parameter param, String value) {
    param.maxValue = double.tryParse(value) ?? param.maxValue;
    notifyListeners();
  }

  List<Parameter> parameters = [];

  var total = 0;

  List<AdListRowData> getAdListRowData() {
    switch (selectedServiceType) {
      case ServiceTypeEnum.CM:
        return adsCm;
      case ServiceTypeEnum.SVM:
        return adsSVM;
      case ServiceTypeEnum.EQUIPMENT:
        return adsEq;

      case ServiceTypeEnum.MACHINARY:
        return ads;

      default:
        return ads;
    }
  }

  Future<void> loadSortedAds(SortAlgorithmEnum sortAlgorithm,int? cityId) async {
    _isLoading = true;
    notifyListeners(); // Уведомляем UI о начале загрузки

    try {
      // Запрос данных с сортировкой
      final response = await _adApiClient.getAdSMListWithPagination(
        limit: 10,
        offset: 0,
        sortAlgorithm: sortAlgorithm,
        cityId: cityId// Передаем параметр сортировки
      );

      // Проверка и получение данных из ответа
      final List<AdSpecializedMachinery> adList =
          response?[0] as List<AdSpecializedMachinery>? ?? [];

      // Очистка старых данных и добавление новых
      _ads
        ..clear()
        ..addAll(adList.map((ad) => AdSpecializedMachinery.getAdListRowDataFromSM(ad)));

      notifyListeners(); // Уведомляем UI об обновлении данных
    } catch (error) {
      print('Ошибка при загрузке объявлений: $error');
    } finally {
      _isLoading = false;
      notifyListeners(); // Уведомляем UI о завершении загрузки
    }
  }


  Future<void> setupAds({City? selectedCity, int? cityId, ServiceTypeEnum? serviceTypeEnum}) async {
    isContentEmpty = false;
    _isLoading = true;

    setSelectedCity(selectedCity);
    selectedCityId = cityId ?? selectedCityId;  // Сохраняем `cityId`

    if (serviceTypeEnum != null) {
      selectedServiceType = serviceTypeEnum;
      selectedServiceTypeForChange = serviceTypeEnum;
    } else {
      selectedServiceType = selectedServiceTypeForChange;
    }

    notifyListeners();
    AppChangeNotifier().checkConnectivity();

    if (category.isEmpty) {
      selectedCategoryModel = selectedCategoryModel ??
          Category(id: 0, name: DefaultNames.allCategories.name);
      await fetchAllCategory();
    }

    _ads.clear();
    _adsEq.clear();
    _adsCM.clear();
    _adsSVM.clear();
    notifyListeners();

    await _loadAds(selectedCityId);  // Используем сохраненный `cityId`

    _isLoading = false;
    notifyListeners();
  }


  Future<void> setupAdsAfterFilter({ServiceTypeEnum? serviceTypeEnum,int? cityId}) async {
    isContentEmpty = false;
    _isLoading = true;
    notifyListeners();

    selectedServiceType = selectedServiceTypeForChange;
    _ads.clear();
    _adsEq.clear();
    _adsCM.clear();
    _adsSVM.clear();

    AppChangeNotifier().checkConnectivity();

    await fetchAllCategory();

    await _loadAds(cityId);

    notifyListeners();
  }

  Future<void> loadMoreData(int? cityId) async {
    await _loadAdsForPaginator(serviceTypeEnum: selectedServiceType, cityId: cityId);
  }

  void setIsLoadingPaginator() {
    _isLoadingPaginator = true;
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
      final result = await _adApiClient.getAdClientListWithPaginator(
        subCategoryId: selectedSubCategoryModel?.id != 0
            ? selectedSubCategoryModel?.id
            : null,
        categoryId:
        selectedCategoryModel?.id != 0 ? selectedCategoryModel?.id : null,
        sortAlgorithm: getSortAlgorithmEnumFromString(_sortAlgorithm),  // Добавляем сортировку
        qmap: queryParams..addAll(keyValueForSortAlgorithmEnum(_sortAlgorithm)),
        offset: currentOffset,
        cityId: cityId,
        limit: 10,
      );


      total = result?[1] ?? currentOffset;
      final data = result?[0] as List<AdClient>? ?? <AdClient>[];

      final Set<int> idKeys = _ads.map((e) => e.id ?? 0).toSet();
      for (var element in data) {
        if (idKeys.add(element.id)) {
          _ads.add(_makeRowData(element));
        }
      }
    } else if (selectedServiceType == ServiceTypeEnum.EQUIPMENT) {
      var result = await _adApiClient.getAdEquipmentClientListWithPaginator(
          subCategoryId: selectedSubCategoryModel?.id != 0
              ? selectedSubCategoryModel?.id
              : null,
          categoryId:
              selectedCategoryModel?.id != 0 ? selectedCategoryModel?.id : null,
          cityID: cityId,
          sortAlgorithm: sortAlgorithm,
          map: queryParams
            ..addAll(keyValueForSortAlgorithmEnum(sortAlgorithm)
              ..addAll({
                "status": RequestStatus.CREATED.name,
                'documents_detail': 'true',
                'city_detail': 'true'
              })),
          offset: currentOffset);
      total = result?[1] ?? currentOffset;
      final data =
          result?[0] as List<AdEquipmentClient>? ?? <AdEquipmentClient>[];

      final Set<int> idKeys = _adsEq.map((e) => e.id ?? 0).toSet();
      for (var element in data) {
        if (idKeys.add(element.id ?? 0)) {
          _adsEq.add(_makeRowDataEq(element));
        }
      }
    } else if (selectedServiceType == ServiceTypeEnum.CM) {
      final result = await adCmRepo
          .getAdConstructionMaterialListForDriverOrOwnerWithPaginator(
        queryParametersFromPage: {
          if (selectedSubCategoryModel != null &&
              selectedSubCategoryModel?.id != 0)
            'construction_material_subcategory_id':
                selectedSubCategoryModel?.id,
          'price': '${priceRangeValues.start}-${priceRangeValues.end}',
          "status": RequestStatus.CREATED.name,
          if (selectedCategoryModel != null && selectedCategoryModel?.id != 0)
            'construction_material_category_id':
                selectedCategoryModel?.id.toString(),
          if (cityId != null)
            'city_id': cityId.toString(),
          'documents_detail': 'true',
        }..addAll(keyValueForSortAlgorithmEnum(sortAlgorithm)),
      );

      total = result?[1] ?? currentOffset;
      final data = result?[0] as List<AdConstructionClientModel>? ??
          <AdConstructionClientModel>[];

      final Set<int> idKeys = _adsCM.map((e) => e.id ?? 0).toSet();
      for (var element in data) {
        if (idKeys.add(element.id!)) {
          _adsCM.add(_makeRowDataCm(element));
        }
      }
    } else {
      final result =
          await adServiceRepo.getAdServiceListForDriverOrOwnerWithPaginator(
                qmap: {
                  if (selectedSubCategoryModel != null &&
                      selectedSubCategoryModel?.id != 0)
                    'service_subcategory_id': selectedSubCategoryModel?.id,
                  if (selectedCategoryModel != null &&
                      selectedCategoryModel?.id != 0)
                    'service_category_id': selectedCategoryModel?.id,
                  if (cityId != null)
                    'city_id': cityId.toString(),
                  "status": RequestStatus.CREATED.name,
                  'price': '${priceRangeValues.start}-${priceRangeValues.end}',
                  'city_detail': 'true',
                  'documents_detail': 'true',
                }..addAll(keyValueForSortAlgorithmEnum(sortAlgorithm)),
              ) ??
              [];

      total = result[1] ?? currentOffset;
      final data =
          result[0] as List<AdServiceClientModel>? ?? <AdServiceClientModel>[];

      final Set<int> idKeys = _adsSVM.map((e) => e.id ?? 0).toSet();
      for (var element in data) {
        if (idKeys.add(element.id!)) {
          _adsSVM.add(_makeRowDataSvm(element));
        }
      }
    }
    if (currentOffset == total) {
      notifyListeners();
      return;
    }
    if (total == 0) {
      isContentEmpty = true;
      notifyListeners();
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> _loadAdsForPaginator({ServiceTypeEnum? serviceTypeEnum, int? cityId}) async {
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
      return;
    }

    if (selectedServiceType == ServiceTypeEnum.MACHINARY) {
      final result = await _adApiClient.getAdClientListWithPaginator(
        subCategoryId: selectedSubCategoryModel?.id != 0
            ? selectedSubCategoryModel?.id
            : null,
        categoryId:
        selectedCategoryModel?.id != 0 ? selectedCategoryModel?.id : null,
        sortAlgorithm: getSortAlgorithmEnumFromString(_sortAlgorithm),  // Добавляем сортировку
        qmap: queryParams..addAll(keyValueForSortAlgorithmEnum(_sortAlgorithm)),
        offset: currentOffset,
        limit: 10,
        cityId: cityId
      );


      total = result?[1] ?? 0;
      final data = result?[0] as List<AdClient>? ?? <AdClient>[];

      final Set<int> idKeys = _ads.map((e) => e.id ?? 0).toSet();
      for (var element in data) {
        if (idKeys.add(element.id)) {
          _ads.add(_makeRowData(element));
        }
      }
    } else if (selectedServiceType == ServiceTypeEnum.EQUIPMENT) {
      var result = await _adApiClient.getAdEquipmentClientListWithPaginator(
          subCategoryId: selectedSubCategoryModel?.id != 0
              ? selectedSubCategoryModel?.id
              : null,
          categoryId:
              selectedCategoryModel?.id != 0 ? selectedCategoryModel?.id : null,
          sortAlgorithm: sortAlgorithm,
          cityID: cityId,
          map: queryParams
            ..addAll(keyValueForSortAlgorithmEnum(sortAlgorithm)
              ..addAll({
                "status": RequestStatus.CREATED.name,
                'documents_detail': 'true',
                'city_detail': 'true'
              })),
          limit: 10,
          offset: currentOffset);
      total = result?[1] ?? 0;
      final data =
          result?[0] as List<AdEquipmentClient>? ?? <AdEquipmentClient>[];

      final Set<int> idKeys = _adsEq.map((e) => e.id ?? 0).toSet();
      for (var element in data) {
        if (idKeys.add(element.id ?? 0)) {
          _adsEq.add(_makeRowDataEq(element));
        }
      }
    } else if (selectedServiceType == ServiceTypeEnum.CM) {
      final result = await adCmRepo
          .getAdConstructionMaterialListForDriverOrOwnerWithPaginator(
        queryParametersFromPage: {
          if (selectedSubCategoryModel != null &&
              selectedSubCategoryModel?.id != 0)
            'construction_material_subcategory_id':
                selectedSubCategoryModel?.id,
          if (cityId != null)
            'city_id': cityId.toString(),
          'price': '${priceRangeValues.start}-${priceRangeValues.end}',
          "status": RequestStatus.CREATED.name,
          if (selectedCategoryModel != null && selectedCategoryModel?.id != 0)
            'construction_material_category_id':
                selectedCategoryModel?.id.toString(),
          'documents_detail': 'true',
          'limit': 10,
        }..addAll(keyValueForSortAlgorithmEnum(sortAlgorithm)),
      );

      total = result?[1] ?? 0;
      final data = result?[0] as List<AdConstructionClientModel>? ??
          <AdConstructionClientModel>[];

      final Set<int> idKeys = _adsCM.map((e) => e.id ?? 0).toSet();
      for (var element in data) {
        if (idKeys.add(element.id!)) {
          _adsCM.add(_makeRowDataCm(element));
        }
      }
    } else {
      final result =
          await adServiceRepo.getAdServiceListForDriverOrOwnerWithPaginator(
                qmap: {
                  if (selectedSubCategoryModel != null &&
                      selectedSubCategoryModel?.id != 0)
                    'service_subcategory_id': selectedSubCategoryModel?.id,
                  if (selectedCategoryModel != null &&
                      selectedCategoryModel?.id != 0)
                    'service_category_id': selectedCategoryModel?.id,
                  if (cityId != null)
                    'city_id': cityId.toString(),
                  "status": RequestStatus.CREATED.name,
                  'price': '${priceRangeValues.start}-${priceRangeValues.end}',
                  'city_detail': 'true',
                  'documents_detail': 'true',
                  'limit': 10,
                }..addAll(keyValueForSortAlgorithmEnum(sortAlgorithm)),
              ) ??
              [];

      total = result[1] ?? 0;
      final data =
          result[0] as List<AdServiceClientModel>? ?? <AdServiceClientModel>[];

      final Set<int> idKeys = _adsSVM.map((e) => e.id ?? 0).toSet();
      for (var element in data) {
        if (idKeys.add(element.id!)) {
          _adsSVM.add(_makeRowDataSvm(element));
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
    if (selectedServiceType == ServiceTypeEnum.MACHINARY) {
      final id = ads.toList()[index].id.toString();
      await context.pushNamed(
        AppRouteNames.adSMClientDetail,
        extra: {'id': id},
      );
    } else if (selectedServiceType == ServiceTypeEnum.EQUIPMENT) {
      final id = adsEq.toList()[index].id.toString();
      await context.pushNamed(
        AppRouteNames.adEquipmentClientDetail,
        extra: {'id': id},
      );
    } else if (selectedServiceType == ServiceTypeEnum.CM) {
      final id = adsCm.toList()[index].id.toString();
      await context.pushNamed(
        AppRouteNames.adConstructionClientDetail,
        extra: {'id': id},
      );
    } else {
      final id = adsSVM.toList()[index].id.toString();
      await context.pushNamed(
        AppRouteNames.adServiceClientDetailScreen,
        extra: {'id': id},
      );
    }
  }

  AdListRowData _makeRowData(AdClient adSM) {
    return AdClient.getAdListRowDataFromSM(adSM);
  }

  AdListRowData _makeRowDataEq(AdEquipmentClient adSM) {
    return AdEquipmentClient.getAdListRowDataFromSM(adSM);
  }

  AdListRowData _makeRowDataCm(AdConstructionClientModel ad) {
    return AdConstructionClientModel.getAdListRowDataFromSM(ad);
  }

  AdListRowData _makeRowDataSvm(AdServiceClientModel ad) {
    return AdServiceClientModel.getAdListRowDataFromSM(ad);
  }

  Future<void> resetFilter({ServiceTypeEnum? serviceTypeEnum}) async {
    if (serviceTypeEnum != null) {
      selectedServiceTypeForChange = serviceTypeEnum;
    } else {
      selectedServiceTypeForChange = ServiceTypeEnum.MACHINARY;
    }

    _isLoading = true;
    category.clear();
    subCategory.clear();
    selectedCategoryModel = null;
    selectedSubCategoryModel = null;
    notifyListeners();
    if (selectedServiceTypeForChange != null) {
      await fetchAllCategory();
      notifyListeners();
    }

    notifyListeners();
  }

  Future<void> fetchAllCategory() async {
    try {
      dynamic response;
      if (selectedServiceTypeForChange == ServiceTypeEnum.EQUIPMENT) {
        response = await _adApiClient.getEqCategoryList();
      } else if (selectedServiceTypeForChange == (ServiceTypeEnum.MACHINARY)) {
        response = await _adApiClient.getSMCategoryList();
      } else if (selectedServiceTypeForChange == (ServiceTypeEnum.CM)) {
        response = await _adApiClient.getCMCategoryList();
      } else {
        response = await _adApiClient.getSVMCategoryList();
      }

      if (category.isNotEmpty) {
        category.clear();
      }

      if (response != null) {
        category.sort((a, b) => (a.name ?? '').compareTo(b.name ?? ''));
        category.insert(
            0, Category(name: DefaultNames.allCategories.name, id: 0));

        category.addAll(response);

        selectedCategoryModel = selectedCategoryModel ?? category.first;

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
      subCategory.clear();
      final dynamic response;
      if (selectedServiceTypeForChange == ServiceTypeEnum.EQUIPMENT) {
        response = await _adApiClient.getEqSubCategoryList('$categoryId');
      } else if (selectedServiceTypeForChange == ServiceTypeEnum.MACHINARY) {
        response = await _networkClient.aliGet(
            path: '/$categoryId/sub_category',
            fromJson: (json) {
              List<dynamic> data = json['categories'];
              List<SubCategory> result =
                  data.map((e) => SubCategory.fromJson(e)).toList();
              return result;
            });
      } else if (selectedServiceTypeForChange == ServiceTypeEnum.CM) {
        response = await _adApiClient
            .getCMSubCategoryList((selectedCategoryModel?.id ?? 0).toString());
      } else {
        response = await _adApiClient
            .getSVMSubCategoryList((selectedCategoryModel?.id ?? 0).toString());
      }

      if (response != null) {
        subCategory.addAll(response ?? []);
        subCategory.sort((a, b) => (a.name ?? '').compareTo(b.name ?? ''));
        subCategory.insert(0, SubCategory(name: 'Все подкатегории', id: 0));
        selectedSubCategoryModel = subCategory.first;

        notifyListeners();
      } else {
        throw Exception('Response or adSpecializedMachinery is null');
      }
    } catch (e) {
      debugPrint('Error fetching data: $e');
    }

    notifyListeners();
  }
}
