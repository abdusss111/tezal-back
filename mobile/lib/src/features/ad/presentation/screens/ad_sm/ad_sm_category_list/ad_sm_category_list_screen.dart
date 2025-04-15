// import 'package:eqshare_mobile/src/core/presentation/widgets/app_circular_progress_indicator.dart';
// import 'package:eqshare_mobile/src/core/res/theme/app_dimensions.dart';
// import 'package:eqshare_mobile/src/features/ad/presentation/widgets/app_ad_category_list_view_widget.dart';
// import 'package:eqshare_mobile/src/features/global_search/widgets/global_search_field_widget.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// import 'ad_sm_category_list_controller.dart';

// class AdSMCategoryListScreen extends StatelessWidget {
//   const AdSMCategoryListScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // floatingActionButton:
//       //     Provider.of<NavigationScreenController>(context, listen: false)
//       //                 .userMode ==
//       //             UserMode.client
//       //         ? const AppLocationFAB()
//       //         : const SizedBox.shrink(),
//       appBar: AppBar(
//         title: const Text('Категории'),
//       ),
//       body: Column(
//         children: [
//           const SizedBox(height: 16),
//           const Padding(
//             padding: EdgeInsets.symmetric(
//               horizontal: AppDimensions.defaultPadding,
//             ),
//             child: GlobalSearchFieldWidget(),
//           ),
//           const SizedBox(height: 8),
//           Consumer<AdSMCategoryListController>(
//               builder: (context, controller, child) {
//             if (controller.isLoading) {
//               return const Expanded(child: AppCircularProgressIndicator());
//             }
//             return AppAdCategoryListViewWidget(
//               onCategoryTap: (index) {
//                 controller.onCategoryTap(context, index);
//               },
//               categoryList: controller.categories,
//             );
//           }),
//         ],
//       ),
//     );
//   }
// }
