import 'package:flutter/material.dart';

import 'package:eqshare_mobile/src/global_widgets/global_values.dart';
import 'package:eqshare_mobile/src/features/requests/presentation/widgets/rate_order_dialog.dart';

import 'package:eqshare_mobile/src/core/presentation/routing/app_route.dart';
import 'package:eqshare_mobile/src/features/main/location/driver_location_screen.dart';
import 'package:eqshare_mobile/src/features/main/profile/profile_page/profile_controller.dart';
import 'package:eqshare_mobile/src/features/requests/data/models/request_execution_list/request_execution.dart';
import 'package:eqshare_mobile/src/features/requests/presentation/request_history/request_history_screen.dart';
import 'package:eqshare_mobile/src/features/requests/presentation/widgets/request_list_action_button.dart';

import 'package:go_router/go_router.dart';

List<Widget> requestExecutionItemButtons({
  required BuildContext context,
  required RequestExecution request,
  required String userID,
  required bool isConstructionMaterials,
  required String userAUD,
  bool isFromOwnerDriversPage = false,
  bool isNeedHistoryButton = true,
  ServiceTypeEnum? serviceType,
  Future<bool> Function({required String requestID})? acceptOrder,
  // Future<void> Function({required String requestID})? reassignTheDriver,
  Future<bool> Function({required String requestID})? pauseOrder,
  Future<bool> Function({required String requestID})? finishOrder,
  Future<bool> Function({required String requestID})? toRoadRequest,
  Future<bool> Function(
          {required RequestExecution request,
          required int rating,
          required String text})?
      rateOrder,
}) {
  void onShowRoadPressed(BuildContext context) {
    final isOwner = userAUD.toUpperCase() == UserMode.owner.name.toUpperCase();
    final isClient =
        userAUD.toUpperCase() == UserMode.client.name.toUpperCase();
    final isDriver =
        userAUD.toUpperCase() == UserMode.driver.name.toUpperCase();

    final isOwnerExecutor =
        ((request.assigned == null || request.assigned == 1) &&
            request.driverID == int.parse(userID));
    final isDriverExecutor = request.driverID == int.parse(userID) ||
        request.assigned == int.parse(userID);

    final isUserExecutor = isClient
        ? false
        : (isDriver
            ? isDriverExecutor
            : isOwner
                ? isOwnerExecutor
                : false);
    if (isClient) {
      // context.pushNamed(AppRouteNames.monitorDriveFromNavigationScreen, extra: {
      //   'id': request.id,
      // });
      context.pushNamed(AppRouteNames.clientGoogleNavigationScreen, extra: {
          'id': request.id.toString(),
          'lat': request.finishLatitude,
          'lon': request.finishLongitude
        });

    } else {
      if (isUserExecutor) {
        context.pushNamed(AppRouteNames.googleNavigationScreen, extra: {
          'id': request.id.toString(),
          'lat': request.finishLatitude,
          'lon': request.finishLongitude
        });
        // Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //         builder: (context) =>
        //             DriverLocationScreen(request: request.id ?? 0)));
      } else {
         context.pushNamed(AppRouteNames.clientGoogleNavigationScreen, extra: {
          'id': request.id.toString(),
          'lat': request.finishLatitude,
          'lon': request.finishLongitude
        });
      }
    }
  }

  Widget buildHistoryButton() {
    return RequestListActionButton(
      text: 'История заказа',
      onPressed: () {
        context.pushNamed(
          AppRouteNames.requestHistory,
          extra: RequestHistoryData(
            requestId: request.id ?? -1,
          ),
        );
      },
    );
  }

  Widget reassignTheDriverButton() {
    return RequestListActionButton(
      text: 'Переназначить водителя',
      onPressed: () async {
        // await reassignTheDriver!(requestID: request.id.toString());
      },
    );
  }

  List<Widget> buildOnRoadButtons({required bool isUserExecutor}) {
    return [
      if (isUserExecutor)
        RequestListActionButton(
          text: 'Путь',
          onPressed: () => onShowRoadPressed(context),
        ),
      if (!isUserExecutor)
        RequestListActionButton(
          text: 'Отслеживать водителя',
          onPressed: () => onShowRoadPressed(context),
        ),
      if (isUserExecutor)
        RequestListActionButton(
          text: 'Поставить на паузу',
          onPressed: () async {
            await pauseOrder!(requestID: request.id.toString());
          },
        ),
      if (isUserExecutor)
        RequestListActionButton(
          text: 'Начать',
          onPressed: () async {
            await acceptOrder!(requestID: request.id.toString());
          },
        ),
    ];
  }

  List<Widget> buildWorkingButtons({required bool isUserExecutor}) {
    return [
      if (isUserExecutor)
        RequestListActionButton(
          text: 'Открыть путь',
          onPressed: () async {
            await toRoadRequest!(requestID: request.id.toString());
            if (context.mounted) {
              onShowRoadPressed(context);
            }
          },
        ),
      if (!isConstructionMaterials && isUserExecutor)
        RequestListActionButton(
          text: 'Поставить на паузу',
          onPressed: () async {
            await pauseOrder!(requestID: request.id.toString());
          },
        ),
      if (isUserExecutor)
        RequestListActionButton(
          text: 'Завершить',
          onPressed: () async {
            await finishOrder!(requestID: request.id.toString());
          },
        ),
    ];
  }

  Widget buildResumeButton(BuildContext context) {
    return RequestListActionButton(
      text: 'Возобновить',
      onPressed: () async {
        await acceptOrder!(requestID: request.id.toString());
      },
    );
  }

  Widget buildRateButton(BuildContext context) {
    if ((request.rate == 0 || request.rate == null)) {
      return RequestListActionButton(
        text: 'Поставить оценку',
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AliRateOrderDialog(
                request: request,
                rateOrder: rateOrder!, // Ensure correct type
              );
            },
          );
        },
      );
    } else {
      return const SizedBox();
    }
  }

  List<Widget> buildAwaitStartButtons() {
    return [
      // RequestListActionButton(
      //   text: 'В путь',
      //   onPressed: () async {
      //     await toRoadRequest!(requestID: request.id.toString());
      //     if (context.mounted) {
      //       Navigator.push(
      //         context,
      //         MaterialPageRoute(
      //           builder: (context) => DriverLocationScreen(request: request),
      //         ),
      //       );
      //     }
      //   },
      // ),
      RequestListActionButton(
        text: 'Начать',
        onPressed: () async {
          await acceptOrder!(requestID: request.id.toString());
        },
      )
      // : const SizedBox(),
    ];
  }

  List<Widget> buildActionButtons(BuildContext context) {
    final isOwner = userAUD.toUpperCase() == UserMode.owner.name.toUpperCase();
    final isClient =
        userAUD.toUpperCase() == UserMode.client.name.toUpperCase();
    final isDriver =
        userAUD.toUpperCase() == UserMode.driver.name.toUpperCase();
    final isUserExecutor = isClient
        ? false
        : (isDriver
            ? request.driverID == int.parse(userID) ||
                request.assigned == int.parse(userID)
            : isOwner
                ? ((request.assigned == null || request.assigned == 1) &&
                    request.driverID == int.parse(userID))
                : false);

    if (isFromOwnerDriversPage) {
      return [
        buildHistoryButton(),
        if (request.status == 'ON_ROAD')
          ...buildOnRoadButtons(isUserExecutor: isUserExecutor),
      ];
    }
    return [
      if (isNeedHistoryButton) buildHistoryButton(),
      // if (isOwner) reassignTheDriverButton(),
      if (request.status == 'ON_ROAD')
        ...buildOnRoadButtons(isUserExecutor: isUserExecutor),
      if (request.status == 'WORKING')
        ...buildWorkingButtons(isUserExecutor: isUserExecutor),
      if (request.status == 'PAUSE' && isUserExecutor)
        buildResumeButton(context),
      if (request.status == 'FINISHED' && isClient && request.rate == null)
        buildRateButton(context),
      if (request.status == 'AWAITS_START' && isUserExecutor)
        ...buildAwaitStartButtons(),
    ];
  }

  return buildActionButtons(context);
}
