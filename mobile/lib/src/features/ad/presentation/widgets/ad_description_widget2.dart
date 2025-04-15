import 'package:eqshare_mobile/src/core/presentation/utils/date_format_helper.dart';
import 'package:eqshare_mobile/src/features/requests/presentation/widgets/help_widgets/detail_row_widget.dart';
import 'package:flutter/material.dart';

class AdDescriptionWidget2 extends StatelessWidget {
  final String? startedTime;
  final String? endedTime;
  final DateTime? createdTime;
  final String? userFirstName;
  final String? userSecondName;
  final String? userContacts;

  const AdDescriptionWidget2({
    super.key,
    this.startedTime,
    this.endedTime,
    this.createdTime,
    this.userFirstName,
    this.userSecondName,
    this.userContacts,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 2,
            offset: const Offset(0, 3),
          ),
        ],
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
                  DetailRowWidget('Заказ создан',
                      DateTimeUtils.formatDatetime2(createdTime!)),
                if (startedTime != null)
                  DetailRowWidget('Планируемое начало',
                      DateTimeUtils.formatDatetime(startedTime!)),
                if (endedTime != null &&
                    endedTime!.isNotEmpty &&
                    endedTime !=
                        'null') // Я знаю что это пиздец пока не понял кто это засунул
                  DetailRowWidget('Планируемое завершение',
                      DateTimeUtils.formatDatetime(endedTime)),
                if ((userFirstName != null && userFirstName!.isNotEmpty) ||
                    (userSecondName != null && userSecondName!.isNotEmpty))
                  DetailRowWidget('Заказчик',
                      '${userFirstName ?? ''} ${userSecondName ?? ''}'),
                if (userContacts != null)
                  DetailRowWidget('Контакты', '$userContacts'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
