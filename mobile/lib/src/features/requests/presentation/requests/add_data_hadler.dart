import 'package:eqshare_mobile/src/core/presentation/routing/app_route.dart';
import 'package:eqshare_mobile/src/global_widgets/global_values.dart';
import 'package:eqshare_mobile/src/features/requests/data/models/construction_request/construction_request_client/construction_request_client_model.dart';
import 'package:eqshare_mobile/src/features/requests/data/models/equipment_request/equipment_client_request_model/request_ad_equipment_client.dart';
import 'package:eqshare_mobile/src/features/requests/data/models/equipment_request/equipment_request_model/request_ad_equipment.dart';
import 'package:eqshare_mobile/src/features/requests/data/models/service_request/service_request/service_request_model.dart';

import 'package:eqshare_mobile/src/features/requests/data/models/service_request/service_request_client/service_request_client_model.dart';
import 'package:eqshare_mobile/src/features/requests/data/models/construction_request/construction_request/construction_request_model.dart';
import 'package:eqshare_mobile/src/features/requests/data/models/specialized_machinery_request_models/specialized_machinery_request_client_model/specialized_machinery_request_client.dart';
import 'package:eqshare_mobile/src/features/requests/data/models/specialized_machinery_request_models/specialized_machinery_request_model/specialized_machinery_request.dart';
import 'package:eqshare_mobile/src/features/requests/data/repository/ad_constructions_request_repository.dart';
import 'package:eqshare_mobile/src/features/requests/data/repository/ad_service_request_repository.dart';
import 'package:eqshare_mobile/src/features/requests/data/repository/equipment_request_repository_impl.dart';
import 'package:eqshare_mobile/src/features/requests/data/repository/sm_request_repository_impl.dart';

class RequestDataHandlerFactory {
  RequestAdDataHandler getHandler(AllServiceTypeEnum serviceType) {
    switch (serviceType) {
      case AllServiceTypeEnum.MACHINARY:
        return MachineryDataHandler();
      case AllServiceTypeEnum.EQUIPMENT:
        return EquipmentDataHandler();
      case AllServiceTypeEnum.CM:
        return CmDataHandler();
      case AllServiceTypeEnum.SVM:
        return SvmDataHandler();
      case AllServiceTypeEnum.MACHINARY_CLIENT:
        return MachineryClientDataHandler();
      case AllServiceTypeEnum.EQUIPMENT_CLIENT:
        return EquipmentClientDataHandler();
      case AllServiceTypeEnum.CM_CLIENT:
        return CmClientDataHandler();
      case AllServiceTypeEnum.SVM_CLIENT:
        return SvmClientDataHandler();
      default:
        throw Exception('Unknown service type');
    }
  }
}

abstract class RequestAdDataHandler {
  Future<List<dynamic>?> getExecutorList(String executorID, String status);
  Future<List<dynamic>?> getUserList(String userID, String status);
  Future<dynamic> getDetail(String getDetailID);
  Future<bool> approveRequest(String requestID, String executorID);
  Future<bool> cancelRequest(String requestID);
  Future<void> pushToPage(String requestID);
  Future<bool> reassignTheDriverButton(String requestID, String executorID);
}

class MachineryDataHandler implements RequestAdDataHandler {
  @override
  Future<List<SpecializedMachineryRequest>?> getExecutorList(
      String executorID, String status) {
    return SMRequestRepositoryImpl().getSMRequestList(
        adSpecializedMachineryUserId: executorID, status: status);
  }

  @override
  Future<List<SpecializedMachineryRequest>?> getUserList(
      String userID, String status) {
    return SMRequestRepositoryImpl()
        .getSMRequestList(userId: userID, status: status);
  }

  @override
  Future<SpecializedMachineryRequest?> getDetail(String getDetailID) {
    return SMRequestRepositoryImpl().getSMRequestDetail(getDetailID);
  }

  @override
  Future<bool> approveRequest(String requestID, String executorID) {
    return SMRequestRepositoryImpl()
        .postSMRequestApprove(requestId: requestID, executorID: executorID)
        .then((value) {
      return value?.statusCode == 200;
    });
  }

