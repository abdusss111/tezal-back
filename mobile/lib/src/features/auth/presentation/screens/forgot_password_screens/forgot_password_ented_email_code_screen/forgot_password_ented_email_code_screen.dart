import 'package:eqshare_mobile/src/core/data/services/storage/token_provider_service.dart';
import 'package:eqshare_mobile/src/core/presentation/routing/app_route.dart';
import 'package:eqshare_mobile/src/core/presentation/widgets/app_primary_button.dart';
import 'package:eqshare_mobile/src/core/presentation/widgets/app_snack_bar.dart';
import 'package:eqshare_mobile/src/core/res/theme/app_colors.dart';
import 'package:eqshare_mobile/src/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:eqshare_mobile/src/features/auth/domain/use_cases/auth_use_case.dart';
import 'package:eqshare_mobile/src/features/auth/presentation/screens/forgot_password_screens/forgot_password_ented_email_code_screen/forgot_password_ented_email_code_screen_controller.dart';
import 'package:eqshare_mobile/src/features/auth/presentation/widgets/app_primary_text_field_ali.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:provider/provider.dart';

class ForgotPasswordEntedEmailCodeScreen extends StatefulWidget {
  const ForgotPasswordEntedEmailCodeScreen({super.key});

  @override
  State<ForgotPasswordEntedEmailCodeScreen> createState() =>
      _ForgotPasswordEntedEmailCodeScreenState();
}

class _ForgotPasswordEntedEmailCodeScreenState
    extends State<ForgotPasswordEntedEmailCodeScreen> {
  final AuthUseCase authUseCase = AuthUseCase(
    AuthRepositoryImpl(),
    TokenService(),
  );

  final formKey = GlobalKey<FormState>();
  final textEditingController = TextEditingController();
  final passwordEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Восстановление пароля'),
      ),
      body: Consumer<ForgotPasswordEntedEmailCodeScreenController>(
          builder: (context, controller, child) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppPrimaryTextFieldAli(
                  controller: textEditingController,
                  keyboardType: TextInputType.emailAddress,
                  hintText: 'Почта',
                  validator: controller.validatorEmail,
                  onSubmitted: controller.setIsEmailValid,
                  onEditingComplete: () =>
                      controller.setIsEmailValid(textEditingController.text),
                  suffixWidget: Container(
                    decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(12),
                            bottomRight: Radius.circular(12))),
                    child: TextButton(
                      onPressed: () async {
                        final isValid = formKey.currentState?.validate();
                        if (isValid == true) {
                          await controller
                              .sendCodeForThisEmail(textEditingController.text)
                              .then((value) {
                            if (value.isNotEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                AppSnackBar.showErrorSnackBar(value),
                              );
                              controller.setErrorMessage('');
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  AppSnackBar.showErrorSnackBar(
                                      'На вашу почту отправлено временный пароль, проверьте',
                                      duration: const Duration(seconds: 3)));
                            }
                          });
                        }
                      },
                      child: Text(
                        'Отправить',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.appPrimaryColor,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                ),
                if (controller.isSendSuccess)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: AppPrimaryTextFieldAli(
                      hintText: 'Временный пароль',
                      controller: passwordEditingController,
                    ),
                  ),
                if (controller.isSendSuccess)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: AppPrimaryButtonWidget(
                        onPressed: () {
                          authUseCase.authenticateWithEmail(
                              email: textEditingController.text,
                              password: passwordEditingController.text,
                              context: context,
                              onSuccess: () {
                                context.pushReplacementNamed(
                                    AppRouteNames.navigation,
                                    extra: {'id': 4});
                              },
                              onError: (error) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    AppSnackBar.showErrorSnackBar(
                                        'Неправильный пароль',
                                        duration: const Duration(seconds: 2)));
                              },
                              onLoading: () {},
                              onComplete: () {});
                        },
                        textColor: Colors.white,
                        text: 'Войти'),
                  ),
                const SizedBox(height: 3),
              ],
            ),
          ),
        );
      }),
    );
  }
}
