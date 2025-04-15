import 'package:eqshare_mobile/src/core/res/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class PhoneNumberField extends StatelessWidget {
  const PhoneNumberField({
    super.key,
    required this.controller,
    this.onlyReading = false,
    this.onSubmitted,
    this.valueTextStyle,
  });

  final TextEditingController controller;
  final bool onlyReading;
  final TextStyle? valueTextStyle;
  final void Function(String)? onSubmitted;

  bool validatePhoneNumber(String value) {
    if (value.isEmpty) {
      return false;
    }
    final data = value.replaceAll(RegExp(r'\D'), '').length == 10;
    return data;
  }

  @override
  Widget build(BuildContext context) {
    final maskFormatter = MaskTextInputFormatter(
      mask: '###)###-##-##',
      filter: {'#': RegExp(r'[0-9]')},
      type: MaskAutoCompletionType.lazy,
    );

    return TextFormField(
      maxLength: 16,
      readOnly: onlyReading,
      style: valueTextStyle ??
          const TextStyle(fontSize: 16.0, fontWeight: FontWeight.normal),
      keyboardType: TextInputType.phone,
      inputFormatters: [maskFormatter],
      controller: controller,
      onChanged: (value) {
        // final data = validatePhoneNumber(value);
        // if (data) {
        //   if (onSubmitted != null) {
        //     onSubmitted!(controller.text);
        //   }
        // }
      },
      autofocus: false,
      onEditingComplete: () {
        if (onSubmitted != null) {
          onSubmitted!(controller.text);
        }
      },
      onSaved: (value) {
        if (onSubmitted != null) {
          onSubmitted!(controller.text);
        }
      },
      onTapOutside: (reason) {
        if (onSubmitted != null) {
          onSubmitted!(controller.text);
        }
      },
      decoration: InputDecoration(
        prefixIcon: Text('+7(',
            style: valueTextStyle ??
                const TextStyle(fontSize: 16.0, fontWeight: FontWeight.normal)),
        prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
        counterText: '',
        fillColor: AppColors.fieldBgColor,
        filled: false,
        hintText: '__)__-__-__',
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Colors.transparent,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Colors.transparent,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Colors.transparent,
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Colors.transparent,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Colors.transparent,
          ),
        ),
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Пожалуйста введите номер телефона';
        } else if (value.length < 13) {
          return 'Пожалуйста введите правильный номер телефона';
        }
        return null;
      },
    );
  }
}
