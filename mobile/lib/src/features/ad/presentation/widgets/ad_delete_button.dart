import 'package:eqshare_mobile/src/core/presentation/services/app_dialog_service.dart';
import 'package:eqshare_mobile/src/core/presentation/widgets/app_primary_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AdDeleteButton extends StatelessWidget {
  final Future<void> Function() delete;
  final bool isExpanded;
  const AdDeleteButton(
      {super.key, required this.delete, this.isExpanded = true});

  @override
  Widget build(BuildContext context) {
    if (isExpanded) {
      return Expanded(
        child: deleteButton(context),
      );
    } else {
      return deleteButton(context);
    }
  }

  AppPrimaryButtonWidget deleteButton(BuildContext context) {
    return AppPrimaryButtonWidget(
      buttonType: ButtonType.filled,
      backgroundColor: Colors.red,
      textColor: Colors.black,
      onPressed: () {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Точно хотите удалить?'),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Нет')),
                  TextButton(
                      onPressed: () async {
                        AppDialogService.showLoadingDialog(context);

                        await delete();

                        if (context.mounted) {
                          Navigator.pop(context);
                          Navigator.pop(context);
                        }
                        if (context.mounted) {
                          context.pop();
                        }
                      },
                      child: const Text('Да')),
                ],
              );
            });
      },
      text: 'Удалить',
    );
  }
}
