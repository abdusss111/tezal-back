import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:eqshare_mobile/app/app_safe_change_notifier.dart';
import 'package:eqshare_mobile/src/core/data/services/storage/token_provider_service.dart';
import 'package:eqshare_mobile/src/core/presentation/routing/app_route.dart';
import 'package:eqshare_mobile/src/core/presentation/services/app_dialog_service.dart';
import 'package:eqshare_mobile/src/core/presentation/widgets/app_snack_bar.dart';
import 'package:eqshare_mobile/src/core/res/api_endpoints/api_endpoints.dart';
import 'package:eqshare_mobile/src/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:eqshare_mobile/src/features/auth/domain/use_cases/auth_use_case.dart';
import 'package:eqshare_mobile/src/features/main/profile/profile_page/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class ForgetPasswordController extends AppSafeChangeNotifier {
  final AuthUseCase authUseCase = AuthUseCase(
    AuthRepositoryImpl(),
    TokenService(),
  );
  final formKey = GlobalKey<FormState>();
  final phoneNumberTextEditingController = TextEditingController();

  String _phoneNumber = '';
  bool _isIgnoring = true;
  bool _obscureText = true;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  bool get isIgnoring => _isIgnoring;
  bool get obscureText => _obscureText;
  String get phoneNumber => _phoneNumber;

  void setObsureText(bool value) {
    _obscureText = !_obscureText;
    notifyListeners();
  }

  void setPhoneNumber(String value) {
    _phoneNumber = value;
    final data = validatePhoneNumber(value);
    if (data) _isIgnoring = false;
    if (!data) _isIgnoring = true;
    notifyListeners();
  }

  void setIsIgnoring() {
    _isIgnoring = !_isIgnoring;
    notifyListeners();
  }

  bool validatePhoneNumber(String value) {
    if (value.isEmpty) {
      return false;
    }
    final data = value.replaceAll(RegExp(r'\D'), '').length == 10;
    return data;
  }

  void setErrorMessage(String value) {
    if (value.contains('many')) {
      _errorMessage = 'Слишком много попыток,попробуйте позже';
    }
    if (value.contains('user')) {
      _errorMessage = 'Такого клиента не существует';
    }
    if (value.isEmpty) {
      _errorMessage = '';
    }
    if (_errorMessage.isNotEmpty) {
      notifyListeners();
    }
  }

  Future<bool> sendCode(String phoneNumber) async {
    try {
      final editedPhoneNumber = phoneNumber.replaceAll(RegExp(r'\D'), '');
      log(editedPhoneNumber.toString(), name: '${DateTime.now()} : ');
      final data = await Dio()
          .post('${ApiEndPoints.baseUrl}/user/reset/password', data: {
        "phone": '+7$editedPhoneNumber',
      });
      return true;
    } on DioException catch (e) {
      final response = e.response;
      final responseData = response?.data;
      if (responseData is Map<String, dynamic>) {
        final error = responseData['error'] ?? '';
        if (error.isNotEmpty) {
          setErrorMessage(error);
        }
      }
      final error = e;
      log(error.toString());
      return false;
    }
  }

  Future<void> authenticate(
  BuildContext context, {
  required String phoneNumber,
  required String newPassword,
}) async {
  final password = newPassword;
  final phone = '+7${phoneNumber.replaceAll(RegExp(r'\D'), '')}';
  FocusScope.of(context).requestFocus(FocusNode());
  try {
    await authUseCase.authenticate(
      phone: phone,
      password: password,
      onSuccess: () async {
        // Показываем уведомление о успешном восстановлении пароля
        ScaffoldMessenger.of(context).showSnackBar(
          AppSnackBar.showSuccessSnackBar('Пароль успешно восстановлен!'),
        );
      final profileController = Provider.of<ProfileController>(context, listen: false);
        await profileController.loadProfile();
        // Переход на новую страницу
        context.go('/${AppRouteNames.navigation}', extra: {'index': '4'});
      },
      onError: (message) {
        ScaffoldMessenger.of(context).showSnackBar(
          AppSnackBar.showErrorSnackBar(message),
        );
        context.go('/${AppRouteNames.navigation}', extra: {'index': '4'});
        context.pop();

        if (message == 'Ошибка сервера') context.pop();
      },
      onLoading: () => AppDialogService.showLoadingDialog(context),
      onComplete: () {},
      context: context,
    );
  } catch (e) {
    debugPrint('catch');

    if (!context.mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(AppSnackBar.showErrorSnackBar(e.toString()));
    context.pop();
  }
  if (!context.mounted) return;
  FocusScope.of(context).unfocus();
}

}