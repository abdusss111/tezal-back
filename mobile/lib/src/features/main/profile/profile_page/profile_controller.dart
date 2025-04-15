import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:eqshare_mobile/app/app_safe_change_notifier.dart';
import 'package:eqshare_mobile/src/core/data/models/user_model/user.dart';
import 'package:eqshare_mobile/src/core/presentation/services/app_dialog_service.dart';
import 'package:eqshare_mobile/src/core/presentation/services/app_theme_provider.dart';
import 'package:eqshare_mobile/app/app_change_notifier.dart';
import 'package:eqshare_mobile/src/core/res/extensions/string_extensions.dart';
import 'package:eqshare_mobile/src/features/home/location_permission_status_widget.dart';
import 'package:eqshare_mobile/src/features/main/navigation/navigation_controller.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../../../../core/data/models/payload/payload.dart';
import '../../../../core/data/services/network/api_client/network_client.dart';
import '../../../../core/data/services/network/api_client/user_profile_api_client.dart';
import '../../../../core/data/services/storage/token_provider_service.dart';
import '../../../../core/domain/services/connectivity_service/connectivity_service.dart';
import '../../../../core/presentation/routing/app_route.dart';
import 'profile_controller_utils.dart';

enum UserMode {
  client,
  driver,
  owner,
  guest,
}

class ProfileController extends ChangeNotifier {
  final _apiClient = UserProfileApiClient();
  final TokenService _tokenProviderService = TokenService();
  final ConnectivityService _connectivityService = ConnectivityService();
  final AppChangeNotifier appChangeNotifier;

  User? _user;
  User? get user => _user;
  set user(value) => _user = value;
  Timer? _locationStatusTimer;
  bool _isLoading = true;
  bool isPuttingName = false;
  String _uid = '-1';

  bool get isLoading => _isLoading;

  String get uid => _uid;
  bool _isLocationTrackingEnabled = false;

  bool get isLocationTrackingEnabled => _isLocationTrackingEnabled;

  ProfileController({required this.appChangeNotifier}) {
    loadProfile();
  }

  Future<void> init() async {
    await getLocationStatus();
    notifyListeners();
  }

  void unnull() {
    _user = null;
    _uid = '-1';
    notifyListeners();
  }

  Future<User?> getUser() async {
    await _connectivityService.startMonitoring();

    final token = await _tokenProviderService.getToken();
    log(token.toString(), name: 'Token : ');
    if (token == null) {
      _isLoading = false;
      notifyListeners();
      return null;
    }
    final payload = _tokenProviderService.extractPayloadFromToken(token);
    _updateProfileData(payload);
    final userProfileResponse = await _apiClient.getUserDetail(_uid);
    _user = userProfileResponse;
    return userProfileResponse;
  }

  void isLoadingProfile() {
    _isLoading = true;
    notifyListeners();
  }

  Future<void> loadProfile() async {
    _isLoading = true;
    notifyListeners();
    await _connectivityService.startMonitoring();

    final token = await _tokenProviderService.getToken();
    log(token.toString(), name: 'Token : ');
    if (token == null) {
      _isLoading = false;
      notifyListeners();
      return;
    }
    final payload = _tokenProviderService.extractPayloadFromToken(token);
    _updateProfileData(payload);
    final userProfileResponse =
    await _apiClient.getUserDetail(payload.sub ?? _uid);
    if (userProfileResponse != null) {
      _user = userProfileResponse;
    }

    _isLoading = false;
    notifyListeners();
  }

  void _updateProfileData(Payload payload) {
    final audience = payload.aud;
    _uid = payload.sub ?? '-1';

    if (audience == ProfileControllerUtils.driverAudience) {
      appChangeNotifier.userMode = UserMode.driver;
    } else if (audience == ProfileControllerUtils.ownerAudience) {
      appChangeNotifier.userMode = UserMode.owner;
    } else {
      appChangeNotifier.userMode = UserMode.client;
    }
  }

  Future<void> switchMode({
    required BuildContext context,
    required UserMode userMode,
  }) async {
    try {
      if (userMode != UserMode.guest) {
        AppDialogService.showLoadingDialog(context);

        final response = await _switchUserMode(userMode);
        if (response?.statusCode != 200) {
          if (context.mounted) {
            context.pop();
          }
          return;
        }
        log(response!.statusCode.toString(), name: 'Switch Mode Status:');
        log(response.body.toString(), name: 'Switch Mode Response:');
        final json = jsonDecode(response.body);
        if (!context.mounted) return;
        _handleResponse(response.statusCode, json, context, userMode);

        // 🔥 Обновление userMode в глобальном AppChangeNotifier
        appChangeNotifier.userMode = userMode;
        appChangeNotifier.notifyListeners();
      } else {
        context.pushNamed(AppRouteNames.login);
      }
    } catch (e) {
      if (!context.mounted) return;
      _handleResponse(403, {}, context, userMode);

      _handleSwitchModeError(context, userMode, errorMessage: e.toString());
    }
  }

