import 'package:eqshare_mobile/src/core/presentation/widgets/app_primary_button.dart';
import 'package:eqshare_mobile/src/features/main/profile/driver_form/driver_form_screen.dart';
import 'package:eqshare_mobile/src/features/main/profile/profile_page/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class EditNameBottomSheet extends StatefulWidget {
  final ProfileController profileController;
  const EditNameBottomSheet({super.key, required this.profileController});

  @override
  State<EditNameBottomSheet> createState() => _EditNameBottomSheetState();
}

class _EditNameBottomSheetState extends State<EditNameBottomSheet> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Напишите имя',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                Spacer(),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 12),
                DriverFormCollapsedTextField(
                  descriptionController: firstNameController,
                  hintText: 'Введите имя',
                ),
                const SizedBox(height: 12),
                DriverFormCollapsedTextField(
                  descriptionController: lastNameController,
                  hintText: 'Введите фамилию',
                ),
                const SizedBox(height: 12),
                _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                        strokeWidth: 2,
                      ))
                    : AppPrimaryButtonWidget(
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {
                            setState(() {
                              _isLoading = true;
                            });
                            await widget.profileController.putUserName(
                                firstName: firstNameController.text,
                                lastName: lastNameController.text);
                            if (context.mounted) {
                              // Navigator.pop(context);
                              context.pop();
                            }
                          }
                        },
                        textColor: Colors.white,
                        text: 'Сохранить',
                      )
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    super.dispose();
  }
}
