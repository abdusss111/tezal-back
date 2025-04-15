import 'dart:io';

import 'package:eqshare_mobile/src/core/data/models/user_model/user.dart';
import 'package:eqshare_mobile/src/core/data/repositories/app_general_repo.dart';
import 'package:eqshare_mobile/src/core/presentation/routing/app_route.dart';
import 'package:eqshare_mobile/src/core/presentation/services/app_dialog_service.dart';
import 'package:eqshare_mobile/src/core/presentation/services/image_picker_service.dart';
import 'package:eqshare_mobile/src/core/presentation/utils/date_format_helper.dart';
import 'package:eqshare_mobile/src/core/presentation/widgets/app_form_field_label.dart';
import 'package:eqshare_mobile/src/core/presentation/widgets/app_primary_button.dart';
import 'package:eqshare_mobile/src/core/res/theme/app_colors.dart';

import 'package:eqshare_mobile/src/global_widgets/global_values.dart';

import 'package:eqshare_mobile/src/features/ad/presentation/screens/ad_sm_client_business_create/ad_sm_client_create_business_controller.dart';
import 'package:eqshare_mobile/src/features/ad/presentation/widgets/ad_build_amount_of_hours.dart';
import 'package:eqshare_mobile/src/features/ad/presentation/widgets/ad_total_price_widget.dart';
import 'package:eqshare_mobile/src/features/ad/presentation/widgets/app_location_picker_row_item.dart';
import 'package:eqshare_mobile/src/features/ad/presentation/widgets/app_primary_ad_text_field.dart';
import 'package:eqshare_mobile/src/features/ad/presentation/widgets/price_text_field.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:eqshare_mobile/src/core/data/models/category_models/sub_category.dart';
import '../../../../../core/data/models/cities/city/city_model.dart';
import '../../../../../core/presentation/widgets/app_generic_dropdown_search.dart';

class AdSMClientCreateBusinessScreen extends StatefulWidget {
  const AdSMClientCreateBusinessScreen({super.key});

  @override
  State<AdSMClientCreateBusinessScreen> createState() =>
      _AdSMClientCreateScreenBusinessState();
}

