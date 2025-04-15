import 'dart:developer';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:eqshare_mobile/app/app_change_notifier.dart';
import 'package:eqshare_mobile/app/app_safe_change_notifier.dart';
import 'package:eqshare_mobile/src/core/data/repositories/user_recently_viewed_ads_repo.dart';
import 'package:eqshare_mobile/src/core/presentation/widgets/app_circular_progress_indicator.dart';
import 'package:eqshare_mobile/src/core/presentation/widgets/connectivy_check_screen/connectivy_check_controller.dart';
import 'package:eqshare_mobile/src/core/presentation/widgets/connectivy_check_screen/connectivy_check_screen.dart';
import 'package:eqshare_mobile/src/features/ad/presentation/screens/ad_sm/all_ad_sm/ad_client_list/ad_client_list_controller.dart';
import 'package:eqshare_mobile/src/features/ad/presentation/screens/ad_sm/all_ad_sm/ad_sm_list/ad_sm_list_controller.dart';
import 'package:eqshare_mobile/src/features/main/location/bloc/sm_list_map_bloc.dart';
import 'package:eqshare_mobile/src/features/main/location/sm_list_map_repository.dart';
import 'package:eqshare_mobile/src/features/main/navigation/navigation_controller.dart';
import 'package:eqshare_mobile/src/features/main/profile/profile_page/profile_controller.dart';
import 'package:eqshare_mobile/src/global_widgets/global_values.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:full_screen_back_gesture/full_screen_back_gesture.dart';

import 'package:protocol_handler/protocol_handler.dart';
import 'package:provider/provider.dart';

import 'package:eqshare_mobile/src/core/data/services/storage/token_provider_service.dart';
import 'package:upgrader/upgrader.dart';

import '../main.dart';
import '../src/core/domain/services/connectivity_service/connectivity_service.dart';
import '../src/core/presentation/routing/app_route.dart';
import '../src/core/presentation/services/app_theme_provider.dart';
import '../src/core/res/theme/app_colors.dart';
import '../src/features/home/home_controller.dart';
import 'app_controller.dart';

const Color myPrimaryColor = AppColors.appPrimaryColor;

class App extends StatefulWidget {
  final AppController appController;
  // static final appNavigation = AppRoute();
  const App({
    super.key,
    required this.appController,
  });

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> with ProtocolListener {
  @override
  void initState() {
    protocolHandler.addListener(this);
    super.initState();
  }

  @override
  void dispose() {
    protocolHandler.removeListener(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    if (kIsWeb) {
      return MultiBlocProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => ConnectivityService()),
            ChangeNotifierProvider(create: (_) => HomeController()), // Добавляем HomeController
          ],
          child: MultiBlocProvider(
            providers: [
              BlocProvider<SmListMapBloc>(
                create: (context) => SmListMapBloc(
                  smListMapRepository: SmListMapRepository(),
                  homeController: Provider.of<HomeController>(context, listen: false), // Передаем HomeController
                ),
              ),
            ],
        child: ChangeNotifierProvider(
          create: (_) => ConnectivityService(),
          child: MaterialApp.router(
            debugShowCheckedModeBanner: false,

            // initialRoute:
            //     App.appNavigation.initialRoute(widget.appController.isAuth),
            // routes: App.appNavigation.routes,
            routerConfig: router,
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en'),
              Locale('ru'),
            ],
            locale: const Locale('ru'),
          ),
        ),
      ));
    }
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ConnectivityService(),
        ),
        ChangeNotifierProvider(create: (_) => HomeController()),
        BlocProvider(
          lazy: false,
          create: (context) => SmListMapBloc(
            smListMapRepository: SmListMapRepository(),
            homeController: Provider.of<HomeController>(context, listen: false), // Передаем
          )..add(FetchInitialData()),
        ),
        ChangeNotifierProvider(
          create: (_) => AppSafeChangeNotifier(),
        ),
        ChangeNotifierProvider(
          create: (_) => AppChangeNotifier()..init(),
        ),
        ChangeNotifierProvider(
          create: (context) => NavigationScreenController(),
        ),
        ChangeNotifierProvider(
          create: (context) => AdSMListController(
              selectedServiceType: ServiceTypeEnum.MACHINARY,
              userRecentlyViewedAdsRepo: Provider.of<UserRecentlyViewedAdsRepo>(
                  context,
                  listen: false))
            ..setupAds(),
        ),
        ChangeNotifierProvider(
          create: (context) => AdClientListController(
              selectedServiceType: ServiceTypeEnum.MACHINARY)
            ..setupAds(),
        ),
        ChangeNotifierProvider(
          create: (_) => ProfileController(appChangeNotifier: appChangeNotifier),
        ),
        ChangeNotifierProvider(create: (_) => ConnectivityServiceController()),
      ],
      child: AdaptiveTheme(
        light: ThemeData.light().copyWith(
          pageTransitionsTheme: const PageTransitionsTheme(
            builders: {
              TargetPlatform.android:
                  FullScreenBackGesturePageTransitionsBuilder(),
              TargetPlatform.iOS: FullScreenBackGesturePageTransitionsBuilder(),
            },
          ),
        ),
        dark: ThemeData.dark().copyWith(
          pageTransitionsTheme: const PageTransitionsTheme(
            builders: {
              TargetPlatform.android:
                  FullScreenBackGesturePageTransitionsBuilder(),
              TargetPlatform.iOS: FullScreenBackGesturePageTransitionsBuilder(),
            },
          ),
        ),
        initial: AdaptiveThemeMode.light,
        builder: (theme, darkTheme) {
          return MaterialAppWrap(
            appWidget: widget,
            theme: theme,
            darkTheme: darkTheme,
          );
        },
      ),
    );
  }

  @override
  void onProtocolUrlReceived(String url) {
    Uri uri = Uri.parse(url);
    String? id = uri.queryParameters['id'];
    int? number = int.tryParse(id ?? '');
    List<String> parts = url.split('/');
    String result = parts[3];

    log(url.toString(), name: '$result : ');
  }
}

class MaterialAppWrap extends StatefulWidget {
  const MaterialAppWrap({
    super.key,
    this.theme,
    this.darkTheme,
    required this.appWidget,
  });

  final ThemeData? theme;
  final ThemeData? darkTheme;

  final App appWidget;

  @override
  State<MaterialAppWrap> createState() => _MaterialAppWrapState();
}

class _MaterialAppWrapState extends State<MaterialAppWrap> {
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _initializeTheme();
  }

  Future<void> _initializeTheme() async {
    final token = await TokenService().getToken();
    if (mounted) {
      await ThemeManager.instance.updateTheme(context, token);
    }
    _initialized = true;
  }

  @override
  Widget build(BuildContext context) {
    if (_initialized == true) {
      return SafeArea(
        top: false,
        bottom: false,
        child: MaterialApp.router(
          theme: widget.theme,
          darkTheme: widget.darkTheme,
          debugShowCheckedModeBanner: false,
          // initialRoute: App.appNavigation
          //     .initialRoute(widget.appWidget.appController.isAuth),
          // routes: App.appNavigation.routes,
          routerConfig: router,
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en'),
            Locale('ru'),
          ],
          locale: const Locale('ru'),
          builder: (context, child) {
            return UpgradeAlert(
              shouldPopScope: () => true,
              navigatorKey: router.routerDelegate.navigatorKey,
              child: ConnectivityCheckScreen(
                  connectedWidget: child ?? Text('child')),
            );
          },
        ),
      );
    } else {
      return const AppCircularProgressIndicator();
    }
  }
}
