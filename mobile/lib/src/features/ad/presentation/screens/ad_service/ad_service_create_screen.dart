import 'package:eqshare_mobile/app/app_change_notifier.dart';
import 'package:eqshare_mobile/src/core/presentation/routing/app_route.dart';
import 'package:eqshare_mobile/src/features/ad/presentation/screens/ad_construction/ad_construction_create_screen/ad_construction_create_screen.dart';
import 'package:eqshare_mobile/src/features/ad/presentation/screens/ad_service/ad_service_create_screen_controller.dart';
import 'package:eqshare_mobile/src/features/ad/presentation/utils/create_ad_or_request_enum.dart';
import 'package:eqshare_mobile/src/features/ad/presentation/widgets/get_widget.dart';
import 'package:eqshare_mobile/src/features/ad/presentation/screens/ad_create_global_widgets/ad_create_global_widgets.dart';
import 'package:eqshare_mobile/src/core/presentation/widgets/get_core_widgets.dart';

import 'package:eqshare_mobile/src/features/main/profile/profile_page/profile_controller.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

import 'package:eqshare_mobile/src/features/ad/data/repository/ad_service_repository.dart';

import 'package:flutter/material.dart';

class AdServiceCreateScreen extends StatefulWidget {
  const AdServiceCreateScreen({super.key});

  @override
  State<AdServiceCreateScreen> createState() => _AdServiceCreateScreenState();
}

class _AdServiceCreateScreenState extends State<AdServiceCreateScreen> {
  @override
  void initState() {
    super.initState();
    controller =
        Provider.of<AdServiceCreateScreenController>(context, listen: false);
  }

  late final AdServiceCreateScreenController controller;

  final adServiceRepo = AdServiceRepository();
  final TextEditingController headlineController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  Widget buildImageOfObject() {
    if (controller.getEditID == null) {
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
    return AdTotalPriceWidget(
        totalPrice: ((controller.calculateHoursDifference() ?? 0) *
                int.parse(controller.priceController.text))
            .toString());
  }

  Widget endedPickedDateTime() {
    if (controller.isEndTimeEnabled == true) {
      return PickedDatetimeWidget(
        pickedDatetime: controller.endedDatetime,
        onDateTimePicked: (value) {
          final data = controller.checkTimeIsBefore(value);
          if (data) {
            ScaffoldMessenger.of(context).showSnackBar(
                AppSnackBar.showErrorSnackBar(
                    'Время начала должен быть раньше, чем время окончания работы'));
          } else {
            controller.changeEndedDatetime(value);
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
        controller.changeLatLng(result['selectedPoint'] as LatLng?);
        controller.changeAddress(result['address'] as String?);
      },
      selectedAddress: controller.address,
      hintText: 'Выберите адрес',
    );
  }

  AdTextInformationFromUser descriptionControllerWidget() {
    return AdTextInformationFromUser(
      controller: descriptionController,
      hintText: 'Введите описание',
      maxLines: 5,
      initialValue: controller.description,
      onChanged: controller.changeDescription,
    );
  }

  AdTextInformationFromUser headlineControllerWidget() {
    return AdTextInformationFromUser(
      controller: headlineController,
      hintText: 'Введите заголовок',
      onChanged: controller.changeTitle,
      initialValue: controller.title,
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
      future: adServiceRepo.getAdServiceListSubCategory(
          categoryID: controller.selectedCategory?.id),
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

  Widget createOrEditButton(
      {required Future<dynamic> Function() uploadAdClient,
      required Future<dynamic> Function() editFunction}) {
    return ApproveCreateAdButton(
      buttonText: controller.getEditID == null ? null : 'Сохранить изменение',
      showSuccessDialogTitleText:
          controller.getEditID == null ? null : 'Успешно изменено',
      uploadAdClient:
          controller.getEditID == null ? uploadAdClient : editFunction,
      buttonTextColor: Colors.white,
      isValidForm: controller.isValidForm(),
      alternativeRoute: AppRouteNames.navigation, // Todo check
    );
  }

  Widget createOrEditButtonForDriver(
      {required Future<dynamic> Function() uploadAdClient,
      required Future<dynamic> Function() editFunction}) {
    return ApproveCreateAdButton(
      buttonText: controller.getEditID == null ? null : 'Сохранить изменение',
      showSuccessDialogTitleText:
          controller.getEditID == null ? null : 'Успешно изменено',
      uploadAdClient:
          controller.getEditID == null ? uploadAdClient : editFunction,
      buttonTextColor: Colors.white,
      isValidForm: controller.isValidForForDriverOrOwner(),
      alternativeRoute: AppRouteNames.navigation, // Todo check
    );
  }

  Widget requestCreateServiceBody() {
    return Consumer<AdServiceCreateScreenController>(
        builder: (context, newController, child) {
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
                }),
            ...totalWorkPriceWidget(),
            const SizedBox(height: 16),
            buildImageOfObject(),
            createOrEditButton(uploadAdClient: () async {
              final result = controller.uploadClientAdService(
                  priceText: controller.price,
                  descriptionText: descriptionController.text,
                  headlineText: headlineController.text);
              return result;
            }, editFunction: () async {
              final result = controller.editClientAdService(
                  priceText: controller.price,
                  descriptionText: descriptionController.text,
                  headlineText: headlineController.text);
              return result;
            })
          ],
        ),
      );
    });
  }

  Widget adCreateServiceBody() {
    return Consumer<AdServiceCreateScreenController>(
        builder: (context, newController, child) {
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
            createOrEditButtonForDriver(uploadAdClient: () async {
              final result = controller.uploadDriverOrOwnerAdService(
                  descriptionText: descriptionController.text,
                  priceText: controller.price,
                  headlineText: headlineController.text);
              return result;
            }, editFunction: () async {
              final result = controller.editDriverOrOwnerAdService(
                  descriptionText: descriptionController.text,
                  priceText: controller.price,
                  headlineText: headlineController.text);
              return result;
            })
          ],
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () {
            if (controller.getEditID != null) {
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
        title: Text(controller.getEditID == null
            ? (Provider.of<AppChangeNotifier>(context).payload != null &&
                    Provider.of<AppChangeNotifier>(context).userMode ==
                        UserMode.client)
                ? 'Создание услуги'
                : 'Добавление услуги'
            : 'Редактирование'),
      ),
      body: Consumer<AdServiceCreateScreenController>(
          builder: (context, controller, child) {
        if (controller.isLoading) {
          return const AppCircularProgressIndicator();
        } else {
          if (controller.requestEnum == CreateAdOrRequestEnum.request) {
            return requestCreateServiceBody();
          } else {
            return adCreateServiceBody();
          }
        }
      }),
    );
  }
}
