// import 'dart:developer';

// import 'package:dio/dio.dart' as dioPackage;
// import 'package:eqshare_mobile/src/core/data/services/storage/token_provider_service.dart';
// import 'package:eqshare_mobile/src/core/presentation/services/app_dialog_service.dart';
// import 'package:eqshare_mobile/app/app_change_notifier.dart';
// import 'package:eqshare_mobile/src/core/res/api_endpoints/api_endpoints.dart';
// import 'package:eqshare_mobile/src/features/ad/data/models/ad_equipment_models/ad_equipment_client_model/ad_equipment_client.dart';
// import 'package:eqshare_mobile/src/features/requests/data/repository/equipment_request_repository_impl.dart';

// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:http/http.dart';

// class EquipmentClientCreatedRequestDetailController extends AppChangeNotifier {
//   final String requestId;
//   bool isLoading = true;
//   bool isLoadingInProgres = false;
//   bool isContentEmpty = false;

//   EquipmentClientCreatedRequestDetailController(this.requestId);

//   // TODO MIGRATE TO EQUIPMENT

//   AdEquipmentClient? _requestDetails;

//   AdEquipmentClient? get requestDetails => _requestDetails;

//   final _requestApiClient = EquipmentRequestRepositoryImpl();

//   Future<AdEquipmentClient?> loadDetails(BuildContext context) async {
//     await getUserMode();

//     // if (!context.mounted) return;

//     // _requestDetails = await _requestApiClient.getEquipmentClientRequestDetail(
//     //     requestId, context);
//     // if (kDebugMode) {
//     //   print('_requestDetails:$_requestDetails');
//     // }
//     isLoading = false;
//     final dio = dioPackage.Dio();

//     try {
//       final token = await TokenService().getToken();
//       final payload = TokenService().extractPayloadFromToken(token!);
//       final response = await dio.get(
//           '${ApiEndPoints.baseUrl}/equipment/request_ad_equipment_client/$requestId',
//           queryParameters: {'id': int.parse(payload.sub!)},
//           options: dioPackage.Options(headers: {
//             // 'Authorization': 'Bearer $token',
//           }));
//       if (response.statusCode == 200) {
//         // log(response.data.toString());
//         // "ad_equipment_client"
//         // "ad_equipment_client" -> Map (21 items)
//         final data = response.data;
//         // final List<dynamic> dynamicList = data["request_ad_equipment"];
//         final AdEquipmentClient adEquipmentList = AdEquipmentClient.fromJson(
//             data["request_ad_equipment"]["ad_equipment_client"]);

//         // _requestDetails = AdEquipmentClient.fromJson(json)e
//         _requestDetails = adEquipmentList;
//         return adEquipmentList;
//       } else {
//         log(response.toString());
//         return null;
//       }
//     } catch (e) {
//       log(e.toString(), name: "error on loadDetails : ");
//       rethrow;
//     }

//   }

//   Future<void> onApprovePress(BuildContext context) async {
//     AppDialogService.showLoadingDialog(context);

//     Response? response =
//         await _requestApiClient.postEquipmentClientRequestApprove( requestId: requestId);
//     if (!context.mounted) return;
//     // Navigator.pop(context);
//     context.pop();
//     if (response?.statusCode == 200) {
//       showApproveDialog(context);
//     }
//   }

//   Future<void> onCancelPress(BuildContext context) async {
//     AppDialogService.showLoadingDialog(context);

//     Response? response =
//         await _requestApiClient.postEquipmentClientRequestCancel( requestId: requestId);

//     if (!context.mounted) return;

//     // Navigator.pop(context);
//     context.pop();
//     if (response?.statusCode == 200) {
//       showCancelDialog(context);
//     }
//   }

//   void showApproveDialog(BuildContext context) {
//     AppDialogService.showSuccessDialog(
//       context,
//       buttonText: 'Мои заказы',
//       title: 'Заказ успешно согласован!',
//       onPressed: () {
//         // Navigator.pop(context);
//         // Navigator.pop(context);
//         context.pop();
//         context.pop();
//       },
//     );
//   }

//   void showCancelDialog(BuildContext context) {
//     AppDialogService.showSuccessDialog(
//       context,
//       buttonText: 'Мои заказы',
//       title: 'Заказ отменен!',
//       onPressed: () {
//         // Navigator.pop(context);
//         // Navigator.pop(context);
//         context.pop();
//         context.pop();
//       },
//     );
//   }
// }
