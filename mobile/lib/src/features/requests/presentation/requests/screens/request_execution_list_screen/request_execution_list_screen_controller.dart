import 'dart:developer';

import 'package:eqshare_mobile/app/app_change_notifier.dart';
import 'package:eqshare_mobile/app/app_safe_change_notifier.dart';
import 'package:eqshare_mobile/src/core/presentation/routing/app_route.dart';
import 'package:eqshare_mobile/src/features/requests/presentation/requests/widgets/request_execution_card_item.dart';
import 'package:eqshare_mobile/src/global_widgets/global_values.dart';
import 'package:eqshare_mobile/src/features/requests/data/models/construction_request/construction_request/construction_request_model.dart';
import 'package:eqshare_mobile/src/features/requests/data/models/construction_request/construction_request_client/construction_request_client_model.dart';
import 'package:eqshare_mobile/src/features/requests/data/models/equipment_request/equipment_client_request_model/request_ad_equipment_client.dart';
import 'package:eqshare_mobile/src/features/requests/data/models/equipment_request/equipment_request_model/request_ad_equipment.dart';
import 'package:eqshare_mobile/src/features/requests/data/models/request_execution_list/request_execution.dart';
import 'package:eqshare_mobile/src/features/requests/data/models/service_request/service_request/service_request_model.dart';
import 'package:eqshare_mobile/src/features/requests/data/models/service_request/service_request_client/service_request_client_model.dart';
import 'package:eqshare_mobile/src/features/requests/data/models/specialized_machinery_request_models/specialized_machinery_request_client_model/specialized_machinery_request_client.dart';
import 'package:eqshare_mobile/src/features/requests/data/models/specialized_machinery_request_models/specialized_machinery_request_model/specialized_machinery_request.dart';
import 'package:eqshare_mobile/src/features/requests/data/repository/request_execution_repository.dart';
import 'package:eqshare_mobile/src/features/requests/presentation/requests/add_data_hadler.dart';
import 'package:eqshare_mobile/src/features/requests/presentation/requests/model/request_item_class.dart';
import 'package:flutter/material.dart';

class RequestExecutionListScreenController extends AppSafeChangeNotifier {
  List<RequestExecution> _reList = [];
  List<RequestItemClass> _reItemClass = [];

  List<RequestExecution> getReList() => _reList;
  List<RequestItemClass> getReItemClass() => _reItemClass;

  bool isLoading = true;

  final appChangeNotifier = AppChangeNotifier();
  final GlobalKey<AnimatedListState> listKey = GlobalKey();

  final RequestExecutionRepository _requestExecutionRepository;

  final RequestDataHandlerFactory _factory;

  RequestExecutionListScreenController({
    required RequestExecutionRepository requestExecutionRepository,
    required RequestDataHandlerFactory factory,
  })  : _requestExecutionRepository = requestExecutionRepository,
        _factory = factory;

  Future<void> deleteFromReList(RequestExecution request) async {
    final index = _reList.indexOf(request);
    _reList.removeAt(index);

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
    notifyListeners();
  }

