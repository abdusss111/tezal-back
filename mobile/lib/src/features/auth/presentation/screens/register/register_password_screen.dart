import 'package:eqshare_mobile/src/core/presentation/services/app_dialog_service.dart';
import 'package:eqshare_mobile/src/features/auth/data/models/user_model/user_model.dart';
import 'package:eqshare_mobile/src/core/presentation/widgets/app_primary_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../../core/data/services/storage/token_provider_service.dart';
import '../../../data/repositories/auth_repository_impl.dart';
import '../../../domain/use_cases/auth_use_case.dart';
import '../../auth.dart';

class RegisterPasswordScreen extends StatefulWidget {
  final User user;
  const RegisterPasswordScreen({super.key, required this.user});

  @override
  State<RegisterPasswordScreen> createState() => _RegisterPasswordScreenState();
}

class _RegisterPasswordScreenState extends State<RegisterPasswordScreen> {
  final AuthUseCase authUseCase = AuthUseCase(
    AuthRepositoryImpl(),
    TokenService(),
  );
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<RegisterPasswordController>(
      create: (_) => RegisterPasswordController(authUseCase),
      child: Consumer<RegisterPasswordController>(
          builder: (context, controller, __) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Регистрация'),
            leading: IconButton(
              onPressed: () => context.pop(),
              icon: const Icon(Icons.arrow_back_ios_new),
            ),
          ),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: SingleChildScrollView(
                child: Form(
                  key: controller.formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const FormRichText(text: 'Пароль'),
                      const SizedBox(height: 5),
                      PasswordFormField(
                        controller: controller,
                        obscureText: controller.isShowPassword,
                      ),
                      const SizedBox(height: 10),
                      const FormRichText(text: 'Повторите пароль'),
                      const SizedBox(height: 5),
                      PasswordFormField(
                        controller: controller,
                        isPasswordRepeat: true,
                        obscureText: controller.isShowRepeatPassword,
                      ),
                      const SizedBox(height: 44),
                      AppPrimaryButtonWidget(
                        onPressed: () {
                          if (controller.passwordRepeatController.text ==
                              controller.passwordController.text) {
                            return controller.register(context, widget.user);
                          } else {
                            AppDialogService.showNotValidFormDialog(
                                context, 'Пароли не совпадают');
                          }
                        },
                        textColor: Colors.white,
                        text: 'Далее',
                        icon: Icons.arrow_forward_ios_outlined,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
