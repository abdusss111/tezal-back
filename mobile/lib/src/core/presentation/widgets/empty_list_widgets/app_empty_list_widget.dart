import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppAdEmptyListWidget extends StatelessWidget {
  const AppAdEmptyListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(
            CupertinoIcons.news,
            size: 32,
          ),
          const SizedBox(height: 10),
          Text(
            'Здесь нет объявлений',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 7),
        ],
      ),
    );
  }
}
