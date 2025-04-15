import 'package:flutter/material.dart';

abstract class PasswordController {
  TextEditingController get passwordController;
  TextEditingController? get passwordRepeatController;
  bool get isShowPassword;
  bool get isShowRepeatPassword;
  void setShowPassword(bool value);
  void setShowRepeatPassword(bool value);
}

class PasswordFormField<T extends PasswordController> extends StatelessWidget {
  final T controller;
  final bool isPasswordRepeat;
  final bool obscureText;

  const PasswordFormField({
    super.key,
    required this.controller,
    this.isPasswordRepeat = false,
    required this.obscureText,
  });

  final OutlineInputBorder _transparentInputBorder = const OutlineInputBorder(
    borderSide: BorderSide(color: Colors.transparent, width: 0.5),
  );

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLength: 18,
      keyboardType: TextInputType.text,
      controller: isPasswordRepeat
          ? controller.passwordRepeatController
          : controller.passwordController,
      obscureText: !isPasswordRepeat
          ? !controller.isShowPassword
          : !controller.isShowRepeatPassword,
      decoration: InputDecoration(
        counterText: '',
        hintText: '*******',
        suffixIcon: IconButton(
          icon: !isPasswordRepeat
              ? Icon(controller.isShowPassword
                  ? Icons.visibility_rounded
                  : Icons.visibility_off_outlined)
              : Icon(controller.isShowRepeatPassword
                  ? Icons.visibility_rounded
                  : Icons.visibility_off_outlined),
          onPressed: () => !isPasswordRepeat
              ? controller.setShowPassword(!controller.isShowPassword)
              : controller
                  .setShowRepeatPassword(!controller.isShowRepeatPassword),
        ),
        focusedBorder: _transparentInputBorder,
        focusedErrorBorder: _transparentInputBorder,
        errorBorder: _transparentInputBorder,
        border: _transparentInputBorder,
        enabledBorder: _transparentInputBorder,
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Пожалуйста введите пароль';
        }
        return null;
      },
    );
  }
}
