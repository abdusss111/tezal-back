import 'package:flutter/material.dart';

class AdBuildAmountOfHours extends StatelessWidget {
  final String amountHour;
  const AdBuildAmountOfHours({super.key, required this.amountHour});

  @override
  Widget build(BuildContext context) {
    return Text.rich(TextSpan(
        text: 'Количество часов:  ',
        style: Theme.of(context).textTheme.bodyLarge,
        children: [
          TextSpan(
              text: amountHour,
              style: Theme.of(context)
                  .textTheme
                  .displaySmall!
                  .copyWith(fontWeight: FontWeight.normal))
        ]));
  }
}
