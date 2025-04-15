// import 'package:eqshare_mobile/src/core/presentation/routing/app_route.dart';
// import 'package:eqshare_mobile/src/core/presentation/utils/auth_middleware.dart';
// import 'package:eqshare_mobile/src/core/presentation/widgets/app_primary_button.dart';
// import 'package:eqshare_mobile/src/core/res/theme/app_colors.dart';

// import 'package:eqshare_mobile/src/features/main/navigation/navigation_controller.dart';
// import 'package:eqshare_mobile/src/features/main/profile/profile_page/profile_controller.dart';
// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:provider/provider.dart';

// // ignore: constant_identifier_names
// enum Choice { sm, equipment, material, none, sm_business, service }

// class AdCreateScreen extends StatefulWidget {
//   const AdCreateScreen({super.key});

//   @override
//   State<AdCreateScreen> createState() => _AdCreateScreenState();
// }

// class _AdCreateScreenState extends State<AdCreateScreen> {
//   Choice _choice = Choice.none;

//   @override
//   Widget build(BuildContext context) {
//     final navController =
//         Provider.of<NavigationScreenController>(context, listen: false);
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Новое объявление'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text(
//                     'Выберите вид услуги',
//                     style:
//                         TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
//                   ),
//                   const SizedBox(height: 16.0),
//                   _buildChoiceTile('Аренда спецтехники', Choice.sm),
//                   const SizedBox(height: 10.0),
//                   _buildChoiceTile('Аренда оборудовании', Choice.equipment),
//                   const SizedBox(height: 10.0),
//                   _buildChoiceTile('Строительные материалы', Choice.material),
//                   const SizedBox(height: 16.0),
//                   _buildChoiceTile('Услуга', Choice.service),
//                   const SizedBox(height: 16.0),
//                   if (navController.appChangeNotifier.userMode == UserMode.owner)
//                     _buildChoiceTile(
//                         'Назначить заказ без клиента', Choice.sm_business),
//                 ],
//               ),
//             ),
//             _SubmitButton(choice: _choice)
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildChoiceTile(String title, Choice choice) {
//     return GestureDetector(
//       onTap: () {
//         setState(() {
//           _choice = choice;
//         });
//       },
//       child: Container(
//         decoration: BoxDecoration(
//           color: _choice == choice
//               ? AppColors.appPrimaryColor.withOpacity(0.2)
//               : null,
//           border: Border.all(
//             color: _choice == choice
//                 ? Colors.transparent
//                 : AppColors.appDropdownBorderColor,
//           ),
//           borderRadius: BorderRadius.circular(8.0),
//         ),
//         padding: const EdgeInsets.all(10.0),
//         child: Text(
//           title,
//           style: const TextStyle(
//             fontSize: 16.0,
//           ),
//         ),
//       ),
//     );
//   }
// }

// class _SubmitButton extends StatelessWidget {
//   const _SubmitButton({
//     required Choice choice,
//   }) : _choice = choice;

//   final Choice _choice;

//   @override
//   Widget build(BuildContext context) {
//     final navController =
//         Provider.of<NavigationScreenController>(context, listen: false);
//     return AppPrimaryButtonWidget(
//         onPressed: () async {
//           switch (_choice) {
//             case Choice.sm:
//               if (navController.appChangeNotifier.userMode == UserMode.driver ||
//                   navController.appChangeNotifier.userMode == UserMode.owner) {
//                 AuthMiddleware.executeIfAuthenticated(
//                     context,
//                     () => context
//                         .pushNamed(AppRouteNames.createAdSMForDriverOrOwner));
//               } else {
//                 AuthMiddleware.executeIfAuthenticated(context,
//                     () => context.pushNamed(AppRouteNames.createAdSMForClient));
//               }
//             case Choice.equipment:
//               if (navController.appChangeNotifier.userMode == UserMode.driver ||
//                   navController.appChangeNotifier.userMode == UserMode.owner) {
//                 AuthMiddleware.executeIfAuthenticated(
//                     context,
//                     () => context.pushNamed(
//                         AppRouteNames.createAdEquipmentForDriverOrOwner));
//               } else {
//                 AuthMiddleware.executeIfAuthenticated(
//                     context,
//                     () => (context
//                         .pushNamed(AppRouteNames.createAdEquipmentForClient)));
//               }

//             case Choice.sm_business:
//               AuthMiddleware.executeIfAuthenticated(context,
//                   () => context.pushNamed(AppRouteNames.createAdWithoutType));
//             case Choice.material:
//               AuthMiddleware.executeIfAuthenticated(context,
//                   () => context.pushNamed(AppRouteNames.createAdConstructions));
//             case Choice.service:
//               AuthMiddleware.executeIfAuthenticated(context,
//                   () => context.pushNamed(AppRouteNames.createAdService));

//             default:
//           }
//         },
//         text: 'Перейти к подаче');
//   }
// }
