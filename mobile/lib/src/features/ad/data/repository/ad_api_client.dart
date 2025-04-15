import 'package:eqshare_mobile/src/core/data/models/brand/brand.dart';
import 'package:eqshare_mobile/src/core/data/models/category_models/category.dart';
import 'package:eqshare_mobile/src/core/data/models/category_models/sub_category.dart';
import 'package:eqshare_mobile/src/global_widgets/global_values.dart';
import 'package:eqshare_mobile/src/features/ad/data/models/ad_client_interacted_model/ad_client_interacted.dart';
import 'package:eqshare_mobile/src/features/ad/data/models/ad_contruction_models/ad_construction_client_model.dart/ad_construction_client_model.dart';
import 'package:eqshare_mobile/src/features/ad/data/models/ad_contruction_models/ad_construction_model/ad_constrution_model.dart';
import 'package:eqshare_mobile/src/features/ad/data/models/ad_equipment_models/ad_equipment_client_model/ad_equipment_client.dart';
import 'package:eqshare_mobile/src/features/ad/data/models/ad_equipment_models/ad_equipment_model/ad_equipment.dart';

import 'package:eqshare_mobile/src/features/ad/data/models/ad_service_models/ad_service_client_model/ad_service_client_model.dart';
import 'package:eqshare_mobile/src/features/ad/data/models/ad_service_models/ad_service_model/ad_service_model.dart';

import 'package:eqshare_mobile/src/features/ad/data/models/ad_sm_interacted_list/ad_sm_interacted_list.dart';
import 'package:eqshare_mobile/src/features/ad/data/models/ad_sm_models/ad_sm_client_model/ad_client.dart';
import 'package:eqshare_mobile/src/features/ad/data/models/ad_sm_models/ad_sm_model/ad_specialized_machinery.dart';

import 'package:eqshare_mobile/src/features/main/location/ad_in_map/ad_data_handler.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

import '../../../../core/data/services/storage/token_provider_service.dart';
import '../../../../core/data/services/network/api_client/network_client.dart';

class AdApiClient {
  final _networkClient = NetworkClient();

  Future<List<AdSpecializedMachinery>?>
      getFavoriteAdSpecializedMachinery() async {
    final result = await _networkClient.aliGet(
        path: '/ad_sm/favorite',
        fromJson: (json) {
          final List<dynamic> data = json["favorites"];
          final List<AdSpecializedMachinery> adSEquipmentList = data
              .map((e) => AdSpecializedMachinery.fromJson(
                  e['ad_specialized_machinery']))
              .toList();
          return adSEquipmentList;
        });
    return result;
  }

  Future<List<AdEquipment>?> aliGetFavoriteAdEquipment() async {
    final result = _networkClient.aliGet(
        path: '/equipment/ad_equipment/favorite',
        fromJson: (json) {
          final List<dynamic> adSpecializedMachineryJsonList =
               json["favorites"];
          final List<AdEquipment> adSEquipmentList =
              adSpecializedMachineryJsonList
                  .map((adSpecializedMachinery) => AdEquipment.fromJson(
                      adSpecializedMachinery['ad_equipment']))
                  .toList();
          return adSEquipmentList;
        });
    return result;
  }

  Future<List<AdServiceModel>?> aliGetFavoriteSVM() async {
    final result = _networkClient.aliGet(
        path: '/service/ad_service/favorite',
        fromJson: (json) {
          final List<dynamic> adSpecializedMachineryJsonList =
              json["favorites"];
          final List<AdServiceModel> adSEquipmentList =
              adSpecializedMachineryJsonList
                  .map((adSpecializedMachinery) => AdServiceModel.fromJson(
                      adSpecializedMachinery['ad_service']))
                  .toList();
          return adSEquipmentList;
        });
    return result;
  }

  Future<List<AdConstrutionModel>?> aliGetFavoriteCm() async {
    final result = _networkClient.aliGet(
        path: '/construction_material/ad_construction_material/favorite',
        fromJson: (json) {
          final List<dynamic> adSpecializedMachineryJsonList =
              json["favorites"];
          final List<AdConstrutionModel> adSEquipmentList =
              adSpecializedMachineryJsonList
                  .map((adSpecializedMachinery) => AdConstrutionModel.fromJson(
                      adSpecializedMachinery['ad_construction_material']))
                  .toList();
          return adSEquipmentList;
        });
    return result;
  }

