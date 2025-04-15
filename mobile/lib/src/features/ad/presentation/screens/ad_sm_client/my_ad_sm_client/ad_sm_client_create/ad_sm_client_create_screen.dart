import 'package:eqshare_mobile/src/core/data/models/cities/city/city_model.dart';
import 'package:eqshare_mobile/src/core/presentation/routing/app_route.dart';
import 'package:eqshare_mobile/src/core/presentation/utils/auth_middleware.dart';
import 'package:eqshare_mobile/src/core/presentation/widgets/get_core_widgets.dart';
import 'package:eqshare_mobile/src/features/ad/presentation/screens/ad_create_global_widgets/ad_create_global_widgets.dart';
import 'package:eqshare_mobile/src/features/ad/presentation/widgets/get_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

import 'package:eqshare_mobile/src/core/data/models/category_models/category.dart';
import 'ad_sm_client_create_controller.dart';

class AdSMClientCreateScreen extends StatefulWidget {
  const AdSMClientCreateScreen({super.key});

  @override
  State<AdSMClientCreateScreen> createState() => _AdSMClientCreateScreenState();
}

class _AdSMClientCreateScreenState extends State<AdSMClientCreateScreen> {
  final maxImagesCount = 5;
  late AdSMClientCreateController controller;

  late final Future<List<Category>> getCategoryFuture;
  late final Future<List<City>> getCityFuture;

  @override
  void initState() {
    super.initState();
    controller =
        Provider.of<AdSMClientCreateController>(context, listen: false);
    getCategoryFuture = controller.fetchCategories();
    getCityFuture = controller.fetchCities();
  }

  Widget buildImageOfObject() {
    if (controller.editID == null) {
      return PickImagesForAdWhenCreateWidget(
          inputFieldLabelText: 'Добавить фото',
          selectedImagesLength: controller.selectedImages.length,
          onImagePicked: (imagePath) {
            controller.addImages(imagePath);
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
            controller.addImages(imagePath);
          },
          selectedImages: controller.selectedImages,
          onImageRemoved: (index) {
            controller.removeImages(index);
          });
    }
  }

  Widget buildTotalPrice() {
    final price = int.tryParse(controller.priceController.text.trim()) ?? 0;
    final hours = controller.calculateHoursDifference() ?? 0;
    return AdTotalPriceWidget(totalPrice: (price * hours).toString());
  }

  Widget endedPickedDateTime() {
    if (controller.isEndTimeEnabled == true) {
      return PickedDatetimeWidget(
        pickedDatetime: controller.toDateTime,
        onDateTimePicked: (value) {
          final data = controller.checkTimeIsBefore(value);
          if (data) {
            ScaffoldMessenger.of(context).showSnackBar(
                AppSnackBar.showErrorSnackBar(
                    'Время начала должен быть раньше, чем время окончания работы'));
          } else {
            controller.setEndDateTime(value);
          }
        },
        inputFieldLabelText: 'Время завершения работы',
      );
    } else {
      return const SizedBox();
    }
  }

  List<Widget> hourOfWorkWidget() {
    if (controller.fromDateTime != null && controller.toDateTime != null) {
      return [
        const SizedBox(height: 16),
        AdBuildAmountOfHours(
            amountHour: controller.calculateHoursDifference().toString()),
      ];
    } else {
      return [];
    }
  }

  List<Widget> totalWorkPriceWidget() {
    if (controller.toDateTime != null &&
        controller.fromDateTime != null &&
        controller.priceController.text.isNotEmpty) {
      return [
        const SizedBox(height: 16),
        buildTotalPrice(),
      ];
    } else {
      return [];
    }
  }

  AppLocationPickerRowItem appLocationWidget() {
    return AppLocationPickerRowItem(
      onLocationSelected: (result) async {
        controller.setPoint(result['selectedPoint'] as LatLng?);
        controller.setAddress(result['address'] as String?);
      },
      selectedAddress: controller.address,
      hintText: 'Выберите адрес',
    );
  }

  AdTextInformationFromUser descriptionControllerWidget() {
    return AdTextInformationFromUser(
        controller: controller.descriptionController,
        hintText: 'Введите описание',
        maxLines: 5,
        onChanged: controller.setDescription);
  }

  AdTextInformationFromUser headlineControllerWidget() {
    return AdTextInformationFromUser(
      controller: controller.headerController,
      hintText: 'Введите заголовок',
      onChanged: controller.setTitle,
    );
  }

