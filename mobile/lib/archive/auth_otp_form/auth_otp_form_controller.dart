// import 'package:flutter/material.dart';

// import '../../../../data/models/user/user_model.dart';
// import '../../../navigation/app_navigation.dart';

// class AuthOtpFormController extends ChangeNotifier {
//   final TextEditingController otpController = TextEditingController();
//   final FocusNode pinPutFocusNode = FocusNode();
//   bool pinValid = true;

//   void validatePin(String pin) {
//     pinValid = isValidPin(pin);
//     notifyListeners();
//   }

//   bool isValidPin(String pin) {
//     if (pin.length != 4 || pin.contains(RegExp(r'[^0-9]'))) {
//       return false;
//     }

//     if (pin == '1234' || pin == '0000' || !pin.contains('2222')) {
//       return false;
//     }

//     return true;
//   }

//   void sendOtp(BuildContext context, User arguments) {
//     Navigator.pushNamed(
//       context,
//       AppNavigationRouteNames.authPasswordScreen,
//       arguments: arguments,
//     );
//   }
// }
