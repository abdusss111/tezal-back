import 'package:eqshare_mobile/app/app_change_notifier.dart';
import 'package:eqshare_mobile/app/app_safe_change_notifier.dart';
import 'package:eqshare_mobile/src/global_widgets/global_values.dart';
import 'package:eqshare_mobile/src/features/main/profile/profile_page/profile_controller.dart';

import 'package:eqshare_mobile/src/features/requests/data/repository/request_execution_repository.dart';
import 'package:eqshare_mobile/src/features/requests/presentation/requests/add_data_hadler.dart';
import 'package:flutter/material.dart';

import 'package:eqshare_mobile/src/features/requests/data/models/construction_request/construction_request/construction_request_model.dart';
import 'package:eqshare_mobile/src/features/requests/data/models/construction_request/construction_request_client/construction_request_client_model.dart';
import 'package:eqshare_mobile/src/features/requests/data/models/equipment_request/equipment_client_request_model/request_ad_equipment_client.dart';
import 'package:eqshare_mobile/src/features/requests/data/models/equipment_request/equipment_request_model/request_ad_equipment.dart';
import 'package:eqshare_mobile/src/features/requests/data/models/service_request/service_request/service_request_model.dart';
import 'package:eqshare_mobile/src/features/requests/data/models/service_request/service_request_client/service_request_client_model.dart';
import 'package:eqshare_mobile/src/features/requests/data/models/specialized_machinery_request_models/specialized_machinery_request_client_model/specialized_machinery_request_client.dart';
import 'package:eqshare_mobile/src/features/requests/data/models/specialized_machinery_request_models/specialized_machinery_request_model/specialized_machinery_request.dart';
import 'package:eqshare_mobile/src/features/requests/presentation/requests/model/request_item_class.dart';

class GeneralRequestScreenController extends AppSafeChangeNotifier {
  final RequestExecutionRepository _requestExecutionRepository;

  bool isLoading = true;
  int? activeRequests;
  int? activeRequestExecutions;
  int? finishRequestExecutionsAndCancelRequests;

  GeneralRequestScreenController(
      {required RequestExecutionRepository requestExecutionRepository})
      : _requestExecutionRepository = requestExecutionRepository;

  Future<int> getActiveRequestExecutionTotal() async {
    final total = await getRequestExecutionsTotal([
      RequestStatus.AWAITS_START.name,
      RequestStatus.PAUSE.name,
      RequestStatus.WORKING.name,
      RequestStatus.ON_ROAD.name,
    ]);
    activeRequestExecutions = total;
    return total ?? 0;
  }

  Future<void> init() async {
    await Future.wait([
      getActiveRequestsTotal(),
      getActiveRequestExecutionTotal(),
      getFinishedRequestExecutionsORCancelRequestsTotal(),
    ]);
  }

  Future<int> getFinishedRequestExecutionsORCancelRequestsTotal() async {
    if (AppChangeNotifier().userMode == UserMode.client) {
      final total = await getAllRequestsForClient(
          AppChangeNotifier().payload?.sub ?? '', RequestStatus.CANCELED.name);
      final requestExecutionTotal =
          await getRequestExecutionsTotal([RequestStatus.FINISHED.name]);

      finishRequestExecutionsAndCancelRequests =
          total + (requestExecutionTotal ?? 0);
      return finishRequestExecutionsAndCancelRequests ?? 0;
    } else {
      final total = await getAllRequestsForDriver(
          AppChangeNotifier().payload?.sub ?? '', RequestStatus.CANCELED.name);
      final requestExecutionTotal =
          await getRequestExecutionsTotal([RequestStatus.FINISHED.name]);

      finishRequestExecutionsAndCancelRequests =
          total + (requestExecutionTotal ?? 0);
      return finishRequestExecutionsAndCancelRequests ?? 0;
    }
  }

  Future<int> getActiveRequestsTotal() async {
    if (AppChangeNotifier().userMode == UserMode.client) {
      final total = await getAllRequestsForClient(
          AppChangeNotifier().payload?.sub ?? '', RequestStatus.CREATED.name);
      activeRequests = total;
      return total;
    } else {
      final total = await getAllRequestsForDriver(
          AppChangeNotifier().payload?.sub ?? '', RequestStatus.CREATED.name);
      activeRequests = total;
      return total;
    }
  }

