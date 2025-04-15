import 'package:eqshare_mobile/src/core/presentation/widgets/empty_list_widgets/notification_empty_list_widget.dart';
import 'package:flutter/material.dart';

class NotificationListScreen extends StatelessWidget {
  const NotificationListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Уведомления'),
      ),
      body: const NotificationEmptyListWidget(),
    );
  }
}
