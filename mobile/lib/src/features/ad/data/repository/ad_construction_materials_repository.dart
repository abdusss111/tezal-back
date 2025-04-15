import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:eqshare_mobile/src/core/data/models/brand/brand.dart';
import 'package:eqshare_mobile/src/core/data/models/category_models/category.dart';
import 'package:eqshare_mobile/src/core/data/models/category_models/sub_category.dart';
import 'package:eqshare_mobile/src/core/data/services/network/api_client/network_client.dart';
import 'package:eqshare_mobile/src/core/presentation/utils/date_format_helper.dart';
import 'package:eqshare_mobile/src/features/ad/data/models/ad_client_interacted_model/ad_client_interacted.dart';
import 'package:eqshare_mobile/src/features/ad/data/models/ad_contruction_models/ad_construction_client_model.dart/ad_construction_client_model.dart';
import 'package:eqshare_mobile/src/features/ad/data/models/ad_contruction_models/ad_construction_model/ad_constrution_model.dart';

import 'package:eqshare_mobile/src/core/data/models/payload/payload.dart';
import 'package:eqshare_mobile/src/core/data/services/storage/token_provider_service.dart';
import 'package:eqshare_mobile/src/core/res/api_endpoints/api_endpoints.dart';
import 'package:eqshare_mobile/src/global_widgets/global_values.dart';

import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';

class AdConstructionMaterialsRepository {
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

  Future<List<AdConstructionClientModel>?>
      getAdConstructionMaterialListForDriverOrOwner(
          {Map<String, dynamic>? queryParametersFromPage,
          int? selectedSubCategory,
          int? selectedCategory,
          int? cityId,
          String? userID,
          String? sortAlgorithm}) async {
    final Map<String, dynamic> queryParameters = {
      'user_detail': 'true',
      'city_detail': 'true',
      'document_detail': 'true',
      if (userID != null) 'user_id': userID,
      if (selectedSubCategory != null && selectedSubCategory != 0)
        'construction_material_subcategory_id': selectedSubCategory.toString(),
      if (selectedCategory != null && selectedCategory != 0)
        'construction_material_category_id': selectedCategory.toString(),
      if (cityId != null && cityId != 0)
        'city_id': cityId.toString()
    };
    if (queryParametersFromPage != null) {
      queryParameters.addAll(queryParametersFromPage);
    }
    try {
      log(DateTime.now().toString(), name: 'DateTime : ');
      final response = await _networkClient.aliGet(
          path: '/construction_material/ad_construction_material_client',
          queryParams: queryParameters,
          fromJson: (json) {
            final List<dynamic> data = json['ad_construction_material_clients'];
            final List<AdConstructionClientModel> result =
                data.map((e) => AdConstructionClientModel.fromJson(e)).toList();
            if (queryParameters.containsKey('ASC')) {
              if (queryParameters.containsValue('price')) {
                return result
                  ..sort((a, b) => (a.price ?? 0).compareTo(b.price ?? 0));
              } else {
                return result
                  ..sort((a, b) => (b.createdAt ?? DateTime.now())
                      .compareTo(a.createdAt ?? DateTime.now()));
              }
            }
            if (queryParameters.containsKey('DESC')) {
              return result
                ..sort((a, b) => (b.price ?? 0).compareTo(a.price ?? 0));
            }
            return result;
          });
      return response;
    } catch (e) {
      printLog(e, 'getAdConstructionMaterialListForDriverOrOwner');
      return null;
    }
  }

