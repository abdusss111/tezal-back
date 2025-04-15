import 'package:flutter/material.dart';

class RatingWithStarWidget extends StatelessWidget {
  const RatingWithStarWidget({super.key, required this.rating, this.style});

  final double? rating;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    if (rating != null) {
      return Text(
        '\u2605 ${rating?.toStringAsFixed(1) ?? -1}',
        style: style ??
            Theme.of(context)
                .textTheme
                .labelMedium
                ?.copyWith(color: Colors.black54),
      );
    } else {
      return const SizedBox();
    }
  }
}