  Future<int?> getRequestExecutionsTotal(List<String> status) async {
    final data = await _requestExecutionRepository.getRequestExecutionCount(
        status: status);
    return data;
  }

  Future<int> getAllRequestsForClient(String userID, String status) async {
    final statuses = status;
    final data = await Future.wait([
      RequestDataHandlerFactory()
          .getHandler(AllServiceTypeEnum.MACHINARY)
          .getUserList(userID, statuses),
      RequestDataHandlerFactory()
          .getHandler(AllServiceTypeEnum.MACHINARY_CLIENT)
          .getUserList(userID, statuses),
      RequestDataHandlerFactory()
          .getHandler(AllServiceTypeEnum.EQUIPMENT)
          .getUserList(userID, statuses),
      RequestDataHandlerFactory()
          .getHandler(AllServiceTypeEnum.EQUIPMENT_CLIENT)
          .getUserList(userID, statuses),
      RequestDataHandlerFactory()
          .getHandler(AllServiceTypeEnum.CM)
          .getUserList(userID, statuses),
      RequestDataHandlerFactory()
          .getHandler(AllServiceTypeEnum.CM_CLIENT)
          .getUserList(userID, statuses),
      RequestDataHandlerFactory()
          .getHandler(AllServiceTypeEnum.SVM)
          .getUserList(userID, statuses),
      RequestDataHandlerFactory()
          .getHandler(AllServiceTypeEnum.SVM_CLIENT)
          .getUserList(userID, statuses),
    ]);
    final requestItemClassList = getFromSnapShot(data);
    return requestItemClassList.length;
  }

  Future<int> getAllRequestsForDriver(String userID, String status) async {
    final statuses = status;
    final data = await Future.wait([
      RequestDataHandlerFactory()
          .getHandler(AllServiceTypeEnum.MACHINARY)
          .getExecutorList(userID, statuses),
      RequestDataHandlerFactory()
          .getHandler(AllServiceTypeEnum.MACHINARY_CLIENT)
          .getExecutorList(userID, statuses),
      RequestDataHandlerFactory()
          .getHandler(AllServiceTypeEnum.EQUIPMENT)
          .getExecutorList(userID, statuses),
      RequestDataHandlerFactory()
          .getHandler(AllServiceTypeEnum.EQUIPMENT_CLIENT)
          .getExecutorList(userID, statuses),
      RequestDataHandlerFactory()
          .getHandler(AllServiceTypeEnum.CM)
          .getExecutorList(userID, statuses),
      RequestDataHandlerFactory()
          .getHandler(AllServiceTypeEnum.CM_CLIENT)
          .getExecutorList(userID, statuses),
      RequestDataHandlerFactory()
          .getHandler(AllServiceTypeEnum.SVM)
          .getExecutorList(userID, statuses),
      RequestDataHandlerFactory()
          .getHandler(AllServiceTypeEnum.SVM_CLIENT)
          .getExecutorList(userID, statuses),
    ]);
    final requestItemClassList = getFromSnapShot(data);
    return requestItemClassList.length;
  }

