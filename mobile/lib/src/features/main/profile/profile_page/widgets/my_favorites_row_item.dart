import 'package:eqshare_mobile/src/core/presentation/routing/app_route.dart';
import 'package:eqshare_mobile/src/core/presentation/widgets/app_menu_row_widget.dart';
import 'package:eqshare_mobile/src/features/main/profile/profile_page/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MyFavoritesRowItem extends StatelessWidget {
  final ProfileController profileController;
  const MyFavoritesRowItem({
    super.key,
    required this.profileController,
  });

  @override
  Widget build(BuildContext context) {
    final userMode = profileController.appChangeNotifier.userMode;
    final isDriver = userMode == UserMode.driver;
    final isOwner = userMode == UserMode.owner;
    const menuText = 'Избранное';
    return AppMenuRowWidget(
      onTap: () {
        if (isDriver || isOwner) {
          context.pushNamed(AppRouteNames.favoriteAdsForDriverOrOwner);
        } else {
          context.pushNamed(AppRouteNames.favoriteAdsForClient);
          // Navigator.pushNamed(context, AppRouteNames.favoriteSM);
        }
      },
      menuRowData: const AppMenuRowData(
        text: menuText,
        icon: Icons.bookmark_outline_rounded,
      ),
    );
  }
}
