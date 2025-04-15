import 'package:eqshare_mobile/src/core/presentation/routing/app_route.dart';
import 'package:eqshare_mobile/src/core/presentation/widgets/app_circular_progress_indicator.dart';
import 'package:eqshare_mobile/src/core/presentation/widgets/app_snack_bar.dart';
import 'package:eqshare_mobile/src/features/ad/data/repository/ad_construction_materials_repository.dart';
import 'package:eqshare_mobile/src/features/ad/presentation/screens/ad_construction/ad_construction_create_screen/ad_construction_create_screen_controller.dart';
import 'package:eqshare_mobile/src/features/ad/presentation/utils/create_ad_or_request_enum.dart';

import 'package:eqshare_mobile/src/features/ad/presentation/widgets/get_widget.dart';
import 'package:eqshare_mobile/src/features/ad/presentation/screens/ad_create_global_widgets/ad_create_global_widgets.dart';
import 'package:go_router/go_router.dart';

import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

import 'package:flutter/material.dart';

class AdConstructionCreateScreen extends StatefulWidget {
  const AdConstructionCreateScreen({super.key});

  @override
  State<AdConstructionCreateScreen> createState() =>
      _AdConstructionCreateScreenState();
}

class _AdConstructionCreateScreenState
    extends State<AdConstructionCreateScreen> {
  @override
  void initState() {
    super.initState();
    controller = Provider.of<AdConstructionCreateScreenController>(context,
        listen: false);
  }

  late final AdConstructionCreateScreenController controller;

  final adServiceRepo = AdConstructionMaterialsRepository();

  final TextEditingController headlineController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  Widget buildImageOfObject() {
    if (controller.getEditAd == null) {
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

  Widget endedPickedDateTime() {
    if (controller.isEndTimeEnabled == true) {
      return PickedDatetimeWidget(
        pickedDatetime: controller.endedDatetime,
        onDateTimePicked: (value) {
          final data = controller.checkDateTime(value);
          if (data) {
            controller.changeEndedDatetime(value);
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

  List<Widget> hourOfWorkWidget() {
    if (controller.pickedDatetime != null && controller.endedDatetime != null) {
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
    if (controller.pickedDatetime != null &&
        controller.endedDatetime != null &&
        controller.priceController.text.isNotEmpty) {
      final price = int.tryParse(controller.priceController.text.replaceAll(RegExp(r'[^\d]'), '')) ?? 0;
      final hours = controller.calculateHoursDifference() ?? 0;
      return [
        const SizedBox(height: 16),
        AdTotalPriceWidget(
          totalPrice: (hours * price).toString(),
        )
      ];
    } else {
      return [];
    }
  }


  AppLocationPickerRowItem appLocationWidget() {
    return AppLocationPickerRowItem(
      onLocationSelected: (result) async {
        controller.changeLatLng(result['selectedPoint'] as LatLng?);
        controller.changeAddress(result['address'] as String?);
      },
      selectedAddress: controller.address,
      hintText: 'Выберите адрес объекта',
    );
  }

  AdTextInformationFromUser descriptionControllerWidget() {
    return AdTextInformationFromUser(
      controller: descriptionController,
      maxLines: 5,
      hintText: 'Введите описание',
      initialValue: controller.description,
      onChanged: controller.changeDescription,
    );
  }

  AdTextInformationFromUser headlineControllerWidget() {
    return AdTextInformationFromUser(
      controller: headlineController,
      initialValue: controller.title,
      hintText: 'Введите заголовок',
      onChanged: controller.changeTitle,
    );
  }

  CitiesDropDownButtonWithSearch citiesDropDownButtonWithSearch() {
    return CitiesDropDownButtonWithSearch(
      future: controller.getCityFuture,
      onChanged: (value) {
        controller.changeCity(value);
      },
      selectedCity: controller.city,
    );
  }

  SingleSelectionSubCategoryDropDownButtonWithSearch
      singleSelectionSubCategoryDropDownButtonWithSearch() {
    return SingleSelectionSubCategoryDropDownButtonWithSearch(
      future: controller.getSubCategory(),
      key: controller.key,
      selectedItem: controller.selectedSubCategory,
      onChanged: (value) {
        controller.changeSelectedSubCategory(value);
      },
    );
  }

  SingleSelectionCategoryDropDownButtonWithSearch
      singleSelectionCategoryDropDownButtonWithSearch() {
    return SingleSelectionCategoryDropDownButtonWithSearch(
      future: controller.getCategory,
      selectedItem: controller.selectedCategory,
      onChanged: (value) {
        controller.changeSelectedCategory(value);
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
        if (controller.pickedDatetime != null) {
          controller.changeisEndTimeEnabled();
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
      pickedDatetime: controller.pickedDatetime,
      onDateTimePicked: (value) {
        controller.changePickedDatetime(value);
      },
      inputFieldLabelText: 'Время начала работы',
    );
  }

  Widget clientCreateAdServiceBody() {
    return Consumer<AdConstructionCreateScreenController>(
        builder: (context, newController, child) {
      if (controller.isLoading) {
        return const AppCircularProgressIndicator();
      } else {
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
                initialValue: controller.price,
                onEndEditing: (value) {
                  controller.changeisprice(value);
                },
              ),
              ...totalWorkPriceWidget(),
              const SizedBox(height: 16),
              buildImageOfObject(),
              createOrEditButton(
                editFunction: () async {
                  final result = controller.editClientAd(
                      priceText: controller.price,
                      descriptionText: descriptionController.text,
                      headlineText: headlineController.text);
                  return result;
                },
                uploadAdClient: () async {
                  final result = controller.uploadClientAd(
                      priceText: controller.price,
                      descriptionText: descriptionController.text,
                      headlineText: headlineController.text);
                  return result;
                },
              ),
            ],
          ),
        );
      }
    });
  }

  Widget createOrEditButton(
      {required Future<dynamic> Function() uploadAdClient,
      required Future<dynamic> Function() editFunction}) {
    return ApproveCreateAdButton(
      buttonText: controller.getEditAd == null ? null : 'Сохранить изменение',
      showSuccessDialogTitleText:
          controller.getEditAd == null ? null : 'Успешно изменено',
      uploadAdClient:
          controller.getEditAd == null ? uploadAdClient : editFunction,
      buttonTextColor: Colors.white,
      isValidForm: controller.isValidForm(),
      alternativeRoute: AppRouteNames.navigation, // Todo check
    );
  }

  Widget createOrEditButtonForDriver(
      {required Future<dynamic> Function() uploadAdClient,
      required Future<dynamic> Function() editFunction}) {
    return Consumer<AdConstructionCreateScreenController>(
        builder: (context, controller, value) {
      final isValid = controller.isValidForForDriverOrOwner();
      return ApproveCreateAdButton(
        buttonText: controller.getEditAd == null ? null : 'Сохранить изменение',
        showSuccessDialogTitleText:
            controller.getEditAd == null ? null : 'Успешно изменено',
        uploadAdClient:
            controller.getEditAd == null ? uploadAdClient : editFunction,
        buttonTextColor: Colors.white,
        isValidForm: isValid,
        alternativeRoute: AppRouteNames.navigation, // Todo check
      );
    });
  }

  Widget driverOrOwnerCreateAdServiceBody() {
    return Consumer<AdConstructionCreateScreenController>(
        builder: (context, newController, child) {
      if (controller.isLoading) {
        return const AppCircularProgressIndicator();
      } else {
        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RequiredTextUpWidgets.categeryText(),
              singleSelectionCategoryDropDownButtonWithSearch(),
              RequiredTextUpWidgets.subCategeryText(),
              singleSelectionSubCategoryDropDownButtonWithSearch(),
              RequiredTextUpWidgets.cityText(),
              citiesDropDownButtonWithSearch(),
              const SizedBox(height: 11),
              RequiredTextUpWidgets.brandText(),
              SingleSelectionBrandDropDownWithSearch(
                future: adServiceRepo.getConstructionMaterialListBrand(),
                selectedItem: controller.brand,
                onChanged: (value) {
                  controller.changeBrand(value);
                },
              ),
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
                initialValue: controller.price,
                onEndEditing: (value) {
                  controller.changeisprice(value);
                },
              ),
              ...totalWorkPriceWidget(),
              const SizedBox(height: 16),
              buildImageOfObject(),
              createOrEditButtonForDriver(
                editFunction: () async {
                  final result = controller.editDriverOrOwnerAd(
                      priceText: controller.price,
                      descriptionText: descriptionController.text,
                      headlineText: headlineController.text);
                  return result;
                },
                uploadAdClient: () async {
                  final result = controller.uploadDriverOrOwnerAd(
                      descriptionText: descriptionController.text,
                      priceText: controller.price,
                      headlineText: headlineController.text);
                  return result;
                },
              ),
            ],
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () {
            if (controller.getEditAd != null) {
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
        title: Text(controller.getEditAd == null
            ? 'Добавление строительных материалов'
            : 'Редактирование'),
      ),
      body: Builder(builder: (context) {
        if (controller.requestEnum == CreateAdOrRequestEnum.request) {
          return clientCreateAdServiceBody();
        } else {
          return driverOrOwnerCreateAdServiceBody();
        }
      }),
    );
  }
}