  List<RequestItemClass> getFromSnapShot(List<List<dynamic>?> snapshot) {
    final List<SpecializedMachineryRequest>? machinaryRequest =
        snapshot[0] != null && (snapshot[0] as List).isNotEmpty
            ? snapshot[0] as List<SpecializedMachineryRequest>
            : null;
    final List<SpecializedMachineryRequestClient>? machinaryClientRequest =
        snapshot[1] != null && (snapshot[1] as List).isNotEmpty
            ? snapshot[1] as List<SpecializedMachineryRequestClient>
            : null;
    final List<RequestAdEquipment>? equipmentRequest =
        snapshot[2] != null && (snapshot[2] as List).isNotEmpty
            ? snapshot[2] as List<RequestAdEquipment>
            : null;
    final List<RequestAdEquipmentClient>? equipmentClientRequest =
        snapshot[3] != null && (snapshot[3] as List).isNotEmpty
            ? snapshot[3] as List<RequestAdEquipmentClient>
            : null;
    final List<ConstructionRequestModel>? constructionRequest =
        snapshot[4] != null && (snapshot[4] as List).isNotEmpty
            ? snapshot[4] as List<ConstructionRequestModel>
            : null;
    final List<ConstructionRequestClientModel>? constructionClientRequest =
        snapshot[5] != null && (snapshot[5] as List).isNotEmpty
            ? snapshot[5] as List<ConstructionRequestClientModel>
            : null;
    final List<ServiceRequestModel>? servcieRequest =
        snapshot[6] != null && (snapshot[6] as List).isNotEmpty
            ? snapshot[6] as List<ServiceRequestModel>
            : null;
    final List<ServiceRequestClientModel>? serviceClientRequest =
        snapshot[7] != null && (snapshot[7] as List).isNotEmpty
            ? snapshot[7] as List<ServiceRequestClientModel>
            : null;
    final List<RequestItemClass> data = [];

    if (machinaryRequest != null && machinaryRequest.isNotEmpty) {
      data.addAll(mapMachinaryRequestToRequestItemClass(machinaryRequest));
    }
    if (machinaryClientRequest != null && machinaryClientRequest.isNotEmpty) {
      data.addAll(
          mapMachinaryClientRequestToRequestItemClass(machinaryClientRequest));
    }
    if (equipmentRequest != null && equipmentRequest.isNotEmpty) {
      data.addAll(mapEquipmentRequestToRequestItemClass(equipmentRequest));
    }
    if (equipmentClientRequest != null && equipmentClientRequest.isNotEmpty) {
      data.addAll(
          mapEquipmentClientRequestToRequestItemClass(equipmentClientRequest));
    }
    if (constructionRequest != null && constructionRequest.isNotEmpty) {
      data.addAll(
          mapConstructionRequestToRequestItemClass(constructionRequest));
    }
    if (constructionClientRequest != null &&
        constructionClientRequest.isNotEmpty) {
      data.addAll(mapConstructionClientRequestToRequestItemClass(
          constructionClientRequest));
    }
    if (servcieRequest != null && servcieRequest.isNotEmpty) {
      data.addAll(mapServiceRequestToRequestItemClass(servcieRequest));
    }
    if (serviceClientRequest != null && serviceClientRequest.isNotEmpty) {
      data.addAll(
          mapServiceClientRequestToRequestItemClass(serviceClientRequest));
    }
    return data;
  }

  List<RequestItemClass> mapMachinaryRequestToRequestItemClass(
      List<SpecializedMachineryRequest> machinaryRequest) {
    return machinaryRequest.map((e) {
      return RequestItemClass(
          title: e.adSpecializedMachinery?.name ?? '',
          subcategory: e.adSpecializedMachinery?.type?.name ?? '',
          startLeaseDate: e.startLeaseAt.toString(),
          type: AllServiceTypeEnum.MACHINARY,
          id: e.id ?? 0,
          ownerID: int.parse(AppChangeNotifier().payload?.sub ?? '-1'),
          endLeaseDate: e.endLeaseAt.toString(),
          priceForHour: (e.adSpecializedMachinery?.price ?? 0).toDouble(),
          createDate: e.createdAt.toString(),
          status: e.status ?? '',
          address: e.address ?? '');
    }).toList();
  }

  List<RequestItemClass> mapMachinaryClientRequestToRequestItemClass(
      List<SpecializedMachineryRequestClient> machinaryClientRequest) {
    return machinaryClientRequest.map((e) {
      return RequestItemClass(
          title: e.adSm?.headline ?? '',
          subcategory: e.adSm?.type?.name ?? '',
          startLeaseDate: e.adSm?.startDate ?? '',
          type: AllServiceTypeEnum.MACHINARY_CLIENT,
          id: e.id ?? 0,
          endLeaseDate: e.adSm?.endDate,
          ownerID: -1,
          priceForHour: (e.adSm?.price ?? 0).toDouble(),
          createDate: e.createdAt,
          status: e.status ?? '',
          address: e.adSm?.address ?? '');
    }).toList();
  }

  List<RequestItemClass> mapEquipmentRequestToRequestItemClass(
      List<RequestAdEquipment> equipmentRequest) {
    return equipmentRequest.map((e) {
      return RequestItemClass(
          title: e.adEquipment?.title ?? '',
          subcategory: e.adEquipment?.subcategory?.name ?? '',
          startLeaseDate: e.startLeaseAt?.toString() ?? '',
          type: AllServiceTypeEnum.EQUIPMENT,
          id: e.id,
          ownerID: e.executorId ?? 0,
          endLeaseDate: e.endLeaseAt?.toString() ?? '',
          priceForHour: e.adEquipment?.price ?? 0.0,
          createDate: e.createdAt?.toString() ?? '',
          status: e.status ?? '',
          address: e.address ?? '');
    }).toList();
  }

