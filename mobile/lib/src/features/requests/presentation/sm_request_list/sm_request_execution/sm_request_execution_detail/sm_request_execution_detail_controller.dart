import 'package:eqshare_mobile/app/app_safe_change_notifier.dart';
import 'package:eqshare_mobile/src/core/data/models/user_model/user.dart';

import 'package:eqshare_mobile/src/core/data/services/network/api_client/user_profile_api_client.dart';
import 'package:eqshare_mobile/src/core/presentation/services/app_dialog_service.dart';
import 'package:eqshare_mobile/app/app_change_notifier.dart';
import 'package:eqshare_mobile/src/core/res/app_images.dart';
import 'package:eqshare_mobile/src/features/requests/data/models/request_execution_list/request_execution.dart';
import 'package:eqshare_mobile/src/features/requests/data/repository/sm_request_repository_impl.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart';


import '../../../../../../core/data/services/storage/token_provider_service.dart';
import '../../../../../main/profile/profile_page/profile_controller.dart';

class SMRequestExecutionDetailController extends AppSafeChangeNotifier {
  final String requestId;
  bool isLoading = true;
  bool isLoadingInProgres = false;
  bool isContentEmpty = false;
  final appChangeProvider = AppChangeNotifier();
  SMRequestExecutionDetailController(this.requestId);

  RequestExecution? _requestDetails;

  RequestExecution? get requestDetails => _requestDetails;

  final _workersApiClient = UserProfileApiClient();
  final _workers = <User>[];

  List<User> get workers => List.unmodifiable(_workers.toList());

  final _requestApiClient = SMRequestRepositoryImpl();


  SMRequestRepositoryImpl get requestApiClient => _requestApiClient;

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
    isLoadingInProgres = true;

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
        if (_workers.isEmpty) {
          isContentEmpty = true;
        } else {
          isContentEmpty = false;
        }
        isLoadingInProgres = false;
        notifyListeners();
      }
    } catch (e) {
      isLoadingInProgres = false;
    }
  }

  Future<void> loadDetails(BuildContext context) async {
    isLoading = true;

    final token = await TokenService().getToken();
    if (token == null) {
      return;
    }

    final payload = TokenService().extractPayloadFromToken(token);

    switch (payload.aud) {
      case TokenService.driverAudience:
       appChangeProvider. userMode = UserMode.driver;
      case TokenService.ownerAudience:
        appChangeProvider.userMode = UserMode.owner;
      default:
        appChangeProvider.userMode = UserMode.client;
    }

    if (!context.mounted) return;

    try {
      _requestDetails =
          await _requestApiClient.getRequestExecutionDetail( requestID:  requestId);
    } catch (e) {
      print('Error fetching request $e');
    }
    if (!context.mounted) return;

    // await setupWorkers(context);
    if (kDebugMode) {
      print('_requestDetails:$_requestDetails');
    }
    isLoading = false;

    notifyListeners();
  }

  Future<void> onAssignSelfPress(BuildContext context) async {
    AppDialogService.showLoadingDialog(context);

    Response? response = await _requestApiClient.postSMRequestApprove( requestId: requestId);
    if (!context.mounted) return;

    // Navigator.pop(context);
    context.pop();
    if (response?.statusCode == 200) {
      showAssignSelfDialog(context);
    }
  }

  Future<void> onApprovePress(BuildContext context) async {
    AppDialogService.showLoadingDialog(context);

    Response? response = await _requestApiClient.postSMRequestApprove( requestId: requestId);
    if (!context.mounted) return;

    // Navigator.pop(context);
    context.pop();
    if (response?.statusCode == 200) {
      showApproveDialog(context);
    }
  }

  Future<void> onCancelPress(BuildContext context) async {
    AppDialogService.showLoadingDialog(context);

    Response? response = await _requestApiClient.postSMRequestCancel(requestId: requestId);
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

    Response? response = await _requestApiClient.postSMRequestAssignToDriver( workerId: workerId, requestId: requestId);
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
