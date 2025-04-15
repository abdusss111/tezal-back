// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'request_execution.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

RequestExecution _$RequestExecutionFromJson(Map<String, dynamic> json) {
  return _RequestExecution.fromJson(json);
}

/// @nodoc
mixin _$RequestExecution {
  int? get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'deleted_at')
  dynamic get deletedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'specialized_machinery_request_id')
  int? get specializedMachineryRequestId => throw _privateConstructorUsedError;
  @JsonKey(name: 'specialized_machinery_request')
  SpecializedMachineryRequest? get specializedMachineryRequest =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'request_ad_equipment_client')
  RequestAdEquipmentClient? get requestAdEquipmentClient =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'request_ad_equipment')
  RequestAdEquipment? get requestAdEquipment =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'request_id')
  int? get requestId => throw _privateConstructorUsedError;
  SpecializedMachineryRequestClient? get request =>
      throw _privateConstructorUsedError;
  String? get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'work_started_clinet')
  bool? get workStartedClinet => throw _privateConstructorUsedError;
  @JsonKey(name: 'work_started_driver')
  bool? get workStartedDriver => throw _privateConstructorUsedError;
  @JsonKey(name: 'work_started_at')
  DateTime? get workStartedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'work_end_at')
  dynamic get workEndAt => throw _privateConstructorUsedError;
  int? get assigned => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_assigned')
  User? get userAssigned => throw _privateConstructorUsedError;
  @JsonKey(name: 'driver_id')
  int? get driverID => throw _privateConstructorUsedError;
  double? get latitude => throw _privateConstructorUsedError;
  double? get longitude => throw _privateConstructorUsedError;
  double? get rate => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  @JsonKey(name: 'url_foto')
  List<String>? get urlFoto => throw _privateConstructorUsedError;
  @JsonKey(name: 'finish_address')
  String? get finishAddress => throw _privateConstructorUsedError;
  @JsonKey(name: 'finish_latitude')
  double? get finishLatitude => throw _privateConstructorUsedError;
  @JsonKey(name: 'finish_longitude')
  double? get finishLongitude => throw _privateConstructorUsedError;
  User? get driver => throw _privateConstructorUsedError;
  @JsonKey(name: 'clinet')
  User? get client => throw _privateConstructorUsedError;
  @JsonKey(name: 'start_lease_at')
  String? get startLeaseAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'rate_comment')
  String? get rateComment => throw _privateConstructorUsedError;
  @JsonKey(name: 'end_lease_at')
  dynamic get endLeaseAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'driver_payment_amount')
  int? get price => throw _privateConstructorUsedError;
  @JsonKey(name: 'request_ad_construction_material_client_id')
  int? get requestAdConstructionMaterialClientID =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'request_ad_construction_material_client')
  ConstructionRequestClientModel? get constructionRequestClientModel =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'request_ad_construction_material')
  ConstructionRequestModel? get constructionRequesttModel =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'request_ad_service')
  ServiceRequestModel? get serviceRequestModel =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'request_ad_service_id')
  int? get serviceRequestModelID => throw _privateConstructorUsedError;
  @JsonKey(name: 'request_ad_service_client_id')
  int? get serviceRequestClientModelID => throw _privateConstructorUsedError;
  @JsonKey(name: 'request_ad_service_client')
  ServiceRequestClientModel? get serviceRequestClientModel =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'sub_category_name')
  String? get subCategory => throw _privateConstructorUsedError;
  @JsonKey(name: 'price')
  double? get priceForHour => throw _privateConstructorUsedError;
  String? get src => throw _privateConstructorUsedError;

  /// Serializes this RequestExecution to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RequestExecution
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RequestExecutionCopyWith<RequestExecution> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RequestExecutionCopyWith<$Res> {
  factory $RequestExecutionCopyWith(
          RequestExecution value, $Res Function(RequestExecution) then) =
      _$RequestExecutionCopyWithImpl<$Res, RequestExecution>;
  @useResult
  $Res call(
      {int? id,
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
      String title,
      @JsonKey(name: 'url_foto') List<String>? urlFoto,
      @JsonKey(name: 'finish_address') String? finishAddress,
      @JsonKey(name: 'finish_latitude') double? finishLatitude,
      @JsonKey(name: 'finish_longitude') double? finishLongitude,
      User? driver,
      @JsonKey(name: 'clinet') User? client,
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
      String? src});

  $SpecializedMachineryRequestCopyWith<$Res>? get specializedMachineryRequest;
  $RequestAdEquipmentClientCopyWith<$Res>? get requestAdEquipmentClient;
  $RequestAdEquipmentCopyWith<$Res>? get requestAdEquipment;
  $SpecializedMachineryRequestClientCopyWith<$Res>? get request;
  $UserCopyWith<$Res>? get userAssigned;
  $UserCopyWith<$Res>? get driver;
  $UserCopyWith<$Res>? get client;
  $ConstructionRequestClientModelCopyWith<$Res>?
      get constructionRequestClientModel;
  $ConstructionRequestModelCopyWith<$Res>? get constructionRequesttModel;
  $ServiceRequestModelCopyWith<$Res>? get serviceRequestModel;
  $ServiceRequestClientModelCopyWith<$Res>? get serviceRequestClientModel;
}

