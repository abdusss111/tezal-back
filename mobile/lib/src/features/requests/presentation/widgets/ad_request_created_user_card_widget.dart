import 'package:eqshare_mobile/app/app_change_notifier.dart';
import 'package:eqshare_mobile/src/core/presentation/utils/date_format_helper.dart';
import 'package:eqshare_mobile/src/features/ad/presentation/widgets/ad_call_button.dart';

import 'package:eqshare_mobile/src/features/main/profile/profile_page/profile_controller.dart';
import 'package:eqshare_mobile/src/features/requests/presentation/widgets/help_widgets/detail_row_widget.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AdRequestCreatedUserCardWidget extends StatelessWidget {
  final String? startedTime;
  final String? endedTime;
  final String? createdTime;
  final String? userFirstName;
  final String? userSecondName;
  final String? userContacts;
  final bool forClient; //isClient
  final bool isClientRequest; //isClient
  final bool? isAssinged;
  final String? assingedUserFirstName;
  final String? assingedUSerLastName;
  final String? assingedUserContacts;

  const AdRequestCreatedUserCardWidget({
    super.key,
    this.startedTime,
    this.endedTime,
    this.createdTime,
    this.userFirstName,
    this.userSecondName,
    this.userContacts,
    this.isClientRequest = false,
    this.forClient = true,
    this.isAssinged,
    this.assingedUserFirstName,
    this.assingedUSerLastName,
    this.assingedUserContacts,
  });
  Future<void> _showContactOptions(BuildContext context, String contact) async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.call),
                title: const Text('Позвонить'),
                onTap: () async {
                  final Uri callUri = Uri(scheme: 'tel', path: contact);
                  if (await canLaunchUrl(callUri)) {
                    await launchUrl(callUri);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Не удалось выполнить звонок')),
                    );
                  }
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.chat),
                title: const Text('Связаться по WhatsApp'),
                onTap: () async {
                  final Uri whatsappUri = Uri(
                    scheme: 'https',
                    host: 'wa.me',
                    path: contact.replaceAll('+', '').replaceAll(' ', ''),
                  );
                  if (await canLaunchUrl(whatsappUri)) {
                    await launchUrl(whatsappUri);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Не удалось открыть WhatsApp')),
                    );
                  }
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(0.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (createdTime != null)
                  DetailRowWidget(
                      isClientRequest ? 'Заказ создан' : 'Заказ пришел',
                      DateTimeUtils.formatDatetime(createdTime!)),
                if (startedTime != null)
                  DetailRowWidget('Дата начала заказа',
                      DateTimeUtils.formatDatetime(startedTime!)),
                if (endedTime != null &&
                    endedTime!.isNotEmpty &&
                    endedTime !=
                        'null') // Я знаю что это пиздец пока не понял кто это засунул
                  DetailRowWidget('Дата завершения заказа',
                      DateTimeUtils.formatDatetime(endedTime)),
                if ((userFirstName != null && userFirstName!.isNotEmpty) ||
                    (userSecondName != null && userSecondName!.isNotEmpty))
                  DetailRowWidget(forClient ? 'Исполнитель' : 'Клиент',
                      '${userFirstName ?? ''} ${userSecondName ?? ''}'),
                if (userContacts != null && userContacts!.isNotEmpty)
                  GestureDetector(
                      onTap: () {
                        if (userContacts != null && userContacts!.isNotEmpty) {
                          _showContactOptions(context, userContacts!);
                        }
                      },
                      child: DetailRowWidget(
                        forClient ? 'Контакты исполнителя' : 'Контакты клиента',
                        '$userContacts',
                        valueStyle:
                            Theme.of(context).textTheme.displayMedium!.copyWith(
                                  fontSize: 14,
                                  color: Colors.blue,
                                  overflow: TextOverflow.ellipsis,
                                ),
                      )),
                if (isAssinged != null &&
                    isAssinged! &&
                    (assingedUserFirstName != userFirstName ||
                        userSecondName != assingedUSerLastName ||
                        userContacts != assingedUserContacts))
                  DetailRowWidget(
                      !(AppChangeNotifier().userMode == UserMode.client)
                          ? 'Вам назначил'
                          : 'Отправил заявку',
                      '${assingedUserFirstName != null && !assingedUserFirstName!.contains('null') && assingedUserFirstName!.isNotEmpty ? assingedUserFirstName : ''} ${assingedUSerLastName != null && !assingedUSerLastName!.contains('null') && assingedUSerLastName!.isNotEmpty ? assingedUSerLastName : ''} '),
                if (isAssinged != null &&
                    isAssinged! &&
                    assingedUserContacts != null &&
                    !assingedUserContacts!.contains('null') &&
                    assingedUserContacts!.isNotEmpty &&
                    (assingedUserFirstName != userFirstName ||
                        userSecondName != assingedUSerLastName ||
                        userContacts != assingedUserContacts))
                  GestureDetector(
                      onTap: () async {
                        if (userContacts!.isNotEmpty) {
                          await CallOptionsFunctions()
                              .onCallPressed(context, userContacts);
                        }
                      },
                      child: DetailRowWidget(
                        'Контакт',
                        '$assingedUserContacts',
                        valueStyle:
                            Theme.of(context).textTheme.displayMedium!.copyWith(
                                  fontSize: 14,
                                  color: Colors.blue,
                                  overflow: TextOverflow.ellipsis,
                                ),
                      )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
