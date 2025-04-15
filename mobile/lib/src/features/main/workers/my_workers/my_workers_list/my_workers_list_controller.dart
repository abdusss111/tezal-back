import 'package:eqshare_mobile/app/app_safe_change_notifier.dart';
import 'package:eqshare_mobile/src/core/data/services/network/api_client/user_profile_api_client.dart';
import 'package:eqshare_mobile/src/core/presentation/services/app_dialog_service.dart';
import 'package:eqshare_mobile/app/app_change_notifier.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:eqshare_mobile/src/core/data/models/user_model/user.dart';

import '../../../../../core/data/services/storage/token_provider_service.dart';

class MyWorkersListController extends AppSafeChangeNotifier {
  bool _isLoading = true;
  final _workersApiClient = UserProfileApiClient();
  final _workers = <User>[];
  var isLoadingInProgres = false;
  bool isContentEmpty = false;
  bool _isListView = false;
  List<User> get workers => List.unmodifiable(_workers);
  bool get isLoading => _isLoading;
  bool get isListView => _isListView;
  bool hasError = false;
  String _searchString = '';
  String get searchString => _searchString;
  final appChangeNotifier = AppChangeNotifier();

  set searchString(String value) {
    _searchString = value;
    notifyListeners();
  }

  void toggleViewMode() {
    _isListView = !_isListView;
    notifyListeners();
  }

  Future<void> setupWorkers(BuildContext context) async {
    final token = await TokenService().getToken();
    if (token == null) return;

    final payload = TokenService().extractPayloadFromToken(token);

    _isLoading = true;
    isContentEmpty = false;
    notifyListeners();

    appChangeNotifier.checkConnectivity();

    if (context.mounted) {
      if (_workers.isEmpty) {
        await _loadMyWorkers(context, payload.sub ?? '-1');
      }
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> _loadMyWorkers(BuildContext context, String id) async {
    isLoadingInProgres = true;
    notifyListeners();

    try {
      final token = await TokenService().getToken();
      if (token == null || !context.mounted) return;

      final payload = TokenService().extractPayloadFromToken(token);
      final workersResponse = await _workersApiClient.getMyWorkers(payload.sub ?? '1');

      if (workersResponse != null) {
        _workers.clear();
        _workers.addAll(workersResponse);
        isContentEmpty = _workers.isEmpty;
      }
    } catch (e) {
      debugPrint('Error loading workers: $e');
    } finally {
      isLoadingInProgres = false;
      notifyListeners();
    }
  }

  Future<void> refreshAllWorkers(BuildContext context) async {
    final token = await TokenService().getToken();
    if (token == null) return;

    final payload = TokenService().extractPayloadFromToken(token);
    await _loadMyWorkers(context, payload.sub ?? '-1');
  }

  void onDeleteTap(BuildContext context, int? workerId) async {
    AppDialogService.showLoadingDialog(context);
    notifyListeners();

    final token = await TokenService().getToken();
    if (token == null || !context.mounted) return;
    final payload = TokenService().extractPayloadFromToken(token);
    await _workersApiClient.deleteWorker(ownerId: payload.sub, workerId: workerId);

    if (context.mounted) {
      context.pop();
      await setupWorkers(context);
      notifyListeners();
    }
  }

  void refreshWorkers(BuildContext context, String id) {
    setupWorkers(context);
  }
}