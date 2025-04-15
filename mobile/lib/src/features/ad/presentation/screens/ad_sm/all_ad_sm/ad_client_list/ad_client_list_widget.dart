import 'dart:async';

import 'package:eqshare_mobile/src/core/data/models/category_models/category.dart';
import 'package:eqshare_mobile/src/core/data/models/category_models/sub_category.dart';
import 'package:eqshare_mobile/src/core/presentation/services/app_bottom_sheet_service.dart';
import 'package:eqshare_mobile/src/core/presentation/widgets/app_circular_progress_indicator.dart';
import 'package:eqshare_mobile/src/core/presentation/widgets/app_primary_button.dart';
import 'package:eqshare_mobile/src/core/presentation/widgets/empty_list_widgets/app_empty_list_widget.dart';
import 'package:eqshare_mobile/src/features/ad/presentation/utils/sliver_delegate.dart';
import 'package:eqshare_mobile/src/global_widgets/global_values.dart';

import 'package:eqshare_mobile/src/features/ad/presentation/widgets/ad_list_tools_block.dart';
import 'package:eqshare_mobile/src/features/ad/presentation/widgets/additional_ad_widget_from_main_screen.dart';
import 'package:eqshare_mobile/src/features/ad/presentation/widgets/app_ad_grid_view_widget.dart';
import 'package:eqshare_mobile/src/features/ad/presentation/widgets/app_ad_list_view_widget.dart';
import 'package:eqshare_mobile/src/features/ad/presentation/widgets/pinned_sliver_header_delegate.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:side_sheet/side_sheet.dart';

import '../../../../../../home/home_controller.dart';
import 'ad_client_list_controller.dart';

class AdClientListWidget extends StatefulWidget {
  final int? subCategoryId;
  final String? subCategoryName;
  final int? typeId;
  final int? cityId;
  final String? typeName;
  final String? selectedServiceType;
  final bool? isBlockType;
  final bool showAdditionalAdWidget;

  const AdClientListWidget(
      {super.key,
      required this.typeId,
      required this.typeName,
      required this.subCategoryId,
      required this.subCategoryName,
      required this.selectedServiceType,
      this.isBlockType,
        this.cityId,
      required this.showAdditionalAdWidget});

  @override
  State<AdClientListWidget> createState() => _AdClientListWidgetState();
}

