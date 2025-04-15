// import 'package:eqshare_mobile/src/core/presentation/routing/app_route.dart';
// import 'package:eqshare_mobile/src/core/presentation/utils/auth_middleware.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:go_router/go_router.dart';

// class RequestsScreen extends StatelessWidget {
//   const RequestsScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Заказы'),
//       ),
//       body: Column(
//         children: [
//           _AppMenuRowWidget(
//             menuRowData: const _AppMenuRowData(
//               text: 'По спецтехнике',
//               count: 0, //TODO УБРАТЬ ФИКТИВНЫЙ ЧИСЛО ЗАПРОСИТЬ У СЕРВЕРА
//             ),
//             onTap: () {
//               AuthMiddleware.executeIfAuthenticated(
//                   context, () => context.pushNamed(AppRouteNames.requestAdSM));
//             },
//           ),
//           Padding(
//             padding: const EdgeInsets.only(left: 18.0),
//             child: Container(
//               height: 1,
//               color: Colors.grey.shade200,
//             ),
//           ),
//           _AppMenuRowWidget(
//             menuRowData: const _AppMenuRowData(
//               text: 'По оборудованиям',
//               count: 0, // TODO УБРАТЬ ФИКТИВНЫЙ ЧИСЛО ЗАПРОСИТЬ У СЕРВЕРА
//             ),
//             onTap: () {
//               AuthMiddleware.executeIfAuthenticated(
//                   context, () => context.pushNamed(AppRouteNames.requestAdEQ));
//             },
//           ),
//           Padding(
//             padding: const EdgeInsets.only(left: 18.0),
//             child: Container(
//               height: 1,
//               color: Colors.grey.shade200,
//             ),
//           ),
//           _AppMenuRowWidget(
//             menuRowData: const _AppMenuRowData(
//               text: 'По строительным материалам',
//               count: 0, //TODO УБРАТЬ ФИКТИВНЫЙ ЧИСЛО ЗАПРОСИТЬ У СЕРВЕРА
//             ),
//             onTap: () {
//               AuthMiddleware.executeIfAuthenticated(
//                   context, () => context.pushNamed(AppRouteNames.requestAdCM));
//             },
//           ),
//           Padding(
//             padding: const EdgeInsets.only(left: 18.0),
//             child: Container(
//               height: 1,
//               color: Colors.grey.shade200,
//             ),
//           ),
//           _AppMenuRowWidget(
//             menuRowData: const _AppMenuRowData(
//               text: 'По услугам',
//               count: 0,
//             ),
//             onTap: () {
//               AuthMiddleware.executeIfAuthenticated(
//                   context, () => context.pushNamed(AppRouteNames.requestAdSVM));
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _AppMenuRowData {
//   final IconData? icon;
//   final String? iconSvgAsset;
//   final int? count;
//   final String text;

//   const _AppMenuRowData({
//     required this.text,
//     this.iconSvgAsset,
//     this.icon,
//     this.count,
//   });
// }

// class _AppMenuRowWidget extends StatelessWidget {
//   final _AppMenuRowData menuRowData;
//   final VoidCallback onTap;

//   const _AppMenuRowWidget({
//     required this.menuRowData,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: onTap,
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
//         child: Column(
//           children: [
//             Row(
//               children: [
//                 menuRowData.icon != null
//                     ? SizedBox(
//                         width: 40,
//                         height: 40,
//                         child: Icon(
//                           menuRowData.icon,
//                         ),
//                       )
//                     : const SizedBox(
//                         height: 40,
//                       ),
//                 menuRowData.iconSvgAsset != null
//                     ? SvgPicture.asset(
//                         menuRowData.iconSvgAsset ?? '',
//                       )
//                     : const SizedBox(),
//                 const SizedBox(width: 18),
//                 Expanded(
//                   child: Text(
//                     menuRowData.text,
//                     style: const TextStyle(fontSize: 16.0),
//                   ),
//                 ),
//                 if (menuRowData.count != null)
//                   Text(
//                     '${menuRowData.count}',
//                     style: TextStyle(
//                       color: Colors.grey.shade600,
//                     ),
//                   ),
//                 Icon(
//                   Icons.chevron_right_rounded,
//                   color: Colors.grey.shade600,
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
