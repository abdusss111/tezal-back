import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:eqshare_mobile/app/app_change_notifier.dart';
import 'package:eqshare_mobile/src/core/data/services/network/api_client/network_client.dart';
import 'package:eqshare_mobile/src/core/data/services/storage/token_provider_service.dart';
import 'package:eqshare_mobile/src/core/res/api_endpoints/api_endpoints.dart';
import 'package:eqshare_mobile/src/global_widgets/global_values.dart';
import 'package:eqshare_mobile/src/features/requests/data/models/service_request/service_request/service_request_model.dart';
import 'package:eqshare_mobile/src/features/requests/data/models/service_request/service_request_client/service_request_client_model.dart';
import 'package:eqshare_mobile/src/features/requests/data/repository/request_execution_repository.dart';

class AdServiceRequestRepository extends RequestExecutionRepository {
  final dio = Dio();
  final baseUrl = ApiEndPoints.baseUrl;
  final tokenService = TokenService();
  final _networkClient = NetworkClient();

  Future<Map<String, dynamic>> getAuthHeaders() async {
    final token = await tokenService.getToken();

    return {'Authorization': 'Bearer $token'};
  }

  Future<List<ServiceRequestClientModel>?>
      getDriverRequestsListAwaitsApprovedFromClient(
          {required String driverOrOwnerID, String? status}) async {
    final queryParameters = {
      if (status == null) 'status': RequestStatus.CREATED.name,
      if (status != null) 'status': status,
      'ad_service_client_detail': 'true',
      'ad_service_client_document_detail': 'true',
      'user_detail': 'true',
      'executor_detail': 'true',
    };

    final data = await _networkClient.aliGet(
        path: '/service/request_ad_service_client',
        queryParams: queryParameters,
        fromJson: (json) {
          final List<dynamic> data = json['request_ad_service_clients'];
          final List<ServiceRequestClientModel> result =
              data.map((e) => ServiceRequestClientModel.fromJson(e)).toList();
          final newResult = result
              .where((e) =>
                  e.userId == int.parse(driverOrOwnerID) ||
                  e.executorId == int.parse(driverOrOwnerID))
              .toList();
          return newResult;
        });
    return data;
  }

  Future<List<ServiceRequestClientModel>?>
      getClientRequestsWhereNeedsAprovedFromClient(
          {required String clientID, required String status}) async {
    final path = '$baseUrl/service/request_ad_service_client';
    final queryParameters = {
      'status': status,
      'ad_service_client_detail': 'true',
      'user_detail': 'true',
      'executor_detail': 'true',
    };
    try {
      final headers = await getAuthHeaders();
      final response = await dio.get(path,
          queryParameters: queryParameters, options: Options(headers: headers));
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['request_ad_service_clients'];
        final List<ServiceRequestClientModel> result =
            data.map((e) => ServiceRequestClientModel.fromJson(e)).toList();
        final single = result
            .where((e) => e.adClient?.userID == int.parse(clientID))
            .toList();
        return single;
      }
    } on Exception catch (e) {
      printLog(e, 'getDriverRequestsAwaitsApprovedFromClient');
    }

