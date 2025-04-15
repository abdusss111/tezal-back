import 'package:eqshare_mobile/src/core/presentation/routing/app_route.dart';
import 'package:eqshare_mobile/src/core/presentation/widgets/app_circular_progress_indicator.dart';
import 'package:eqshare_mobile/src/core/presentation/widgets/app_form_field_label.dart';

import 'package:eqshare_mobile/src/features/ad/presentation/screens/ad_create_global_widgets/ad_create_global_widgets.dart';

import 'package:eqshare_mobile/src/features/ad/presentation/screens/ad_equipment/ad_equipment_create/ad_equipment_create_controller.dart';
import 'package:eqshare_mobile/src/features/ad/presentation/widgets/get_widget.dart';
import 'package:go_router/go_router.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdEquipmentCreateScreen extends StatefulWidget {
  const AdEquipmentCreateScreen({super.key});

  @override
  State<AdEquipmentCreateScreen> createState() =>
      _AdEquipmentCreateScreenState();
}

class _AdEquipmentCreateScreenState extends State<AdEquipmentCreateScreen> {
  late AdEquipmentCreateController controller;

  @override
  void initState() {
    super.initState();
    controller =
        Provider.of<AdEquipmentCreateController>(context, listen: false);
  }

  @override
  void dispose() {
    controller.descriptionController.dispose();
    controller.headerController.dispose();
    controller.priceController.dispose();
    super.dispose();
  }

  Widget createOrEdit() {
    if (controller.editID == null) {
      return ApproveCreateAdButton(
        buttonTextColor: Colors.white,
        isValidForm: controller.isValidForm,
        uploadAdClient: () async {
          final result = await controller.uploadAdEquipment();
          print(result);
          return result;
        },
        alternativeRoute: AppRouteNames.myAdEquipmentList,
        showSuccessDialogTitleText:
            controller.editID == null ? null : 'Изменения сохранены',
        buttonText:
            controller.editID == null ? 'Добавить' : 'Сохранить изменение',
      );
    } else {
      return ApproveCreateAdButton(
        buttonTextColor: Colors.white,
        isValidForm: controller.isValidForm,
        uploadAdClient: () async {
          final result = await controller.editAdEquipment();
          return result;
        },
        alternativeRoute: AppRouteNames.myAdEquipmentList,
        showSuccessDialogTitleText:
            controller.editID == null ? null : 'Изменения сохранены',
        buttonText:
            controller.editID == null ? 'Добавить' : 'Сохранить изменение',
      );
    }
  }

  Widget buildImagesField(BuildContext context) {
    if (controller.editID == null) {
      return PickImagesForAdWhenCreateWidget(
          inputFieldLabelText: 'Фото оборудования',
          selectedImagesLength: controller.selectedImages.length,
          onImagePicked: (pickedImagePath) {
            controller.selectedImages.add(pickedImagePath);
          },
          selectedImages: controller.selectedImages,
          onImageRemoved: (index) {
            controller.selectedImages.removeAt(index);
          });
    } else {
      return PickImagesWhenRedactAd(
        inputFieldLabelText: 'Фото оборудования',
        selectedImagesLength: controller.selectedImages.length,
        onImagePicked: (pickedImagePath) {
          controller.selectedImages.add(pickedImagePath);
        },
        selectedImages: controller.selectedImages,
        onImageRemoved: (index) {
          controller.selectedImages.removeAt(index);
        },
        networkImages: controller.networkImages,
      );
    }
  }

  Widget buildCategoryField() {
    return SingleSelectionCategoryDropDownButtonWithSearch(
        future: controller.getCategoryFuture,
        selectedItem: controller.selectedCategory,
        onChanged: (value) {
          controller.setSelectedCategory(value);
          if (value != null) {
            controller.fetchSubCategories(value.id.toString());
          }
        });
  }

  Widget buildSubCategoryField() {
    return SingleSelectionSubCategoryDropDownButtonWithSearch(
        future: controller.futureSubCategories,
        selectedItem: controller.selectedSubCategory,
        onChanged: (value) {
          controller.setSelectedSubCategory(value);
        });
  }

  Widget buildCityField() {
    return CitiesDropDownButtonWithSearch(
      future: controller.getCityFuture,
      selectedCity: controller.selectedCity,
      onChanged: (value) {
        controller.setSelectedCity(value);
      },
    );
  }

  List<Widget> buildPriceField(BuildContext context) {
    return [
      const SizedBox(height: 16),
      const AppInputFieldLabel(text: 'Цена аренды', isRequired: true),
      const SizedBox(height: 16),
      PriceTextField(
          initialValue: controller.price,
          priceController: controller.priceController,
          onEndEditing: controller.setPrice
          )
    ];
  }

  List<Widget> buildDescriptionField() {
    return [
      const AppInputFieldLabel(text: 'Описание', isRequired: true),
      const SizedBox(height: 12),
      AppPrimaryTextField(
        controller: controller.descriptionController,
        hintText: 'Введите описание',
        maxLines: 5,
      ),
    ];
  }

  List<Widget> buildHeaderField() {
    return [
      const AppInputFieldLabel(text: 'Заголовок', isRequired: true),
      const SizedBox(height: 12),
      AppPrimaryTextField(
        controller: controller.headerController,
        hintText: 'Введите заголовок',
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () {
            if (controller.editID == null) {
              context.pop();
            } else {
              showDialog(
                  context: context,
                  builder: (context) {
                    return const AdAlertDialogForPop();
                  });
            }
          },
        ),
        title: Text(controller.editID == null
            ? 'Добавление оборудования'
            : 'Редактирование'),
      ),
      body: Consumer<AdEquipmentCreateController>(
        builder: (context, controller, child) {
          if (controller.isLoading) {
            return const AppCircularProgressIndicator();
          }
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 22),
                const AppInputFieldLabel(
                  text: 'Категория',
                  isRequired: true,
                ),
                buildCategoryField(),
                const AppInputFieldLabel(
                  text: 'Подкатегория',
                  isRequired: true,
                ),
                buildSubCategoryField(),
                const AppInputFieldLabel(
                  text: 'Бренд',
                  isRequired: true,
                ),
                SingleSelectionBrandDropDownWithSearch(
                  future: controller.getBrandFuture,
                  selectedItem: controller.selectedBrand,
                  onChanged: (value) {
                    controller.setSelectedBrand(value);
                  },
                ),
                const AppInputFieldLabel(
                  text: 'Город',
                  isRequired: true,
                ),
                buildCityField(),
                const SizedBox(height: 8),
                ...buildHeaderField(),
                const SizedBox(height: 16),
                ...buildDescriptionField(),
                buildImagesField(context),
                const SizedBox(height: 16),
                const AppInputFieldLabel(
                  text: 'Адрес оборудования',
                  isRequired: true,
                ),
                const SizedBox(height: 8),
                AppLocationPickerRowItem(
                  onLocationSelected: controller.handleLocationSelected,
                  selectedAddress: controller.address,
                  hintText: 'Выберите адрес оборудования',
                ),
                ...buildPriceField(context),
                createOrEdit(),
              ],
            ),
          );
        },
      ),
    );
  }
}
