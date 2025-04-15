import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:eqshare_mobile/app/app_providers.dart';
import 'package:eqshare_mobile/src/core/presentation/widgets/connection_none_screen.dart';
import 'package:eqshare_mobile/src/core/presentation/widgets/connection_waiting_screen.dart';
import 'package:eqshare_mobile/src/core/presentation/widgets/connectivy_check_screen/connectivy_check_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ConnectivityCheckScreen extends StatelessWidget {
  final Widget connectedWidget;

  const ConnectivityCheckScreen({
    super.key,
    required this.connectedWidget,
  });

  @override
  Widget build(BuildContext context) {
    final connectivityService =
        Provider.of<ConnectivityServiceController>(context);

    return StreamBuilder<List<ConnectivityResult>>(
      stream: connectivityService.connectivityStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const ConnectionWaitingScreen();
        } else if (snapshot.hasData) {
          final connectivityResult = snapshot.data!;
          if (connectivityResult.contains(ConnectivityResult.none)) {
            return ConnectionNoneScreen(
              onRetry: () async {
                // Логика повторной попытки подключения
                final result =
                    await connectivityService.fetchConnectivityResult();
                if (!result.contains(ConnectivityResult.none)) {
                  // Если подключение восстановлено, обновите UI
                  // Возможно, потребуется использовать Navigator или другие методы
                }
              },
            );
          }
          return MultiProvider(
              providers: appProviders(), child: connectedWidget);
        } else if (snapshot.hasError) {
          return Center(child: Text('Ошибка: ${snapshot.error}'));
        } else {
          return const SizedBox();
        }
      },
    );
  }
}
