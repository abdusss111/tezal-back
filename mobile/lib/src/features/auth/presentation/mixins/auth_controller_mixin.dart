import 'package:eqshare_mobile/app/app_change_notifier.dart';
import 'package:eqshare_mobile/src/core/presentation/routing/app_route.dart';
import 'package:eqshare_mobile/src/core/presentation/widgets/app_snack_bar.dart';
import 'package:eqshare_mobile/src/features/main/profile/profile_page/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../core/presentation/services/app_dialog_service.dart';

mixin AuthControllerMixin {
  void navigateToHomeScreen(BuildContext context) async {
    await AppChangeNotifier().init();
    if (context.mounted) {
      Provider.of<ProfileController>(context, listen: false).isLoadingProfile();
    }
    if (context.mounted) {
      Provider.of<ProfileController>(context, listen: false).loadProfile();
    }
    if (context.mounted) {
      context.go("/${AppRouteNames.navigation}", extra: {'index': '5'});
    }
  }

  void showErrorMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      AppSnackBar.showErrorSnackBar(message),
    );
    // Navigator.pop(context);
    // context.pop();
    context.go('/${AppRouteNames.navigation}', extra: {'index': '4'});
  }

  void showLoadingDialog(BuildContext context) {
    AppDialogService.showLoadingDialog(context);
  }

  void hideLoadingDialog(BuildContext context) {
    // Navigator.of(context).pop();
    context.pop();
  }
}
