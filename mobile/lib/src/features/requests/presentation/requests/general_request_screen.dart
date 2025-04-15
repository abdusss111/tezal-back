
import 'package:eqshare_mobile/src/core/data/models/payload/payload.dart';
import 'package:eqshare_mobile/src/core/data/services/storage/token_provider_service.dart';
import 'package:eqshare_mobile/src/core/presentation/widgets/app_circular_progress_indicator.dart';

import 'package:eqshare_mobile/src/features/requests/data/repository/request_execution_repository.dart';
import 'package:eqshare_mobile/src/features/requests/presentation/requests/add_data_hadler.dart';
import 'package:eqshare_mobile/src/features/requests/presentation/requests/general_request_screen_controller.dart';

import 'package:eqshare_mobile/src/features/requests/presentation/requests/screens/cancel_or_finished_requests/finished_requests/finished_requests_screen.dart';

import 'package:eqshare_mobile/src/features/requests/presentation/requests/screens/request_execution_list_screen/request_execution_list_screen.dart';
import 'package:eqshare_mobile/src/features/requests/presentation/requests/screens/request_execution_list_screen/request_execution_list_screen_controller.dart';
import 'package:eqshare_mobile/src/features/requests/presentation/requests/screens/requests_screen/requests_list_screen.dart';
import 'package:eqshare_mobile/src/features/requests/presentation/requests/screens/requests_screen/requests_list_screen_controller.dart';

import 'package:eqshare_mobile/src/features/requests/presentation/widgets/listenable_tab_controller.dart';
import 'package:eqshare_mobile/src/features/requests/presentation/widgets/request_empty_list_widget.dart';
import 'package:eqshare_mobile/src/features/requests/presentation/widgets/tab_with_total.dart';

import 'package:eqshare_mobile/src/global_widgets/global_future_builder.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NewBigRequestScreen extends StatefulWidget {
  const NewBigRequestScreen({super.key});

  @override
  State<NewBigRequestScreen> createState() => _NewBigRequestScreenState();
}

class _NewBigRequestScreenState extends State<NewBigRequestScreen> {
  Future<Payload?> getPayload() async {
    final token = await TokenService().getToken();
    if (token != null) return TokenService().extractPayloadFromToken(token);
    return null;
  }

  late final GeneralRequestScreenController generalRequestScreenController;

  @override
  void initState() {
    super.initState();

    generalRequestScreenController =
        Provider.of<GeneralRequestScreenController>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
  
    return FutureBuilder(
        future: getPayload(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const AppCircularProgressIndicator();
          }
          if (snapshot.data == null) {
            return Scaffold(
                backgroundColor: Colors.transparent,
                appBar: AppBar(
                  title: const Text('Заказы'),
                  centerTitle: true,
                ),
                body: const RequestEmptyListWidget());
          }

          return ListenableTabController(
            initialIndex: 1,
            length: 3,
            onPageChanged: (int value) {},
            child: Scaffold(
              appBar: AppBar(
                title: const Text('Заказы'),
                bottom: TabBar(
                  dividerColor: Colors.transparent,
                  tabAlignment: TabAlignment.center,
                  isScrollable: true,
                  indicatorSize: TabBarIndicatorSize.tab,
                  tabs: [
                    FutureBuilder<int?>(
                        future: generalRequestScreenController
                            .getActiveRequestsTotal(),
                        builder: (context, snapshot) {
                          return TabWithTotal(
                            label: 'Ожидание',
                            total: snapshot.data,
                          );
                        }),
                    FutureBuilder<int?>(
                        future: generalRequestScreenController
                            .getActiveRequestExecutionTotal(),
                        builder: (context, snapshot) {
                          return TabWithTotal(
                            label: 'Активные',
                            total: snapshot.data,
                          );
                        }),
                    FutureBuilder<int?>(
                        future: generalRequestScreenController
                            .getFinishedRequestExecutionsORCancelRequestsTotal(),
                        builder: (context, snapshot) {
                          return TabWithTotal(
                            label: 'Завершенные',
                            total: snapshot.data,
                          );
                        }),
                  ],
                ),
              ),
              body: GlobalFutureBuilder(
                  future: getPayload(),
                  buildWidget: (payload) {
                    return Consumer<GeneralRequestScreenController>(
                        builder: (context, controller, _) {
                      if (payload == null) {
                        return const RequestEmptyListWidget();
                      }

                      return TabBarView(children: [
                        ChangeNotifierProvider(
                            create: (context) => RequestScreenController(
                                factory: RequestDataHandlerFactory(),
                                requestExecutionRepository:
                                    RequestExecutionRepository())
                              ..initController(),
                            child: const RequestListScreen()),
                        ChangeNotifierProvider(
                            create: (context) =>
                                RequestExecutionListScreenController(
                                  requestExecutionRepository:
                                      RequestExecutionRepository(),
                                  factory: RequestDataHandlerFactory(),
                                )..initController(),
                            child: const RequestExecutionListScreen()),
                        ChangeNotifierProvider(
                            create: (context) =>
                                RequestExecutionListScreenController(
                                    factory: RequestDataHandlerFactory(),
                                    requestExecutionRepository:
                                        RequestExecutionRepository())
                                  ..initController(isFinishedScreen: true),
                            child: const FinishedRequestsScreen()),
                      ]);
                    });
                  }),
            ),
          );
        });
  }


}
