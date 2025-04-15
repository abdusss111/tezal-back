import 'dart:developer';

import 'package:eqshare_mobile/app/app_safe_change_notifier.dart';
import 'package:eqshare_mobile/src/core/data/models/user_model/user.dart';
import 'package:eqshare_mobile/src/core/data/services/network/api_client/user_profile_api_client.dart';
import 'package:eqshare_mobile/src/core/presentation/services/app_dialog_service.dart';
import 'package:eqshare_mobile/app/app_change_notifier.dart';
import 'package:eqshare_mobile/src/core/res/app_images.dart';
import 'package:eqshare_mobile/src/features/requests/data/models/equipment_request/equipment_request_model/request_ad_equipment.dart';

import 'package:eqshare_mobile/src/features/requests/data/repository/equipment_request_repository_impl.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart';



import '../../../../../../core/data/services/storage/token_provider_service.dart';

class EquipmentCreatedRequestDetailController extends AppSafeChangeNotifier {
  final String requestId;
  bool isLoading = true;
  bool isLoadingInProgres = false;
  bool isContentEmpty = false;
  final appChangeNotifier = AppChangeNotifier();

  EquipmentCreatedRequestDetailController(this.requestId);

  RequestAdEquipment? _requestDetails;
  // AdEquipmentClient? _requestDetails;


  RequestAdEquipment? get requestDetails => _requestDetails;

  final _workersApiClient = UserProfileApiClient();
  final _workers = <User>[];
  List<User> get workers => List.unmodifiable(_workers.toList());

  final _requestApiClient = EquipmentRequestRepositoryImpl();