  Future<List<AdClient>?> aliGetFavoriteClientAdSpecializedMachinery() async {
    final result = _networkClient.aliGet(
        path: '/ad_client/favorite',
        fromJson: (json) {
          final List<dynamic> adSpecializedMachineryJsonList =
              json["favorites"];
          final List<AdClient> adSpecializedMachineryList =
              adSpecializedMachineryJsonList
                  .map((adSpecializedMachinery) =>
                      AdClient.fromJson(adSpecializedMachinery["ad_client"]))
                  .toList();
          return adSpecializedMachineryList;
        });
    return result;
  }

  Future<List<AdEquipmentClient>?> aliGetFavoriteClientAdEquipment() async {
    final result = _networkClient.aliGet(
        path: '/equipment/ad_equipment_client/favorite',
        fromJson: (json) {
          final List<dynamic> adSpecializedMachineryJsonList =
              json["favorites"];
          final List<AdEquipmentClient> adSEquipmentList =
              adSpecializedMachineryJsonList
                  .map((adSpecializedMachinery) => AdEquipmentClient.fromJson(
                      adSpecializedMachinery["ad_equipment_client"]))
                  .toList();
          return adSEquipmentList;
        });
    return result;
  }

  Future<List<AdConstructionClientModel>?> aliGetFavoriteClientCM() async {
    final result = _networkClient.aliGet(
        path: '/construction_material/ad_construction_material_client/favorite',
        fromJson: (json) {
          final List<dynamic> adSpecializedMachineryJsonList =
              json["favorites"];
          final List<AdConstructionClientModel> adSEquipmentList =
              adSpecializedMachineryJsonList
                  .map((adSpecializedMachinery) =>
                      AdConstructionClientModel.fromJson(adSpecializedMachinery[
                          'ad_construction_material_client']))
                  .toList();
          return adSEquipmentList;
        });
    return result;
  }

  Future<List<AdServiceClientModel>?> aliGetFavoriteClientSVM() async {
    final result = _networkClient.aliGet(
        path: '/service/ad_service_client/favorite',
        fromJson: (json) {
          final List<dynamic> adSpecializedMachineryJsonList =
              json["favorites"];
          final List<AdServiceClientModel> adSEquipmentList =
              adSpecializedMachineryJsonList
                  .map((adSpecializedMachinery) =>
                      AdServiceClientModel.fromJson(
                          adSpecializedMachinery['ad_service_client']))
                  .toList();
          return adSEquipmentList;
        });
    return result;
  }

  Future<List<AdSpecializedMachinery>?> getAdSMList(
      {int? categoryId,
      int? subCategoryId,
      int? limit,
      int? offset,
      int? cityId,
      String? userID,

      Map<String, dynamic>? map,
      SortAlgorithmEnum? sortAlgorithm, // Добавляем параметр сортировки

      }) async {

    Map<String, dynamic> queryParams = {
      if (categoryId != 0 && categoryId != null)
        'sub_category_id': categoryId.toString(),
      if (subCategoryId != 0 && subCategoryId != null)
        'type_id': subCategoryId.toString(),
      if (cityId != null && cityId != 92) // ✅ Исключаем 92
        'city_id': cityId.toString(),      if (limit != null) 'limit': limit.toString(),
      if (offset != null) 'offset': offset.toString(),
      if (userID != null) 'user_id': userID.toString(),
      'document_detail': 'true',
      'city_detail': 'true',
      'type_detail': 'true',
    };
    if (sortAlgorithm != null) {
      queryParams.addAll(keyValueForSortAlgorithmEnum(sortAlgorithm.name));
    }
    if (map != null && map.isNotEmpty) {
      queryParams.addAll(map);
    }
    final data = await _networkClient.aliGet(
      path: '/ad_sm',
      queryParams: queryParams,
      fromJson: (json) {
        final adDataHandler =
            DataHandlerFactory.getHandler(ServiceTypeEnum.MACHINARY);
        final result =
            adDataHandler.createObjects(json['ad_specialized_machinery']);
        if (queryParams.containsKey('ASC')) {
          if (queryParams.containsValue('price')) {
            result as List<AdSpecializedMachinery>;
          } else {
            return result as List<AdSpecializedMachinery>
              ..sort((a, b) => (b.createdAt ?? DateTime.now())
                  .compareTo(a.createdAt ?? DateTime.now()));
          }
        }
        return result as List<AdSpecializedMachinery>;
      },
    );
    return data;
  }

