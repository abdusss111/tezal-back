import 'package:eqshare_mobile/src/core/res/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:pin_input_text_field/pin_input_text_field.dart';

class AppNumberFormField extends StatelessWidget {
  const AppNumberFormField({
    super.key,
    required this.otpController,
    required this.pinPutFocusNode,
    required this.isPinValid,
    required this.onChanged,
  });

  final TextEditingController otpController;
  final FocusNode pinPutFocusNode;
  final bool isPinValid;
  final Function(String) onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 54,
          ),
          child: PinInputTextField(
            // pinLength: 4,
            controller: otpController,
            focusNode: pinPutFocusNode,
            decoration: UnderlineDecoration(
              textStyle:Theme.of(context).textTheme.displaySmall,
              colorBuilder: const FixedColorBuilder(
                AppColors.appPrimaryColor,
              ),
              obscureStyle: ObscureStyle(
                isTextObscure: false,
              ),
            ),
            autoFocus: true,
            textInputAction: TextInputAction.done,
            keyboardType: TextInputType.number,
            onChanged: onChanged,
          ),
        ),
        const SizedBox(height: 10),
        isPinValid
            ? const Text(
                '',
              )
            :  Text(
                'Пожалуйста введите правильный номер',
                style: Theme.of(context).textTheme.displaySmall
              ),
      ],
    );
  }
}
