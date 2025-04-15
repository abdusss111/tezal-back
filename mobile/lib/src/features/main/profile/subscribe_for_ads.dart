import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:eqshare_mobile/src/core/data/models/category_models/category.dart';
import 'package:eqshare_mobile/src/core/data/models/category_models/sub_category.dart';
import 'package:eqshare_mobile/src/core/data/models/cities/city/city_model.dart';
import 'package:eqshare_mobile/src/core/data/services/storage/token_provider_service.dart';
import 'package:eqshare_mobile/src/core/presentation/services/app_dialog_service.dart';
import 'package:eqshare_mobile/src/core/presentation/widgets/app_generic_dropdown_search.dart';
import 'package:eqshare_mobile/src/core/res/api_endpoints/api_endpoints.dart';
import 'package:eqshare_mobile/src/core/res/theme/app_colors.dart';
import 'package:eqshare_mobile/src/features/ad/data/repository/ad_api_client.dart';
import 'package:eqshare_mobile/src/features/ad/data/repository/ad_construction_materials_repository.dart';
import 'package:eqshare_mobile/src/features/ad/data/repository/ad_service_repository.dart';

import 'package:eqshare_mobile/src/features/main/profile/subscribe_for_ads_controller.dart';
import 'package:eqshare_mobile/src/global_widgets/global_future_builder.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

enum SubscribeType { adSM, adEQ, adCM, adSVM, city }

class SubscribeForAds extends StatefulWidget {
  const SubscribeForAds({super.key});

  @override
  State<SubscribeForAds> createState() => _SubscribeForAdsState();
}

class _SubscribeForAdsState extends State<SubscribeForAds> {
  final cmRespo = AdConstructionMaterialsRepository();
  final svmRepo = AdServiceRepository();

  final adApi = AdApiClient();

  List<City> selectedCity = [];

  Future<List<dynamic>>? getFuture;
  Future<List<City>?>? getFutureForCity;

  final dio = Dio();

  final controller = SubscribeForAdsController();

