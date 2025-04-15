import 'package:eqshare_mobile/src/features/ad/presentation/widgets/expandable_text.dart';
import 'package:flutter/material.dart';

class AdDescriptionOnlyWidget extends StatelessWidget {
  final String description;
  final int maxLines;

  const AdDescriptionOnlyWidget(
      {super.key, required this.description, this.maxLines = 5});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Описание', style: Theme.of(context).textTheme.bodyLarge),
          const SizedBox(height: 4),
          ExpandableText(
            maxLines: maxLines,
            text: description,
            textStyle: Theme.of(context).textTheme.bodyMedium,
          )
        ],
      ),
    );
  }
}
