import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MessageEmptyListWidget extends StatelessWidget {
  const MessageEmptyListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(
            CupertinoIcons.chat_bubble_2,
            size: 32,
          ),
          const SizedBox(height: 10),
          Text(
            'Здесь пока нет сообщений',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 7),
        ],
      ),
    );
  }
}
