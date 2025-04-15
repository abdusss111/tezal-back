import 'dart:developer';

import 'package:eqshare_mobile/app/app_safe_change_notifier.dart';
import 'package:eqshare_mobile/src/core/data/repositories/user_recently_viewed_ads_repo.dart';
import 'package:eqshare_mobile/src/core/presentation/services/providers/loading_change_notifier.dart';
import 'package:eqshare_mobile/src/features/ad/data/classes/ad_list_row_data.dart';
import 'package:eqshare_mobile/src/features/ad/data/models/ad_contruction_models/ad_construction_client_model.dart/ad_construction_client_model.dart';
import 'package:eqshare_mobile/src/features/ad/data/models/ad_contruction_models/ad_construction_model/ad_constrution_model.dart';
import 'package:eqshare_mobile/src/features/ad/data/models/ad_equipment_models/ad_equipment_client_model/ad_equipment_client.dart';
import 'package:eqshare_mobile/src/features/ad/data/models/ad_equipment_models/ad_equipment_model/ad_equipment.dart';
import 'package:eqshare_mobile/src/features/ad/data/models/ad_service_models/ad_service_client_model/ad_service_client_model.dart';
import 'package:eqshare_mobile/src/features/ad/data/models/ad_service_models/ad_service_model/ad_service_model.dart';
import 'package:eqshare_mobile/src/features/ad/data/models/ad_sm_models/ad_sm_client_model/ad_client.dart';
import 'package:eqshare_mobile/src/features/ad/data/models/ad_sm_models/ad_sm_model/ad_specialized_machinery.dart';
import 'package:eqshare_mobile/src/features/ad/data/repository/ad_api_client.dart';
import 'package:eqshare_mobile/src/features/ad/data/repository/ad_construction_materials_repository.dart';
import 'package:eqshare_mobile/src/features/ad/data/repository/ad_service_repository.dart';
import 'package:eqshare_mobile/src/global_widgets/global_values.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserRecentlyViewedAdsController extends AppSafeChangeNotifier
    with LoadingChangeNotifier {
  final Set<String> userRecentlyViewedList;
  final adApiClient = AdApiClient();
  List<AdListRowData> _showData = [];

  List<AdListRowData> get showData => _showData;

  UserRecentlyViewedAdsController({required this.userRecentlyViewedList}) {
    dataFetchers;
    initData();
  }

  UniqueKey uniqueKey = UniqueKey();

  Future<void> deleteList(BuildContext context) async {
    Provider.of<UserRecentlyViewedAdsRepo>(context, listen: false).delete();
    uniqueKey = UniqueKey();
    notifyListeners();
  }

  Future<void> getAllData(Set<AllServiceTypeEnum> dataTypes) async {
    final List<Future<List<AdListRowData>?>> allDataFutures = [];

    for (var type in dataTypes) {
      final fetcher = dataFetchers[type];
      if (fetcher != null) {
        final filteredIds = userRecentlyViewedList
            .where((element) =>
                getTypeFromSharedPreference(element)?.keys.first == type)
            .toList();
        final List<String> idList = filteredIds
            .map((e) => getTypeFromSharedPreference(e)!.values.first)
            .toList();
        allDataFutures.add(fetcher(idList));
      }
    }

    final allResults = await Future.wait(allDataFutures);

    final data = allResults.expand((element) => element ?? []).toList();

    for (final element in data) {
      if (element.runtimeType == AdListRowData().runtimeType) {
        _showData.add(element);
      } else {
        log(element.runtimeType.toString(), name: 'Runtipe');
        log(element.toString(), name: 'element');
        log('=' * 20, name: '[]]');
      }
    }

    setLoading(false);
    notifyListeners();
  }

  /// Метод для извлечения типа из строки
  Map<AllServiceTypeEnum, String>? getTypeFromSharedPreference(String value) {
    final parts = value.split('-');
    if (parts.length != 2) return null;

    final type = AllServiceTypeEnum.values.firstWhere(
      (e) => e.name == parts[0],
      orElse: () => AllServiceTypeEnum.UNKNOWN,
    );
    return {type: parts[1]};
  }

  /// Инициализация данных
  Future<void> initData() async {
    final Set<AllServiceTypeEnum> dataTypes = {};
    for (var element in userRecentlyViewedList) {
      final data = getTypeFromSharedPreference(element);
      if (data != null) {
        dataTypes.add(data.keys.first);
      }
    }
    await getAllData(dataTypes);
  }

  Future<List<AdListRowData>?> getData(
      List<String> idList,
      Future<dynamic> Function(String) apiCall,
      AdListRowData Function(dynamic)? getFromType) async {
    final List<AdListRowData> list = [];
    for (var id in idList) {
      final result = await apiCall(id);
      if (result != null) {
        if (getFromType != null) {
          list.add(getFromType(result));
        } else {
          list.add(result);
        }
      }
    }
    return list;
  }

  late final Map<AllServiceTypeEnum,
      Future<List<AdListRowData>?> Function(List<String>)> dataFetchers = {
    AllServiceTypeEnum.MACHINARY: getFromSm,
    AllServiceTypeEnum.EQUIPMENT: getFromEq,
    AllServiceTypeEnum.CM: getFromCm,
    AllServiceTypeEnum.SVM: getFromSVM,
    AllServiceTypeEnum.MACHINARY_CLIENT: getFromSmClient,
    AllServiceTypeEnum.EQUIPMENT_CLIENT: getFromEqClient,
    AllServiceTypeEnum.CM_CLIENT: getFromCMClient,
    AllServiceTypeEnum.SVM_CLIENT: getFromSVMClient,
  };

  /// Метод для получения данных по всем типам
  // Future<void> getAllData(Set<AllServiceTypeEnum> dataTypes) async {
  //   for (var type in dataTypes) {
  //     final fetcher = dataFetchers[type];
  //     if (fetcher != null) {
  //       await fetcher(userRecentlyViewedList);
  //     }
  //   }
  // }

  Future<List<AdListRowData>?> getFromSm(List<String> idList) async {
    return await getData(
      idList,
      adApiClient.getAdSMDetail,
      (result) => AdSpecializedMachinery.getAdListRowDataFromSM(result),
    );
  }

  Future<List<AdListRowData>?> getFromSmClient(List<String> idList) async {
    return await getData(
      idList,
      adApiClient.getAdSMClientDetail,
      (result) => AdClient.getAdListRowDataFromSM(result),
    );
  }

  Future<List<AdListRowData>?> getFromEq(List<String> idList) async {
    return await getData(
      idList,
      adApiClient.getAdEquipmentDetail,
      (result) => AdEquipment.getAdListRowDataFromSM(result),
    );
  }

  Future<List<AdListRowData>?> getFromEqClient(List<String> idList) async {
    return await getData(
      idList,
      adApiClient.getAdEquipmentClientDetail,
      (result) => AdEquipmentClient.getAdListRowDataFromSM(result),
    );
  }

  Future<List<AdListRowData>?> getFromCm(List<String> idList) async {
    return await getData(idList, (id) async {
      return AdConstrutionModel.getAdListRowDataFromSM(
        await AdConstructionMaterialsRepository()
                .getAdConstructionMaterialDetailForClient(adID: id) ??
            AdConstrutionModel(),
      );
    }, null);
  }

  Future<List<AdListRowData>?> getFromCMClient(List<String> idList) async {
    return await getData(idList, (id) async {
      return AdConstructionClientModel.getAdListRowDataFromSM(
        await AdConstructionMaterialsRepository()
                .getAdConstructionMaterialDetailForDriverOrOwner(adID: id) ??
            AdConstructionClientModel(),
      );
    }, null);
  }

  Future<List<AdListRowData>?> getFromSVM(List<String> idList) async {
    return await getData(idList, (id) async {
      return AdServiceModel.getAdListRowDataFromSM(
        await AdServiceRepository().getAdServiceDetailForClient(adID: id) ??
            AdServiceModel(),
      );
    }, null);
  }

  Future<List<AdListRowData>?> getFromSVMClient(List<String> idList) async {
    return await getData(idList, (id) async {
      return AdServiceClientModel.getAdListRowDataFromSM(
          await AdServiceRepository()
                  .getAdServiceDetailForDriverOrOwner(adID: id) ??
              AdServiceClientModel());
    }, null);
  }
}
