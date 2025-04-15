import 'package:flutter/material.dart';

class AdTotalPriceWidget extends StatelessWidget {
  final String totalPrice;
  const AdTotalPriceWidget({super.key, required this.totalPrice});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text('Общая сумма:',
            style: Theme.of(context)
                .textTheme
                .displaySmall!
                .copyWith(fontSize: 16)),
        const Spacer(),
        Text.rich(
          TextSpan(
            text: totalPrice,
            style: Theme.of(context).textTheme.displaySmall,
            children: [
              TextSpan(
                text: ' т',
                style: Theme.of(context)
                    .textTheme
                    .displaySmall!
                    .copyWith(color: Colors.black),
              ),
            ],
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