  List<RequestItemClass> mapEquipmentClientRequestToRequestItemClass(
      List<RequestAdEquipmentClient> equipmentClientRequest) {
    return equipmentClientRequest.map((e) {
      return RequestItemClass(
          title: e.adEquipmentClient?.title ?? '',
          subcategory: e.adEquipmentClient?.equipmentSubcategory?.name ?? '',
          startLeaseDate: e.adEquipmentClient?.startLeaseDate ?? '',
          type: AllServiceTypeEnum.EQUIPMENT_CLIENT,
          id: e.id ?? 0,
          ownerID: -1,
          endLeaseDate: e.adEquipmentClient?.endLeaseDate ?? '',
          priceForHour: e.adEquipmentClient?.price ?? 0.0,
          createDate: e.createdAt.toString(),
          status: e.status ?? '',
          address: e.adEquipmentClient?.address ?? '');
    }).toList();
  }

  List<RequestItemClass> mapConstructionRequestToRequestItemClass(
      List<ConstructionRequestModel> constructionRequest) {
    return constructionRequest.map((e) {
      return RequestItemClass(
          title: e.adConstructionModel?.title ?? '',
          subcategory:
              e.adConstructionModel?.constructionMaterialSubCategory?.name ??
                  '',
          startLeaseDate: e.startLeaseAt?.toString() ?? '',
          type: AllServiceTypeEnum.CM,
          id: e.id ?? 0,
          ownerID: e.executorId ?? 0,
          endLeaseDate: e.endLeaseAt?.toString() ?? '',
          priceForHour: (e.adConstructionModel?.price ?? 0).toDouble(),
          createDate: e.createdAt?.toString() ?? '',
          status: e.status ?? '',
          address: e.address ?? '');
    }).toList();
  }

  List<RequestItemClass> mapConstructionClientRequestToRequestItemClass(
      List<ConstructionRequestClientModel> constructionClientRequest) {
    return constructionClientRequest.map((e) {
      return RequestItemClass(
          title: e.adConstructionClientModel?.title ?? '',
          subcategory: e.adConstructionClientModel
                  ?.constructionMaterialSubCategory?.name ??
              '',
          startLeaseDate:
              e.adConstructionClientModel?.startLeaseDate.toString() ?? '',
          type: AllServiceTypeEnum.CM_CLIENT,
          id: e.id ?? 0,
          ownerID: -1,
          endLeaseDate:
              e.adConstructionClientModel?.endLeaseDate.toString() ?? '',
          priceForHour: (e.adConstructionClientModel?.price ?? 0.0).toDouble(),
          createDate: e.createdAt,
          status: e.status ?? '',
          address: e.adConstructionClientModel?.address ?? '');
    }).toList();
  }

  List<RequestItemClass> mapServiceRequestToRequestItemClass(
      List<ServiceRequestModel> servcieRequest) {
    return servcieRequest.map((e) {
      return RequestItemClass(
          title: e.ad?.title ?? '',
          subcategory: e.ad?.subcategory?.name ?? '',
          startLeaseDate: e.startLeaseAt?.toString() ?? '',
          type: AllServiceTypeEnum.SVM,
          id: e.id ?? 0,
          ownerID: e.executorId ?? 0,
          endLeaseDate: e.endLeaseAt?.toString() ?? '',
          priceForHour: (e.ad?.price ?? 0).toDouble(),
          createDate: e.createdAt?.toString() ?? '',
          status: e.status ?? '',
          address: e.address ?? '');
    }).toList();
  }

  List<RequestItemClass> mapServiceClientRequestToRequestItemClass(
      List<ServiceRequestClientModel> serviceClientRequest) {
    return serviceClientRequest.map((e) {
      return RequestItemClass(
          title: e.adClient?.title ?? '',
          subcategory: e.adClient?.subcategory?.name ?? '',
          startLeaseDate: e.adClient?.startLeaseDate ?? '',
          type: AllServiceTypeEnum.SVM_CLIENT,
          id: e.id ?? 0,
          ownerID: -1,
          endLeaseDate: e.adClient?.endLeaseDate ?? '',
          priceForHour: (e.adClient?.price ?? 0).toDouble(),
          createDate: e.createdAt,
          status: e.status ?? '',
          address: e.adClient?.address ?? '');
    }).toList();
  }
}
