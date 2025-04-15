import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:eqshare_mobile/src/core/data/models/payload/payload.dart';
import 'package:eqshare_mobile/src/core/data/services/storage/token_provider_service.dart';
import 'package:eqshare_mobile/src/core/res/api_endpoints/api_endpoints.dart';
import 'package:eqshare_mobile/src/global_widgets/global_values.dart';
import 'package:eqshare_mobile/src/features/requests/data/models/construction_request/construction_request/construction_request_model.dart';
import 'package:eqshare_mobile/src/features/requests/data/models/construction_request/construction_request_client/construction_request_client_model.dart';
import 'package:eqshare_mobile/src/features/requests/data/models/request_execution_list/request_execution.dart';

import 'package:eqshare_mobile/src/features/requests/data/repository/request_execution_repository.dart';

class AdConstructionsRequestRepository extends RequestExecutionRepository {
  final dio = Dio();
  final baseUrl = ApiEndPoints.baseUrl;
  final tokenService = TokenService();

  Future<Map<String, dynamic>> getAuthHeaders() async {
    final token = await tokenService.getToken();

    return {'Authorization': 'Bearer $token'};
  }

  @override
  Future<Payload> getPayload() async {
    final token = await tokenService.getToken();
    final payload = tokenService.extractPayloadFromToken(token!);
    return payload;
  }

  Future<List<ConstructionRequestClientModel>?>
      getDriverRequestsListAwaitsApprovedFromClient(
          {required String driverOrOwnerID, String? status}) async {
    final path =
        '$baseUrl/construction_material/request_ad_construction_material_client';
    final queryParameters = {
      if (status == null) 'status': RequestStatus.CREATED.name,
      if (status != null) 'status': status,
      'ad_construction_material_client_detail': 'true',
      'user_detail': 'true',
      'executor_detail': 'true',
    };
    try {
      final headers = await getAuthHeaders();
      final response = await dio.get(path,
          queryParameters: queryParameters, options: Options(headers: headers));
      if (response.statusCode == 200) {
        final List<dynamic> data =
            response.data['request_ad_construction_material_clients'];
        final List<ConstructionRequestClientModel> result = data
            .map((e) => ConstructionRequestClientModel.fromJson(e))
            .toList();
        return result
            .where((e) =>
                e.executorId == int.parse(driverOrOwnerID) ||
                e.userId == int.parse(driverOrOwnerID))
            .toList();
      }
    } on Exception catch (e) {
      printLog(e, 'getDriverRequestsAwaitsApprovedFromClient');
    }

    return null;
  }

  Future<List<ConstructionRequestClientModel>?>
      getClientRequestsWhereNeedsAprovedFromClient({
    required String clientID,
    required String status,
  }) async {
    final path =
        '$baseUrl/construction_material/request_ad_construction_material_client';

    final queryParameters = {
      'status': status,
      'user_detail': 'true',
      'executor_detail': 'true',
      'ad_construction_material_client_detail': 'true',
      'ad_construction_material_client_document_detail': 'true',
    };
    try {
      final headers = await getAuthHeaders();
      final response = await dio.get(path,
          queryParameters: queryParameters, options: Options(headers: headers));
      if (response.statusCode == 200) {
        final List<dynamic> data =
            response.data['request_ad_construction_material_clients'];
        final List<ConstructionRequestClientModel> result = data
            .map((e) => ConstructionRequestClientModel.fromJson(e))
            .toList();
        return result
            .where((e) =>
                e.adConstructionClientModel?.userId == int.parse(clientID))
            .toList(); // TODO check UPD Пока не работает
      }
    } on Exception catch (e) {
      printLog(e, 'getDriverRequestsAwaitsApprovedFromClient');
    }

    return null;
  }

  Future<List<ConstructionRequestModel>?>
      getClientRequestsListAwaitsApprovedFromDriverOrOwner({
    required String clientID,
    String? status,
  }) async {
    final path =
        '$baseUrl/construction_material/request_ad_construction_material';
    final queryParameters = {
      if (status == null) 'status': RequestStatus.CREATED.name,
      if (status != null) 'status': status,
      'user_detail': 'true',
      'executor_detail': 'true',
      'city_detail': 'true',
      'ad_construction_material_detail': 'true',
    };
    try {
      final headers = await getAuthHeaders();
      final response = await dio.get(path,
          queryParameters: queryParameters, options: Options(headers: headers));
      if (response.statusCode == 200) {
        final List<dynamic> data =
            response.data['request_ad_construction_materials'];
        final List<ConstructionRequestModel> result =
            data.map((e) => ConstructionRequestModel.fromJson(e)).toList();
        return result
            .where((e) => e.userId == int.parse(clientID))
            .toList(); // TODO check
      }
    } on Exception catch (e) {
      printLog(e, 'getClientRequestsAwaitsApprovedFromDriverOrOwner');
    }

    return null;
  }

