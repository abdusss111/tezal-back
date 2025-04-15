import 'package:eqshare_mobile/src/core/presentation/services/app_bottom_sheet_service.dart';
import 'package:eqshare_mobile/src/core/presentation/widgets/app_menu_row_widget.dart';
import 'package:eqshare_mobile/src/features/main/profile/profile_page/profile_controller.dart';
import 'package:flutter/material.dart';

class MyNotificationsRowItem extends StatelessWidget {
  final ProfileController profileController;
  const MyNotificationsRowItem({
    super.key,
    required this.profileController,
  });

  @override
  Widget build(BuildContext context) {
    const menuText = 'Уведомления';
    return AppMenuRowWidget(
      onTap: () {
        AppBottomSheetService.showAppCupertinoModalBottomSheet(
          context,
          const DevelopmentBottomSheetWidget(),
        );
      },
      menuRowData: const AppMenuRowData(
        text: menuText,
        icon: Icons.notifications_outlined,
      ),
    );
  }
}