  Future<List<dynamic>?> getAdSMListWithPagination(
      {int? categoryId,
      int? subCategoryId,
      int? limit,
      int? offset,
      int? cityId,
      String? userID,
      Map<String, dynamic>? map,
      SortAlgorithmEnum? sortAlgorithm, // Добавляем параметр сортировки

      }) async {
    Map<String, dynamic> queryParams = {
      if (categoryId != 0 && categoryId != null)
        'sub_category_id': categoryId.toString(),
      if (subCategoryId != 0 && subCategoryId != null)
        'type_id': subCategoryId.toString(),
      if (cityId != null && cityId != 92) // ✅ Исключаем 92
        'city_id': cityId.toString(),      if (limit != null) 'limit': limit.toString(),
      if (offset != null) 'offset': offset.toString(),
      if (userID != null) 'user_id': userID.toString(),
      'document_detail': 'true',
      'city_detail': 'true',
      'type_detail': 'true',
    };
    if (sortAlgorithm != null) {
      queryParams.addAll(keyValueForSortAlgorithmEnum(sortAlgorithm.name));
    }
    print('Query Params: $queryParams');

    if (map != null && map.isNotEmpty) {
      queryParams.addAll(map);
    }
    final data = await _networkClient.aliGet(
      path: '/ad_sm',
      queryParams: queryParams,
      fromJson: (json) {
        final adDataHandler =
            DataHandlerFactory.getHandler(ServiceTypeEnum.MACHINARY);
        final result =
            adDataHandler.createObjects(json['ad_specialized_machinery']);
        final total = json['total'];
        return [result as List<AdSpecializedMachinery>, total];
      },
    );
    
    print('ADSMPARAMS: $queryParams');
    print('ADSM: $data');
    return data;
  }

    Future<List<AdEquipment>?> getAdEquipmentList({
      int? categoryId,
      int? subCategoryId,
      String? sortAlgorithm,
      double? min,
      double? max,
      Map<String, String>? parameterQueryParams,
      int? limit,
      int? cityId,
      int? offset,
      String? userId,
    }) async {
      Map<String, dynamic> queryParams = {
        if (subCategoryId != 0 && subCategoryId != null)
          'equipment_subcategory_id': subCategoryId.toString(),
        if (subCategoryId == 0 && categoryId != 0 && categoryId != null)
          'equipment_category_id': categoryId.toString(),
        if (cityId != null)
          'city_id': cityId.toString(),
        if (min != null && max != null) 'price': '$min-$max',
        'equipment_subcategory_detail': 'true',
        'documents_detail': 'true',
        'city_detail': 'true',
        if (limit != null) 'limit': limit.toString(),
        if (offset != null) 'offset': offset.toString(),
        if (userId != null) 'user_id': userId
      };
      if (parameterQueryParams != null) {
        queryParams.addAll(parameterQueryParams);
      }
      final data = _networkClient.aliGet(
        path: '/equipment/ad_equipment',
        queryParams: queryParams,
        fromJson: (json) {
          final adDataHandler =
              DataHandlerFactory.getHandler(ServiceTypeEnum.EQUIPMENT);
          final result = adDataHandler.createObjects(json['ad_equipments']);
          if (queryParams.containsKey('ASC'.toLowerCase())) {
            if (queryParams.containsValue('price')) {
              result as List<AdEquipment>;
            } else {
              return result as List<AdEquipment>
                ..sort((a, b) => (b.createdAt ?? DateTime.now())
                    .compareTo(a.createdAt ?? DateTime.now()));
            }
          }
          return result as List<AdEquipment>;
        },
      );
      return data;
    }

