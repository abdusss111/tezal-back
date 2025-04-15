import 'package:eqshare_mobile/app/app_change_notifier.dart';
import 'package:eqshare_mobile/app/app_safe_change_notifier.dart';
import 'package:eqshare_mobile/src/features/main/profile/profile_page/profile_controller.dart';

import 'package:eqshare_mobile/src/global_widgets/global_values.dart';
import 'package:eqshare_mobile/src/features/requests/data/models/construction_request/construction_request/construction_request_model.dart';
import 'package:eqshare_mobile/src/features/requests/data/models/construction_request/construction_request_client/construction_request_client_model.dart';
import 'package:eqshare_mobile/src/features/requests/data/models/equipment_request/equipment_client_request_model/request_ad_equipment_client.dart';
import 'package:eqshare_mobile/src/features/requests/data/models/equipment_request/equipment_request_model/request_ad_equipment.dart';

import 'package:eqshare_mobile/src/features/requests/data/models/service_request/service_request/service_request_model.dart';
import 'package:eqshare_mobile/src/features/requests/data/models/service_request/service_request_client/service_request_client_model.dart';
import 'package:eqshare_mobile/src/features/requests/data/models/specialized_machinery_request_models/specialized_machinery_request_client_model/specialized_machinery_request_client.dart';
import 'package:eqshare_mobile/src/features/requests/data/models/specialized_machinery_request_models/specialized_machinery_request_model/specialized_machinery_request.dart';
import 'package:eqshare_mobile/src/features/requests/data/repository/request_execution_repository.dart';
import 'package:eqshare_mobile/src/features/requests/presentation/requests/add_data_hadler.dart';
import 'package:eqshare_mobile/src/features/requests/presentation/requests/model/request_item_class.dart';
import 'package:eqshare_mobile/src/features/requests/presentation/requests/widgets/request_card_item.dart';
import 'package:flutter/material.dart';

class RequestScreenController extends AppSafeChangeNotifier {
  final RequestDataHandlerFactory _factory;
  final RequestExecutionRepository _requestExecutionRepository;

  final GlobalKey<AnimatedListState> listKey = GlobalKey();

  final appChangeNotifier = AppChangeNotifier();

  bool isLoading = true;
  List<RequestItemClass> _reList = [];

  List<RequestItemClass> getReList() => _reList;

  RequestScreenController(
      {required RequestDataHandlerFactory factory,
      required RequestExecutionRepository requestExecutionRepository})
      : _factory = factory,
        _requestExecutionRepository = requestExecutionRepository;

  Widget buildItem(RequestItemClass request, Animation<double> animation) {
    return SizeTransition(
        sizeFactor: animation,
        child: RequestCardItem(
            requestScreenController: this,
            requestItemData: request,
            onTap: () async {
              await onTapDriverRequest(request.type, request.id.toString());
              initController();
            }));
  }

  void setUpdateStatus(
      {required String requestID, required RequestStatus requestStatus}) {
    final request = _reList.firstWhere((e) => e.id == int.parse(requestID));
    if (requestStatus == RequestStatus.APPROVED) {
      final index = _reList.indexOf(request);
      _reList.remove(request);
      listKey.currentState?.removeItem(
        index,
        (context, animation) {
          return SlideTransition(
            position: animation.drive(Tween<Offset>(
              begin: const Offset(0.0, 0.0),
              end: const Offset(-1.0, 0.0),
            ).chain(CurveTween(curve: Curves.easeInOut))),
            child: buildItem(request, animation),
          );
        },
        duration: const Duration(milliseconds: 300),
      );
    } else {
      final newRequest = request.copyWith(status: requestStatus.name);
      _reList[_reList.indexOf(request)] = newRequest;
    }
    notifyListeners();
  }

  Future<void> onTapDriverRequest(
      AllServiceTypeEnum enumType, String id) async {
    return await _factory.getHandler(enumType).pushToPage(id);
  }

  void initController() async {
    isLoading = true;
    _reList.clear();

    if (appChangeNotifier.payload?.aud == 'CLIENT') {
      await getAllRequestsForClient(appChangeNotifier.payload?.sub! ?? '');
    } else {
      await getAllRequestsForDriver(appChangeNotifier.payload?.sub! ?? '');
    }
    isLoading = false;
    notifyListeners();
  }

  Future<bool> approveFunctionForOwner(
      {required String requestID,
      required AllServiceTypeEnum serviceTypeEnum,
      required BuildContext context}) async {
    notifyListeners();
    return await showCallOptions(context, assign: (String assignUserID) async {
      final data = await approveFunction(
          requestID: requestID,
          executorID: assignUserID,
          serviceTypeEnum: serviceTypeEnum);
      return data;
    });
  }

