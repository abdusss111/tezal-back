import 'package:flutter/material.dart';

class FormRichText extends StatelessWidget {
  final String text;

  const FormRichText({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: text,
        style: const TextStyle(fontSize: 16, color: Colors.black),
        children: const [
          TextSpan(
            text: ' *',
            style: TextStyle(color: Colors.red),
          )
        ],
      ),
    );
  }
}
