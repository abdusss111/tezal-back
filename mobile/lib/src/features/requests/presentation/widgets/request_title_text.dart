import 'package:flutter/material.dart';

class RequestTitleText extends StatelessWidget {
  const RequestTitleText({
    super.key,
    required this.requestTitle,
  });

  final String requestTitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Text(
        requestTitle,
        style: Theme.of(context).textTheme.displayLarge,
        textAlign: TextAlign.start,
        overflow: TextOverflow.ellipsis,
        maxLines: 2,
      ),
    );
  }
}