class _AdSMClientCreateScreenBusinessState
    extends State<AdSMClientCreateBusinessScreen> {
  final maxImagesCount = 5;
  late AdSmClientCreateBusinessController controller;

  late Future<List<City>> getCitiesFuture;
  late Future<List<User>> getWorkersFuture;

  @override
  void initState() {
    super.initState();
    controller =
        Provider.of<AdSmClientCreateBusinessController>(context, listen: false);
    getCitiesFuture = AppGeneralRepo().getCities();
    getWorkersFuture = controller.fetchMyWorkers();
  }

  void showSuccessDialog(BuildContext context) {
    AppDialogService.showSuccessDialog(
      context,
      title: 'Ваше объявление успешно создано!',
      onPressed: () {
        context.pop();

        if (context.canPop()) {
          context.pop();
          context.pushReplacementNamed(AppRouteNames.myAdSMList);
        } else {
          context.pushNamed(AppRouteNames.myAdSMList);
        }
      },
      buttonText: 'Мои объявления',
    );
  }

  Widget _buildBody() {
    return Consumer<AdSmClientCreateBusinessController>(
        builder: (context, controller, _) {
      return SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 22),
            _buildDateTimePick(context),
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
            if (controller.isEndTimeEnabled == true) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: AppColors.appFormFieldFillColor,
                ),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const AppInputFieldLabel(
                            text: 'Время завершения работы', isRequired: false),
                        const SizedBox(height: 5),
                        Text(
                          controller.toDate != null
                              ? DateTimeUtils.formatDateTimeLabel(
                                  controller.toDate!, controller.toTime!)
                              : 'Выберите время',
                        ),
                      ],
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () async =>
                          controller.showSecondDateTimePicker(context),
                      child: Text(
                        'Изменить',
                        style: Theme.of(context).textTheme.displaySmall,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ],
            if (controller.toDateTime != null &&
                controller.fromDateTime != null) ...[
              const SizedBox(height: 16),
              buildAmountOfHours(),
            ],
            const SizedBox(height: 5),
            const AppInputFieldLabel(text: 'Водитель', isRequired: true),
            buildWorkersField(),
            const AppInputFieldLabel(text: 'Тип заказа', isRequired: true),
            typeDropDown(),
            const AppInputFieldLabel(text: 'Город', isRequired: true),
            buildCityField(),
            const SizedBox(height: 11),
            const AppInputFieldLabel(text: 'Заголовок', isRequired: true),
            const SizedBox(height: 12),
            AppPrimaryTextField(
              controller: controller.headerController,
              hintText: 'Введите заголовок',
            ),
            const SizedBox(height: 12),
            const AppInputFieldLabel(text: 'Имя клиента', isRequired: true),
            const SizedBox(height: 12),
            AppPrimaryTextField(
              controller: controller.clientNameController,
              hintText: 'Имя клиента',
            ),
            const SizedBox(height: 12),
            const AppInputFieldLabel(
                text: 'Номер телефона клиента', isRequired: true),
            const SizedBox(height: 12),
            AppPrimaryTextField(
              controller: controller.clientPhoneController,
              hintText: 'Номер клиента',
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
            const AppInputFieldLabel(text: 'Цена', isRequired: true),
            const SizedBox(height: 16),
            PriceTextField(
              priceController: controller.priceController,
              onEndEditing: (value) {
                controller.setPrice(value);
              },
            ),
            if (controller.toDateTime != null &&
                controller.fromDateTime != null &&
                controller.priceController.text.isNotEmpty) ...[
              const SizedBox(height: 16),
              buildTotalPrice(),
            ],
            const SizedBox(height: 16),
            Row(
              children: [
                const AppInputFieldLabel(
                    text: 'Фото объекта', isRequired: false),
                const SizedBox(width: 22),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 10),
                      minimumSize: Size.zero),
                  onPressed: () async {
                    if (controller.selectedImages.length - 1 < 5) {
                      File? selectedImage =
                          await ImageService.pickImage(context);
                      if (selectedImage != null) {
                        setState(() {
                          controller.selectedImages.add(selectedImage.path);
                        });
                      }
                    } else {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text('Достигнут максимальный предел'),
                            content: const Text(
                                'Вы можете выбрать до 5 изображений.'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  // Navigator.pop(context);
                                  context.pop();
                                },
                                child: const Text('OK'),
                              ),
                            ],
                          );
                        },
                      );
                    }
                  },
                  child: const Icon(Icons.upload_outlined, color: Colors.black),
                ),
              ],
            ),
            (controller.selectedImages.isNotEmpty &&
                    controller.selectedImages.length > 1)
                ? GridView.builder(
                    itemCount: controller.selectedImages.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 8.0,
                            mainAxisSpacing: 4.0),
                    itemBuilder: (BuildContext context, int index) {
                      return (controller.selectedImages[index] ==
                              'place_holder')
                          ? InkWell(
                              onTap: () async {
                                if (controller.selectedImages.length - 1 < 5) {
                                  File? selectedImage =
                                      await ImageService.pickImage(context);
                                  if (selectedImage != null) {
                                    setState(() {
                                      controller.selectedImages
                                          .add(selectedImage.path);
                                    });
                                  }
                                } else {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: const Text(
                                            'Достигнут максимальный предел'),
                                        content: const Text(
                                            'Вы можете выбрать до 5 изображений.'),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              // Navigator.pop(context);
                                              context.pop();
                                            },
                                            child: const Text('OK'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                }
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(4.0),
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  height: 90,
                                  child: Center(
                                    child: Icon(
                                      Icons.add,
                                      size: 28.0,
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : Stack(
                              clipBehavior: Clip.none,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(4.0),
                                  child: Image.file(
                                    File(controller.selectedImages[index]),
                                    fit: BoxFit.fitHeight,
                                    width: MediaQuery.of(context).size.width,
                                    height: 110,
                                    filterQuality: FilterQuality.low,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height: 110,
                                        color: Colors.black,
                                      );
                                    },
                                  ),
                                ),
                                Positioned(
                                  bottom: 15,
                                  right: 8,
                                  child: InkWell(
                                    onTap: () async {
                                      controller.selectedImages.removeAt(index);
                                      setState(() {});
                                    },
                                    child: const CircleAvatar(
                                      radius: 15.0,
                                      backgroundColor: Colors.black45,
                                      child: Icon(
                                        Icons.delete_forever,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            );
                    },
                  )
                : const SizedBox(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 30),
              child: AppPrimaryButtonWidget(
                onPressed: () async {
                  if (isValidForm()) {
                    AppDialogService.showLoadingDialog(context);
                    try {
                      await controller.uploadAdClient();
                      if (!context.mounted) return;
                      // Navigator.pop(context);
                      context.pop();
                      showSuccessDialog(context);
                    } catch (e) {
                      if (!context.mounted) return;
                      // Navigator.pop(context);
                      context.pop();
                      AppDialogService.showNotValidFormDialog(
                          context, 'Произошла ошибка. Попробуйте позднее.');
                    }
                  } else {
                    AppDialogService.showNotValidFormDialog(context);
                  }
                },
                textColor: Colors.white,
                text: 'Сохранить заказ',
              ),
            ),
          ],
        ),
      );
    });
  }

  bool isValidForm() {
    return controller.address?.isNotEmpty == true &&
        controller.price.isNotEmpty &&
        // controller.descriptionController.text.isNotEmpty &&
        controller.headerController.text.isNotEmpty &&
        controller.selectedWorker != null &&
        // controller.selectedSubCategory != null &&
        controller.fromDateTime != null &&
        controller.serviceType != null;
  }

  Container _buildDateTimePick(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: AppColors.appFormFieldFillColor,
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AppInputFieldLabel(
                    text: 'Время начала работы', isRequired: true),
                const SizedBox(height: 5),
                Text(
                  controller.fromDate != null
                      ? DateTimeUtils.formatDateTimeLabel(
                          controller.fromDate!, controller.fromTime!)
                      : 'Выберите время',
                ),
              ],
            ),
            const Spacer(),
            TextButton(
              onPressed: () async =>
                  controller.showFirstDateTimePicker(context),
              child: Text(
                'Изменить',
                style: Theme.of(context).textTheme.displaySmall,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget typeDropDown() {
    return AppGenericDropdownSearch<ServiceTypeEnum>(
      enabled: true,
      items: const [
        ServiceTypeEnum.MACHINARY,
        ServiceTypeEnum.EQUIPMENT,
        ServiceTypeEnum.CM,
        ServiceTypeEnum.SVM
      ],
      selectedItem: controller.serviceType,
      onChanged: (value) {
        controller.setServiceType(value);
      },
      itemAsString: (value) => getServiceTypeStringFromEnum(value),
      hintText: 'Выберите тип...',
    );
  }

  Widget buildWorkersField() {
    return FutureBuilder<List<User>>(
      future: getWorkersFuture,
      builder: (context, snapshot) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppGenericDropdownSearch<User>(
              enabled: !(snapshot.connectionState == ConnectionState.none ||
                  snapshot.hasError ||
                  snapshot.data == null),
              items: snapshot.data ?? [],
              selectedItem: controller.selectedWorker,
              onChanged: (User? worker) {
                controller.setSelectedWorker(worker);
              },
              itemAsString: (User worker) =>
                  (worker.lastName ?? '') + (' ') + (worker.firstName ?? ''),
              hintText: 'Выберите водителя...',
            ),
          ],
        );
      },
    );
  }

  Widget buildSubCategoryField() {
    return FutureBuilder<List<SubCategory>>(
      future: controller.futureSubCategories,
      builder: (context, snapshot) {
        controller.subCategories = snapshot.data ?? [];
        return AppGenericDropdownSearch<SubCategory>(
            enabled: !snapshot.hasError,
            items: controller.subCategories,
            selectedItem: controller.selectedSubCategory,
            onChanged: (SubCategory? subCategory) {
              controller.setSelectedSubCategory(controller.subCategories
                  .singleWhere((e) => e.name == subCategory?.name));
            },
            itemAsString: (SubCategory subCategory) => subCategory.name ?? '',
            hintText: controller.selectedCategory != null
                ? 'Выберите подкатегорию...'
                : 'Выберите сначала категорию...',
            emptyBuilderText: 'Выберите сначала категорию');
      },
    );
  }

  FutureBuilder<List<City>> buildCityField() {
    return FutureBuilder<List<City>>(
      future: getCitiesFuture,
      builder: (context, snapshot) {
        controller.cities = snapshot.data ?? [];
        return AppGenericDropdownSearch<City>(
          enabled: !snapshot.hasError,
          items: controller.cities,
          selectedItem: controller.selectedCity,
          onChanged: (City? city) {
            controller.setSelectedCity(
                controller.cities.singleWhere((e) => e.name == city?.name));
          },
          itemAsString: (City city) => city.name,
          hintText: 'Введите название города...',
        );
      },
    );
  }

  Widget buildAmountOfHours() {
    return AdBuildAmountOfHours(
        amountHour: controller.calculateHoursDifference().toString());
  }

  Widget buildTotalPrice() {
    return AdTotalPriceWidget(
        totalPrice: ((controller.calculateHoursDifference() ?? 0) *
                int.parse(controller.priceController.text))
            .toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Заказ на сотрудника'),
        ),
        body: _buildBody());
  }
}
