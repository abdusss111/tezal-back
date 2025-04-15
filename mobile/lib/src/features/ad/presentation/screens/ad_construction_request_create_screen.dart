import 'package:eqshare_mobile/src/core/presentation/routing/app_route.dart';
import 'package:eqshare_mobile/src/core/presentation/services/app_dialog_service.dart';
import 'package:eqshare_mobile/src/core/presentation/widgets/app_form_field_label.dart';
import 'package:eqshare_mobile/src/core/presentation/widgets/app_primary_button.dart';
import 'package:eqshare_mobile/src/core/presentation/widgets/app_snack_bar.dart';

import 'package:eqshare_mobile/src/features/ad/presentation/screens/ad_create_global_widgets/ad_text_information_from_user.dart';
import 'package:eqshare_mobile/src/features/ad/presentation/screens/ad_create_global_widgets/pick_images_widget.dart';
import 'package:eqshare_mobile/src/features/ad/presentation/screens/ad_create_global_widgets/picked_datetime_widget.dart';
import 'package:eqshare_mobile/src/features/ad/presentation/widgets/ad_build_amount_of_hours.dart';
import 'package:eqshare_mobile/src/features/ad/presentation/widgets/ad_total_price_widget.dart';
import 'package:eqshare_mobile/src/features/ad/presentation/widgets/app_location_picker_row_item.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';

class AdRequestCreateScreen extends StatefulWidget {
  final Future<bool>? Function({
    required String description,
    required DateTime pickedStart,
    required List<String> pickedImages,
    required LatLng latLng,
    required String address,
    DateTime? pickedEndTime,
    required String adID,
    required double adPrice,
  }) approveThisUserPostToDriver;

  final String adID;
  final double adPrice;

  const AdRequestCreateScreen(
      {super.key,
      required this.adID,
      required this.adPrice,
      required this.approveThisUserPostToDriver});

  @override
  State<AdRequestCreateScreen> createState() => _AdRequestCreateScreenState();
}

class _AdRequestCreateScreenState extends State<AdRequestCreateScreen> {
  DateTime? pickedStartDateTime;
  DateTime? pickedEndDateTime;

  bool isEndTimeEnabled = false;

  String? selectedAddress;
  List<String> selectedImages = [];
  LatLng? latLng;

  final descriptionController = TextEditingController();

  int calculateHoursDifference() {
    return pickedEndDateTime!.difference(pickedStartDateTime!).inHours;
  }

  bool isValid() {
    return selectedAddress != null &&
        selectedAddress!.isNotEmpty &&
        descriptionController.text.isNotEmpty &&
        pickedStartDateTime != null &&
        (isEndTimeEnabled ? pickedEndDateTime != null : true);
  }

  Widget buildImageOfObject() {
    return PickImagesForAdWhenCreateWidget(
        inputFieldLabelText: 'Добавить фото',
        selectedImagesLength: selectedImages.length,
        onImagePicked: (imagePath) {
          selectedImages.add(imagePath);
          setState(() {});
        },
        selectedImages: selectedImages,
        onImageRemoved: (index) {
          selectedImages.removeAt(index);
          setState(() {});
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Информация по аренде'),
        leading: IconButton(
          // onPressed: () => Navigator.pop(context),
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              Text('Детали аренды:',
                  style: Theme.of(context).textTheme.bodyLarge),
              const SizedBox(height: 8),
              PickedDatetimeWidget(
                inputFieldLabelText: 'Время начала работы',
                onDateTimePicked: (value) {
                  setState(() {
                    pickedStartDateTime = value;
                  });
                },
                pickedDatetime: pickedStartDateTime,
              ),
              const SizedBox(height: 8),
              CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Время окончания работы'),
                value: isEndTimeEnabled,
                onChanged: (newValue) {
                  if (newValue != null) {
                    setState(() {
                      isEndTimeEnabled = newValue;
                      pickedEndDateTime = null;
                    });
                  }
                },
                controlAffinity: ListTileControlAffinity.leading,
              ),
              const SizedBox(height: 8),
              isEndTimeEnabled
                  ? PickedDatetimeWidget(
                      inputFieldLabelText: 'Время окончания работы',
                      onDateTimePicked: (value) {
                        if (value.isBefore(pickedStartDateTime!)) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              AppSnackBar.showErrorSnackBar(
                                  'Время начала должен быть раньше, чем время окончания работы'));
                        } else {
                          setState(() {
                            pickedEndDateTime = value;
                          });
                        }
                      },
                      pickedDatetime: pickedEndDateTime,
                    )
                  : const SizedBox(),
              if (pickedStartDateTime != null && pickedEndDateTime != null) ...[
                const SizedBox(height: 16),
                AdBuildAmountOfHours(
                    amountHour: calculateHoursDifference().toString()),
              ],

              // SingleSelectionSubCategoryDropDownButtonWithSearch(
              //   future: future,
              //    onChanged: onChanged)
              const SizedBox(height: 16),
              buildImageOfObject(),
              const SizedBox(height: 16),
              AdTextInformationFromUser(
                controller: descriptionController,
                hintText: 'Введите описание заказа',
                maxLines: 4,
                onChanged: (value) {},
              ),
              const SizedBox(height: 16),
              const AppInputFieldLabel(text: 'Адрес работы', isRequired: true),
              const SizedBox(height: 8),
              AppLocationPickerRowItem(
                onLocationSelected: (result) async {
                  setState(() {
                    latLng = result['selectedPoint'] as LatLng?;
                    selectedAddress = result['address'] as String?;
                  });
                },
                selectedAddress: selectedAddress,
                hintText: 'Добавить адрес объекта',
              ),
              if (pickedStartDateTime != null && pickedEndDateTime != null) ...[
                const SizedBox(height: 16),
                AdTotalPriceWidget(
                    totalPrice: (widget.adPrice *
                            (calculateHoursDifference() ?? 0).toDouble())
                        .toString())
              ],
              const SizedBox(height: 16),
              AppPrimaryButtonWidget(
                onPressed: () async {
                  if (isValid()) {
                    AppDialogService.showLoadingDialog(context);

                    final result = await widget.approveThisUserPostToDriver(
                        adID: widget.adID,
                        adPrice: widget.adPrice,
                        address: selectedAddress!,
                        description: descriptionController.text,
                        latLng: latLng!,
                        pickedImages: selectedImages,
                        pickedStart: pickedStartDateTime!,
                        pickedEndTime: pickedEndDateTime);
                    if (!context.mounted) return;
                    context.pop();
                    if (result != null && result) {
                      AppDialogService.showSuccessDialog(
                        context,
                        title: 'Ваше объявление успешно создано!',
                        onPressed: () {
                          context.goNamed(AppRouteNames.navigation);
                        },
                        buttonText: 'Мои объявления',
                      );
                    } else {
                      AppDialogService.showNotValidFormDialog(context);
                    }
                  } else {
                    AppDialogService.showNotValidFormDialog(context);
                  }
                },
                textColor: Colors.white,
                text: 'Отправить заказ',
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