  @override
  Future<bool> cancelRequest(String requestID) {
    return SMRequestRepositoryImpl()
        .postSMRequestCancel(requestId: requestID)
        .then((value) {
      return value?.statusCode == 200;
    });
  }

  @override
  Future pushToPage(String requestID) async {
    router.pushNamed(AppRouteNames.smCreatedRequestDetail, // TODO
        extra: {'id': requestID});
  }

  @override
  Future<bool> reassignTheDriverButton(String requestID, String executorID) {
    return SMRequestRepositoryImpl().reAssingRequest(requestID, executorID);
  }
}

class MachineryClientDataHandler implements RequestAdDataHandler {
  @override
  Future<List<SpecializedMachineryRequestClient>?> getExecutorList(
      String executorID, String status) {
    return SMRequestRepositoryImpl()
        .getSMClientRequestList(userId: executorID, status: status);
  }

  @override
  Future<List<SpecializedMachineryRequestClient>?> getUserList(
      String userID, String status) {
    return SMRequestRepositoryImpl()
        .getSMClientRequestList(adClientUserId: userID, status: status);
  }

  @override
  Future<SpecializedMachineryRequestClient?> getDetail(String getDetailID) {
    return SMRequestRepositoryImpl().getClientRequestDetailWC(getDetailID);
  }

  @override
  Future<bool> approveRequest(String requestID, String executorID) {
    return SMRequestRepositoryImpl()
        .postClientRequestApprove(requestId: requestID)
        .then((value) {
      return value?.statusCode == 200;
    });
  }

  @override
  Future<bool> cancelRequest(String requestID) {
    return SMRequestRepositoryImpl()
        .postClientRequestCancel(requestId: requestID)
        .then((value) {
      return value?.statusCode == 200;
    });
  }

  @override
  Future pushToPage(String requestID) async {
    router.pushNamed(AppRouteNames.smClientCreatedRequestDetail,
        extra: {'id': requestID});
  }

  @override
  Future<bool> reassignTheDriverButton(String requestID, String executorID) {
    return SMRequestRepositoryImpl()
        .reAssingClientRequest(requestID, executorID);
  }
}

class EquipmentDataHandler implements RequestAdDataHandler {
  @override
  Future<List<RequestAdEquipment>?> getExecutorList(
      String executorID, String status) {
    return EquipmentRequestRepositoryImpl().getEquipmentRequestList(
        adEquipmentUserIds: executorID, status: status);
  }

  @override
  Future<List<RequestAdEquipment>?> getUserList(String userID, String status) {
    return EquipmentRequestRepositoryImpl()
        .getEquipmentRequestList(userIds: userID, status: status);
  }

  @override
  Future<RequestAdEquipment?> getDetail(String getDetailID) {
    return EquipmentRequestRepositoryImpl()
        .getEquipmentRequestDetailWC(getDetailID);
  }

  @override
  Future<bool> approveRequest(String requestID, String executorID) {
    return EquipmentRequestRepositoryImpl()
        .postEquipmentRequestApprove(requestId: requestID,executorID: executorID)
        .then((value) {
      return value?.statusCode == 200;
    });
  }

  @override
  Future<bool> cancelRequest(String requestID) {
    return EquipmentRequestRepositoryImpl()
        .postEquipmentRequestCancel(requestId: requestID)
        .then((value) {
      return value?.statusCode == 200;
    });
  }

  @override
  Future pushToPage(String requestID) async {
    router.pushNamed(AppRouteNames.equipmentCreatedRequestDetail,
        extra: {'id': requestID});
  }

  @override
  Future<bool> reassignTheDriverButton(String requestID, String executorID) {
    return EquipmentRequestRepositoryImpl()
        .reAssingEquipmentRequest(requestID, executorID);
  }
}

class EquipmentClientDataHandler implements RequestAdDataHandler {
  @override
  Future<List<RequestAdEquipmentClient>?> getExecutorList(
      String executorID, String status) {
    return EquipmentRequestRepositoryImpl()
        .getEquipmentClientRequestList(userId: executorID, status: status);
  }

