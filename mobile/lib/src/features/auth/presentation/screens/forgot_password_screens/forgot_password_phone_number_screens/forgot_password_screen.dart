import 'package:eqshare_mobile/src/core/presentation/routing/app_route.dart';
import 'package:eqshare_mobile/src/core/presentation/widgets/app_primary_button.dart';
import 'package:eqshare_mobile/src/features/auth/presentation/auth.dart';
import 'package:eqshare_mobile/src/features/auth/presentation/screens/forgot_password_screens/forgot_password_phone_number_screens/forget_password_controller.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _RegisterPhoneScreenState();
}

class _RegisterPhoneScreenState extends State<ForgotPasswordScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Восстановление пароля'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Consumer<ForgetPasswordController>(
            builder: (context, controller, child) {
          return Form(
            key: controller.formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Введите номер\nмобильного телефона',
                  style: Theme.of(context)
                      .textTheme
                      .labelLarge
                      ?.copyWith(fontSize: 22),
                  textAlign: TextAlign.center,
                ),
                Text(
                  'Вам придёт 4 значный код для\nподтверждения номера',
                  style: Theme.of(context)
                      .textTheme
                      .labelLarge
                      ?.copyWith(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 44),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: FormRichText(text: 'Номер телефона'),
                ),
                const SizedBox(height: 5),
                PhoneNumberField(
                  controller: controller.phoneNumberTextEditingController,
                  onSubmitted: controller.setPhoneNumber,
                ),
                const SizedBox(height: 44),
                AppPrimaryButtonWidget(
                  onPressed: () {
                    final data = controller.formKey.currentState?.validate();
                    if (data == true) {
                      context.pushNamed(
                          AppRouteNames.forgotPasswordEnterSendCode,
                          extra:
                              controller.phoneNumberTextEditingController.text);
                    }
                  },
                  textColor: Colors.white,
                  backgroundColor: Colors.orange,
                  text: 'Далее',
                  icon: Icons.arrow_forward_ios_outlined,
                )
              ],
            ),
          );
        }),
      ),
    );
  }
}
