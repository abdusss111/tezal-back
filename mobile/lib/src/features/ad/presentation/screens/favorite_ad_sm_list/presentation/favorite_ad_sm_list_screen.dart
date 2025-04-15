import 'dart:developer';

import 'package:eqshare_mobile/src/features/ad/data/models/ad_equipment_models/ad_equipment_model/ad_equipment.dart';
import 'package:eqshare_mobile/src/features/ad/data/models/ad_sm_models/ad_sm_model/ad_specialized_machinery.dart';
import 'package:eqshare_mobile/src/features/ad/data/repository/ad_api_client.dart';
import 'package:eqshare_mobile/src/core/presentation/routing/app_route.dart';
import 'package:eqshare_mobile/src/core/presentation/widgets/empty_list_widgets/app_empty_list_widget.dart';
import 'package:eqshare_mobile/src/features/ad/data/classes/ad_list_row_data.dart';
import 'package:eqshare_mobile/src/features/ad/data/models/ad_contruction_models/ad_construction_model/ad_constrution_model.dart';

import 'package:eqshare_mobile/src/features/ad/data/models/ad_service_models/ad_service_model/ad_service_model.dart';

import 'package:eqshare_mobile/src/features/ad/presentation/widgets/app_ad_grid_view_widget.dart';
import 'package:eqshare_mobile/src/features/ad/presentation/widgets/app_ad_list_view_widget.dart';
import 'package:eqshare_mobile/src/features/requests/presentation/widgets/listenable_tab_controller.dart';
import 'package:eqshare_mobile/src/features/requests/presentation/widgets/tab_with_total.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class FavoriteAdSMListScreen extends StatefulWidget {
  const FavoriteAdSMListScreen({super.key});

  @override
  State<FavoriteAdSMListScreen> createState() => _FavoriteAdSMListScreenState();
}

class _FavoriteAdSMListScreenState extends State<FavoriteAdSMListScreen> {
  UniqueKey _futureBuilderKey = UniqueKey();

  AdListRowData makeRowDataFromEquipment(AdEquipment ad) {
    return AdEquipment.getAdListRowDataFromSM(ad);
  }

  AdListRowData makeRowDataFromMachine(AdSpecializedMachinery ad) {
    return AdSpecializedMachinery.getAdListRowDataFromSM(ad);
  }

  AdListRowData makeRowDataFromCM(AdConstrutionModel ad) {
    return AdConstrutionModel.getAdListRowDataFromSM(ad);
  }

  AdListRowData makeRowDataFromSvm(AdServiceModel ad) {
    return AdServiceModel.getAdListRowDataFromSM(ad);
  }

  Future<List<List<AdListRowData>>> getAllData() async {
    try {
      AdApiClient adApiClient = AdApiClient();

      final dataAdSpecializedMachinery =
          await adApiClient.getFavoriteAdSpecializedMachinery();
      final dataAdEquipment = await adApiClient.aliGetFavoriteAdEquipment();
      final cm = await adApiClient.aliGetFavoriteCm();
      final svm = await adApiClient.aliGetFavoriteSVM();

      final finalDataWithMachine = <AdListRowData>[];
      final finalDataWithEquipment = <AdListRowData>[];
      final cmL = <AdListRowData>[];
      final svmL = <AdListRowData>[];

      for (var item in dataAdSpecializedMachinery ?? []) {
        finalDataWithMachine.add(makeRowDataFromMachine(item));
      }
      for (var element in dataAdEquipment ?? []) {
        finalDataWithEquipment.add(makeRowDataFromEquipment(element));
      }

      for (var item in cm ?? []) {
        cmL.add(makeRowDataFromCM(item));
      }
      for (var element in svm ?? []) {
        svmL.add(makeRowDataFromSvm(element));
      }

      return [finalDataWithMachine, finalDataWithEquipment, cmL, svmL];
    } on Exception catch (e) {
      log(e.toString());
      return [];
    }
  }

  Widget tabBarScreen(List<Widget> children) {
    if (children.isEmpty) {
      return const AppAdEmptyListWidget();
    }
    return SingleChildScrollView(
      child: Column(
        children: children,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableTabController(
      initialIndex: 0,
      length: 4,
      onPageChanged: (int value) {},
      child: Builder(builder: (context) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Избранное'),
            leading: IconButton(
              onPressed: () {
                context.go(
                  '/${AppRouteNames.navigation}',
                  extra: {'index': '4'},
                );
              },
              icon: const Icon(Icons.arrow_back_ios_new),
            ),
            bottom: const TabBar(
              dividerColor: Colors.transparent,

              padding: EdgeInsets.only(left: 10),
              tabAlignment: TabAlignment.start,
              isScrollable: true,
              indicatorSize: TabBarIndicatorSize.tab,
              tabs: [
                TabWithTotal(
                  label: 'Спец машины',
                  total: 0,
                ),
                TabWithTotal(label: 'Оборудование', total: 0),
                TabWithTotal(
                  label: 'Стр материалы',
                  total: 0,
                ),
                TabWithTotal(
                  label: 'Услуги',
                  total: 0,
                ),
              ],
            ),
          ),
          body: FutureBuilder<List<List<AdListRowData>>>(
              key: _futureBuilderKey,
              future: getAllData(),
              builder: (context, snapshot) {
                if (snapshot.data != null && snapshot.data!.isNotEmpty) {
                  final machinary = snapshot.data![0];
                  final equipment = snapshot.data![1];
                  final cm = snapshot.data![2];
                  final svm = snapshot.data![3];

                  if (machinary.isEmpty &&
                      equipment.isEmpty &&
                      cm.isEmpty &&
                      svm.isEmpty) {
                    return const AppAdEmptyListWidget();
                  }
                  return TabBarView(
                    children: [
                      tabBarScreen(machinary
                          .map((element) => AppAdItem(
                              adListRowData: element,
                              onTap: () async {
                                await context.pushNamed(
                                  AppRouteNames.adSMClientDetailFromMyClientAd,
                                  extra: {'id': element.id.toString()},
                                );

                                setState(() {
                                  _futureBuilderKey = UniqueKey();
                                });
                              }))
                          .toList()),
                      tabBarScreen(equipment
                          .map((element) => AppAdItem(
                              onTap: () async {
                                await context.pushNamed(
                                  AppRouteNames
                                      .adEquipmentClientDetailFromClientFavo,
                                  extra: {'id': element.id.toString()},
                                );
                                setState(() {
                                  _futureBuilderKey = UniqueKey();
                                });
                              },
                              adListRowData: element))
                          .toList()),
                      tabBarScreen(cm
                          .map((element) => AppAdItem(
                              onTap: () async {
                                await context.pushNamed(
                                  AppRouteNames.adConstructionDetail,
                                  extra: {'id': element.id.toString()},
                                );
                                setState(() {
                                  _futureBuilderKey = UniqueKey();
                                });
                              },
                              adListRowData: element))
                          .toList()),
                      tabBarScreen(svm
                          .map((element) => AppAdItem(
                              onTap: () async {
                                await context.pushNamed(
                                  AppRouteNames.adServiceDetailScreen,
                                  extra: {'id': element.id.toString()},
                                );
                                setState(() {
                                  _futureBuilderKey = UniqueKey();
                                });
                              },
                              adListRowData: element))
                          .toList())
                    ],
                  );
                } else if (snapshot.hasError) {
                  return const Center(
                      child: Text('Попробуйте позже или обнавите страницу'));
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              }),
        );
      }),
    );
  }
}
