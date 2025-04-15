import 'package:eqshare_mobile/src/global_widgets/global_values.dart';
import 'package:eqshare_mobile/src/features/ad/data/models/ad_contruction_models/ad_construction_model/ad_constrution_model.dart';
import 'package:eqshare_mobile/src/features/ad/data/models/ad_equipment_models/ad_equipment_model/ad_equipment.dart';

import 'package:eqshare_mobile/src/features/ad/data/models/ad_service_models/ad_service_model/ad_service_model.dart';
import 'package:eqshare_mobile/src/features/ad/data/models/ad_sm_models/ad_sm_model/ad_specialized_machinery.dart';

import 'package:eqshare_mobile/src/features/ad/data/repository/ad_api_client.dart';
import 'package:eqshare_mobile/src/features/ad/data/repository/ad_construction_materials_repository.dart';
import 'package:eqshare_mobile/src/features/ad/data/repository/ad_service_repository.dart';

class DataHandlerFactory {
  static AdDataHandler getHandler(ServiceTypeEnum serviceType) {
    switch (serviceType) {
      case ServiceTypeEnum.MACHINARY:
        return MachineryDataHandler();
      case ServiceTypeEnum.EQUIPMENT:
        return EquipmentDataHandler();
      case ServiceTypeEnum.CM:
        return CmDataHandler();
      case ServiceTypeEnum.SVM:
        return SvmDataHandler();
      default:
        throw Exception('Unknown service type');
    }
  }
}

abstract class AdDataHandler {
  List<dynamic> parseData(Map<String, dynamic> json);
  List<dynamic> createObjects(List<dynamic> jsonData);
  Future<List<dynamic>?> getDataFromServer(
      {int? categoryID, int? subCategoryID, int? cityID});
}

class MachineryDataHandler implements AdDataHandler {
  @override
  List<dynamic> parseData(Map<String, dynamic> json) {
    return json['result']['ad_specialized_machineries'];
  }

  @override
  List<dynamic> createObjects(List<dynamic> jsonData) {
    return jsonData.map((map) => AdSpecializedMachinery.fromJson(map)).toList();
  }

  @override
  Future<List<AdSpecializedMachinery>?> getDataFromServer(
      {int? categoryID, int? subCategoryID, int? cityID}) async {
    final map = {
      if (subCategoryID != null && subCategoryID != 0)
        'type_id': subCategoryID.toString(),
      if (categoryID != null && categoryID != 0)
        'sub_category_id': categoryID.toString(),
      if (cityID != null)
        'city_id': cityID.toString(),
      'document_detail': 'true'
    };
    final data = await AdApiClient().getAdSMList(map: map);

    return data;
  }
}

class EquipmentDataHandler implements AdDataHandler {
  @override
  List<dynamic> parseData(Map<String, dynamic> json) {
    return json['result']['ad_equipments'];
  }

  @override
  List<dynamic> createObjects(List<dynamic> jsonData) {
    return jsonData.map((map) => AdEquipment.fromJson(map)).toList();
  }

  @override
  Future<List<AdEquipment>?> getDataFromServer(
      {int? categoryID, int? subCategoryID, int? cityID}) {
    return AdApiClient().getAdEquipmentList(
      categoryId: categoryID,
      subCategoryId: subCategoryID,
      cityId: cityID
    );
  }
}

class CmDataHandler implements AdDataHandler {
  @override
  List<dynamic> parseData(Map<String, dynamic> json) {
    return json['result']['ad_construction_material'];
  }

  @override
  List<dynamic> createObjects(List<dynamic> jsonData) {
    return jsonData.map((map) => AdConstrutionModel.fromJson(map)).toList();
  }

  @override
  Future<List<AdConstrutionModel>?> getDataFromServer(
      {int? categoryID, int? subCategoryID, int? cityID}) async {
    return AdConstructionMaterialsRepository()
        .getAdConstructionMaterialListForClient(queryParametersFromPage: {
      if (subCategoryID != null && subCategoryID != 0)
        'construction_material_subcategory_id': subCategoryID,
      if (categoryID != null && categoryID != 0)
        'construction_material_category_id': categoryID,
      if (cityID != null)
        'city_id': cityID.toString(),
        'documents_detail': 'true',

    });
  }
}

class SvmDataHandler implements AdDataHandler {
  @override
  List<dynamic> parseData(Map<String, dynamic> json) {
    return json['result']['ad_service'];
  }

  @override
  List<dynamic> createObjects(List<dynamic> jsonData) {
    return jsonData.map((map) => AdServiceModel.fromJson(map)).toList();
  }

  @override
  Future<List<AdServiceModel>?> getDataFromServer(
      {int? categoryID, int? subCategoryID, int? cityID}) {
    return AdServiceRepository()
        .getAdServiceListForClient(queryParametersFromPage: {
      if (subCategoryID != null && subCategoryID != 0)
        'service_subcategory_id': subCategoryID,
      if (categoryID != null && categoryID != 0)
        'service_category_id': categoryID,
      if (cityID != null)
        'city_id': cityID.toString(),
        'documents_detail': 'true',

    });
  }
}
