import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:eqshare_mobile/app/app_change_notifier.dart';
import 'package:eqshare_mobile/src/core/data/services/storage/token_provider_service.dart';
import 'package:eqshare_mobile/src/core/res/api_endpoints/api_endpoints.dart';
import 'package:eqshare_mobile/src/features/main/profile/profile_page/profile_controller.dart';
import 'package:eqshare_mobile/src/features/requests/data/models/equipment_request/equipment_client_request_model/request_ad_equipment_client.dart';
import 'package:eqshare_mobile/src/features/requests/data/models/equipment_request/equipment_request_model/request_ad_equipment.dart';
import 'package:eqshare_mobile/src/features/requests/data/repository/request_execution_repository.dart';

import 'package:http/http.dart' as http;

import '../../../../core/data/services/network/api_client/network_client.dart';

class EquipmentRequestRepositoryImpl extends RequestExecutionRepository {
  final _networkClient = NetworkClient();

  Future<Map<String, dynamic>> getAuthHeaders() async {
    final token = await TokenService().getToken();

    return {'Authorization': 'Bearer $token'};
  }

  Future<RequestAdEquipment?> getEquipmentRequestDetail(
      String requestId) async {
    return _networkClient.aliGet(
      path: '/equipment/request_ad_equipment/$requestId',
      fromJson: (json) {
        return RequestAdEquipment.fromJson(json['request_ad_equipment']);
      },
      queryParams: {
        'user_detail': 'true',
        'city_detail': 'true',
        'ad_equipment_detail': 'true',
        'document_detail': 'true',
      },
    );
  }

  Future<List<RequestAdEquipment>?> getEquipmentRequestList(
      {String? userIds,
      String? adEquipmentUserIds,
      required String status,
      String? limit}) async {
    Map<String, dynamic> queryParams = {
      if (userIds != null) 'user_ids': userIds,
      if (adEquipmentUserIds != null)
        'ad_equipment_user_ids': adEquipmentUserIds,
      if (limit != null) 'limit': limit,
      'status': status,
      'document_detail': 'true',
      'ad_equipment_detail': 'true',
      'executor_detail': 'true',
      'user_detail': 'true'
    };

    final result = await _networkClient.aliGet(
      path: '/equipment/request_ad_equipment',
      fromJson: (json) {
        final List<dynamic> data = json['request_ad_equipments'];
        final result = data.map((e) => RequestAdEquipment.fromJson(e)).toList();
        return result;
      },
      queryParams: queryParams,
    );

    return result;
  }

  Future<List<RequestAdEquipmentClient>?> getEquipmentClientRequestList({
    String? userId,
    String? adClientUserId,
    String? limit,
    required String status,
  }) async {
    if (AppChangeNotifier().userMode == UserMode.driver) {
      Map<String, dynamic> queryParams = {
        if (status.isNotEmpty) 'status': status,
        'ad_equipment_client_detail': 'true',
        'ad_equipment_client_document_detail': 'true',
        'user_detail': 'true',
        'executor_detail': 'true'
      };
      try {
        final data = await _networkClient.aliGet(
          path: '/eq  ',
          queryParams: queryParams,
          fromJson: (json) {
            final List<dynamic> getData = json['request_ad_equipment_clients'];
            final result = getData
                .map((e) => RequestAdEquipmentClient.fromJson(e))
                .toList();
            final single = result
                .where((e) => e.executorId == int.parse(userId ?? '0'))
                .toList();
            return single;
          },
        );
        return data;
      } catch (e) {
        log('Error fetching data: $e');
      }
    } else {
      Map<String, dynamic> queryParams = {
        if (userId != null) 'user_id': userId.toString(),
        if (adClientUserId != null) 'ad_equipment_client_ids': adClientUserId,
        if (limit != null) 'limit': limit,
        if (status.isNotEmpty) 'status': status,
        'ad_equipment_client_detail': 'true',
        'ad_equipment_client_document_detail': 'true'
      };
      try {
        final data = await _networkClient.aliGet(
          path: '/equipment/request_ad_equipment_client',
          queryParams: queryParams,
          fromJson: (json) {
            final List<dynamic> getData = json['request_ad_equipment_clients'];
            final result = getData
                .map((e) => RequestAdEquipmentClient.fromJson(e))
                .toList();
            return result;
          },
        );
        return data;
      } catch (e) {
        log('Error fetching data: $e');
      }
    }

    return [];
  }

