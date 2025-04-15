import 'dart:developer';

import 'package:eqshare_mobile/app/app_change_notifier.dart';
import 'package:eqshare_mobile/app/app_safe_change_notifier.dart';
import 'package:eqshare_mobile/custom_icons.dart';
import 'package:eqshare_mobile/src/core/presentation/routing/app_route.dart';
import 'package:eqshare_mobile/src/core/presentation/utils/auth_middleware.dart';
import 'package:eqshare_mobile/src/core/presentation/widgets/app_primary_button.dart';
import 'package:eqshare_mobile/src/global_widgets/global_values.dart';
import 'package:eqshare_mobile/src/features/ad/data/repository/ad_api_client.dart';
import 'package:eqshare_mobile/src/features/ad/data/repository/ad_construction_materials_repository.dart';
import 'package:eqshare_mobile/src/features/ad/data/repository/ad_service_repository.dart';
import 'package:eqshare_mobile/src/features/ad/presentation/screens/ad_create_global_widgets/single_selection_category_drop_down_button_with_search.dart';
import 'package:eqshare_mobile/src/features/ad/presentation/screens/ad_create_global_widgets/single_selection_sub_category_drop_down_button_with_search.dart';
import 'package:eqshare_mobile/src/features/ad/presentation/utils/create_ad_or_request_enum.dart';
import 'package:eqshare_mobile/src/features/main/profile/profile_page/profile_controller.dart';
import 'package:eqshare_mobile/src/features/requests/data/repository/request_execution_repository.dart';
import 'package:eqshare_mobile/src/features/requests/presentation/widgets/rate_order_dialog.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:side_sheet/side_sheet.dart';

import 'package:eqshare_mobile/src/core/data/models/category_models/category.dart';
import 'package:eqshare_mobile/src/core/data/models/category_models/sub_category.dart';

