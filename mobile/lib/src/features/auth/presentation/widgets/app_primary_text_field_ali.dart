import 'package:flutter/material.dart';

class AppPrimaryTextFieldAli extends StatelessWidget {
  const AppPrimaryTextFieldAli({
    super.key,
    required this.controller,
    this.maxLines,
    required this.hintText,
    this.maxLength,
    this.onSubmitted,
    this.onEditingComplete,
    this.keyboardType,
    this.suffixWidget,
    this.readOnly, this.validator,
  });

  final TextEditingController controller;
  final String hintText;
  final int? maxLines;
  final int? maxLength;
  final void Function(String)? onSubmitted;
  final void Function()? onEditingComplete;
  final TextInputType? keyboardType;
  final Widget? suffixWidget;
  final bool? readOnly;
 final String? Function(String?)? validator;

  OutlineInputBorder circulBorder(BuildContext context) {
    return OutlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        borderSide:
            BorderSide(width: 1, color: Theme.of(context).primaryColor));
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validator,
      maxLength: maxLength,
      maxLines: maxLines,
      readOnly: readOnly ?? false,
      controller: controller,
      onSaved: (value) {
        if (value != null && onSubmitted != null) {
          onSubmitted!(value);
        }
      },
      keyboardType: keyboardType,
      onEditingComplete: onEditingComplete,
      decoration: InputDecoration(
        enabledBorder: circulBorder(context),
        focusedBorder: circulBorder(context),
        border: circulBorder(context),
        hintText: hintText,
        suffixIconConstraints: BoxConstraints.tight(const Size(100, 52)),
        suffixIcon: Padding(
            padding: const EdgeInsets.only(right: 1),
            child: suffixWidget ?? const SizedBox()),
        hintStyle: Theme.of(context).textTheme.bodyLarge,
      ),
    );
  }
}
