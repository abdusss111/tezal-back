import 'package:eqshare_mobile/src/core/presentation/routing/app_route.dart';
import 'package:eqshare_mobile/src/core/presentation/widgets/app_circular_progress_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class AppDialogService {
  static Future<dynamic> showSuccessDialog(
    BuildContext context, {
    required String title,
    required Function() onPressed,
    required String buttonText,
  }) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      useRootNavigator: false,
      builder: (context) => AlertDialog(
        title: Text(
          title,
          style: Theme.of(context)
              .textTheme
              .displayMedium!
              .copyWith(fontWeight: FontWeight.normal),
        ),
        icon: SvgPicture.asset('assets/svgs/success.svg'),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () => onPressed(),
              child: Text(
                buttonText,
                style: Theme.of(context)
                    .textTheme
                    .displaySmall!
                    .copyWith(color: Theme.of(context).primaryColor),
              ),
            ),
            GestureDetector(
              onTap: () {
                context.goNamed(
                  AppRouteNames.navigation,
                  extra: {'index': '0'},
                );
              },
              child: Text(
                'Главная',
                style: Theme.of(context)
                    .textTheme
                    .displaySmall!
                    .copyWith(color: Theme.of(context).primaryColor),
              ),
            ),
            // TextButton(
            //   onPressed: () {
            //     print('profile button pressed');
            //     // Navigator.pushNamedAndRemoveUntil(
            //     //   context,
            //     //   AppRouteNames.navigation,
            //     //   (route) => false,
            //     // );
            //     context
            //         .pushReplacementNamed('${AppRouteNames.navigation}', extra: {'index': '0'});
            //     // GoRouter.of(context).go('/${AppRouteNames.navigation}');
            //   },
            //   child: Text(
            //     'Главная',
            //     style: AppFonts.s17w500
            //         .copyWith(color: Theme.of(context).primaryColor),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  static Future<dynamic> showNotValidFormDialog(
    BuildContext context, [
    String? dialogText,
  ]) {
    return showCupertinoDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          dialogText ?? 'Необходимо заполнить все обязательные поля',
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(fontWeight: FontWeight.normal),
        ),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed: () {
                // Navigator.pop(context);
                context.pop();
              },
              child: Text(
                'OK',
                style: Theme.of(context)
                    .textTheme
                    .displaySmall!
                    .copyWith(color: Theme.of(context).primaryColor),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Future<dynamic> showActionDialog(
    BuildContext context, {
    required String title,
    required Function() onPressed,
  }) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          textAlign: TextAlign.center,
          title,
          style: Theme.of(context)
              .textTheme
              .displayMedium!
              .copyWith(fontWeight: FontWeight.normal),
        ),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed: onPressed,
              child: Text(
                'Подтвердить',
                style: Theme.of(context)
                    .textTheme
                    .displaySmall!
                    .copyWith(color: Theme.of(context).primaryColor),
              ),
            ),
            TextButton(
              onPressed: () {
                context.pop();
                // Navigator.pop(context);
              },
              child: Text(
                'Отмена',
                style: Theme.of(context)
                    .textTheme
                    .displaySmall!
                    .copyWith(color: Theme.of(context).primaryColor),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Future<dynamic> showLoadingDialog(BuildContext context) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (_) => const AppCircularProgressIndicator(),
    );
  }
}
