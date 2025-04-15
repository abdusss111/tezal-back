import 'dart:async';
import 'dart:developer';
import 'dart:io' show Platform;
import 'package:eqshare_mobile/app/app_change_notifier.dart';
import 'package:eqshare_mobile/app/app_controller.dart';
import 'package:eqshare_mobile/src/core/data/services/network/notification_api/notification_api.dart';
import 'package:eqshare_mobile/src/core/presentation/services/app_bottom_sheet_service.dart';
import 'package:eqshare_mobile/src/core/presentation/widgets/app_snack_bar.dart';
import 'package:eqshare_mobile/src/core/presentation/widgets/bottom_nav_bar.dart';
import 'package:eqshare_mobile/src/features/home/home_screen.dart';
import 'package:eqshare_mobile/src/features/requests/data/repository/request_execution_repository.dart';
import 'package:eqshare_mobile/src/features/requests/presentation/requests/general_request_screen.dart';
import 'package:eqshare_mobile/src/features/requests/presentation/requests/general_request_screen_controller.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import '../../../core/presentation/widgets/app_location_f_a_b.dart';
import '../chats/chats_controller.dart';
import '../chats/chats_screen.dart';
import '../profile/profile_page/profile_controller.dart';
import '../profile/profile_page/profile_screen.dart';
import 'navigation_controller.dart';

class NavigationScreen extends StatefulWidget {
  final int? initialIndex;

  const NavigationScreen({
    super.key,
    required this.initialIndex,
  });

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  late NavigationScreenController controller;
  int? requestsCount;
  int? messagesCount;
  Timer? _requestUpdateTimer;
  late final AppChangeNotifier _appNotifier;

  String fcmToken = 'Getting Firebase Token';
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _appNotifier = Provider.of<AppChangeNotifier>(context, listen: false);

