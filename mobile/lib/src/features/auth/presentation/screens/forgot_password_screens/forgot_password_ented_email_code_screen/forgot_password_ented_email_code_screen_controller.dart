import 'package:dio/dio.dart';
import 'package:eqshare_mobile/app/app_safe_change_notifier.dart';
import 'package:eqshare_mobile/src/core/res/api_endpoints/api_endpoints.dart';
import 'package:flutter/material.dart';

class ForgotPasswordEntedEmailCodeScreenController extends AppSafeChangeNotifier {
  bool isEmailValid = false;
  bool isPressedSendButton = false;
  bool isSendSuccess = false;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  bool _isValidEmail(String email) {
    final RegExp emailRegExp = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    final result = emailRegExp.hasMatch(email);
    return result;
  }

  String? validatorEmail(String? email) {
    final RegExp emailRegExp = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    if (email == null || email.isEmpty) {
      return 'Это поле не может быть пустым';
    }
    final result = emailRegExp.hasMatch(email);
    if (result) {
      return null;
    } else {
      return 'Введите корректный адрес электронной почты';
    }
  }

  bool isValidEmailFunc(String email) => _isValidEmail(email);

  void setIsEmailValid(String value) {
    isEmailValid = _isValidEmail(value);
    notifyListeners();
  }

  void setErrorMessage(String value) {
    _errorMessage = (value);
    notifyListeners();
  }

  void setIsSendSuccess(bool value) {
    isSendSuccess = value;
    notifyListeners();
  }

  void setisPressedSendButton(bool? value) {
    isPressedSendButton = value ?? isPressedSendButton;
    notifyListeners();
  }

  Future<String> sendCodeForThisEmail(String email) async {
    try {
      final response = await Dio()
          .post('${ApiEndPoints.baseUrl}/user/reset/password', data: {
        "email": email,
      });
      if (response.statusCode == 200) {
        return '';
      }
      setIsSendSuccess(true);

      return '';
    } on DioException catch (e) {
      final errorMessage = e.response?.data['error'] as String? ?? '';
      if (errorMessage.contains('user')) {
        _errorMessage = 'Такого пользователя нет';

      }
      if (errorMessage.contains('many')) {
        _errorMessage = 'Слишком много попыток, попробуйте позже';
      }

      return _errorMessage;
    }
  }
}
