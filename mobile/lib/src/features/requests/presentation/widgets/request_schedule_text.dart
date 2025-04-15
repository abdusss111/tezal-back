import 'package:eqshare_mobile/src/core/presentation/utils/date_format_helper.dart';

import 'package:eqshare_mobile/src/features/requests/data/models/request_execution_list/request_execution.dart';
import 'package:flutter/material.dart';

class RequestScheduleText extends StatelessWidget {
  const RequestScheduleText({
    super.key,
    required this.requestExecution,
  });

  final RequestExecution requestExecution;

  @override
  Widget build(BuildContext context) {

    final request = requestExecution;


    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text.rich(
              TextSpan(
                text: 'Начало заказа: ',
                style: Theme.of(context).textTheme.displayLarge,
                children: [
                  TextSpan(
                    text:
                        DateTimeUtils.formatDatetime(request.startLeaseAt.toString()),
                    style: Theme.of(context).textTheme.displayLarge!
                        .copyWith(fontWeight: FontWeight.normal),
                  ),
                ],
              ),
            ),
            if (request.endLeaseAt != null)
              Text.rich(
                TextSpan(
                  text: 'Завершение заказа: ',
                  style: Theme.of(context).textTheme.displayLarge!,
                  children: [
                    TextSpan(
                      text:
                          DateTimeUtils.formatDatetime(request.endLeaseAt.toString()),
                      style: Theme.of(context).textTheme.displayLarge!
                          .copyWith(fontWeight: FontWeight.normal),
                    ),
                  ],
                ),
              ),
            if (request.createdAt != null)
              Text.rich(
                TextSpan(
                  text: 'Создание заказа: ',
                  style: Theme.of(context).textTheme.displayLarge,
                  children: [
                    TextSpan(
                      text:
                          DateTimeUtils.formatDatetime(request.createdAt.toString()),
                      style: Theme.of(context).textTheme.displayLarge!
                          .copyWith(fontWeight: FontWeight.normal),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ],
    );
  }
}
