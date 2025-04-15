import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:eqshare_mobile/app/app_change_notifier.dart';
import 'package:eqshare_mobile/src/core/presentation/services/app_theme_provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import '../../../../core/data/services/storage/token_provider_service.dart';
import '../../data/models/models.dart';
import '../repositories/auth_repository.dart';

class AuthUseCase {
  final AuthRepository _authRepository;
  final TokenService _tokenProviderService;

  AuthUseCase(this._authRepository, this._tokenProviderService);
  Future<void> authenticate({
    required String phone,
    required String password,
    required BuildContext context,
    required Function onSuccess,
    required Function(String) onError,
    required Function onLoading,
    required Function onComplete,
  }) async {
    onLoading();
    try {
      final response = await _authRepository.postAuthenticateUser(
        phone: phone,
        password: password,
      );

      if (response != null && response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final token = json['token']['access'] as String?;
        await _tokenProviderService.setToken(token);
        if (!context.mounted) return;
        ThemeManager.instance.updateTheme(context, token);

        if (Platform.isAndroid) {
          final fcmToken = await FirebaseMessaging.instance.getToken();
          log(fcmToken.toString(), name: 'fcmToken.toString()');
          await _authRepository.postSaveFCMToken(
            token: fcmToken,
          );
        }
        if (Platform.isIOS) {
          String? apnsToken;
          try {
            apnsToken = await FirebaseMessaging.instance.getAPNSToken();
            if (apnsToken == null) {
              await Future.delayed(const Duration(seconds: 3));
              apnsToken = await FirebaseMessaging.instance.getAPNSToken();
            } else {}
          } catch (e) {
            log(e.toString(), name: 'Error catch authenticate:');
            onError(e.toString());
          }
          await Future.delayed(Duration(seconds: 2));
          String? fcmToken;

          try {
            fcmToken = await FirebaseMessaging.instance.getToken();
            log(fcmToken.toString());
            await _authRepository.postSaveFCMToken(
              token: fcmToken,
            );
          } on Exception catch (e) {
            // TODO
            log(e.toString(), name: 'Error in : ');
          }

          log(fcmToken.toString(), name: 'Error in : ');
        }

        if (token == null) return;

        await AppChangeNotifier().init();

        onSuccess();
      } else if (response != null &&
          (response.statusCode == 401 ||
              response.body == "{'error':'not found'}" ||
              response.body == "{'error':'password doesn't match'}")) {
        onError('Введен неверный номер или пароль');
      } else {
        onError('Ошибка сервера');
      }
    } catch (e) {
      debugPrint('catch');
      onError(e.toString());
    } finally {
      onComplete();
    }
  }

  Future<void> authenticateWithEmail({
    required String email,
    required String password,
    required BuildContext context,
    required Function onSuccess,
    required Function(String) onError,
    required Function onLoading,
    required Function onComplete,
  }) async {
    onLoading();
    try {
      final response = await _authRepository.postAuthenticateUserWithEmail(
        email: email,
        password: password,
      );
      if (response != null && response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final token = json['token']['access'] as String?;
        await _tokenProviderService.setToken(token);
        if (!context.mounted) return;
        ThemeManager.instance.updateTheme(context, token);

        if (Platform.isAndroid) {
          final fcmToken = await FirebaseMessaging.instance.getToken();
          log(fcmToken.toString(), name: 'fcmToken.toString()');
          await _authRepository.postSaveFCMToken(
            token: fcmToken,
          );
        }
        if (Platform.isIOS) {
          String? apnsToken;
          try {
            apnsToken = await FirebaseMessaging.instance.getAPNSToken();
            if (apnsToken == null) {
              await Future.delayed(const Duration(seconds: 3));
              apnsToken = await FirebaseMessaging.instance.getAPNSToken();
            } else {}
          } catch (e) {
            log(e.toString(), name: 'Error catch authenticate:');
            onError(e.toString());
          }
          final fcmToken = await FirebaseMessaging.instance.getToken();
          log(fcmToken.toString());
          await _authRepository.postSaveFCMToken(
            token: fcmToken,
          );
        }

        if (token == null) return;

        await AppChangeNotifier().init();

        onSuccess();
      } else if (response != null &&
          (response.statusCode == 401 ||
              response.body == "{'error':'not found'}" ||
              response.body == "{'error':'password doesn't match'}")) {
        onError('Введен неверный номер или пароль');
      } else {
        onError('Ошибка сервера');
      }
    } catch (e) {
      debugPrint('catch');
      onError(e.toString());
    } finally {
      onComplete();
    }
  }

  Future<void> registerUser({
    required User userAuthData,
    required String password,
    required BuildContext context,
    required Function onSuccess,
    required Function(String) onError,
    required Function onLoading,
    required Function onComplete,
  }) async {
    onLoading();
    try {
      final registerResponse = await _authRepository.postRegisterUser(
        userAuthData: userAuthData,
        password: password,
      );
      if (registerResponse != null && registerResponse.statusCode == 200) {
        if (!context.mounted) return;
        final authResponse = await _authRepository.postAuthenticateUser(
          phone: userAuthData.phoneNumber,
          password: password,
        );

        final json = jsonDecode(authResponse!.body);
        final token = json['token']['access'] as String?;
        await _tokenProviderService.setToken(token);
        if (Platform.isAndroid) {
          final fcmToken = await FirebaseMessaging.instance.getToken();
          if (!context.mounted) return;
          log(fcmToken.toString(), name: 'fcmToken.toString()');
          await _authRepository.postSaveFCMToken(
            token: fcmToken,
          );
        }
        if (Platform.isIOS) {
          String? apnsToken;
          try {
            apnsToken = await FirebaseMessaging.instance.getAPNSToken();
            if (apnsToken == null) {
              await Future.delayed(const Duration(seconds: 3));
              apnsToken = await FirebaseMessaging.instance.getAPNSToken();
            } else {}
          } catch (exception) {}
          final fcmToken = await FirebaseMessaging.instance.getToken();
          log(fcmToken.toString());
          await _authRepository.postSaveFCMToken(
            token: fcmToken,
          );
        }
        await AppChangeNotifier().init();

        onSuccess();
      } else {
        if (registerResponse!.statusCode == 204) {
          onError('Данный номер уже зарегистрирован!');
        } else {
          onError('Не удалось зарегистрировать пользователя');
        }
      }
    } catch (e) {
      log(e.toString(), name: 'Error catch authenticate:');
      onError(e.toString());
    } finally {
      onComplete();
    }
  }
}
