import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:eqshare_mobile/app/app_change_notifier.dart';
import 'package:eqshare_mobile/src/core/data/services/storage/token_provider_service.dart';
import 'package:eqshare_mobile/src/core/res/api_endpoints/api_endpoints.dart';
import 'package:eqshare_mobile/src/features/main/profile/profile_page/profile_controller.dart';
import 'package:eqshare_mobile/src/features/requests/data/models/specialized_machinery_request_models/specialized_machinery_request_client_model/specialized_machinery_request_client.dart';

import 'package:eqshare_mobile/src/features/requests/data/models/specialized_machinery_request_models/specialized_machinery_request_model/specialized_machinery_request.dart';
import 'package:eqshare_mobile/src/features/requests/data/repository/request_execution_repository.dart';

import 'package:http/http.dart' as http;

import '../../../../core/data/services/network/api_client/network_client.dart';

class SMRequestRepositoryImpl extends RequestExecutionRepository {
  final _networkClient = NetworkClient();

  Future<Map<String, dynamic>> getAuthHeaders() async {
    final token = await TokenService().getToken();

    return {'Authorization': 'Bearer $token'};
  }

  Future<SpecializedMachineryRequest?> getSMRequestDetail(String requestId) {
    return _networkClient.aliGet(
      path: '/smr/$requestId?user_detail=true',
      fromJson: (json) => SpecializedMachineryRequest.fromJson(
          json['specialized_machinery_request']),
    );
  }

  Future<List<SpecializedMachineryRequest>?> getSMRequestList(
      {String? userId,
      String? adSpecializedMachineryUserId,
      required String status,
      String? limit}) async {
    Map<String, dynamic> queryParams = {
      if (userId != null) 'user_id': userId,
      if (adSpecializedMachineryUserId != null)
        'ad_specialized_machinery_user_id': adSpecializedMachineryUserId,
      if (limit != null) 'limit': limit,
      'status': status,
      'user_detail': 'true'
    };

    try {
      final data = await _networkClient.aliGet(
        path: '/smr',
        fromJson: (json) {
          final List<dynamic> data = json['specialized_machinery_requests'];
          final result =
              data.map((e) => SpecializedMachineryRequest.fromJson(e)).toList();
          return result;
        },
        queryParams: queryParams,
      );
      print('REQUESTS $data');

      return data ?? [];
    } on Exception catch (e) {
      printLog(e, 'getSMRequestList');
      return [];
    }
  }

  Future<List<SpecializedMachineryRequestClient>?> getSMClientRequestList({
    String? userId,
    String? adClientUserId,
    String? limit,
    required String status,
  }) async {
    if (AppChangeNotifier().payload != null &&
        AppChangeNotifier().userMode == UserMode.driver) {
      Map<String, dynamic> queryParams = {
        'status': status,
        'document_detail': 'true',
        'user_detail': 'true',
        'user_assigned': 'true',

      };
      try {
        final data = await _networkClient.aliGet(
          path: '/client_request',
          queryParams: queryParams,
          fromJson: (json) {
            final List<dynamic> data = json['requests'];
            final result = data
                .map((e) => SpecializedMachineryRequestClient.fromJson(e))
                .toList();
            final single = result
                .where((e) =>
                    e.assigned == int.parse(userId ?? '0') ||
                    e.userId == int.parse(userId ?? '0'))
                .toList();
            return single;
          },
        );
        return data ?? [];
      } on Exception catch (e) {
        log(e.toString(), name: 'Errors : ');
        return [];
      }
    } else {
      Map<String, dynamic> queryParams = {
        if (userId != null) 'user_id': userId,
        if (adClientUserId != null) 'ad_client_user_id': adClientUserId,
        if (limit != null) 'limit': limit,
        'status': status,
        'document_detail': 'true',
      };

      try {
        final data = await _networkClient.aliGet(
          path: '/client_request',
          queryParams: queryParams,
          fromJson: (json) {
            final List<dynamic> data = json['requests'];
            final result = data
                .map((e) => SpecializedMachineryRequestClient.fromJson(e))
                .toList();
            return result;
          },
        );
        return data ?? [];
      } on Exception catch (e) {
        log(e.toString(), name: 'Errors : ');
        return [];
      }
    }
  }

  Future<http.Response?> postClientRequestForceApprove({
    required String adId,
    required String userId,
  }) async {
    final Map<String, dynamic> body = {
      'ad_client_id': int.parse(adId),
      'user_id': int.parse(userId),
    };

    return _networkClient.aliPost('/client_request/force_approve', body);
  }

  Future<http.Response?> postSMRequestApprove({
    required String requestId,
    String? executorID,
  }) async {
    final myUID = AppChangeNotifier().payload?.sub;
    if (executorID != null && myUID != executorID) {
      http.Response? response = await _networkClient
          .aliPost('/smr/$requestId/approve/assign_to', {"worker_id": int.tryParse(executorID)});
      return response;
    }
    http.Response? response =
        await _networkClient.aliPost('/smr/$requestId/approve', {});
    return response;
  }

  Future<http.Response?> postSMRequestCancel(
      {required String requestId}) async {
    http.Response? response =
        await _networkClient.aliPost('/smr/$requestId/canceled', {});

    return response;
  }

  Future<http.Response?> postClientRequestApprove(
      {required String requestId}) async {
    http.Response? response =
        await _networkClient.aliPost('/client_request/$requestId/approve', {});

    return response;
  }

  Future<http.Response?> postClientRequestCancel(
      {required String requestId}) async {
    http.Response? response =
        await _networkClient.aliPost('/client_request/$requestId/canceled', {});

    return response;
  }

  Future<http.Response?> postSMRequestAssignToDriver(
      {required String requestId, required String workerId}) async {
    final Map<String, dynamic> body = {
      'worker_id': int.tryParse(workerId),
    };

    http.Response? response =
        await _networkClient.aliPost('/smr/$requestId/approve/assign_to', body);
    return response;
  }

  Future<http.Response?> postClientRequestAssignToDriver({
    require,
    required String requestId,
    required String workerId,
  }) async {
    final Map<String, dynamic> body = {
      'worker_id': int.tryParse(workerId),
    };

    http.Response? response = await _networkClient.aliPost(
        '/client_request/$requestId/assign_to', body);

    return response;
  }

  Future<SpecializedMachineryRequestClient?> getClientRequestDetailWC(
      String requestId) async {
    return _networkClient.aliGet(
      path: '/client_request/$requestId',
      queryParams: {
        'user_detail': 'true',
        'executor_detail': 'true',
        'city_detail': 'true',
      },
      fromJson: (json) =>
          SpecializedMachineryRequestClient.fromJson(json['client_request']),
    );
  }

  Future<bool> reAssingRequest(String requestID, String executorID) async {
    final formData = FormData.fromMap({
      'base': jsonEncode({"executor_id": executorID})
    });
    try {
      final headers = await getAuthHeaders();

      final response = await Dio().patch(
          '${ApiEndPoints.baseUrl}/equipment/request_ad_equipment/$requestID/executor',
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

  Future<bool> reAssingClientRequest(
      String requestID, String executorID) async {
    final formData = FormData.fromMap({
      'base': jsonEncode({"executor_id": executorID})
    });
    try {
      final headers = await getAuthHeaders();

      final response = await Dio().patch(
          '${ApiEndPoints.baseUrl}/equipment/request_ad_equipment_client/$requestID/executor',
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
}
