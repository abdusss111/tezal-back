// import 'package:eqshare_mobile/presentation/features/user_auth/city_page.dart';
// import 'package:eqshare_mobile/presentation/theme/app_fonts.dart';
// import 'package:eqshare_mobile/presentation/widgets/custom_button.dart';
// import 'package:eqshare_mobile/presentation/widgets/otp_field.dart';
// import 'package:flutter/material.dart';

// class OptConfirmationPage extends StatefulWidget {
//   const OptConfirmationPage({super.key});

//   @override
//   State<OptConfirmationPage> createState() => _OptConfirmationPageState();
// }

// class _OptConfirmationPageState extends State<OptConfirmationPage> {
//   final TextEditingController otpController = TextEditingController();
//   final FocusNode pinPutFocusNode = FocusNode();
//   bool pinValid = true;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'Регистрация',
//           style: TextStyle(
//             fontWeight: FontWeight.w500,
//           ),
//         ),
//         leading: IconButton(
//           onPressed: () {
//             Navigator.pop(context);
//           },
//           icon: const Icon(
//             Icons.arrow_back_ios_new,
//           ),
//         ),
//       ),
//       body: Center(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(
//             horizontal: 24,
//           ),
//           child: SingleChildScrollView(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 const Text.rich(
//                   TextSpan(
//                     text:
//                         'Мы отправили Вам 4 значный\nкод введите его в поле\n',
//                     style: AppFonts.s20w500,
//                     children: [
//                       TextSpan(
//                         text: 'на номер ',
//                         style: AppFonts.s12w500Grey,
//                       ),
//                       TextSpan(
//                         text: ' +7(707)778-88-99',
//                         style: AppFonts.s14w600Yellow,
//                       ),
//                     ],
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//                 const SizedBox(height: 44),
//                 OtpFieldWidget(
//                   otpController: otpController,
//                   pinPutFocusNode: pinPutFocusNode,
//                   pinValid: pinValid,
//                   onChanged: (pin) {
//                     setState(() {
//                       pinValid = validatePin(pin);
//                     });
//                   },
//                 ),
//                 const SizedBox(height: 24),
//                 InkWell(
//                   onTap: () {},
//                   child: const Text(
//                     'Код не пришёл?',
//                     style: AppFonts.s16w500Underline,
//                   ),
//                 ),
//                 const SizedBox(height: 44),
//                 CustomButtonWidget(
//                   onPressed: () {
//                     if (otpController.text.isEmpty) {
//                       return 'Error';
//                     }
//                     pinValid
//                         ? Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => const CitySelectPage(),
//                             ),
//                           )
//                         : 'Error';
//                   },
//                   text: 'Далее',
//                   icon: Icons.arrow_forward_ios_outlined,
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   bool validatePin(String pin) {
//     if (pin.length != 4 || pin.contains(RegExp(r'[^0-9]'))) {
//       return false;
//     }

//     if (pin == '1234' || pin == '0000' || !pin.contains('2222')) {
//       return false;
//     }

//     return true;
//   }
// }
