import 'package:eqshare_mobile/src/core/data/models/user_model/user.dart';
import 'package:eqshare_mobile/src/features/requests/data/models/construction_request/construction_request_client/construction_request_client_model.dart';
import 'package:eqshare_mobile/src/features/requests/data/models/specialized_machinery_request_models/specialized_machinery_request_client_model/specialized_machinery_request_client.dart';
import 'package:eqshare_mobile/src/features/requests/data/models/construction_request/construction_request/construction_request_model.dart';
import 'package:eqshare_mobile/src/features/requests/data/models/equipment_request/equipment_client_request_model/request_ad_equipment_client.dart';
import 'package:eqshare_mobile/src/features/requests/data/models/equipment_request/equipment_request_model/request_ad_equipment.dart';
import 'package:eqshare_mobile/src/features/requests/data/models/service_request/service_request/service_request_model.dart';
import 'package:eqshare_mobile/src/features/requests/data/models/service_request/service_request_client/service_request_client_model.dart';
import 'package:eqshare_mobile/src/features/requests/data/models/specialized_machinery_request_models/specialized_machinery_request_model/specialized_machinery_request.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'request_execution.freezed.dart';
part 'request_execution.g.dart';

@freezed
class RequestExecution with _$RequestExecution {
  factory RequestExecution({
    int? id,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
    @JsonKey(name: 'deleted_at') dynamic deletedAt,
    @JsonKey(name: 'specialized_machinery_request_id')
    int? specializedMachineryRequestId,
    @JsonKey(name: 'specialized_machinery_request')
    SpecializedMachineryRequest? specializedMachineryRequest,
    @JsonKey(name: 'request_ad_equipment_client')
    RequestAdEquipmentClient? requestAdEquipmentClient,
    @JsonKey(name: 'request_ad_equipment')
    RequestAdEquipment? requestAdEquipment,
    @JsonKey(name: 'request_id') int? requestId,
    SpecializedMachineryRequestClient? request,
    String? status,
    @JsonKey(name: 'work_started_clinet') bool? workStartedClinet,
    @JsonKey(name: 'work_started_driver') bool? workStartedDriver,
    @JsonKey(name: 'work_started_at') DateTime? workStartedAt,
    @JsonKey(name: 'work_end_at') dynamic workEndAt,
    int? assigned,
    @JsonKey(name: 'user_assigned') User? userAssigned,
    @JsonKey(name: 'driver_id') int? driverID,
    double? latitude,
    double? longitude,
    double? rate,
    required String title,
    @JsonKey(name: 'url_foto') List<String>? urlFoto,
    @JsonKey(name: 'finish_address') String? finishAddress,
    @JsonKey(name: 'finish_latitude') double? finishLatitude,
    @JsonKey(name: 'finish_longitude') double? finishLongitude,
    User? driver,
     @JsonKey(name: 'clinet')  User? client,
    @JsonKey(name: 'start_lease_at') String? startLeaseAt,
    @JsonKey(name: 'rate_comment') String? rateComment,
    @JsonKey(name: 'end_lease_at') dynamic endLeaseAt,
    @JsonKey(name: 'driver_payment_amount') int? price,
    @JsonKey(name: 'request_ad_construction_material_client_id')
    int? requestAdConstructionMaterialClientID,
    @JsonKey(name: 'request_ad_construction_material_client')
    ConstructionRequestClientModel? constructionRequestClientModel,
    @JsonKey(name: 'request_ad_construction_material')
    ConstructionRequestModel? constructionRequesttModel,
    @JsonKey(name: 'request_ad_service')
    ServiceRequestModel? serviceRequestModel,
    @JsonKey(name: 'request_ad_service_id') int? serviceRequestModelID,
    @JsonKey(name: 'request_ad_service_client_id')
    int? serviceRequestClientModelID,
    @JsonKey(name: 'request_ad_service_client')
    ServiceRequestClientModel? serviceRequestClientModel,
    @JsonKey(name: 'sub_category_name') String? subCategory,
    @JsonKey(name: 'price') double? priceForHour,



    String? src,
  }) = _RequestExecution;

  factory RequestExecution.fromJson(Map<String, dynamic> json) =>
      _$RequestExecutionFromJson(json);

  static RequestExecution getShorterData(Map<String, dynamic> json) {
    return RequestExecution(

      title: json['title'] as String? ?? '',
      id: json['id'] as int?,
      src: json['src'] as String? ?? '',
      startLeaseAt: json['start_lease_at'] as String? ?? '',
      endLeaseAt: json['end_lease_at'] as dynamic,
      status: json['status'] as String? ?? '',
      finishAddress: json['finish_address'] as String? ?? '',
      driverID: json['driver_id'] as int? ?? 0,
      assigned: json['assigned'] as int? ?? 0,
      price: json['price'] as int? ?? 0,

      // urlFoto: json['url_foto'] as List<dynamic>? ?? <dynamic>[]
    );
  }

  static RequestExecution getShorterDataWithOutTypes(
      Map<String, dynamic> json) {
    return RequestExecution(
      title: json['title'] as String? ?? '',
      id: json['id'] as int?,
      src: json['src'] as String? ?? '',
      // startLeaseAt: json['start_lease_at'] as String? ?? '',
      endLeaseAt: json['end_lease_at'] as dynamic,
      status: (json['status'] as String? ?? '').toString(),
      finishAddress: json['finish_address'] as String? ?? '',
      // urlFoto: json['url_foto'] as List<String>? ?? <String>[],
      driverID: json['driver_id'] as int? ?? 0,
      assigned: json['assigned'] as int? ?? 0,
      createdAt: json['created_at'] as DateTime? ?? DateTime.now(),
    );
  }
}
