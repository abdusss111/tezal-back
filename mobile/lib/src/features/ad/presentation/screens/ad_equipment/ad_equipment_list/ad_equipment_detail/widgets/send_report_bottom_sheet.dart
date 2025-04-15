import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../../../core/presentation/widgets/app_primary_button.dart';
import '../../../../../../../main/profile/driver_form/driver_form_screen.dart';
import '../ad_equipment_detail_controller.dart';

class SendReportEqBottomSheet extends StatefulWidget {
  final AdEquipmentDetailController adEquipmentDetailController;
  final specializedMachineryId;

  const SendReportEqBottomSheet(
      {super.key,
      required this.adEquipmentDetailController,
      required this.specializedMachineryId});

  @override
  State<SendReportEqBottomSheet> createState() =>
      _SendFeedbackBottomSheetState();
}

class _SendFeedbackBottomSheetState extends State<SendReportEqBottomSheet> {
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
                    textColor: Colors.white,
                    onPressed: () async {
                      setState(() {
                        _isLoading = true;
                      });
                      await widget.adEquipmentDetailController
                          .onReportPostClient(
                        context,
                        widget.specializedMachineryId,
                        descriptionController.text.toString(),
                        widget.specializedMachineryId,
                      );
                      if (context.mounted) {
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
