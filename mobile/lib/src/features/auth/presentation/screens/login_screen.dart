import 'package:eqshare_mobile/app/app_change_notifier.dart';
import 'package:eqshare_mobile/src/core/presentation/routing/app_route.dart';
import 'package:eqshare_mobile/src/core/presentation/widgets/app_primary_button.dart';
import 'package:eqshare_mobile/src/core/presentation/widgets/app_snack_bar.dart';
import 'package:eqshare_mobile/src/features/auth/presentation/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../data/repositories/auth_repository_impl.dart';
import '../../../../core/data/services/storage/token_provider_service.dart';
import '../../domain/use_cases/auth_use_case.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthUseCase authUseCase = AuthUseCase(
    AuthRepositoryImpl(),
    TokenService(),
  );

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<LoginController>(
      create: (_) => LoginController(authUseCase),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Авторизация'),
          leading: BackButton(
            onPressed: () {
              context.go('/${AppRouteNames.navigation}', extra: {'index': '4'});
            },
          ),
        ),
        body: Consumer<LoginController>(
          builder: (context, controller, _) {
            if (AppChangeNotifier().errorMessage != null &&
                AppChangeNotifier().errorMessage!.isNotEmpty) {
              SchedulerBinding.instance.addPostFrameCallback((_) {
                ScaffoldMessenger.of(context).showSnackBar(
                  AppSnackBar.showErrorSnackBar(
                      '${AppChangeNotifier().errorMessage}'),
                );
                AppChangeNotifier().setErrorMessage('');
              });
            }
            return Form(
              key: controller.formKey,
              child: Center(
                child: ListView(
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(20.0),
                  children: [
                    Text(
                      'Введите номер \nтелефона и пароль',
                      style: Theme.of(context)
                          .textTheme
                          .labelLarge
                          ?.copyWith(fontSize: 22),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 44),
                    const FormRichText(text: 'Номер телефона'),
                    const SizedBox(height: 5),
                    PhoneNumberField(controller: controller.phoneController),
                    const SizedBox(height: 10),
                    const FormRichText(text: 'Пароль'),
                    const SizedBox(height: 5),
                    PasswordFormField(
                      controller: controller,
                      obscureText: controller.isShowPassword,
                    ),
                    const SizedBox(height: 6),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: TextButton(
                        onPressed: () {
                          context.pushNamed(
                              AppRouteNames.forgotPasswordPickWayScreen);
                        },
                        child: const Text('Забыли пароль?'),
                      ),
                    ),
                    const SizedBox(height: 30),
                    AppPrimaryButtonWidget(
                      onPressed: () => controller.authenticate(context),
                      text: 'Войти',
                      textStyle: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.copyWith(color: Colors.white),
                      icon: Icons.arrow_forward_ios_outlined,
                    ),
                    const SizedBox(height: 44),
                    const SuggestionSignUp(),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