  Future<List<ConstructionRequestModel>?>
      getDriverOrOwnerRequestsAwaitsTheirApproved({
    required String clientID,
    required String status,
  }) async {
    final path =
        '$baseUrl/construction_material/request_ad_construction_material';
    final queryParameters = {
      'status': status,
      'ad_service_detail': 'true',
      'user_detail': 'true',
      'executor_detail': 'true',
      'city_detail': 'true',
      'ad_construction_material_detail': 'true',
    };
    try {
      final headers = await getAuthHeaders();

      // final payload = TokenService().extractPayloadFromToken( regex.firstMatch(headers['Authorization'].toString())?.group(1).toString() ?? '');
      final response = await dio.get(path,
          queryParameters: queryParameters, options: Options(headers: headers));
      if (response.statusCode == 200) {
        final List<dynamic> data =
            response.data['request_ad_construction_materials'];
        final List<ConstructionRequestModel> result =
            data.map((e) => ConstructionRequestModel.fromJson(e)).toList();
        return result
            .where((e) => e.executorId == int.parse(clientID))
            .toList(); // TODO check
      }
    } on Exception catch (e) {
      printLog(e, 'getClientRequestsAwaitsApprovedFromDriverOrOwner');
    }

    return null;
  }

  Future<List<ConstructionRequestModel>?>
      getClientRequestsListAwaitsDriverOrOwnerApprove({
    required String driverOrOwner,
  }) async {
    final path =
        '$baseUrl/construction_material/request_ad_construction_material';

    final queryParameters = {
      'status': RequestStatus.CREATED.name,
      'ad_service_detail': 'true',
      'user_detail': 'true',
      'city_detail': 'true'
    };
    try {
      final headers = await getAuthHeaders();
      final response = await dio.get(path,
          queryParameters: queryParameters, options: Options(headers: headers));
      if (response.statusCode == 200) {
        final List<dynamic> data =
            response.data['request_ad_construction_materials'];
        final List<ConstructionRequestModel> result =
            data.map((e) => ConstructionRequestModel.fromJson(e)).toList();
        return result
            .where((e) => e.executorId == int.parse(driverOrOwner))
            .toList(); // TODO check
      }
    } on Exception catch (e) {
      printLog(e, 'getClientRequestsAwaitsApprovedFromDriverOrOwner');
    }

    return null;
  }

  Future<ConstructionRequestModel?>
      getDriverRequestDetailAwaitsApprovedFromClient(
          {required String adServiceRequestID}) async {
    final path =
        '$baseUrl/construction_material/request_ad_construction_material/$adServiceRequestID';

    final queryParameters = {
      'status': RequestStatus.CREATED.name,
      'ad_construction_material_detail': 'true',
      'user_detail': 'true',
      'executor_detail': 'true',
      'city_detail': 'true'
    };
    try {
      final headers = await getAuthHeaders();
      final response = await dio.get(path,
          queryParameters: queryParameters, options: Options(headers: headers));
      if (response.statusCode == 200) {
        final data = response.data['request_ad_construction_material'];
        final ConstructionRequestModel result =
            ConstructionRequestModel.fromJson(data);
        return result;
      }
    } on Exception catch (e) {
      printLog(e, 'getDriverRequestDetailAwaitsApprovedFromClient');
    }

    return null;
  }

  Future<ConstructionRequestClientModel?>
      getClientRequestDetailAwaitsApprovedFromDriverOrOwner(
          {required String adServiceRequestID, String? status}) async {
    final path =
        '$baseUrl/construction_material/request_ad_construction_material_client/$adServiceRequestID';
    // final queryParameters = {
    //   'ad_construction_material_client_detail': 'true',
    //   'ad_construction_material_client_document_detail': 'true',
    //   'executor_detail': 'true',
    //   'user_detail': 'true',
    //   'city_detail': 'true'
    // };
    try {
      final headers = await getAuthHeaders();
      final response = await dio.get(path,
          queryParameters: {}, options: Options(headers: headers));
      if (response.statusCode == 200) {
        final data = response.data['request_ad_construction_material'];
        final ConstructionRequestClientModel result =
            ConstructionRequestClientModel.fromJson(data);
        return result; // TODO check
      }
    } on Exception catch (e) {
      printLog(e, 'getClientRequestDetailAwaitsApprovedFromDriverOrOwner');
    }

    return null;
  }

  Future<bool> approveClientRequestFromDriverOrOwner(String approvedRequestID,
      {String? workerID}) async {
    final path =
        '$baseUrl/construction_material/request_ad_construction_material/$approvedRequestID/approve';
    try {
      final headers = await getAuthHeaders();
      final token = await tokenService.getToken();
      final payload = tokenService.extractPayloadFromToken(token!);

      final data = {
        'executor_id': int.tryParse(workerID ?? '') ?? int.parse(payload.sub!)
      };
      final response =
          await dio.post(path, options: Options(headers: headers), data: data);
      if (response.statusCode == 200) {
        return true;
      }
    } on Exception catch (e) {
      printLog(e, 'approveDriverOrOwnerRequestFromClient');
    }
    return false;
  }

