import 'package:eqshare_mobile/src/core/presentation/services/app_dialog_service.dart';
import 'package:eqshare_mobile/src/core/presentation/widgets/app_primary_button.dart';
import 'package:eqshare_mobile/src/features/auth/presentation/widgets/register/password_text_controller.dart';
import 'package:eqshare_mobile/src/features/main/profile/change_or_update_password_screen/change_or_update_password_screen_controller.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class ChangeOrUpdatePasswordScreen extends StatefulWidget {
  const ChangeOrUpdatePasswordScreen({super.key});

  @override
  State<ChangeOrUpdatePasswordScreen> createState() =>
      _ChangeOrUpdatePasswordScreenState();
}

class _ChangeOrUpdatePasswordScreenState
    extends State<ChangeOrUpdatePasswordScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Изменить пароль'),
          centerTitle: true,
          leading: const BackButton()),
      body: Consumer<ChangeOrUpdatePasswordScreenController>(
        builder: (context, value, child) {
          return FutureBuilder(
              future: value.getUserDetail(),
              builder: (context, snapshot) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Form(
                      key: value.formKey,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: PasswordTextController(
                              hintText: "Новый пароль",
                              passwordController: value.passwordController,
                              obscureText: value.obsureMainPassword,
                              obsureTextonpressed: (obsure) {
                                value.changeObsureMainPassword();
                              },
                              onEdited: (password) {
                                value.changeNewPassword(password);
                              },
                            ),
                          ),
                          // Divider(),
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: PasswordTextController(
                              hintText: 'Повторите новый пароль',
                              passwordController:
                                  value.passwordRepaetController,
                              repeatPasswordController:
                                  value.passwordController,
                              obscureText: value.obsureRepaetPassword,
                              obsureTextonpressed: (obsure) {
                                value.changeObsureRepaetPassword();
                              },
                              onEdited: (password) {},
                            ),
                          ),
                          AppPrimaryButtonWidget(
                            onPressed: () async {
                              if (value.formKey.currentState!.validate()) {
                                AppDialogService.showLoadingDialog(context);
                                final result = await value.updatePassword();
                                if (result && context.mounted) {
                                  context.pop();
                                  value.clearAll();
                                  AppDialogService.showSuccessDialog(context,
                                      title: 'Успешно изменен',
                                      onPressed: () => context.pop(),
                                      buttonText: 'Назад');
                                } else {
                                  AppDialogService.showNotValidFormDialog(
                                      context, 'Повторите позже');
                                }
                              }
                            },
                            textColor: Colors.white,
                            text: 'Изменить',
                          ),
                        ],
                      )),
                );
              });
        },
      ),
    );
  }
}
