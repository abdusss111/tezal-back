import 'dart:convert';
import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:dio/dio.dart';
import 'package:eqshare_mobile/src/core/presentation/services/app_dialog_service.dart';
import 'package:eqshare_mobile/src/core/res/api_endpoints/api_endpoints.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../../../../core/data/services/network/api_client/user_profile_api_client.dart';
import '../../../../core/data/services/storage/token_provider_service.dart';
import '../../../../core/presentation/widgets/app_form_field_label.dart';
import '../../../../core/presentation/routing/app_route.dart';
import '../../../../core/presentation/services/image_picker_service.dart';
import '../../../../core/presentation/widgets/app_snack_bar.dart';
import '../../../../core/presentation/widgets/app_primary_button.dart';
import '../profile_page/profile_controller_utils.dart';

class DriverFormScreen extends StatefulWidget {
  const DriverFormScreen({super.key, this.userNameInfo});

  final UserNameInfo? userNameInfo;

  @override
  State<DriverFormScreen> createState() => _DriverFormScreenState();
}

class _DriverFormScreenState extends State<DriverFormScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController iinController = TextEditingController();
  TextEditingController birthController = TextEditingController();
  TextEditingController licenseNumberController = TextEditingController();
  TextEditingController expirationDateController = TextEditingController();
  File? _driverLicensePhotoFrontSide;
  File? _driverLicensePhotoBackSide;

  bool _isDriverFrontImageValid = true;
  bool _isDriverBackImageValid = true;

  @override
  void initState() {
    super.initState();
    firstNameController.text = widget.userNameInfo?.firstName ?? '';
    lastNameController.text = widget.userNameInfo?.lastName ?? '';
  }

  void _onSuccessfulDocumentsSend(BuildContext context) {
    AppDialogService.showSuccessDialog(
      context,
      title: 'Ваши документы успешно загружены!',
      onPressed: () {
        switchToDriverMode(context);
      },
      buttonText: 'В профиль',
    );
  }

  Future<void> switchToDriverMode(BuildContext context) async {
    AppDialogService.showLoadingDialog(context);

    try {
      http.Response? response =
          await UserProfileApiClient().postSwitchToDriver();
      debugPrint(response!.statusCode.toString());

      final json = await jsonDecode(response.body);

      if (response.statusCode == 200) {
        final token = await json['Authorization']['access'] as String?;
        debugPrint(token!);

        await TokenService().setToken(token);
        if (context.mounted) {
          if (context.mounted) {

            // Navigator.of(context).pushNamedAndRemoveUntil(
            //     AppRouteNames.navigation,
            //     arguments: {'index': '4'},
            //     (route) => false);
            context.pushReplacementNamed(AppRouteNames.navigation,
                extra: {'index': '4'});
          }
        }
      } else if (response.statusCode == 403) {
        if (context.mounted) {
          context.pop();
          // Navigator.pop(context);
          context.go('/${AppRouteNames.navigation}', extra: {'index': '4'});
          // Navigator.pushNamed(context, AppRouteNames.driverForm);
        }
      } else {
        if (context.mounted) {
          // Navigator.pop(context);
          // Navigator.pop(context);
          context.pop();
          context.pop();

          ScaffoldMessenger.of(context).showSnackBar(
            AppSnackBar.showErrorSnackBar(
              'Нельзя стать водителем',
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          AppSnackBar.showErrorSnackBar(
            e.toString(),
          ),
        );
        // Navigator.pop(context);
        context.pop();
      }
    }

    final token = await TokenService().getToken();
    if (token == null) {
      return;
    }
  }

  Future<bool> uploadDriverForm({
    required File? driverLicensePhotoFrontSide,
    required File? driverLicensePhotoBackSide,
  }) async {
    String photoFrontSideFileName =
        driverLicensePhotoFrontSide!.path.split('/').last;
    String photoBackSideFileName =
        driverLicensePhotoBackSide!.path.split('/').last;
    final url = '${ApiEndPoints.baseUrl}/driver/';
    Map<String, String> headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    final token = await TokenService().getToken();
    headers['Authorization'] = 'Bearer $token';
    debugPrint(headers['Authorization'].toString());
    List<dynamic>? documents = [];
    documents.add(await MultipartFile.fromFile(driverLicensePhotoFrontSide.path,
        filename: photoFrontSideFileName));
    documents.add(await MultipartFile.fromFile(driverLicensePhotoBackSide.path,
        filename: photoBackSideFileName));
    try {
      final formData = FormData.fromMap({
        'first_name': firstNameController.text,
        'last_name': lastNameController.text,
        'birth_date': birthController.text,
        'iin': iinController.text,
        'license_number': licenseNumberController.text,
        'expiration_date': expirationDateController.text,
        'documents': documents
      });

      debugPrint(formData.files.toString());
      debugPrint(formData.fields.toString());

      final response = await Dio().post(
        url,
        data: formData,
        options: Options(
          headers: headers,
        ),
      );
      if (response.statusCode == 200) {
        final map = response.data as Map;
        if (map['status'] == 'Successfully added') {
          return true;
        } else {
          return false;
        }
      } else {
        debugPrint('status:${response.statusCode}');

        BotToast.showText(text: 'Error');
        return false;
      }
    } on DioException catch (e) {
      if (e.response != null) {
        debugPrint(e.response?.data.toString() ?? 'nnn');

        debugPrint(e.response?.headers.toString() ?? 'nnn');
        debugPrint(e.response?.requestOptions.toString() ?? 'nnn');
      } else {
        debugPrint(e.requestOptions.toString());
        debugPrint(e.message.toString());
      }
      throw (e.message.toString());
    }
  }

  bool get isValidForm {
    return _formKey.currentState!.validate() &&
        _isDriverFrontImageValid &&
        _isDriverBackImageValid;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const FittedBox(child: Text('Заполнение необходимых данных')),
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    const SizedBox(height: 16),
                    const AppInputFieldLabel(
                      text: 'Имя',
                      isRequired: true,
                    ),
                    const SizedBox(height: 8),
                    DriverFormCollapsedTextField(
                      hintText: 'Введите ваше имя',
                      descriptionController: firstNameController,
                    ),
                    const SizedBox(height: 16),
                    const AppInputFieldLabel(
                      text: 'Фамилия',
                      isRequired: true,
                    ),
                    const SizedBox(height: 8),
                    DriverFormCollapsedTextField(
                      hintText: 'Введите вашу фамилию',
                      descriptionController: lastNameController,
                    ),
                    const SizedBox(height: 16),
                    const AppInputFieldLabel(
                      text: 'ЖСН/ИИН',
                      isRequired: true,
                    ),
                    const SizedBox(height: 8),
                    _IINInput(controller: iinController),
                    const AppInputFieldLabel(
                      text: 'Дата рождения',
                      isRequired: true,
                    ),
                    const SizedBox(height: 8),
                    _BirthDayDateInput(birthController: birthController),
                    const SizedBox(height: 16),
                    const AppInputFieldLabel(
                      text: 'Номер водительского удостоверения',
                      isRequired: true,
                    ),
                    const SizedBox(height: 8),
                    _LicenseNumberInput(controller: licenseNumberController),
                    const AppInputFieldLabel(
                      text: 'Дата окончания действия лицензии',
                      isRequired: true,
                    ),
                    const SizedBox(height: 8),
                    _LicenceExpirationDatePicker(
                        controller: expirationDateController),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Expanded(
                          child: AppInputFieldLabel(
                            text:
                                'Фото водительского удостоверения (обратная сторона)',
                            isRequired: true,
                          ),
                        ),
                        const SizedBox(width: 22),
                        OutlinedButton(
                          style: OutlinedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5)),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 10),
                              minimumSize: Size.zero),
                          onPressed: () async {
                            _driverLicensePhotoFrontSide =
                                await ImageService.pickImage(context,
                                    openScreenType: OpenScreenType.dialog);
                            setState(() {});
                          },
                          child: const Icon(Icons.upload_outlined,
                              color: Colors.black),
                        ),
                      ],
                    ),
                    _driverLicensePhotoFrontSide != null
                        ? _DriverLicenceImage(
                            driverLicenseImage: _driverLicensePhotoFrontSide)
                        : const SizedBox(),
                    if (!_isDriverFrontImageValid)
                      const ImageValidationErrorWidget(),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Expanded(
                          child: AppInputFieldLabel(
                            text:
                                'Фото водительского удостоверения (обратная сторона)',
                            isRequired: true,
                          ),
                        ),
                        const SizedBox(width: 22),
                        OutlinedButton(
                          style: OutlinedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5)),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 10),
                              minimumSize: Size.zero),
                          onPressed: () async {
                            _driverLicensePhotoBackSide =
                                await ImageService.pickImage(context,
                                    openScreenType: OpenScreenType.dialog);
                            setState(() {});
                          },
                          child: const Icon(Icons.upload_outlined,
                              color: Colors.black),
                        ),
                      ],
                    ),
                    _driverLicensePhotoBackSide != null
                        ? _DriverLicenceImage(
                            driverLicenseImage: _driverLicensePhotoBackSide)
                        : const SizedBox(),
                    if (!_isDriverBackImageValid)
                      const ImageValidationErrorWidget(),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: AppPrimaryButtonWidget(
                        onPressed: () async {
                          setState(() {
                            _isDriverFrontImageValid =
                                _driverLicensePhotoFrontSide != null;
                            _isDriverBackImageValid =
                                _driverLicensePhotoBackSide != null;
                          });
                          if (isValidForm) {
                            AppDialogService.showLoadingDialog(context);
                            await uploadDriverForm(
                                driverLicensePhotoFrontSide:
                                    _driverLicensePhotoFrontSide,
                                driverLicensePhotoBackSide:
                                    _driverLicensePhotoBackSide);
                            if (context.mounted) {
                              // Navigator.pop(context);
                              context.pop();
                            }
                            if (context.mounted) {
                              _onSuccessfulDocumentsSend(context);
                            }
                          }
                        },
                        text: 'Сохранить',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ImageValidationErrorWidget extends StatelessWidget {
  const ImageValidationErrorWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Text('Пожалуйста, загрузите фото',
          style: Theme.of(context).inputDecorationTheme.errorStyle),
    );
  }
}

