import 'package:eqshare_mobile/src/core/presentation/services/app_bottom_sheet_service.dart';
import 'package:eqshare_mobile/src/features/ad/presentation/widgets/send_report_dialog/send_reports_bottom_sheet.dart';
import 'package:flutter/material.dart';

class SendReportButton extends StatelessWidget {
  final String id;
  final Future<bool> Function({
    required String adID,
    required int reportReasonID,
    required String reportText,
  }) sendReport;
  const SendReportButton(
      {required this.id, required this.sendReport, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GestureDetector(
        onTap: () {
          AppBottomSheetService.showAppCupertinoModalBottomSheet(
              context,
              CommonSendReportBottomSheet(
                  adID: int.parse(id), sendReport: sendReport));
        },
        child: Container(
          height: 40,
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 255, 212, 0),
            borderRadius: BorderRadius.circular(5),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.report_outlined,
                color: Color.fromARGB(255, 0, 0, 0),
                size: 24,
              ),
              Text('Пожаловаться на обьявление')
            ],
          ),
        ),
      ),
    );
  }
}