  Future<List<dynamic>?> getAdEquipmentListWithPaginator({
    required int? categoryId,
    required int? subCategoryId,
    String? sortAlgorithm,
    double? min,
    double? max,
    Map<String, String>? parameterQueryParams,
    int? limit,
    int? offset,
    String? userId,
  }) async {
    Map<String, dynamic> queryParams = {
      if (subCategoryId != 0 && subCategoryId != null)
        'equipment_subcategory_id': subCategoryId.toString(),
      if (subCategoryId == 0 && categoryId != 0 && categoryId != null)
        'equipment_category_id': categoryId.toString(),
      if (min != null && max != null) 'price': '$min-$max',
      'equipment_subcategory_detail': 'true',
      'documents_detail': 'true',
      'city_detail': 'true',
      if (limit != null) 'limit': limit.toString(),
      if (offset != null) 'offset': offset.toString(),
      if (userId != null) 'user_id': userId
    };
    if (parameterQueryParams != null) {
      queryParams.addAll(parameterQueryParams);
    }
    final data = await _networkClient.aliGet(
      path: '/equipment/ad_equipment',
      queryParams: queryParams,
      fromJson: (json) {
        final total = json['total'];
        final adDataHandler =
            DataHandlerFactory.getHandler(ServiceTypeEnum.EQUIPMENT);
        final result = adDataHandler.createObjects(json['ad_equipments']);
        // if (queryParams.containsKey('ASC'.toLowerCase())) {
        //   if (queryParams.containsValue('price')) {
        //     result as List<AdEquipment>;
        //   } else {
        //     return result as List<AdEquipment>
        //       ..sort((a, b) => (b.createdAt ?? DateTime.now())
        //           .compareTo(a.createdAt ?? DateTime.now()));
        //   }
        // }

        return [result as List<AdEquipment>, total];
      },
    );
    return data;
  }

    Future<List<AdClient>?> getAdClientList({
      int? categoryId,
      int? subCategoryId,
      bool? deleted,
      String? status,
      String? id,
      int? limit,
      int? offset,
      bool unscoped = false,
      Map<String, dynamic>? qmap,
    }) async {
      Map<String, dynamic> queryParams = {
        if (subCategoryId != null && subCategoryId != 0)
          'type_id': subCategoryId.toString(),
        if (categoryId != null && categoryId != 0)
          'category_id': categoryId.toString(),
        if (unscoped) 'unscoped': 'true',
        if (deleted != null) 'deleted': deleted.toString(),
        if (status != null) 'status': status,
        if (id != null) 'user_id': id.toString(),
        if (offset != null) 'offset': offset.toString(),
        if (limit != null) 'limit': limit.toString(),
      };
      if (qmap != null && qmap.isNotEmpty) {
        queryParams.addAll(qmap);
      }
      return _networkClient.aliGet(
          path: '/ad_client',
          queryParams: queryParams,
          fromJson: (json) {
            final List<dynamic> data = json['ad_client'];
            final List<AdClient> result =
                data.map((e) => AdClient.fromJson(e)).toList();

            if (queryParams.containsKey('ASC')) {
              if (queryParams.containsValue('price')) {
              } else {
                return result
                  ..sort((a, b) => (b.createdAt ?? DateTime.now())
                      .compareTo(a.createdAt ?? DateTime.now()));
              }
            }
            return result;
          });
    }

