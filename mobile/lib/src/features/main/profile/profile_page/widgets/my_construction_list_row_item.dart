import 'package:eqshare_mobile/custom_icons.dart';
import 'package:eqshare_mobile/src/core/presentation/routing/app_route.dart';
import 'package:eqshare_mobile/src/core/presentation/widgets/app_menu_row_widget.dart';
import 'package:eqshare_mobile/src/features/main/profile/profile_page/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MyConstructionListRowItem extends StatelessWidget {
  final ProfileController profileController;

  const MyConstructionListRowItem({
    super.key,
    required this.profileController,
  });

  @override
  Widget build(BuildContext context) {
    final menuText = getMenuText(profileController.appChangeNotifier.userMode);
    return AppMenuRowWidget(
      onTap: () {
        context.pushNamed(AppRouteNames.myAdConstruction);
      },
      menuRowData: AppMenuRowData(
        text: menuText,
        icon: CustomIcons.stroyMater,
      ),
    );
  }

  String getMenuText(UserMode? userMode) {
    switch (userMode) {
      case UserMode.driver:
        return 'Мои строительные материалы';
      case UserMode.owner:
        return 'Мои строительные материалы';
      default:
        return 'Мои объявления по строительным материалам';
    }
  }
}