  Future<http.Response?> _switchUserMode(UserMode userMode) async {
    switch (userMode) {
      case UserMode.driver:
        return await _apiClient.postSwitchToDriver();
      case UserMode.owner:
        return await _apiClient.postSwitchToOwner();
      default:
        return await _apiClient.postSwitchToClient();
    }
  }

  Future<String?> patchWorkerImage(
      BuildContext context, File? pickedImage, int? workerId) async {
    final token = await _tokenProviderService.getToken();

    if (pickedImage == null && context.mounted) {
      ProfileControllerUtils.showErrorSnackbar(
          context, 'Изображение не выбрано');
      return null;
    }

    final response = await NetworkClient().aliPatch(
      path: '/user/${workerId}/custom_foto',
      imageFile: pickedImage!,
    );

    if (response != null && response.statusCode == 200) {
      pickedImage = null;

      final responseBody = jsonDecode(response.body);

      if (responseBody is Map<String, dynamic> &&
          responseBody['url'] is String) {
        final newImageUrl = responseBody['url'] as String;
        await loadProfile();
        return newImageUrl;
      } else {
        if (context.mounted) {
          ProfileControllerUtils.showErrorSnackbar(
              context, 'Не удалось обновить фото');
        }
        return null;
      }
    } else {
      if (context.mounted) {
        final errorMessage = response?.body;
        ProfileControllerUtils.showErrorSnackbar(
            context, errorMessage ?? 'Unexpected error');
      }
      return null;
    }
  }

  Future<void> patchUserImage(BuildContext context, File? pickedImage) async {
    final token = await _tokenProviderService.getToken();
    final payload = _tokenProviderService.extractPayloadFromToken(token!);

    if (pickedImage == null) {
      if (context.mounted) {
        ProfileControllerUtils.showErrorSnackbar(context, 'Изображение не выбрано');
      }
      return;
    }

    final response = await NetworkClient().aliPatch(
      path: '/user/${payload.sub}/foto',
      imageFile: pickedImage,
    );

    log('Upload Status Code: ${response?.statusCode}');
    log('Upload Response Body: ${response?.body}');

    if (response != null && response.statusCode == 200) {
      log('Фотография успешно загружена!');

      // 🔥 Обновляем локально фото пользователя
      final responseBody = jsonDecode(response.body);
      if (responseBody is Map<String, dynamic> && responseBody['url'] is String) {
        _user = _user?.copyWith(avatarUrl: responseBody['url']); // 🔥 Используем copyWith()
      }

      // 🔥 Перезагружаем профиль, чтобы получить актуальные данные
      await loadProfile();

      // 🔥 Обновляем UI
      notifyListeners();
    } else {
      final errorMessage = response?.body ?? 'Ошибка загрузки фото';
      if (context.mounted) {
        ProfileControllerUtils.showErrorSnackbar(context, errorMessage);
      }
    }
  }




  void _handleResponse(int statusCode, dynamic json, BuildContext context,
      UserMode userMode) async {
    if (statusCode == 200) {
      _handleSuccessfulResponse(json, context);
    } else if (statusCode == 403 && userMode == UserMode.driver) {
      final firstName = user?.firstName;
      final lastName = user?.lastName;
      if (firstName?.isNotEmpty == true && lastName?.isNotEmpty == true) {
        ProfileControllerUtils.navigateToDriverForm(
            context, UserNameInfo(firstName: firstName, lastName: lastName));
      } else {
        ProfileControllerUtils.navigateToDriverForm(context, null);
      }
    } else if (statusCode == 403 && userMode == UserMode.owner) {
      try {
        await _apiClient.postPurchaseOwnerRole();
        if (context.mounted) {
          final response = await _switchUserMode(UserMode.owner);
          log(response!.statusCode.toString(),
              name: 'Error on _handeLEReso : ');
          log(response.body.toString(), name: 'Error on _handeLEReso body :');
          final json = await jsonDecode(response.body);

          if (!context.mounted) return;
          AppChangeNotifier().init();

          _handleResponse(response.statusCode, json, context, userMode);
        }
      } catch (e) {
        if (!context.mounted) return;
        _handleSwitchModeError(context, userMode, errorMessage: e.toString());
      }
    } else if (statusCode == 401) {
    } else {
      _handleSwitchModeError(context, userMode);
    }
  }

