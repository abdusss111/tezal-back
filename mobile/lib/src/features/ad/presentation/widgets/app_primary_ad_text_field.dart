
import 'package:eqshare_mobile/src/core/res/theme/app_dimensions.dart';
import 'package:flutter/material.dart';


class AppPrimaryTextField extends StatelessWidget {
  const AppPrimaryTextField({
    super.key,
    required this.controller,
    this.maxLines,
    required this.hintText,
    this.maxLength,
    this.onSubmitted,
    this.onEditingComplete,
    this.keyboardType,
    this.prefixWidget,
  });

  final TextEditingController controller;
  final String hintText;
  final int? maxLines;
  final int? maxLength;
  final void Function(String)? onSubmitted;
  final void Function()? onEditingComplete;
  final TextInputType? keyboardType;
  final Widget? prefixWidget;

  @override
  Widget build(BuildContext context) {
    return TextField(
      maxLength: maxLength,
      maxLines: maxLines,
      controller: controller,
      onSubmitted: onSubmitted,
      keyboardType: keyboardType,
      onEditingComplete: onEditingComplete,
      decoration: InputDecoration(
        contentPadding: AppDimensions.appPrimaryInputPadding,
        isCollapsed: true,
        hintText: hintText,
        suffix: prefixWidget,
        hintStyle: Theme.of(context).textTheme.bodyMedium
      ),
    );
  }
}