  Future<List<dynamic>?> getAdClientListWithPaginator({
    int? categoryId,
    int? subCategoryId,
    bool? deleted,
    String? status,
    String? id,
    int? limit,
    int? cityId,
    int? offset,
    bool unscoped = false,
    Map<String, dynamic>? qmap,
    SortAlgorithmEnum? sortAlgorithm, // Добавляем параметр сортировки

  }) async {
    Map<String, dynamic> queryParams = {
      if (subCategoryId != null && subCategoryId != 0)
        'type_id': subCategoryId.toString(),
      if (categoryId != null && categoryId != 0)
        'category_id': categoryId.toString(),
      if (unscoped) 'unscoped': 'true',
      if (deleted != null) 'deleted': deleted.toString(),
      if (status != null) 'status': status,
      if (id != null) 'user_id': id.toString(),
      if (offset != null) 'offset': offset.toString(),
      if (limit != null) 'limit': limit.toString(),
      if (cityId != null && cityId != 92) // ✅ Исключаем 92
        'city_id': cityId.toString(),    };

    if (sortAlgorithm != null) {
      queryParams.addAll(keyValueForSortAlgorithmEnum(sortAlgorithm.name));
    }

    if (qmap != null && qmap.isNotEmpty) {
      queryParams.addAll(qmap);
    }
    return _networkClient.aliGet(
        path: '/ad_client',
        queryParams: queryParams,
        fromJson: (json) {
          final List<dynamic> data = json['ad_client'];
          final List<AdClient> result =
              data.map((e) => AdClient.fromJson(e)).toList();

          final total = json['total'];

          if (queryParams.containsKey('ASC')) {
            if (queryParams.containsValue('price')) {
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
        });
  }

  Future<List<AdEquipmentClient>?> getAdEquipmentClientListWith(
      {int? categoryId,
      int? subCategoryId,
      bool? deleted,
      String? status,
      String? sortAlgorithm,
      String? id,
      int? limit,
      int? offset,
      bool unscoped = false,
      Map<String, dynamic>? map}) async {
    Map<String, dynamic> queryParams = {
      if (subCategoryId != null && subCategoryId != 0)
        'equipment_subcategory_id': subCategoryId.toString(),
      if (categoryId != null && categoryId != 0)
        'equipment_category_id': categoryId.toString(),
      if (deleted != null) 'deleted': deleted.toString(),
      if (status != null) 'status': status,
      if (id != null) 'user_id': id.toString(),
      if (limit != null) 'limit': limit.toString(),
      if (offset != null) 'offset': offset.toString(),
      'documents_detail': 'true',
      if (unscoped) 'unscoped': 'true',
      'equipment_subcategory_detail': 'true',
      'city_detail': 'true'
    };
    if (map != null && map.isNotEmpty) {
      queryParams.addAll(map);
    }
    return _networkClient.aliGet(
      path: '/equipment/ad_equipment_client',
      queryParams: queryParams,
      fromJson: (json) {
        final List<dynamic> data = json['ad_equipment_clients'];
        final List<AdEquipmentClient> result =
            data.map((e) => AdEquipmentClient.fromJson(e)).toList();
        if (queryParams.containsKey('ASC')) {
          if (queryParams.containsValue('price')) {
            return result
              ..sort((a, b) => (a.price ?? 0).compareTo(b.price ?? 0));
          } else {
            return result
              ..sort((a, b) => (b.createdAt ?? DateTime.now())
                  .compareTo(a.createdAt ?? DateTime.now()));
          }
        }
        if (queryParams.containsKey('DESC')) {
          return result..sort((a, b) => (b.price ?? 0).compareTo(a.price ?? 0));
        }

        return result;
      },
    );
  }

  Future<List<dynamic>?> getAdEquipmentClientListWithPaginator(
      {int? categoryId,
      int? subCategoryId,
      bool? deleted,
      String? status,
      String? sortAlgorithm,
      String? id,
      int? limit,
      int? cityID,
      int? offset,
      bool unscoped = false,
      Map<String, dynamic>? map}) async {
    Map<String, dynamic> queryParams = {
      if (subCategoryId != null && subCategoryId != 0)
        'equipment_subcategory_id': subCategoryId.toString(),
      if (categoryId != null && categoryId != 0)
        'equipment_category_id': categoryId.toString(),
      if (deleted != null) 'deleted': deleted.toString(),
      if (status != null) 'status': status,
      if (id != null) 'user_id': id.toString(),
      if (limit != null) 'limit': limit.toString(),
      if (cityID != null && cityID != 92) // ✅ Исключаем 92
        'city_id': cityID.toString(),      if (offset != null) 'offset': offset.toString(),
      'documents_detail': 'true',
      if (unscoped) 'unscoped': 'true',
      'equipment_subcategory_detail': 'true',
    };
    if (map != null && map.isNotEmpty) {
      queryParams.addAll(map);
    }
    return _networkClient.aliGet(
      path: '/equipment/ad_equipment_client',
      queryParams: queryParams,
      fromJson: (json) {
        final List<dynamic> data = json['ad_equipment_clients'];
        final List<AdEquipmentClient> result =
            data.map((e) => AdEquipmentClient.fromJson(e)).toList();
        final total = json['total'];
        if (queryParams.containsKey('ASC')) {
          if (queryParams.containsValue('price')) {
            return [
              result..sort((a, b) => (a.price ?? 0).compareTo(b.price ?? 0)),
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
        if (queryParams.containsKey('DESC')) {
          return [
            result..sort((a, b) => (b.price ?? 0).compareTo(a.price ?? 0)),
            total
          ];
        }

        return [result, total];
      },
    );
  }

  Future<List<AdClientInteracted>?> getAdClientInteractedList(
    String adId,
  ) async {
    final data = _networkClient.aliGet(
      path: '/ad_client/$adId/interacted',
      fromJson: (json) {
        final List<dynamic> data = json['ad_client_interacted'];
        final List<AdClientInteracted> result =
            data.map((e) => AdClientInteracted.fromJson(e)).toList();
        return result;
      },
    );
    return data;
  }

  Future<AdSmInteractedList?> getAdSMInteractedList(String adId) async {
    return _networkClient.aliGet(
      path: '/ad_sm/$adId/interacted',
      fromJson: AdSmInteractedList.fromJson,
    );
  }

  Future<List<AdEquipment>?> getFavoriteAdEquipmentList() async {
    return _networkClient.aliGet(
      path: '/equipment/ad_equipment/favorite',
      fromJson: (json) {
        final List<dynamic> data = json['favorites'];
        final List<AdEquipment> result =
            data.map((e) => AdEquipment.fromJson(e['ad_equipment'])).toList();
        return result;
      },
    );
  }

  Future<List<AdClient>?> getFavoriteAdSMClientList() async {
    return _networkClient.aliGet(
      path: '/ad_client/favorite',
      fromJson: (json) {
        final List<dynamic> data = json['favorites'];
        final List<AdClient> result =
            data.map((e) => AdClient.fromJson(e['ad_client'])).toList();
        return result;
      },
      queryParams: {'ad_client_detail': 'true'},
    );
  }

  Future<List<AdEquipmentClient>?> getFavoriteAdEquipmentClientList() async {
    return _networkClient.aliGet(
      path: '/equipment/ad_equipment_client/favorite',
      fromJson: (json) {
        final List<dynamic> data = json['favorites'];
        final result = data
            .map((e) => AdEquipmentClient.fromJson(e['ad_equipment_client']))
            .toList();
        return result;
      },
    );
  }

  Future<List<Category>> getSMCategoryList() async {
    final data = await _networkClient.aliGet(
      path: '/category',
      fromJson: (json) {
        final List<dynamic> data = json['categories'];
        final List<Category> result =
            data.map((e) => Category.fromJson(e)).toList();
        return result;
      },
    );
    return data ?? [];
  }

  Future<Category?> getSMCategoryWithID(int? id) async {
    if (id == null) {
      return null;
    }
    final data = await _networkClient.aliGet(
      path: '/category/$id',
      fromJson: (json) {
        final result = Category.fromJson(json['categories']);
        return result;
      },
    );
    return data;
  }

  Future<List<Category>?> getCMCategoryList() async {
    return _networkClient.aliGet(
      path: '/construction_material/category',
      fromJson: (json) {
        final List<dynamic> data = json['categories'];
        final List<Category> result =
            data.map((e) => Category.fromJson(e)).toList();
        return result;
      },
    );
  }

  Future<List<SubCategory>?> getCMSubCategoryList(String id) async {
    return _networkClient.aliGet(
      path: '/construction_material/category/$id/sub_category',
      fromJson: (json) {
        final List<dynamic> data = json['sub_categories'];
        final List<SubCategory> result =
            data.map((e) => SubCategory.fromJson(e)).toList();
        return result;
      },
    );
  }

  Future<List<SubCategory>?> getSVMSubCategoryList(String id) async {
    return _networkClient.aliGet(
      path: '/service/category/$id/sub_category',
      fromJson: (json) {
        final List<dynamic> data = json['sub_categories'];
        final List<SubCategory> result =
            data.map((e) => SubCategory.fromJson(e)).toList();
        return result;
      },
    );
  }

  Future<List<Category>?> getSVMCategoryList() async {
    return _networkClient.aliGet(
      path: '/service/category',
      fromJson: (json) {
        final List<dynamic> data = json['categories'];
        final List<Category> result =
            data.map((e) => Category.fromJson(e)).toList();
        return result;
      },
    );
  }

  Future<List<Category>> getEqCategoryList() async {
    final data = await _networkClient.aliGet(
      path: '/equipment/category',
      fromJson: (json) {
        final List<dynamic> data = json['categories'];
        final List<Category> result =
            data.map((e) => Category.fromJson(e)).toList();
        return result;
      },
    );
    return data ?? [];
  }

  Future<AdSpecializedMachinery?> getAdSMDetail(String adId) async {
    return _networkClient.aliGet(
      path: '/ad_sm/$adId',
      queryParams: {'document_detail': 'true'},
      fromJson: (json) {
        final data =
            AdSpecializedMachinery.fromJson(json['ad_specialized_machinery']);
        return data;
      },
    );
  }

  Future<AdEquipment?> getAdEquipmentDetail(String adId) async {
    return _networkClient.aliGet(
      path: '/equipment/ad_equipment/$adId',
      fromJson: (json) {
        return AdEquipment.fromJson(json['ad_equipment']);
      },
    );
  }

  Future<List<SubCategory>> getEqSubCategoryList(String? id) async {
    final data = await _networkClient.aliGet(
      path: '/equipment/category/$id/sub_category',
      fromJson: (json) {
        final List<dynamic> data = json['sub_categories'];
        final List<SubCategory> result =
            data.map((e) => SubCategory.fromJson(e)).toList();
        return result;
      },
    );
    return data ?? [];
  }

  Future<List<SubCategory>> getSmSubCategoryList(String? id) async {
    final data = await _networkClient.aliGet(
      path: '/$id/sub_category',
      fromJson: (json) {
        final List<dynamic> data = json['categories'];
        final List<SubCategory> result =
            data.map((e) => SubCategory.fromJson(e)).toList();
        return result;
      },
    );
    return data ?? [];
  }

  Future<AdClient?> getAdSMClientDetail(String adId) async {
    return _networkClient.aliGet(
      path: '/ad_client/$adId',
      fromJson: (json) {
        return AdClient.fromJson(json['ad_client']);
      },
    );
  }

  Future<AdEquipmentClient?> getAdEquipmentClientDetail(String adId) async {
    return _networkClient.aliGet(
      path: '/equipment/ad_equipment_client/$adId',
      fromJson: (json) {
        return AdEquipmentClient.fromJson(json['ad_equipment_client']);
      },
    );
  }

  Future<http.Response?> postAdClientInteracted({required String adId}) async {
    return _networkClient.aliPost('/ad_client/$adId/interacted', {});
  }

  Future<http.Response?> postAdSMInteracted({
    required String adId,
  }) async {
    return _networkClient.aliPost(
      '/ad_sm/$adId/interacted',
      {},
    );
  }

  Future<http.Response?> postFavoriteAdSM({
    required String id,
  }) async {
    return _networkClient.aliPost(
      '/ad_sm/$id/favorite',
      {},
    );
  }

  Future<http.Response?> postFavoriteAdEquipment({
    required String id,
  }) async {
    return _networkClient.aliPost(
      '/equipment/ad_equipment/$id/favorite',
      {},
    );
  }

  Future<http.Response?> postFavoriteAdSMClient({
    required String id,
  }) async {
    return _networkClient.aliPost(
      '/ad_client/$id/favorite',
      {},
    );
  }

  Future<http.Response?> postFavoriteAdEquipmentClient({
    required String id,
  }) async {
    return _networkClient.aliPost(
      '/equipment/ad_equipment_client/$id/favorite',
      {},
    );
  }

  Future<http.Response?> deleteAdSM(String adId) async {
    return await _networkClient.aliDelete(
      '/ad_sm/$adId',
    );
  }

  Future<http.Response?> deleteAdEquipment(String adId) async {
    return await _networkClient.aliDelete(
      '/equipment/ad_equipment/$adId',
    );
  }

  Future<http.Response?> deleteAdSMClient(String adId) async {
    return await _networkClient.aliDelete(
      '/ad_client/$adId',
    );
  }

  Future<http.Response?> deleteAdEquipmentClient(String adId) async {
    return await _networkClient.aliDelete(
      '/equipment/ad_equipment_client/$adId',
    );
  }

  Future<http.Response?> deleteFavoriteAdSM({required String id}) async {
    return await _networkClient.aliDelete('/ad_sm/$id/favorite');
  }

  Future<http.Response?> deleteFavoriteAdEquipment({required String id}) async {
    return await _networkClient
        .aliDelete('/equipment/ad_equipment/$id/favorite');
  }

  Future<http.Response?> deleteFavoriteAdSMClient({required String id}) async {
    return await _networkClient.aliDelete(
      '/ad_client/$id/favorite',
    );
  }

  Future<http.Response?> deleteFavoriteAdEquipmentClient(
      {required String id}) async {
    return await _networkClient.aliDelete(
      '/equipment/ad_equipment_client/$id/favorite',
    );
  }

  // Future<ReportReasonList?> getReasonsReport(BuildContext context) async {
  //   return _networkClient.get(
  //     path: '/report/reasons/ad',
  //     fromJson: ReportReasonList.fromJson,
  //     context,
  //   );
  // }

  Future<http.Response?> addReasonsAdEquipmentClient({
    required int ad_equipment_id,
    required String description,
    required int report_reasons_id,
  }) async {
    Map<String, String> headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    final token = await TokenService().getToken();
    headers['Authorization'] = 'Bearer $token';
    debugPrint(headers['Authorization'].toString());
    try {
      final body = {
        'ad_equipment_id': ad_equipment_id,
        'description': description,
        'report_reasons_id': 3
      };

      final response = await _networkClient.aliPost('/report/ad/eq', body);

      return response;
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<http.Response?> addReasonsAdSpecializedMachineryClient({
    required int ad_specialized_machinery_id,
    required String description,
    required int report_reasons_id,
  }) async {
    Map<String, String> headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    final token = await TokenService().getToken();
    headers['Authorization'] = 'Bearer $token';
    debugPrint(headers['Authorization'].toString());
    try {
      final body = {
        'ad_specialized_machinery_id': ad_specialized_machinery_id,
        'description': description,
        'report_reasons_id': 3
      };

      final response = await _networkClient.aliPost('/report/ad/sm', body);

      return response;
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<http.Response?> addReasonsAdSpecializedMachineryBussiness({
    required int ad_client_id,
    required String description,
    required int report_reasons_id,
  }) async {
    Map<String, String> headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    final token = await TokenService().getToken();
    headers['Authorization'] = 'Bearer $token';
    debugPrint(headers['Authorization'].toString());
    try {
      final body = {
        'ad_client_id': ad_client_id,
        'description': description,
        'report_reasons_id': 3
      };

      final response =
          await _networkClient.aliPost('/report/ad/sm_client', body);

      return response;
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<http.Response?> addReasonsEquipBussiness({
    required int ad_equipment_client_id,
    required String description,
    required int report_reasons_id,
  }) async {
    Map<String, String> headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    final token = await TokenService().getToken();
    headers['Authorization'] = 'Bearer $token';
    debugPrint(headers['Authorization'].toString());
    try {
      final body = {
        'ad_equipment_client_id': ad_equipment_client_id,
        'description': description,
        'report_reasons_id': 3
      };

      print(body.toString());

      final response =
          await _networkClient.aliPost('/report/ad/eq_client', body);

      return response;
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<List<Brand>> getSMBrands() async {
    final data = await _networkClient.aliGet(
        path: '/brand_sm',
        fromJson: (json) {
          final List<dynamic> data = json['brands'];
          final List<Brand> result =
              data.map((e) => Brand.fromJson(e)).toList();
          return result;
        });
    return data ?? [];
  }

  Future<List<Brand>> getEquipmentBrands() async {
    final data = await _networkClient.aliGet(
        path: '/equipment/brand',
        fromJson: (json) {
          final List<dynamic> data = json['brands'];
          final List<Brand> result =
              data.map((e) => Brand.fromJson(e)).toList();
          return result;
        });
    return data ?? [];
  }

  // Future<int?> getAdsTotalCategoryCountByCategoryId(
  //     int categoryId, BuildContext context) async {
  //   Map<String, dynamic> queryParams = {
  //     if (categoryId != null && categoryId != 0)
  //       'equipment_category_ids': categoryId.toString(),
  //   };

  //   final response = await _networkClient.get(context,
  //       path: '/ad_client',
  //       fromJson: AdSMClientList.fromJson,
  //       queryParams: queryParams);
  //   return response?.total;
  // }

  // Future<int?> getEqTotalCategoryCountByCategoryId(
  //     int categoryId, BuildContext context) async {
  //   print('cat:: $categoryId');
  //   Map<String, dynamic> queryParams = {
  //     if (categoryId != null && categoryId != 0)
  //       'equipment_category_ids': categoryId.toString(),
  //     'equipment_subcategory_detail': 'true',
  //     'documents_detail': 'true',
  //   };

  //   final response = await _networkClient.get(context,
  //       path: '/equipment/ad_equipment_client',
  //       fromJson: AdSMClientList.fromJson,
  //       queryParams: queryParams);
  //   print('response?.total ${response?.total}');
  //   return response?.total;
  // }
}