  @override
  Future<List<RequestAdEquipmentClient>?> getUserList(
      String userID, String status) {
    return EquipmentRequestRepositoryImpl()
        .getEquipmentClientRequestWhereAuthorISClient(
            userId: userID, status: status);
  }

  @override
  Future<RequestAdEquipmentClient?> getDetail(String getDetailID) {
    return EquipmentRequestRepositoryImpl()
        .getRequestAdEquipmentClientDetail(requestId: getDetailID);
  }

  @override
  Future<bool> approveRequest(String requestID, String executorID) {
    return EquipmentRequestRepositoryImpl()
        .postEquipmentClientRequestApprove(requestId: requestID)
        .then((value) {
      return value?.statusCode == 200;
    });
  }

  @override
  Future<bool> cancelRequest(String requestID) {
    return EquipmentRequestRepositoryImpl()
        .postEquipmentClientRequestCancel(requestId: requestID)
        .then((value) {
      return value?.statusCode == 200;
    });
  }

  @override
  Future pushToPage(String requestID) async {
    router.pushNamed(AppRouteNames.equipmentCreatedClientRequestDetail,
        extra: {'id': requestID});
  }

  @override
  Future<bool> reassignTheDriverButton(String requestID, String executorID) {
    return EquipmentRequestRepositoryImpl()
        .reAssingClientEquipmentRequest(requestID, executorID);
  }
}

class CmDataHandler implements RequestAdDataHandler {
  @override
  Future<List<ConstructionRequestModel>?> getExecutorList(
      String executorID, String status) {
    return AdConstructionsRequestRepository()
        .getDriverOrOwnerRequestsAwaitsTheirApproved(
            clientID: executorID, status: status);
  }

  @override
  Future<List<ConstructionRequestModel>?> getUserList(
      String userID, String status) {
    return AdConstructionsRequestRepository()
        .getClientRequestsListAwaitsApprovedFromDriverOrOwner(
            clientID: userID, status: status);
  }

  @override
  Future<ConstructionRequestModel?> getDetail(String getDetailID) {
    return AdConstructionsRequestRepository()
        .getDriverRequestDetailAwaitsApprovedFromClient(
            adServiceRequestID: getDetailID);
  }

  @override
  Future<bool> approveRequest(String requestID, String executorID) {
    return AdConstructionsRequestRepository()
        .approveClientRequestFromDriverOrOwner(requestID, workerID: executorID)
        .then((value) {
      return value;
    });
  }

  @override
  Future<bool> cancelRequest(String requestID) {
    return AdConstructionsRequestRepository()
        .cancelClientRequestsWhereAuthorFromAccountDriverOrOwner(requestID)
        .then((value) {
      return value;
    });
  }

  @override
  Future pushToPage(String requestID) async {
    router.pushNamed(AppRouteNames.adConstructionRequestDetailScreen,
        extra: {'id': requestID});
  }

  @override
  Future<bool> reassignTheDriverButton(String requestID, String executorID) {
    return AdConstructionsRequestRepository()
        .reAssingConstructionMaterialRequest(requestID, executorID);
  }
}

class CmClientDataHandler implements RequestAdDataHandler {
  @override
  Future<List<ConstructionRequestClientModel>?> getExecutorList(
      String executorID, String status) {
    return AdConstructionsRequestRepository()
        .getDriverRequestsListAwaitsApprovedFromClient(
            driverOrOwnerID: executorID, status: status);
  }

  @override
  Future<List<ConstructionRequestClientModel>?> getUserList(
      String userID, String status) {
    return AdConstructionsRequestRepository()
        .getClientRequestsWhereNeedsAprovedFromClient(
            clientID: userID, status: status);
  }

  @override
  Future<ConstructionRequestClientModel?> getDetail(String getDetailID) {
    return AdConstructionsRequestRepository()
        .getClientRequestDetailAwaitsApprovedFromDriverOrOwner(
            adServiceRequestID: getDetailID);
  }

