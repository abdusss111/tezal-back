import 'dart:convert';
import 'dart:math';
import 'package:dio/dio.dart';
import 'package:eqshare_mobile/app/app_safe_change_notifier.dart';
import 'package:eqshare_mobile/src/core/data/models/category_models/category.dart';
import 'package:eqshare_mobile/src/core/data/models/category_models/sub_category.dart';
import 'package:eqshare_mobile/src/core/data/models/cities/city/city_model.dart';
import 'package:eqshare_mobile/src/core/data/repositories/app_general_repo.dart';
import 'package:eqshare_mobile/src/core/data/services/network/api_client/network_client.dart';
import 'package:eqshare_mobile/src/core/data/services/storage/token_provider_service.dart';
import 'package:eqshare_mobile/src/core/presentation/routing/app_route.dart';
import 'package:eqshare_mobile/src/core/res/api_endpoints/api_endpoints.dart';
import 'package:eqshare_mobile/src/features/ad/data/classes/ad_list_row_data.dart';
import 'package:eqshare_mobile/src/features/ad/data/global_fuctions.dart';
import 'package:eqshare_mobile/src/features/ad/data/models/ad_contruction_models/ad_construction_client_model.dart/ad_construction_client_model.dart';
import 'package:eqshare_mobile/src/features/ad/data/models/ad_contruction_models/ad_construction_model/ad_constrution_model.dart';
import 'package:eqshare_mobile/src/features/ad/data/models/ad_equipment_models/ad_equipment_client_model/ad_equipment_client.dart';
import 'package:eqshare_mobile/src/features/ad/data/models/ad_equipment_models/ad_equipment_model/ad_equipment.dart';
import 'package:eqshare_mobile/src/features/ad/data/models/ad_service_models/ad_service_client_model/ad_service_client_model.dart';
import 'package:eqshare_mobile/src/features/ad/data/models/ad_service_models/ad_service_model/ad_service_model.dart';
import 'package:eqshare_mobile/src/features/ad/data/models/ad_sm_models/ad_sm_client_model/ad_client.dart';
import 'package:eqshare_mobile/src/features/ad/data/models/ad_sm_models/ad_sm_model/ad_specialized_machinery.dart';
import 'package:eqshare_mobile/src/features/ad/data/repository/ad_api_client.dart';
import 'package:eqshare_mobile/src/features/global_search/widgets/search_results_screen/city_picker_modal.dart';
import 'package:eqshare_mobile/src/features/main/profile/profile_page/profile_controller.dart';
import 'package:eqshare_mobile/src/global_widgets/global_values.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchResultsScreenController extends AppSafeChangeNotifier {
  Set<AllServiceTypeEnum> uniqueServiceTypes = {};
  int? currentScreenIndex;
  bool _hasMore = true;
  bool get hasMore => _hasMore;

  bool _isLoadingPaginator = false;
  bool get isLoadingPaginator => _isLoadingPaginator;

  SearchResultsScreenController({
    required this.pickedId,
    required this.serviceTypeEnum,
    required this.searchText,
  }) {
    init();
  }

  final AdApiClient adApiClient = AdApiClient();
  final String searchText;
  final AllServiceTypeEnum serviceTypeEnum;
  int pickedId;
  int? selectedCityId;
  List<City> cities = [];
  City? selectedCity;
  bool _isLoading = true;
  bool get isLoading => _isLoading;
  int offset = 0;
  final int limit = 10;

  int showAdsId = 0;
  List<AdListRowData> _showData = [];
  List<AdListRowData> get showData => _showData;

  List<Category> listOfCategory = [];
  List<SubCategory> listOfSubCategory = [];
  Category? selectedCategory;
  SubCategory? selectedSubCategory;
  Map<String, String> activeFilters = {};

  Future<void> fetchCities() async {
    try {
      cities = await AppGeneralRepo().getCities();
      await _loadSelectedCity();
    } catch (e) {
      debugPrint('Error fetching cities: $e');
    }
  }

  Future<void> _loadSelectedCity() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final cityJson = prefs.getString('selectedCity');

    if (cityJson != null) {
      selectedCity = City.fromJson(jsonDecode(cityJson));
      selectedCityId = selectedCity?.id;
    }

    notifyListeners();
  }

  void showCityModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return cities.isEmpty
            ? Center(child: Text('Города не найдены'))
            : CityPickerModal(
          cities: cities,
          onSelect: (City city) async {
            _isLoading = true;
            selectedCity = city;
            selectedCityId = city.id;

            final SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.setString('selectedCity', jsonEncode(city.toJson()));

            fetchData(searchText, filters: activeFilters, cityId: selectedCity?.id);
            notifyListeners();
            Navigator.pop(context);
          },
        );
      },
    );
  }

  Future<void> applyFilters(Map<String, String> filters) async {
    _isLoading = true;
    activeFilters = filters;
    offset = 0;
    _showData.clear();
    notifyListeners();
    await fetchData(searchText, filters: filters, cityId: selectedCityId);
  }


  void clearFilters() {
    _isLoading = true;
    activeFilters.clear();
    _showData.clear();
    fetchData(searchText, cityId: selectedCityId);
    notifyListeners();
  }

  void clearCity() {
    _isLoading = true;
    selectedCity = null;
    selectedCityId = null;
    _showData.clear();
    fetchData(searchText, filters: activeFilters);
    notifyListeners();
  }

  List<SortAlgorithmEnum> sortsType = [
    SortAlgorithmEnum.ascCreatedAt,
    SortAlgorithmEnum.descCreatedAt,
    SortAlgorithmEnum.ascPrice,
    SortAlgorithmEnum.descPrice
  ];

  SortAlgorithmEnum selectedSortAlgorithmEnum = SortAlgorithmEnum.ascCreatedAt;

  Future<void> init() async {
    await fetchAllCategory();
    await fetchData(searchText);
    await fetchCities();
  }

  void setSelectedCategory(Category value) {
    selectedCategory = value;
    fetchAllSubCategory(value.id.toString());
    notifyListeners();
  }

  void setSelectedSubCategory(SubCategory value) {
    selectedSubCategory = value;
    notifyListeners();
  }

  Future<void> setSelectedSortAlgorithmEnum(SortAlgorithmEnum value) async {
    selectedSortAlgorithmEnum = value;
    _isLoading = true;
    notifyListeners();

    await sortAllData();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> sortAllData() async {
    _showData = List.from(getSortData(_showData, sortType: selectedSortAlgorithmEnum));
    notifyListeners();
  }

  void setSelecteAD(int value) {
    pickedId = value;
    notifyListeners();
  }

  Future<void> fetchAllCategory() async {
    try {
      dynamic response;
      if (serviceTypeEnum == AllServiceTypeEnum.EQUIPMENT ||
          serviceTypeEnum == AllServiceTypeEnum.EQUIPMENT_CLIENT) {
        response = await adApiClient.getEqCategoryList();
      } else if (serviceTypeEnum == AllServiceTypeEnum.MACHINARY ||
          serviceTypeEnum == AllServiceTypeEnum.MACHINARY_CLIENT) {
        response = await adApiClient.getSMCategoryList();
      } else if (serviceTypeEnum == AllServiceTypeEnum.CM ||
          serviceTypeEnum == AllServiceTypeEnum.CM_CLIENT) {
        response = await adApiClient.getCMCategoryList();
      } else {
        response = await adApiClient.getSVMCategoryList();
      }

      if (listOfCategory.isNotEmpty) {
        listOfCategory.clear();
      }

      if (response != null) {
        listOfCategory.sort((a, b) => (a.name ?? '').compareTo(b.name ?? ''));
        listOfCategory.insert(
            0, Category(name: DefaultNames.allCategories.name, id: 0));

        listOfCategory.addAll(response);

        selectedCategory = selectedCategory ?? listOfCategory.first;
      } else {
        throw Exception('Response or adSpecializedMachinery is null');
      }
    } catch (e) {
      debugPrint('Error fetching data: $e');
    }
  }

  Future<void> fetchAllSubCategory(String categoryId) async {
    try {
      listOfSubCategory.clear();
      final List<SubCategory>? response;
      if (serviceTypeEnum == AllServiceTypeEnum.EQUIPMENT ||
          serviceTypeEnum == AllServiceTypeEnum.EQUIPMENT_CLIENT) {
        response = await adApiClient.getEqSubCategoryList(categoryId.toString());
      } else if (serviceTypeEnum == AllServiceTypeEnum.MACHINARY ||
          serviceTypeEnum == AllServiceTypeEnum.MACHINARY_CLIENT) {
        response = await NetworkClient().aliGet(
            path: '/$categoryId/sub_category',
            fromJson: (json) {
              List<dynamic> data = json['categories'];
              List<SubCategory> result =
              data.map((e) => SubCategory.fromJson(e)).toList();
              return result;
            });
      } else if (serviceTypeEnum == AllServiceTypeEnum.CM ||
          serviceTypeEnum == AllServiceTypeEnum.CM_CLIENT) {
        response = await adApiClient.getCMSubCategoryList((categoryId).toString());
      } else {
        response = await adApiClient.getSVMSubCategoryList((categoryId).toString());
      }
      if (listOfSubCategory.isNotEmpty) {
        listOfSubCategory.clear();
      }

      if (response != null) {
        listOfSubCategory.addAll(response);
        listOfSubCategory.sort((a, b) => (a.name ?? '').compareTo(b.name ?? ''));
        listOfSubCategory.insert(
            0, SubCategory(name: 'Все подкатегории', id: 0));
        selectedSubCategory = listOfSubCategory.first;

        notifyListeners();
      } else {
        throw Exception('Response or adSpecializedMachinery is null');
      }
    } catch (e) {
      debugPrint('Error fetching data: $e');
    }

    notifyListeners();
  }

  Future<void> loadMoreData() async {
    if (_isLoadingPaginator || !_hasMore) return;

    _isLoadingPaginator = true;
    notifyListeners();

    offset += limit;

    await fetchData(
      searchText,
      filters: activeFilters,
      cityId: selectedCityId,
      offset: offset,
      limit: limit,
    );

    _isLoadingPaginator = false;
    notifyListeners();
  }



  Future<void> fetchData(
      String searchQuery, {
        Map<String, String>? filters,
        int? cityId,
        int offset = 0,
        int limit = 10,

      }) async {
    print('🚀 fetchData вызван! searchQuery: $searchQuery, cityId: $cityId, offset: $offset');

    if (searchQuery.isEmpty) return;

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final cityJson = prefs.getString('selectedCity');
    final City? selectedCity =
    cityJson != null ? City.fromJson(jsonDecode(cityJson)) : null;
    final int? cityIdFromPrefs = selectedCity?.id;

    if (cityId == null && cityIdFromPrefs == null) {
      print("⚠️ Город не выбран — поиск будет выполнен по всем городам.");
    }

    final int cityToUse = cityId ?? cityIdFromPrefs ?? 0;

    String filterQuery = filters != null && filters.isNotEmpty
        ? '&${filters.entries.map((e) => '${e.key}=${e.value}').join('&')}'
        : '';

    String cityFilter = cityToUse != 0 && cityToUse != 92 ? '&city_id=$cityToUse' : '';
    String offsetFilter = offset > 0 ? '&offset=$offset' : '';
    String limitFilter = '&limit=$limit'; // ← добавим limit
    final trimmedSearch = searchQuery.trim();

    final String requestUrl =
        '${ApiEndPoints.baseUrl}/search?general=$trimmedSearch$filterQuery$cityFilter$offsetFilter$limitFilter';

    print('🔍 SEARCH QUERY: $requestUrl');

    try {
      final response = await Dio().get(requestUrl);

      if (response.statusCode == 200) {
        final jsonData = response.data;
        final result = jsonData?['result'] as Map<String, dynamic>;

        if (result.isEmpty) {
          print('⚠️ Нет данных.');
          if (offset == 0) _showData.clear();
          _isLoading = false;
          notifyListeners();
          return;
        }

        print('📩 Ответ API: $result');

        List<AdSpecializedMachinery> adSMList = [];
        List<AdClient> adClients = [];
        List<AdEquipment> eqList = [];
        List<AdEquipmentClient> adEqClients = [];
        List<AdConstrutionModel> cmList = [];
        List<AdConstructionClientModel> cmClientList = [];
        List<AdServiceModel> svmList = [];
        List<AdServiceClientModel> svmClientList = [];

        final List<dynamic> adClientsJson = result['ad_clients'] ?? [];
        final List<dynamic> adSMListJson = result['ad_specialized_machineries'] ?? [];
        final List<dynamic> adEqClientsJson = result['ad_equipment_clients'] ?? [];
        final List<dynamic> eqListJson = result['ad_equipments'] ?? [];
        final List<dynamic> cmListJson = result['ad_construction_material'] ?? [];
        final List<dynamic> cmClientListJson = result['ad_construction_material_clients'] ?? [];
        final List<dynamic> svmListJson = result['ad_service'] ?? [];
        final List<dynamic> svmClientListJson = result['ad_service_clients'] ?? [];

        if (adSMListJson.isNotEmpty) {
          adSMList = adSMListJson.map((e) => AdSpecializedMachinery.fromJson(e)).toList();
        }
        if (adClientsJson.isNotEmpty) {
          adClients = adClientsJson.map((e) => AdClient.fromJson(e)).toList();
        }
        if (eqListJson.isNotEmpty) {
          eqList = eqListJson.map((e) => AdEquipment.fromJson(e)).toList();
        }
        if (adEqClientsJson.isNotEmpty) {
          adEqClients = adEqClientsJson.map((e) => AdEquipmentClient.fromJson(e)).toList();
        }
        if (cmListJson.isNotEmpty) {
          cmList = cmListJson.map((e) => AdConstrutionModel.fromJson(e)).toList();
        }
        if (cmClientListJson.isNotEmpty) {
          cmClientList = cmClientListJson.map((e) => AdConstructionClientModel.fromJson(e)).toList();
        }
        if (svmListJson.isNotEmpty) {
          svmList = svmListJson.map((e) => AdServiceModel.fromJson(e)).toList();
        }
        if (svmClientListJson.isNotEmpty) {
          svmClientList = svmClientListJson.map((e) => AdServiceClientModel.fromJson(e)).toList();
        }

        final payload = await getPayload();

        if (offset == 0) {
          _showData.clear();

        }
        final int loadedCountBefore = _showData.length;

        if (payload == null || payload.aud == 'CLIENT' || payload.aud == 'GUEST') {
          _showData.addAll(adSMList.map((e) => AdSpecializedMachinery.getAdListRowDataFromSM(e)));
          _showData.addAll(eqList.map((e) => AdEquipment.getAdListRowDataFromSM(e)));
          _showData.addAll(cmList.map((e) => AdConstrutionModel.getAdListRowDataFromSM(e)));
          _showData.addAll(svmList.map((e) => AdServiceModel.getAdListRowDataFromSM(e)));
        } else {
          _showData.addAll(adClients.map((e) => AdClient.getAdListRowDataFromSM(e)));
          _showData.addAll(adEqClients.map((e) => AdEquipmentClient.getAdListRowDataFromSM(e)));
          _showData.addAll(cmClientList.map((e) => AdConstructionClientModel.getAdListRowDataFromSM(e)));
          _showData.addAll(svmClientList.map((e) => AdServiceClientModel.getAdListRowDataFromSM(e)));
        }
        final int loadedCountAfter = _showData.length;
        final int justLoaded = loadedCountAfter - loadedCountBefore;

        _hasMore = justLoaded == limit;

        // Обновляем общее количество (если API возвращает эту информацию)

        await sortAllData();

        print('✅ Итоговое количество объявлений: ${_showData.length}');
        getTabCount();
      } else {
        throw Exception('❌ Ошибка загрузки данных');
      }
    } catch (e) {
      print('❌ Ошибка при загрузке данных: $e');
      if (offset == 0) _showData.clear();
    }

    _isLoading = false;
    notifyListeners();

  }

  void getTabCount() {
    uniqueServiceTypes.clear();

    for (var ad in showData) {
      if (ad.allServiceTypeEnum != null) {
        uniqueServiceTypes.add(ad.allServiceTypeEnum!);
      }
    }

    final index = uniqueServiceTypes.toList().indexOf(serviceTypeEnum);
    currentScreenIndex = (index >= 0) ? index : 0;
  }

  Future<void> pushToPage(
      BuildContext context, int id, AllServiceTypeEnum serviceTypeEnum) async {
    final map = {'id': id.toString()};
    switch (serviceTypeEnum) {
      case AllServiceTypeEnum.MACHINARY:
        context.pushNamed(AppRouteNames.adSMDetail, extra: map);
        break;

      case AllServiceTypeEnum.MACHINARY_CLIENT:
        context.pushNamed(AppRouteNames.adSMClientDetail, extra: map);
        break;

      case AllServiceTypeEnum.EQUIPMENT:
        context.pushNamed(AppRouteNames.adEquipmentDetail, extra: map);
        break;

      case AllServiceTypeEnum.EQUIPMENT_CLIENT:
        context.pushNamed(AppRouteNames.adEquipmentClientDetail, extra: map);
        break;

      case AllServiceTypeEnum.CM:
        context.pushNamed(AppRouteNames.adConstructionDetail, extra: map);
        break;

      case AllServiceTypeEnum.CM_CLIENT:
        context.pushNamed(AppRouteNames.adConstructionDetail, extra: map);
        break;

      case AllServiceTypeEnum.SVM:
        context.pushNamed(AppRouteNames.adServiceDetailScreen, extra: map);
        break;

      case AllServiceTypeEnum.SVM_CLIENT:
        context.pushNamed(AppRouteNames.adServiceClientDetailScreen, extra: map);
        break;

      default:
        context.pop();
        break;
    }
  }

  Future<UserMode> getUserMode() async {
    final token = await TokenService().getToken();
    if (token == null) {
      return UserMode.guest;
    } else {
      final payload = TokenService().extractPayloadFromToken(token);
      switch (payload.aud) {
        case TokenService.driverAudience:
          return UserMode.driver;
        case TokenService.ownerAudience:
          return UserMode.owner;
        case TokenService.clientAudience:
          return UserMode.client;
        default:
          return UserMode.guest;
      }
    }
  }
}