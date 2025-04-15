import 'package:eqshare_mobile/src/core/presentation/services/app_dialog_service.dart';
import 'package:eqshare_mobile/src/core/presentation/widgets/app_primary_button.dart';
import 'package:eqshare_mobile/src/features/main/profile/driver_form/driver_form_screen.dart';
import 'package:eqshare_mobile/src/features/main/profile/profile_page/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SendFeedbackBottomSheet extends StatefulWidget {
  final ProfileController profileController;

  const SendFeedbackBottomSheet({super.key, required this.profileController});

  @override
  State<SendFeedbackBottomSheet> createState() =>
      _SendFeedbackBottomSheetState();
}

class _SendFeedbackBottomSheetState extends State<SendFeedbackBottomSheet> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController descriptionController = TextEditingController();
  bool _isLoading = false;

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
                Text(
                  'Обратная связь',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                Spacer(),
              ],
            ),
            const SizedBox(height: 12),
            DriverFormCollapsedTextField(
              descriptionController: descriptionController,
              hintText: 'Введите обратную связь',
              maxLength: 100,
              maxLines: 3,
            ),
            const SizedBox(height: 12),
            _isLoading
                ? const Center(
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : AppPrimaryButtonWidget(
                    onPressed: () async {
                      FocusScope.of(context).unfocus();
                      setState(() {
                        _isLoading = true;
                      });
                      final data = await widget.profileController.sendFeedback(
                        context,
                        description: descriptionController.text,
                      );
                      if (context.mounted && data) {
                        Navigator.pop(context);
                        AppDialogService.showSuccessDialog(context,
                            title: "Ваш отзыв принять",
                            onPressed: () => Navigator.pop(context),
                            buttonText: 'Назад');
                      } else {
                        if (context.mounted) {
                          AppDialogService.showNotValidFormDialog(
                              context, 'Попробуйте позже');
                        }
                      }
                    },
                    textColor: Colors.white,
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
