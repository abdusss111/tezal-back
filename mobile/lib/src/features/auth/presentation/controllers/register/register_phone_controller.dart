
import 'package:eqshare_mobile/app/app_safe_change_notifier.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../data/models/user_model/user_model.dart';
import '../../../../../core/presentation/routing/app_route.dart';

class RegisterPhoneController extends AppSafeChangeNotifier {
  final TextEditingController phoneController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String? phoneNumber;
  bool isIgnoring = true;
  bool obscureText = true;

  void setisIgnoring() {
    isIgnoring = !isIgnoring;
    notifyListeners();
  }

  void setobscureText(bool value) {
    obscureText = value;
    notifyListeners();
  }

  void setPhoneNumber(String number) {
    phoneNumber = number;
    notifyListeners();
  }

  bool validatePhoneNumber() {
    if (phoneNumber == null || phoneNumber!.isEmpty) {
      return false;
    }
    return phoneNumber!.replaceAll(RegExp(r'\D'), '').length == 11;
  }

  void sendOtp(BuildContext context) {
    if (validatePhoneNumber()) {
      final formattedPhoneNumber =
          '+7${phoneNumber!.replaceAll(RegExp(r'\D'), '')}';
      // Navigator.pushNamed(
      //   context,
      //   AppRouteNames.registerOtpForm,
      //   arguments: User(phoneNumber: formattedPhoneNumber, cityId: -1),
      // );
      context.pushNamed(
        AppRouteNames.registerOtpForm,
        extra: User(phoneNumber: formattedPhoneNumber, cityId: -1),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Пожалуйста, введите действующий номер телефона.'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }
}
