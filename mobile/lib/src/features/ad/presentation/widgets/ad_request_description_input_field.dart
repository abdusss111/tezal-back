import 'package:eqshare_mobile/src/core/presentation/widgets/app_form_field_label.dart';
import 'package:flutter/material.dart';

class AdRequestDescriptionInputField extends StatelessWidget {
  const AdRequestDescriptionInputField({
    super.key,
    required this.textEditingController,
  });
  final TextEditingController textEditingController;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AppInputFieldLabel(text: 'Описание заказа', isRequired: true),
        const SizedBox(height: 16),
        TextField(
          maxLines: 3,
          autofocus: false,
          onTapOutside: (event){

          },
          controller: textEditingController,
          decoration: InputDecoration(
            hintText: 'Введите описание заказа',
            hintStyle: Theme.of(context).textTheme.bodyMedium,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: const BorderSide(color: Colors.grey),
            ),
          ),
        ),
      ],
    );
  }
}
