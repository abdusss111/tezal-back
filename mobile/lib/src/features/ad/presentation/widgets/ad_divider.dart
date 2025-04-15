import 'package:flutter/material.dart';

class AdDivider extends StatelessWidget {
  final double horizontal;
  final double vertical;
  final Color? color;

  const AdDivider({
    super.key,
    this.horizontal = 4.0,
    this.vertical = 4.0,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical),
      child: Divider(
        color: color ?? Colors.grey.shade100, // Если цвет не указан, используется стандартный
      ),
    );
  }
}
