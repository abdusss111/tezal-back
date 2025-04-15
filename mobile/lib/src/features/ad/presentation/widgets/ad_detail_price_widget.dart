import 'package:eqshare_mobile/src/global_widgets/global_values.dart';
import 'package:flutter/material.dart';

class AdDetailPriceWidget extends StatelessWidget {
  final String? price;
  final double? rating;

  const AdDetailPriceWidget({
    super.key,
    required this.price,
    this.rating,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          getPrice(price),
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 16, // Smaller font size
                  fontWeight: FontWeight.w500,
                ),
        ),
        if (rating != null)
          Text(
            '\u2605 ${rating!.toStringAsFixed(1)}',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 16, // Smaller font size
                  fontWeight: FontWeight.w500, // Not bold
                ),
          ),
      ],
    );
  }
}
