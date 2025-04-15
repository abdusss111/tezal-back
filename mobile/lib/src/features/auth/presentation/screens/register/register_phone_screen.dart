import 'package:eqshare_mobile/src/core/presentation/routing/app_route.dart';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../auth.dart';

class RegisterPhoneScreen extends StatefulWidget {
  const RegisterPhoneScreen({super.key});

  @override
  State<RegisterPhoneScreen> createState() => _RegisterPhoneScreenState();
}

class _RegisterPhoneScreenState extends State<RegisterPhoneScreen> {
  final controller = RegisterPhoneController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Регистрация'),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Consumer<RegisterPhoneController>(
              builder: (context, controller, child) {
            return Form(
              key: controller.formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Введите номер\nмобильного телефона',
                    style: Theme.of(context)
                        .textTheme
                        .labelLarge
                        ?.copyWith(fontSize: 22),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    'Вам придёт 4 значный код для\nподтверждения номера',
                    style: Theme.of(context)
                        .textTheme
                        .labelLarge
                        ?.copyWith(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 44),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: FormRichText(text: 'Номер телефона'),
                  ),
                  const SizedBox(height: 5),
                  PhoneNumberField(controller: controller.phoneController),
                  const SizedBox(height: 14),
                  if (false)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text('Я согласен с условиями'),
                              GestureDetector(
                                  onTap: () {
                                    context
                                        .pushNamed(AppRouteNames.privacyPolicy);
                                  },
                                  child: Text(
                                      'Политикой данных и Условиями использование приложение',
                                      maxLines: 2,
                                      textAlign: TextAlign.center,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(color: Colors.orange))),
                            ],
                          ),
                        ),
                        Checkbox(
                            value: !(controller.isIgnoring),
                            onChanged: (value) {
                              controller.setisIgnoring();
                            }),
                      ],
                    ),
                  const SizedBox(height: 25),
                  RegisterButton(
                      controller: controller,
                      fromFirstPaage: true,
                      ignoring: false)
                ],
              ),
            );
          }),
        ));
  }
}