  Widget buildItem(RequestExecution request, Animation<double> animation) {
    return SizeTransition(
        sizeFactor: animation,
        child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: RequestExecutionCardItem(
                requestScreenController: this,
                requestItemData: request,
                finishOrder: (
                    {required String requestID, required int amount}) {
                  return finish(amount: amount, requestID: requestID)
                      .then((value) {
                    // if (value) {
                    deleteFromReList(request);
                    // }
                  });
                },
                onTap: () {
                  onTapDriverRequestExecution(request).then((value) {
                    // setState(() {
                    initController();
                    // });
                  });
                })));
  }

  Future<void> initController({bool isFinishedScreen = false}) async {
    if (_reList.isNotEmpty) {
      isLoading = true;
      _reList.clear();
      notifyListeners();
    }
    if (isFinishedScreen) {
      await loadRequestExecutionForFinished();
      if (appChangeNotifier.payload!.aud == 'CLIENT') {
        await getAllRequestsForClient(appChangeNotifier.payload!.sub!);
      } else {
        await getAllRequestsForDriver(appChangeNotifier.payload!.sub!);
      }
      isLoading = false;
      notifyListeners();
    } else {
      await loadRequestExecution();
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadRequestExecution() async {
    log(DateTime.now().toString());
    try {
      final data = await _requestExecutionRepository
          .getListOfRequestExecutionWithBigData(
        status: [
          RequestStatus.AWAITS_START.name,
          RequestStatus.ON_ROAD.name,
          RequestStatus.PAUSE.name,
          RequestStatus.WORKING.name,
        ],
      );
      Map<String, int> statusOrder = {
        RequestStatus.WORKING.name: 1,
        RequestStatus.ON_ROAD.name: 2,
        RequestStatus.PAUSE.name: 3,
        RequestStatus.AWAITS_START.name: 4,
        RequestStatus.CANCELED.name: 6,
        RequestStatus.CREATED.name: 7,
        RequestStatus.FINISHED.name: 8,
        RequestStatus.DELETED.name: 8,
      };
      _reList = data ?? []
        ..sort((a, b) {
          final aSrc = a.status;
          final bSrc = b.status;

          final aOrder = statusOrder[aSrc] ?? 0;
          final bOrder = statusOrder[bSrc] ?? 0;
          return aOrder.compareTo(bOrder);
        });

      log(_reList.length.toString());
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<void> loadRequestExecutionForFinished() async {
    try {
      final data = await _requestExecutionRepository
          .getListOfRequestExecutionWithBigData(
        status: [
          RequestStatus.FINISHED.name,
        ],
      );
      Map<String, int> statusOrder = {
        RequestStatus.CANCELED.name: 2,
        RequestStatus.FINISHED.name: 1,
      };
      _reList = data ?? []
        ..sort((a, b) {
          final aSrc = a.status;
          final bSrc = b.status;
          final aOrder = statusOrder[aSrc] ?? 0;
          final bOrder = statusOrder[bSrc] ?? 0;
          return aOrder.compareTo(bOrder);
        });
      log(_reList.length.toString());
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<void> onTapDriverRequestExecution(
      RequestExecution selectedRequestItem) async {
    final type = selectedRequestItem.src ?? '';
    final Map<String, dynamic> extra = {
      'id': selectedRequestItem.id.toString()
    };
    final enumType = getAllServiceTypeEnumFromSRCStandart(type);

    switch (enumType) {
      case AllServiceTypeEnum.MACHINARY:
        await router.pushNamed(AppRouteNames.requestExecutionDetailSM,
            extra: extra);
        break;
      case AllServiceTypeEnum.MACHINARY_CLIENT:
        await router.pushNamed(AppRouteNames.requestExecutionDetailSM,
            extra: extra);
        break;
      case AllServiceTypeEnum.EQUIPMENT:
        await router.pushNamed(AppRouteNames.adEquipmentRequestDetail,
            extra: extra);
        break;
      case AllServiceTypeEnum.EQUIPMENT_CLIENT:
        await router.pushNamed(AppRouteNames.adEquipmentRequestDetail,
            extra: extra);
        break;
      case AllServiceTypeEnum.CM:
        await router.pushNamed(
            AppRouteNames.adConstructionRequesExecutiontDetailScreen,
            extra: extra);
        break;
      case AllServiceTypeEnum.CM_CLIENT:
        await router.pushNamed(
            AppRouteNames.adConstructionRequesExecutiontDetailScreen,
            extra: extra);
        break;
      case AllServiceTypeEnum.SVM:
        await router.pushNamed(
            AppRouteNames.adServiceRequesExecutiontDetailScreen,
            extra: extra);
        break;
      case AllServiceTypeEnum.SVM_CLIENT:
        await router.pushNamed(
            AppRouteNames.adServiceRequesExecutiontDetailScreen,
            extra: extra);
        break;
      default:
        router.goNamed(AppRouteNames.navigation);
        break;
    }
  }

  void setNewStatusOfRequestExecution(int id, String status) async {
    final requestExecution = _reList.firstWhere((e) => e.id == id);
    final newRequestExecution = requestExecution.copyWith(status: status);
    _reList[_reList.indexOf(requestExecution)] = newRequestExecution;
    notifyListeners();
    // = status;
  }

  Future<bool> rateOrder(
          {required int rating,
          required RequestExecution request,
          required String text}) =>
      _requestExecutionRepository.rateOrder(
          rating: rating, request: request, text: text);

  Future<bool> acceptOrder({required String requestID}) {
    notifyListeners();
    return _requestExecutionRepository.startOrAcceptRequestExecution(
        requestID: requestID);
  }

  Future<bool> pauseOrder({required String requestID}) {
    notifyListeners();
    return _requestExecutionRepository.pauseRequestExecution(
        requestID: requestID);
  }

  Future<bool> onRoad({required String requestID}) {
    notifyListeners();
    return _requestExecutionRepository.toRoadRequestExecution(
        requestID: requestID);
  }

  Future<bool> finish({required String requestID, required int amount}) {
    notifyListeners();
    return _requestExecutionRepository.finishRequestExecution(
        requestID: requestID, amount: amount);
  }

  Future<void> getAllRequestsForDriver(String userID) async {
    final statuses = RequestStatus.CANCELED.name;
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
    _reItemClass = requestItemClassList;
    _reItemClass.sort((a, b) {
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

  void onTapRequestItemCLass(AllServiceTypeEnum enumType, String id) {
    _factory.getHandler(enumType).pushToPage(id);
  }

  Future<void> getAllRequestsForClient(String userID) async {
    final statuses = RequestStatus.CANCELED.name;
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
    _reItemClass = requestItemClassList;
    _reItemClass.sort((a, b) {
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
