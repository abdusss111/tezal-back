import 'package:flutter/material.dart';

class AdAlertDialogForPop extends StatelessWidget {
  final String? alertDialogTitle;
  final void Function()? onPressedYes;
  final void Function()? onPressedNo;

  const AdAlertDialogForPop(
      {super.key, this.alertDialogTitle, this.onPressedYes, this.onPressedNo});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(alertDialogTitle ?? 'Точно хотите покинуть страницу?',
          style: Theme.of(context).textTheme.bodyLarge),
      actions: [
        TextButton(
          onPressed: onPressedNo ??
              () {
                Navigator.pop(context);
              },
          child: const Text('Назад'),
        ),
        TextButton(
          onPressed: onPressedYes ??
              () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
          child: const Text('Да'),
        ),
      ],
    );
  }
}