  Future<List<dynamic>?>
      getAdConstructionMaterialListForDriverOrOwnerWithPaginator(
          {Map<String, dynamic>? queryParametersFromPage,
          String? sortAlgorithm}) async {
    final Map<String, dynamic> queryParameters = {
      'user_detail': 'true',
      'city_detail': 'true',
      'document_detail': 'true',
    };
    if (queryParametersFromPage != null) {
      queryParameters.addAll(queryParametersFromPage);
    }
    try {
      log(DateTime.now().toString(), name: 'DateTime : ');
      final response = await _networkClient.aliGet(
          path: '/construction_material/ad_construction_material_client',
          queryParams: queryParameters,
          fromJson: (json) {
            final List<dynamic> data = json['ad_construction_material_clients'];
            final List<AdConstructionClientModel> result =
                data.map((e) => AdConstructionClientModel.fromJson(e)).toList();
            final total = json['total'];
            if (queryParameters.containsKey('ASC')) {
              if (queryParameters.containsValue('price')) {
                return [
                  result
                    ..sort((a, b) => (a.price ?? 0).compareTo(b.price ?? 0)),
                  total
                ];
              } else {
                return [
                  result
                    ..sort((a, b) => (b.createdAt ?? DateTime.now())
                        .compareTo(a.createdAt ?? DateTime.now())),
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
          });
      return response;
    } catch (e) {
      printLog(e, 'getAdConstructionMaterialListForDriverOrOwner');
      return null;
    }
  }

  Future<List<AdConstrutionModel>?> getAdConstructionMaterialListForClient({
    Map<String, dynamic>? queryParametersFromPage,
    int? selectedSubCategory,
    int? selectedCategory,
    int? cityId,
    String? userId,
  }) async {
    final Map<String, dynamic> queryParameters = {
      if (userId != null) 'user_id': userId,
      'user_detail': 'true',
      'city_detail': 'true',
      'document_detail': 'true',
      if (selectedSubCategory != null && selectedSubCategory != 0)
        'construction_material_subcategory_id': selectedSubCategory.toString(),
      if (selectedCategory != null && selectedCategory != 0)
        'construction_material_category_id': selectedCategory.toString(),
      if (cityId != null && cityId != 0) 'city_id': cityId.toString()
    };
    if (queryParametersFromPage != null) {
      queryParameters.addAll(queryParametersFromPage);
    }
    try {
      final response = await _networkClient.aliGet(
          path: '/construction_material/ad_construction_material',
          queryParams: queryParameters,
          fromJson: (json) {
            return json;
          });
      final List<dynamic> data = response!['ad_construction_materials'];
      final List<AdConstrutionModel> result =
          data.map((e) => AdConstrutionModel.fromJson(e)).toList();

      if (queryParameters.containsKey('ASC'.toLowerCase())) {
        if (queryParameters.containsValue('price')) {
          result;
        } else {
          return result
            ..sort((a, b) => (b.createdAt ?? DateTime.now())
                .compareTo(a.createdAt ?? DateTime.now()));
        }
      }

      return result;
    } catch (e) {
      printLog(e, 'getAdConstructionMaterialListForClient');
      return null;
    }
  }

  Future<List<dynamic>?> getAdConstructionMaterialListForClientWithPaginator(
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
      final response = await _networkClient.aliGet(
          path: '/construction_material/ad_construction_material',
          queryParams: queryParameters,
          fromJson: (json) {
            return json;
          });
      final total = response?['total'];
      final List<dynamic> data = response?['ad_construction_materials'] ?? [];
      final List<AdConstrutionModel> result =
          data.map((e) => AdConstrutionModel.fromJson(e)).toList();

      if (queryParameters.containsKey('ASC'.toLowerCase())) {
        if (queryParameters.containsValue('price')) {
          result;
        } else {
          return [
            result
              ..sort((a, b) => (b.createdAt ?? DateTime.now())
                  .compareTo(a.createdAt ?? DateTime.now())),
            total
          ];
        }
      }

      return [result, total];
    } catch (e) {
      printLog(e, 'getAdConstructionMaterialListForClient');
      return null;
    }
  }

  Future<bool> postClientAdConstructionMaterial(
      {required String description,
      required String address,
      required int cityID,
      DateTime? endLeaseDate,
      required List<String> images,
      required double latitude,
      required double longitude,
      required double price,
      required int subcategoryID,
      required DateTime startLeaseDate,
      required String status,
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
        "construction_material_subcategory_id": subcategoryID,
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
      final response = await dio.post(
          '$baseUrl/construction_material/ad_construction_material_client',
          data: formData,
          options: Options(headers: headers));
      if (response.statusCode == 200) {
        return true;
      }
    } on Exception catch (e) {
      printLog(e, 'postClientAdConstructionMaterial');
    }
    return false;
  }

  Future<bool> patchOrEditClientAdConstructionMaterial(
      {required String description,
      required String address,
      required int cityID,
      required int userID,
      required int id,
      DateTime? endLeaseDate,
      required List<String> images,
      required double latitude,
      required double longitude,
      required double price,
      required int subcategoryID,
      required DateTime startLeaseDate,
      required String status,
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
      "construction_material_subcategory_id": subcategoryID,
      "start_lease_date": DateTimeUtils().dateFormatForUpdate(startLeaseDate),
      "status": RequestStatus.CREATED.name,
      "title": title,
      'user_id': userID
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
      final response = await dio.put(
          '$baseUrl/construction_material/ad_construction_material_client/$id',
          data: formData,
          options: Options(headers: headers));
      if (response.statusCode == 200) {
        return true;
      }
    } on Exception catch (e) {
      printLog(e, 'postClientAdConstructionMaterial');
    }
    return false;
  }

  Future<bool> postDriverOrOwnerAdConstructionMaterial(
      {required String description,
      required String title,
      required String address,
      required int price,
      required int brandId,
      required int subCategoryID,
      required double latitude,
      required List<String> images,
      required double longitude,
      required int cityID,
      Map<String, dynamic>? params}) async {
    final formData = FormData.fromMap({
      'base': jsonEncode({
        "address": address,
        "city_id": cityID,
        "description": description,
        "latitude": latitude,
        "longitude": longitude,
        "price": price,
        "construction_material_brand_id": brandId,
        "construction_material_sub_сategory_id": subCategoryID,
        "title": title,
        if (params != null) 'params': params
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
      log(formData.fields.toString(), name: 'FormDaata: ');
      final response = await dio.post(
          '$baseUrl/construction_material/ad_construction_material',
          data: formData,
          options: Options(headers: headers));
      if (response.statusCode == 200) {
        return true;
      }
    } on Exception catch (e) {
      printLog(e, 'postDriverOrOwnerAdConstructionMaterial');
      return false;
    }
    return false;
  }

  Future<bool> patchOrEditDriverOrOwnerAdConstructionMaterial(
      {required String description,
      required String title,
      required String address,
      required int price,
      required int brandId,
      required int subCategoryID,
      required double latitude,
      required int id,
      required int userID,
      required List<String> images,
      required double longitude,
      required int cityID,
      Map<String, dynamic>? params}) async {
    final formData = {
      "address": address,
      "city_id": cityID,
      "description": description,
      "latitude": latitude,
      "longitude": longitude,
      "price": price,
      "construction_material_brand_id": brandId,
      "construction_material_subcategory_id": subCategoryID,
      "title": title,
      "user_id": userID,
    };

    try {
      final headers = await getAuthHeaders();
      final response = await dio.put(
          '$baseUrl/construction_material/ad_construction_material/$id',
          data: formData,
          options: Options(headers: headers));
      if (response.statusCode == 200) {
        return true;
      }
    } on Exception catch (e) {
      printLog(e, 'postDriverOrOwnerAdConstructionMaterial');
      return false;
    }
    return false;
  }

  Future<bool> checkIsAdConstructionMaterialISFavouriteForClient(
      {required int aAdConstructionMaterialID}) async {
    try {} on Exception catch (e) {
      printLog(e, 'checkIsAdConstructionMaterialISFavouriteForClient');
    }
    return false;
  }

  Future<bool> checkIsAdConstructionMaterialISFavouriteForDriverOrOwner(
      {required int aAdConstructionMaterialID}) async {
    try {} on Exception catch (e) {
      printLog(e, 'checkIsAdConstructionMaterialISFavouriteForDriverOrOwner');
    }
    return false;
  }

  Future<void> adForFavouriteADDriverOrOwnerFromClientAccount() async {} //TODO
  Future<void> adForFavouriteADClientFromDriverOrOwnerAccount() async {} //TODO

  Future<void> deleteFavouriteADDriverOrOwnerFromClientAccount() async {} //TODO
  Future<void> deleteFavouriteADClientFromDriverOrOwnerAccount() async {} //TODO

  Future<bool> createRequestFromUserToDriverOrOwner(
      {required String adID,
      required int adPrice,
      required String address,
      required String description,
      required LatLng latLng,
      DateTime? pickedEndTime,
      required List<String> pickedImages,
      required DateTime pickedStart}) async {
    final dio = Dio();
    final path =
        '${ApiEndPoints.baseUrl}/construction_material/request_ad_construction_material';
    try {
      final headers = await getAuthHeaders();
      final formData = FormData.fromMap({
        'base': jsonEncode({
          "ad_construction_material_id": int.parse(adID),
          "address": address,
          // "count_hour": calculateHoursDifference(),
          "description": description,
          if (pickedEndTime != null)
            "end_lease_at": DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSSSSSSS'Z'")
                .format(pickedEndTime),
          "latitude": latLng.latitude,
          "longitude": latLng.longitude,
          "order_amount": 1,
          "start_lease_at": DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSSSSSSS'Z'")
              .format(pickedStart),
        })
      });
      final response = await dio.post(path,
          options: Options(headers: headers), data: formData);
      if (response.statusCode == 200) {
        log('Success');
        return true;
      }
    } on Exception catch (e) {
      log(e.toString(), name: "safasf:  ");
    }
    return false;
  }

  Future<bool> createRequestFromDriverOrOwner(String description,
      {required int adConstructionClientID,
      required Payload payload,
      required int executorID}) async {
    final dio = Dio();
    final path =
        '${ApiEndPoints.baseUrl}/construction_material/request_ad_construction_material_client';

    try {
      final map = {
        'ad_construction_material_client_id': adConstructionClientID,
        // 'ad_construction_material_client_id': 320,
        'description': description,
        // 'executor_id': 318,
        // 'executor_id':int.tryParse( payload.sub ?? '1') ?? 1,
        'executor_id': executorID,
      };
      final headers = await getAuthHeaders();
      headers.addAll(<String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      });
      final response = await dio.post(path,
          data: map,
          queryParameters: {'status': 'CREATED'},
          options:
              Options(headers: headers, contentType: Headers.jsonContentType));
      // TODO Возможно дио не правильно отправляет значение double из мапы
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } on Exception catch (e) {
      log(e.toString(), name: 'Erasf:  s ');
      return false;
    }
  }

  Future<bool> postRequestFromDriverOrOwnerTOClientAdConstructionMaterial(
      {required String description,
      required int adConstructionMaterialID,
      required int driverOrOwnerID}) async {
    final formData = {
      "ad_construction_material_client_id": adConstructionMaterialID,
      "description": description,
      "executor_id": driverOrOwnerID
    };
    try {
      final headers = await getAuthHeaders();
      final response = await dio.post(
          '$baseUrl/construction_material/request_ad_construction_material_client',
          options: Options(headers: headers),
          data: formData);
      if (response.statusCode == 200) {
        return true;
      }
    } catch (e) {
      printLog(e,
          'postRequestFromDriverOrOwnerTOClientAdConstructionMaterial'); // TODO error
    }
    return false;
  }

  Future<void>
      getAuthorPhoneNumberFromOwnerORDriverAdConstructionMaterialTOClient() async {} // TODO
  Future<void>
      getAuthorPhoneNumberFromClientAdConstructionMaterialTOOwnerORDriver() async {} // TODO

  Future<AdConstructionClientModel?>
      getAdConstructionMaterialDetailForDriverOrOwner(
          {required String adID,
          Map<String, dynamic> queryParameters = const {
            'user_detail': 'true',
            'city_detail': 'true',
            'document_detail': 'true',
          }}) async {
    try {
      final response = await dio.get(
          '$baseUrl/construction_material/ad_construction_material_client/$adID',
          queryParameters: queryParameters);
      if (response.statusCode == 200) {
        final data = response.data['ad_construction_material_client'];
        final AdConstructionClientModel result =
            AdConstructionClientModel.fromJson(data);
        return result;
      }
    } catch (e) {
      printLog(e, 'getAdConstructionMaterialDetailForDriverOrOwner');
    }
    return null;
  }

  Future<AdConstrutionModel?> getAdConstructionMaterialDetailForClient(
      {required String adID,
      Map<String, dynamic> queryParameters = const {
        // 'user_detail': 'true',
        // 'city_detail': 'true',
        'document_detail': 'true',
      }}) async {
    try {
      final response = await dio.get(
          '$baseUrl/construction_material/ad_construction_material/$adID',
          queryParameters: queryParameters);
      if (response.statusCode == 200) {
        final data = response.data['ad_construction_material'];
        final AdConstrutionModel result = AdConstrutionModel.fromJson(data);
        return result;
      }
    } catch (e) {
      printLog(e, 'getAdConstructionMaterialListForDriverOrOwner');
    }
    return null;
  }

  Future<List<Category>> getAdConstrutionListCategory() async {
    final path = '$baseUrl/construction_material/category';

    try {
      final response = await dio.get(path);

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['categories'];
        final List<Category> result =
            data.map((e) => Category.fromJson(e)).toList();
        return result;
      }
    } on Exception catch (e) {
      printLog(e, 'getAdConstructionMaterialListCategory');
    }
    return [];
  }

  Future<Category?> getAdConstrutionCategoryWithID(int id) async {
    final path = '$baseUrl/construction_material/category/$id';

    try {
      final response = await dio.get(path);

      if (response.statusCode == 200) {
        final data = response.data['category'];
        final Category result = Category.fromJson(data);
        return result;
      }
    } on Exception catch (e) {
      printLog(e, 'getAdConstructionMaterialListCategory');
    }
    return null;
  }

  Future<List<Brand>> getConstructionMaterialListBrand() async {
    final path = '$baseUrl/brand_cm';

    try {
      final response = await dio.get(path);

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['brands'];
        final List<Brand> result = data.map((e) => Brand.fromJson(e)).toList();
        return result;
      }
    } on Exception catch (e) {
      printLog(e, 'getAdConstructionMaterialListSubCategory');
    }
    return [];
  }

  Future<List<SubCategory>> getConstructionMaterialListSubCategory(
      {required int? categoryID}) async {
    final path =
        '$baseUrl/construction_material/category/${categoryID ?? 0}/sub_category';

    try {
      final response = await dio.get(path);

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['sub_categories'];
        final List<SubCategory> result =
            data.map((e) => SubCategory.fromJson(e)).toList();
        return result;
      }
    } on Exception catch (e) {
      printLog(e, 'getAdConstructionMaterialListSubCategory');
    }
    return [];
  }

  Future<bool> isThisFavouriteAdForClient(String id) async {
    final path =
        '$baseUrl/construction_material/ad_construction_material/favorite';
    try {
      final headers = await getAuthHeaders();
      final response = await dio.get(path, options: Options(headers: headers));
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['favorites'];
        final List<FavoritesForClient> result =
            data.map((e) => FavoritesForClient.fromJson(e)).toList();
        for (var e in result) {
          if (e.id == int.parse(id)) {
            return true;
          }
        }
      }
    } catch (e) {
      printLog(e, 'isThisFavouriteAdForClient');
    }

    return false;
  }

