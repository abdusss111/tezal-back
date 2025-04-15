import 'package:connectivity_plus/connectivity_plus.dart';

import 'package:eqshare_mobile/src/core/data/models/payload/payload.dart';
import 'package:eqshare_mobile/src/core/data/services/storage/token_provider_service.dart';
import 'package:eqshare_mobile/src/features/main/profile/profile_page/profile_controller.dart';
import 'package:flutter/material.dart';

class AppChangeNotifier extends ChangeNotifier {
  AppChangeNotifier._internal();

  // Единственный экземпляр класса
  static final AppChangeNotifier _instance = AppChangeNotifier._internal();

  // Фабричный конструктор, который возвращает этот единственный экземпляр
  factory AppChangeNotifier() => _instance;

  UserMode? _userMode = UserMode.guest;
  UserMode? get userMode => _userMode;
  Payload? _payload;
  Payload? get payload => _payload;
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<void> init() async {
    final token = await TokenService().getToken();
    if (token != null) {
      _payload = TokenService().extractPayloadFromToken(token);
      _getUserModeFromPayload();
    }
    notifyListeners();
  }

  void _getUserModeFromPayload() {
    switch (payload?.aud ?? '') {
      case TokenService.driverAudience:
        _userMode = UserMode.driver;
      case TokenService.ownerAudience:
        _userMode = UserMode.owner;
      case TokenService.clientAudience:
        _userMode = UserMode.client;
      default:
        _userMode = UserMode.guest;
    }
  }

  set userMode(UserMode? value) {
    _userMode = value;
    notifyListeners();
  }

  void setErrorMessage(String? value) {
    _errorMessage = value;
    notifyListeners();
  }

  bool isConnected = true;
  bool _disposed = false;

  void unnull() {
    _payload = null;
    _userMode = UserMode.guest;
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  @override
  void notifyListeners() {
    if (!_disposed) {
      super.notifyListeners();
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

  void updateProfileData(Payload payload) {
    switch (payload.aud) {
      case TokenService.driverAudience:
        _userMode = UserMode.driver;
      case TokenService.ownerAudience:
        _userMode = UserMode.owner;
      case TokenService.clientAudience:
        _userMode = UserMode.client;
      default:
        _userMode = UserMode.guest;
    }
    notifyListeners();
  }

  Future<String> getUserMode() async {
    final token = await TokenService().getToken();
    var mode = UserMode.guest;
    if (token == null) {
      userMode = UserMode.guest;
      mode = userMode!;
    } else {
      final payload = TokenService().extractPayloadFromToken(token);
      updateProfileData(payload);
      mode = userMode!;
    }
    notifyListeners();
    return mode.name;
  }
}
