import 'dart:developer';
import 'dart:io';

import 'package:eqshare_mobile/app/app_change_notifier.dart';
import 'package:eqshare_mobile/src/core/data/repositories/user_recently_viewed_ads_repo.dart';
import 'package:eqshare_mobile/src/core/data/services/network/ip_service.dart';
import 'package:eqshare_mobile/src/core/res/api_endpoints/api_endpoints.dart';
import 'package:eqshare_mobile/src/features/home/home_controller.dart';
import 'package:eqshare_mobile/src/features/home/location_permission_status_widget.dart';
import 'package:eqshare_mobile/src/features/main/chats/chats_controller.dart';
import 'package:eqshare_mobile/src/features/main/profile/profile_page/profile_controller.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';
import 'package:protocol_handler/protocol_handler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
as bg;
import 'package:workmanager/workmanager.dart';

import 'firebase_options.dart';
import 'src/core/data/services/network/notification_api/notification_api.dart';
import 'src/core/presentation/widgets/restart_widget.dart';
import 'app/app.dart';
import 'app/app_controller.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    print('Task started: $task');
    await showBackgroundNotification("Отслеживание", "Приложение отслеживает ваше местоположение в фоновом режиме.");

    if (task == "fetchLocation" || task == "fetchLocationTask") {
      try {
        final position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );
        final timestamp = DateTime.now().toIso8601String();
        print('Fetched position: ${position.latitude}, ${position.longitude}, ${timestamp}');

        await sendLocationToServer(position.latitude, position.longitude);

        debugPrint('Location sent successfully');
      } catch (e) {
        debugPrint('Error in background task: $e');
      }
    }
    return Future.value(true);
  });
}

final FlutterLocalNotificationsPlugin notificationsPlugin = FlutterLocalNotificationsPlugin();

Future<void> initializeNotifications() async {
  const AndroidInitializationSettings initializationSettingsAndroid =
  AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initializationSettings =
  InitializationSettings(android: initializationSettingsAndroid);

  await notificationsPlugin.initialize(initializationSettings);
}

// Создаем глобальный экземпляр AppChangeNotifier
final appChangeNotifier = AppChangeNotifier(); // 🔥 Глобальный объект

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final ip = await fetchIpFromBackend();
  ApiEndPoints.init(ip);
  // Initialize Notification API
  NotificationApi.init();
  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  await FirebaseMessaging.instance.setAutoInitEnabled(true);

  // Инициализируем глобальный AppChangeNotifier
  await appChangeNotifier.init();

  // Request Notification Permissions
  final settings = await firebaseMessaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: true,
    sound: true,
  );

  if (kDebugMode) {
    print('Permission granted: ${settings.authorizationStatus}');
  }

  // Handle notification when app is launched via notification
  final RemoteMessage? message = await firebaseMessaging.getInitialMessage();
  if (message != null) {
    NotificationApi.pushNotification(message);
  }

  final appController = AppController(message: message);
  await appController.checkAuth();

  final prefs = await SharedPreferences.getInstance();
  final recentlyViewedAdsRepo = UserRecentlyViewedAdsRepo(prefs: prefs)
    ..initRecentlyViewedAdList();

  // Initialize background location tracking
  Future.delayed(Duration(seconds: 2), () async {
    if (Platform.isIOS) {
      bg.BackgroundGeolocation.removeListeners();
      await initializeBackgroundGeolocationIOS(ProfileController(appChangeNotifier: appChangeNotifier));
    } else if (Platform.isAndroid) {
      print("Android Location update");
      await initializeNotifications();
      await initializeBackgroundLocationAndroid();
    }
  });

  final app = MultiProvider(
    providers: [
      ChangeNotifierProvider<AppChangeNotifier>.value(value: appChangeNotifier),
      ChangeNotifierProvider(create: (context) => HomeController()..setUp()),
      ChangeNotifierProvider(create: (context) => ChatsController()),
      ChangeNotifierProvider(create: (context) => ProfileController(
        appChangeNotifier: appChangeNotifier, // ✅ исправлено здесь!
      )..init()),
      ChangeNotifierProvider(create: (_) => AppController(message: message)),
      Provider<UserRecentlyViewedAdsRepo>(create: (_) => recentlyViewedAdsRepo),
    ],
    child: RestartWidget(
      child: TextFieldUnfocus(
        child: App(
          appController: appController,
        ),
      ),
    ),
  );


  await protocolHandler.register('myprotocol');

  runApp(app);
}

Future<void> initializeBackgroundGeolocationIOS(
    ProfileController profileController) async {
  debugPrint('Initializing background geolocation for iOS');

  bg.BackgroundGeolocation.onLocation((bg.Location location) async {
    double latitude = location.coords.latitude;
    double longitude = location.coords.longitude;

    final appController = AppController();
    await appController.sendLocationToServer(latitude, longitude);
    print("iOS Location update: $latitude, $longitude");
  });

  bg.BackgroundGeolocation.ready(bg.Config(
    desiredAccuracy: bg.Config.DESIRED_ACCURACY_HIGH,
    distanceFilter: 500.0,
    stopOnTerminate: false,
    startOnBoot: true,
    preventSuspend: true,
    heartbeatInterval: 900,
    debug: false,
    logLevel: bg.Config.LOG_LEVEL_VERBOSE,
  )).then((bg.State state) {
    if (!state.enabled) {
      bg.BackgroundGeolocation.start();
    }
  });
}

Future<void> initializeBackgroundLocationAndroid() async {
  final permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied ||
      permission == LocationPermission.deniedForever || permission == LocationPermission.whileInUse) {
    await Geolocator.requestPermission();
  }

  if (await Geolocator.isLocationServiceEnabled()) {
    Workmanager().initialize(
      callbackDispatcher,
      isInDebugMode: true,
    );

    Workmanager().registerPeriodicTask(
      "fetchLocationTask",
      "fetchLocation",
      frequency: const Duration(minutes: 15),
      constraints: Constraints(
        networkType: NetworkType.connected,
      ),
    );

    debugPrint("Background location task initialized");
  } else {
    debugPrint("Location services are disabled. Enable them to track location.");
  }
}

Future<void> showBackgroundNotification(String title, String body) async {
  const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
    'background_tracking',
    'Фоновое отслеживание',
    channelDescription: 'Уведомление о фоновом отслеживании местоположения',
    importance: Importance.low,
    priority: Priority.low,
    icon: '@mipmap/ic_launcher',
  );

  const NotificationDetails notificationDetails = NotificationDetails(android: androidDetails);

  await notificationsPlugin.show(
    0,
    title,
    body,
    notificationDetails,
  );
}

Future<void> sendLocationToServer(double latitude, double longitude) async {
  final appController = AppController();
  await appController.sendLocationToServer(latitude, longitude);
  debugPrint("Location sent to server: $latitude, $longitude");
}

void requestLocationPermissions() async {
  bg.BackgroundGeolocation.requestPermission().then((status) {
    if (kDebugMode) {
      print('status=$status');
    }
  }).catchError((error) {
    print('Error requesting location permission: $error');
  });
}

class TextFieldUnfocus extends StatelessWidget {
  const TextFieldUnfocus({required this.child, super.key});
  final Widget child;

  @override
  Widget build(BuildContext context) => GestureDetector(
    behavior: HitTestBehavior.translucent,
    onTap: () {
      final FocusScopeNode currentFocus = FocusScope.of(context);
      if (!currentFocus.hasPrimaryFocus &&
          currentFocus.focusedChild != null) {
        currentFocus.focusedChild?.unfocus();
      }
    },
    child: child,
  );
}