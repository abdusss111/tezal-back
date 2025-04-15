import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:eqshare_mobile/src/core/data/services/network/api_client/network_client.dart';
import 'package:eqshare_mobile/src/core/data/services/storage/token_provider_service.dart';

class ChatsController with ChangeNotifier {
  final List<NotificationMessage> _allNotifications = [];
  final _networkClient = NetworkClient();
  final _tokenService = TokenService();

  List<NotificationMessage> get allNotifications => _allNotifications;

  Future<void> loadNotifications() async {
    try {
      final notifications = await _fetchNotifications();

      if (notifications.isNotEmpty) {
        _allNotifications.clear();

        final role = notifications.firstOrNull?.accessRole ?? 'UNKNOWN';

        _allNotifications.addAll(notifications.map((n) {
          final fullName = n.full_name;

          if (role == 'OWNER') {
            return n.copyWith(
              full_name: 'Вы отправили заявку водителю: $fullName',
            );
          } else if (role == 'DRIVER') {
            return n.copyWith(
              full_name: '$fullName',
            );
          }
          return n;
        }));
      }

      notifyListeners();
    } catch (e) {
      debugPrint('Ошибка загрузки уведомлений: $e');
    }
  }

  Future<List<NotificationMessage>> _fetchNotifications() async {
    try {
      print('Отправляем запрос на сервер...');
      final String? token = await _tokenService.getToken();
      if (token == null) {
        print('Ошибка: токен не найден');
        return [];
      }

      final response = await _networkClient.aliGet3(
        '/notification/owner_driver',
        headers: {
          'Authorization': 'Bearer $token',
        },
        fromJson: (json) {
          final List<NotificationMessage> notifications = [];
          if (json is Map<String, dynamic>) {
            final accessRole = json['access_role'] ?? 'UNKNOWN';
            final notificationsJson = json['notifications'] as List<dynamic>?;

            if (notificationsJson != null) {
              for (var item in notificationsJson) {
                final notification = NotificationMessage.fromJson(
                  item as Map<String, dynamic>,
                  accessRole: accessRole,
                );
                notifications.add(notification);
              }
            }
          }
          return notifications;
        },
      );

      return response ?? [];
    } catch (e) {
      debugPrint('Ошибка при получении уведомлений: $e');
      return [];
    }
  }

  Future<void> respondToNotification(int ownerId, bool accept) async {
    try {
      print('Отправка отклика на уведомление ownerId: $ownerId, accept: $accept');

      final String? token = await _tokenService.getToken();
      if (token == null) {
        print('Ошибка: токен не найден');
        return;
      }

      final response = await _networkClient.aliPost(
        '/driver/driver/respond/$ownerId?accept=$accept',
        {},
      );

      if (response != null && response.statusCode == 200) {
        print('Отклик отправлен успешно. Обновляем уведомления...');
        loadNotifications();
      } else {
        print('Ошибка при отправке отклика: ${response?.statusCode}');
      }
    } catch (e) {
      debugPrint('Ошибка при ответе на уведомление: $e');
    }
  }
}

class NotificationMessage {
  final String createdAt;
  final int driverId;
  final int ownerId;
  final String full_name;
  final String status;
  final String updatedAt;
  final String accessRole;

  NotificationMessage({
    required this.createdAt,
    required this.driverId,
    required this.ownerId,
    required this.full_name,
    required this.status,
    required this.updatedAt,
    required this.accessRole,
  });

  factory NotificationMessage.fromJson(
      Map<String, dynamic> json, {
        required String accessRole,
      }) {
    return NotificationMessage(
      createdAt: json['created_at'] ?? '',
      driverId: json['driver_id'] ?? 0,
      ownerId: json['owner_id'] ?? 0,
      full_name: _decodeUtf8(json['full_name'] ?? 'Имя не указано'),
      status: json['status'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      accessRole: accessRole,
    );
  }

  static String _decodeUtf8(dynamic input) {
    try {
      // Если входные данные - это List<int> (массив байтов)
      if (input is List<int>) {
        return utf8.decode(input);
      }
      // Если входные данные уже строка, возвращаем их как есть
      return input.toString();
    } catch (e) {
      debugPrint('Ошибка декодирования UTF-8: $e');
      return input.toString();
    }
  }



  NotificationMessage copyWith({
    String? full_name,
    String? status,
  }) {
    return NotificationMessage(
      createdAt: createdAt,
      driverId: driverId,
      ownerId: ownerId,
      full_name: full_name ?? this.full_name,
      status: status ?? this.status,
      updatedAt: updatedAt,
      accessRole: accessRole,
    );
  }
}
