import 'package:flutter/material.dart';

class AppCircularProgressIndicator extends StatelessWidget {
  const AppCircularProgressIndicator({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return  const Center(
      child: CircularProgressIndicator.adaptive(strokeWidth: 6.5),
    );
  }
}
