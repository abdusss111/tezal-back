import 'package:eqshare_mobile/src/core/presentation/routing/app_route.dart';
import 'package:eqshare_mobile/src/core/presentation/widgets/app_menu_row_widget.dart';
import 'package:eqshare_mobile/src/features/main/profile/profile_page/profile_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

class PrivacyPolicyItem extends StatelessWidget {
  final UserMode? privacy_policy;

  const PrivacyPolicyItem({
    super.key,
    required this.privacy_policy,
  });

  @override
  Widget build(BuildContext context) {
    final menuText = getMenuText(privacy_policy);
    return AppMenuRowWidget(
      onTap: () {
        // Navigator.pushNamed(context, AppRouteNames.privacyPolicy);
        context.pushNamed(AppRouteNames.privacyPolicy);
      },
      menuRowData: AppMenuRowData(
        text: menuText,
        icon: CupertinoIcons.info,
      ),
    );
  }

  String getMenuText(UserMode? userMode) {
    return 'Политика конфиденциальности';
  }
}
