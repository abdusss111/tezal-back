import 'package:eqshare_mobile/src/core/presentation/services/app_dialog_service.dart';
import 'package:eqshare_mobile/src/core/presentation/widgets/app_form_field_label.dart';
import 'package:eqshare_mobile/src/core/presentation/widgets/app_primary_button.dart';
import 'package:eqshare_mobile/src/core/res/extensions/string_extensions.dart';
import 'package:eqshare_mobile/src/core/res/theme/app_dimensions.dart';

import 'package:eqshare_mobile/src/features/ad/presentation/screens/ad_sm/my_ad_sm/ad_sm_create/ad_sm_create_controller.dart';
import 'package:eqshare_mobile/src/features/ad/presentation/screens/ad_sm/my_ad_sm/ad_sm_create/ad_sm_parameters/ad_sm_parameters_controller.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class AdSMParametersData {
  final AdFormModel adFormModel;
  final int categoryId;
  final int subCategoryId;
  final Map<String, dynamic>? params;

  AdSMParametersData({
    this.params,
    required this.categoryId,
    required this.subCategoryId,
    required this.adFormModel,
  });
}

class AdSMParametersScreen extends StatefulWidget {
  final AdSMParametersData adSMParametersData;

  const AdSMParametersScreen({
    super.key,
    required this.adSMParametersData,
  });

  @override
  State<AdSMParametersScreen> createState() => _AdSMParametersScreenState();
}

class _AdSMParametersScreenState extends State<AdSMParametersScreen> {
  late AdSMParametersController controller;

  @override
  void initState() {
    super.initState();
    controller = Provider.of<AdSMParametersController>(context, listen: false);
    controller.addListener(_controllerListener);
    controller.loadParameters(context);
  }

  @override
  void dispose() {
    controller.removeListener(_controllerListener);
    super.dispose();
  }

  void _controllerListener() {
    setState(() {}); // Trigger a rebuild when the controller notifies listeners
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Добавление параметров'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            Expanded(child: DrillForm(controller: controller)),
            const SizedBox(height: 16.0),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
              child: AppPrimaryButtonWidget(
                onPressed: () async {
                  AppDialogService.showLoadingDialog(context);

                  bool res = await controller.submitForm(context);
                  if (res) {
                    if (!context.mounted) return;
                    context.pop();
                    showSuccessDialog(context);
                  } else {
                    if (!context.mounted) return;

                    context.pop();
                    showFailureDialog(context);
                  }
                },
                textColor: Colors.white,
                text: 'Сохранить объявление',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DrillForm extends StatelessWidget {
  final AdSMParametersController controller;

  const DrillForm({
    super.key,
    required this.controller,
  });

  bool isConvertibleToDouble(String s) {
    return double.tryParse(s) != null;
  }

  @override
  Widget build(BuildContext context) {
    return controller.isLoading
        ? const Center(child: CircularProgressIndicator())
        : Form(
            key: controller.formKey,
            child: ListView(
              children: [
                for (var param in controller.params)
                  SMParamTextField(
                    text: param['name'],
                    onChanged: (value) =>
                        controller.updateFormData(param['name_eng'], value),
                    validator: (value) {
                      if (value?.isEmpty == true) {
                        return null;
                      }
                      if (!isConvertibleToDouble(value!)) {
                        return '${param['name']} должен быть в формате ##.#';
                      }
                      return null;
                    },
                    isRequired: false,
                    hintText: '',
                  ),
              ],
            ),
          );
  }
}

class SMParamTextField extends StatefulWidget {
  final String text;
  final bool isRequired;
  final String hintText;
  final void Function(String)? onChanged;
  final String? Function(String?)? validator;
  final String? value;
  final bool isNeedOnchanged;

  const SMParamTextField({
    super.key,
    required this.text,
    required this.isRequired,
    required this.hintText,
    this.isNeedOnchanged = true,
    this.onChanged,
    this.validator,
    this.value,
  });

  @override
  State<SMParamTextField> createState() => _SMParamTextFieldState();
}

class _SMParamTextFieldState extends State<SMParamTextField> {
  final TextEditingController textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.value != null) {
      textEditingController.text = widget.value ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        AppInputFieldLabel(
            text: widget.text.capitalizeFirstLetter(), isRequired: false),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: textEditingController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  isCollapsed: true,
                  contentPadding: AppDimensions.appPrimaryInputPadding,
                  hintText: widget.hintText,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5)),
                  hintStyle: Theme.of(context).textTheme.bodyLarge,
                ),
                onChanged:
                    widget.isNeedOnchanged ? widget.onChanged : (value) {},
                onEditingComplete: () {
                  if (widget.onChanged != null) {
                    widget.onChanged?.call(textEditingController.text);
                  }
                },
                validator: widget.validator,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
