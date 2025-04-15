import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:eqshare_mobile/src/core/res/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:full_screen_back_gesture/full_screen_back_gesture.dart';

import '../../data/services/storage/token_provider_service.dart';

enum ThemeType { client, owner, driver }

class ThemeManager {
  static final ThemeManager _instance = ThemeManager._internal();
  static ThemeManager get instance => _instance;
  static const Color _canvasColor = Color.fromARGB(255, 245, 245, 245);
  // static const Color _dialogBackgroundColor = Color.fromRGBO(231, 231, 231, 1);

  ThemeManager._internal();

  Future<void> applyTheme({
    required ThemeType themeType,
    required BuildContext context,
  }) async {
    ThemeData themeData = _getThemeData(themeType, context);

    AdaptiveTheme.of(context).setTheme(
      light: themeData
        ..copyWith(
            pageTransitionsTheme: const PageTransitionsTheme(builders: {
          TargetPlatform.android: FullScreenBackGesturePageTransitionsBuilder(),
          TargetPlatform.iOS: FullScreenBackGesturePageTransitionsBuilder(),
        })),
      dark: themeData
        ..copyWith(
            pageTransitionsTheme: const PageTransitionsTheme(builders: {
          TargetPlatform.android: FullScreenBackGesturePageTransitionsBuilder(),
          TargetPlatform.iOS: FullScreenBackGesturePageTransitionsBuilder(),
        })),
    );
  }

  Future<void> updateTheme(BuildContext context, String? token) async {
    ThemeType themeType = _getThemeType(token);

    await applyTheme(
      themeType: themeType,
      context: context,
    );
  }

  ThemeType _getThemeType(String? token) {
    if (token == null) return ThemeType.client;

    final payload = TokenService().extractPayloadFromToken(token);

    switch (payload.aud) {
      case 'OWNER':
        return ThemeType.owner;
      case 'DRIVER':
        return ThemeType.driver;
      default:
        return ThemeType.client;
    }
  }

  ThemeData _getThemeData(ThemeType themeType, BuildContext context) {
    Brightness brightness = Brightness.light;

    switch (themeType) {
      case ThemeType.owner:
        return _getTheme(context, AppColors.appOwnerPrimaryColor, brightness);
      case ThemeType.driver:
        return _getTheme(context, AppColors.appDriverPrimaryColor, brightness);
      default:
        return _getTheme(context, AppColors.appPrimaryColor, brightness);
    }
  }

  ThemeData _getTheme(
      BuildContext context, Color primaryColor, Brightness brightness) {
    return ThemeData(
      useMaterial3: true,
      cardColor: _canvasColor,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: _canvasColor,
      bottomNavigationBarTheme:
          const BottomNavigationBarThemeData(backgroundColor: _canvasColor),
      pageTransitionsTheme: const PageTransitionsTheme(builders: {
        TargetPlatform.android: FullScreenBackGesturePageTransitionsBuilder(),
        TargetPlatform.iOS: FullScreenBackGesturePageTransitionsBuilder(),
      }),
      dialogTheme: DialogTheme(
        surfaceTintColor: Colors.transparent,
        backgroundColor: _canvasColor,
        titleTextStyle: const TextStyle(color: Colors.black),
        contentTextStyle: const TextStyle(color: Colors.black),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      ),
      colorScheme: ColorScheme.fromSwatch(
        brightness: brightness,
        primarySwatch: MaterialColor(
          primaryColor.value,
          <int, Color>{
            50: primaryColor.withOpacity(0.05),
            100: primaryColor.withOpacity(0.1),
            200: primaryColor.withOpacity(0.2),
            300: primaryColor.withOpacity(0.3),
            400: primaryColor.withOpacity(0.4),
            500: primaryColor.withOpacity(0.5),
            600: primaryColor.withOpacity(0.6),
            700: primaryColor.withOpacity(0.7),
            800: primaryColor.withOpacity(0.8),
            900: primaryColor.withOpacity(0.9),
          },
        ),
      ),
      textSelectionTheme: TextSelectionThemeData(cursorColor: primaryColor),
      appBarTheme: const AppBarTheme(
        iconTheme: IconThemeData(),
        centerTitle: true,
        titleTextStyle: TextStyle(
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w500,
            fontSize: 22,
            color: Colors.black),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
      ),
      inputDecorationTheme: InputDecorationTheme(
        errorStyle: const TextStyle(color: Colors.red, fontSize: 12.0),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.appPrimaryInputHintColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: primaryColor),
        ),
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w900,
          color: Colors.black,
          fontSize: 24,
        ),
        displayMedium: TextStyle(
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w900,
            fontSize: 20,
            color: Colors.black
            //height: 22,
            ),
        displaySmall: TextStyle(
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w700,
            fontSize: 17,
            color: Colors.black),
        headlineLarge: TextStyle(
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w900,
            fontSize: 17,
            color: Colors.black),
        headlineSmall: TextStyle(
            fontFamily: 'Roboto', // не трогать
            fontWeight: FontWeight.w700,
            fontSize: 15,
            color: Colors.black),
        titleLarge:
            TextStyle(fontFamily: 'Roboto', fontSize: 18, color: Colors.black),
        titleMedium:
            TextStyle(fontFamily: 'Roboto', fontSize: 15, color: Colors.black),
        titleSmall:
            TextStyle(fontFamily: 'Roboto', color: Colors.black), // не трогать
        bodyLarge: TextStyle(
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w700,
            fontSize: 15,
            color: Colors.black),
        bodyMedium:
            TextStyle(fontFamily: 'Roboto', fontSize: 14, color: Colors.black),
        labelLarge:
            TextStyle(fontFamily: 'Roboto', fontSize: 16, color: Colors.black),
        labelMedium:
            TextStyle(fontFamily: 'Roboto', fontSize: 14, color: Colors.black),
        labelSmall: TextStyle(
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w700,
            fontSize: 12,
            color: Colors.black),
      ), // трек
    );
  }
}
