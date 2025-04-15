import 'dart:io';

import 'package:eqshare_mobile/src/core/data/models/brand/brand.dart';
import 'package:eqshare_mobile/src/core/data/models/category_models/sub_category.dart';
import 'package:eqshare_mobile/src/features/ad/presentation/screens/ad_create_global_widgets/single_selection_category_drop_down_button_with_search.dart';
import 'package:eqshare_mobile/src/features/ad/presentation/screens/ad_create_global_widgets/single_selection_sub_category_drop_down_button_with_search.dart';
import 'package:eqshare_mobile/src/features/ad/presentation/widgets/app_primary_ad_text_field.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../../../../core/data/models/cities/city/city_model.dart';
import '../../../../../../../core/presentation/services/image_picker_service.dart';
import '../../../../../../../core/presentation/widgets/app_form_field_label.dart';
import '../../../../../../../core/presentation/widgets/app_primary_button.dart';
import '../../../../../../../core/presentation/widgets/app_generic_dropdown_search.dart';
import '../../../../widgets/app_location_picker_row_item.dart';
import '../../../../widgets/price_text_field.dart';

import 'ad_sm_create_controller.dart';

class AdSMCreateScreen extends StatefulWidget {
  const AdSMCreateScreen({super.key});

  @override
  State<AdSMCreateScreen> createState() => _AdSMCreateScreenState();
}

class _AdSMCreateScreenState extends State<AdSMCreateScreen> {
  late AdSMCreateController controller;

  @override
  void initState() {
    super.initState();
    controller = Provider.of<AdSMCreateController>(context, listen: false)
      ..init();
  }

  @override
  void dispose() {
    controller.descriptionController.dispose();
    controller.headerController.dispose();
    controller.priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Добавление спецтехники'),
      ),
      body: Consumer<AdSMCreateController>(
        builder: (context, controller, child) {
          return Column(
            children: [
              if (controller.isLoading)
                const Expanded(child: SizedBox())
              else
                Expanded(
                  child: SingleChildScrollView(
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
                        buildBrandField(),
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
                          text: 'Адрес стоянки',
                          isRequired: true,
                        ),
                        const SizedBox(height: 8),
                        AppLocationPickerRowItem(
                          onLocationSelected: controller.handleLocationSelected,
                          selectedAddress: controller.address,
                          hintText: 'Выберите адрес стоянки',
                        ),
                        ...buildPriceField(context),
                      ],
                    ),
                  ),
                ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                child: AppPrimaryButtonWidget(
                  onPressed: () async {
                    controller.handleNextButtonPressed(context);
                  },
                  textColor: Colors.white,
                  text: 'Далее',
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget buildImagesField(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Row(
          children: [
            const AppInputFieldLabel(
                text: 'Фото спецтехники', isRequired: false),
            const SizedBox(width: 22),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  minimumSize: Size.zero),
              onPressed: () async {
                if (controller.selectedImages.length - 1 < 5) {
                  File? selectedImage = await ImageService.pickImage(context);
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
                        content:
                            const Text('Вы можете выбрать до 5 изображений.'),
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
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 8.0,
                    mainAxisSpacing: 4.0),
                itemBuilder: (BuildContext context, int index) {
                  return (controller.selectedImages[index] == 'place_holder')
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
                                    width: MediaQuery.of(context).size.width,
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
      ],
    );
  }

  Widget buildCategoryField() {
    return SingleSelectionCategoryDropDownButtonWithSearch(
        future: controller.getCategory!,
        selectedItem: controller.selectedCategory,
        onChanged: (category) {
          controller.setSelectedCategory(category);
          if (category != null) {
            controller.fetchSubCategories(category.id.toString());
          }
        });
  }

  Widget buildSubCategoryField() {
    return SingleSelectionSubCategoryDropDownButtonWithSearch(
        future: controller.getSubCategory,
        selectedItem: controller.selectedSubCategory,
        onChanged: (SubCategory? subCategory) {
          controller.setSelectedSubCategory(subCategory);
        });
  }

  Widget buildBrandField() {
    return FutureBuilder<List<Brand>>(
      future: controller.fetchBrands(),
      builder: (context, snapshot) {
        controller.brands = snapshot.data ?? [];

        return AppGenericDropdownSearch<Brand>(
          enabled: !snapshot.hasError,
          items: controller.brands,
          selectedItem: controller.selectedBrand,
          onChanged: (Brand? brand) {
            controller.setSelectedBrand(
                controller.brands.singleWhere((e) => e.name == brand?.name));
          },
          itemAsString: (Brand brand) => brand.name ?? '',
          hintText: 'Выберите бренд...',
        );
      },
    );
  }

  Widget buildCityField() {
    return FutureBuilder<List<City>>(
      future: controller.getCities!,
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
          hintText: 'Выберите город...',
        );
      },
    );
  }

  List<Widget> buildPriceField(BuildContext context) {
    return [
      const SizedBox(height: 16),
      const AppInputFieldLabel(text: 'Цена аренды', isRequired: true),
      const SizedBox(height: 16),
      PriceTextField(
        priceController: controller.priceController,
        onEndEditing: (value) {
          controller.setPrice(value);
        },
        initialValue: controller.priceController.text,
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
}
