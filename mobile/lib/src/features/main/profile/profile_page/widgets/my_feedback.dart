import 'package:eqshare_mobile/src/core/presentation/services/app_bottom_sheet_service.dart';
import 'package:eqshare_mobile/src/core/presentation/widgets/app_menu_row_widget.dart';
import 'package:eqshare_mobile/src/features/main/profile/profile_page/profile_controller.dart';
import 'package:eqshare_mobile/src/features/main/profile/profile_page/widgets/send_feedback.dart';
import 'package:flutter/material.dart';

class MyFeedbackItem extends StatelessWidget {
  final ProfileController profileController;

  const MyFeedbackItem({
    super.key,
    required this.profileController,
  });

  @override
  Widget build(BuildContext context) {
    const menuText = 'Обратная связь';
    return AppMenuRowWidget(
      onTap: () {
        AppBottomSheetService.showAppCupertinoModalBottomSheet(
          context,
          SendFeedbackBottomSheet(
              profileController: profileController), // Removed 'const'
        );
      },
      menuRowData: const AppMenuRowData(
        text: menuText,
        icon: Icons.feedback_outlined,
      ),
    );
  }
}
