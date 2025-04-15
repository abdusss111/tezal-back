import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:eqshare_mobile/src/core/data/models/brand/brand.dart';
import 'package:eqshare_mobile/src/core/data/models/category_models/category.dart';
import 'package:eqshare_mobile/src/core/data/models/category_models/sub_category.dart';
import 'package:eqshare_mobile/src/core/data/services/network/api_client/network_client.dart';

import 'package:eqshare_mobile/src/core/data/models/payload/payload.dart';
import 'package:eqshare_mobile/src/core/data/services/storage/token_provider_service.dart';
import 'package:eqshare_mobile/src/core/presentation/utils/date_format_helper.dart';
import 'package:eqshare_mobile/src/core/res/api_endpoints/api_endpoints.dart';
import 'package:eqshare_mobile/src/features/ad/data/models/ad_client_interacted_model/ad_client_interacted.dart';
import 'package:eqshare_mobile/src/global_widgets/global_values.dart';
import 'package:eqshare_mobile/src/features/ad/data/models/ad_service_models/ad_service_client_model/ad_service_client_model.dart';
import 'package:eqshare_mobile/src/features/ad/data/models/ad_service_models/ad_service_model/ad_service_model.dart';
import 'package:intl/intl.dart';

class AdServiceRepository {
  final baseUrl = ApiEndPoints.baseUrl;
  final dio = Dio();
  final tokenService = TokenService();
  final _networkClient = NetworkClient();

  Future<Payload> getPayload() async {
    final token = await tokenService.getToken();
    final payload = tokenService.extractPayloadFromToken(token!);
    return payload;
  }

  Future<Payload?> getPayloadWithNull() async {
    final token = await tokenService.getToken();
    if (token != null) {
      final payload = tokenService.extractPayloadFromToken(token);
      return payload;
    }
    return null;
  }

