import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:eqshare_mobile/src/core/data/models/payload/payload.dart';
import 'package:eqshare_mobile/src/core/data/services/storage/token_provider_service.dart';
import 'package:flutter/material.dart';

class AppSafeChangeNotifier extends ChangeNotifier {
  bool isConnected = true;
  bool _disposed = false;

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  @override
  void notifyListeners() {
    if (!_disposed) {
      try {
        super.notifyListeners();
      } on Exception catch (e) {
        // TODO
        log(e.toString());
      }
    }
  }

  Future<void> checkConnectivity() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    isConnected = connectivityResult != ConnectivityResult.none;
  }

  Future<Payload?> getPayload() async {
    final token = await TokenService().getToken();
    if (token != null) return TokenService().extractPayloadFromToken(token);
    return null;
  }
}
