import 'package:eqshare_mobile/src/core/res/theme/app_dimensions.dart';

import 'package:flutter/material.dart';

class AdTextInformationFromUser extends StatelessWidget {
  const AdTextInformationFromUser(
      {super.key,
      required this.controller,
      this.maxLines,
      required this.hintText,
      this.maxLength,
      this.textInputType,
      required this.onChanged,
      this.initialValue});

  final TextEditingController controller;
  final String hintText;
  final int? maxLines;
  final int? maxLength;
  final String? initialValue;
  final TextInputType? textInputType;

  final void Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    if (initialValue != null) {
      controller.text = initialValue!;
    }
    return TextFormField(
      maxLength: maxLength,
      maxLines: maxLines,
      // initialValue: initialValue,
      controller: controller,
      autofocus: false,
      keyboardType: textInputType,
      onChanged: onChanged,
      decoration: InputDecoration(
        contentPadding: AppDimensions.appPrimaryInputPadding,
        hintText: hintText,
        hintStyle: Theme.of(context).textTheme.bodyMedium,
      ),
    );
  }
}
