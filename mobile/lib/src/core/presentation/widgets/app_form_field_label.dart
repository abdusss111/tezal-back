import 'package:flutter/material.dart';

class AppInputFieldLabel extends StatelessWidget {
  const AppInputFieldLabel({
    super.key,
    required this.text,
    required this.isRequired,
  });
  final String text;
  final bool isRequired;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: text,
        style: Theme.of(context).textTheme.bodyLarge,
        children: [
          if (isRequired == true)
            const TextSpan(
              text: ' *',
              style: TextStyle(
                color: Colors.red,
              ),
            )
        ],
      ),
    );
  }
}