  Future<bool> approveDriverOrOwnerRequestFromClientAccount(
      String approvedRequestID) async {
    final path =
        '$baseUrl/construction_material/request_ad_construction_material_client/$approvedRequestID/approve';
    try {
      final headers = await getAuthHeaders();
      final response = await dio.post(path, options: Options(headers: headers));
      if (response.statusCode == 200) {
        return true;
      }
    } on Exception catch (e) {
      printLog(e, 'approveDriverOrOwnerRequestFromClient');
    }
    return false;
  }

  Future<bool> cancelDriverOrOwnerRequestsWhereAuthorFromClientAccount(
      String canceledRequestID) async {
    final path =
        '$baseUrl/construction_material/request_ad_construction_material_client/$canceledRequestID/canceled';
    // Все правильно я удостоверился ali
    //Отклоняю запрос водителя или бизнеса с аккаунта клиент
    try {
      final headers = await getAuthHeaders();
      final response = await dio.post(path, options: Options(headers: headers));
      if (response.statusCode == 200) {
        return true;
      }
    } on Exception catch (e) {
      printLog(e, 'approveDriverOrOwnerRequestFromClient');
    }
    return false;
  }

  Future<bool> cancelClientRequestsWhereAuthorFromAccountDriverOrOwner(
      String canceledRequestID) async {
    final path =
        '$baseUrl/construction_material/request_ad_construction_material/$canceledRequestID/canceled';
    try {
      final headers = await getAuthHeaders();
      final response = await dio.post(path, options: Options(headers: headers));
      if (response.statusCode == 200) {
        return true;
      }
    } on Exception catch (e) {
      printLog(e, 'approveDriverOrOwnerRequestFromClient');
    }
    return false;
  }

  Future<List<RequestExecution>?> getRequestExecution({
    required List<String> status,
    required List<String> src,
    required String id,
    required String clientAudiense,
  }) async {
    final path = '$baseUrl/re';
    final queryParameters = <String, dynamic>{
      'src': src,
    }..addAll({'status': status});

    if (clientAudiense == 'CLIENT') {
      queryParameters.addAll({'client_id': id});
    } else if (clientAudiense == 'DRIVER') {
      queryParameters.addAll({
        // 'assigned': id,
        // 'driver_id': id,
      });
    } else {
      queryParameters.addAll({
        'driver_id': id,
      });
    }

    try {
      final headers = await getAuthHeaders();
      final response = await dio.get(path,
          options: Options(headers: headers), queryParameters: queryParameters);
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['request_execution'];
        final List<RequestExecution> result =
            data.map((e) => RequestExecution.fromJson(e)).toList();
        return result;
      }
    } catch (e) {
      printLog(e, 'getRequestExecution');
    }
    return null;
  }

  Future<bool> reAssingConstructionMaterialRequest(
      String requestID, String executorID) async {
    final formData = FormData.fromMap({
      'base': jsonEncode({"executor_id": executorID})
    });
    try {
      final headers = await getAuthHeaders();

      final response = await dio.patch(
          '${ApiEndPoints.baseUrl}/construction_material/request_ad_construction_material/$requestID/executor',
          data: formData,
          options: Options(headers: headers));
      if (response.statusCode == 200) {
        return true;
      } else {
        throw response.data;
      }
    } on Exception catch (e) {
      printLog(e, 'reassingServiceRequest');
      return false;
    }
  }

  Future<bool> reAssingClientConstructionMaterialRequest(
      String requestID, String executorID) async {
    final formData = FormData.fromMap({
      'base': jsonEncode({"executor_id": executorID})
    });
    try {
      final headers = await getAuthHeaders();

      final response = await dio.patch(
          '${ApiEndPoints.baseUrl}/construction_material/request_ad_construction_material_client/$requestID/executor',
          data: formData,
          options: Options(headers: headers));
      if (response.statusCode == 200) {
        return true;
      } else {
        throw response.data;
      }
    } on Exception catch (e) {
      printLog(e, 'reassingServiceRequest');
      return false;
    }
  }

  // Future<void> acceptOrStartAferPauseOrder({required String requestID}) async {

  // }
  // Future<void> pauseOrder({required String requestID}) async {}
  // Future<void> finishOrder({required String requestID}) async {
  //   // await
  // }

  // Future<void> rateOrder({required int rating, required RequestExecution request, required String text}) async {}
  // Future<void> toRoadRequest({required String requestID}) async {}

  void printLog(Object e, String errorName) {
    return log(e.toString(), name: 'Error name :$errorName');
  }
}
