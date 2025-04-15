import 'package:flutter/material.dart';

class CheckBoxForAccessEndDatetime extends StatelessWidget {
  final bool checkBoxValue;
  final void Function(bool?)? onChanged;
  const CheckBoxForAccessEndDatetime(
      {super.key, required this.checkBoxValue, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      checkColor: Colors.white,
      contentPadding: EdgeInsets.zero,
      title: const Text('Время завершения работы'),
      value: checkBoxValue,
      onChanged: onChanged,
      controlAffinity: ListTileControlAffinity.leading,
    );
  }
}
