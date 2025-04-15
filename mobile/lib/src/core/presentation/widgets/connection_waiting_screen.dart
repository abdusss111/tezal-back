import 'package:eqshare_mobile/src/core/presentation/widgets/app_circular_progress_indicator.dart';
import 'package:flutter/material.dart';

class ConnectionWaitingScreen extends StatelessWidget {
  const ConnectionWaitingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 1,
      child: const Scaffold(
        extendBody: true,
        body: Column(
          children: [SizedBox(height: 10), AppCircularProgressIndicator()],
        ),
      ),
    );
  }
}
