import 'package:eqshare_mobile/src/core/presentation/widgets/app_primary_button.dart';
import 'package:eqshare_mobile/src/core/res/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:eqshare_mobile/src/features/main/profile/profile_page/profile_controller.dart';

class UserModeSwitcher extends StatelessWidget {
  final ProfileController profileController;

  const UserModeSwitcher({super.key, required this.profileController});

  @override
  Widget build(BuildContext context) {
    final userModeText =
        getUserModeText(profileController.appChangeNotifier.userMode);

    return GestureDetector(
      onTap: () {
        _showUserModeModal(context, profileController);
      },
      child: Container(
        height: 35,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(8),
            bottomLeft: Radius.circular(8),
          ),
          color: Theme.of(context).primaryColor,
        ),
        child: Align( alignment: Alignment.center ,child: Text(
          userModeText,
          textAlign: TextAlign.center,
          style:  TextStyle(color: Colors.white, fontSize: MediaQuery.of(context).size.width * 0.04),
        ),
      ),
    ));
  }

  void _showUserModeModal(
      BuildContext context, ProfileController profileController) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
            child: Container(
          padding: const EdgeInsets.all(16),
          child: _buildUserModeButtons(context, profileController),
        ));
      },
    );
  }

  Widget _buildUserModeButtons(
      BuildContext context, ProfileController controller) {
    final userMode = controller.appChangeNotifier.userMode;
    final isDriver = userMode == UserMode.driver;
    final isOwner = userMode == UserMode.owner;

    final textStyle = Theme.of(context)
        .textTheme
        .labelLarge
        ?.copyWith(color: Colors.white, fontSize: 15);
    const double height = 48;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (isDriver) ...[
          AppPrimaryButtonWidget(
            height: height,
            backgroundColor: AppColors.appOwnerPrimaryColor,
            onPressed: () {
              controller.switchMode(context: context, userMode: UserMode.owner);
            },
            text: 'Переключиться в режим бизнеса',
            icon: Icons.arrow_forward_ios_outlined,
            textStyle: textStyle,
          ),
          const SizedBox(height: 6),
        ],
        if (isOwner) ...[
          AppPrimaryButtonWidget(
            height: height,
            backgroundColor: AppColors.appDriverPrimaryColor,
            onPressed: () {
              controller.switchMode(
                  context: context, userMode: UserMode.driver);
            },
            text: 'Переключиться в режим водителя',
            icon: Icons.arrow_forward_ios_outlined,
            textStyle: textStyle,
          ),
          const SizedBox(height: 6),
        ],
        AppPrimaryButtonWidget(
          height: height,
          backgroundColor: isDriver || isOwner
              ? AppColors.appPrimaryColor
              : AppColors.appDriverPrimaryColor,
          onPressed: () {
            controller.switchMode(
                context: context,
                userMode:
                    isDriver || isOwner ? UserMode.client : UserMode.driver);
          },
          text: isDriver || isOwner
              ? 'Переключиться в режим клиента'
              : 'Переключиться в режим водителя',
          icon: Icons.arrow_forward_ios_outlined,
          textStyle: textStyle,
        ),
      ],
    );
  }
}

String getUserModeText(UserMode? userMode) {
  switch (userMode) {
    case UserMode.driver:
      return 'Водитель';
    case UserMode.owner:
      return 'Бизнес';
    default:
      return 'Клиент';
  }
}
