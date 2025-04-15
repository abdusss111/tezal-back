import 'dart:developer';

import 'package:eqshare_mobile/src/core/data/models/user_model/user.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../../../res/api_endpoints/api_endpoints.dart';
import 'network_client.dart';

class UserProfileApiClient {
  final _networkClient = NetworkClient();

  Future<http.Response?> postSwitchToClient() async {
    const path = AuthEndPoints.switchToClient;

    http.Response? response = await _networkClient.aliPost(path, {});

    return response;
  }

  Future<http.Response?> postSwitchToDriver() async {
    const path = AuthEndPoints.switchToDriver;

    http.Response? response = await _networkClient.aliPost(path, {});

    return response;
  }

  Future<http.Response?> postSwitchToOwner() async {
    try {
      const path = AuthEndPoints.switchToOwner;

      http.Response? response = await _networkClient.aliPost(path, {});
      log((response?.body ?? 'no').toString(), name: 'respomse body');
      if (response?.statusCode != 200) {
        throw (response!.body.toString());
      }
      return response;
    } on Exception catch (e) {
      log(e.toString(), name: 'Error on postSwitchToOwner ');
      rethrow;
    }
  }

  Future<http.Response?> postPurchaseOwnerRole() async {
    const path = AuthEndPoints.getOwnerRole;
    http.Response? response = await _networkClient.aliPost(path, {});
    log((response?.body ?? '').toString(), name: 'postPurchaseOwnerRole');

    return response;
  }

  Future<User?> getUserDetail(String userId) async {
    try {
      final result = await _networkClient.aliGet(
        path: '/user/$userId',
        fromJson: (json) {
          log(json.toString(), name: 'Json to String() : ');
          final data = json['user'];
          log(data.toString(), name: 'data to String() : ');

          final result = User.fromJson(data);
          log(result.toString(), name: 'result to String() : ');
          return result;
        },
      );

      return result;
    } on Exception catch (e) {
      printLog(e, 'getUserDetail');
    }
    return null;
  }

  Future<http.Response?> updatePassword(
      {required String password, required User? user}) async {
    try {
      final result = await _networkClient.aliPut('/user/profile', {
        "city_id": user?.cityId,
        "email": user?.phoneNumber,
        "firs_name": user?.firstName,
        "last_name": user?.lastName,
        "password": password,
      });
      return result;
    } catch (e) {
      printLog(e, 'updatePassword');
      return null;
    }
  }

  Future<List<User>?> getMyWorkers(String ownerId) async {
    try {
      final result = await _networkClient.aliGet(
          path: '/user?owner_id=$ownerId&document_detail=true',
          fromJson: (json) {
            final List<dynamic> getMyWorkersJson = json['users'];
            log(getMyWorkersJson.toString());
            final List<User> result =
                getMyWorkersJson.map((e) => User.fromJson(e)).toList();
            return result;
          });
      return result;
    } on Exception catch (e) {
      printLog(e, 'getMyWorkers');
    }
    return null;
  }

  // TODO расписать получение локации
  Future<dynamic?> getWorkersLocations(String ownerId) async {
    try {
      final result = await _networkClient.aliGet2(
          path: '/re/stream_drivers',
          fromJson: (json) {
            final getMyWorkersJson = json;
            // final List<User> result =
            //     getMyWorkersJson.map((e) => User.fromJson(e)).toList();
            return getMyWorkersJson;
            
          });
          print(result);
      return result;
    } on Exception catch (e) {
      printLog(e, 'getMyWorkers');
    }
    return null;
  }

  Future<http.Response?> deleteWorker({
    required String? ownerId,
    required int? workerId,
  }) async {
    final http.Response? result = await _networkClient.aliDelete(
      '/owner/$ownerId/worker/$workerId',
    );
    return result;
  }

  void printLog(Object e, String errorName) {
    return log(e.toString(), name: 'Error name : ');
  }
}
