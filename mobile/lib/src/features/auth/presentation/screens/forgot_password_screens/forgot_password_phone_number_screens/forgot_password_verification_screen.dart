import 'package:dio/dio.dart';
import 'package:eqshare_mobile/src/core/presentation/widgets/app_primary_button.dart';
import 'package:eqshare_mobile/src/core/presentation/widgets/app_snack_bar.dart';
import 'package:eqshare_mobile/src/features/auth/presentation/auth.dart';
import 'package:eqshare_mobile/src/features/auth/presentation/screens/forgot_password_screens/forgot_password_phone_number_screens/forget_password_controller.dart';
import 'package:eqshare_mobile/src/features/auth/presentation/widgets/register/password_text_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';

class ForgotPasswordVerificationScreen extends StatefulWidget {
  final String phoneNumber;
  const ForgotPasswordVerificationScreen(
      {super.key, required this.phoneNumber});

  @override
  State<ForgotPasswordVerificationScreen> createState() =>
      _RegisterPhoneScreenState();
}

class _RegisterPhoneScreenState
    extends State<ForgotPasswordVerificationScreen> {
  final dio = Dio();
  final TextEditingController passwordEditingController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    final contl = Provider.of<ForgetPasswordController>(context, listen: false)
      ..phoneNumberTextEditingController.text = widget.phoneNumber;
    contl.sendCode(widget.phoneNumber).then((onValue) {
      // if (onValue) {
        ScaffoldMessenger.of(context).showSnackBar(
            AppSnackBar.showErrorSnackBar(
                'Вам отправлено сообщение на указанный номер'));
        setState(() {
          wasSended = true;
        });
      // }
    });
  }

  late final Future<bool> sendCode;
  bool wasSended = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Верификация'),
      ),
      body: Consumer<ForgetPasswordController>(
          builder: (context, controller, child) {
        return Builder(builder: (context) {
          SchedulerBinding.instance.addPostFrameCallback((_) {
            if (controller.errorMessage.isNotEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                AppSnackBar.showErrorSnackBar(controller.errorMessage),
              );
              controller.setErrorMessage('');
            }
          });
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Form(
              key: controller.formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Введите временный пароль',
                      style: Theme.of(context)
                          .textTheme
                          .labelLarge
                          ?.copyWith(fontSize: 22),
                      textAlign: TextAlign.center),
                  PhoneNumberField(
                      onlyReading: true,
                      valueTextStyle: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.copyWith(fontWeight: FontWeight.w500),
                      controller: controller.phoneNumberTextEditingController),
                  const SizedBox(height: 4),
                  PasswordTextController(
                    passwordController: passwordEditingController,
                    obscureText: controller.obscureText,
                    obsureTextonpressed: controller.setObsureText,
                    onEdited: (value) {},
                  ),
                  const SizedBox(height: 4),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (wasSended)
                          StreamBuilder(
                            stream: Stream.periodic(
                                    const Duration(seconds: 1), (tick) => tick)
                                .take(61), // Ограничим поток до 60 тиков
                            builder: (context, snapshot) {
                              int remainingSeconds = 60 -
                                  (snapshot.data ??
                                      0); // Количество оставшихся секунд

                              // Убедимся, что значение отображается с двумя цифрами, когда меньше 10
                              String displaySeconds = remainingSeconds > 9
                                  ? '$remainingSeconds'
                                  : '0$remainingSeconds';

                              if (remainingSeconds == 0) {
                                WidgetsBinding.instance
                                    .addPostFrameCallback((_) {
                                  setState(() {
                                    wasSended = false;
                                  });
                                });
                              }
                              return Text(
                                '00:$displaySeconds',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(fontWeight: FontWeight.w300),
                              );
                            },
                          ),
                        IgnorePointer(
                          ignoring: wasSended,
                          child: TextButton(
                              onPressed: () async {
                                await controller
                                    .sendCode(widget.phoneNumber)
                                    .then((value) {
                                  if (value) {
                                    if (value) {
                                      setState(() {
                                        wasSended = true;
                                      });
                                    }
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      AppSnackBar.showErrorSnackBar(
                                          'Отправлено'),
                                    );
                                  }
                                });
                              },
                              child: const Text('Отправить заново')),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 3),
                  AppPrimaryButtonWidget(
                    onPressed: () async {
                      await controller.authenticate(context,
                          newPassword: passwordEditingController.text,
                          phoneNumber: widget.phoneNumber);
                    },
                    text: 'Войти',
                    textStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                    icon: Icons.arrow_forward_ios_outlined,
                  )
                ],
              ),
            ),
          );
        });
      }),
    );
  }
}