/// @nodoc
class _$RequestExecutionCopyWithImpl<$Res, $Val extends RequestExecution>
    implements $RequestExecutionCopyWith<$Res> {
  _$RequestExecutionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RequestExecution
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? deletedAt = freezed,
    Object? specializedMachineryRequestId = freezed,
    Object? specializedMachineryRequest = freezed,
    Object? requestAdEquipmentClient = freezed,
    Object? requestAdEquipment = freezed,
    Object? requestId = freezed,
    Object? request = freezed,
    Object? status = freezed,
    Object? workStartedClinet = freezed,
    Object? workStartedDriver = freezed,
    Object? workStartedAt = freezed,
    Object? workEndAt = freezed,
    Object? assigned = freezed,
    Object? userAssigned = freezed,
    Object? driverID = freezed,
    Object? latitude = freezed,
    Object? longitude = freezed,
    Object? rate = freezed,
    Object? title = null,
    Object? urlFoto = freezed,
    Object? finishAddress = freezed,
    Object? finishLatitude = freezed,
    Object? finishLongitude = freezed,
    Object? driver = freezed,
    Object? client = freezed,
    Object? startLeaseAt = freezed,
    Object? rateComment = freezed,
    Object? endLeaseAt = freezed,
    Object? price = freezed,
    Object? requestAdConstructionMaterialClientID = freezed,
    Object? constructionRequestClientModel = freezed,
    Object? constructionRequesttModel = freezed,
    Object? serviceRequestModel = freezed,
    Object? serviceRequestModelID = freezed,
    Object? serviceRequestClientModelID = freezed,
    Object? serviceRequestClientModel = freezed,
    Object? subCategory = freezed,
    Object? priceForHour = freezed,
    Object? src = freezed,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      deletedAt: freezed == deletedAt
          ? _value.deletedAt
          : deletedAt // ignore: cast_nullable_to_non_nullable
              as dynamic,
      specializedMachineryRequestId: freezed == specializedMachineryRequestId
          ? _value.specializedMachineryRequestId
          : specializedMachineryRequestId // ignore: cast_nullable_to_non_nullable
              as int?,
      specializedMachineryRequest: freezed == specializedMachineryRequest
          ? _value.specializedMachineryRequest
          : specializedMachineryRequest // ignore: cast_nullable_to_non_nullable
              as SpecializedMachineryRequest?,
      requestAdEquipmentClient: freezed == requestAdEquipmentClient
          ? _value.requestAdEquipmentClient
          : requestAdEquipmentClient // ignore: cast_nullable_to_non_nullable
              as RequestAdEquipmentClient?,
      requestAdEquipment: freezed == requestAdEquipment
          ? _value.requestAdEquipment
          : requestAdEquipment // ignore: cast_nullable_to_non_nullable
              as RequestAdEquipment?,
      requestId: freezed == requestId
          ? _value.requestId
          : requestId // ignore: cast_nullable_to_non_nullable
              as int?,
      request: freezed == request
          ? _value.request
          : request // ignore: cast_nullable_to_non_nullable
              as SpecializedMachineryRequestClient?,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String?,
      workStartedClinet: freezed == workStartedClinet
          ? _value.workStartedClinet
          : workStartedClinet // ignore: cast_nullable_to_non_nullable
              as bool?,
      workStartedDriver: freezed == workStartedDriver
          ? _value.workStartedDriver
          : workStartedDriver // ignore: cast_nullable_to_non_nullable
              as bool?,
      workStartedAt: freezed == workStartedAt
          ? _value.workStartedAt
          : workStartedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      workEndAt: freezed == workEndAt
          ? _value.workEndAt
          : workEndAt // ignore: cast_nullable_to_non_nullable
              as dynamic,
      assigned: freezed == assigned
          ? _value.assigned
          : assigned // ignore: cast_nullable_to_non_nullable
              as int?,
      userAssigned: freezed == userAssigned
          ? _value.userAssigned
          : userAssigned // ignore: cast_nullable_to_non_nullable
              as User?,
      driverID: freezed == driverID
          ? _value.driverID
          : driverID // ignore: cast_nullable_to_non_nullable
              as int?,
      latitude: freezed == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double?,
      longitude: freezed == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double?,
      rate: freezed == rate
          ? _value.rate
          : rate // ignore: cast_nullable_to_non_nullable
              as double?,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      urlFoto: freezed == urlFoto
          ? _value.urlFoto
          : urlFoto // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      finishAddress: freezed == finishAddress
          ? _value.finishAddress
          : finishAddress // ignore: cast_nullable_to_non_nullable
              as String?,
      finishLatitude: freezed == finishLatitude
          ? _value.finishLatitude
          : finishLatitude // ignore: cast_nullable_to_non_nullable
              as double?,
      finishLongitude: freezed == finishLongitude
          ? _value.finishLongitude
          : finishLongitude // ignore: cast_nullable_to_non_nullable
              as double?,
      driver: freezed == driver
          ? _value.driver
          : driver // ignore: cast_nullable_to_non_nullable
              as User?,
      client: freezed == client
          ? _value.client
          : client // ignore: cast_nullable_to_non_nullable
              as User?,
      startLeaseAt: freezed == startLeaseAt
          ? _value.startLeaseAt
          : startLeaseAt // ignore: cast_nullable_to_non_nullable
              as String?,
      rateComment: freezed == rateComment
          ? _value.rateComment
          : rateComment // ignore: cast_nullable_to_non_nullable
              as String?,
      endLeaseAt: freezed == endLeaseAt
          ? _value.endLeaseAt
          : endLeaseAt // ignore: cast_nullable_to_non_nullable
              as dynamic,
      price: freezed == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as int?,
      requestAdConstructionMaterialClientID: freezed ==
              requestAdConstructionMaterialClientID
          ? _value.requestAdConstructionMaterialClientID
          : requestAdConstructionMaterialClientID // ignore: cast_nullable_to_non_nullable
              as int?,
      constructionRequestClientModel: freezed == constructionRequestClientModel
          ? _value.constructionRequestClientModel
          : constructionRequestClientModel // ignore: cast_nullable_to_non_nullable
              as ConstructionRequestClientModel?,
      constructionRequesttModel: freezed == constructionRequesttModel
          ? _value.constructionRequesttModel
          : constructionRequesttModel // ignore: cast_nullable_to_non_nullable
              as ConstructionRequestModel?,
      serviceRequestModel: freezed == serviceRequestModel
          ? _value.serviceRequestModel
          : serviceRequestModel // ignore: cast_nullable_to_non_nullable
              as ServiceRequestModel?,
      serviceRequestModelID: freezed == serviceRequestModelID
          ? _value.serviceRequestModelID
          : serviceRequestModelID // ignore: cast_nullable_to_non_nullable
              as int?,
      serviceRequestClientModelID: freezed == serviceRequestClientModelID
          ? _value.serviceRequestClientModelID
          : serviceRequestClientModelID // ignore: cast_nullable_to_non_nullable
              as int?,
      serviceRequestClientModel: freezed == serviceRequestClientModel
          ? _value.serviceRequestClientModel
          : serviceRequestClientModel // ignore: cast_nullable_to_non_nullable
              as ServiceRequestClientModel?,
      subCategory: freezed == subCategory
          ? _value.subCategory
          : subCategory // ignore: cast_nullable_to_non_nullable
              as String?,
      priceForHour: freezed == priceForHour
          ? _value.priceForHour
          : priceForHour // ignore: cast_nullable_to_non_nullable
              as double?,
      src: freezed == src
          ? _value.src
          : src // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }

  /// Create a copy of RequestExecution
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SpecializedMachineryRequestCopyWith<$Res>? get specializedMachineryRequest {
    if (_value.specializedMachineryRequest == null) {
      return null;
    }

    return $SpecializedMachineryRequestCopyWith<$Res>(
        _value.specializedMachineryRequest!, (value) {
      return _then(_value.copyWith(specializedMachineryRequest: value) as $Val);
    });
  }

  /// Create a copy of RequestExecution
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $RequestAdEquipmentClientCopyWith<$Res>? get requestAdEquipmentClient {
    if (_value.requestAdEquipmentClient == null) {
      return null;
    }

    return $RequestAdEquipmentClientCopyWith<$Res>(
        _value.requestAdEquipmentClient!, (value) {
      return _then(_value.copyWith(requestAdEquipmentClient: value) as $Val);
    });
  }

  /// Create a copy of RequestExecution
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $RequestAdEquipmentCopyWith<$Res>? get requestAdEquipment {
    if (_value.requestAdEquipment == null) {
      return null;
    }

    return $RequestAdEquipmentCopyWith<$Res>(_value.requestAdEquipment!,
        (value) {
      return _then(_value.copyWith(requestAdEquipment: value) as $Val);
    });
  }

  /// Create a copy of RequestExecution
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SpecializedMachineryRequestClientCopyWith<$Res>? get request {
    if (_value.request == null) {
      return null;
    }

    return $SpecializedMachineryRequestClientCopyWith<$Res>(_value.request!,
        (value) {
      return _then(_value.copyWith(request: value) as $Val);
    });
  }

  /// Create a copy of RequestExecution
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UserCopyWith<$Res>? get userAssigned {
    if (_value.userAssigned == null) {
      return null;
    }

    return $UserCopyWith<$Res>(_value.userAssigned!, (value) {
      return _then(_value.copyWith(userAssigned: value) as $Val);
    });
  }

  /// Create a copy of RequestExecution
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UserCopyWith<$Res>? get driver {
    if (_value.driver == null) {
      return null;
    }

    return $UserCopyWith<$Res>(_value.driver!, (value) {
      return _then(_value.copyWith(driver: value) as $Val);
    });
  }

  /// Create a copy of RequestExecution
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UserCopyWith<$Res>? get client {
    if (_value.client == null) {
      return null;
    }

    return $UserCopyWith<$Res>(_value.client!, (value) {
      return _then(_value.copyWith(client: value) as $Val);
    });
  }

  /// Create a copy of RequestExecution
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ConstructionRequestClientModelCopyWith<$Res>?
      get constructionRequestClientModel {
    if (_value.constructionRequestClientModel == null) {
      return null;
    }

    return $ConstructionRequestClientModelCopyWith<$Res>(
        _value.constructionRequestClientModel!, (value) {
      return _then(
          _value.copyWith(constructionRequestClientModel: value) as $Val);
    });
  }

  /// Create a copy of RequestExecution
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ConstructionRequestModelCopyWith<$Res>? get constructionRequesttModel {
    if (_value.constructionRequesttModel == null) {
      return null;
    }

    return $ConstructionRequestModelCopyWith<$Res>(
        _value.constructionRequesttModel!, (value) {
      return _then(_value.copyWith(constructionRequesttModel: value) as $Val);
    });
  }

  /// Create a copy of RequestExecution
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ServiceRequestModelCopyWith<$Res>? get serviceRequestModel {
    if (_value.serviceRequestModel == null) {
      return null;
    }

    return $ServiceRequestModelCopyWith<$Res>(_value.serviceRequestModel!,
        (value) {
      return _then(_value.copyWith(serviceRequestModel: value) as $Val);
    });
  }

  /// Create a copy of RequestExecution
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ServiceRequestClientModelCopyWith<$Res>? get serviceRequestClientModel {
    if (_value.serviceRequestClientModel == null) {
      return null;
    }

    return $ServiceRequestClientModelCopyWith<$Res>(
        _value.serviceRequestClientModel!, (value) {
      return _then(_value.copyWith(serviceRequestClientModel: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$RequestExecutionImplCopyWith<$Res>
    implements $RequestExecutionCopyWith<$Res> {
  factory _$$RequestExecutionImplCopyWith(_$RequestExecutionImpl value,
          $Res Function(_$RequestExecutionImpl) then) =
      __$$RequestExecutionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int? id,
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
      String title,
      @JsonKey(name: 'url_foto') List<String>? urlFoto,
      @JsonKey(name: 'finish_address') String? finishAddress,
      @JsonKey(name: 'finish_latitude') double? finishLatitude,
      @JsonKey(name: 'finish_longitude') double? finishLongitude,
      User? driver,
      @JsonKey(name: 'clinet') User? client,
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
      String? src});

  @override
  $SpecializedMachineryRequestCopyWith<$Res>? get specializedMachineryRequest;
  @override
  $RequestAdEquipmentClientCopyWith<$Res>? get requestAdEquipmentClient;
  @override
  $RequestAdEquipmentCopyWith<$Res>? get requestAdEquipment;
  @override
  $SpecializedMachineryRequestClientCopyWith<$Res>? get request;
  @override
  $UserCopyWith<$Res>? get userAssigned;
  @override
  $UserCopyWith<$Res>? get driver;
  @override
  $UserCopyWith<$Res>? get client;
  @override
  $ConstructionRequestClientModelCopyWith<$Res>?
      get constructionRequestClientModel;
  @override
  $ConstructionRequestModelCopyWith<$Res>? get constructionRequesttModel;
  @override
  $ServiceRequestModelCopyWith<$Res>? get serviceRequestModel;
  @override
  $ServiceRequestClientModelCopyWith<$Res>? get serviceRequestClientModel;
}

/// @nodoc
class __$$RequestExecutionImplCopyWithImpl<$Res>
    extends _$RequestExecutionCopyWithImpl<$Res, _$RequestExecutionImpl>
    implements _$$RequestExecutionImplCopyWith<$Res> {
  __$$RequestExecutionImplCopyWithImpl(_$RequestExecutionImpl _value,
      $Res Function(_$RequestExecutionImpl) _then)
      : super(_value, _then);

  /// Create a copy of RequestExecution
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? deletedAt = freezed,
    Object? specializedMachineryRequestId = freezed,
    Object? specializedMachineryRequest = freezed,
    Object? requestAdEquipmentClient = freezed,
    Object? requestAdEquipment = freezed,
    Object? requestId = freezed,
    Object? request = freezed,
    Object? status = freezed,
    Object? workStartedClinet = freezed,
    Object? workStartedDriver = freezed,
    Object? workStartedAt = freezed,
    Object? workEndAt = freezed,
    Object? assigned = freezed,
    Object? userAssigned = freezed,
    Object? driverID = freezed,
    Object? latitude = freezed,
    Object? longitude = freezed,
    Object? rate = freezed,
    Object? title = null,
    Object? urlFoto = freezed,
    Object? finishAddress = freezed,
    Object? finishLatitude = freezed,
    Object? finishLongitude = freezed,
    Object? driver = freezed,
    Object? client = freezed,
    Object? startLeaseAt = freezed,
    Object? rateComment = freezed,
    Object? endLeaseAt = freezed,
    Object? price = freezed,
    Object? requestAdConstructionMaterialClientID = freezed,
    Object? constructionRequestClientModel = freezed,
    Object? constructionRequesttModel = freezed,
    Object? serviceRequestModel = freezed,
    Object? serviceRequestModelID = freezed,
    Object? serviceRequestClientModelID = freezed,
    Object? serviceRequestClientModel = freezed,
    Object? subCategory = freezed,
    Object? priceForHour = freezed,
    Object? src = freezed,
  }) {
    return _then(_$RequestExecutionImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      deletedAt: freezed == deletedAt
          ? _value.deletedAt
          : deletedAt // ignore: cast_nullable_to_non_nullable
              as dynamic,
      specializedMachineryRequestId: freezed == specializedMachineryRequestId
          ? _value.specializedMachineryRequestId
          : specializedMachineryRequestId // ignore: cast_nullable_to_non_nullable
              as int?,
      specializedMachineryRequest: freezed == specializedMachineryRequest
          ? _value.specializedMachineryRequest
          : specializedMachineryRequest // ignore: cast_nullable_to_non_nullable
              as SpecializedMachineryRequest?,
      requestAdEquipmentClient: freezed == requestAdEquipmentClient
          ? _value.requestAdEquipmentClient
          : requestAdEquipmentClient // ignore: cast_nullable_to_non_nullable
              as RequestAdEquipmentClient?,
      requestAdEquipment: freezed == requestAdEquipment
          ? _value.requestAdEquipment
          : requestAdEquipment // ignore: cast_nullable_to_non_nullable
              as RequestAdEquipment?,
      requestId: freezed == requestId
          ? _value.requestId
          : requestId // ignore: cast_nullable_to_non_nullable
              as int?,
      request: freezed == request
          ? _value.request
          : request // ignore: cast_nullable_to_non_nullable
              as SpecializedMachineryRequestClient?,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String?,
      workStartedClinet: freezed == workStartedClinet
          ? _value.workStartedClinet
          : workStartedClinet // ignore: cast_nullable_to_non_nullable
              as bool?,
      workStartedDriver: freezed == workStartedDriver
          ? _value.workStartedDriver
          : workStartedDriver // ignore: cast_nullable_to_non_nullable
              as bool?,
      workStartedAt: freezed == workStartedAt
          ? _value.workStartedAt
          : workStartedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      workEndAt: freezed == workEndAt
          ? _value.workEndAt
          : workEndAt // ignore: cast_nullable_to_non_nullable
              as dynamic,
      assigned: freezed == assigned
          ? _value.assigned
          : assigned // ignore: cast_nullable_to_non_nullable
              as int?,
      userAssigned: freezed == userAssigned
          ? _value.userAssigned
          : userAssigned // ignore: cast_nullable_to_non_nullable
              as User?,
      driverID: freezed == driverID
          ? _value.driverID
          : driverID // ignore: cast_nullable_to_non_nullable
              as int?,
      latitude: freezed == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double?,
      longitude: freezed == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double?,
      rate: freezed == rate
          ? _value.rate
          : rate // ignore: cast_nullable_to_non_nullable
              as double?,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      urlFoto: freezed == urlFoto
          ? _value._urlFoto
          : urlFoto // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      finishAddress: freezed == finishAddress
          ? _value.finishAddress
          : finishAddress // ignore: cast_nullable_to_non_nullable
              as String?,
      finishLatitude: freezed == finishLatitude
          ? _value.finishLatitude
          : finishLatitude // ignore: cast_nullable_to_non_nullable
              as double?,
      finishLongitude: freezed == finishLongitude
          ? _value.finishLongitude
          : finishLongitude // ignore: cast_nullable_to_non_nullable
              as double?,
      driver: freezed == driver
          ? _value.driver
          : driver // ignore: cast_nullable_to_non_nullable
              as User?,
      client: freezed == client
          ? _value.client
          : client // ignore: cast_nullable_to_non_nullable
              as User?,
      startLeaseAt: freezed == startLeaseAt
          ? _value.startLeaseAt
          : startLeaseAt // ignore: cast_nullable_to_non_nullable
              as String?,
      rateComment: freezed == rateComment
          ? _value.rateComment
          : rateComment // ignore: cast_nullable_to_non_nullable
              as String?,
      endLeaseAt: freezed == endLeaseAt
          ? _value.endLeaseAt
          : endLeaseAt // ignore: cast_nullable_to_non_nullable
              as dynamic,
      price: freezed == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as int?,
      requestAdConstructionMaterialClientID: freezed ==
              requestAdConstructionMaterialClientID
          ? _value.requestAdConstructionMaterialClientID
          : requestAdConstructionMaterialClientID // ignore: cast_nullable_to_non_nullable
              as int?,
      constructionRequestClientModel: freezed == constructionRequestClientModel
          ? _value.constructionRequestClientModel
          : constructionRequestClientModel // ignore: cast_nullable_to_non_nullable
              as ConstructionRequestClientModel?,
      constructionRequesttModel: freezed == constructionRequesttModel
          ? _value.constructionRequesttModel
          : constructionRequesttModel // ignore: cast_nullable_to_non_nullable
              as ConstructionRequestModel?,
      serviceRequestModel: freezed == serviceRequestModel
          ? _value.serviceRequestModel
          : serviceRequestModel // ignore: cast_nullable_to_non_nullable
              as ServiceRequestModel?,
      serviceRequestModelID: freezed == serviceRequestModelID
          ? _value.serviceRequestModelID
          : serviceRequestModelID // ignore: cast_nullable_to_non_nullable
              as int?,
      serviceRequestClientModelID: freezed == serviceRequestClientModelID
          ? _value.serviceRequestClientModelID
          : serviceRequestClientModelID // ignore: cast_nullable_to_non_nullable
              as int?,
      serviceRequestClientModel: freezed == serviceRequestClientModel
          ? _value.serviceRequestClientModel
          : serviceRequestClientModel // ignore: cast_nullable_to_non_nullable
              as ServiceRequestClientModel?,
      subCategory: freezed == subCategory
          ? _value.subCategory
          : subCategory // ignore: cast_nullable_to_non_nullable
              as String?,
      priceForHour: freezed == priceForHour
          ? _value.priceForHour
          : priceForHour // ignore: cast_nullable_to_non_nullable
              as double?,
      src: freezed == src
          ? _value.src
          : src // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RequestExecutionImpl implements _RequestExecution {
  _$RequestExecutionImpl(
      {this.id,
      @JsonKey(name: 'created_at') this.createdAt,
      @JsonKey(name: 'updated_at') this.updatedAt,
      @JsonKey(name: 'deleted_at') this.deletedAt,
      @JsonKey(name: 'specialized_machinery_request_id')
      this.specializedMachineryRequestId,
      @JsonKey(name: 'specialized_machinery_request')
      this.specializedMachineryRequest,
      @JsonKey(name: 'request_ad_equipment_client')
      this.requestAdEquipmentClient,
      @JsonKey(name: 'request_ad_equipment') this.requestAdEquipment,
      @JsonKey(name: 'request_id') this.requestId,
      this.request,
      this.status,
      @JsonKey(name: 'work_started_clinet') this.workStartedClinet,
      @JsonKey(name: 'work_started_driver') this.workStartedDriver,
      @JsonKey(name: 'work_started_at') this.workStartedAt,
      @JsonKey(name: 'work_end_at') this.workEndAt,
      this.assigned,
      @JsonKey(name: 'user_assigned') this.userAssigned,
      @JsonKey(name: 'driver_id') this.driverID,
      this.latitude,
      this.longitude,
      this.rate,
      required this.title,
      @JsonKey(name: 'url_foto') final List<String>? urlFoto,
      @JsonKey(name: 'finish_address') this.finishAddress,
      @JsonKey(name: 'finish_latitude') this.finishLatitude,
      @JsonKey(name: 'finish_longitude') this.finishLongitude,
      this.driver,
      @JsonKey(name: 'clinet') this.client,
      @JsonKey(name: 'start_lease_at') this.startLeaseAt,
      @JsonKey(name: 'rate_comment') this.rateComment,
      @JsonKey(name: 'end_lease_at') this.endLeaseAt,
      @JsonKey(name: 'driver_payment_amount') this.price,
      @JsonKey(name: 'request_ad_construction_material_client_id')
      this.requestAdConstructionMaterialClientID,
      @JsonKey(name: 'request_ad_construction_material_client')
      this.constructionRequestClientModel,
      @JsonKey(name: 'request_ad_construction_material')
      this.constructionRequesttModel,
      @JsonKey(name: 'request_ad_service') this.serviceRequestModel,
      @JsonKey(name: 'request_ad_service_id') this.serviceRequestModelID,
      @JsonKey(name: 'request_ad_service_client_id')
      this.serviceRequestClientModelID,
      @JsonKey(name: 'request_ad_service_client')
      this.serviceRequestClientModel,
      @JsonKey(name: 'sub_category_name') this.subCategory,
      @JsonKey(name: 'price') this.priceForHour,
      this.src})
      : _urlFoto = urlFoto;

  factory _$RequestExecutionImpl.fromJson(Map<String, dynamic> json) =>
      _$$RequestExecutionImplFromJson(json);

  @override
  final int? id;
  @override
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;
  @override
  @JsonKey(name: 'deleted_at')
  final dynamic deletedAt;
  @override
  @JsonKey(name: 'specialized_machinery_request_id')
  final int? specializedMachineryRequestId;
  @override
  @JsonKey(name: 'specialized_machinery_request')
  final SpecializedMachineryRequest? specializedMachineryRequest;
  @override
  @JsonKey(name: 'request_ad_equipment_client')
  final RequestAdEquipmentClient? requestAdEquipmentClient;
  @override
  @JsonKey(name: 'request_ad_equipment')
  final RequestAdEquipment? requestAdEquipment;
  @override
  @JsonKey(name: 'request_id')
  final int? requestId;
  @override
  final SpecializedMachineryRequestClient? request;
  @override
  final String? status;
  @override
  @JsonKey(name: 'work_started_clinet')
  final bool? workStartedClinet;
  @override
  @JsonKey(name: 'work_started_driver')
  final bool? workStartedDriver;
  @override
  @JsonKey(name: 'work_started_at')
  final DateTime? workStartedAt;
  @override
  @JsonKey(name: 'work_end_at')
  final dynamic workEndAt;
  @override
  final int? assigned;
  @override
  @JsonKey(name: 'user_assigned')
  final User? userAssigned;
  @override
  @JsonKey(name: 'driver_id')
  final int? driverID;
  @override
  final double? latitude;
  @override
  final double? longitude;
  @override
  final double? rate;
  @override
  final String title;
  final List<String>? _urlFoto;
  @override
  @JsonKey(name: 'url_foto')
  List<String>? get urlFoto {
    final value = _urlFoto;
    if (value == null) return null;
    if (_urlFoto is EqualUnmodifiableListView) return _urlFoto;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey(name: 'finish_address')
  final String? finishAddress;
  @override
  @JsonKey(name: 'finish_latitude')
  final double? finishLatitude;
  @override
  @JsonKey(name: 'finish_longitude')
  final double? finishLongitude;
  @override
  final User? driver;
  @override
  @JsonKey(name: 'clinet')
  final User? client;
  @override
  @JsonKey(name: 'start_lease_at')
  final String? startLeaseAt;
  @override
  @JsonKey(name: 'rate_comment')
  final String? rateComment;
  @override
  @JsonKey(name: 'end_lease_at')
  final dynamic endLeaseAt;
  @override
  @JsonKey(name: 'driver_payment_amount')
  final int? price;
  @override
  @JsonKey(name: 'request_ad_construction_material_client_id')
  final int? requestAdConstructionMaterialClientID;
  @override
  @JsonKey(name: 'request_ad_construction_material_client')
  final ConstructionRequestClientModel? constructionRequestClientModel;
  @override
  @JsonKey(name: 'request_ad_construction_material')
  final ConstructionRequestModel? constructionRequesttModel;
  @override
  @JsonKey(name: 'request_ad_service')
  final ServiceRequestModel? serviceRequestModel;
  @override
  @JsonKey(name: 'request_ad_service_id')
  final int? serviceRequestModelID;
  @override
  @JsonKey(name: 'request_ad_service_client_id')
  final int? serviceRequestClientModelID;
  @override
  @JsonKey(name: 'request_ad_service_client')
  final ServiceRequestClientModel? serviceRequestClientModel;
  @override
  @JsonKey(name: 'sub_category_name')
  final String? subCategory;
  @override
  @JsonKey(name: 'price')
  final double? priceForHour;
  @override
  final String? src;

  @override
  String toString() {
    return 'RequestExecution(id: $id, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt, specializedMachineryRequestId: $specializedMachineryRequestId, specializedMachineryRequest: $specializedMachineryRequest, requestAdEquipmentClient: $requestAdEquipmentClient, requestAdEquipment: $requestAdEquipment, requestId: $requestId, request: $request, status: $status, workStartedClinet: $workStartedClinet, workStartedDriver: $workStartedDriver, workStartedAt: $workStartedAt, workEndAt: $workEndAt, assigned: $assigned, userAssigned: $userAssigned, driverID: $driverID, latitude: $latitude, longitude: $longitude, rate: $rate, title: $title, urlFoto: $urlFoto, finishAddress: $finishAddress, finishLatitude: $finishLatitude, finishLongitude: $finishLongitude, driver: $driver, client: $client, startLeaseAt: $startLeaseAt, rateComment: $rateComment, endLeaseAt: $endLeaseAt, price: $price, requestAdConstructionMaterialClientID: $requestAdConstructionMaterialClientID, constructionRequestClientModel: $constructionRequestClientModel, constructionRequesttModel: $constructionRequesttModel, serviceRequestModel: $serviceRequestModel, serviceRequestModelID: $serviceRequestModelID, serviceRequestClientModelID: $serviceRequestClientModelID, serviceRequestClientModel: $serviceRequestClientModel, subCategory: $subCategory, priceForHour: $priceForHour, src: $src)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RequestExecutionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            const DeepCollectionEquality().equals(other.deletedAt, deletedAt) &&
            (identical(other.specializedMachineryRequestId, specializedMachineryRequestId) ||
                other.specializedMachineryRequestId ==
                    specializedMachineryRequestId) &&
            (identical(other.specializedMachineryRequest, specializedMachineryRequest) ||
                other.specializedMachineryRequest ==
                    specializedMachineryRequest) &&
            (identical(other.requestAdEquipmentClient, requestAdEquipmentClient) ||
                other.requestAdEquipmentClient == requestAdEquipmentClient) &&
            (identical(other.requestAdEquipment, requestAdEquipment) ||
                other.requestAdEquipment == requestAdEquipment) &&
            (identical(other.requestId, requestId) ||
                other.requestId == requestId) &&
            (identical(other.request, request) || other.request == request) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.workStartedClinet, workStartedClinet) ||
                other.workStartedClinet == workStartedClinet) &&
            (identical(other.workStartedDriver, workStartedDriver) ||
                other.workStartedDriver == workStartedDriver) &&
            (identical(other.workStartedAt, workStartedAt) ||
                other.workStartedAt == workStartedAt) &&
            const DeepCollectionEquality().equals(other.workEndAt, workEndAt) &&
            (identical(other.assigned, assigned) ||
                other.assigned == assigned) &&
            (identical(other.userAssigned, userAssigned) ||
                other.userAssigned == userAssigned) &&
            (identical(other.driverID, driverID) ||
                other.driverID == driverID) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            (identical(other.rate, rate) || other.rate == rate) &&
            (identical(other.title, title) || other.title == title) &&
            const DeepCollectionEquality().equals(other._urlFoto, _urlFoto) &&
            (identical(other.finishAddress, finishAddress) ||
                other.finishAddress == finishAddress) &&
            (identical(other.finishLatitude, finishLatitude) ||
                other.finishLatitude == finishLatitude) &&
            (identical(other.finishLongitude, finishLongitude) ||
                other.finishLongitude == finishLongitude) &&
            (identical(other.driver, driver) || other.driver == driver) &&
            (identical(other.client, client) || other.client == client) &&
            (identical(other.startLeaseAt, startLeaseAt) ||
                other.startLeaseAt == startLeaseAt) &&
            (identical(other.rateComment, rateComment) ||
                other.rateComment == rateComment) &&
            const DeepCollectionEquality()
                .equals(other.endLeaseAt, endLeaseAt) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.requestAdConstructionMaterialClientID, requestAdConstructionMaterialClientID) ||
                other.requestAdConstructionMaterialClientID == requestAdConstructionMaterialClientID) &&
            (identical(other.constructionRequestClientModel, constructionRequestClientModel) || other.constructionRequestClientModel == constructionRequestClientModel) &&
            (identical(other.constructionRequesttModel, constructionRequesttModel) || other.constructionRequesttModel == constructionRequesttModel) &&
            (identical(other.serviceRequestModel, serviceRequestModel) || other.serviceRequestModel == serviceRequestModel) &&
            (identical(other.serviceRequestModelID, serviceRequestModelID) || other.serviceRequestModelID == serviceRequestModelID) &&
            (identical(other.serviceRequestClientModelID, serviceRequestClientModelID) || other.serviceRequestClientModelID == serviceRequestClientModelID) &&
            (identical(other.serviceRequestClientModel, serviceRequestClientModel) || other.serviceRequestClientModel == serviceRequestClientModel) &&
            (identical(other.subCategory, subCategory) || other.subCategory == subCategory) &&
            (identical(other.priceForHour, priceForHour) || other.priceForHour == priceForHour) &&
            (identical(other.src, src) || other.src == src));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        createdAt,
        updatedAt,
        const DeepCollectionEquality().hash(deletedAt),
        specializedMachineryRequestId,
        specializedMachineryRequest,
        requestAdEquipmentClient,
        requestAdEquipment,
        requestId,
        request,
        status,
        workStartedClinet,
        workStartedDriver,
        workStartedAt,
        const DeepCollectionEquality().hash(workEndAt),
        assigned,
        userAssigned,
        driverID,
        latitude,
        longitude,
        rate,
        title,
        const DeepCollectionEquality().hash(_urlFoto),
        finishAddress,
        finishLatitude,
        finishLongitude,
        driver,
        client,
        startLeaseAt,
        rateComment,
        const DeepCollectionEquality().hash(endLeaseAt),
        price,
        requestAdConstructionMaterialClientID,
        constructionRequestClientModel,
        constructionRequesttModel,
        serviceRequestModel,
        serviceRequestModelID,
        serviceRequestClientModelID,
        serviceRequestClientModel,
        subCategory,
        priceForHour,
        src
      ]);

  /// Create a copy of RequestExecution
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RequestExecutionImplCopyWith<_$RequestExecutionImpl> get copyWith =>
      __$$RequestExecutionImplCopyWithImpl<_$RequestExecutionImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RequestExecutionImplToJson(
      this,
    );
  }
}