class _DriverLicenceImage extends StatelessWidget {
  const _DriverLicenceImage({
    required File? driverLicenseImage,
  }) : _driverLicenseImage = driverLicenseImage;

  final File? _driverLicenseImage;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      width: double.maxFinite,
      child: Image.file(_driverLicenseImage!, fit: BoxFit.cover),
    );
  }
}

class DriverFormCollapsedTextField extends StatelessWidget {
  const DriverFormCollapsedTextField({
    super.key,
    required this.descriptionController,
    required this.hintText,
    this.keyboardType,
    this.maxLength,
    this.autofocus,
    this.maxLines,
  });

  final TextEditingController descriptionController;
  final String hintText;
  final TextInputType? keyboardType;
  final int? maxLength;
  final int? maxLines;

  final bool? autofocus;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autofocus: autofocus ?? false,
      controller: descriptionController,
      keyboardType: keyboardType ?? TextInputType.text,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hintText,
        border: const OutlineInputBorder(),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        counterText: '',
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return hintText;
        }
        if (maxLength != null && value.length > maxLength!) {
          return 'Maximum length exceeded';
        }
        return null;
      },
      maxLength: maxLength ?? 20,
    );
  }
}

class _BirthDayDateInput extends StatefulWidget {
  const _BirthDayDateInput({
    required this.birthController,
  });

