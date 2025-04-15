import 'package:flutter/material.dart';
import 'package:eqshare_mobile/src/core/presentation/widgets/app_primary_button.dart';

class AdEditButton extends StatelessWidget {
  final void Function() onPressed;
  const AdEditButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: AppPrimaryButtonWidget(
        borderColor: Colors.black,
        backgroundColor: Colors.grey.shade100,
        onPressed: onPressed,
        text: 'Редактировать',
      ),
    );
  }
}
