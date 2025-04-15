import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../domain/services/connectivity_service/connectivity_service.dart';
import 'connection_none_screen.dart';
import 'connection_waiting_screen.dart';

class ConnectivityCheckWidget extends StatefulWidget {
  final Widget? connectedWidget;
  final ChangeNotifierProvider? changeNotifierProvider;

  const ConnectivityCheckWidget({
    super.key,
    this.connectedWidget,
    this.changeNotifierProvider,
  });

  @override
  State<ConnectivityCheckWidget> createState() =>
      ConnectivityCheckWidgetState();
}

class ConnectivityCheckWidgetState extends State<ConnectivityCheckWidget> {
  bool retrying = false;
  late Future<List<ConnectivityResult>?> connectivityFuture;

  @override
  void initState() {
    super.initState();
    connectivityFuture = Future.value([ConnectivityResult.none]);
    retrieveConnectivity();
  }

  Future<void> retrieveConnectivity() async {
    final connectivityService =
    Provider.of<ConnectivityService?>(context, listen: false);

    if (connectivityService != null) {
      setState(() {
        connectivityFuture = connectivityService.fetchConnectivityResult();
      });
    } else {
      print('ConnectivityService is null');
    }
  }

  Future<void> retryConnectivity() async {
    if (mounted) {
      setState(() {
        retrying = true;
      });
    }
    final connectivityService =
    Provider.of<ConnectivityService?>(context, listen: false);
    if (connectivityService != null) {
      setState(() {
        connectivityFuture = connectivityService.fetchConnectivityResult();
      });
    }
    if (mounted) {
      setState(() {
        retrying = false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ConnectivityResult>?>(
      future: connectivityFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const ConnectionWaitingScreen();
        } else if (snapshot.hasData) {
          final connectivityResult = snapshot.data!;
          if (connectivityResult.contains(ConnectivityResult.none)) {
            return ConnectionNoneScreen(onRetry: retryConnectivity);
          }
          return widget.changeNotifierProvider ??
              widget.connectedWidget ??
              const CircularProgressIndicator(
                strokeWidth: 1.0,
              );
        } else {
          return const SizedBox();
        }
      },
    );
  }
}
