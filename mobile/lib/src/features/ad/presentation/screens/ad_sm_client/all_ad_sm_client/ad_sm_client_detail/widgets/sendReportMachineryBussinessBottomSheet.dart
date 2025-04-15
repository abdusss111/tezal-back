import 'package:eqshare_mobile/src/core/presentation/widgets/app_primary_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../../main/profile/driver_form/driver_form_screen.dart';
import '../ad_sm_client_detail_controller.dart';

class SendReportEqBottomSheetBussiness extends StatefulWidget {
  final AdSMClientDetailController anSmClientDetailController;
  final ad_client_id;

  const SendReportEqBottomSheetBussiness(
      {Key? key,
      required this.anSmClientDetailController,
      required this.ad_client_id})
      : super(key: key);

  @override
  State<SendReportEqBottomSheetBussiness> createState() =>
      _SendFeedbackBottomSheetState();
}

class _SendFeedbackBottomSheetState
    extends State<SendReportEqBottomSheetBussiness> {
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
                ? Center(
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : AppPrimaryButtonWidget(
                    onPressed: () async {
                      // if (formKey.currentState!.validate()) {
                      setState(() {
                        _isLoading = true;
                      });
                      await widget.anSmClientDetailController
                          .onReportPostBussiness(
                        context,
                        widget.ad_client_id,
                        descriptionController.text.toString(),
                        widget.ad_client_id,
                      );
                      if (mounted) {
                        // Navigator.pop(context);
                        context.pop();
                      }
                      // }
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