  CitiesDropDownButtonWithSearch citiesDropDownButtonWithSearch() {
    return CitiesDropDownButtonWithSearch(
      future: getCityFuture,
      onChanged: (value) {
        controller.setSelectedCity(value);
      },
      selectedCity: controller.selectedCity,
    );
  }

  SingleSelectionSubCategoryDropDownButtonWithSearch
      singleSelectionSubCategoryDropDownButtonWithSearch() {
    return SingleSelectionSubCategoryDropDownButtonWithSearch(
      future: controller.adApiClient.getSmSubCategoryList(
          (controller.selectedCategory?.id ?? 0).toString()),
      selectedItem: controller.selectedSubCategory,
      onChanged: (value) {
        controller.setSelectedSubCategory(value);
      },
    );
  }

  SingleSelectionCategoryDropDownButtonWithSearch
      singleSelectionCategoryDropDownButtonWithSearch() {
    return SingleSelectionCategoryDropDownButtonWithSearch(
      future: getCategoryFuture,
      selectedItem: controller.selectedCategory,
      onChanged: (value) {
        controller.setSelectedCategory(value);
      },
    );
  }

  CheckboxListTile checkBoxListTileForControllEndTime() {
    return CheckboxListTile(
      checkColor: Colors.white,
      contentPadding: EdgeInsets.zero,
      title: const Text('Время завершения работы'),
      value: controller.isEndTimeEnabled,
      onChanged: (newValue) {
        if (controller.fromDateTime != null) {
          controller.setEndDateTimeEnabled(newValue);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              AppSnackBar.showErrorSnackBar('Сперва выберите время начала'));
        }
      },
      controlAffinity: ListTileControlAffinity.leading,
    );
  }

  PickedDatetimeWidget pickedDateTimeWidget() {
    return PickedDatetimeWidget(
      pickedDatetime: controller.fromDateTime,
      onDateTimePicked: (value) {
        controller.setStartDateTime(value);
      },
      inputFieldLabelText: 'Время начала работы',
    );
  }

  Widget createOrEditButton(
      {required Future<dynamic> Function() uploadAdClient,
      required Future<dynamic> Function() editFunction}) {
    return ApproveCreateAdButton(
      buttonText: controller.editID == null ? null : 'Сохранить изменение',
      showSuccessDialogTitleText:
          controller.editID == null ? null : 'Успешно изменено',
      uploadAdClient: controller.editID == null ? uploadAdClient : editFunction,
      buttonTextColor: Colors.white,
      isValidForm: controller.isValidForm(),
      alternativeRoute: AppRouteNames.navigation, // Todo check
    );
  }

  Widget _buildBody() {
    return Consumer<AdSMClientCreateController>(
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
            checkBoxListTileForControllEndTime(),
            endedPickedDateTime(),
            ...hourOfWorkWidget(),
            const SizedBox(height: 22),
            RequiredTextUpWidgets.categeryText(),
            singleSelectionCategoryDropDownButtonWithSearch(),
            RequiredTextUpWidgets.subCategeryText(),
            singleSelectionSubCategoryDropDownButtonWithSearch(),
            RequiredTextUpWidgets.cityText(),
            citiesDropDownButtonWithSearch(),
            const SizedBox(height: 11),
            RequiredTextUpWidgets.headlineOrTitleText(),
            const SizedBox(height: 12),
            headlineControllerWidget(),
            const SizedBox(height: 18),
            RequiredTextUpWidgets.descriptionText(),
            const SizedBox(height: 12),
            descriptionControllerWidget(),
            const SizedBox(height: 16),
            RequiredTextUpWidgets.adressText(),
            const SizedBox(height: 8),
            appLocationWidget(),
            const SizedBox(height: 16),
            RequiredTextUpWidgets.priceText(),
            const SizedBox(height: 16),
            PriceTextField(
              priceController: controller.priceController,
              onEndEditing: (value) {
                controller.setPrice(value);
              },
              initialValue: controller.priceController.text,
            ),
            ...totalWorkPriceWidget(),
            const SizedBox(height: 16),
            buildImageOfObject(),
            createOrEditButton(uploadAdClient: () async {
              final result = await controller.uploadAdClient();
              return result;
            }, editFunction: () async {
              final result = await controller.editAdClient();
              return result;
            })
          ],
        ),
      );
    });
  }

  Widget buildAmountOfHours() {
    return AdBuildAmountOfHours(
        amountHour: '${controller.calculateHoursDifference()}');
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
        title: const Text('Добавить объявление'),
      ),
      body: AuthMiddleware().buildAuthenticatedWidget(_buildBody()),
    );
  }
}
