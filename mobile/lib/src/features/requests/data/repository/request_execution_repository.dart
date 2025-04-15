import 'dart:developer';

import 'package:eqshare_mobile/src/core/data/models/payload/payload.dart';
import 'package:eqshare_mobile/src/core/data/services/network/api_client/network_client.dart';
import 'package:eqshare_mobile/src/core/data/services/storage/token_provider_service.dart';
import 'package:eqshare_mobile/src/features/requests/data/models/request_execution_list/request_execution.dart';
import 'package:eqshare_mobile/src/features/requests/data/models/request_history/request_history.dart';
import 'package:eqshare_mobile/src/features/requests/data/models/request_statistic/request_statistic.dart';

class RequestExecutionRepository {
  final _networkClient = NetworkClient();

  Future<Payload> getPayload() async {
    final token = await TokenService().getToken();
    return TokenService().extractPayloadFromToken(token ?? '-1');
  }

  Future<bool> startOrAcceptRequestExecution(
      {required String requestID}) async {
    try {
      await _networkClient.aliPost('/re/$requestID/start', {});
      return true;
    } catch (e) {
      printLog(e, 'startOrAcceptRequestExecution');
      return false;
    }
  }

  Future<bool> finishRequestExecution({
    required String requestID,
    required int amount,
  }) async {
    try {
      final Map<String, dynamic> body = {
        'payment_amount': amount,
      };
      await _networkClient.aliPost('/re/$requestID/finish', body);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> pauseRequestExecution({required String requestID}) async {
    try {
      await _networkClient.aliPost('/re/$requestID/pause', {});
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> toRoadRequestExecution({required String requestID}) async {
    try {
      await _networkClient.aliPost('/re/$requestID/on_road', {});
      return true;
    } on Exception catch (e) {
      printLog(e, 'toRoadRequestExecution');
      return false;
    }
  }

  Future<RequestExecution?> getRequestExecutionDetail(
      {required String requestID, String? adNameForQueryParams}) async {
    try {
      final response = await _networkClient.aliGet(
        path: '/re/$requestID',
        queryParams: {
          'document_detail': 'true',
          'city_detail': 'true',
          'client_detail': 'true',
          'user_detail': 'true',
          '$adNameForQueryParams': 'true',
        },
        fromJson: (json) {
          return RequestExecution.fromJson(json['request_execution']);
        },
      );
      return response;
    } catch (e) {
      printLog(e, 'getRequestExecutionDetail');
      return null;
    }
  }

  Future<bool> rateOrder(
      {required int rating,
      required RequestExecution request,
      required String text}) async {
    final Map<String, dynamic> body = {
      'rate': rating,
      'comment': text,
    };
    try {
      await _networkClient.aliPut('/re/${request.id}/rate', body, isJson: true);
      return true;
    } on Exception catch (e) {
      printLog(e, 'rateOrder');
      return false;
    }
  }

  Future<List<RequestExecution>?> getListOfRequestExecutionForClientList(
      {required String userID, List<String>? src, List<String>? status}) async {
    try {
      final map = <String, dynamic>{
        'document_detail': 'true',
        'city_detail': 'true',
        'user_detail': 'true',
        'client_id': userID,
      };
      if (src != null) {
        map.addAll({'src': src});
      }
      if (status != null) {
        map.addAll({'statuc': status});
      }
      final response = await _networkClient.aliGet(
        path: '/re',
        queryParams: map,
        fromJson: (json) {
          final List<dynamic> data = json['request_execution'];
          final result = data
              .map((e) => RequestExecution.fromJson(json['request_execution']))
              .toList();
          return result;
        },
      );
      return response;
    } catch (e) {
      printLog(e, 'getRequestExecutionDetail');
      return null;
    }
  }

  Future<List<RequestExecution>?>
      getListOfRequestExecutionForDriverOrOwnerList({
    List<String>? status,
    List<String>? src,
    Map<String, dynamic>? map,
  }) async {
    final queryParameters = {
      'document_detail': 'true',
      'city_detail': 'true',
      'user_detail': 'true',
      if (src != null) 'src': src,
      if (status != null) 'status': status
    };

    try {
      final token = await TokenService().getToken();
      final payload = TokenService().extractPayloadFromToken(token ?? '-1');
      if (payload.aud == 'CLIENT') {
        queryParameters.addAll({'client_id': payload.sub ?? ''});
      } else if (payload.aud == 'OWNER') {
        queryParameters.addAll({'driver_id': payload.sub ?? ''});
      } else {
        queryParameters.addAll(
            {'driver_id': payload.sub ?? '', 'assign_to': payload.sub ?? ''});
      }
      final response = await _networkClient.aliGet(
        path: '/re',
        queryParams: queryParameters,
        fromJson: (json) {
          final List<dynamic> data = json['request_execution'];
          final result = data.map((e) {
            try {
              return RequestExecution.fromJson(e);
            } on Exception catch (e) {
              log(e.toString(),
                  name: 'getListOfRequestExecutionForDriverOrOwnerList error');
              return RequestExecution(title: 'Empty');
            }
          }).toList();
          return result;
        },
      );
      return response;
    } catch (e) {
      printLog(e, 'getListOfRequestExecutionForDriverOrOwnerList');
      return null;
    }
  }

  Future<List<RequestExecution>?> getListOfRequestExecutionWithBigData({
    List<String>? status,
    List<String>? src,
    Map<String, dynamic>? map,
  }) async {
    final queryParameters = {
      'document_detail': 'true',
      'city_detail': 'true',
      'user_detail': 'true',
      if (src != null) 'src': src,
      if (status != null) 'status': status
    };

    try {
      final token = await TokenService().getToken();
      final payload = TokenService().extractPayloadFromToken(token ?? '-1');
      if (payload.aud == 'CLIENT') {
        queryParameters.addAll({'client_id': payload.sub ?? ''});
      } else if (payload.aud == 'OWNER') {
        queryParameters.addAll({
          'driver_id': payload.sub ?? '',
        });
      } else {
        queryParameters.addAll(
            {'driver_id': payload.sub ?? '', 'assign_to': payload.sub ?? ''});
      }
      final response = await _networkClient.aliGet(
        path: '/re',
        queryParams: queryParameters,
        fromJson: (json) {
          final List<dynamic> data = json['request_execution'];
          final result = data.map((e) {
            try {
              return RequestExecution.fromJson(e);
            } on Exception catch (e) {
              log(e.toString(),
                  name: 'getListOfRequestExecutionWithBigData error');

              return RequestExecution(title: 'Empty');
            }
          }).toList();
          return result;
        },
      );
      return response;
    } catch (e) {
      printLog(e, 'getListOfRequestExecutionForDriverOrOwnerList');
      return null;
    }
  }

  Future<int?> getRequestExecutionCount({
    List<String>? status,
    List<String>? src,
    Map<String, dynamic>? map,
  }) async {
    final queryParameters = {
      'document_detail': 'true',
      'city_detail': 'true',
      'user_detail': 'true',
      if (src != null) 'src': src,
      if (status != null) 'status': status
    };

    try {
      final token = await TokenService().getToken();
      final payload = TokenService().extractPayloadFromToken(token ?? '-1');
      if (payload.aud == 'CLIENT') {
        queryParameters.addAll({'client_id': payload.sub ?? ''});
      } else if (payload.aud == 'OWNER') {
        queryParameters.addAll({
          'driver_id': payload.sub ?? '',
        });
      } else {
        queryParameters.addAll(
            {'driver_id': payload.sub ?? '', 'assign_to': payload.sub ?? ''});
      }
      final response = await _networkClient.aliGet(
        path: '/re',
        queryParams: queryParameters,
        fromJson: (json) {
          final int data = json['total'];

          return data;
        },
      );
      return response;
    } catch (e) {
      printLog(e, 'getListOfRequestExecutionForDriverOrOwnerList');
      return null;
    }
  }

  Future<RequestHistory?> getRequestHistory(String requestId) async {
    return _networkClient.aliGet(
      path: '/statistics/re/$requestId/history',
      fromJson: RequestHistory.fromJson,
    );
  }

  Future<RequestStatistic?> getRequestStatistic(String requestId) async {
    return _networkClient.aliGet(
      path: '/statistics/re/$requestId/status',
      fromJson: RequestStatistic.fromJson,
    );
  }

  void printLog(Object e, String errorName) {
    return log(e.toString(), name: 'Error name :$errorName');
  }
}
