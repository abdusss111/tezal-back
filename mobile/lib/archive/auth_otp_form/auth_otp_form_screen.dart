// // ignore_for_file: public_member_api_docs, sort_constructors_first
// import 'package:flutter/material.dart';

// import 'package:eqshare_mobile/presentation/theme/app_fonts.dart';
// import 'package:eqshare_mobile/presentation/widgets/custom_button.dart';
// import 'package:eqshare_mobile/presentation/widgets/otp_field.dart';

// import '../../../../data/models/user/user_model.dart';
// import 'auth_otp_form_controller.dart';

// class AuthOtpFormScreen extends StatefulWidget {
//   const AuthOtpFormScreen({
//     Key? key,
//   }) : super(key: key);

//   @override
//   State<AuthOtpFormScreen> createState() => _AuthOtpFormScreenState();
// }

// class _AuthOtpFormScreenState extends State<AuthOtpFormScreen> {
//   final AuthOtpFormController controller = AuthOtpFormController();

//   @override
//   Widget build(BuildContext context) {
//     final arguments = ModalRoute.of(context)!.settings.arguments as User;

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'Авторизация',
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
//                 Text.rich(
//                   TextSpan(
//                     text:
//                         'Мы отправили Вам 4 значный\nкод введите его в поле\n',
//                     style: AppFonts.s20w500,
//                     children: [
//                       const TextSpan(
//                         text: 'на номер ',
//                         style: AppFonts.s12w500Grey,
//                       ),
//                       TextSpan(
//                         text: arguments.phoneNumber,
//                         style: AppFonts.s14w600Yellow,
//                       ),
//                     ],
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//                 const SizedBox(height: 44),
//                 OtpFieldWidget(
//                   otpController: controller.otpController,
//                   pinPutFocusNode: controller.pinPutFocusNode,
//                   pinValid: controller.pinValid,
//                   onChanged: (pin) {
//                     controller.validatePin(pin);
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
//                     if (controller.otpController.text.isEmpty) {
//                       return 'Error';
//                     }
//                     controller.sendOtp(context, arguments);
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
// }
