import 'package:eqshare_mobile/src/core/presentation/routing/app_route.dart';
import 'package:eqshare_mobile/src/core/presentation/widgets/app_menu_row_widget.dart';
import 'package:eqshare_mobile/src/features/main/profile/profile_page/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MyDriversRowItem extends StatelessWidget {
  final ProfileController profileController;
  const MyDriversRowItem({
    super.key,
    required this.profileController,
  });

  @override
  Widget build(BuildContext context) {
    const menuText = 'Мои водители';
    return AppMenuRowWidget(
      onTap: () {
        context.pushNamed(AppRouteNames.myWorkersList);
      },
      menuRowData: const AppMenuRowData(
        text: menuText,
        icon: Icons.people_outline_outlined,
      ),
    );
  }
}
