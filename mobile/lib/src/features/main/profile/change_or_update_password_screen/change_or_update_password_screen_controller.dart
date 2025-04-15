import 'dart:developer';


import 'package:eqshare_mobile/app/app_safe_change_notifier.dart';
import 'package:eqshare_mobile/src/core/data/models/user_model/user.dart';
import 'package:eqshare_mobile/src/core/data/services/network/api_client/user_profile_api_client.dart';
import 'package:eqshare_mobile/src/core/data/services/storage/token_provider_service.dart';

import 'package:flutter/material.dart';

class ChangeOrUpdatePasswordScreenController extends AppSafeChangeNotifier {
  String newPassword = '';
  final userProfileApiClient = UserProfileApiClient();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordRepaetController =
      TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  User? user;

  bool obsureMainPassword = true;
  bool obsureRepaetPassword = true;

  void changeObsureRepaetPassword() {
    obsureRepaetPassword = !obsureRepaetPassword;
    notifyListeners();
  }

  void changeObsureMainPassword() {
    obsureMainPassword = !obsureMainPassword;
    notifyListeners();
  }

  void changeNewPassword(String newPasswordValue) {
    newPassword = newPasswordValue;
    notifyListeners();
  }

  Future<bool> updatePassword() async {
    if (user != null) {
      try {
        final result = await userProfileApiClient.updatePassword(
            password: newPassword, user: user);

        if (result?.statusCode == 200) {
          return true;
        } else {
          throw (result ?? '');
        }
      } on Exception catch (e) {
        log(e.toString(), name: 'Erros s f s a ;');
        return false;
      }
    }
    return false;
  }

  Future<User?> getUserDetail() async {
    final token = await TokenService().getToken();
    final payload = TokenService().extractPayloadFromToken(token!);
    user =
        await userProfileApiClient.getUserDetail(payload.sub!);
    return user;
  }

  void clearAll() {
    passwordController.clear();
    passwordRepaetController.clear();
    newPassword = '';
    notifyListeners();
  }
}