    // Рекомендуется добавить слушатель здесь же, чтобы потом корректно его удалить
    // _appNotifier.addListener(_appNotifierListener);
  }

  @override
  void initState() {
    super.initState();

    _getFCMToken();
    _fetchRequestsCount();
    _fetchMessagesCount();
    _requestUpdateTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      _fetchRequestsCount();
      _fetchMessagesCount();
    });

    messageOpenApp();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      NotificationApi.pushNotification(message);
    });

    AppChangeNotifier().init();
    controller = Provider.of<NavigationScreenController>(context, listen: false);
    controller.currentIndex = widget.initialIndex ?? 0;
    controller.initialCurrentPageIndex(widget.initialIndex ?? 0);

    try {
      _firebaseMessaging.setForegroundNotificationPresentationOptions(
          alert: true, badge: true, sound: true);
    } catch (e) {
      Provider.of<AppChangeNotifier>(context, listen: false)
          .setErrorMessage('Error in navigation screen: $e');
    }

    final appNotifier = Provider.of<AppChangeNotifier>(context, listen: false);
    appNotifier.addListener(() {
      if (mounted && appNotifier.userMode != null) {
        _fetchRequestsCount();
        _fetchMessagesCount();
      }
    });
  }

  Future<void> _fetchRequestsCount() async {
    final requestExecutionController = GeneralRequestScreenController(
      requestExecutionRepository: RequestExecutionRepository(),
    );
    final count = await requestExecutionController.getActiveRequestsTotal();
    if (!mounted) return;

    setState(() {      requestsCount = count;
    });
  }

  Future<void> _fetchMessagesCount() async {
    try {
      final chatsController = ChatsController();
      await chatsController.loadNotifications();
      final count = chatsController.allNotifications
          .where((n) => n.status.toLowerCase() == 'pending')
          .length;
      setState(() {
        messagesCount = count;
      });
    } catch (e) {
      debugPrint('Ошибка при загрузке количества сообщений: $e');
    }
  }

  void messageOpenApp() {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      NotificationApi.pushNotification(message);
    });
  }

  void _getFCMToken() async {
    if (Platform.isIOS) {
      try {
        String? apnsToken = await FirebaseMessaging.instance.getAPNSToken();
        if (apnsToken == null) {
          await Future.delayed(const Duration(seconds: 3));
          apnsToken = await FirebaseMessaging.instance.getAPNSToken();
        }
      } catch (e) {
        if (mounted) {
          Provider.of<AppChangeNotifier>(context, listen: false)
              .setErrorMessage(e.toString());
        }
      }
    } else {
      try {
        final fcmToken = await FirebaseMessaging.instance.getToken();
        log(fcmToken.toString(), name: 'FCM TOKEN : ');
      } catch (e) {
        if (mounted) {
          Provider.of<AppChangeNotifier>(context, listen: false)
              .setErrorMessage(e.toString());
        }
      }
    }
  }

  List<Widget> clientScreens = [
    const HomeScreen(),
    ChangeNotifierProvider(
        create: (_) => GeneralRequestScreenController(
            requestExecutionRepository: RequestExecutionRepository()),
        child: const NewBigRequestScreen()),
    const ChatsScreen(),
    const ProfileScreen(),
  ];

  List<Widget> driverScreens = [
    const HomeScreen(),
    ChangeNotifierProvider(
        create: (_) => GeneralRequestScreenController(
            requestExecutionRepository: RequestExecutionRepository()),
        child: const NewBigRequestScreen()),
    const ChatsScreen(),
    const ProfileScreen(),
  ];

  Widget _buildFAB(NavigationScreenController controller) {
    if (controller.currentIndex == 0) {
      switch (controller.appChangeNotifier.userMode) {
        case UserMode.client || UserMode.guest:
          return const AppLocationFAB();
        case UserMode.driver || UserMode.owner:
          return const SizedBox.shrink();
        default:
          return const AppLocationFAB();
      }
    }
    return const SizedBox.shrink();
  }

  Widget _buildBody(NavigationScreenController controller) {
    switch (controller.appChangeNotifier.userMode) {
      case UserMode.client || UserMode.guest:
        return clientScreens[controller.currentPageIndex];
      case UserMode.driver || UserMode.owner:
        return driverScreens[controller.currentPageIndex];
      default:
        return clientScreens[controller.currentPageIndex];
    }
  }

  @override
  void dispose() {
    _requestUpdateTimer?.cancel();
    // final appNotifier = Provider.of<AppChangeNotifier>(context, listen: false);
    _appNotifier.removeListener(() {
      if (mounted && _appNotifier.userMode != null) {
        _fetchRequestsCount();
        _fetchMessagesCount();
      }
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<NavigationScreenController>(
        builder: (context, controller, _) {
          if (controller.appChangeNotifier.errorMessage != null &&
              controller.appChangeNotifier.errorMessage?.isNotEmpty == true) {
            SchedulerBinding.instance.addPostFrameCallback((_) {
              ScaffoldMessenger.of(context).showSnackBar(
                AppSnackBar.showErrorSnackBar(
                    '${controller.appChangeNotifier.errorMessage}'),
              );
              controller.appChangeNotifier.setErrorMessage('');
            });
          }
          return Scaffold(
            backgroundColor: Colors.white,
            floatingActionButton: _buildFAB(controller),
            body: _buildBody(controller),
            bottomNavigationBar: AppBottomNavBarWidget(
              requestsCount: requestsCount,
              messagesCount: messagesCount,
              onTap: (value) async {
                if (value == 2) {
                  if (AppChangeNotifier().userMode == UserMode.guest ||
                      AppChangeNotifier().userMode == UserMode.client) {
                    AppBottomSheetService.showCreateRequestBottomSheet(
                        context: context);
                  } else {
                    AppBottomSheetService.showCreateAdBottomSheet(context: context);
                  }
                } else {
                  controller.handleTabChange(value);
                }
              },
              currentIndex: controller.currentIndex,
            ),
          );
        });
  }
}
