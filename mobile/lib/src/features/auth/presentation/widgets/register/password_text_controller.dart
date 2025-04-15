import 'package:flutter/material.dart';

class PasswordTextController extends StatelessWidget {
  final TextEditingController passwordController;
  final TextEditingController? repeatPasswordController;
  final bool obscureText;
  final TextStyle? valueTextStyle;
  final void Function(bool) obsureTextonpressed;
  final void Function(String) onEdited;
  final String hintText; // Customizable hint text

  const PasswordTextController({
    super.key,
    required this.passwordController,
    required this.obscureText,
    required this.obsureTextonpressed,
    this.repeatPasswordController,
    required this.onEdited,
    this.valueTextStyle,
    this.hintText = '*******', // Default hint text
  });

  final OutlineInputBorder _transparentInputBorder = const OutlineInputBorder(
    borderSide: BorderSide(color: Colors.transparent, width: 0.5),
  );

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLength: 18,
      keyboardType: TextInputType.text,
      controller: passwordController,
      obscureText: obscureText,
      onChanged: onEdited,
      style: valueTextStyle,
      decoration: InputDecoration(
        counterText: '',
        hintText: hintText, // Use the custom hint text
        suffixIcon: IconButton(
          icon: obscureText
              ? const Icon(Icons.visibility_rounded)
              : const Icon(Icons.visibility_off_outlined),
          onPressed: () {
            obsureTextonpressed(obscureText);
          },
        ),
        focusedBorder: _transparentInputBorder,
        focusedErrorBorder: _transparentInputBorder,
        errorBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red, width: 0.5),
        ),
        border: _transparentInputBorder,
        enabledBorder: _transparentInputBorder,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Пожалуйста введите пароль';
        }
        if (repeatPasswordController != null &&
            repeatPasswordController!.text.isNotEmpty) {
          if (repeatPasswordController!.text != passwordController.text) {
            return 'Пароли не совподают';
          }
        }
        return null;
      },
    );
  }
}
