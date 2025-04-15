import 'package:eqshare_mobile/app/app_change_notifier.dart';
import 'package:eqshare_mobile/src/core/data/models/payload/payload.dart';
import 'package:eqshare_mobile/src/core/presentation/routing/app_route.dart';
import 'package:eqshare_mobile/src/core/presentation/widgets/get_core_widgets.dart';

import 'package:eqshare_mobile/src/global_widgets/global_values.dart';
import 'package:eqshare_mobile/src/features/ad/presentation/screens/my_ad_screens/my_ads_list_screen.dart';
import 'package:eqshare_mobile/src/features/ad/presentation/screens/my_ad_screens/my_services/my_services_controller.dart';
import 'package:eqshare_mobile/src/features/ad/presentation/utils/create_ad_or_request_enum.dart';
import 'package:eqshare_mobile/src/features/requests/presentation/widgets/listenable_tab_controller.dart';
import 'package:eqshare_mobile/src/features/requests/presentation/widgets/tab_with_total.dart';
import 'package:eqshare_mobile/src/global_widgets/global_future_builder.dart';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class MyServicesScreen extends StatefulWidget {
  const MyServicesScreen({super.key});

  @override
  State<MyServicesScreen> createState() => _MyServicesScreenState();
}

class _MyServicesScreenState extends State<MyServicesScreen> {
  var uniqueKey = UniqueKey();

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Payload?>(
        future: AppChangeNotifier().getPayload(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const AppCircularProgressIndicator();
          } else if (snapshot.data == null) {
            return const Center(child: Text('Back'));
          } else if (snapshot.data?.aud == 'CLIENT') {
            return ListenableTabController(
                initialIndex: 0,
                length: 3,
                onPageChanged: (int value) {},
                child: Builder(builder: (context) {
                  return Scaffold(
                      appBar: AppBar(
                        title: const Text('Услуги'),
                        bottom: const TabBar(
                          padding: EdgeInsets.only(left: 10),
                          tabAlignment: TabAlignment.center,
                          isScrollable: true,
                          dividerColor: Colors.transparent,
                          indicatorSize: TabBarIndicatorSize.tab,
                          tabs: [
                            TabWithTotal(label: 'Активные', total: 0),
                            TabWithTotal(label: 'Завершенные', total: 0),
                            TabWithTotal(label: 'Удаленные', total: 0),
                          ],
                        ),
                      ),
                      body: GlobalFutureBuilder(
                          key: uniqueKey,
                          future: Provider.of<MyServicesController>(context,
                                  listen: false)
                              .getClientData(),
                          buildWidget: (requests) {
                            final request = requests[0];

                            final result = request
                                .where((e) =>
                                    e.status == RequestStatus.CREATED.name &&
                                    (e.deletedAt == null))
                                .toList();
                            final finishedAds = request
                                .where((e) =>
                                    e.status == RequestStatus.FINISHED.name)
                                .toList();
                            final deletedAds = request
                                .where((e) =>
                                    e.status == RequestStatus.CREATED.name &&
                                    (e.deletedAt != null))
                                .toList();

                            return Consumer<MyServicesController>(
                                builder: (context, controller, child) {
                              return  TabBarView(children: [
                                MyAdClientListView(
                                  ads: result,
                                  onAdTapped: (id, isClient) async {
                                    controller
                                        .anAdTapRequests(context,
                                            isClient: true, id: id)
                                        .then((value) {
                                      setState(() {
                                        uniqueKey = UniqueKey();
                                      });
                                    });
                                  },
                                  addButtonText: 'Создать заявку',
                                  onTapCreate: () => context.pushNamed(
                                      AppRouteNames.createAdService,
                                      extra: {
                                        'value':
                                            CreateAdOrRequestEnum.request.name
                                      }),
                                ),
                                MyAdClientListView(
                                  ads: finishedAds,
                                  onAdTapped: (id, isClient) async {
                                    controller
                                        .anAdTapRequests(context,
                                            isClient: true, id: id)
                                        .then((value) {
                                      setState(() {
                                        uniqueKey = UniqueKey();
                                      });
                                    });
                                  },
                                ),
                                MyAdClientListView(
                                  ads: deletedAds,
                                  onAdTapped: (id, isClient) async {
                                    controller
                                        .anAdTapRequests(context,
                                            isClient: true, id: id)
                                        .then((value) {
                                      setState(() {
                                        uniqueKey = UniqueKey();
                                      });
                                    });
                                  },
                                )
                              ]);
                            });
                          }));
                }));
          } else {
            return Scaffold(
              appBar: AppBar(title: const Text('Услуги')),
              body: GlobalFutureBuilder(
                  key: uniqueKey,
                  future:
                      Provider.of<MyServicesController>(context, listen: false)
                          .getClientData(),
                  buildWidget: (requests) {
                    final ad = requests[1];
                    return Consumer<MyServicesController>(
                        builder: (context, controller, child) {
                      return  MyAdClientListView(
                        ads: ad,
                        onAdTapped: (id, isClient) async {
                          controller
                              .anAdTapRequests(context, isClient: false, id: id)
                              .then((value) {
                            setState(() {
                              uniqueKey = UniqueKey();
                            });
                          });
                        },
                        onTapCreate: () {
                          context.pushNamed(AppRouteNames.createAdService,
                              extra: {'value': CreateAdOrRequestEnum.ad.name});
                        },
                        addButtonText: 'Создать объявления',
                      );
                    });
                  }),
            );
          }
        });
  }
}
