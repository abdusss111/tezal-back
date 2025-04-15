import 'dart:async';
import 'dart:developer';

import 'package:eqshare_mobile/src/core/data/models/category_models/category.dart';
import 'package:eqshare_mobile/src/core/data/models/category_models/sub_category.dart';
import 'package:eqshare_mobile/src/core/data/repositories/user_recently_viewed_ads_repo.dart';

import 'package:eqshare_mobile/src/core/presentation/services/app_bottom_sheet_service.dart';
import 'package:eqshare_mobile/src/core/presentation/services/app_theme_provider.dart';
import 'package:eqshare_mobile/src/core/presentation/widgets/app_circular_progress_indicator.dart';
import 'package:eqshare_mobile/src/core/presentation/widgets/app_primary_button.dart';
import 'package:eqshare_mobile/src/core/presentation/widgets/empty_list_widgets/app_empty_list_widget.dart';
import 'package:eqshare_mobile/src/core/presentation/widgets/page_wrapper.dart';
import 'package:eqshare_mobile/src/features/ad/presentation/utils/sliver_delegate.dart';
import 'package:eqshare_mobile/src/features/ad/presentation/widgets/user_recently_viewed_ads_widget/user_recently_viewed_ads_controller.dart';
import 'package:eqshare_mobile/src/features/ad/presentation/widgets/user_recently_viewed_ads_widget/user_recently_viewed_ads_widget.dart';
import 'package:eqshare_mobile/src/features/home/home_controller.dart';
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

import 'ad_sm_list_controller.dart';

class AdSMListWidget extends StatefulWidget {
  final int? subCategoryId;
  final String? subCategoryName;
  final int? typeId;
  final int? cityId;
  final String? typeName;
  final String? selectedServiceType;
  final bool? isBlockType;
  final bool showAdditionalAdWidget;

  const AdSMListWidget(
      {super.key,
        required this.typeId,
        required this.cityId,
      required this.typeName,
      required this.subCategoryId,
      required this.subCategoryName,
      required this.selectedServiceType,
      this.isBlockType,
      required this.showAdditionalAdWidget});

  @override
  State<AdSMListWidget> createState() => _AdSMListWidgetState();
}


class _AdSMListWidgetState extends State<AdSMListWidget> {
  String getAdListToolsBlockTitleFromSelectedServiceType(
      ServiceTypeEnum? serviceTypeEnum) {
    switch (serviceTypeEnum) {
      case ServiceTypeEnum.CM:
        return 'Строй материалы';
      case ServiceTypeEnum.MACHINARY:
        return 'Спецтехника';
      case ServiceTypeEnum.EQUIPMENT:
        return 'Оборудования';
      case ServiceTypeEnum.SVM:
        return 'Услуги';
      default:
        return 'Заказы ';
    }
  }

