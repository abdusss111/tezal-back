import 'dart:convert';
import 'dart:developer';


import 'package:eqshare_mobile/src/core/data/services/network/api_client/network_client.dart';
import 'package:eqshare_mobile/src/core/data/services/network/notification_api/on_select_notification.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as timezone;
import 'package:timezone/timezone.dart' as timezone;

class NotificationApi {
  static final _notification = FlutterLocalNotificationsPlugin();

  static void init() {
    _notification.initialize(
      onDidReceiveNotificationResponse: onSelectNotification,
      const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings(),
      ),
    );
  }

  static scheduleNotification() async {
    timezone.initializeTimeZones();
    var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
      'channel id',
      'channel name',
      channelDescription: 'channel description',
      importance: Importance.max,
      priority: Priority.high,
    );
    var iOSPlatformChannelSpecifics = const DarwinNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );
    await _notification.zonedSchedule(
        2,
        'notification title',
        'Message goes here',
        timezone.TZDateTime.now(timezone.local)
            .add(const Duration(seconds: 10)),
        platformChannelSpecifics,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        androidAllowWhileIdle: true);
  }

  static pushNotification(RemoteMessage message) async {
    var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
      'channed id',
      'channel name',
      channelDescription: 'channel description',
      importance: Importance.max,
      priority: Priority.high,
    );

    var iOSPlatformChannelSpecifics = const DarwinNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );
    final payload = json.encode(message.data.toString());
    await _notification.show(1, message.notification?.title,
        message.notification?.body, platformChannelSpecifics,
        payload: payload);
  }

  static Future<void> onSelectNotification(
      NotificationResponse response) async {
    try {
      final newResponse = response;
      String result = response.payload?.replaceFirst(RegExp(r'^.*?,\s*'), '') ??
          '{"empty": "empty"}';
      // if (response.payload != null) {
      final mapString = result.replaceAll("\"", "");

      final lastString = mapString.substring(0, mapString.length - 1);

      String jsonString = lastString
          .replaceAllMapped(RegExp(r'(\w+):'), (match) => '"${match[1]}":')
          .replaceAllMapped(
              RegExp(
                  r'(?<=: )([a-zA-Z_]+[a-zA-Z_0-9]*|\d{4}-\d{2}-\d{2}.*?\d+)'),
              (match) => '"${match[1]}"');

      late Map<String, dynamic> mapData;
      final mapStringLast = '{$jsonString}';
      log(mapStringLast, name: 'mapStringLast');

      try {
        mapData = json.decode(mapStringLast);
      } catch (e) {
        log(e.toString(), name: 'String: ');
        mapData = json.decode('{"empty": "empty"}');
      }

      log(newResponse.toString(), name: 'NewResponse');
      OnSelectNotification().onSelectNotification(mapData: mapData);
    } on Exception catch (e) {
      NetworkClient().aliPost('/report/system',
          {"description": e.toString(), "report_reason_system_id": 9});
      log(e.toString());
    }

    // router
    //     .pushNamed(AppRouteNames.adServiceRequesExecutiontDetailScreen, extra: {
    //   'id': 475,
    //   // 'lat': 43.23218137044216,
    //   // 'lon': 76.92180585332034
    // });

    // if (screen == 'driver_on_road') {
    //   log('Navigate to driver on road screen');
    //   // final id = decoded['id'] ?? 0;
    //   // final lat = decoded['lat'] ?? 0;
    //   // final lon = decoded['lon'] ?? 0;

    //   // router.pushNamed(AppRouteNames.monitorDriveFromNavigationScreen,
    //   //     extra: {'id': id, 'lat': lat, 'lon': lon});
    // } else if (screen == 'ad') {}
    // }
  }
}
