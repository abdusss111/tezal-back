import 'dart:convert';


import 'package:eqshare_mobile/app/app_safe_change_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:eqshare_mobile/src/core/presentation/routing/app_route.dart';
import 'package:go_router/go_router.dart';

import '../../../presentation/widgets/restart_widget.dart';
import '../../models/payload/payload.dart';

class TokenService extends AppSafeChangeNotifier{
  static const _secureStorage = FlutterSecureStorage();
  static const _tokenKey = 'token';
  static const _idKey = 'id';
  static const driverAudience = 'DRIVER';
  static const ownerAudience = 'OWNER';
  static const clientAudience = 'CLIENT';

  String? _token;
  String? _uid;

  String? get token => _token;
  String? get uid => _uid;

  TokenService() {
    _initToken();
  }

  Future<void> _initToken() async {
    _token = await _secureStorage.read(key: _tokenKey);
    _uid = await _secureStorage.read(key: _idKey);
    notifyListeners();
  }

  Future<void> setToken(String? value) async {
    if (value != null) {
      await _secureStorage.write(key: _tokenKey, value: value);
    } else {
      await _secureStorage.delete(key: _tokenKey);
    }
    _token = value;
    notifyListeners();
  }

  Future<void> deleteAll() async {
    await _secureStorage.deleteAll();
    _token = null;
    _uid = null;
    notifyListeners();
  }

  Future<String?> getToken() async => await _secureStorage.read(key: _tokenKey);

  Future<String?> getId() async => await _secureStorage.read(key: _idKey);

  Future<void> setId(String? value) async {
    if (value != null) {
      await _secureStorage.write(key: _idKey, value: value);
    } else {
      await _secureStorage.delete(key: _idKey);
    }
  }

  Future<String?> purchaseToken(BuildContext context) async {
    final token = await getToken();

    if (token == null) {
      if (context.mounted) {
        deleteAll();
        RestartWidget.restartApp(context);
        // Navigator.of(context)
        //     .pushNamedAndRemoveUntil(AppRouteNames.login, (route) => false);
        context.go('/${AppRouteNames.login}');
      }
    }
    return token;
  }

  Payload extractPayloadFromToken(String token) {
    final encodedPayload = token.split('.')[1];
    final payloadData =
        utf8.fuse(base64).decode(base64.normalize(encodedPayload));
    return Payload.fromJson(jsonDecode(payloadData));
  }
}