  final TextEditingController birthController;

  @override
  State<_BirthDayDateInput> createState() => _BirthDayDateInputState();
}

class _BirthDayDateInputState extends State<_BirthDayDateInput> {
  late DateFormat _displayFormat;

  @override
  void initState() {
    super.initState();
    _displayFormat = DateFormat('dd-MM-yyyy');
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      lastDate: DateTime.now().subtract(const Duration(days: 365 * 18)),
      firstDate: DateTime(1900),
      initialDate: DateTime.now().subtract(const Duration(days: 365 * 18)),
    );
    if (pickedDate != null) {
      setState(() {
        widget.birthController.text = _displayFormat.format(pickedDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.birthController,
      readOnly: true,
      onTap: () => _selectDate(context),
      decoration: const InputDecoration(
        hintText: 'дд-мм-гггг',
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Выберите дату рождения';
        }
        return null;
      },
    );
  }
}

class _LicenceExpirationDatePicker extends StatefulWidget {
  const _LicenceExpirationDatePicker({required this.controller});

  final TextEditingController controller;

  @override
  State<_LicenceExpirationDatePicker> createState() =>
      _LicenceExpirationDatePickerState();
}

class _LicenceExpirationDatePickerState
    extends State<_LicenceExpirationDatePicker> {
  Future<void> _selectExpirationDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 10)),
    );
    if (pickedDate == null) return;

    setState(() {
      widget.controller.text = DateFormat('dd-MM-yyyy').format(pickedDate);
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      readOnly: true,
      onTap: () => _selectExpirationDate(context),
      decoration: const InputDecoration(
        hintText: 'дд-мм-гггг',
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Пожалуйста, выберите дату истечения лицензии';
        }
        return null;
      },
    );
  }
}

class _IINInput extends StatefulWidget {
  const _IINInput({required this.controller});

  final TextEditingController controller;

  @override
  State<_IINInput> createState() => _IINInputState();
}

class _IINInputState extends State<_IINInput> {
  final RegExp _iinRegex = RegExp(r'^\d{12}$');

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      keyboardType: TextInputType.number,
      maxLength: 12,
      maxLengthEnforcement: MaxLengthEnforcement.none,
      decoration: const InputDecoration(
        hintText: 'ЖСН/ИИН',
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Пожалуйста, введите ИИН';
        } else if (!_iinRegex.hasMatch(value)) {
          return 'ИИН должен состоять из 12 цифр';
        }
        return null;
      },
    );
  }
}

class _LicenseNumberInput extends StatefulWidget {
  const _LicenseNumberInput({required this.controller});

  final TextEditingController controller;

  @override
  State<_LicenseNumberInput> createState() => _LicenseNumberInputState();
}

class _LicenseNumberInputState extends State<_LicenseNumberInput> {
  final RegExp _licenceNumberRegex = RegExp(r'^\d{6}$');

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      keyboardType: TextInputType.text,
      textCapitalization: TextCapitalization.characters,
      maxLength: 6,
      maxLengthEnforcement: MaxLengthEnforcement.none,
      decoration: const InputDecoration(
        hintText: 'Введите номер удостоверения',
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Пожалуйста, введите номер водительского удостоверения';
        } else if (!_licenceNumberRegex.hasMatch(value)) {
          return 'Номер водительского удостоверения должен состоять из 6 цифр';
        }
        return null;
      },
    );
  }
}
