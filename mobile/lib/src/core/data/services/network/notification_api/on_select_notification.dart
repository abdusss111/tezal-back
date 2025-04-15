// ignore_for_file: non_constant_identifier_names, constant_identifier_names

import 'dart:developer';

import 'package:eqshare_mobile/src/core/presentation/routing/app_route.dart';
import 'package:eqshare_mobile/src/global_widgets/global_values.dart';
import 'package:eqshare_mobile/src/features/requests/data/models/request_execution_list/request_execution.dart';
import 'package:eqshare_mobile/src/features/requests/data/repository/request_execution_repository.dart';
import 'package:eqshare_mobile/src/features/requests/presentation/requests/add_data_hadler.dart';
import 'package:eqshare_mobile/src/features/requests/presentation/requests/screens/request_execution_list_screen/request_execution_list_screen_controller.dart';

const String NotificationTypeCM = "request_ad_cm";
const String NotificationTypeCMClient = "request_ad_cm_client";
const String NotificationTypeEQ = "request_ad_equipment";
const String NotificationTypeEQClient = "request_ad_equipment_client";
const String NotificationTypeSVC = "request_ad_service";
const String NotificationTypeSVCClient = "request_ad_service_client";
const String NotificationTypeSMClient = "request_ad_sm_client";
const String NotificationTypeSM = "request_ad_sm";

class OnSelectNotification {
  String _getSrcFromType(String type) {
    switch (type) {
      case NotificationTypeSMClient:
        return 'SM_CLIENT';
      case NotificationTypeSM:
        return 'SM';
      case NotificationTypeCM:
        return AllServiceTypeEnum.CM.name;
      case NotificationTypeCMClient:
        return AllServiceTypeEnum.CM_CLIENT.name;
      case NotificationTypeEQ:
        return 'EQ';
      case NotificationTypeEQClient:
        return ('EQ_CLIENT');
      case NotificationTypeSVC:
        return (AllServiceTypeEnum.SVM.name);
      case NotificationTypeSVCClient:
        return (AllServiceTypeEnum.SVM_CLIENT.name);

      default:
        return '';
    }
  }

  Future<void> onSelectNotification(
      {required Map<String, dynamic> mapData}) async {
    log(mapData.toString(), name: 'maapData: ');
    log(mapData.length.toString(), name: 'maapData length: ');

    final type = mapData['type'] as String? ?? '';
    final id = mapData['id'] as int? ?? '';
    final status = mapData['status'] as String? ?? '';
    final src = mapData['src'] as String? ?? '';
    final wasApproved = mapData['wasApproved'] as bool?;
    log(type.toString(), name: 'type: ');
    log(id.toString(), name: 'id: ');
    log(status.toString(), name: 'status: ');
    log(src.toString(), name: 'src: ');

    // if (wasApproved != null && wasApproved) {
    //   _onReNotificationSelect(
    //       status: status, id: id.toString(), src: _getSrcFromType(type));
    // }

    final addDataHandler = RequestDataHandlerFactory();

    switch (type) {
      case NotificationTypeSMClient:
        await addDataHandler
            .getHandler(AllServiceTypeEnum.MACHINARY_CLIENT)
            .pushToPage(id.toString());
        break;
      case NotificationTypeSM:
        await addDataHandler
            .getHandler(AllServiceTypeEnum.MACHINARY)
            .pushToPage(id.toString());

        break;

      case NotificationTypeCM:
        await addDataHandler
            .getHandler(AllServiceTypeEnum.CM)
            .pushToPage(id.toString());
        break;
      case NotificationTypeCMClient:
        await addDataHandler
            .getHandler(AllServiceTypeEnum.CM_CLIENT)
            .pushToPage(id.toString());
        break;
      case NotificationTypeEQ:
        await addDataHandler
            .getHandler(AllServiceTypeEnum.EQUIPMENT)
            .pushToPage(id.toString());

        break;

      case NotificationTypeEQClient:
        await addDataHandler
            .getHandler(AllServiceTypeEnum.EQUIPMENT_CLIENT)
            .pushToPage(id.toString());

        break;

      case NotificationTypeSVC:
        await addDataHandler
            .getHandler(AllServiceTypeEnum.SVM)
            .pushToPage(id.toString());

        break;

      case NotificationTypeSVCClient:
        await addDataHandler
            .getHandler(AllServiceTypeEnum.SVM_CLIENT)
            .pushToPage(id.toString());
        break;

      case 're':
        return _onReNotificationSelect(
            status: status, src: src, id: id.toString());
      default:
        return _onReNotificationSelect(
            status: status, src: src, id: id.toString());
    }
  }

  void _onReNotificationSelect(
      {required String status, required String id, required String src}) {
    switch (status) {
      case 'ON_ROAD':
        router.pushNamed(AppRouteNames.monitorDriveFromNavigationScreen,
            extra: {'id': id});
      case 'AWAITS_START':
        _pushRequestExecutionScreen(src: src, id: id);
      default:
        _pushRequestExecutionScreen(src: src, id: id);
    }
  }

  void _pushRequestExecutionScreen({required String src, required String id}) {
    final requestExecutionListController = RequestExecutionListScreenController(
        requestExecutionRepository: RequestExecutionRepository(),
        factory: RequestDataHandlerFactory());
    requestExecutionListController.onTapDriverRequestExecution(
        RequestExecution(id: int.tryParse(id), title: '', src: src));
  }
}