  Future<List<RequestAdEquipmentClient>?>
      getEquipmentClientRequestWhereAuthorISClient({
    required String userId,
    String? limit,
    required String status,
  }) async {
    Map<String, dynamic> queryParams = {
      if (limit != null) 'limit': limit,
      if (status.isNotEmpty) 'status': status,
      'ad_equipment_client_detail': 'true',
      'ad_equipment_client_document_detail': 'true',
       'user_detail': 'true',
        'executor_detail': 'true'
    };
    try {
      final data = await _networkClient.aliGet(
        path: '/equipment/request_ad_equipment_client',
        queryParams: queryParams,
        fromJson: (json) {
          final List<dynamic> getData = json['request_ad_equipment_clients'];
          final result =
              getData.map((e) => RequestAdEquipmentClient.fromJson(e)).toList();
          return result
              .where((e) => e.adEquipmentClient?.userId == int.parse(userId))
              .toList();
        },
      );
      return data;
    } catch (e) {
      log('Error fetching data: $e');
    }

    return [];
  }

  Future<http.Response?> postEquipmentClientRequestForceApprove({
    required String adId,
    required String userId,
  }) async {
    final Map<String, dynamic> body = {
      'ad_client_id': int.parse(adId),
      'user_id': int.parse(userId),
    };

    return _networkClient.aliPost('/client_request/force_approve', body);
  }

  Future<http.Response?> postEquipmentRequestApprove(
      {required String requestId, String? executorID}) async {
    http.Response? response = await _networkClient.aliPost(
        '/equipment/request_ad_equipment/$requestId/approve',
        {if (executorID != null) "executor_id": int.parse(executorID)});
    return response;
  }

  Future<http.Response?> postEquipmentRequestCancel({
    required String requestId,
  }) async {
    http.Response? response = await _networkClient
        .aliPost('/equipment/request_ad_equipment/$requestId/canceled', {});

    return response;
  }

  Future<http.Response?> postEquipmentClientRequestApprove({
    required String requestId,
  }) async {
    http.Response? response = await _networkClient.aliPost(
        '/equipment/request_ad_equipment_client/$requestId/approve', {});

    return response;
  }

  Future<http.Response?> postEquipmentClientRequestCancel({
    required String requestId,
  }) async {
    http.Response? response = await _networkClient.aliPost(
        '/equipment/request_ad_equipment_client/$requestId/canceled', {});

    return response;
  }

  Future<http.Response?> postEquipmentRequestAssignToDriver({
    required String requestId,
    required String workerId,
  }) async {
    final Map<String, dynamic> body = {
      'executor_id': int.tryParse(workerId),
    };

    http.Response? response = await _networkClient.aliPost(
        '/equipment/request_ad_equipment/$requestId/approve', body);
    return response;
  }

  // Future<http.Response?> postEquipmentClientRequestAssignToDriver({

  //   required String requestId,
  //   required String workerId,
  // }) async {
  //   final Map<String, dynamic> body = {
  //     'worker_id': int.tryParse(workerId),
  //   };

  //   http.Response? response = await _networkClient.aliPost(
  //       '/client_request/$requestId/assign_to', context, body);
  //   return response;
  // }

  Future<http.Response?> postForDriverRequest(Map<String, dynamic> body) async {
    final response =
        _networkClient.aliPost('/equipment/request_ad_equipment_client', body);
    return response;
  }

  Future<RequestAdEquipmentClient?> getRequestAdEquipmentClientDetail(
      {required String requestId}) async {
    try {
      final data = await _networkClient.aliGet(
          path: '/equipment/request_ad_equipment_client/$requestId',
          fromJson: (json) {
            return RequestAdEquipmentClient.fromJson(
                json['request_ad_equipment']);
          });
      return data;
    } on Exception catch (e) {
      log(e.toString(), name: 'Error getAdEquipmentListWithDio');
      return null;
    }
  }

  Future<RequestAdEquipment?> getEquipmentRequestDetailWC(
      String requestId) async {
    return _networkClient.aliGet(
      path: '/equipment/request_ad_equipment/$requestId',
      fromJson: (json) {
        return RequestAdEquipment.fromJson(json['request_ad_equipment']);
      },
      queryParams: {
        'user_detail': 'true',
        'city_detail': 'true',
        'ad_equipment_detail': 'true',
        'document_detail': 'true',
      },
    );
  }

  Future<bool> reAssingEquipmentRequest(
      String requestID, String executorID) async {
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

  Future<bool> reAssingClientEquipmentRequest(
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
