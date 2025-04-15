import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:eqshare_mobile/src/core/data/models/category_models/category.dart';
import 'package:eqshare_mobile/src/core/data/models/category_models/sub_category.dart';
import 'package:eqshare_mobile/src/core/res/api_endpoints/api_endpoints.dart';
import 'package:eqshare_mobile/src/features/ad/data/repository/ad_api_client.dart';
import 'package:eqshare_mobile/src/features/ad/data/repository/ad_construction_materials_repository.dart';
import 'package:eqshare_mobile/src/features/ad/data/repository/ad_service_repository.dart';
import 'package:eqshare_mobile/src/features/main/location/ad_in_map/ad_data_handler.dart';
import 'package:eqshare_mobile/src/global_widgets/global_values.dart';

class SmListMapRepository {
  final Dio dio = Dio();
  CancelToken? _cancelToken; // Токен для отмены запроса

  final adServiceRepo = AdServiceRepository();
  final adCMRepo = AdConstructionMaterialsRepository();
  final adRepo = AdApiClient();
  final adDataHandlerFactory = DataHandlerFactory();

  Future<List<dynamic>> getSearchListData(ServiceTypeEnum pickedServiceType,
      {required String searchQuery, required int cityId}) async {
    // Отменяем предыдущий запрос, если он еще выполняется
    if (_cancelToken?.isCancelled == false) {
      _cancelToken?.cancel("Отменено новым запросом");
    }
    _cancelToken = CancelToken(); // Создаем новый токен

    try {
      final response = await dio.get(
        '${ApiEndPoints.baseUrl}/search',
        queryParameters: {
          'general': searchQuery,
          'city_id': cityId
        },
        cancelToken: _cancelToken, // Передаем токен в запрос
      );
      print("FETCH SEARCH ${ApiEndPoints.baseUrl}");
      print("FETCH SEARCH ${cityId}");
      print("FETCH SEARCH ${searchQuery}");

      if (response.statusCode == 200) {
        final AdDataHandler dataHandler =
        DataHandlerFactory.getHandler(pickedServiceType);
        final List<dynamic> jsonData = dataHandler.parseData(response.data);
        print("FETCH SEARCH ${jsonData.toString()}");
        // Фильтрация данных
        final filteredData = jsonData.where((item) {
          return item.toString().toLowerCase().contains(searchQuery.toLowerCase());
        }).toList();

        final List<dynamic> objects = dataHandler.createObjects(filteredData);
        return objects;
      } else {
        log("Status code: \${response.statusCode} ", error: response);
        return [];
      }
    } on DioException catch (e) {
      if (CancelToken.isCancel(e)) {
        log("Запрос отменен: \${e.message}");
      }
      return [];
    } catch (e) {
      log("Ошибка запроса: \${e.toString()}");
      return [];
    }
  }

  Future<List<Category>?> getAllCategories(
      ServiceTypeEnum pickedServiceEnum) async {
    try {
      switch (pickedServiceEnum) {
        case ServiceTypeEnum.MACHINARY:
          return adRepo.getSMCategoryList();
        case ServiceTypeEnum.EQUIPMENT:
          return adRepo.getEqCategoryList();
        case ServiceTypeEnum.CM:
          return adRepo.getCMCategoryList();
        case ServiceTypeEnum.SVM:
          return adRepo.getSVMCategoryList();
        default:
          return adRepo.getSMCategoryList();
      }
    } on Exception catch (e) {
      log("Ошибка при получении категорий: \${e.toString()}");
      rethrow;
    }
  }

  Future<List<SubCategory>?> getAllSubCategories(
      ServiceTypeEnum pickedServiceEnum,
      {required int mainCategoryID}) async {
    try {
      switch (pickedServiceEnum) {
        case ServiceTypeEnum.MACHINARY:
          return adRepo.getSmSubCategoryList(mainCategoryID.toString());
        case ServiceTypeEnum.EQUIPMENT:
          return adRepo.getEqSubCategoryList(mainCategoryID.toString());
        case ServiceTypeEnum.CM:
          return adRepo.getCMSubCategoryList(mainCategoryID.toString());
        case ServiceTypeEnum.SVM:
          return adRepo.getSVMSubCategoryList(mainCategoryID.toString());
        default:
          return adRepo.getSmSubCategoryList(mainCategoryID.toString());
      }
    } on Exception catch (e) {
      log("Ошибка при получении подкатегорий: \${e.toString()}");
      rethrow;
    }
  }

  Future<List<dynamic>?> getData(
      ServiceTypeEnum pickedServiceType, {int? categoryID, int? subCategoryID, int? cityID}) async {
    try {
      final adDataHandler = DataHandlerFactory.getHandler(pickedServiceType);
      final List<dynamic>? data = await adDataHandler.getDataFromServer(
          categoryID: categoryID, subCategoryID: subCategoryID, cityID: cityID);
      return data;
    } on Exception catch (e) {
      log("Ошибка при получении данных: \${e.toString()}");
      rethrow;
    }
  }
}
