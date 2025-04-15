import 'package:eqshare_mobile/src/core/data/models/brand/brand.dart';
import 'package:eqshare_mobile/src/core/data/models/categories_params/categories_params.dart';
import 'package:eqshare_mobile/src/core/data/models/category_models/sub_category.dart';
import 'package:eqshare_mobile/src/core/data/models/cities/city/city_model.dart';
import 'package:eqshare_mobile/src/core/presentation/routing/app_route.dart';
import 'package:eqshare_mobile/src/features/ad/presentation/screens/ad_create_global_widgets/ad_create_global_widgets.dart';

import 'package:eqshare_mobile/src/features/ad/presentation/screens/ad_create_global_widgets/pick_images_when_redact_ad.dart';
import 'package:eqshare_mobile/src/features/ad/presentation/screens/ad_create_global_widgets/single_selection_category_drop_down_button_with_search.dart';
import 'package:eqshare_mobile/src/features/ad/presentation/screens/ad_create_global_widgets/single_selection_sub_category_drop_down_button_with_search.dart';
import 'package:eqshare_mobile/src/features/ad/presentation/screens/ad_sm/my_ad_sm/ad_sm_create/ad_sm_parameters/ad_sm_parameters_screen.dart';

import 'package:eqshare_mobile/src/features/ad/presentation/screens/ad_sm/my_ad_sm/my_ad_sm_detail/edit_my_ad_sm_detail_controller.dart';

import 'package:eqshare_mobile/src/features/ad/presentation/widgets/get_widget.dart';
import 'package:eqshare_mobile/src/core/presentation/widgets/get_core_widgets.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditMyAdSmDetailScreen extends StatefulWidget {
  const EditMyAdSmDetailScreen({super.key});

  @override
  State<EditMyAdSmDetailScreen> createState() => _EditMyAdSmDetailScreenState();
}

class _EditMyAdSmDetailScreenState extends State<EditMyAdSmDetailScreen> {
  late EditMyAdSmDetailController controller;

  @override
  void initState() {
    super.initState();
    controller = Provider.of<EditMyAdSmDetailController>(context, listen: false)
      ..init();
  }

  @override
  void dispose() {
    controller.descriptionController.dispose();
    controller.headerController.dispose();
    controller.priceController.dispose();
    super.dispose();
  }

  Widget buildImagesField(BuildContext context) {
    return PickImagesWhenRedactAd(
      networkImages: controller.selectedNetworkImages,
      inputFieldLabelText: 'Фото спецтехники',
      selectedImagesLength: controller.selectedImages.length,
      selectedImages: controller.selectedImages,
      onImagePicked: (url) {
        controller.selectedImages.add(url);
        controller.notifyListeners();
      },
      onImageRemoved: (index) {
        controller.selectedImages.removeAt(index);
        controller.notifyListeners();
      },
      onNetworkImageRemoved: (index) {
        final removedUrl = controller.selectedNetworkImages[index];
        controller.selectedNetworkImages.removeAt(index);
        controller.removedNetworkImages.add(removedUrl); // ✅ Добавляем URL
        controller.notifyListeners();
      },


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
          itemAsString: (City city) => city.name ?? '',
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
          controller.setSelectedPrice(value);
        },
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
        title: const Text('Редактировать'),
        leading: BackButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text('Точно хотите покинуть страницу?',
                      style: Theme.of(context).textTheme.bodyLarge),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Назад'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      child: const Text('Да'),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
      body: Consumer<EditMyAdSmDetailController>(
        builder: (context, controller, child) {
          return Column(
            children: [
              if (controller.isLoading)
                const Expanded(child: AppCircularProgressIndicator())
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
                        ExpansionTile(
                          tilePadding: const EdgeInsets.all(-4),
                          title: const Text('Параметры'),
                          children: controller.getParams
                                  ?.toJson()
                                  .entries
                                  .where((entry) => entry.value != null)
                                  .map((entry) {
                                final category =
                                    controller.categoriesParams?.firstWhere(
                                  (e) =>
                                      e.nameEng ==
                                      controller.camelToSnake(entry.key),
                                  orElse: () => CategoriesParams(id: 0),
                                );
                                if (category?.id == 0) {
                                  return const SizedBox();
                                }

                                return SMParamTextField(
                                    text: category?.name ?? '',
                                    isRequired: true,
                                    value: entry.value.toString(),
                                    hintText: '',
                                    onChanged: (value) {
                                      controller.updateFormData(
                                          entry.key.toString(), value);
                                    });
                              }).toList() ??
                              [],
                        ),
                      ],
                    ),
                  ),
                ),
              if (!controller.isLoading)
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                  child: ApproveCreateAdButton(
                    isValidForm: controller.isValidForm,
                    uploadAdClient: () async {
                      return await controller.submitAdUpdate(); // это вызовет и base, и фото
                    },

                    showSuccessDialogTitleText: 'Успешно изменено',
                    alternativeRoute: AppRouteNames.myAdSMList,
                    buttonTextColor: Colors.white,
                    buttonText: 'Сохранить',
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
