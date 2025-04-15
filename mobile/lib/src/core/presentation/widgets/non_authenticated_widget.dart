import 'package:eqshare_mobile/src/core/presentation/routing/app_route.dart';
import 'package:eqshare_mobile/src/core/presentation/widgets/app_primary_button.dart';
import 'package:eqshare_mobile/src/core/res/theme/app_colors.dart';
import 'package:eqshare_mobile/src/features/main/profile/profile_page/profile_controller.dart';
import 'package:eqshare_mobile/src/features/main/profile/profile_page/widgets/privacy_policy_item.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NonAuthenticatedWidget extends StatelessWidget {
  const NonAuthenticatedWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 18.0, vertical: 28.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Вход или регистрация',
                  style: Theme.of(context)
                      .textTheme
                      .labelLarge
                      ?.copyWith(fontWeight: FontWeight.bold, fontSize: 25),
                ),
                const SizedBox(height: 8),
                Text(
                    'Добавляйте свои объявления о спецтехнике и нанимайте специалистов. Войдите, чтобы начать 🚀🔧',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.normal, fontSize: 18)),
                const SizedBox(height: 10),
                AppPrimaryButtonWidget(
                  onPressed: () async {
                    context.replaceNamed(AppRouteNames.login);
                  },
                  text: 'Войти',
                  textStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                  backgroundColor: AppColors.appPrimaryColor,
                  icon: Icons.arrow_forward_ios_outlined,
                ),
                const SizedBox(
                  height: 30,
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 6, vertical: 10),
            child: PrivacyPolicyItem(privacy_policy: UserMode.guest),
          )
        ],
      ),
    );
  }
}
