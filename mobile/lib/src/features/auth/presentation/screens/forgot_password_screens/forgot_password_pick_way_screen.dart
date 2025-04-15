import 'package:eqshare_mobile/src/core/presentation/routing/app_route.dart';
import 'package:eqshare_mobile/src/core/presentation/widgets/app_primary_button.dart';
import 'package:eqshare_mobile/src/core/res/theme/app_fonts.dart';
import 'package:eqshare_mobile/src/features/auth/presentation/auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ForgotPasswordPickWayScreen extends StatefulWidget {
  const ForgotPasswordPickWayScreen({super.key});

  @override
  State<ForgotPasswordPickWayScreen> createState() =>
      _ForgotPasswordPickWayScreenState();
}

class _ForgotPasswordPickWayScreenState
    extends State<ForgotPasswordPickWayScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Восстановление пароля'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Выберите метод',
              style: Theme.of(context)
                  .textTheme
                  .displayLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(4),
              child: AppPrimaryButtonWidget(
                  buttonType: ButtonType.filled,
                  onPressed: () {
                    context.pushNamed(
                        AppRouteNames.forgotPasswordEnterPhoneNumber);
                  },
                  textStyle: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(color: Colors.white),
                  text: 'Номер телефона'),
            ),
            Padding(
              padding: const EdgeInsets.all(4),
              child: AppPrimaryButtonWidget(
                  buttonType: ButtonType.filled,
                  onPressed: () {
                    context.pushNamed(
                        AppRouteNames.forgotPasswordEnterSendCodeFromEmail);
                  },
                  textStyle: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(color: Colors.white),
                  text: 'Почта'),
            ),
          ],
        ),
      ),
    );
  }
}