class _AdClientListWidgetState extends State<AdClientListWidget> {
  @override
  void initState() {
    super.initState();

    // Загружаем данные при инициализации виджета
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final controller = Provider.of<AdClientListController>(context, listen: false);
      controller.setupAds();  // Загрузка данных
    });
  }

  Future<void> _loadTotalCount() async {
    await Provider.of<AdClientListController>(context, listen: false)
        .setupAdsAfterFilter();
  }

  String getAdListToolsBlockTotalLabelFromSelectedServiceType(
      ServiceTypeEnum? serviceTypeEnum) {
    switch (serviceTypeEnum) {
      case ServiceTypeEnum.CM:
        return 'строительных материалов';
      case ServiceTypeEnum.MACHINARY:
        return 'спецтехник';
      case ServiceTypeEnum.EQUIPMENT:
        return 'оборудовании';
      case ServiceTypeEnum.SVM:
        return 'услуг';
      // case ServiceTypeEnum.MACHINARY_RUS : return 'спецтехник';
      // case ServiceTypeEnum.EQUIPMENT_RUS : return 'оборудовании';
      default:
        return 'Заказы ';
    }
  }

  Widget driverOrOwnerAds() {
    return ChangeNotifierProvider.value(
      value: Provider.of<AdClientListController>(context, listen: false),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Consumer<AdClientListController>(
          builder: (context, controller, child) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 6, right: 2),
                  child: Row(
                    children: [
                      Text('Заявки',
                          style: Theme.of(context).textTheme.titleLarge),
                      const Spacer(),
                      TextButton(
                          onPressed: () {
                            AppBottomSheetService.showCreateAdBottomSheet(
                                context: context);
                          },
                          child: DecoratedBox(
                              decoration: BoxDecoration(
                                  color: Colors.orange.shade100,
                                  borderRadius: BorderRadius.circular(8)),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 4, vertical: 2),
                                child: Text('Создать объявление',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                            fontWeight: FontWeight.w300)),
                              )))
                    ],
                  ),
                ),
                if (controller.isLoading)
                  const SizedBox(
                      height: 200, child: AppCircularProgressIndicator())
                else
                  SizedBox(
                    height: 200,
                    child: GridView.builder(
                      scrollDirection: Axis.horizontal,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, // Количество элементов в одном ряду
                        mainAxisSpacing: 5.0, // Расстояние между строками
                        crossAxisSpacing: 7.0, // Расстояние между элементами
                        childAspectRatio: 0.45, // Соотношение сторон элементов
                      ),
                      itemCount: controller
                          .getAdListRowDataFromSelectedAdServiceType()
                          .length,
                      itemBuilder: (context, index) {
                        final item = controller
                            .getAdListRowDataFromSelectedAdServiceType()[index];
                        return GestureDetector(
                          onTap: () {
                            controller.onAdTap(context, index);
                          },
                          child: AdditionalAdWidgetFromMainScreen(
                              adListRowData: item),
                        );
                      },
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget adListToolsBlock(
      AdClientListController controller, BuildContext context) {
    return ColoredBox(
      color: Colors.white,
      child: AdListToolsBlock(
        title: getAdListToolsBlockTitleFromSelectedServiceType(
            controller.selectedServiceType),
        total: controller.total,
        totalLabel: getAdListToolsBlockTotalLabelFromSelectedServiceType(
            controller.selectedServiceType),
        sortAlgorithm: controller.sortAlgorithmEnum, // <-- Передаем текущий алгоритм сортировки

        onSortTap: () {
          AppBottomSheetService.showSortModal(
            context,
            controller.sortAlgorithm,
                (selectedSort) {
              controller.setSortAlgorithm(selectedSort);
              final homeController = Provider.of<HomeController>(context, listen: false);
              final cityId = homeController.selectedCity?.id ?? 5;

              final sortEnum = SortAlgorithmEnum.values.firstWhere(
                    (e) => e.name == selectedSort,
                orElse: () => SortAlgorithmEnum.descCreatedAt,
              );

              controller.loadSortedAds(sortEnum, cityId); // Вызов метода сортировки
            },
          );
        },


        onFilterTap: () async {
          final result = await SideSheet.right(
              context: context,
              width: MediaQuery.sizeOf(context).width,
              body: StatefulBuilder(builder: (context, newSetState) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    AppBar(
                      leadingWidth: 80,
                      leading: TextButton(
                        onPressed: () {
                          // Navigator.pop(context);
                          controller.setSelectedServiceTypeForChange(
                            controller.selectedServiceType,
                          );
                          context.pop();
                        },
                        child: Text('Отмена',
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.copyWith(
                                    color: Theme.of(context).primaryColor)),
                      ),
                      centerTitle: true,
                      title: const Text('Фильтры'),
                      actions: [
                        TextButton(
                            onPressed: () {
                              controller.initialPriceRangeValues =
                                  const RangeValues(0, 100000);
                              setState(() {});
                              controller.resetFilter(
                                  serviceTypeEnum: widget.showAdditionalAdWidget
                                      ? null
                                      : getServiceTypeEnumFromString(
                                          widget.selectedServiceType));
                              controller.setupAds();
                              context.pop();
                            },
                            child: Text('Сбросить',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(
                                        color: Theme.of(context).primaryColor)))
                      ],
                    ),
                    Expanded(
                      child: Stack(
                        children: [
                          SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(left: 18),
                                  child: Text(
                                    'Тип услуги',
                                    style: TextStyle(
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                if (widget.showAdditionalAdWidget)
                                  Padding(
                                    padding: const EdgeInsets.only(left: 18),
                                    child: Column(
                                      children: [
                                        RadioListTile(
                                          title: const Text('Спецтехника'),
                                          value: ServiceTypeEnum.MACHINARY,
                                          groupValue: controller
                                              .selectedServiceTypeForChange,
                                          onChanged: (value) async {
                                            controller
                                                .setSelectedServiceTypeForChange(
                                                    value!);
                                            controller.category.clear();
                                            controller.subCategory.clear();
                                            await controller.resetFilter(
                                                serviceTypeEnum:
                                                    ServiceTypeEnum.MACHINARY);
                                            newSetState(() {});
                                          },
                                          autofocus: true,
                                        ),
                                        RadioListTile(
                                          title: const Text('Оборудование'),
                                          value: ServiceTypeEnum.EQUIPMENT,
                                          groupValue: controller
                                              .selectedServiceTypeForChange,
                                          onChanged: (value) async {
                                            controller
                                                .setSelectedServiceTypeForChange(
                                                    value!);
                                            controller.category.clear();
                                            controller.subCategory.clear();
                                            await controller.resetFilter(
                                                serviceTypeEnum:
                                                    ServiceTypeEnum.EQUIPMENT);
                                            newSetState(() {});
                                          },
                                        ),
                                        RadioListTile(
                                          title: const Text(
                                              'Строительные материалы'),
                                          value: ServiceTypeEnum.CM,
                                          groupValue: controller
                                              .selectedServiceTypeForChange,
                                          onChanged: (value) async {
                                            controller
                                                .setSelectedServiceTypeForChange(
                                                    ServiceTypeEnum.CM);
                                            controller.category.clear();
                                            controller.subCategory.clear();
                                            await controller.resetFilter(
                                                serviceTypeEnum:
                                                    ServiceTypeEnum.CM);
                                            newSetState(() {});
                                          },
                                          autofocus: false,
                                        ),
                                        RadioListTile(
                                          title: const Text('Услуги'),
                                          value: ServiceTypeEnum.SVM,
                                          groupValue: controller
                                              .selectedServiceTypeForChange,
                                          onChanged: (value) async {
                                            controller
                                                .setSelectedServiceTypeForChange(
                                                    ServiceTypeEnum.SVM);
                                            controller.category.clear();
                                            controller.subCategory.clear();
                                            await controller.resetFilter(
                                                serviceTypeEnum:
                                                    ServiceTypeEnum.SVM);
                                            newSetState(() {});
                                          },
                                          autofocus: false,
                                        ),
                                      ],
                                    ),
                                  ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 18),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      allMainCategoryDropDownButton(
                                          context, controller, newSetState),
                                      allSubCategoryDropDownButton(
                                          context, controller, newSetState),
                                    ],
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.only(left: 18),
                                  child: Text(
                                    'Цена',
                                    style: TextStyle(
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 6.0),
                                  child: RangeSlider(
                                    activeColor: Colors.orange,
                                    values: controller.priceRangeValues,
                                    min: controller
                                        .initialPriceRangeValues.start,
                                    max: controller.initialPriceRangeValues.end,
                                    onChanged: (RangeValues values) {
                                      controller.setPriceRangeValues(values);
                                      newSetState(() {});
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
                                      Text(
                                        '${controller.priceRangeValues.start.toInt()}',
                                        style: const TextStyle(
                                          color: Colors.black,
                                        ),
                                      ),
                                      Text(
                                        '${controller.priceRangeValues.end.toInt()}',
                                        style: const TextStyle(
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // for (Parameter param in controller.parameters)
                                //   ParameterTextField(
                                //     param: param,
                                //     controller: controller,

                                //   ),
                                const SizedBox(height: 80)
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
                                  Navigator.pop(context, true);
                                  // context.pop();
                                  controller.setupAds();  // Или loadSortedAds, если нужно

                                },
                                textColor: Colors.white,

                                text: 'Показать результаты',
                                // 'Показать результаты ${totalCount}',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }));

          if (result == true) {
            _loadTotalCount();

            // if (context.mounted) {
            //   await Provider.of<AdClientListController>(context,
            //           listen: false)
            //       .setupAds(context);

            // }
          }
        },
        onViewTap: () {
          controller.setIsBlockView(!controller.isBlockView);
          setState(() {});
        },
        isBlockType: controller.isBlockView,
      ),
    );
  }

  Widget allSubCategoryDropDownButton(BuildContext context,
      AdClientListController controller, StateSetter newSetStater) {
    if (controller.subCategory.isEmpty) {
      return SizedBox(
          width: MediaQuery.of(context).size.width * 0.6,
          child: DropdownButton<SubCategory>(
              isExpanded: true,
              borderRadius: BorderRadius.circular(10),
              underline: const Divider(color: Colors.black38),
              dropdownColor: Theme.of(context).scaffoldBackgroundColor,
              value: SubCategory(name: 'Все подкатегории', id: 0),
              items: [SubCategory(name: 'Все подкатегории', id: 0)]
                  .map<DropdownMenuItem<SubCategory>>((value) {
                return DropdownMenuItem<SubCategory>(
                  value: value,
                  child: Text(
                    value.name!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              }).toList(),
              onChanged: (value) {}));
    }

    final List<SubCategory> dropDown =
        (controller.subCategory).toSet().toList();

    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.6,
      child: DropdownButton<SubCategory>(
        isExpanded: true,
        borderRadius: BorderRadius.circular(10),
        underline: const Divider(color: Colors.black38),
        dropdownColor: Theme.of(context).scaffoldBackgroundColor,
        value: controller.selectedSubCategoryModel,
        items: (dropDown).map<DropdownMenuItem<SubCategory>>((value) {
          return DropdownMenuItem<SubCategory>(
            value: value,
            child: Text(
              value.name!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          );
        }).toList(),
        onChanged: (value) {
          controller.selectedSubCategoryModel = value;
          controller.changeSubCategory(value);
          // _loadTotalCount();
          newSetStater(() {});
        },
      ),
    );
  }

  Widget allMainCategoryDropDownButton(BuildContext context,
      AdClientListController controller, StateSetter newSetStater) {
    if (controller.category.isEmpty) {
      return SizedBox(
          width: MediaQuery.of(context).size.width * 0.6,
          child: DropdownButton<Category>(
              isExpanded: true,
              borderRadius: BorderRadius.circular(10),
              underline: const Divider(color: Colors.black38),
              dropdownColor: Theme.of(context).scaffoldBackgroundColor,
              value: Category(name: 'Все категории', id: 0),
              items: [Category(name: 'Все категории', id: 0)]
                  .map<DropdownMenuItem<Category>>((value) {
                return DropdownMenuItem<Category>(
                  value: value,
                  child: Text(
                    value.name!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              }).toList(),
              onChanged: (value) {}));
    }
    final List<Category> dropDown = (controller.category).toSet().toList();

    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.6,
      child: DropdownButton<Category>(
        isExpanded: true,
        dropdownColor: Theme.of(context).scaffoldBackgroundColor,
        value: dropDown
            .firstWhere((e) => controller.selectedCategoryModel?.id == e.id),
        borderRadius: BorderRadius.circular(10),
        underline: const Divider(color: Colors.black38),
        items: dropDown.map<DropdownMenuItem<Category>>((value) {
          return DropdownMenuItem<Category>(
            value: value,
            child: Text(
              '${value.name!}  ',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          );
        }).toList(),
        onChanged: (value) async {
          controller.changeCategory(value, context);
          await controller.fetchAllSubCategory(value?.id, context);
          newSetStater(() {});
        },
      ),
    );
  }

  Timer? _debounce;

  @override
  Widget build(BuildContext context) {
    return Consumer<AdClientListController>(
        builder: (context, controller, child) {
      if (controller.isLoading) {
        return const AppCircularProgressIndicator();
      } else {
        return NotificationListener<ScrollNotification>(
          onNotification: (scrollInfo) {
            final homeController = Provider.of<HomeController>(context, listen: false);
            final cityId = homeController.selectedCity?.id ?? 5;

            final isPixelEnd =
                scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent;
            final currentLength =
                controller.getAdListRowDataFromSelectedAdServiceType().length;
            final total = controller.total;
            final isTotal = currentLength < total;
            final isNeedUpdate = isPixelEnd && isTotal;

            if (currentLength >= total) {
              return true;
            }
            if (isNeedUpdate) {
              controller.setIsLoadingPaginator();
              if (_debounce?.isActive ?? false) _debounce!.cancel();
              _debounce = Timer(const Duration(milliseconds: 300), () {
                controller.loadMoreData(cityId);
              });
            }

            return true;
          },
          child: CustomScrollView(
            slivers: [
              // if (widget.showAdditionalAdWidget)
              //   SliverToBoxAdapter(child: driverOrOwnerAds()),
              SliverPersistentHeader(
                  pinned: true,
                  floating: true,
                  delegate: PinnedSliverHeaderDelegate(
                      maxHeight: MediaQuery.of(context).size.height * 0.1,
                      minHeight: MediaQuery.of(context).size.height * 0.08,
                      child: adListToolsBlock(controller, context))),
              if (controller.isContentEmpty)
                const SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: AppAdEmptyListWidget(),
                  ),
                ),
              if (!controller.isBlockView && !controller.isContentEmpty)
                SliverList.builder(
                    itemCount: controller
                        .getAdListRowDataFromSelectedAdServiceType()
                        .length,
                    itemBuilder: (context, index) {
                      final ad = controller
                          .getAdListRowDataFromSelectedAdServiceType()[index];
                      return AppAdItem(
                        onTap: () {
                          controller.onAdTap(context, index);
                        },
                        adListRowData: ad,
                      );
                    }),
              if (controller.isBlockView && !controller.isContentEmpty)
                SliverPadding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                    sliver: SliverGrid(
                      gridDelegate: SliverDelegate()
                          .sliverGridDelegateWithFixedCrossAxisCount(),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final ad = controller
                                  .getAdListRowDataFromSelectedAdServiceType()[
                              index];
                          return AppGridViewAdItem(
                            elevation: 0,
                            onTap: () {
                              controller.onAdTap(context, index);
                            },
                            adListRowData: ad,
                          );
                        },
                        childCount: controller
                            .getAdListRowDataFromSelectedAdServiceType()
                            .length,
                      ),
                    )),
              if (controller.isLoadingPaginator)
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.only(top: 16, bottom: 20),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                ),
            ],
          ),
        );
      }
    });
  }
}
