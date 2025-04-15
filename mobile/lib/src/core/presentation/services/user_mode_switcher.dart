import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:eqshare_mobile/app/app_change_notifier.dart';
import 'package:eqshare_mobile/app/app_safe_change_notifier.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../data/models/payload/payload.dart';
import '../../data/services/network/api_client/user_profile_api_client.dart';
import '../../data/services/storage/token_provider_service.dart';
import '../routing/app_route.dart';
import 'app_dialog_service.dart';
import '../widgets/app_snack_bar.dart';
import '../widgets/connectivity_check_widget.dart';
import 'app_theme_provider.dart';

class ProfileController extends AppSafeChangeNotifier {
  final _apiClient = UserProfileApiClient();
  final _tokenProviderService = TokenService();
  final GlobalKey<ConnectivityCheckWidgetState> _connectivityWidgetKey =
      GlobalKey();

  bool _isLoading = true;
  String _uid = '-1';
  final bool _hasError = false;

  bool get isLoading => _isLoading;
  bool get hasError => _hasError;
  String get uid => _uid;
  GlobalKey<ConnectivityCheckWidgetState> get connectivityWidgetKey =>
      _connectivityWidgetKey;

  Future<void> loadProfile(BuildContext context) async {
    _isLoading = true;
    notifyListeners();

    _listenToConnectivity();

    final token = await _tokenProviderService.getToken();
    debugPrint(token ?? '');

    if (token == null) {
      return;
    }

    final payload = _tokenProviderService.extractPayloadFromToken(token);
    _updateProfileData(payload);

    _isLoading = false;
    notifyListeners();
  }

  void _listenToConnectivity() {
    Connectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult> result) {
      notifyListeners();
    });
  }

  void _handleTokenExpiration(BuildContext context) {
    if (context.mounted) {
      _tokenProviderService.getToken();
    }
  }

  void _updateProfileData(Payload payload) {
    AppChangeNotifier().updateProfileData(payload);
    _uid = payload.sub ?? '-2';
  }

  Future<void> switchMode({
    required BuildContext context,
    required bool toDriver,
  }) async {
    _isLoading = true;
    AppDialogService.showLoadingDialog(context);

    try {
      final response = await (toDriver
          ? _apiClient.postSwitchToDriver()
          : _apiClient.postSwitchToClient());

      debugPrint(response!.statusCode.toString());

      final json = await jsonDecode(response.body);

      if (response.statusCode == 200) {
        final token = await json['Authorization']['access'] as String?;
        debugPrint(token!);

        await _tokenProviderService.setToken(token);
        if (context.mounted) ThemeManager.instance.updateTheme(context, token);

        if (context.mounted) {
          // Navigator.of(context).pushNamedAndRemoveUntil(
          //   AppRouteNames.navigation,
          //   arguments: {'index': '4'},
          //   (route) => false,
          // );
          context.go('/' + AppRouteNames.navigation, extra: {'index': '4'});
        }
      } else if (response.statusCode == 403 && toDriver) {
        if (!context.mounted) return;

        // Navigator.pop(context);

        context.go('/' + AppRouteNames.navigation, extra: {'index': '4'});
        // Navigator.pushNamed(context, AppRouteNames.driverForm);
      } else {
        if (!context.mounted) return;

        _handleSwitchModeError(context, toDriver);
      }
    } catch (e) {
      if (!context.mounted) return;

      _handleSwitchModeError(context, toDriver, errorMessage: e.toString());
    }
    if (!context.mounted) return;

    _handleTokenExpiration(context);
  }

  void _handleSwitchModeError(BuildContext context, bool toDriver,
      {String? errorMessage}) {
    // Navigator.pop(context);
    // Navigator.pop(context);
    context.pop();
    context.pop();

    final message =
        toDriver ? 'Нельзя стать водителем' : 'Нельзя стать клиентом';

    ScaffoldMessenger.of(context).showSnackBar(
      AppSnackBar.showErrorSnackBar(
        errorMessage != null ? '$message: $errorMessage' : message,
      ),
    );
  }

  void reloadConnectivityWidget() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _connectivityWidgetKey.currentState?.retryConnectivity();
    });
  }
}