  Future<void> _handleSuccessfulResponse(json, BuildContext context) async {
    final token = await json['Authorization']['access'] as String?;
    await _tokenProviderService.setToken(token);
    AppChangeNotifier().init();

    if (context.mounted) {
      await Provider.of<NavigationScreenController>(context, listen: false)
          .updateUserMode(context);
    }

    if (context.mounted) {
      ProfileControllerUtils.navigateToScreen(
          context, AppRouteNames.navigation);
    }
    if (token == null) return;
    if (context.mounted) ThemeManager.instance.updateTheme(context, token);
    if (context.mounted) context.pop();
  }

  void _handleSwitchModeError(BuildContext context, UserMode userMode,
      {String? errorMessage}) {
    context.pop();

    String message;

    switch (userMode) {
      case UserMode.driver:
        message = 'Cannot switch to driver mode';
      case UserMode.owner:
        message = 'Cannot switch to owner mode';
      default:
        message = 'Cannot switch to client mode';
    }
  }

  String getFormattedName() {
    final firstName = user?.firstName ?? '';
    final lastName = user?.lastName ?? '';
    if (firstName.isEmpty && lastName.isEmpty) return '';

    return '$firstName $lastName';
  }

  Future<bool> putUserName(
      {required String firstName, required String lastName}) async {
    isPuttingName = true;
    notifyListeners();
    final path = '/user/$uid/name';
    Map<String, String> headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    final token = await TokenService().getToken();
    headers['Authorization'] = 'Bearer $token';
    debugPrint(headers['Authorization'].toString());

    try {
      final body = {
        'first_name': firstName.trim().capitalizeFirstLetter(),
        'last_name': lastName.trim().capitalizeFirstLetter(),
      };

      debugPrint(body.toString());

      final response = await NetworkClient().aliPut(path, body);
      isPuttingName = false;
      notifyListeners();

      if (response?.statusCode == 200) {
        debugPrint(response?.body.toString());
        await loadProfile();
        return true;
      } else {
        debugPrint('status:${response?.statusCode}');

        return false;
      }
    } catch (e) {
      debugPrint(e.toString());
      throw (e.toString());
    }
  }

  Future<bool> putUserEmail({required String email}) async {
    await Future.delayed(Duration(seconds: 2));
    return false;
  }

  Future<bool> sendFeedback(BuildContext context,
      {required String description}) async {
    isPuttingName = true;
    notifyListeners();
    const path = '/report/system';
    Map<String, String> headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    final token = await TokenService().getToken();
    headers['Authorization'] = 'Bearer $token';
    debugPrint(headers['Authorization'].toString());

    try {
      final body = {
        'description': description.trim().capitalizeFirstLetter(),
        'report_reason_system_id': 1
      };

      final response = await NetworkClient().aliPost(path, body);
      isPuttingName = false;
      notifyListeners();

      if (response?.statusCode == 200) {
        await loadProfile();
        return true;
      } else {
        return false;
      }
    } catch (e) {
      debugPrint(e.toString());
      throw (e.toString());
    }
  }

  Future<void> sendLocationStatusBackground(bool isTrackingEnabled) async {
    const path = '/driver/location_status';
    Map<String, String> headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    final token = await TokenService().getToken();
    if (token == null) return;
    final payload = TokenService().extractPayloadFromToken(token);
    headers['Authorization'] = 'Bearer $token';

    try {
      final body = {
        'is_enabled': isTrackingEnabled,
      };

      final response = await _networkClient.aliPost(path, body);
      if (response?.statusCode == 200) {
        _isLocationTrackingEnabled = isTrackingEnabled;
        log('Location tracking updated: $isTrackingEnabled');
      }
    } catch (e) {
      debugPrint('Error updating location status: $e');
    }
    notifyListeners();
  }

  Future<void> sendLocationStatus(bool isTrackingEnabled) async {
    const path = '/driver/location_status';
    Map<String, String> headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    final token = await _tokenProviderService.getToken();
    headers['Authorization'] = 'Bearer $token';

    try {
      final body = {
        'is_enabled': isTrackingEnabled,
      };

      final response = await _networkClient.aliPost(path, body);
      if (response?.statusCode == 200) {
        _isLocationTrackingEnabled = isTrackingEnabled;
        log('Location tracking updated: $isTrackingEnabled');
      }
    } catch (e) {
      debugPrint('Error updating location status: $e');
    }
    notifyListeners();
  }

  final _networkClient = NetworkClient();
  Future<void> getLocationStatus() async {
    Map<String, String> headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    final token = await _tokenProviderService.getToken();
    headers['Authorization'] = 'Bearer $token';

    try {
      final response = await _networkClient.aliGet(
        path: '/driver/location_status',
        fromJson: (json) => json,
      );

      final status = response?['status'];
      _isLocationTrackingEnabled = status == 'enabled';
      log('Location tracking status: $_isLocationTrackingEnabled');
    } catch (e) {
      debugPrint('Error fetching location status: $e');
      _isLocationTrackingEnabled =
      false; // Default to disabled if the call fails
    }
    notifyListeners();
  }
}