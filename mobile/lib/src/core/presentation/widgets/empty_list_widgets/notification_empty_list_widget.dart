import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NotificationEmptyListWidget extends StatelessWidget {
  const NotificationEmptyListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(
            CupertinoIcons.bell,
            size: 32,
          ),
          const SizedBox(height: 10),
          Text(
            'Здесь пока нет уведомлений',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 7),
        ],
      ),
    );
  }
}
