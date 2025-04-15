import 'package:eqshare_mobile/src/features/ad/presentation/screens/ad_sm/all_ad_sm/ad_sm_detail/ad_sm_detail_controller.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../../../core/presentation/widgets/app_primary_button.dart';
import '../../../../../../../main/profile/driver_form/driver_form_screen.dart';

class SendReportBottomSheet extends StatefulWidget {
  final AdSMDetailController adSMDetailController;
  final int specializedMachineryId;

  const SendReportBottomSheet(
      {super.key,
      required this.adSMDetailController,
      required this.specializedMachineryId});

  @override
  State<SendReportBottomSheet> createState() => _SendFeedbackBottomSheetState();
}

class _SendFeedbackBottomSheetState extends State<SendReportBottomSheet> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController descriptionController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      // Wrap with SingleChildScrollView
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Material(
        color: Colors.white,
        child: Column(
          // Wrap with Column
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 12),
            const Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Пожаловаться',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                Spacer(),
              ],
            ),
            const SizedBox(height: 12),
            DriverFormCollapsedTextField(
              descriptionController: descriptionController,
              hintText: 'Введите текст',
            ),
            const SizedBox(height: 12),
            _isLoading
                ? const Center(
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : AppPrimaryButtonWidget(
                    onPressed: () async {
                      setState(() {
                        _isLoading = true;
                      });
                      await widget.adSMDetailController.onReportPostClient(
                        context,
                        widget.specializedMachineryId,
                        descriptionController.text.toString(),
                        widget.specializedMachineryId,
                      );
                      if (mounted) {
                        context.pop();
                      }
                    },
                    text: 'Сохранить',
                  ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    descriptionController.dispose();
    super.dispose();
  }
}
