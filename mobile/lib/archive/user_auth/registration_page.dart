// import 'package:eqshare_mobile/presentation/features/user_auth/otp_confirmation_page.dart';
// import 'package:eqshare_mobile/presentation/theme/app_fonts.dart';
// import 'package:eqshare_mobile/presentation/widgets/custom_button.dart';
// import 'package:eqshare_mobile/presentation/widgets/phone_field.dart';
// import 'package:flutter/material.dart';

// class RegistrationPage extends StatefulWidget {
//   const RegistrationPage({super.key});

//   @override
//   State<RegistrationPage> createState() => _RegistrationPageState();
// }

// class _RegistrationPageState extends State<RegistrationPage> {
//   TextEditingController phoneController = TextEditingController();
//   final GlobalKey<FormState> formKey = GlobalKey<FormState>();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'Авторизация',
//           style: TextStyle(
//             fontWeight: FontWeight.w500,
//           ),
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(
//           horizontal: 24,
//         ),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Text(
//               'Введите номер\nмобильного телефона',
//               style: AppFonts.s20w500,
//               textAlign: TextAlign.center,
//             ),
//             const Text(
//               'Вам придёт 4 значный код для\nподтверждения номера',
//               style: AppFonts.s12w500Grey,
//               textAlign: TextAlign.center,
//             ),
//             const SizedBox(height: 44),
//             PhoneNumberField(
//               formKey: formKey,
//               phoneController: phoneController,
//             ),
//             const SizedBox(height: 44),
//             CustomButtonWidget(
//               onPressed: () {
//                 if (formKey.currentState!.validate() &&
//                     phoneController.text.length == 18) {
//                   // ScaffoldMessenger.of(context).showSnackBar(
//                   //   const SnackBar(
//                   //     content: Text('Successful'),
//                   //   ),
//                   // );
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => const OptConfirmationPage(),
//                     ),
//                   );
//                 }
//               },
//               text: 'Далее',
//               icon: Icons.arrow_forward_ios_outlined,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
