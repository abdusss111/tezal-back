import 'package:eqshare_mobile/src/core/presentation/routing/app_route.dart';
import 'package:eqshare_mobile/src/core/presentation/services/app_dialog_service.dart';
import 'package:eqshare_mobile/src/core/presentation/utils/auth_middleware.dart';

import 'package:eqshare_mobile/src/core/presentation/widgets/get_core_widgets.dart';

import 'package:eqshare_mobile/src/features/ad/presentation/screens/ad_create_global_widgets/ad_create_global_widgets.dart';
import 'package:eqshare_mobile/src/features/ad/presentation/screens/ad_equipment_client/ad_equipment_client_create/ad_equipment_client_create_controller.dart';
import 'package:eqshare_mobile/src/features/ad/presentation/widgets/get_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class AdEquipmentClientCreateScreen extends StatefulWidget {
  const AdEquipmentClientCreateScreen({super.key});

  @override
  State<AdEquipmentClientCreateScreen> createState() =>
      _AdEquipmentClientCreateScreenState();
}

class _AdEquipmentClientCreateScreenState
    extends State<AdEquipmentClientCreateScreen> {
  final maxImagesCount = 5;

  late final AdEquipmentClientCreateController controller;

  @override
  void initState() {
    super.initState();
    controller =
        Provider.of<AdEquipmentClientCreateController>(context, listen: false);
  }

  void showSuccessDialog(BuildContext context) {
    AppDialogService.showSuccessDialog(
      context,
      title: 'Ваше объявление успешно создано!',
      onPressed: () {
        context.pop();
        context.pop();

        if (context.canPop()) {
          context.pop();
          context.pushReplacementNamed(AppRouteNames.myAdEquipmentList);
        } else {
          context.pushNamed(AppRouteNames.myAdEquipmentList);
        }
      },
      buttonText: 'Мои объявления',
    );
  }

  Widget _buildBody() {
    return Consumer<AdEquipmentClientCreateController>(
        builder: (context, controller, _) {
      if (controller.isLoading) {
        return const AppCircularProgressIndicator();
      }
      return SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 22),
            pickedDateTimeWidget(),
            const SizedBox(height: 8),
            CheckboxListTile(
              checkColor: Colors.white,
              contentPadding: EdgeInsets.zero,
              title: const Text('Время завершения работы'),
              value: controller.isEndTimeEnabled,
              onChanged: (bool? newValue) {
                controller.toggleEndTime(newValue);
              },
              controlAffinity: ListTileControlAffinity.leading,
            ),
            endedPickedDateTime(),
            if (controller.toDateTime != null &&
                controller.fromDateTime != null) ...[
              const SizedBox(height: 16),
              AdBuildAmountOfHours(
                  amountHour: controller.calculateHoursDifference().toString()),
            ],
            const SizedBox(height: 22),
            const AppInputFieldLabel(text: 'Категория', isRequired: true),
            buildCategoryField(),
            const AppInputFieldLabel(
              text: 'Подкатегория',
              isRequired: true,
            ),
            buildSubCategoryField(),
            const AppInputFieldLabel(text: 'Город', isRequired: true),
            buildCityField(),
            const SizedBox(height: 11),
            const AppInputFieldLabel(text: 'Заголовок', isRequired: true),
            const SizedBox(height: 12),
            AdTextInformationFromUser(
              controller: controller.headerController,
              initialValue: controller.title,
              hintText: 'Введите заголовок',
              onChanged: controller.setTitle,
            ),
            const SizedBox(height: 18),
            const AppInputFieldLabel(text: 'Описание', isRequired: true),
            const SizedBox(height: 12),
            AdTextInformationFromUser(
              controller: controller.descriptionController,
              initialValue: controller.desc,
              hintText: 'Введите описание',
              maxLines: 5,
              onChanged: controller.setDescription,
            ),
            const SizedBox(height: 16),
            const AppInputFieldLabel(text: 'Адрес объекта', isRequired: true),
            const SizedBox(height: 8),
            AppLocationPickerRowItem(
              onLocationSelected: controller.handleLocationSelected,
              selectedAddress: controller.address,
              hintText: 'Выберите адрес объекта',
            ),
            const SizedBox(height: 16),
            const AppInputFieldLabel(
                text: 'Предлагаемая цена', isRequired: true),
            const SizedBox(height: 16),
            PriceTextField(
              priceController: controller.priceController,
              initialValue: controller.price,
              onEndEditing: (value) {
                controller.setPrice(value);
              },
            ),
            if (controller.toDateTime != null &&
                controller.fromDateTime != null &&
                controller.priceController.text.isNotEmpty) ...[
              const SizedBox(height: 16),
              AdTotalPriceWidget(
                totalPrice: ((controller.calculateHoursDifference() ?? 0) *
                        int.parse(controller.priceController.text))
                    .toString(),
              ),
            ],
            const SizedBox(height: 16),
            buildImageOfObject(),
            editOrCreateButton(),
          ],
        ),
      );
    });
  }

  Widget editOrCreateButton() {
    return ApproveCreateAdButton(
      isValidForm: isValidForm(),
      uploadAdClient: controller.editID == null
          ? () async {
              final result = await controller.uploadAdClient();
              return result;
            }
          : () async {
              final result = await controller.editOrUpdateAdClient();
              return result;
            },
      showSuccessDialogTitleText: controller.editID == null
          ? 'Ваше объявление успешно создано!'
          : 'Изменение сохранены',
      alternativeRoute: AppRouteNames.adEquipmentList,
      buttonTextColor: Colors.white,
      buttonText: controller.editID == null
          ? 'Сохранить объявление'
          : 'Сохранить изменение',
    );
  }

  bool isValidForm() {
    return controller.address?.isNotEmpty == true &&
        controller.price != null &&
        controller.price!.isNotEmpty &&
        controller.descriptionController.text.isNotEmpty &&
        controller.headerController.text.isNotEmpty &&
        controller.selectedCategory != null &&
        controller.selectedSubCategory != null &&
        controller.fromDateTime != null;
  }

  Widget buildImageOfObject() {
    if (controller.editID == null) {
      return PickImagesForAdWhenCreateWidget(
          inputFieldLabelText: 'Добавить фото',
          selectedImagesLength: controller.selectedImages.length,
          onImagePicked: (imagePath) {
            controller.setDescription(imagePath);
          },
          selectedImages: controller.selectedImages,
          onImageRemoved: (index) {
            controller.removeImages(index);
          });
    } else {
      return PickImagesWhenRedactAd(
          networkImages: controller.networkImages,
          inputFieldLabelText: 'Добавить фото',
          selectedImagesLength: controller.selectedImages.length,
          onImagePicked: (imagePath) {
            controller.setImage(imagePath);
          },
          selectedImages: controller.selectedImages,
          onImageRemoved: (index) {
            controller.removeImages(index);
          });
    }
  }

  PickedDatetimeWidget pickedDateTimeWidget() {
    return PickedDatetimeWidget(
      pickedDatetime: controller.fromDateTime,
      onDateTimePicked: (value) {
        controller.setSelectedFromDateTime(value);
      },
      inputFieldLabelText: 'Время начала работы',
    );
  }

  Widget endedPickedDateTime() {
    if (controller.isEndTimeEnabled == true) {
      return PickedDatetimeWidget(
        pickedDatetime: controller.toDateTime,
        onDateTimePicked: (value) {
          final data = controller.checkDateTime(value);
          if (data) {
            controller.setSelectedToDateTime(value);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
                AppSnackBar.showErrorSnackBar(
                    'Время начала должен быть раньше, чем время окончания работы'));
          }
        },
        inputFieldLabelText: 'Время завершения работы',
      );
    } else {
      return const SizedBox();
    }
  }

  Widget buildCategoryField() {
    return SingleSelectionCategoryDropDownButtonWithSearch(
        future: controller.getCategoryFuture,
        selectedItem: controller.selectedCategory,
        onChanged: (value) {
          controller.setSelectedCategory(value);
        });
  }

  Widget buildSubCategoryField() {
    return SingleSelectionSubCategoryDropDownButtonWithSearch(
        future: controller.getSubCategoryFuture,
        selectedItem: controller.selectedSubCategory,
        onChanged: (value) {
          controller.setSelectedSubCategory(value);
        });
  }

  Widget buildCityField() {
    return CitiesDropDownButtonWithSearch(
        selectedCity: controller.selectedCity,
        onChanged: (city) {
          controller.setSelectedCity(city);
        },
        future: controller.getCityFuture);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () {
            if (controller.editID != null) {
              showDialog(
                  context: context,
                  builder: (context) {
                    return const AdAlertDialogForPop();
                  });
            } else {
              context.pop();
            }
          },
        ),
        title: Text(controller.editID == null
            ? 'Добавить объявление'
            : 'Редактирование'),
      ),
      body: AuthMiddleware().buildAuthenticatedWidget(_buildBody()),
    );
  }
}
