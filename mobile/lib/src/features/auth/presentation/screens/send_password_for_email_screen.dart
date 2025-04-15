
import 'package:eqshare_mobile/src/features/ad/presentation/widgets/app_primary_ad_text_field.dart';
import 'package:eqshare_mobile/src/features/auth/presentation/auth.dart';
import 'package:flutter/material.dart';

class SendPasswordForEmailScreen extends StatefulWidget {
  const SendPasswordForEmailScreen({super.key});

  @override
  State<SendPasswordForEmailScreen> createState() =>
      _RegisterPhoneScreenState();
}

class _RegisterPhoneScreenState extends State<SendPasswordForEmailScreen> {
  final textEditingController = TextEditingController();
  final controller = RegisterPhoneController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Восстановление пароля'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Form(
          key: controller.formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
               Text(
                'Введите электронную почту',
                style: Theme.of(context).textTheme.displayLarge,
                textAlign: TextAlign.center,
              ),
               Text(
                'Вам придёт значный код для\nподтверждения номера',
                style: Theme.of(context).textTheme.displayLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 44),
              const Align(
                alignment: Alignment.centerLeft,
                child: FormRichText(text: 'Электронная почта'),
              ),
              const SizedBox(height: 5),
              AppPrimaryTextField(
                hintText: 'Электронная почта',
                controller: textEditingController,
              ),
              const SizedBox(height: 44),
              RegisterButton(
                  controller: controller,
                  fromFirstPaage: false,
                  fromForgotPasswordPages: true,
                  ignoring: false),
            ],
          ),
        ),
      ),
    );
  }
}
