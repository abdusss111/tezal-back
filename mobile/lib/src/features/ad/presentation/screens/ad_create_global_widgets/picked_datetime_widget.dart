import 'package:eqshare_mobile/src/core/presentation/utils/date_format_helper.dart';
import 'package:eqshare_mobile/src/core/presentation/widgets/app_form_field_label.dart';
import 'package:eqshare_mobile/src/core/res/theme/app_colors.dart';
import 'package:flutter/material.dart';

class PickedDatetimeWidget extends StatefulWidget {
  final String inputFieldLabelText;
  final DateTime? pickedDatetime;

  final void Function(DateTime) onDateTimePicked;

  const PickedDatetimeWidget(
      {super.key,
      required this.inputFieldLabelText,
      required this.onDateTimePicked,
      required this.pickedDatetime});

  @override
  State<PickedDatetimeWidget> createState() => _PickedDatetimeWidgetState();
}

class _PickedDatetimeWidgetState extends State<PickedDatetimeWidget> {
  Future<DateTime?> showFirstDateTimePicker(BuildContext context) async {
    final pickedFromDate = await DateTimeUtils.showAppDatePicker(context);
    if (pickedFromDate != null) {
      if (!context.mounted) return pickedFromDate;
      final pickedFromTime = await DateTimeUtils.showAppTimePicker(context);
      if (pickedFromTime != null) {
        final fromDate = pickedFromDate;
        final fromTime = pickedFromTime;

        final fromDateTime = DateTime(
          fromDate.year,
          fromDate.month,
          fromDate.day,
          fromTime.hour,
          fromTime.minute,
        );
        widget.onDateTimePicked(fromDateTime);
        return fromDateTime;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: AppColors.appFormFieldFillColor,
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppInputFieldLabel(
                    text: widget.inputFieldLabelText, isRequired: true),
                const SizedBox(height: 5),
                Text(
                  widget.pickedDatetime != null
                      ? DateTimeUtils.formatDateTime(widget.pickedDatetime)
                      : 'Выберите время',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
            const Spacer(),
            TextButton(
              onPressed: () async => showFirstDateTimePicker(context),
              child: Text(
                'Изменить',
                style: Theme.of(context).textTheme.displaySmall,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
