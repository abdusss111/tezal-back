import 'package:eqshare_mobile/app/app_safe_change_notifier.dart';
import 'package:eqshare_mobile/src/core/presentation/services/app_dialog_service.dart';
import 'package:eqshare_mobile/app/app_change_notifier.dart';

import 'package:eqshare_mobile/src/features/requests/data/models/specialized_machinery_request_models/specialized_machinery_request_client_model/specialized_machinery_request_client.dart';
import 'package:eqshare_mobile/src/features/requests/data/repository/sm_request_repository_impl.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart';

class SMClientCreatedRequestDetailController extends AppSafeChangeNotifier {
  final String requestId;
  bool isLoading = true;
  bool isLoadingInProgres = false;
  bool isContentEmpty = false;

  final appChangeProvide = AppChangeNotifier();

  SMClientCreatedRequestDetailController(this.requestId);

  SpecializedMachineryRequestClient? _requestDetails;

  SpecializedMachineryRequestClient? get requestDetails => _requestDetails;

  final _requestApiClient = SMRequestRepositoryImpl();

  Future<void> loadDetails() async {
    await appChangeProvide.getUserMode();


    _requestDetails =
        await _requestApiClient.getClientRequestDetailWC(requestId);
    if (kDebugMode) {
      print('_requestDetails:$_requestDetails');
    }
    isLoading = false;

    notifyListeners();
  }

  Future<void> onApprovePress(BuildContext context) async {
    AppDialogService.showLoadingDialog(context);

    Response? response = await _requestApiClient.postClientRequestApprove( requestId: requestId);
    if (!context.mounted) return;
    context.pop();
    if (response?.statusCode == 200) {
      showApproveDialog(context);
    }
  }

  Future<void> onCancelPress(BuildContext context) async {
    AppDialogService.showLoadingDialog(context);

    Response? response = await _requestApiClient.postClientRequestCancel( requestId: requestId);

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
}
