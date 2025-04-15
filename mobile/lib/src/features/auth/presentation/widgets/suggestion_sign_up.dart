import 'package:eqshare_mobile/src/core/presentation/routing/app_route.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SuggestionSignUp extends StatelessWidget {
  const SuggestionSignUp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('У вас нет аккаунта?',
            style: Theme.of(context).textTheme.labelMedium),
        TextButton(
          onPressed: () {
            // Navigator.pushNamed(context, AppRouteNames.registerPhone);
            context.pushNamed(AppRouteNames.registerPhone);
          },
          child: Text(
            'Зарегистрироваться',
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.normal,
                  color: Theme.of(context).primaryColor,
                ),
          ),
        ),
      ],
    );
  }
}