  Future<void> postThisAdForClientFavorite(String id) async {
    final path =
        '$baseUrl/construction_material/ad_construction_material/$id/favorite';
    try {
      final headers = await getAuthHeaders();
      await dio.post(path, options: Options(headers: headers));
    } catch (e) {
      printLog(e, 'postThisAdForClientFavorite');
    }
  }

  Future<void> deleteThisAdForClientFavorite(String id) async {
    final path =
        '$baseUrl/construction_material/ad_construction_material/$id/favorite';
    try {
      final headers = await getAuthHeaders();
      await dio.delete(path, options: Options(headers: headers));
    } catch (e) {
      printLog(e, 'postThisAdForClientFavorite');
    }
  }

  Future<bool> isFovoriteForDriver(String id) async {
    try {
      final headers = await getAuthHeaders();
      final response = await dio.get(
          '${ApiEndPoints.baseUrl}/construction_material/ad_construction_material_client/favorite',
          options: Options(headers: headers));
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['favorites'];

        final List<FavoritesForDriver> getData =
            data.map((e) => FavoritesForDriver.fromJson(e)).toList();

        for (var element in getData) {
          if (int.parse(id) == element.id) {
            return true;
          }
        }
      }
    } catch (e) {
      log(e.toString(), name: 'Eerers : ');
    }
    return false;
  }

  Future<void> postFavoriteFromDriver(String id) async {
    try {
      final headers = await getAuthHeaders();
      await dio.post(
          '${ApiEndPoints.baseUrl}/construction_material/ad_construction_material_client/$id/favorite',
          options: Options(headers: headers));
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> deleteFavoriteFromDriver(String id) async {
    try {
      final headers = await getAuthHeaders();
      await dio.delete(
          '${ApiEndPoints.baseUrl}/construction_material/ad_construction_material_client/$id/favorite',
          options: Options(headers: headers));
    } catch (e) {
      log(e.toString());
    }
  }

  Future<List<AdConstrutionModel>?> getMyAdConstructionsForDriverOrOwner(
      String driverOrOwnerID,
      {bool categoryDetails = true}) async {
    final path = '$baseUrl/construction_material/ad_construction_material';
    final qp = {
      'user_id': driverOrOwnerID,
      'city_detail': 'true',
      'documents_detail': 'true',
      if (categoryDetails) 'construction_material_subcategory_detail': 'true'
    };
    try {
      final response = await dio.get(path, queryParameters: qp);
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['ad_construction_materials'];
        final List<AdConstrutionModel> result =
            data.map((e) => AdConstrutionModel.fromJson(e)).toList();
        return result;
      }
    } catch (e) {
      printLog(e, 'getMyAdConstructionsForDriverOrOwner');
    }
    return null;
  }

  Future<List<AdConstructionClientModel>?> getMyAdConstructionsForClient(
      String clientID,
      {bool unscoped = false,
      bool categoryDetails = true}) async {
    final path =
        '$baseUrl/construction_material/ad_construction_material_client';
    final qp = {
      'user_id': clientID,
      'city_detail': 'true',
      if (unscoped) 'unscoped': 'true',
      if (categoryDetails) 'construction_material_subcategory_detail': 'true'
    };
    try {
      final response = await dio.get(path, queryParameters: qp);
      if (response.statusCode == 200) {
        final List<dynamic> data =
            response.data['ad_construction_material_clients'];
        final List<AdConstructionClientModel> result =
            data.map((e) => AdConstructionClientModel.fromJson(e)).toList();
        return result;
      }
    } catch (e) {
      printLog(e, 'getMyAdConstructionsForClient');
    }
    return null;
  }

  Future<void> deteteMyClientAd(String id) async {
    try {
      final headers = await getAuthHeaders();
      String path;

      path =
          '$baseUrl/construction_material/ad_construction_material_client/$id';

      final response =
          await dio.delete(path, options: Options(headers: headers));
      log(response.statusCode.toString());
    } catch (e) {
      printLog(e, 'geteteMyAd');
    }
  }

  Future<void> deteteMyAd(String id) async {
    try {
      final headers = await getAuthHeaders();
      String path =
          '$baseUrl/construction_material/ad_construction_material/$id';

      await dio.delete(path, options: Options(headers: headers));
    } catch (e) {
      printLog(e, 'geteteMyAd');
    }
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
        path = '/report/ad/cm';
        map.addAll({
          "ad_construction_material_id": int.parse(adID),
          "description": reportText,
          "report_reasons_id": reportReasonID
        });
      } else {
        path = '/report/ad/cm_client';
        map.addAll({
          "ad_equipment_client_id": int.parse(adID),
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
    return {'Authorization': 'Bearer $token'};
  }
}

class FavoritesForClient {
  int id;

  FavoritesForClient({required this.id});

  static FavoritesForClient fromJson(Map<String, dynamic> map) {
    return FavoritesForClient(id: map['ad_construction_material_id']);
  }
}

class FavoritesForDriver {
  int id;

  FavoritesForDriver({required this.id});

  static FavoritesForDriver fromJson(Map<String, dynamic> map) {
    return FavoritesForDriver(id: map['ad_construction_material_client_id']);
  }
}