  @override
  Future<bool> approveRequest(String requestID, String executorID) {
    return AdConstructionsRequestRepository()
        .approveDriverOrOwnerRequestFromClientAccount(requestID)
        .then((value) {
      return value;
    });
  }

  @override
  Future<bool> cancelRequest(String requestID) {
    return AdConstructionsRequestRepository()
        .cancelDriverOrOwnerRequestsWhereAuthorFromClientAccount(requestID)
        .then((value) {
      return value;
    });
  }

  @override
  Future pushToPage(String requestID) async {
    router.pushNamed(AppRouteNames.adConstructionRequesClientDetailScreen,
        extra: {'id': requestID});
  }

  @override
  Future<bool> reassignTheDriverButton(String requestID, String executorID) {
    return AdConstructionsRequestRepository()
        .reAssingClientConstructionMaterialRequest(requestID, executorID);
  }
}

class SvmDataHandler implements RequestAdDataHandler {
  @override
  Future<List<ServiceRequestModel>?> getExecutorList(
      String executorID, String status) {
    return AdServiceRequestRepository()
        .getClientRequestsListAwaitsDriverOrOwnerApprove(
            driverOrOwner: executorID, status: status);
  }

  @override
  Future<List<ServiceRequestModel>?> getUserList(String userID, String status) {
    return AdServiceRequestRepository()
        .getClientRequestsListAwaitsApprovedFromDriverOrOwner(
            clientID: userID, status: status);
  }

  @override
  Future<ServiceRequestModel?> getDetail(String getDetailID) {
    return AdServiceRequestRepository()
        .getDriverRequestDetailAwaitsApprovedFromClient(
            adServiceRequestID: getDetailID);
  }

  @override
  Future<bool> approveRequest(String requestID, String executorID) {
    return AdServiceRequestRepository()
        .approveClientRequestFromDriverOrOwner(requestID, workerID: executorID)
        .then((value) {
      return value;
    });
  }

  @override
  Future<bool> cancelRequest(String requestID) {
    return AdServiceRequestRepository()
        .cancelClientRequestFromDriverOrOwner(requestID)
        .then((value) {
      return value;
    });
  }

  @override
  Future pushToPage(String requestID) async {
    router.pushNamed(AppRouteNames.adServiceRequestDetailScreen,
        extra: {'id': requestID});
  }

  @override
  Future<bool> reassignTheDriverButton(String requestID, String executorID) {
    return AdServiceRequestRepository()
        .reassingServiceRequest(requestID, executorID);
  }
}

class SvmClientDataHandler implements RequestAdDataHandler {
  @override
  Future<List<ServiceRequestClientModel>?> getExecutorList(
      String executorID, String status) {
    return AdServiceRequestRepository()
        .getDriverRequestsListAwaitsApprovedFromClient(
            driverOrOwnerID: executorID, status: status);
  }

  @override
  Future<List<ServiceRequestClientModel>?> getUserList(
      String userID, String status) {
    return AdServiceRequestRepository()
        .getClientRequestsWhereNeedsAprovedFromClient(
            clientID: userID, status: status);
  }

  @override
  Future<ServiceRequestClientModel?> getDetail(String getDetailID) {
    return AdServiceRequestRepository()
        .getClientRequestDetailAwaitsApprovedFromDriverOrOwner(
            adServiceRequestID: getDetailID);
  }

  @override
  Future<bool> approveRequest(String requestID, String executorID) {
    return AdServiceRequestRepository()
        .approveDriverOrOwnerRequestFromClient(requestID)
        .then((value) {
      return value;
    });
  }

  @override
  Future<bool> cancelRequest(String requestID) {
    return AdServiceRequestRepository()
        .cancelDriverOrOwnerRequestFromClient(requestID)
        .then((value) {
      return value;
    });
  }

  @override
  Future pushToPage(String requestID) async {
    router.pushNamed(AppRouteNames.adServiceClientRequestDetailScreen,
        extra: {'id': requestID});
  }

  @override
  Future<bool> reassignTheDriverButton(String requestID, String executorID) {
    return AdServiceRequestRepository()
        .reassingClientServiceRequest(requestID, executorID);
  }
}
