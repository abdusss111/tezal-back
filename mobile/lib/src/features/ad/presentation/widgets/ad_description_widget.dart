import 'package:eqshare_mobile/src/core/presentation/utils/date_format_helper.dart';
import 'package:eqshare_mobile/src/features/requests/presentation/widgets/help_widgets/detail_row_widget.dart';
import 'package:flutter/material.dart';

class AdDescriptionWidget extends StatelessWidget {
  final String descriptionText;
  final dynamic adSM;

  const AdDescriptionWidget({
    super.key,
    required this.descriptionText,
    required this.adSM,
  });

  bool hasProperty(dynamic object, String property) {

    if (object is Map) {
      return object.containsKey(property);
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
   
    return Container(
      padding: (hasProperty(adSM, 'createdAt') && adSM['createdAt'] != null)
          ? const EdgeInsets.all(12)
          : const EdgeInsets.all(0),
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
                  if (adSM is Map<String, dynamic>) ...[
                    if (hasProperty(adSM, 'startLeaseAt') &&
                        adSM['startLeaseAt'] != null)
                      DetailRowWidget('Дата начала заказа',
                          DateTimeUtils.formatDatetime2(adSM['startLeaseAt'])),
                    if (hasProperty(adSM, 'endLeaseAt') &&
                        adSM['endLeaseAt'] != null)
                      DetailRowWidget('Дата завершения заказа',
                          DateTimeUtils.formatDatetime2(adSM['endLeaseAt'])),
                    if (hasProperty(adSM, 'createdAt') &&
                        adSM['createdAt'] != null)
                      DetailRowWidget('Заказ создан',
                          DateTimeUtils.formatDatetime2(adSM['createdAt'])),
                    if (hasProperty(adSM, 'createdAt') &&
                        adSM['createdAt'] != null)
                      DetailRowWidget('Заказчик',
                          '${adSM['user']['lastName']} ${adSM['user']['firstName']}'),
                    if (hasProperty(adSM['user'], 'phoneNumber') &&
                        adSM['user']['phoneNumber'] != null)
                      DetailRowWidget(
                          'Контакты', '${adSM['user']['phoneNumber']}'),
                  ],
                ],
              )),
        ],
      ),
    );
  }
}
