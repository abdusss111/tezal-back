import 'package:eqshare_mobile/custom_icons.dart';
import 'package:eqshare_mobile/src/core/presentation/routing/app_route.dart';
import 'package:eqshare_mobile/src/core/presentation/widgets/app_menu_row_widget.dart';
import 'package:eqshare_mobile/src/features/main/profile/profile_page/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MyAdEquipmentListRowItem extends StatelessWidget {
  final ProfileController profileController;

  const MyAdEquipmentListRowItem({
    super.key,
    required this.profileController,
  });

  @override
  Widget build(BuildContext context) {
    final menuText = getMenuText(profileController.appChangeNotifier.userMode);
    return AppMenuRowWidget(
      onTap: () {
        // if (profileController.appChangeNotifier.userMode == UserMode.driver ||
        //     profileController.appChangeNotifier.userMode == UserMode.owner) {
          // Navigator.pushNamed(context, AppRouteNames.myAdEquipmentList);
          context.pushNamed(AppRouteNames.myAdEquipmentList);
        // } else {
        //   // context.pushNamed(AppRouteNames.myAdEquipmentClientList);
        //   // Navigator.pushNamed(context, AppRouteNames.myAdEquipmentClientList);
        // }
      },
      menuRowData: AppMenuRowData(
        text: menuText,
        icon: CustomIcons.oborud,
      ),
    );
  }

  String getMenuText(UserMode? userMode) {
    switch (userMode) {
      case UserMode.driver:
        return 'Мое оборудование';
      case UserMode.owner:
        return 'Мое оборудование';
      default:
        return 'Мои объявления по оборудованиям';
    }
  }
}
