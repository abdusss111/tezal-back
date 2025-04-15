import 'package:eqshare_mobile/src/core/presentation/services/app_dialog_service.dart';
import 'package:eqshare_mobile/src/core/presentation/widgets/app_primary_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ApproveCreateAdButton extends StatelessWidget {
  final bool isValidForm;
  final Future Function() uploadAdClient;
  final String alternativeRoute;
  final String? buttonText;
  final Color? buttonTextColor;
  final String? showSuccessDialogTitleText;
  const ApproveCreateAdButton(
      {super.key,
      required this.isValidForm,
      required this.uploadAdClient,
      this.buttonTextColor,
      this.buttonText,
      this.showSuccessDialogTitleText,
      required this.alternativeRoute});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30),
      child: AppPrimaryButtonWidget(
        textColor: buttonTextColor,
        onPressed: () async {
          if (isValidForm) {
            AppDialogService.showLoadingDialog(context);
            final result = await uploadAdClient();
            if (!context.mounted) return;
            context.pop();
            if (result) {
              AppDialogService.showSuccessDialog(
                context,
                title: showSuccessDialogTitleText ??
                    'Ваше объявление успешно создано!',
                onPressed: () {
                  context.goNamed(alternativeRoute);
                },
                buttonText: 'Мои объявления',
              );
            } else {
              AppDialogService.showNotValidFormDialog(
                  context, 'Что-то пошло не так');
            }
          } else {
            AppDialogService.showNotValidFormDialog(context);
          }
        },
        text: buttonText ?? 'Сохранить объявление',
      ),
    );
  }
}
