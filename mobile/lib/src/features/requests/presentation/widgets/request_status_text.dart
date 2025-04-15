import 'package:flutter/material.dart';

class RequestStatusText extends StatelessWidget {
  const RequestStatusText({
    super.key,
    required this.statusText,
    this.color,
  });

  final String statusText;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Text.rich(
        TextSpan(
          text: 'Статус: ',
          style: Theme.of(context)
              .textTheme
              .bodyMedium!
              .copyWith(fontWeight: FontWeight.bold),
          children: [
            TextSpan(
              text: statusText,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(fontWeight: FontWeight.normal, color: color),
            ),
          ],
        ),
      ),
    );
  }
}