  Future<bool> approveFunction(
      {required String requestID,
      required String executorID,
      required AllServiceTypeEnum serviceTypeEnum}) {
    notifyListeners();
    return _factory
        .getHandler(serviceTypeEnum)
        .approveRequest(requestID, executorID);
  }

  Future<bool> cancelRequest(
      {required String requestID,
      required AllServiceTypeEnum serviceTypeEnum}) {
    notifyListeners();
    return _factory.getHandler(serviceTypeEnum).cancelRequest(requestID);
  }

  Future<void> getAllRequestsForDriver(String userID) async {
    final statuses = RequestStatus.CREATED.name;
    final data = await Future.wait([
      _factory
          .getHandler(AllServiceTypeEnum.MACHINARY)
          .getExecutorList(userID, statuses),
      _factory
          .getHandler(AllServiceTypeEnum.MACHINARY_CLIENT)
          .getExecutorList(userID, statuses),
      _factory
          .getHandler(AllServiceTypeEnum.EQUIPMENT)
          .getExecutorList(userID, statuses),
      _factory
          .getHandler(AllServiceTypeEnum.EQUIPMENT_CLIENT)
          .getExecutorList(userID, statuses),
      _factory
          .getHandler(AllServiceTypeEnum.CM)
          .getExecutorList(userID, statuses),
      _factory
          .getHandler(AllServiceTypeEnum.CM_CLIENT)
          .getExecutorList(userID, statuses),
      _factory
          .getHandler(AllServiceTypeEnum.SVM)
          .getExecutorList(userID, statuses),
      _factory
          .getHandler(AllServiceTypeEnum.SVM_CLIENT)
          .getExecutorList(userID, statuses),
    ]);
    final requestItemClassList = getFromSnapShot(data);
    _reList = requestItemClassList;
    _reList.sort((a, b) {
      final aType = a.type.name;
      final bType = b.type.name;
      if (aType.contains('CLIENT') && !bType.contains('CLIENT')) {
        return 1;
      } else if (!aType.contains('CLIENT') && bType.contains('CLIENT')) {
        return -1;
      } else {
        return 0;
      }
    });
  }

  Future<void> getAllRequestsForClient(String userID) async {
    final statuses = RequestStatus.CREATED.name;
    final data = await Future.wait([
      _factory
          .getHandler(AllServiceTypeEnum.MACHINARY)
          .getUserList(userID, statuses),
      _factory
          .getHandler(AllServiceTypeEnum.MACHINARY_CLIENT)
          .getUserList(userID, statuses),
      _factory
          .getHandler(AllServiceTypeEnum.EQUIPMENT)
          .getUserList(userID, statuses),
      _factory
          .getHandler(AllServiceTypeEnum.EQUIPMENT_CLIENT)
          .getUserList(userID, statuses),
      _factory.getHandler(AllServiceTypeEnum.CM).getUserList(userID, statuses),
      _factory
          .getHandler(AllServiceTypeEnum.CM_CLIENT)
          .getUserList(userID, statuses),
      _factory.getHandler(AllServiceTypeEnum.SVM).getUserList(userID, statuses),
      _factory
          .getHandler(AllServiceTypeEnum.SVM_CLIENT)
          .getUserList(userID, statuses),
    ]);
    final requestItemClassList = getFromSnapShot(data);
    _reList = requestItemClassList;
    _reList.sort((a, b) {
      final aType = a.type.name;
      final bType = b.type.name;

      if (aType.contains('CLIENT') && !bType.contains('CLIENT')) {
        return -1;
      } else if (!aType.contains('CLIENT') && bType.contains('CLIENT')) {
        return 1;
      } else {
        return 0;
      }
    });
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
          ownerID: int.parse(appChangeNotifier.payload?.sub ?? '-1'),
          endLeaseDate: e.endLeaseAt.toString(),
          priceForHour: (e.adSpecializedMachinery?.price ?? 0).toDouble(),
          createDate: e.createdAt.toString(),
          status: e.status ?? '',
          executorUser: AppChangeNotifier().userMode == UserMode.client ?  e.adSpecializedMachinery?.user : e.user ,
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
          executorUser: e.user,
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
          executorUser: AppChangeNotifier().userMode == UserMode.client ?  e.executor : e.user ,

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
          executorUser: e.user,
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
          executorUser: AppChangeNotifier().userMode == UserMode.client ?  e.executorUser : e.user ,

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
          executorUser: e.user,
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
          executorUser: AppChangeNotifier().userMode == UserMode.client ?  e.executor : e.user ,
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
          executorUser: e.user,
          address: e.adClient?.address ?? '');
    }).toList();
  }
}
