
import 'package:eqshare_mobile/src/features/requests/data/models/request_execution_list/request_execution.dart';
import 'package:flutter/material.dart';

class RequestDriverName extends StatelessWidget {
  const RequestDriverName({
    super.key,
    required this.request,
  });

  final RequestExecution request;

  @override
  Widget build(BuildContext context) {
    String value;
    if (request.assigned != null) {
      value =
          '${request.userAssigned?.firstName ?? ''} ${request.userAssigned?.lastName ?? ''}';
    } else {
      final driver = request.driver;
      value = '${driver?.firstName ?? ''} ${driver?.lastName ?? ''}';
    }
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Text.rich(
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        TextSpan(
          text: 'Исполнитель: ',
          style: Theme.of(context).textTheme.displayLarge!.copyWith(fontWeight: FontWeight.bold),
          children: [
            TextSpan(
              text: value,
              style: Theme.of(context).textTheme.displayLarge!.copyWith(
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