abstract class _RequestExecution implements RequestExecution {
  factory _RequestExecution(
      {final int? id,
      @JsonKey(name: 'created_at') final DateTime? createdAt,
      @JsonKey(name: 'updated_at') final DateTime? updatedAt,
      @JsonKey(name: 'deleted_at') final dynamic deletedAt,
      @JsonKey(name: 'specialized_machinery_request_id')
      final int? specializedMachineryRequestId,
      @JsonKey(name: 'specialized_machinery_request')
      final SpecializedMachineryRequest? specializedMachineryRequest,
      @JsonKey(name: 'request_ad_equipment_client')
      final RequestAdEquipmentClient? requestAdEquipmentClient,
      @JsonKey(name: 'request_ad_equipment')
      final RequestAdEquipment? requestAdEquipment,
      @JsonKey(name: 'request_id') final int? requestId,
      final SpecializedMachineryRequestClient? request,
      final String? status,
      @JsonKey(name: 'work_started_clinet') final bool? workStartedClinet,
      @JsonKey(name: 'work_started_driver') final bool? workStartedDriver,
      @JsonKey(name: 'work_started_at') final DateTime? workStartedAt,
      @JsonKey(name: 'work_end_at') final dynamic workEndAt,
      final int? assigned,
      @JsonKey(name: 'user_assigned') final User? userAssigned,
      @JsonKey(name: 'driver_id') final int? driverID,
      final double? latitude,
      final double? longitude,
      final double? rate,
      required final String title,
      @JsonKey(name: 'url_foto') final List<String>? urlFoto,
      @JsonKey(name: 'finish_address') final String? finishAddress,
      @JsonKey(name: 'finish_latitude') final double? finishLatitude,
      @JsonKey(name: 'finish_longitude') final double? finishLongitude,
      final User? driver,
      @JsonKey(name: 'clinet') final User? client,
      @JsonKey(name: 'start_lease_at') final String? startLeaseAt,
      @JsonKey(name: 'rate_comment') final String? rateComment,
      @JsonKey(name: 'end_lease_at') final dynamic endLeaseAt,
      @JsonKey(name: 'driver_payment_amount') final int? price,
      @JsonKey(name: 'request_ad_construction_material_client_id')
      final int? requestAdConstructionMaterialClientID,
      @JsonKey(name: 'request_ad_construction_material_client')
      final ConstructionRequestClientModel? constructionRequestClientModel,
      @JsonKey(name: 'request_ad_construction_material')
      final ConstructionRequestModel? constructionRequesttModel,
      @JsonKey(name: 'request_ad_service')
      final ServiceRequestModel? serviceRequestModel,
      @JsonKey(name: 'request_ad_service_id') final int? serviceRequestModelID,
      @JsonKey(name: 'request_ad_service_client_id')
      final int? serviceRequestClientModelID,
      @JsonKey(name: 'request_ad_service_client')
      final ServiceRequestClientModel? serviceRequestClientModel,
      @JsonKey(name: 'sub_category_name') final String? subCategory,
      @JsonKey(name: 'price') final double? priceForHour,
      final String? src}) = _$RequestExecutionImpl;

