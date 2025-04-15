import 'dart:developer';

import 'package:eqshare_mobile/src/core/data/services/storage/token_provider_service.dart';
import 'package:eqshare_mobile/src/core/presentation/routing/app_route.dart';
import 'package:eqshare_mobile/src/core/presentation/widgets/non_authenticated_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AuthMiddleware {
  Future<bool> get isAuthenticated async {
    final token = await TokenService().getToken();
    return token != null;
  }

   
   Widget buildAuthenticatedWidget(Widget authenticatedWidget) {
    final authMiddleware = AuthMiddleware();
    return FutureBuilder<bool>(
      future: authMiddleware.isAuthenticated,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return snapshot.data == true
              ? authenticatedWidget
              : const NonAuthenticatedWidget();
        }
      },
    );
  }

  static void executeIfAuthenticated(
      BuildContext context, Function() authenticatedFunction) async {
    final token = await TokenService().getToken();
    //  authenticatedFunction();
    log(token.toString());
    if (token != null) {
      authenticatedFunction();
    } else {
      if (context.mounted) {
        // Navigator.of(context).pushNamed(
        //   AppRouteNames.login,
        // );
        
        context.pushNamed(
          AppRouteNames.login,
        );
      }
    }
  }
}
