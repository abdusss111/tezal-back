import 'package:flutter/material.dart';

class AppSnackBar {
  static SnackBar showErrorSnackBar(String message,{Duration? duration}) {
    return SnackBar(
        content: SizedBox(
          child: Center(
            child: Text(
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(4),
            bottomRight: Radius.circular(4),
          ),
        ));
  }
  static SnackBar showSuccessSnackBar(String message) {
    return SnackBar(
      content: Text(message),
      backgroundColor: Colors.green,
      behavior: SnackBarBehavior.floating,
    );
}
}
SnackBar appAuthErrorSnackbar = const SnackBar(
  content: Text(
    'Пароль или почта введены неправильно',
    style: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
    ),
  ),
  duration: Duration(seconds: 6),
  behavior: SnackBarBehavior.floating,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.only(
      topLeft: Radius.circular(8),
      topRight: Radius.circular(8),
    ),
  ),
);
