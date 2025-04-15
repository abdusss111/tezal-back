import 'dart:developer';

import 'package:eqshare_mobile/src/core/data/services/storage/token_provider_service.dart';
import 'package:eqshare_mobile/src/core/presentation/routing/app_route.dart';
import 'package:eqshare_mobile/src/core/presentation/widgets/empty_list_widgets/app_empty_list_widget.dart';
import 'package:eqshare_mobile/src/features/ad/data/classes/ad_list_row_data.dart';
import 'package:eqshare_mobile/src/features/ad/data/models/ad_contruction_models/ad_construction_client_model.dart/ad_construction_client_model.dart';
import 'package:eqshare_mobile/src/features/ad/data/models/ad_equipment_models/ad_equipment_client_model/ad_equipment_client.dart';

import 'package:eqshare_mobile/src/features/ad/data/models/ad_service_models/ad_service_client_model/ad_service_client_model.dart';
import 'package:eqshare_mobile/src/features/ad/data/models/ad_sm_models/ad_sm_client_model/ad_client.dart';

import 'package:eqshare_mobile/src/features/ad/data/repository/ad_api_client.dart';
import 'package:eqshare_mobile/src/features/ad/presentation/widgets/app_ad_grid_view_widget.dart';
import 'package:eqshare_mobile/src/features/ad/presentation/widgets/app_ad_list_view_widget.dart';
import 'package:eqshare_mobile/src/features/requests/presentation/widgets/listenable_tab_controller.dart';
import 'package:eqshare_mobile/src/features/requests/presentation/widgets/tab_with_total.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class FavoriteAdClientListScreen extends StatefulWidget {
  const FavoriteAdClientListScreen({super.key});

  @override
  State<FavoriteAdClientListScreen> createState() =>
      _FavoriteAdClientListScreenState();
}

class _FavoriteAdClientListScreenState
    extends State<FavoriteAdClientListScreen> {
  UniqueKey _futureBuilderUniqueKey = UniqueKey();

  Future<String> getToken() async {
    final token = await TokenService().getToken();
    return token ?? '';
  }

  AdListRowData makeRowDataFromEquipment(AdEquipmentClient ad) {
    return AdEquipmentClient.getAdListRowDataFromSM(ad);
  }

  AdListRowData makeRowDataFromCM(AdConstructionClientModel ad) {
    return AdConstructionClientModel.getAdListRowDataFromSM(ad);
  }

  AdListRowData makeRowDataFromSVM(AdServiceClientModel ad) {
    return AdServiceClientModel.getAdListRowDataFromSM(ad);
  }

  AdListRowData makeRowDataFromMachine(AdClient ad) {
    return AdClient.getAdListRowDataFromSM(ad);
  }

  Future<List<List<AdListRowData>>> getFavoriteDriverList() async {
    final adApiClient = AdApiClient();

    final machinary = <AdListRowData>[];
    final equimentList = <AdListRowData>[];
    final cmList = <AdListRowData>[];
    final svmList = <AdListRowData>[];

    try {
      final favoriteADSMListResponse =
          await adApiClient.aliGetFavoriteClientAdSpecializedMachinery();

      final favoriteEquipmentListResponse =
          await adApiClient.aliGetFavoriteClientAdEquipment();
      final favoriteCMListResponse = await adApiClient.aliGetFavoriteClientCM();

      final favoriteSVMListResponse =
          await adApiClient.aliGetFavoriteClientSVM();

      for (var item in favoriteADSMListResponse ?? []) {
        machinary.add(makeRowDataFromMachine(item));
      }
      for (var element in favoriteEquipmentListResponse ?? []) {
        equimentList.add(makeRowDataFromEquipment(element));
      }

      for (var element in favoriteCMListResponse ?? []) {
        cmList.add(makeRowDataFromCM(element));
      }
      for (var element in favoriteSVMListResponse ?? []) {
        svmList.add(makeRowDataFromSVM(element));
      }
      return [machinary, equimentList, cmList, svmList];
    } on Exception catch (e) {
      log(e.toString(), name: 'Erro on getFaviruteForDriver');
      return [];
    }
  }

  Widget tabBarScreen(List<Widget> children) {
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
              onPressed: () => context.pop(),
              icon: const Icon(Icons.arrow_back_ios_new),
            ),
            bottom: const TabBar(
              padding: EdgeInsets.only(left: 10),
              tabAlignment: TabAlignment.start,
              isScrollable: true,
              indicatorSize: TabBarIndicatorSize.tab,
              dividerColor: Colors.transparent,
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
              key: _futureBuilderUniqueKey,
              future: getFavoriteDriverList(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Center(
                      child: Text('Попробуйте позже или обнавите страницу'));
                } else if (snapshot.data == null) {
                  return const Center(child: Text('Непредвиденная ошибка'));
                } else {
                  final machinary = snapshot.data![0];
                  final equipment = snapshot.data![1];
                  final cm = snapshot.data![2];
                  final svm = snapshot.data![3];

                  if (machinary.isEmpty && equipment.isEmpty) {
                    return const AppAdEmptyListWidget();
                  }
                  return TabBarView(
                  
                    children: [
                      tabBarScreen(machinary
                          .map((element) => AppAdItem(
                              adListRowData: element,
                              onTap: () async {
                                await context.pushNamed(
                                  AppRouteNames.adSMClientDetailFromMyAd,
                                  extra: {'id': element.id.toString()},
                                );

                                setState(() {
                                  _futureBuilderUniqueKey = UniqueKey();
                                });
                              }))
                          .toList()),
                      tabBarScreen(equipment
                          .map((element) => AppAdItem(
                              onTap: () async {
                                await context.pushNamed(
                                  AppRouteNames.adEquipmentClientDetail,
                                  extra: {'id': element.id.toString()},
                                );
                                setState(() {
                                  _futureBuilderUniqueKey = UniqueKey();
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
                                  _futureBuilderUniqueKey = UniqueKey();
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
                                  _futureBuilderUniqueKey = UniqueKey();
                                });
                              },
                              adListRowData: element))
                          .toList())
                    ],
                  );
                }
              }),
        );
      }),
    );
  }
}
