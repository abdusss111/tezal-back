import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:eqshare_mobile/src/core/presentation/routing/app_route.dart';
import 'package:eqshare_mobile/src/core/presentation/services/app_dialog_service.dart';
import 'package:eqshare_mobile/src/core/presentation/widgets/app_snack_bar.dart';
import 'package:eqshare_mobile/src/core/res/api_endpoints/api_endpoints.dart';
import 'package:eqshare_mobile/src/global_widgets/global_future_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_verification_code/flutter_verification_code.dart';
import 'package:go_router/go_router.dart';
import '../../../data/models/models.dart';

import 'package:provider/provider.dart';

import '../../auth.dart';

class VerificationPhoneNumberScreen extends StatefulWidget {
  final String phoneNumber;
  const VerificationPhoneNumberScreen({super.key, required this.phoneNumber});

  @override
  State<VerificationPhoneNumberScreen> createState() =>
      _RegisterPhoneScreenState();
}

class _RegisterPhoneScreenState extends State<VerificationPhoneNumberScreen> {
  final controller = RegisterPhoneController();

  final dio = Dio();

  Future<bool> sendCode() async {
    log(DateTime.now().toString(), name: 'DateTime : ');

    try {
      final editedPhoneNumber =
          '+${widget.phoneNumber.replaceAll(RegExp(r'\D'), '')}';
      final response =
          await dio.post('${ApiEndPoints.baseUrl}/send/code', data: {
        "phone_number": editedPhoneNumber,
      });
      if (response.statusCode == 200) {
        if (mounted) {
          setState(() {
            wasSended = true;
          });
          ScaffoldMessenger.of(context).showSnackBar(
              AppSnackBar.showErrorSnackBar(
                  'Вам отправлено сообщение на указанный номер'));
        }

        return true;
      } else {
        throw (response);
      }
    } on DioException catch (e) {
      final errorMessage = e.response?.data['error'] as String? ?? '';
      if (errorMessage.contains('user')) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
              AppSnackBar.showErrorSnackBar(
                  'Такой пользователя уже существует'));
        }
      }
      if (errorMessage.contains('many')) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
              AppSnackBar.showErrorSnackBar(
                  'Слишком много попыток,попробуйте позже'));
        }
      }
      return false;
    }
  }

  @override
  initState() {
    super.initState();
    sendCode();
  }

  bool ignoring = true;
  bool wasSended = false;

  @override
  Widget build(BuildContext context) {
    controller.phoneController.text = widget.phoneNumber;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Регистрация'),
      ),
      body: Consumer<RegisterCitySelectController>(
          builder: (context, contr, child) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            key: controller.formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Введите код\n верификации',
                  style: Theme.of(context)
                      .textTheme
                      .labelLarge
                      ?.copyWith(fontSize: 22),
                  textAlign: TextAlign.center,
                ),
                VerificationCode(
                  autofocus: true,
                  textStyle: Theme.of(context)
                      .textTheme
                      .displayLarge!
                      .copyWith(fontSize: 20.0, color: Colors.red[900]),
                  keyboardType: TextInputType.number,
                  underlineColor: Colors.amber,
                  length: 6,
                  cursorColor: Colors.orange,
                  clearAll: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Очистить',
                      style: Theme.of(context).textTheme.labelLarge!.copyWith(
                          decoration: TextDecoration.underline,
                          color: Colors.blue[700]),
                    ),
                  ),
                  onCompleted: (String value) async {
                    contr.changeCode(value);

                    AppDialogService.showLoadingDialog(context);
                    contr.changeIsMatch(false);
                    try {
                      final data = {
                        "phone_number":
                            '+${controller.phoneController.text.replaceAll(RegExp(r'\D'), '')}',
                        "code": int.parse(contr.code),
                      };
                      final response = await dio.post(
                          '${ApiEndPoints.baseUrl}/confirm/code',
                          data: data);

                      if (response.statusCode == 200) {
                        //908727
                        if (context.mounted) {
                          context.pop();
                          contr.changeIsMatch(true);

                          context.pushNamed(AppRouteNames.citySelect,
                              extra: User(
                                phoneNumber:
                                    '+${controller.phoneController.text.replaceAll(RegExp(r'\D'), '')}',
                                cityId: -1,
                              ));
                        }
                      } else {
                        if (context.mounted) {
                          context.pop();

                          AppDialogService.showNotValidFormDialog(
                              context, 'Код не совпадает');
                        }
                      }
                    } catch (e) {
                      if (context.mounted) {
                        context.pop();
                        AppDialogService.showNotValidFormDialog(
                            context, 'Попробуйте позже');
                      }
                    }
                  },
                  onEditing: (bool value) {
                    if (value) FocusScope.of(context).unfocus();
                  },
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
                              .take(61),
                          builder: (context, snapshot) {
                            int remainingSeconds = 60 - (snapshot.data ?? 0);

                            String displaySeconds = remainingSeconds > 9
                                ? '$remainingSeconds'
                                : '0$remainingSeconds';

                            if (remainingSeconds == 0) {
                              WidgetsBinding.instance.addPostFrameCallback((_) {
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
                              await sendCode();
                            },
                            child: const Text('Отправить заново')),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 3),
                RegisterButton(
                    controller: controller,
                    ignoring: !contr.itWasCodeMatch,
                    fromFirstPaage: false), //
              ],
            ),
          ),
        );
      }),
    );
  }
}
