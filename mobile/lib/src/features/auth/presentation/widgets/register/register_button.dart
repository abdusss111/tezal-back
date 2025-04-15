import 'package:eqshare_mobile/src/core/presentation/services/app_dialog_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/presentation/routing/app_route.dart';
import '../../../../../core/presentation/widgets/app_primary_button.dart';
import '../../controllers/register/register_phone_controller.dart';
import '../../../data/models/models.dart';

class RegisterButton extends StatelessWidget {
  const RegisterButton(
      {super.key,
      required this.controller,
      this.ignoring = true,
      required this.fromFirstPaage,
      this.fromForgotEmailPasswordPages = false,
      this.fromForgotPasswordPages = false,
      this.pushToCreateNewPassword = false});

  final bool ignoring;
  final bool fromFirstPaage;
  final bool pushToCreateNewPassword;
  final bool fromForgotPasswordPages;
  final bool fromForgotEmailPasswordPages;

  final RegisterPhoneController controller;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: ignoring,
      child: AppPrimaryButtonWidget(
        backgroundColor: ignoring ? Colors.orange.shade100 : Colors.orange,
        onPressed: () {
          if (fromForgotEmailPasswordPages) {
            context.pushNamed(AppRouteNames.forgotPasswordEnterSendCode,
                extra: User(
                    phoneNumber: controller.phoneController.text, cityId: 0));
          }
          if (fromForgotPasswordPages) {
            if (pushToCreateNewPassword) {
              AppDialogService.showNotValidFormDialog(
                  context, 'Пароли не совпадают');
              context.goNamed(AppRouteNames.navigation, extra: {'id': 4});
            }
            if (controller.phoneController.text.length == 13) {
              context.pushNamed(AppRouteNames.forgotPasswordEnterSendCode,
                  extra: controller.phoneController.text);
            }
          } else {
            if (!fromFirstPaage) {
              _navigateToCitySelectScreen(context);
            } else {
              if (controller.formKey.currentState!.validate() &&
                  controller.phoneController.text.length == 13) {
                navigateForVefificatio(context);
              }
            }
          }
        },
        text: 'Далее',
        textColor: Colors.white,
        icon: Icons.arrow_forward_ios_outlined,
      ),
    );
  }

  void navigateForVefificatio(BuildContext context) {
    context.pushNamed(AppRouteNames.vefirication,
        extra:
            '+7${controller.phoneController.text.replaceAll(RegExp(r'\D'), '')}');
  }

  void _navigateToCitySelectScreen(BuildContext context) {
    // Navigator.pushNamed(
    //   context,
    //   AppRouteNames.citySelect,
    //   arguments: User(
    //     phoneNumber:
    //         '+7${controller.phoneController.text.replaceAll(RegExp(r'\D'), '')}',
    //     cityId: -1,
    //   ),
    // );

    context.pushNamed(AppRouteNames.citySelect,
        extra: User(
          phoneNumber:
              '+7${controller.phoneController.text.replaceAll(RegExp(r'\D'), '')}',
          cityId: -1,
        ));
  }
}