  factory _RequestExecution.fromJson(Map<String, dynamic> json) =
      _$RequestExecutionImpl.fromJson;

  @override
  int? get id;
  @override
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt;
  @override
  @JsonKey(name: 'deleted_at')
  dynamic get deletedAt;
  @override
  @JsonKey(name: 'specialized_machinery_request_id')
  int? get specializedMachineryRequestId;
  @override
  @JsonKey(name: 'specialized_machinery_request')
  SpecializedMachineryRequest? get specializedMachineryRequest;
  @override
  @JsonKey(name: 'request_ad_equipment_client')
  RequestAdEquipmentClient? get requestAdEquipmentClient;
  @override
  @JsonKey(name: 'request_ad_equipment')
  RequestAdEquipment? get requestAdEquipment;
  @override
  @JsonKey(name: 'request_id')
  int? get requestId;
  @override
  SpecializedMachineryRequestClient? get request;
  @override
  String? get status;
  @override
  @JsonKey(name: 'work_started_clinet')
  bool? get workStartedClinet;
  @override
  @JsonKey(name: 'work_started_driver')
  bool? get workStartedDriver;
  @override
  @JsonKey(name: 'work_started_at')
  DateTime? get workStartedAt;
  @override
  @JsonKey(name: 'work_end_at')
  dynamic get workEndAt;
  @override
  int? get assigned;
  @override
  @JsonKey(name: 'user_assigned')
  User? get userAssigned;
  @override
  @JsonKey(name: 'driver_id')
  int? get driverID;
  @override
  double? get latitude;
  @override
  double? get longitude;
  @override
  double? get rate;
  @override
  String get title;
  @override
  @JsonKey(name: 'url_foto')
  List<String>? get urlFoto;
  @override
  @JsonKey(name: 'finish_address')
  String? get finishAddress;
  @override
  @JsonKey(name: 'finish_latitude')
  double? get finishLatitude;
  @override
  @JsonKey(name: 'finish_longitude')
  double? get finishLongitude;
  @override
  User? get driver;
  @override
  @JsonKey(name: 'clinet')
  User? get client;
  @override
  @JsonKey(name: 'start_lease_at')
  String? get startLeaseAt;
  @override
  @JsonKey(name: 'rate_comment')
  String? get rateComment;
  @override
  @JsonKey(name: 'end_lease_at')
  dynamic get endLeaseAt;
  @override
  @JsonKey(name: 'driver_payment_amount')
  int? get price;
  @override
  @JsonKey(name: 'request_ad_construction_material_client_id')
  int? get requestAdConstructionMaterialClientID;
  @override
  @JsonKey(name: 'request_ad_construction_material_client')
  ConstructionRequestClientModel? get constructionRequestClientModel;
  @override
  @JsonKey(name: 'request_ad_construction_material')
  ConstructionRequestModel? get constructionRequesttModel;
  @override
  @JsonKey(name: 'request_ad_service')
  ServiceRequestModel? get serviceRequestModel;
  @override
  @JsonKey(name: 'request_ad_service_id')
  int? get serviceRequestModelID;
  @override
  @JsonKey(name: 'request_ad_service_client_id')
  int? get serviceRequestClientModelID;
  @override
  @JsonKey(name: 'request_ad_service_client')
  ServiceRequestClientModel? get serviceRequestClientModel;
  @override
  @JsonKey(name: 'sub_category_name')
  String? get subCategory;
  @override
  @JsonKey(name: 'price')
  double? get priceForHour;
  @override
  String? get src;

  /// Create a copy of RequestExecution
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RequestExecutionImplCopyWith<_$RequestExecutionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
