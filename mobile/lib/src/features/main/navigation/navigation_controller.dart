import 'dart:developer';

import 'package:eqshare_mobile/app/app_change_notifier.dart';
import 'package:eqshare_mobile/src/core/data/models/payload/payload.dart';
import 'package:flutter/material.dart';

import '../../../core/data/services/storage/token_provider_service.dart';
import '../profile/profile_page/profile_controller.dart';

class NavigationScreenController with ChangeNotifier {
  bool _isLoading = true;
  bool get isLoading => _isLoading;
  late int currentIndex;
  late int currentPageIndex;

  final appChangeNotifier = AppChangeNotifier();

  void initialCurrentPageIndex(int index) {
    currentPageIndex = index <= 2 ? index : index - 1;
  }

  void setInitialCurrentPageIndex(int index) {
    currentPageIndex = index <= 2 ? index : index - 1;
    notifyListeners();
  }

  Future<Payload?> getPayload()async{
    final payload = await TokenService().getPayload();
    return payload;
  }

  Future<void> updateUserMode(BuildContext context) async {
    _isLoading = true;
    notifyListeners();

    final token = await TokenService().getToken();
    if (token == null) {
      appChangeNotifier.userMode = UserMode.guest;
      _isLoading = false;
      notifyListeners();
      return;
    }

    final payload = TokenService().extractPayloadFromToken(token);
    switch (payload.aud) {
      case TokenService.driverAudience:
        appChangeNotifier.userMode = UserMode.driver;
      case TokenService.ownerAudience:
        appChangeNotifier.userMode = UserMode.owner;
      case TokenService.clientAudience:
        appChangeNotifier.userMode = UserMode.client;
      default:
        appChangeNotifier.userMode = UserMode.guest;
    }

    _isLoading = false;

    notifyListeners();
  }

  void handleTabChange(int newIndex) {
    log(newIndex.toString(), name: 'INdex');
    currentIndex = newIndex;
    currentPageIndex = newIndex <= 2 ? newIndex : newIndex - 1;

    notifyListeners();
  }
}