    return null;
  }

  Future<List<ServiceRequestModel>?>
      getClientRequestsListAwaitsApprovedFromDriverOrOwner(
          {required String clientID, String? status}) async {
    final path = '$baseUrl/service/request_ad_service';
    final queryParameters = {
      if (status == null) 'status': RequestStatus.CREATED.name,
      if (status != null) 'status': status,
      'ad_service_detail': 'true',
      'user_detail': 'true',
      'executor_detail': 'true',
      'city_detail': 'true'
    };
    try {
      final headers = await getAuthHeaders();
      final response = await dio.get(path,
          queryParameters: queryParameters, options: Options(headers: headers));
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['request_ad_services'];
        final List<ServiceRequestModel> result =
            data.map((e) => ServiceRequestModel.fromJson(e)).toList();
        return result.where((e) => e.userId == int.parse(clientID)).toList();
      }
    } on Exception catch (e) {
      printLog(e, 'getClientRequestsAwaitsApprovedFromDriverOrOwner');
    }

    return null;
  }

  Future<List<ServiceRequestModel>?>
      getClientRequestsListAwaitsDriverOrOwnerApprove({
    required String driverOrOwner,
    required String status,
  }) async {
    final path = '$baseUrl/service/request_ad_service';
    final queryParameters = {
      'status': status,
      'ad_service_detail': 'true',
      'user_detail': 'true',
      'executor_detail': 'true',
      'city_detail': 'true'
    };
    try {
      final headers = await getAuthHeaders();
      final response = await dio.get(path,
          queryParameters: queryParameters, options: Options(headers: headers));
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['request_ad_services'];
        final List<ServiceRequestModel> result =
            data.map((e) => ServiceRequestModel.fromJson(e)).toList();
        return result
            .where((e) => e.executorId == int.parse(driverOrOwner))
            .toList();
      }
    } on Exception catch (e) {
      printLog(e, 'getClientRequestsAwaitsApprovedFromDriverOrOwner');
    }

    return null;
  }

  Future<ServiceRequestModel?> getDriverRequestDetailAwaitsApprovedFromClient(
      {required String adServiceRequestID}) async {
    final path = '$baseUrl/service/request_ad_service/$adServiceRequestID';
    final queryParameters = {
      'status': RequestStatus.CREATED.name,
      'ad_service_client_detail': 'true',
      'user_detail': 'true'
    };
    try {
      final headers = await getAuthHeaders();
      final response = await dio.get(path,
          queryParameters: queryParameters, options: Options(headers: headers));
      if (response.statusCode == 200) {
        final data = response.data['request_ad_service'];
        final ServiceRequestModel result = ServiceRequestModel.fromJson(data);
        return result;
      }
    } on Exception catch (e) {
      printLog(e, 'getDriverRequestDetailAwaitsApprovedFromClient');
    }

    return null;
  }

  Future<ServiceRequestClientModel?>
      getClientRequestDetailAwaitsApprovedFromDriverOrOwner(
          {required String adServiceRequestID}) async {
    final path =
        '$baseUrl/service/request_ad_service_client/$adServiceRequestID';
    final queryParameters = {
      'ad_service_client_document_detail': 'true',
      'user_detail': 'true',
      'ad_service_client_detail': 'true',
      'city_detail': 'true',
      'executor_detail': 'true',
    };
    try {
      final headers = await getAuthHeaders();
      final response = await dio.get(path,
          queryParameters: queryParameters, options: Options(headers: headers));
      if (response.statusCode == 200) {
        final data = response.data['request_ad_service'];
        final ServiceRequestClientModel result =
            ServiceRequestClientModel.fromJson(data);
        return result;
      }
    } on Exception catch (e) {
      printLog(e, 'getClientRequestDetailAwaitsApprovedFromDriverOrOwner');
    }

    return null;
  }

  Future<bool> approveClientRequestFromDriverOrOwner(String approvedRequestID,
      {String? workerID}) async {
    final path =
        '$baseUrl/service/request_ad_service/$approvedRequestID/approve';
    try {
      final headers = await getAuthHeaders();
      final payload = AppChangeNotifier().payload;
      final data = {
        'executor_id':
            int.tryParse(workerID ?? '') ?? int.parse(payload?.sub ?? '0')
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

  Future<bool> approveDriverOrOwnerRequestFromClient(
      String approvedRequestID) async {
    final path =
        '$baseUrl/service/request_ad_service_client/$approvedRequestID/approve';
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

  Future<bool> cancelClientRequestFromDriverOrOwner(
      String canceledRequestID) async {
    final path =
        '$baseUrl/service/request_ad_service/$canceledRequestID/canceled';
    try {
      final headers = await getAuthHeaders();
      final response = await dio.post(path, options: Options(headers: headers));
      if (response.statusCode == 200) {
        return true;
      }
    } on Exception catch (e) {
      printLog(e, 'cancelClientRequestFromDriverOrOwner');
    }
    return false;
  }

  Future<bool> cancelDriverOrOwnerRequestFromClient(
      String canceledRequestID) async {
    final path =
        '$baseUrl/service/request_ad_service_client/$canceledRequestID/canceled';
    try {
      final headers = await getAuthHeaders();
      final response = await dio.post(path, options: Options(headers: headers));
      if (response.statusCode == 200) {
        return true;
      }
    } on Exception catch (e) {
      printLog(e, 'cancelDriverOrOwnerRequestFromClient');
    }
    return false;
  }

  Future<bool> reassingServiceRequest(
      String requestID, String executorID) async {
    final formData = FormData.fromMap({
      'base': jsonEncode({"executor_id": executorID})
    });
    try {
      final headers = await getAuthHeaders();

      final response = await dio.patch(
          '${ApiEndPoints.baseUrl}/service/request_ad_service/$requestID/executor',
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

  Future<bool> reassingClientServiceRequest(
      String requestID, String executorID) async {
    final formData = FormData.fromMap({
      'base': jsonEncode({"executor_id": executorID})
    });
    try {
      final headers = await getAuthHeaders();

      final response = await dio.patch(
          '${ApiEndPoints.baseUrl}/service/request_ad_service_client/$requestID/executor',
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

  @override
  void printLog(Object e, String errorName) {
    return log(e.toString(), name: 'Error name :$errorName');
  }
}