  Future<List<Category>> getAdServiceListCategory() async {
    final path = '${ApiEndPoints.baseUrl}/service/category';

    try {
      final response = await dio.get(path);

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['categories'];
        final List<Category> result =
            data.map((e) => Category.fromJson(e)).toList();
        return result;
      }
    } on Exception catch (e) {
      log(e.toString());
    }
    return [];
  }

  Future<List<SubCategory>> getAdServiceListSubCategory(int? categoryID) async {
    final path =
        '${ApiEndPoints.baseUrl}/service/category/${categoryID ?? 0}/sub_category';

    try {
      final response = await dio.get(path);

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['sub_categories'];
        final List<SubCategory> result =
            data.map((e) => SubCategory.fromJson(e)).toList();
        return result;
      }
    } on Exception catch (e) {
      log(e.toString());
    }
    return [];
  }

  @override
  void initState() {
    super.initState();
    getFuture = awaitAllData();
    getFutureForCity = getFutureForCityData();
  }

  Future<List<SubCategory>> getConstructionMaterialListSubCategory(
      {required int? categoryID}) async {
    final path =
        '${ApiEndPoints.baseUrl}/construction_material/category/${categoryID ?? 0}/sub_category';

    try {
      final response = await dio.get(path);

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['sub_categories'];
        final List<SubCategory> result =
            data.map((e) => SubCategory.fromJson(e)).toList();
        return result;
      }
    } on Exception catch (e) {
      log(e.toString());
    }
    return [];
  }

  Future<List<Category>> getAdConstrutionListCategory() async {
    final path = '${ApiEndPoints.baseUrl}/construction_material/category';

    try {
      final response = await dio.get(path);

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['categories'];
        final List<Category> result =
            data.map((e) => Category.fromJson(e)).toList();
        return result;
      }
    } on Exception catch (e) {
      log(e.toString());
    }
    return [];
  }

  Future<List<City>?>? getFutureForCityData() async {
    try {
      final response = await dio.get('${ApiEndPoints.baseUrl}/city');
      if (response.statusCode == 200) {
        final List<dynamic> getCities = response.data['brands'];
        final List<City> getCity =
            getCities.map((e) => City.fromJson(e)).toList();
        return getCity;
      }
    } catch (e) {
      log(e.toString(), name: 'log sfafs  : ');
    }
    return null;
  }

  Future<List<dynamic>> awaitAllData() async {
    final getSMCategory = <Category>[];
    final getSMSubCategory = <SubCategory>[];

    final getEqCategory = <Category>[];
    final getEqSubCategory = <SubCategory>[];

    final getSVMCategory = <Category>[];
    final getSVMSubCategory = <SubCategory>[];

    final getCMCategory = <Category>[];
    final getCMSubCategory = <SubCategory>[];

    List<City>? getCity = [];
    try {
      final List<Category> data = await adApi.getSMCategoryList() ?? [];

      getSMCategory.addAll(data);
    } catch (e) {
      log(e.toString(), name: 'Name error ');
    }

    if (getSMCategory.isNotEmpty) {
      try {
        if (getSMCategory.isNotEmpty) {
          try {
            for (var category in getSMCategory) {
              final List<SubCategory> data =
                  await adApi.getSmSubCategoryList(category.id.toString()) ??
                      [];
              getSMSubCategory.addAll(data);
            }
          } catch (e) {
            // Обработка ошибок при загрузке подкатегорий
            log('Error loading sub-categories: $e');
          }
        }
      } on Exception catch (e) {
        log(e.toString(), name: 'Name error ');
      }
    }

    try {
      final List<Category> data = await adApi.getEqCategoryList() ?? [];

      getEqCategory.addAll(data);
    } catch (e) {
      log(e.toString(), name: 'Name error ');
    }

    if (getEqCategory.isNotEmpty) {
      try {
        if (getEqCategory.isNotEmpty) {
          try {
            for (var category in getEqCategory) {
              final List<SubCategory> data =
                  await adApi.getEqSubCategoryList(category.id.toString()) ??
                      [];
              getEqSubCategory.addAll(data);
            }
          } catch (e) {
            // Обработка ошибок при загрузке подкатегорий
            log('Error loading sub-categories: $e');
          }
        }
      } on Exception catch (e) {
        log(e.toString(), name: 'Name error ');
      }
    }

    try {
      final List<Category> data = await getAdConstrutionListCategory();
      getCMCategory.addAll(data);
    } catch (e) {
      log(e.toString(), name: 'Name error ');
    }

    if (getCMCategory.isNotEmpty) {
      try {
        if (getCMCategory.isNotEmpty) {
          try {
            for (var category in getCMCategory) {
              final List<SubCategory> data =
                  await getConstructionMaterialListSubCategory(
                      categoryID: category.id);
              getCMSubCategory.addAll(data);
            }
          } catch (e) {
            // Обработка ошибок при загрузке подкатегорий
            log('Error loading sub-categories: $e');
          }
        }
      } on Exception catch (e) {
        log(e.toString(), name: 'Name error ');
      }
    }

    try {
      final List<Category> data = await getAdServiceListCategory();

      getSVMCategory.addAll(data);
    } catch (e) {
      log(e.toString(), name: 'Name error ');
    }

    if (getSVMCategory.isNotEmpty) {
      try {
        if (getSVMCategory.isNotEmpty) {
          try {
            for (var category in getSVMCategory) {
              final List<SubCategory> data =
                  await getAdServiceListSubCategory(category.id);
              getSVMSubCategory.addAll(data);
            }
          } catch (e) {
            // Обработка ошибок при загрузке подкатегорий
            log('Error loading sub-categories: $e');
          }
        }
      } on Exception catch (e) {
        log(e.toString(), name: 'Name error ');
      }
    }

    try {
      getCity = await getFutureForCityData();
    } on Exception catch (e) {
      log(e.toString(), name: 'Er sad sa; ');
    }

    return [
      getSMSubCategory,
      getEqSubCategory,
      getCity,
      getCMSubCategory,
      getSVMSubCategory
    ];
  }

  Future<bool> subscribeForEQ(List<int> ids) async {
    final url = '${ApiEndPoints.baseUrl}/subscription/ad/eq_client';
    try {
      final token = await TokenService().getToken();

      final response = await dio.post(url,
          data: {
            "city_id": selectedCity.map((e) => e.id).toList(),
            "sub_category_id": List<int>.from(ids)
          },
          options: Options(headers: {'Authorization': 'Bearer $token'}));

      if (response.statusCode == 200) {
        log('Was success');
        return true;
      }
    } on Exception catch (e) {
      log(e.toString(), name: 'Errors on ds : ');
    }
    return false;
  }

  Future<bool> subscribeForCM(List<int> ids) async {
    final url = '${ApiEndPoints.baseUrl}/subscription/ad/cm_client';
    try {
      final token = await TokenService().getToken();

      final response = await dio.post(url,
          data: {
            "city_id": selectedCity.map((e) => e.id).toList(),
            "sub_category_id": List<int>.from(ids)
          },
          options: Options(headers: {'Authorization': 'Bearer $token'}));

      if (response.statusCode == 200) {
        log('Was success');
        return true;
      }
    } on Exception catch (e) {
      log(e.toString(), name: 'Errors on ds : ');
    }
    return false;
  }

  Future<bool> subscribeForSVC(List<int> ids) async {
    final url = '${ApiEndPoints.baseUrl}/subscription/ad/svc_client';
    try {
      final token = await TokenService().getToken();

      final response = await dio.post(url,
          data: {
            "city_id": selectedCity.map((e) => e.id).toList(),
            "sub_category_id": List<int>.from(ids)
          },
          options: Options(headers: {'Authorization': 'Bearer $token'}));

      if (response.statusCode == 200) {
        log('Was success');
        return true;
      }
    } on Exception catch (e) {
      log(e.toString(), name: 'Errors on ds : ');
    }
    return false;
  }

  Future<bool> subscribeForSM(List<int> ids) async {
    final url = '${ApiEndPoints.baseUrl}/subscription/ad/sm_client';
    try {
      final token = await TokenService().getToken();

      final response = await dio.post(url,
          data: {
            "city_id": selectedCity.map((e) => e.id).toList(),
            "sub_category_id": List<int>.from(ids)
          },
          options: Options(headers: {'Authorization': 'Bearer $token'}));

      if (response.statusCode == 200) {
        log('Was success');
        return true;
      }
    } on Exception catch (e) {
      log(e.toString(), name: 'Errors on ds : ');
    }
    return false;
  }

  Widget newMultipleChoise(
      {required List<SubCategory> items,
      required List<SubCategory> selectedItems,
      required SubscribeType subscribeType}) {
    return AppGenericDropdownSearch<SubCategory>(
      enabled: items.isNotEmpty,
      isMultiple: true,
      selectedItems: selectedItems,
      onChangedForMultiple: (value) {
        log('Start func');
        if (value != null) {
          if (subscribeType == SubscribeType.adEQ) {
            controller.adForEQList(value);
          } else if (subscribeType == SubscribeType.adSM) {
            controller.adForSMList(value);
          } else if (subscribeType == SubscribeType.adCM) {
            controller.adForCmList(value);
          } else {
            controller.adForSVMList(value);
          }
        }
        log('End func and value : $value', name: 'Check');
      },
      items: items,
      selectedItem: selectedItems.isNotEmpty ? selectedItems.last : null,
      onChanged: (value) {
        if (value != null) {
          if (subscribeType == SubscribeType.adEQ) {
            controller.adForEQ(value);
          } else if (subscribeType == SubscribeType.adSM) {
            controller.adForSM(value);
          } else if (subscribeType == SubscribeType.adCM) {
            controller.adForCm(value);
          } else {
            controller.adForSVM(value);
          }
        } else {
          log('message for when value is empty');
        }
      },
      itemAsString: (value) => value.name!,
      hintText: 'Выберите категорию',
    );
  }

  Widget newMultipleChoiseCity({
    required List<City> items,
    required List<City> selectedItems,
  }) {
    return AppGenericDropdownSearch<City>(
      enabled: items.isNotEmpty,
      isMultiple: true,
      selectedItems: selectedItems,
      onChangedForMultiple: (value) {
        log('Start func');
        if (value != null) {
          setState(() {
            selectedCity = (value);
          });
        }
        log('End func and value : $value', name: 'Check');
      },
      items: items,
      selectedItem: selectedItems.isNotEmpty ? selectedItems.last : null,
      onChanged: (value) {
        if (value != null) {
          setState(() {
            if (selectedItems.contains(value)) {
              selectedItems.remove(value);
            } else {
              selectedItems.add(value);
            }
          });
        } else {
          log('message for when value is empty');
        }
      },
      itemAsString: (value) => value.name,
      hintText: 'Выберите город',
    );
  }

  DropDownDecoratorProps dropDownDecorationProps() {
    return DropDownDecoratorProps(
      baseStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
      dropdownSearchDecoration: InputDecoration(
        fillColor: AppColors.appFormFieldFillColor,
        filled: true,
        hintText: ('' as String?) != null ? null : 'hintText',
        contentPadding: const EdgeInsets.fromLTRB(14, 12, 0, 8),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.appDropdownBorderColor),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.appDropdownBorderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.appDropdownBorderColor),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text('Подписка на объявления'),
        centerTitle: true,
      ),
      body: GlobalFutureBuilder<List<dynamic>>(
        future: getFuture!,
        buildWidget: (data) {
          final smSubCategories = data[0] as List<SubCategory>;
          final eqSubCategories = data[1] as List<SubCategory>;
          final city = data[2] as List<City>;
          final cmSubCategories = data[3] as List<SubCategory>;
          final svmSubCategories = data[4] as List<SubCategory>;

          return Consumer<SubscribeForAdsController>(
              builder: (context, contoller, child) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, top: 8.0),
                  child: Text(
                    'Выберите города для отслеживания:',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
                newMultipleChoiseCity(
                  items: city,
                  selectedItems: selectedCity,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text('Для специализированных машин: ',
                      style: Theme.of(context).textTheme.bodyLarge),
                ),
                newMultipleChoise(
                    items: smSubCategories,
                    selectedItems: controller.selectedSMSubCategory,
                    subscribeType: SubscribeType.adSM),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text('Для оборудовании:',
                      style: Theme.of(context).textTheme.bodyLarge),
                ),
                newMultipleChoise(
                    items: eqSubCategories,
                    selectedItems: controller.selectedEQSubCategory,
                    subscribeType: SubscribeType.adEQ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text('Для строительных материалов:',
                      style: Theme.of(context).textTheme.bodyLarge),
                ),
                newMultipleChoise(
                    items: cmSubCategories,
                    selectedItems: controller.selectedCMSubCategory,
                    subscribeType: SubscribeType.adCM),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text('Для услуг:',
                      style: Theme.of(context).textTheme.bodyLarge),
                ),
                newMultipleChoise(
                    items: svmSubCategories,
                    selectedItems: controller.selectedSMSubCategory,
                    subscribeType: SubscribeType.adSVM),
              ],
            );
          });
        },
      ),
      floatingActionButton: ElevatedButton(
          child: const Text('Подтвердить'),
          onPressed: () async {
            final isEmty = controller.selectedEQSubCategory.isEmpty &&
                controller.selectedSMSubCategory.isEmpty &&
                controller.selectedCMSubCategory.isEmpty &&
                controller.selectedSVMSubCategory.isEmpty;
            if (isEmty) {
              AppDialogService.showNotValidFormDialog(
                  context, 'Сперва выберите что то!');
              return;
            }
            AppDialogService.showLoadingDialog(context);
            bool? subscribeForEQValue;
            bool? subscribeForSMValue;
            bool? subscribeForCMValue;
            bool? subscribeForSVMValue;

            if (controller.selectedEQSubCategory.isNotEmpty) {
              subscribeForEQValue = await subscribeForEQ(controller
                  .selectedEQSubCategory
                  .map((value) => (value.id ?? 0))
                  .toList());
            }
            if (controller.selectedSMSubCategory.isNotEmpty) {
              subscribeForSMValue = await subscribeForSM(controller
                  .selectedSMSubCategory
                  .map((value) => (value.id ?? 0))
                  .toList());
            }
            if (controller.selectedCMSubCategory.isNotEmpty) {
              subscribeForCMValue = await subscribeForCM(controller
                  .selectedCMSubCategory
                  .map((value) => (value.id ?? 0))
                  .toList());
            }
            if (controller.selectedSVMSubCategory.isNotEmpty) {
              subscribeForSVMValue = await subscribeForSVC(controller
                  .selectedSVMSubCategory
                  .map((value) => (value.id ?? 0))
                  .toList());
            }
            bool isSubscribedSuccessfully =
                (controller.selectedEQSubCategory.isNotEmpty &&
                        subscribeForEQValue == true) ||
                    (controller.selectedSMSubCategory.isNotEmpty &&
                        subscribeForSMValue == true);
            (controller.selectedCMSubCategory.isNotEmpty &&
                    subscribeForCMValue == true) ||
                (controller.selectedSVMSubCategory.isNotEmpty &&
                    subscribeForSVMValue == true);

            if (isSubscribedSuccessfully) {
              if (context.mounted) {
                context.pop();
                AppDialogService.showSuccessDialog(context,
                    title: 'Успешно подписано', onPressed: () {
                  context.pop();
                }, buttonText: 'Назад');
              }
            }
          }),
    );
  }
}
