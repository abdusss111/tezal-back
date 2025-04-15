import 'package:flutter/material.dart';

class DetailRowWidget extends StatelessWidget {
  final String title;
  final String value;
  final TextStyle? valueStyle;

  const DetailRowWidget(this.title, this.value, {super.key, this.valueStyle});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(value,
                style: valueStyle ?? const TextStyle(fontSize: 14),
                maxLines: 2,
                textAlign: TextAlign.end,
                overflow: TextOverflow.fade,
                softWrap: true),
          ),
        ],
      ),
    );
  }
}
