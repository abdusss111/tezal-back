import 'package:eqshare_mobile/src/core/presentation/services/app_dialog_service.dart';
import 'package:flutter/material.dart';

import 'package:eqshare_mobile/src/features/main/profile/driver_form/driver_form_screen.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/presentation/widgets/app_snack_bar.dart';

class UserNameInfo {
  String? firstName;
  String? lastName;
  UserNameInfo({
    required this.firstName,
    required this.lastName,
  });
}

class ProfileControllerUtils {
  static const String driverAudience = 'DRIVER';
  static const String ownerAudience = 'OWNER';
  static const String navigationScreenIndex = '4';

  static Future<void> showLoadingDialog(BuildContext context) async {
    AppDialogService.showLoadingDialog(context);
  }

  static void navigateToScreen(BuildContext context, String screenName) {
    // Navigator.of(context).pushNamedAndRemoveUntil(
    //   screenName,
    //   arguments: {'index': '4'},
    //   (route) => false,
    // );
    context.pushReplacementNamed(screenName, extra: {'index': '4'});
  }

  static void navigateToDriverForm(
      BuildContext context, UserNameInfo? userNameInfo) {
    // Navigator.pop(context);
    context.pop();
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: ((context) => userNameInfo != null
              ? DriverFormScreen(userNameInfo: userNameInfo)
              : const DriverFormScreen())),
    );
  }

  static void showErrorSnackbar(BuildContext context, String errorMessage) {
    ScaffoldMessenger.of(context)
        .showSnackBar(AppSnackBar.showErrorSnackBar( errorMessage));
  }
}
