import 'package:eqshare_mobile/src/core/presentation/utils/date_format_helper.dart';
import 'package:eqshare_mobile/src/features/requests/presentation/widgets/help_widgets/detail_row_widget.dart';
import 'package:flutter/material.dart';

class AdDescriptionClientWidget extends StatelessWidget {
  final String descriptionText;
  final String? startDate;
  final String? endDate;
  final String? createdAt;
  final String? category;

  const AdDescriptionClientWidget(
      {super.key,
      required this.descriptionText,
      this.startDate,
      this.createdAt,
      this.endDate,
      this.category});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (descriptionText.isNotEmpty)
            const Text(
              'Описание',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          if (descriptionText.isNotEmpty) const SizedBox(height: 8),
          if (descriptionText.isNotEmpty)
            Text(
              descriptionText,
              style: const TextStyle(fontSize: 14),
            ),
          if (descriptionText.isNotEmpty) const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.all(0.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (category != null && category!.isNotEmpty)
                  DetailRowWidget('Категория', category ?? ''),
                if (createdAt != null)
                  DetailRowWidget(
                      'Заказ создан', DateTimeUtils.formatDatetime(createdAt)),
                if (startDate != null &&
                    startDate!.isNotEmpty &&
                    !startDate!.contains('null'))
                  DetailRowWidget('Планируемое начало',
                      DateTimeUtils.formatDatetime(startDate)),
                if (endDate != null &&
                    endDate!.isNotEmpty &&
                    !endDate!.contains('null'))
                  DetailRowWidget('Планируемое завершение',
                      DateTimeUtils.formatDatetime(endDate)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
