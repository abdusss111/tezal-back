// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'request_execution.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RequestExecutionImpl _$$RequestExecutionImplFromJson(
        Map<String, dynamic> json) =>
    _$RequestExecutionImpl(
      id: (json['id'] as num?)?.toInt(),
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
      deletedAt: json['deleted_at'],
      specializedMachineryRequestId:
          (json['specialized_machinery_request_id'] as num?)?.toInt(),
      specializedMachineryRequest: json['specialized_machinery_request'] == null
          ? null
          : SpecializedMachineryRequest.fromJson(
              json['specialized_machinery_request'] as Map<String, dynamic>),
      requestAdEquipmentClient: json['request_ad_equipment_client'] == null
          ? null
          : RequestAdEquipmentClient.fromJson(
              json['request_ad_equipment_client'] as Map<String, dynamic>),
      requestAdEquipment: json['request_ad_equipment'] == null
          ? null
          : RequestAdEquipment.fromJson(
              json['request_ad_equipment'] as Map<String, dynamic>),
      requestId: (json['request_id'] as num?)?.toInt(),
      request: json['request'] == null
          ? null
          : SpecializedMachineryRequestClient.fromJson(
              json['request'] as Map<String, dynamic>),
      status: json['status'] as String?,
      workStartedClinet: json['work_started_clinet'] as bool?,
      workStartedDriver: json['work_started_driver'] as bool?,
      workStartedAt: json['work_started_at'] == null
          ? null
          : DateTime.parse(json['work_started_at'] as String),
      workEndAt: json['work_end_at'],
      assigned: (json['assigned'] as num?)?.toInt(),
      userAssigned: json['user_assigned'] == null
          ? null
          : User.fromJson(json['user_assigned'] as Map<String, dynamic>),
      driverID: (json['driver_id'] as num?)?.toInt(),
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      rate: (json['rate'] as num?)?.toDouble(),
      title: json['title'] as String,
      urlFoto: (json['url_foto'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      finishAddress: json['finish_address'] as String?,
      finishLatitude: (json['finish_latitude'] as num?)?.toDouble(),
      finishLongitude: (json['finish_longitude'] as num?)?.toDouble(),
      driver: json['driver'] == null
          ? null
          : User.fromJson(json['driver'] as Map<String, dynamic>),
      client: json['clinet'] == null
          ? null
          : User.fromJson(json['clinet'] as Map<String, dynamic>),
      startLeaseAt: json['start_lease_at'] as String?,
      rateComment: json['rate_comment'] as String?,
      endLeaseAt: json['end_lease_at'],
      price: (json['driver_payment_amount'] as num?)?.toInt(),
      requestAdConstructionMaterialClientID:
          (json['request_ad_construction_material_client_id'] as num?)?.toInt(),
      constructionRequestClientModel:
          json['request_ad_construction_material_client'] == null
              ? null
              : ConstructionRequestClientModel.fromJson(
                  json['request_ad_construction_material_client']
                      as Map<String, dynamic>),
      constructionRequesttModel: json['request_ad_construction_material'] ==
              null
          ? null
          : ConstructionRequestModel.fromJson(
              json['request_ad_construction_material'] as Map<String, dynamic>),
      serviceRequestModel: json['request_ad_service'] == null
          ? null
          : ServiceRequestModel.fromJson(
              json['request_ad_service'] as Map<String, dynamic>),
      serviceRequestModelID: (json['request_ad_service_id'] as num?)?.toInt(),
      serviceRequestClientModelID:
          (json['request_ad_service_client_id'] as num?)?.toInt(),
      serviceRequestClientModel: json['request_ad_service_client'] == null
          ? null
          : ServiceRequestClientModel.fromJson(
              json['request_ad_service_client'] as Map<String, dynamic>),
      subCategory: json['sub_category_name'] as String?,
      priceForHour: (json['price'] as num?)?.toDouble(),
      src: json['src'] as String?,
    );

Map<String, dynamic> _$$RequestExecutionImplToJson(
        _$RequestExecutionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
      'deleted_at': instance.deletedAt,
      'specialized_machinery_request_id':
          instance.specializedMachineryRequestId,
      'specialized_machinery_request': instance.specializedMachineryRequest,
      'request_ad_equipment_client': instance.requestAdEquipmentClient,
      'request_ad_equipment': instance.requestAdEquipment,
      'request_id': instance.requestId,
      'request': instance.request,
      'status': instance.status,
      'work_started_clinet': instance.workStartedClinet,
      'work_started_driver': instance.workStartedDriver,
      'work_started_at': instance.workStartedAt?.toIso8601String(),
      'work_end_at': instance.workEndAt,
      'assigned': instance.assigned,
      'user_assigned': instance.userAssigned,
      'driver_id': instance.driverID,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'rate': instance.rate,
      'title': instance.title,
      'url_foto': instance.urlFoto,
      'finish_address': instance.finishAddress,
      'finish_latitude': instance.finishLatitude,
      'finish_longitude': instance.finishLongitude,
      'driver': instance.driver,
      'clinet': instance.client,
      'start_lease_at': instance.startLeaseAt,
      'rate_comment': instance.rateComment,
      'end_lease_at': instance.endLeaseAt,
      'driver_payment_amount': instance.price,
      'request_ad_construction_material_client_id':
          instance.requestAdConstructionMaterialClientID,
      'request_ad_construction_material_client':
          instance.constructionRequestClientModel,
      'request_ad_construction_material': instance.constructionRequesttModel,
      'request_ad_service': instance.serviceRequestModel,
      'request_ad_service_id': instance.serviceRequestModelID,
      'request_ad_service_client_id': instance.serviceRequestClientModelID,
      'request_ad_service_client': instance.serviceRequestClientModel,
      'sub_category_name': instance.subCategory,
      'price': instance.priceForHour,
      'src': instance.src,
    };
