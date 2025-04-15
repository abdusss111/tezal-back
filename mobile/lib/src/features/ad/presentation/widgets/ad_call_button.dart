import 'package:eqshare_mobile/src/core/presentation/utils/string_format_helper.dart';
import 'package:eqshare_mobile/src/core/presentation/widgets/app_primary_button.dart';
import 'package:eqshare_mobile/src/core/presentation/widgets/app_snack_bar.dart';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher_string.dart';

class AdCallButton extends StatelessWidget {
  final String? phoneNumber;

  const AdCallButton({super.key, required this.phoneNumber});

  Future<void> callOptionsForClient(
      BuildContext context, String phoneNumber) async {
    return showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      builder: (BuildContext context) {
        return SafeArea(
            child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    SizedBox(height: 12),
                    _listTileCar(
                      context,
                      phoneNumber: phoneNumber,
                      titleText: 'Позвонить',
                      borderColor: Colors.blue,
                      cardColor: Colors.blue.withOpacity(0.8),
                      titleColor: const Color.fromARGB(255, 255, 255, 255),
                      shadowColor: Colors.blue.shade200,
                      leading: const Icon(
                        Icons.phone,
                        color: Colors.white,
                      ),
                      onTap: () {
                        try {
                          if (phoneNumber.isNotEmpty) {
                            context.pop();
                            CallOptionsFunctions()
                                .callWithUrlLauncher(context, phoneNumber)
                                .then((value) {
                              if (!value) {
                                throw Exception();
                              }
                            });
                          } else {
                            context.pop();
                            ScaffoldMessenger.maybeOf(context)?.showSnackBar(
                                AppSnackBar.showErrorSnackBar(
                                    'Номер не определен!'));
                          }
                        } on Exception catch (e) {
                          try {
                            if (phoneNumber.isNotEmpty) {
                              context.pop();
                              CallOptionsFunctions()
                                  .onCallPressed(context, phoneNumber);
                            } else {
                              context.pop();

                              ScaffoldMessenger.maybeOf(context)?.showSnackBar(
                                  AppSnackBar.showErrorSnackBar(
                                      'Номер не определен!'));
                            }
                          } on Exception catch (e) {
                            ScaffoldMessenger.maybeOf(context)?.showSnackBar(
                                AppSnackBar.showErrorSnackBar(
                                    'Непредвиденная ошибка'));
                          }
                        }
                      },
                    ),
                    _listTileCar(context,
                        titleColor: const Color.fromARGB(255, 255, 255, 255),
                        leading: const Icon(
                          Icons.message,
                          color: Colors.white,
                        ),
                        titleText: 'WhatsApp', onTap: () async {
                      StringFormatHelper.tryOpenWhatsAppWithNumber(phoneNumber);
                    },
                        borderColor: Colors.green,
                        cardColor: Colors.green.withOpacity(0.8),
                        shadowColor: Colors.green.shade50,
                        phoneNumber: phoneNumber),
                    // ListTile(
                    //   minTileHeight: 80,
                    //   style: ListTileStyle.list,
                    //   leading: const Icon(Icons.message),
                    //   title: const Text('Отправить сообщение в WhatsApp'),
                    //   onTap: () async {
                    //     context.pop();
                    //     CallOptionsFunctions().onWhatsAppPressed(context, phoneNumber);
                    //   },
                    // ),
                    SizedBox(height: 20),
                  ],
                )));
      },
    );
  }

  Widget _listTileCar(BuildContext context,
      {required String phoneNumber,
      required Color cardColor,
      required Color borderColor,
      required Color shadowColor,
      required String titleText,
      required Color titleColor,
      required Widget leading,
      required void Function()? onTap}) {
    return Card(
      shape: RoundedRectangleBorder(
        side: BorderSide(width: 1.05, color: borderColor),
        borderRadius: BorderRadius.circular(16),
      ),
      color: cardColor,
      // shadowColor: shadowColor,
      // margin: EdgeInsets.all(2),
      // elevation: 8,
      child: Padding(
        padding: const EdgeInsets.only(top: 3.0, bottom: 3.0),
        child: ListTile(
            style: ListTileStyle.drawer,
            leading: leading,
            title: Text(
              titleText,
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(color: titleColor),
            ),
            onTap: onTap),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppPrimaryButtonWidget(
      onPressed: () async {
        callOptionsForClient(context, phoneNumber ?? '');
      },
      text: 'Связаться',
      textColor: Colors.white,
      backgroundColor: Colors.green.shade400,
      buttonType: ButtonType.elevated,
    );
  }
}

class CallOptionsFunctions {
  Future<bool> callWithUrlLauncher(
      BuildContext context, String? phoneNumber) async {
    if (phoneNumber != null) {
      try {
        launchUrlString("tel://$phoneNumber");
        return true;
      } on Exception catch (e) {
        return false;
      }
    }
    return false;
  }

  // Please doesnt do it
  Future<bool> onCallPressed(BuildContext context, String? phoneNumber) async {
    if (phoneNumber != null && phoneNumber.isNotEmpty) {
      final success = await callWithUrlLauncher(context, phoneNumber);
      if (!success && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Ошибка при выполнении звонка'),
          ),
        );
      }
      return success;
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Номер телефона не определен'),
          ),
        );
      }
      return false;
    }
  }

  Future<void> onWhatsAppPressed(
      BuildContext context, String phoneNumber) async {
    try {
      StringFormatHelper.tryOpenWhatsAppWithNumber(phoneNumber);
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Произошла ошибка: $e'),
        ),
      );
    } finally {
      if (context.mounted) {
        context.pop();
      }
    }
  }
}