  Future<void> setupWorkers(BuildContext context) async {
    final token = await TokenService().getToken();
    if (token == null) {
      return;
    }
    final payload = TokenService().extractPayloadFromToken(token);
    isLoading = true;
    isContentEmpty = false;

    notifyListeners();
    _workers.clear();

    if (context.mounted) {
      await _loadMyWorkers(context, payload.sub ?? '-1');
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> _loadMyWorkers(BuildContext context, String id) async {

    getUserModeInController();
    try {
      final token = await TokenService().getToken();
      if (token == null) return;
      if (!context.mounted) return;

      final payload = TokenService().extractPayloadFromToken(token);
      final workersResponse = await _workersApiClient.getMyWorkers(
        payload.sub ?? '1',
      );
      if (workersResponse != null) {
        _workers.addAll(workersResponse);

        notifyListeners();
      }
    } catch (e) {
      isLoadingInProgres = false;
    }
  }

  Future<String> getUserModeInController()async{
    return await appChangeNotifier.getUserMode();


  }
  
  Future<void> loadDetails(BuildContext context) async {
    // try {
    //   final token = await TokenService().getToken();
    //   final payload = TokenService().extractPayloadFromToken(token!);
    //   final response = await dio.Dio().get(
    //       '${ApiEndPoints.baseUrl}/equipment/request_ad_equipment_client/$requestId',
    //       queryParameters: {'id': int.parse(payload.sub!)},
    //       options:dio. Options(headers: {
    //         // 'Authorization': 'Bearer $token',
    //       }));
    //   if (response.statusCode == 200) {
    //     // log(response.data.toString());
    //     // "ad_equipment_client"
    //     // "ad_equipment_client" -> Map (21 items)
    //     final data = response.data;
    //     // final List<dynamic> dynamicList = data["request_ad_equipment"];
    //     final AdEquipmentClient adEquipmentList = AdEquipmentClient.fromJson(
    //         data["request_ad_equipment"]["ad_equipment_client"]);
    //     // _requestDetails = AdEquipmentClient.fromJson(json)e
    //     _requestDetails = adEquipmentList;
    //     // return adEquipmentList;
    //   } else {
    //     log(response.toString());
    //     return null;
    //   }
    // } catch (e) {
    //   log(e.toString(), name: "error on loadDetails : ");
    //   rethrow;
    // }
    await appChangeNotifier.getUserMode();
     final token = await TokenService().getToken();
      final payload = TokenService().extractPayloadFromToken(token!);


    log(( payload.toString()),name: 'payload : ');
    log((requestId .toString()),name: 'requestId : ');



    if (!context.mounted) return;

    // _requestDetails = await _requestApiClient.getEquipmentRequestClientDetail(
    //     requestId:requestId );
   
    if (!context.mounted) return;

    await setupWorkers(context);
    if (kDebugMode) {
      log('$_requestDetails',name:'RequestDetails :');
      log(requestId.toString(),name:'Get id from route :');

    }
    isLoading = false;

    notifyListeners();
  }

  Future<void> onAssignSelfPress(BuildContext context) async {
    AppDialogService.showLoadingDialog(context);

    Response? response = await _requestApiClient.postEquipmentRequestApprove( requestId: requestId);
    if (!context.mounted) return;

    // Navigator.pop(context);
    context.pop();
    if (response?.statusCode == 200) {
      showAssignSelfDialog(context);
    }
  }

  Future<void> onApprovePress(BuildContext context) async {

    
    AppDialogService.showLoadingDialog(context);
  

    Response? response = await _requestApiClient.postEquipmentRequestApprove( requestId: requestId,

        );
    if (!context.mounted) return;

    // Navigator.pop(context);
    context.pop();
    if (response?.statusCode == 200) {
      showApproveDialog(context);
    }
    log((response?.statusCode ?? 121).toString());
  }

  Future<void> onCancelPress(BuildContext context) async {
    AppDialogService.showLoadingDialog(context);

    Response? response = await _requestApiClient.postEquipmentRequestCancel( requestId: requestId);
    if (!context.mounted) return;

    // Navigator.pop(context);
    context.pop();
    if (response?.statusCode == 200) {
      showCancelDialog(context);
    }
  }

  void showApproveDialog(BuildContext context) {
    AppDialogService.showSuccessDialog(
      context,
      buttonText: 'Мои заказы',
      title: 'Заказ успешно согласован!',
      onPressed: () {
        // Navigator.pop(context);
        // Navigator.pop(context);
        context.pop();
        context.pop();
        
      },
    );
  }

  void showAssignSelfDialog(BuildContext context) {
    AppDialogService.showSuccessDialog(
      context,
      buttonText: 'Мои заказы',
      title: 'Заказ успешно согласован!',
      onPressed: () {
        // Navigator.pop(context);
        // Navigator.pop(context);
        // Navigator.pop(context);
        context.pop();
        context.pop();
        context.pop();
      },
    );
  }

  void showCancelDialog(BuildContext context) {
    AppDialogService.showSuccessDialog(
      context,
      buttonText: 'Мои заказы',
      title: 'Заказ отменен!',
      onPressed: () {
        // Navigator.pop(context);
        // Navigator.pop(context);
        context.pop();
        context.pop();
      },
    );
  }

  Future<void> _onApproveToDriverPress(
      BuildContext context, String workerId) async {
    AppDialogService.showLoadingDialog(context);

    Response? response =
        await _requestApiClient.postEquipmentRequestAssignToDriver( workerId: workerId, requestId: requestId);
    if (!context.mounted) return;
    // Navigator.pop(context);
    context.pop();
    if (response?.statusCode == 200) {
      _showApprovedToDriverDialog(context);
    }
  }

  Future<void> showCallOptions(BuildContext context) async {
    return showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.account_box_rounded),
              title: const Text('Назначить себе'),
              onTap: () async {
                await onAssignSelfPress(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.people_rounded),
              title: const Text('Назначить одному из моих водителей'),
              onTap: () async {
                _showModal(context);
              },
            ),
          ],
        );
      },
    );
  }

  void _showModal(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        final adClientInteractedList = workers;
        if (adClientInteractedList.isEmpty == true) {
          return SizedBox(
            height: MediaQuery.of(context).size.height * 0.8,
            child: const Center(
              child: Text('Нет данных о водителей'),
            ),
          );
        }
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.8,
          child: Column(
            children: [
              ListTile(
                leading: IconButton(
                  onPressed: () {
                    // Navigator.of(context).pop();
                    context.pop();
                  },
                  icon: const Icon(Icons.arrow_back),
                ),
                title: const Text('Ваши водители'),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: adClientInteractedList.length,
                  itemBuilder: (BuildContext context, int index) {
                    final ad = adClientInteractedList[index];
                    return GestureDetector(
                      onTap: () async {
                        await _onApproveToDriverPress(
                            context, ad.id.toString());
                      },
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Image.asset(
                              AppImages.profilePlaceholder,
                              width: 50,
                              height: 50,
                            ),
                            const SizedBox(width: 28),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  '${ad.firstName ?? ''} ${ad.lastName ?? ''}',
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Text(ad.phoneNumber ?? ''),
                                    const SizedBox(width: 28),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showApprovedToDriverDialog(BuildContext context) {
    AppDialogService.showSuccessDialog(
      context,
      title: 'Заказ успешно назначен водителю!',
      onPressed: () {
        // Navigator.pop(context);
        // Navigator.pop(context);
        // Navigator.pop(context);
        // Navigator.pop(context);
        context.pop();
        context.pop();
        context.pop();
        context.pop();
      },
      buttonText: 'Мои заказы',
    );
  }
}
