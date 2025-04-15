import 'dart:developer';

import 'package:eqshare_mobile/src/core/data/services/network/api_client/network_client.dart';
import 'package:eqshare_mobile/src/core/data/services/network/api_client/user_profile_api_client.dart';

import 'package:eqshare_mobile/src/core/data/services/storage/token_provider_service.dart';
import 'package:eqshare_mobile/src/core/presentation/services/app_dialog_service.dart';
import 'package:eqshare_mobile/src/core/presentation/utils/string_format_helper.dart';
import 'package:eqshare_mobile/src/features/requests/data/models/request_execution_list/request_execution.dart';
import 'package:eqshare_mobile/src/features/requests/data/repository/request_execution_repository.dart';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

class PaymentAmount {
  final int amount;

  PaymentAmount({required this.amount});

  factory PaymentAmount.fromJson(Map<String, dynamic> json) {
    return PaymentAmount(amount: json['sum_payment_amount']);
  }
}

class MyWorkerController with ChangeNotifier {
  final _networkClient = NetworkClient();
  bool _isLoading = false;
  // ignore: prefer_final_fields
  double _sumPaymentAmount = 0;
  String? currentUserId;
  bool get isLoading => _isLoading;
  double get sumPaymentAmount => _sumPaymentAmount;

  Future<PaymentAmount?> fetchSumPaymentAmount(
    int? workerId,
    String startDate,
    String endDate,
  ) async {
    _isLoading = true;
    notifyListeners();
    final queryParams = {
      if (workerId != null) 'assign_to': workerId.toString(),
      'min_updated_at': startDate.toString(),
      'max_updated_at': endDate.toString(),
    };

    final result = await _networkClient.aliGet(
        path: '/statistics/re/sum_payment_amount',
        fromJson: PaymentAmount.fromJson,
        queryParams: queryParams);
    Future.microtask(() {
      _isLoading = false;
      notifyListeners();
    });
    return result;
  }

  Future<List<RequestExecution>> fetchOrders(
    String? driverId,
    String? startDate,
    String? endDate,
  ) async {
    final requestExecutionRepo = RequestExecutionRepository();
    Map<String, dynamic> queryParams = {
      if (driverId != null) 'assign_to': driverId.toString(),
      if (startDate != null) 'min_updated_at': startDate.toString(),
      if (endDate != null) 'max_updated_at': endDate.toString(),
    };
    final token = await TokenService().getToken();
    if (token == null) return [];

    final result = await requestExecutionRepo
            .getListOfRequestExecutionForDriverOrOwnerList(map: queryParams) ??
        [];

    return result;
  }

  Future<bool> updateNickname(int userId, String newNickname) async {
    try {
      _isLoading = true; // Indicate loading state
      notifyListeners();

      // Call aliPut with the correct path and body
      final response = await _networkClient.aliPut(
        '/user/$userId/nick_name', // The API endpoint
        {'nick_name': newNickname},
        // JSON body with nickname key
      );

      log('New Nickname Sent: $newNickname'); // Log for debugging

      // Check response status and handle success
      if (response != null && response.statusCode == 200) {
        log('Nickname updated successfully');
        return true; // Return true on success
      } else {
        log('Failed to update nickname: ${response?.body}');
        return false; // Return false on failure
      }
    } catch (e) {
      debugPrint('Error updating nickname: $e'); // Log any errors
      return false;
    } finally {
      _isLoading = false; // Reset loading state
      notifyListeners();
    }
  }

  void onDeleteTap(BuildContext context, int? workerId) async {
    AppDialogService.showLoadingDialog(context);

    notifyListeners();
    final token = await TokenService().getToken();
    if (token == null) return;
    final payload = TokenService().extractPayloadFromToken(token);
    if (!context.mounted) return;

    await UserProfileApiClient()
        .deleteWorker(ownerId: payload.sub, workerId: workerId);

    if (!context.mounted) return;

    // Navigator.pop(context);
    context.pop();

    // Navigator.pop(context, true);
    context.pop(true);

    notifyListeners();
  }

  Future<void> onCallPressed(
      BuildContext context, String adId, String phoneNumber) async {
    try {
      final url = 'tel:$phoneNumber';
      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(Uri.parse(url));
      } else {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Невозможно совершить звонок'),
          ),
        );
      }
    } catch (e) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Произошла ошибка: $e'),
        ),
      );
    }
  }

  Future<void> onWhatsAppPressed(
      BuildContext context, String adId, String phoneNumber) async {
    try {
      await StringFormatHelper.tryOpenWhatsAppWithNumber(phoneNumber);
    } catch (e) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Произошла ошибка: $e'),
        ),
      );
    } finally {
      if (context.mounted) {
        // Navigator.pop(context);
        context.pop();
      }
    }
  }
}