class AppBottomSheetService extends AppSafeChangeNotifier {
  static void showSortModal(
      BuildContext context,
      String sortAlgorithm,
      Function(String) onChanged,
      ) {
    showBarModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Выберите тип сортировки',
                  style: Theme.of(context).textTheme.displayMedium),
              const SizedBox(height: 16.0),
              _SortCheckBoxWidget(
                onChanged: (isChecked) {
                  onChanged(SortAlgorithmEnum.ascPrice.name);
                  Navigator.pop(context);
                },
                title: 'По возрастанию цены',
                isChecked: sortAlgorithm == SortAlgorithmEnum.ascPrice.name,
              ),
              _SortCheckBoxWidget(
                title: 'По убыванию цены',
                onChanged: (isChecked) {
                  onChanged(SortAlgorithmEnum.descPrice.name);
                  Navigator.pop(context);
                },
                isChecked: sortAlgorithm == SortAlgorithmEnum.descPrice.name,
              ),
              _SortCheckBoxWidget(
                title: 'По дате (новые сначала)',
                onChanged: (isChecked) {
                  onChanged(SortAlgorithmEnum.descCreatedAt.name);
                  Navigator.pop(context);
                },
                isChecked: sortAlgorithm == SortAlgorithmEnum.descCreatedAt.name,
              ),
              _SortCheckBoxWidget(
                title: 'По дате (старые сначала)',
                onChanged: (isChecked) {
                  onChanged(SortAlgorithmEnum.ascCreatedAt.name);
                  Navigator.pop(context);
                },
                isChecked: sortAlgorithm == SortAlgorithmEnum.ascCreatedAt.name,
              ),
            ],
          ),
        );
      },
    );
  }

  static void showSortModalReturnsSortType(
      BuildContext context,
      SortAlgorithmEnum sortAlgorithm,
      Function(SortAlgorithmEnum) onChanged,
      ) {
    showBarModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Выберите тип сортировки',
                  style: Theme.of(context).textTheme.displayMedium),
              const SizedBox(height: 16.0),
              _SortCheckBoxWidget(
                onChanged: (isChecked) {
                  onChanged(SortAlgorithmEnum.ascPrice);
                  Navigator.pop(context);
                },
                title: 'По возрастанию цены',
                isChecked: sortAlgorithm == SortAlgorithmEnum.ascPrice,
              ),
              _SortCheckBoxWidget(
                title: 'По убыванию цены',
                onChanged: (isChecked) {
                  onChanged(SortAlgorithmEnum.descPrice);
                  Navigator.pop(context);
                },
                isChecked: sortAlgorithm == SortAlgorithmEnum.descPrice,
              ),
              _SortCheckBoxWidget(
                title: 'По дате (новые сначала)',
                onChanged: (isChecked) {
                  onChanged(SortAlgorithmEnum.descCreatedAt);
                  Navigator.pop(context);
                },
                isChecked: sortAlgorithm == SortAlgorithmEnum.descCreatedAt,
              ),
              _SortCheckBoxWidget(
                title: 'По дате (старые сначала)',
                onChanged: (isChecked) {
                  onChanged(SortAlgorithmEnum.ascCreatedAt);
                  Navigator.pop(context);
                },
                isChecked: sortAlgorithm == SortAlgorithmEnum.ascCreatedAt,
              ),
            ],
          ),
        );
      },
    );
  }

  static void showAppCupertinoModalBottomSheet(
      BuildContext context, Widget? widget) {
    showCupertinoModalBottomSheet(
      topRadius: const Radius.circular(28.0),
      context: context,
      builder: (context) => Stack(
        alignment: Alignment.topRight,
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
            child: widget,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 2.0),
            child: IconButton(
              visualDensity: VisualDensity.adaptivePlatformDensity,
              onPressed: () {
                context.pop();
                // Navigator.of(context).pop();
              },
              icon: const Icon(
                CupertinoIcons.clear,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// [start] начальная цена
  /// [end] конечная цена
  /// [category] айди основного категории
  /// [sub_category] айди субкатегории цена
  /// Возвращается с таким порядком
  /// При сбросе отправляетт [empty] длина самого мапа==1
  Future<Map<String, dynamic>> filterSideSheet(
    BuildContext context, {
    required Category? selectedCategory,
    required SubCategory? selectedSubCategory,
    required double rangeValuesStart,
    required double rangeValuesEnd,
    required ServiceTypeEnum adServiceName,
    required void Function(Category?) onChangedCategory,
    required void Function(SubCategory?) onChangedSubCategory,
    required Future<List<Category>> getCategory,
  }) async {
    var uniqueKey = UniqueKey();

    Future<List<SubCategory>>? getAdServiceListSubCategory;

    RangeValues rangeValues = RangeValues(rangeValuesStart, rangeValuesEnd);
    final result = await SideSheet.right(
        width: MediaQuery.sizeOf(context).width,
        body: StatefulBuilder(builder: (context, bigSetState) {
          SubCategory? selectedSubCategory;
          if (selectedCategory != null && selectedCategory!.id != 0) {
            getAdServiceListSubCategory = getSubCategoryFuture(
                adServiceName, getAdServiceListSubCategory, selectedCategory);
          }
          return Column(
            key: uniqueKey,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              AppBar(
                leadingWidth: 80,
                leading: TextButton(
                  onPressed: () {
                    final Map<String, dynamic> data = {};
                    context.pop(data);
                  },
                  child: const Text('Отмена'),
                ),
                centerTitle: true,
                title: const Text('Фильтры'),
                actions: [
                  TextButton(
                      onPressed: () {
                        context.pop({'empty': 'empty'});
                      },
                      child: const Text('Сбросить'))
                ],
              ),
              Expanded(
                child: Stack(
                  children: [
                    SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 18),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SingleSelectionCategoryDropDownButtonWithSearch(
                                  future: getCategory,
                                  selectedItem: selectedCategory,
                                  onChanged: (value) async {
                                    onChangedCategory(value!);
                                    selectedCategory = value;
                                    uniqueKey = UniqueKey();
                                    getAdServiceListSubCategory =
                                        AdServiceRepository()
                                            .getAdServiceListSubCategory(
                                                categoryID:
                                                    selectedCategory?.id);
                                    bigSetState(() {
                                      getAdServiceListSubCategory =
                                          getSubCategoryFuture(
                                              adServiceName,
                                              getAdServiceListSubCategory,
                                              selectedCategory);
                                    });
                                    notifyListeners();
                                  },
                                ),
                                SingleSelectionSubCategoryDropDownButtonWithSearch(
                                  future: getAdServiceListSubCategory,
                                  selectedItem: selectedSubCategory,
                                  onChanged: (value) async {
                                    selectedSubCategory = value;
                                    onChangedSubCategory(value);
                                  },
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 18),
                            child: Text('Цена',
                                style:
                                    Theme.of(context).textTheme.displayMedium),
                          ),
                          StatefulBuilder(builder: (context, setState) {
                            log(rangeValues.toString());
                            return Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 6.0),
                                  child: RangeSlider(
                                    activeColor: Colors.orange,
                                    values: rangeValues,
                                    min: 0,
                                    max: 100000,
                                    onChangeEnd: (value) {},
                                    onChanged: (newValue) {
                                      log('Try to change');
                                      rangeValues = newValue;
                                      setState(() {});
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 26.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(rangeValues.start.toInt().toString(),
                                          style: Theme.of(context)
                                              .textTheme
                                              .displaySmall),
                                      Text('${rangeValues.end.toInt()}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .displaySmall),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          }),
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 20, horizontal: 10),
                        child: AppPrimaryButtonWidget(
                          onPressed: () {
                            context.pop({
                              'start': rangeValues.start,
                              'end': rangeValues.end,
                              'category': selectedCategory?.id,
                              'sub_category': selectedSubCategory?.id
                            });
                          },
                          textColor: Colors.white,
                          text: 'Показать результаты',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        }),
        context: context);

    log(result.toString(), name: 'Result from shade');

    return result as Map<String, dynamic>;
  }

  Future<List<SubCategory>>? getSubCategoryFuture(
      ServiceTypeEnum adServiceName,
      Future<List<SubCategory>>? getAdServiceListSubCategory,
      Category? selectedCategory) {
    switch (adServiceName) {
      case ServiceTypeEnum.MACHINARY:
        getAdServiceListSubCategory = AdApiClient()
            .getSmSubCategoryList((selectedCategory?.id ?? 0).toString());
      case ServiceTypeEnum.EQUIPMENT:
        getAdServiceListSubCategory = AdApiClient()
            .getEqSubCategoryList((selectedCategory?.id ?? 0).toString());
      case ServiceTypeEnum.CM:
        getAdServiceListSubCategory = AdConstructionMaterialsRepository()
            .getConstructionMaterialListSubCategory(
                categoryID: selectedCategory?.id);
      case ServiceTypeEnum.SVM:
        getAdServiceListSubCategory = AdServiceRepository()
            .getAdServiceListSubCategory(categoryID: selectedCategory?.id);
      default:
    }
    return getAdServiceListSubCategory;
  }

  static void showAppMaterialModalBottomSheet(
      BuildContext context, Widget? widget) {
    showMaterialModalBottomSheet(
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28.0)),
      ),
      context: context,
      builder: (context) => Stack(
        alignment: Alignment.topRight,
        children: [
          Padding(
            padding: const EdgeInsets.only(
                right: 16.0, left: 16.0, top: 28.0, bottom: 14.0),
            child: widget,
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
            child: IconButton(
              visualDensity: VisualDensity.adaptivePlatformDensity,
              onPressed: () {
                context.pop();
                // Navigator.of(context).pop();
              },
              icon: const Icon(
                CupertinoIcons.clear,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Future<void> showDialogForRate({
    required String bottomText,
    required BuildContext context,
    required void Function() onPressed,
  })
  // Function rateOrder
  {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return RateOrderDialogFromNotification(
          getRequestExecution: RequestExecutionRepository()
              .getRequestExecutionDetail(requestID: '404'),
          requestID: '404',
          rateOrder: ({required int rating, required String text}) {
            return Future.delayed(Duration.zero);
          }, // Ensure correct type
        );
      },
    );
  }

  static Future<void> showCreateAdOrRequestBottomSheet({
    required BuildContext context,
  }) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            child: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Expanded(
                          child: Center(
                              child: Text(
                        'Выберите',
                        style: Theme.of(context).textTheme.titleMedium,
                      ))),
                      IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.close))
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      showCreateAdBottomSheet(context: context);
                    },
                    child: const ListTile(
                      title: Text('Создать объявление'),
                      trailing: Icon(Icons.arrow_right_outlined),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      showCreateRequestBottomSheet(context: context);
                    },
                    child: const ListTile(
                      title: Text('Создать заявку'),
                      trailing: Icon(Icons.arrow_right_outlined),
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

  static Future<void> showCreateAdBottomSheet({
    required BuildContext context,
  }) {
    final divider = Divider(color: Colors.grey.shade300);
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return SingleChildScrollView(
            child:SafeArea(child:
            Column(mainAxisSize: MainAxisSize.min, children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 10, top: 15),
                child: Center(
                  child: Text('Создать объявление',
                      style: Theme.of(context).textTheme.titleLarge),
                ),
              ),
              divider,
              GestureDetector(
                  onTap: () {
                    AuthMiddleware.executeIfAuthenticated(
                        context,
                        () => context.pushNamed(
                            AppRouteNames.createAdSMForDriverOrOwner));
                  },
                  child: ListTile(
                    trailing: const Icon(Icons.arrow_right_outlined),
                    leading: const Icon(CustomIcons.specTech),
                    title: const Text('Спецтехника'),
                    titleTextStyle: Theme.of(context).textTheme.titleSmall,
                  )),
              divider,
              GestureDetector(
                  onTap: () {
                    AuthMiddleware.executeIfAuthenticated(
                        context,
                        () => context.pushNamed(
                            AppRouteNames.createAdEquipmentForDriverOrOwner));
                  },
                  child: ListTile(
                      trailing: const Icon(Icons.arrow_right_outlined),
                      leading: const Icon(CustomIcons.oborud),
                      title: const Text('Оборудование'),
                      titleTextStyle: Theme.of(context).textTheme.titleSmall)),
              divider,
              GestureDetector(
                  onTap: () {
                    AuthMiddleware.executeIfAuthenticated(
                        context,
                        () => context.pushNamed(
                            AppRouteNames.createAdConstructions,
                            extra: {'value': CreateAdOrRequestEnum.ad.name}));
                  },
                  child: ListTile(
                      trailing: const Icon(Icons.arrow_right_outlined),
                      leading: const Icon(CustomIcons.stroyMater),
                      title: const Text('Строительные материалы'),
                      titleTextStyle: Theme.of(context).textTheme.titleSmall)),
              divider,
              GestureDetector(
                  onTap: () {
                    AuthMiddleware.executeIfAuthenticated(
                        context,
                        () => context.pushNamed(AppRouteNames.createAdService,
                            extra: {'value': CreateAdOrRequestEnum.ad.name}));
                  },
                  child: ListTile(
                      trailing: const Icon(Icons.arrow_right_outlined),
                      leading: const Icon(CustomIcons.uslugi),
                      title: const Text('Услуги'),
                      titleTextStyle: Theme.of(context).textTheme.titleSmall)),
              if (AppChangeNotifier().userMode == UserMode.owner) divider,
              if (AppChangeNotifier().userMode == UserMode.owner)
                GestureDetector(
                    onTap: () {
                      AuthMiddleware.executeIfAuthenticated(
                          context,
                          () => context
                              .pushNamed(AppRouteNames.createAdWithoutType));
                    },
                    child: ListTile(
                        trailing: const Icon(Icons.arrow_right_outlined),
                        title: const Text('Без клиента'),
                        leading: const Icon(Icons.person_off_rounded),
                        titleTextStyle:
                            Theme.of(context).textTheme.titleSmall)),
            ]),
          ));
        });
  }

  static Future<void> showCreateRequestBottomSheet({
    required BuildContext context,
  }) {
    final divider = Divider(color: Colors.grey.shade300);
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return SafeArea(child:  Padding(
            padding: EdgeInsets.zero,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 10, top: 15),
                  child: Center(
                    child: Text('Создать заявку',
                        style: Theme.of(context).textTheme.titleLarge),
                  ),
                ),
                divider,
                GestureDetector(
                    onTap: () {
                      AuthMiddleware.executeIfAuthenticated(
                          context,
                          () => context
                              .pushNamed(AppRouteNames.createAdSMForClient));
                    },
                    child: ListTile(
                      trailing: const Icon(Icons.arrow_right_outlined),
                      leading: const Icon(CustomIcons.specTech),
                      title: const Text('Аренда спецтехника'),
                      titleTextStyle: Theme.of(context).textTheme.titleSmall,
                    )),
                divider,
                GestureDetector(
                    onTap: () {
                      AuthMiddleware.executeIfAuthenticated(
                          context,
                          () => (context.pushNamed(
                              AppRouteNames.createAdEquipmentForClient)));
                    },
                    child: ListTile(
                        trailing: const Icon(Icons.arrow_right_outlined),
                        leading: const Icon(CustomIcons.oborud),
                        title: const Text('Аренда оборудование'),
                        titleTextStyle:
                            Theme.of(context).textTheme.titleSmall)),
                divider,
                GestureDetector(
                    onTap: () {
                      AuthMiddleware.executeIfAuthenticated(
                          context,
                          () => context.pushNamed(
                                  AppRouteNames.createAdConstructions,
                                  extra: {
                                    'value': CreateAdOrRequestEnum.request.name
                                  }));
                    },
                    child: ListTile(
                        trailing: const Icon(Icons.arrow_right_outlined),
                        leading: const Icon(CustomIcons.stroyMater),
                        title: const Text('Покупка строительных материалов'),
                        titleTextStyle:
                            Theme.of(context).textTheme.titleSmall)),
                divider,
                GestureDetector(
                    onTap: () {
                      AuthMiddleware.executeIfAuthenticated(
                          context,
                          () => context.pushNamed(AppRouteNames.createAdService,
                                  extra: {
                                    'value': CreateAdOrRequestEnum.request.name
                                  }));
                    },
                    child: ListTile(
                        trailing: const Icon(Icons.arrow_right_outlined),
                        leading: const Icon(CustomIcons.uslugi),
                        title: const Text('Услуга от мастера'),
                        titleTextStyle:
                            Theme.of(context).textTheme.titleSmall)),
              ],
            ),
          ));
        });
  }
}

class _SortCheckBoxWidget extends StatelessWidget {
  final String title;
  final bool isChecked;
  final Function(bool isChecked) onChanged;
  const _SortCheckBoxWidget({
    required this.title,
    required this.isChecked,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return RadioListTile(
      controlAffinity: ListTileControlAffinity.trailing,
      title: Text(title, style: Theme.of(context).textTheme.displaySmall),
      value: true,
      activeColor: Colors.orange,
      onChanged: (bool? value) {
        onChanged(value ?? false);
        context.pop();
        // Navigator.pop(context);
      },
      groupValue: isChecked,
    );
  }
}

class DevelopmentBottomSheetWidget extends StatelessWidget {
  const DevelopmentBottomSheetWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text('Функция в разработке',
                style: Theme.of(context).textTheme.displayMedium),
            const Spacer(),
          ],
        ),
        const SizedBox(height: 28),
        AppPrimaryButtonWidget(
          textColor: Colors.white,
          onPressed: () => context.pop(),
          text: 'Понятно',
        ),
      ],
    );
  }
}
