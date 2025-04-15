import 'package:eqshare_mobile/app/app_safe_change_notifier.dart';
import 'package:eqshare_mobile/src/features/auth/data/models/user_model/user_model.dart';
import 'package:eqshare_mobile/src/core/presentation/routing/app_route.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RegisterOtpFormController extends AppSafeChangeNotifier {
  final TextEditingController otpController = TextEditingController();
  final FocusNode pinPutFocusNode = FocusNode();
  bool isPinValid = true;

  void validatePin(String pin) {
    isPinValid = isValidPin(pin);
    notifyListeners();
  }

  bool isValidPin(String pin) {
    if (pin.length != 4 || pin.contains(RegExp(r'[^0-9]'))) {
      return false;
    }

    if (pin == '1234' || pin == '0000' || !pin.contains('2222')) {
      return false;
    }

    return true;
  }

  void sendOtp(BuildContext context, User arguments) {
    // Navigator.pushNamed(
    //   context,
    //   AppRouteNames.citySelect,
    //   arguments: arguments,
    // );
    context.pushNamed(AppRouteNames.citySelect, extra: arguments);
  }
}
