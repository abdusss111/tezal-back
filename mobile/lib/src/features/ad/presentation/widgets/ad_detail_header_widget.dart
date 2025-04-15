import 'package:eqshare_mobile/app/app_change_notifier.dart';
import 'package:flutter/material.dart';

class AdDetailHeaderWidget extends StatelessWidget {
  final String? titleText;
  final String? status;
  const AdDetailHeaderWidget({
    super.key,
    required this.titleText,
    this.status,
  });
  String getStatusTextForRequest(String? status) {
    switch (status) {
      case 'CANCELED':
        return 'Отменен';
      case 'CREATED':
        if (AppChangeNotifier().payload!.aud != ('CLIENT')) {
          return 'На утверждении клиента';
        } else {
          return 'На утверждении водителя';
        }
      case 'WORKING':
        if (AppChangeNotifier().payload!.aud != ('CLIENT')) {
          return 'В работе';
        } else {
          return 'В работе';
        }
      case 'AWAITS_START':
        if (AppChangeNotifier().payload!.aud != ('CLIENT')) {
          return 'В ожидании начала';
        } else {
          return 'В ожидании начала';
        }
      case 'APPROVED':
        return 'В ожидании начала';
      case 'ON_ROAD':
        return 'В пути';
      case 'PAUSE':
        return 'Приостановлен';
      case 'FINISHED':
        return 'Завершено';
      default:
        return status.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(titleText ?? '',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 20, // Smaller font size
                  fontWeight: FontWeight.bold, // Not bold
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,),

        if (status != null)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('Статус',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 16, // Smaller font size
                        fontWeight: FontWeight.bold, // Not bold
                      )),
              Text(getStatusTextForRequest(status) ?? 'Неизвестен',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 16, // Smaller font size
                      ))
            ],
          )
          
      ],
    );
  }
}
