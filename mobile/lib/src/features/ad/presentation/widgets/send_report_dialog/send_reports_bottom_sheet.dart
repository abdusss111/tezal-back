import 'package:eqshare_mobile/src/core/presentation/services/app_dialog_service.dart';
import 'package:eqshare_mobile/src/core/presentation/widgets/app_primary_button.dart';
import 'package:eqshare_mobile/src/features/main/profile/driver_form/driver_form_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CommonSendReportBottomSheet extends StatefulWidget {
  final Future<bool> Function(
      {required String adID,
      required String reportText,
      required int reportReasonID}) sendReport;
  final int adID;

  const CommonSendReportBottomSheet(
      {super.key, required this.sendReport, required this.adID});

  @override
  State<CommonSendReportBottomSheet> createState() =>
      _CommonSendFeedbackBottomSheetState();
}

class _CommonSendFeedbackBottomSheetState
    extends State<CommonSendReportBottomSheet> {
  final TextEditingController descriptionController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    descriptionController.dispose();
    super.dispose();
  }

  int reportReasonID = 1;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Material(
        color: Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 12),
            const Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text('Пожаловаться',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                Spacer(),
              ],
            ),
            const SizedBox(height: 12),
            DriverFormCollapsedTextField(
                descriptionController: descriptionController,
                hintText: 'Введите текст'),
            const SizedBox(height: 12),
            isLoading
                ? const Center(child: CircularProgressIndicator(strokeWidth: 2))
                : AppPrimaryButtonWidget(
                    textColor: Colors.white,
                    onPressed: () async {
                      if (descriptionController.text.isNotEmpty) {
                        setState(() {
                          isLoading = true;
                        });

                        final value = await widget.sendReport(
                            adID: widget.adID.toString(),
                            reportText: descriptionController.text,
                            reportReasonID: reportReasonID);
                        if (context.mounted && value) {
                          context.pop();
                          setState(() {
                            isLoading = false;
                          });
                          AppDialogService.showSuccessDialog(context,
                              title: 'Ваша жалоба отправлено', onPressed: () {
                            if (context.mounted) {
                              context.pop();
                            }
                          }, buttonText: 'Назад');
                        } else {
                          if (context.mounted) {
                            context.pop();

                            setState(() {
                              isLoading = false;
                            });
                            AppDialogService.showNotValidFormDialog(
                                context, 'Повторите похже');
                          }
                        }
                      }
                    },
                    text: 'Сохранить',
                  ),
          ],
        ),
      ),
    );
  }

  Future<void> showDialogForReport() async {
    final data = await showDialog(
        context: context,
        builder: (context) {
          return Column(
            children: [
              const Text('Пожаловаться на объявление'),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.4,
              )
            ],
          );
        });
  }
}