  Future<List<AdServiceClientModel>?> getAdServiceListForDriverOrOwner({
    Map<String, dynamic>? qmap,
    int? selectedCategory,
    int? selectedSubCategory,
    String? userID,
  }) async {
    final Map<String, dynamic> queryParameters = {
      'user_detail': 'true',
      'city_detail': 'true',
      'document_detail': 'true',
      if (userID != null) 'user_id': userID,
      if (selectedSubCategory != null && selectedSubCategory != 0)
        'service_subcategory_id': selectedSubCategory,
      if (selectedCategory != null && selectedCategory != 0)
        'service_category_id': selectedCategory,
    };
    if (qmap != null && qmap.isNotEmpty) {
      queryParameters.addAll(qmap);
    }
    try {
      final response = await dio.get('$baseUrl/service/ad_service_client',
          queryParameters: queryParameters);
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['ad_service_clients'];
        final List<AdServiceClientModel> result =
            data.map((e) => AdServiceClientModel.fromJson(e)).toList();
        if (queryParameters.containsKey('ASC')) {
          if (queryParameters.containsValue('price')) {
            return result
              ..sort((a, b) => (a.price ?? 0).compareTo(b.price ?? 0));
          } else {
            return result
              ..sort((a, b) => (DateTimeUtils()
                          .formatDateFromyyyyMMddTHHmmssSSSSSSSS(
                              b.createdAt ?? DateTime.now().toString()) ??
                      DateTime.now())
                  .compareTo(DateTimeUtils()
                          .formatDateFromyyyyMMddTHHmmssSSSSSSSS(
                              a.createdAt ?? DateTime.now().toString()) ??
                      DateTime.now()));
          }
        }
        if (queryParameters.containsKey('DESC')) {
          return result..sort((a, b) => (b.price ?? 0).compareTo(a.price ?? 0));
        }
        return result;
      }
    } catch (e) {
      printLog(e, 'getAdServiceListForDriverOrOwner');
    }
    return null;
  }

  Future<List<dynamic>?> getAdServiceListForDriverOrOwnerWithPaginator(
      {Map<String, dynamic>? qmap}) async {
    final Map<String, dynamic> queryParameters = {
      'user_detail': 'true',
      'city_detail': 'true',
      'document_detail': 'true',
    };
    if (qmap != null && qmap.isNotEmpty) {
      queryParameters.addAll(qmap);
    }
    try {
      final response = await dio.get('$baseUrl/service/ad_service_client',
          queryParameters: queryParameters);
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['ad_service_clients'];
        final List<AdServiceClientModel> result =
            data.map((e) => AdServiceClientModel.fromJson(e)).toList();
        final total = response.data['total'];
        if (queryParameters.containsKey('ASC')) {
          if (queryParameters.containsValue('price')) {
            return [
              result..sort((a, b) => (a.price ?? 0).compareTo(b.price ?? 0)),
              total
            ];
          } else {
            return [
              result
                ..sort((a, b) => (DateTimeUtils()
                            .formatDateFromyyyyMMddTHHmmssSSSSSSSS(
                                b.createdAt ?? DateTime.now().toString()) ??
                        DateTime.now())
                    .compareTo(DateTimeUtils()
                            .formatDateFromyyyyMMddTHHmmssSSSSSSSS(
                                a.createdAt ?? DateTime.now().toString()) ??
                        DateTime.now())),
              total
            ];
          }
        }
        if (queryParameters.containsKey('DESC')) {
          return [
            result..sort((a, b) => (b.price ?? 0).compareTo(a.price ?? 0)),
            total
          ];
        }
        return [result, total];
      }
    } catch (e) {
      printLog(e, 'getAdServiceListForDriverOrOwner');
    }
    return null;
  }

  Future<List<AdServiceModel>?> getAdServiceListForClient({
    Map<String, dynamic>? queryParametersFromPage,
    int? selectedCategory,
    int? selectedSubCategory,
    String? userID,
  }) async {
    final Map<String, dynamic> queryParameters = {
      'user_detail': 'true',
      'city_detail': 'true',
      'document_detail': 'true',
      if (userID != null) 'user_id': userID,
      if (selectedSubCategory != null && selectedSubCategory != 0)
        'service_subcategory_id': selectedSubCategory,
      if (selectedCategory != null && selectedCategory != 0)
        'service_category_id': selectedCategory,
    };
    if (queryParametersFromPage != null) {
      queryParameters.addAll(queryParametersFromPage);
    }
    try {
      final response = await dio.get('$baseUrl/service/ad_service',
          queryParameters: queryParameters);
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['ad_services'];
        final List<AdServiceModel> result =
            data.map((e) => AdServiceModel.fromJson(e)).toList();

        if (queryParameters.containsKey('ASC'.toLowerCase())) {
          if (queryParameters.containsValue('price')) {
            result;
          } else {
            return result
              ..sort((b, a) => (DateTimeUtils()
                          .formatDateFromyyyyMMddTHHmmssSSSSSSSS(
                              b.createdAt ?? DateTime.now().toString()) ??
                      DateTime.now())
                  .compareTo(DateTimeUtils()
                          .formatDateFromyyyyMMddTHHmmssSSSSSSSS(
                              a.createdAt ?? DateTime.now().toString()) ??
                      DateTime.now()));
          }
        }
        return result;
      }
    } catch (e) {
      printLog(e, 'getAdServiceListForClient');
    }
    return null;
  }

  Future<List<dynamic>?> getAdServiceListForClientWithPaginator(
      {Map<String, dynamic>? queryParametersFromPage}) async {
    final Map<String, dynamic> queryParameters = {
      'user_detail': 'true',
      'city_detail': 'true',
      'document_detail': 'true',
    };
    if (queryParametersFromPage != null) {
      queryParameters.addAll(queryParametersFromPage);
    }
    try {
      final response = await dio.get('$baseUrl/service/ad_service',
          queryParameters: queryParameters);
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['ad_services'];
        final total = response.data['total'];

        final List<AdServiceModel> result =
            data.map((e) => AdServiceModel.fromJson(e)).toList();

        if (queryParameters.containsKey('ASC'.toLowerCase())) {
          if (queryParameters.containsValue('price')) {
            result;
          } else {
            return [
              result
                ..sort((b, a) => (DateTimeUtils()
                            .formatDateFromyyyyMMddTHHmmssSSSSSSSS(
                                b.createdAt ?? DateTime.now().toString()) ??
                        DateTime.now())
                    .compareTo(DateTimeUtils()
                            .formatDateFromyyyyMMddTHHmmssSSSSSSSS(
                                a.createdAt ?? DateTime.now().toString()) ??
                        DateTime.now())),
              total
            ];
          }
        }
        return [result, total];
      }
    } catch (e) {
      printLog(e, 'getAdServiceListForClient');
    }
    return null;
  }

  Future<bool> postClientAdService(
      {required String description,
      required String address,
      required int cityID,
      DateTime? endLeaseDate,
      required double latitude,
      required double longitude,
      required double price,
      required int serviceSubcategoryID,
      required DateTime startLeaseDate,
      required String status,
      required List<String> images,
      required String title}) async {
    final formData = FormData.fromMap({
      'base': jsonEncode({
        "address": address,
        "city_id": cityID,
        "description": description,
        if (endLeaseDate != null)
          "end_lease_date":
              dateFormatWithyyyyMMddTHHmmssSSSSSSSSS(endLeaseDate),
        "latitude": latitude,
        "longitude": longitude,
        "price": price,
        "service_subcategory_id": serviceSubcategoryID,
        "start_lease_date":
            dateFormatWithyyyyMMddTHHmmssSSSSSSSSS(startLeaseDate),
        "status": RequestStatus.CREATED.name,
        "title": title
      })
    });
    if (images.isNotEmpty) {
      for (int i = 0; i < images.length; i++) {
        File imageFile = File(images[i]);
        formData.files.add(MapEntry(
          'foto',
          await MultipartFile.fromFile(imageFile.path),
        ));
      }
    }
    try {
      final headers = await getAuthHeaders();
      final response = await dio.post('$baseUrl/service/ad_service_client',
          data: formData, options: Options(headers: headers));
      if (response.statusCode == 200) {
        return true;
      }
    } on Exception catch (e) {
      printLog(e, 'postClientAdService');
    }
    return false;
  }

  Future<bool> editClientAdService(
      {required int id,
      required String description,
      required String address,
      required int cityID,
      required int userID,
      DateTime? endLeaseDate,
      required double latitude,
      required double longitude,
      required double price,
      required int serviceSubcategoryID,
      required DateTime startLeaseDate,
      required String status,
      required List<String> images,
      required String title}) async {
    final formData = {
      "address": address,
      "city_id": cityID,
      "description": description,
      if (endLeaseDate != null)
        "end_lease_date": DateTimeUtils().dateFormatForUpdate(endLeaseDate),
      "latitude": latitude,
      "longitude": longitude,
      "price": price,
      "service_subcategory_id": serviceSubcategoryID,
      "start_lease_date": DateTimeUtils().dateFormatForUpdate(startLeaseDate),
      // dateFormatWithyyyyMMddTHHmmssSSSSSSSSS(startLeaseDate),
      "status": RequestStatus.CREATED.name,
      "title": title,
      ' user_id': userID,
    };
    // if (images.isNotEmpty) {
    //   for (int i = 0; i < images.length; i++) {
    //     File imageFile = File(images[i]);
    //     formData.files.add(MapEntry(
    //       'foto',
    //       await MultipartFile.fromFile(imageFile.path),
    //     ));
    //   }
    // }
    try {
      final headers = await getAuthHeaders();
      final response = await dio.put('$baseUrl/service/ad_service_client/$id',
          data: formData, options: Options(headers: headers));
      if (response.statusCode == 200) {
        return true;
      }
    } on Exception catch (e) {
      printLog(e, 'postClientAdService');
      //"invalid start lease date expected format 2006-01-02 15:04:05.000000: parsing time "2024-09-19T00:10:00.000000000Z" as "2006-01-0…"
      // "invalid start lease date expected format 2006-01-02 15:04:05.000000: parsing time "2024-09-19 00:10:00.000Z" as "2006-01-02 15:0…"
    }
    return false;
  }

  Future<bool> postDriverOrOwnerAdService(
      {required String description,
      required String title,
      required String address,
      required int price,
      required int serviceBrandId,
      required int serviceSubCategoryID,
      required double latitude,
      required double longitude,
      required List<String> images,
      required int cityID,
      Map<String, dynamic>? params}) async {
    final map = {
      "address": address,
      "city_id": cityID,
      "description": description,
      "latitude": latitude,
      "longitude": longitude,
      "price": price,
      "service_brand_id": 1, // ! Важно возможно у услугг не будет бренд
      "service_sub_сategory_id": serviceSubCategoryID,
      "title": title,
      if (params != null) 'params': params
    };

    log(map.toString());
    final formData = FormData.fromMap({'base': jsonEncode(map)});

    if (images.isNotEmpty) {
      for (int i = 0; i < images.length; i++) {
        File imageFile = File(images[i]);
        formData.files.add(MapEntry(
          'foto',
          await MultipartFile.fromFile(imageFile.path),
        ));
      }
    }

    try {
      final headers = await getAuthHeaders();
      final response = await dio.post('$baseUrl/service/ad_service',
          data: formData, options: Options(headers: headers));
      if (response.statusCode == 200) {
        return true;
      }
    } on Exception catch (e) {
      printLog(e, 'postDriverOrOwnerAdService');
    }
    return false;
  }

  Future<bool> updateDriverOrOwnerAdService({
    required int userID,
    required String id,
    required String description,
    required String title,
    required String address,
    required int price,
    required int serviceBrandId,
    required int serviceSubCategoryID,
    required double latitude,
    required double longitude,
    required List<String> images,
    required int cityID,
  }) async {
    final map = {
      'user_id': userID,
      "address": address,
      "city_id": cityID,
      "description": description,
      "latitude": latitude,
      "longitude": longitude,
      "price": price.toDouble(),
      "service_brand_id": 1, // ! Важно возможно у услугг не будет бренд
      "service_subcategory_id": serviceSubCategoryID,
      "title": title,
    };

    try {
      final headers = await getAuthHeaders();
      final response = await dio.put(
          '$baseUrl/service/ad_service/${int.parse(id)}',
          data: map,
          options: Options(headers: headers));
      if (response.statusCode == 200) {
        return true;
      }
    } on Exception catch (e) {
      printLog(e, 'postDriverOrOwnerAdService');
    }
    return false;
  }

  Future<bool> checkIsAdServiceISFavouriteForClient(
      {required int aadServiceID}) async {
    final path = '$baseUrl/service/ad_service/favorite';
    try {
      final headers = await getAuthHeaders();
      final resposne = await dio.get(path, options: Options(headers: headers));

      if (resposne.statusCode == 200) {
        final List<dynamic> data = resposne.data['favorites'];
        final List<FavoritesForClient> result =
            data.map((e) => FavoritesForClient.fromJson(e)).toList();

        for (var element in result) {
          if (aadServiceID == element.id) {
            return true;
          }
        }
      } //"token is malformed: token contains an invalid number of segments"
    } on Exception catch (e) {
      printLog(e, 'checkIsAdServiceISFavouriteForClient');
    }
    return false;
  }

  Future<bool> checkIsAdServiceISFavouriteForDriverOrOwner(
      int aadServiceID) async {
    final path = '$baseUrl/service/ad_service_client/favorite';
    try {
      final headers = await getAuthHeaders();
      final resposne = await dio.get(path, options: Options(headers: headers));

      if (resposne.statusCode == 200) {
        final List<dynamic> data = resposne.data['favorites'];
        final List<FavoritesForDriver> result =
            data.map((e) => FavoritesForDriver.fromJson(e)).toList();

        for (var element in result) {
          if (aadServiceID == element.id) {
            return true;
          }
        }
      }
    } on Exception catch (e) {
      printLog(e, 'checkIsAdServiceISFavouriteForClient');
    }
    return false;
  }

  Future<bool> adForFavouriteADDriverOrOwnerServiceFromClientAccount(
      String id) async {
    final path = '$baseUrl/service/ad_service/$id/favorite';

    try {
      final headers = await getAuthHeaders();

      final response = await dio.post(path, options: Options(headers: headers));
      if (response.statusCode == 200) {
        log('Success');
        return true;
      }
    } catch (e) {
      printLog(e, 'adForFavouriteADDriverOrOwnerServiceFromClientAccount');
    }
    return false;
  }

  Future<bool> adForFavouriteADClientServiceFromDriverOrOwnerAccount(
      String id) async {
    final path = '$baseUrl/service/ad_service_client/$id/favorite';

    try {
      final headers = await getAuthHeaders();

      final response = await dio.post(path, options: Options(headers: headers));
      if (response.statusCode == 200) {
        log('Success');
        return true;
      }
    } catch (e) {
      printLog(e, 'adForFavouriteADClientServiceFromDriverOrOwnerAccount');
    }
    return false;
  }

  Future<bool> deleteFavouriteADDriverOrOwnerServiceFromClientAccount(
      String id) async {
    final path = '$baseUrl/service/ad_service/$id/favorite';

    try {
      final headers = await getAuthHeaders();

      final response =
          await dio.delete(path, options: Options(headers: headers));
      if (response.statusCode == 200) {
        log('Delete success');
        return false;
      }
    } catch (e) {
      printLog(e, 'adForFavouriteADDriverOrOwnerServiceFromClientAccount');
    }
    return true;
  } //TODO

  Future<bool> deleteFavouriteADClientServiceFromDriverOrOwnerAccount(
      String id) async {
    final path = '$baseUrl/service/ad_service_client/$id/favorite';

    try {
      final headers = await getAuthHeaders();

      final response =
          await dio.delete(path, options: Options(headers: headers));
      if (response.statusCode == 200) {
        log('Delete success');
        return false;
      }
    } catch (e) {
      printLog(e, 'deleteFavouriteADClientServiceFromDriverOrOwnerAccount');
    }
    return true;
  } //TODO

  Future<bool> postRequestFromClientTODriverOrOwnerAdService({
    required String address,
    required double latitude,
    required double longitude,
    required int adServiceID,
    int? countHour,
    required String description,
    required List<String> images,
    int orderAmount = 1,
    required DateTime startLeaseAt,
    DateTime? endLeaseAt,
  }) async {
    final path = '$baseUrl/service/request_ad_service';
    final formData = FormData.fromMap({
      'base': jsonEncode({
        "ad_service_id": adServiceID,
        "address": address,
        if (countHour != null) "count_hour": countHour,
        "description": description,
        if (endLeaseAt != null)
          "end_lease_at": dateFormatWithyyyyMMddTHHmmssSSSSSSSSS(endLeaseAt),
        "latitude": latitude,
        "longitude": longitude,
        "order_amount": orderAmount,
        "start_lease_at": dateFormatWithyyyyMMddTHHmmssSSSSSSSSS(startLeaseAt)
      })
    });
    if (images.isNotEmpty) {
      for (int i = 0; i < images.length; i++) {
        File imageFile = File(images[i]);
        formData.files.add(MapEntry(
          'foto',
          await MultipartFile.fromFile(imageFile.path),
        ));
      }
    }
    try {
      final headers = await getAuthHeaders();
      final response = await dio.post(path,
          data: formData, options: Options(headers: headers));
      if (response.statusCode == 200) {
        return true;
      }
    } on Exception catch (e) {
      printLog(e, 'postRequestFromClientTODriverOrOwnerAdService');
    }
    return false;
  }

  Future<bool> postRequestFromDriverOrOwnerTOClientAdService(
      {required String description,
      required int adServiceID,
      required int driverOrOwnerID}) async {
    final formData = {
      "ad_service_client_id": adServiceID,
      "description": description,
      "executor_id": driverOrOwnerID
    };
    try {
      final headers = await getAuthHeaders();
      final response = await dio.post(
          '$baseUrl/service/request_ad_service_client',
          options: Options(headers: headers),
          data: formData);
      if (response.statusCode == 200) {
        return true;
      }
    } catch (e) {
      printLog(
          e, 'postRequestFromDriverOrOwnerTOClientAdService'); // TODO error
    }
    return false;
  }

  Future<void>
      getAuthorPhoneNumberFromOwnerORDriverADServiceTOClient() async {} // TODO
  Future<void>
      getAuthorPhoneNumberFromClientADServiceTOOwnerORDriver() async {} // TODO

  Future<AdServiceClientModel?> getAdServiceDetailForDriverOrOwner(
      {required String adID,
      Map<String, dynamic> queryParameters = const {
        'user_detail': 'true',
        'city_detail': 'true',
        'document_detail': 'true',
      }}) async {
    try {
      final response = await dio.get('$baseUrl/service/ad_service_client/$adID',
          queryParameters: queryParameters);
      if (response.statusCode == 200) {
        final data = response.data['ad_service_client'];
        final AdServiceClientModel result = AdServiceClientModel.fromJson(data);
        return result;
      }
    } catch (e) {
      printLog(e, 'getAdServiceDetailForDriverOrOwner');
    }
    return null;
  }

  Future<AdServiceModel?> getAdServiceDetailForClient(
      {required String adID,
      Map<String, dynamic> queryParameters = const {
        'user_detail': 'true',
        'city_detail': 'true',
        'document_detail': 'true',
      }}) async {
    try {
      final response = await dio.get('$baseUrl/service/ad_service/$adID',
          queryParameters: queryParameters);
      if (response.statusCode == 200) {
        final data = response.data['ad_service'];
        final AdServiceModel result = AdServiceModel.fromJson(data);
        return result;
      }
    } catch (e) {
      printLog(e, 'getAdServiceListForDriverOrOwner');
    }
    return null;
  }

  Future<List<Category>> getAdServiceListCategory() async {
    final path = '$baseUrl/service/category';

    try {
      final response = await dio.get(path);

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['categories'];
        final List<Category> result =
            data.map((e) => Category.fromJson(e)).toList();
        return result;
      }
    } on Exception catch (e) {
      printLog(e, 'getAdServiceListCategory');
    }
    return [];
  }

  Future<Category?> getAdServiceCategoryWithID(int id) async {
    final path = '$baseUrl/service/category/$id';

    try {
      final response = await dio.get(path);

      if (response.statusCode == 200) {
        final dynamic data = response.data['category'];
        final Category result = Category.fromJson(data);
        return result;
      }
    } on Exception catch (e) {
      printLog(e, 'getAdServiceListCategory');
    }
    return null;
  }

  Future<List<SubCategory>> getAdServiceListSubCategory(
      {required int? categoryID}) async {
    final path = '$baseUrl/service/category/${categoryID ?? 0}/sub_category';

    try {
      final response = await dio.get(path);

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['sub_categories'];
        final List<SubCategory> result =
            data.map((e) => SubCategory.fromJson(e)).toList();
        return result;
      }
    } on Exception catch (e) {
      printLog(e, 'getAdServiceListSubCategory');
    }
    return [];
  }

  Future<List<Brand>> getAdServiceListBrand() async {
    final path = '$baseUrl/brand_service';

    try {
      final response = await dio.get(path);

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['brands'];
        final List<Brand> result = data.map((e) => Brand.fromJson(e)).toList();
        return result;
      }
    } on Exception catch (e) {
      printLog(e, 'getAdServiceListBrand');
    }
    return [];
  }

  Future<bool> isThisAdIsFavouriteAd() async {
    return false;
  }

  Future<bool> sendReport(
      {required String adID,
      required int reportReasonID,
      required String reportText}) async {
    try {
      final token = await tokenService.getToken();
      if (token == null) {
        return false;
      }
      final payload = tokenService.extractPayloadFromToken(token);
      String path = '';
      final Map<String, dynamic> map = {};
      if (payload.aud == 'CLIENT') {
        path = '/report/ad/svc';
        map.addAll({
          "ad_service_id": int.parse(adID),
          "description": reportText,
          "report_reasons_id": reportReasonID
        });
      } else {
        path = '/report/ad/svc_client';
        map.addAll({
          "ad_service_client_id": int.parse(adID),
          "description": reportText,
          "report_reasons_id": reportReasonID
        });
      }
      final response = await _networkClient.aliPost(path, map);
      if (response?.statusCode == 200) {
        return true;
      } else {
        throw (response.toString());
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<AdServiceClientModel>?> getMyServiceClient(String clientID,
      {bool unscoped = false}) async {
    final Map<String, dynamic> queryParameters = {
      'user_detail': 'true',
      'city_detail': 'true',
      'documents_detail': 'true',
      if (unscoped) 'unscoped': 'true',
      'user_id': clientID,
      'service_subcategory_detail': 'true'
    };
    try {
      final response = await dio.get('$baseUrl/service/ad_service_client',
          queryParameters: queryParameters);
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['ad_service_clients'];
        final List<AdServiceClientModel> result =
            data.map((e) => AdServiceClientModel.fromJson(e)).toList();
        return result;
      }
    } catch (e) {
      printLog(e, 'getAdServiceListForDriverOrOwner');
    }
    return null;
  }

  Future<List<AdServiceModel>?> getMyServiceDriverOrOwner(
      String driverOrOwnerID) async {
    final Map<String, dynamic> queryParameters = {
      'user_detail': 'true',
      'city_detail': 'true',
      'documents_detail': 'true',
      'user_id': driverOrOwnerID,
      'service_subcategory_detail': 'true'
    };
    try {
      final response = await dio.get('$baseUrl/service/ad_service',
          queryParameters: queryParameters);
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['ad_services'];
        final List<AdServiceModel> result =
            data.map((e) => AdServiceModel.fromJson(e)).toList();
        return result;
      }
    } catch (e) {
      printLog(e, 'getAdServiceListForClient');
    }
    return null;
  }

  Future<void> deleteMyAd(String id) async {
    try {
      final headers = await getAuthHeaders();

      await dio.delete('$baseUrl/service/ad_service/$id',
          options: Options(headers: headers));
    } catch (e) {
      printLog(e, 'deleteMyAd');
    }
  }

  Future<void> deleteMyClientAd(String id) async {
    try {
      final headers = await getAuthHeaders();

      await dio.delete('$baseUrl/service/ad_service_client/$id',
          options: Options(headers: headers));
    } catch (e) {
      printLog(e, 'deleteMyAd');
    }
  }

  Future<List<AdClientInteracted>> getAdClientInteractedList() async {
    return [];
  }

  void printLog(Object e, String errorName) {
    return log(e.toString(), name: 'Error name :$errorName');
  }

  String dateFormatWithyyyyMMddTHHmmssSSSSSSSSS(DateTime dateTime) {
    return DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSSSSSSS'Z'").format(dateTime);
  }

  Future<Map<String, dynamic>> getAuthHeaders() async {
    final token = await tokenService.getToken();
    return {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
  }
}

class FavoritesForClient {
  int id;

  FavoritesForClient({required this.id});

  static FavoritesForClient fromJson(Map<String, dynamic> map) {
    return FavoritesForClient(id: map['ad_service_id']);
  }
}

class FavoritesForDriver {
  int id;

  FavoritesForDriver({required this.id});

  static FavoritesForDriver fromJson(Map<String, dynamic> map) {
    return FavoritesForDriver(id: map['ad_service_client_id']);
  }
}