  String getAdListToolsBlockTotalLabelFromSelectedServiceType(
      ServiceTypeEnum? serviceTypeEnum) {
    switch (serviceTypeEnum) {
      case ServiceTypeEnum.CM:
        return 'стр материалов';
      case ServiceTypeEnum.MACHINARY:
        return 'спецтехник';
      case ServiceTypeEnum.EQUIPMENT:
        return 'оборудовании';
      case ServiceTypeEnum.SVM:
        return 'услуг';
      default:
        return 'Заказы ';
    }
  }
  //Фильтры
  Widget adListBlock(AdSMListController controller, BuildContext context) {
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

              controller.loadSortedAds(sortEnum, cityId);
            },
          );
        },
        onFilterTap: () async {
          final homeController = Provider.of<HomeController>(context, listen: false);
          final cityId = homeController.selectedCity?.id ?? 5;
          final result = await SideSheet.right(
              width: MediaQuery.sizeOf(context).width,
              body: StatefulBuilder(
                  builder: (BuildContext context, setState) {
                    return showFilterPage(context, controller, setState);
                  }),
              context: context);
          if (result.isNotEmpty) {
            if (context.mounted) {
              await Provider.of<AdSMListController>(context, listen: false)
                  .setupAdsAfterFilter(cityId);
            }
          }
        },
        onViewTap: () {
          controller.setIsBlockView();
        },
        isBlockType: controller.isBlockView,
      ),
    );
  }


  Column showFilterPage(BuildContext context, AdSMListController controller,
      StateSetter setState) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        AppBar(
          leadingWidth: 80,
          leading: TextButton(
            onPressed: () {
              // Navigator.pop(context);
              controller.setselectedServiceTypeForChange(
                  controller.selectedServiceType);
              context.pop([]);
            },
            child: Text('Отмена',
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(color: Theme.of(context).primaryColor)),
          ),
          centerTitle: true,
          title: const Text('Фильтры'),
          actions: [
            TextButton(
                onPressed: () {
                  controller.initialPriceRangeValues =
                      const RangeValues(0, 100000);
                  setState(() {});
                  controller.reset(
                      serviceTypeEnum: getServiceTypeEnumFromString(
                          widget.selectedServiceType));
                  controller.setupAds(
                      serviceTypeEnum: getServiceTypeEnumFromString(
                          widget.selectedServiceType));
                  context.pop();
                },
                child: Text('Сбросить',
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(color: Theme.of(context).primaryColor)))
          ],
        ),
        Expanded(
          child: showFilterBodyStack(controller, context, setState),
        ),
      ],
    );
  }

  Stack showFilterBodyStack(AdSMListController controller, BuildContext context,
      StateSetter setState) {
    return Stack(
      children: [
        SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.showAdditionalAdWidget)
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
                      RadioListTile<ServiceTypeEnum>(
                        title: const Text('Спецтехника'),
                        value: ServiceTypeEnum.MACHINARY,
                        groupValue: controller.selectedServiceTypeForChange,
                        onChanged: (value) async {
                          controller.setselectedServiceTypeForChange(value!);
                          await controller.resetFilter();
                          setState(() {});
                        },
                        autofocus: true,
                      ),
                      RadioListTile<ServiceTypeEnum>(
                        title: const Text('Оборудование'),
                        value: ServiceTypeEnum.EQUIPMENT,
                        groupValue: controller.selectedServiceTypeForChange,
                        onChanged: (value) async {
                          controller.setselectedServiceTypeForChange(value!);
                          await controller.resetFilter();
                          setState(() {});
                        },
                      ),
                      RadioListTile<ServiceTypeEnum>(
                        title: const Text('Строительные материалы'),
                        value: ServiceTypeEnum.CM,
                        groupValue: controller.selectedServiceTypeForChange,
                        onChanged: (value) async {
                          controller.setselectedServiceTypeForChange(value!);
                          await controller.resetFilter();
                          setState(() {});
                        },
                      ),
                      RadioListTile<ServiceTypeEnum>(
                        title: const Text('Услуги'),
                        value: ServiceTypeEnum.SVM,
                        groupValue: controller.selectedServiceTypeForChange,
                        onChanged: (value) async {
                          controller.setselectedServiceTypeForChange(value!);
                          await controller.resetFilter();
                          setState(() {});
                        },
                      ),
                    ],
                  ),
                ),
              Builder(builder: (context) {
                return Padding(
                  padding: const EdgeInsets.only(left: 18),
                  child: Column(
                    children: [
                      allMainCategoryDropDownButton(
                          context, controller, setState),
                      allSubCategoryDropDownButton(
                          context, controller, setState),
                    ],
                  ),
                );
              }),
              const Padding(
                  padding: EdgeInsets.only(left: 18),
                  child: Text('Цена', style: TextStyle(color: Colors.black))),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6.0),
                child: RangeSlider(
                  activeColor: Colors.orange,
                  values: controller.priceRangeValues,
                  min: controller.initialPriceRangeValues.start,
                  max: controller.initialPriceRangeValues.end,
                  onChanged: (RangeValues values) {
                    controller.setPriceRangeValues(values);
                    setState(() {});
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 26.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('${controller.priceRangeValues.start.toInt()}',
                        style: const TextStyle(color: Colors.black)),
                    Text('${controller.priceRangeValues.end.toInt()}',
                        style: const TextStyle(color: Colors.black))
                  ],
                ),
              ),
              // for (var param in controller.parameters)
              //   ParameterTextField(
              //     param: param,
              //     controller: controller,
              //   ),
              const SizedBox(height: 80)
            ],
          ),
        ),
        showFilterResultsButton(context),
      ],
    );
  }

  Widget allSubCategoryDropDownButton(BuildContext context,
      AdSMListController controller, StateSetter newSetStater) {
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
        value: controller.selectedSubCategory,
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
          controller.setSelectedSubCategory(value);
          newSetStater(() {});
        },
      ),
    );
  }

  Widget allMainCategoryDropDownButton(BuildContext context,
      AdSMListController controller, StateSetter newSetStater) {
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
    final List<Category> dropDown = (controller.category).toList();

    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.6,
      child: DropdownButton<Category>(
        isExpanded: true,
        dropdownColor: Theme.of(context).scaffoldBackgroundColor,
        value: controller.category
            .firstWhere((e) => e.id == controller.selectedCategory?.id),
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
          controller.setSelectedCategory(value);
          await controller.fetchAllSubCategory(value?.id, context);
          newSetStater(() {});
        },
      ),
    );
  }

  Align showFilterResultsButton(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        child: AppPrimaryButtonWidget(
          onPressed: () {
            context.pop([true, false]);
          },
          textColor: Colors.white,
          text: 'Показать результаты',
        ),
      ),
    );
  }

  Widget clientRequest(ServiceTypeEnum? serviceTypeEnum) {
    return ChangeNotifierProvider.value(
      value: Provider.of<AdSMListController>(context, listen: false),
      child: Consumer<AdSMListController>(
        builder: (context, controller, child) {
          return PageWrapper(child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 6, right: 2),
                child: Row(
                  children: [
                    Text('Объявление',
                        style: Theme.of(context).textTheme.titleLarge),
                    const Spacer(),
                    TextButton(
                        onPressed: () {
                          AppBottomSheetService.showCreateRequestBottomSheet(
                              context: context);
                        },
                        child: DecoratedBox(
                            decoration: BoxDecoration(
                                color: Colors.orange.shade100,
                                borderRadius: BorderRadius.circular(8)),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 4, vertical: 2),
                              child: Text('Создать заявку',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(fontWeight: FontWeight.w300)),
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
          ));
        },
      ),
    );
  }

  Timer? _debounce;

  @override
  Widget build(BuildContext context) {
    return Consumer<AdSMListController>(builder: (context, controller, child) {
      if (controller.isLoading) {
        return const AppCircularProgressIndicator();
      } else {
        return NotificationListener<ScrollNotification>(
          onNotification: (scrollInfo) {
            final homeController = Provider.of<HomeController>(context, listen: false);
            final cityId = homeController.selectedCity?.id ?? 5;
            final isPixelEnd =
                scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent;
            final isNeedUpdate = isPixelEnd &&
                controller.getAdListRowDataFromSelectedAdServiceType().length <
                    controller.total;

            if (controller.getAdListRowDataFromSelectedAdServiceType().length >=
                controller.total) {
              return true;
            }
            if (isNeedUpdate) {
              controller.setIsLoadingPaginator();
              if (_debounce?.isActive ?? false) _debounce!.cancel();
              _debounce = Timer(const Duration(milliseconds: 500), () {
                controller.loadMoreData(cityId);
              });
            }

            return true;
          },
            child:  CustomScrollView(
            slivers: [
              // if (widget.showAdditionalAdWidget)
              //   SliverToBoxAdapter(
              //       child: ChangeNotifierProvider(
              //     key: controller.uniqueKey,
              //     create: (context) => UserRecentlyViewedAdsController(
              //         userRecentlyViewedList: controller.getRecentlyId),
              //     child: UserRecentlyViewedAdsWidget(
              //       height: 240,
              //       updateWidget: controller.updateKey,
              //     ),
              //   )),
              // if (widget.showAdditionalAdWidget)
              //   SliverToBoxAdapter(
              //       child: clientRequest(controller.selectedServiceType)),
              SliverPersistentHeader(
                  pinned: true,
                  floating: true,
                  delegate: PinnedSliverHeaderDelegate(
                    maxHeight: MediaQuery.of(context).size.height * 0.1,
                    minHeight: MediaQuery.of(context).size.height * 0.08,
                    child: adListBlock(controller, context),
                  )),
              
              if (!controller.isBlockView)
                SliverList.builder(
                    itemCount: controller
                        .getAdListRowDataFromSelectedAdServiceType()
                        .length,
                    itemBuilder: (context, index) {
                      final ad = controller
                          .getAdListRowDataFromSelectedAdServiceType()[index];
                      return AppAdItem(
                        imageBoxFit: BoxFit.contain,
                        onTap: () {
                          controller.onAdTap(context, index);
                        },
                        adListRowData: ad,
                      );
                    })
              else
              SliverPadding(padding: const EdgeInsets.symmetric(horizontal: 16.0),
              sliver: 
                SliverGrid(
                  gridDelegate: SliverDelegate()
                      .sliverGridDelegateWithFixedCrossAxisCount(),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final ad = controller
                          .getAdListRowDataFromSelectedAdServiceType()[index];
                      return AppGridViewAdItem(
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
                if (controller.isContentEmpty)
                const SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: AppAdEmptyListWidget(),
                  ),
                ),
              if (controller.isLoadingPaginator)
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.only(top: 20, bottom: 20),
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
