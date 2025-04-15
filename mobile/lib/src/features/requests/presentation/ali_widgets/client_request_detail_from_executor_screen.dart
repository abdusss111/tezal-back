// import 'package:eqshare_mobile/src/core/presentation/services/app_dialog_service.dart';
// import 'package:eqshare_mobile/src/core/presentation/widgets/app_detail_location_row.dart';
// import 'package:eqshare_mobile/src/core/presentation/widgets/app_primary_button.dart';
// import 'package:eqshare_mobile/src/core/res/theme/app_dimensions.dart';
// import 'package:eqshare_mobile/src/drivers_app/data/global_values.dart';
// import 'package:eqshare_mobile/src/features/ad/data/global_fuctions.dart';
// import 'package:eqshare_mobile/src/features/ad/presentation/widgets/ad_detail_photos_widget.dart';
// import 'package:eqshare_mobile/src/features/main/location/detail_map_screen.dart';
// import 'package:eqshare_mobile/src/features/requests/presentation/ali_widgets/approve_or_cancel_buttons.dart';
// import 'package:eqshare_mobile/src/features/requests/presentation/requests/add_data_hadler.dart';
// import 'package:eqshare_mobile/src/global_widgets/global_future_builder.dart';
// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:separated_row/separated_row.dart';

// class ClientRequestDetailFromExecutorScreen extends StatefulWidget {
//   final AllServiceTypeEnum serviceType;
//   final String requestID;
//   final bool needApproveButton;

//   const ClientRequestDetailFromExecutorScreen(
//       {super.key,
//       required this.serviceType,
//       required this.requestID,
//       this.needApproveButton = true});

//   @override
//   State<ClientRequestDetailFromExecutorScreen> createState() =>
//       _ClientRequestDetailFromExecutorScreenState();
// }

// class _ClientRequestDetailFromExecutorScreenState
//     extends State<ClientRequestDetailFromExecutorScreen> {
//   late final RequestAdDataHandler dataHandlerFactory;

//   @override
//   void initState() {
//     super.initState();
//     dataHandlerFactory =
//         RequestDataHandlerFactory().getHandler(widget.serviceType);
//   }

//   Widget approveOrCancelButtons() {
//     return ApproveOrCancelButtons(approve: ()async{}, cancel: ()async{})
//     return Padding(
//       padding: AppDimensions.footerActionButtonsPadding,
//       child: SeparatedRow(
//           separatorBuilder: (context, int index) => const SizedBox(
//                 width: AppDimensions.footerActionButtonsSeparatorWidth,
//               ),
//           children: [
//             Expanded(
//               child: AppPrimaryButtonWidget(
//                   backgroundColor: Colors.red,
//                   onPressed: () async {
//                     AppDialogService.showLoadingDialog(context);
//                     bool? result = true;

//                     // result = await adServiceRequestRepository
//                     //     .cancelDriverOrOwnerRequestFromClient(
//                     //         widget.requestId);

//                     if (result && mounted) {
//                       AppDialogService.showSuccessDialog(context,
//                           title: 'Отменено', onPressed: () {
//                         context.pop();
//                         context.pop();
//                       }, buttonText: 'Назад');
//                     }
//                   },
//                   text: 'Отменить'),
//             ),
//             Expanded(
//               child: AppPrimaryButtonWidget(
//                   onPressed: () async {
//                     AppDialogService.showLoadingDialog(context);
//                     bool? result = true;
//                     if (result && mounted) {
//                       AppDialogService.showSuccessDialog(context,
//                           title: 'Приянто', onPressed: () {
//                         context.pop();
//                         context.pop();
//                       }, buttonText: 'Назад');
//                     }
//                   },
//                   text: 'Согласовать'),
//             ),
//           ]),
//     );
//   }

//   Text buildPriceText(String? price) {
//     return Text(
//       'Цена: ${price ?? ''} ₸/час',
//       style: const TextStyle(fontSize: 16),
//     );
//   }

//   Column buildAdSMCategory(String? category) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           'Категория',
//           style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
//         ),
//         const SizedBox(height: 8),
//         Text(
//           category ?? '',
//           style: const TextStyle(fontSize: 14),
//         ),
//       ],
//     );
//   }

//   Column buildAdSMCity(String? description) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           'Город',
//           style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
//         ),
//         const SizedBox(height: 8),
//         Text(
//           description ?? '',
//           style: const TextStyle(fontSize: 14),
//         ),
//       ],
//     );
//   }

//   Text buildAdSMHeader(String? description) {
//     return Text(
//       description ?? '',
//       style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
//     );
//   }

//   Column buildAdSMDescription(String? comment) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           'Описание',
//           style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//         ),
//         const SizedBox(
//           height: 8,
//         ),
//         Text(
//           comment ?? '',
//           style: const TextStyle(fontSize: 16),
//         ),
//       ],
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           leading: const BackButton(),
//           title: const Text('Заказ'),
//           centerTitle: true,
//         ),
//         body: GlobalFutureBuilder(
//           future: dataHandlerFactory.getDetail(widget.requestID),
//           buildWidget: (request) {
//             return Column(
//               children: [
//                 Expanded(
//                   child: ListView(
//                     children: [
//                       AdDetailPhotosWidget(
//                         imageUrls: request?.urlFoto ?? <String>[],
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.all(13.0),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             buildAdSMHeader(request?.description),
//                             const SizedBox(height: 16),
//                             buildPriceText(request?.price.toString()),
//                             const SizedBox(height: 16),
//                             const Text(
//                               'Категория',
//                               style: TextStyle(
//                                   fontSize: 16, fontWeight: FontWeight.bold),
//                             ),
//                             const SizedBox(
//                               height: 8,
//                             ),
//                             Text(
//                               request?.serviceSubCategory?.name ?? '',
//                               style: const TextStyle(fontSize: 16),
//                             ),
//                             const SizedBox(height: 16),
//                             buildAdSMDescription(request?.description),
//                             const SizedBox(height: 16),
//                             const Text(
//                               'Статус',
//                               style: TextStyle(
//                                   fontSize: 16, fontWeight: FontWeight.bold),
//                             ),
//                             const SizedBox(
//                               height: 8,
//                             ),
//                             Text(
//                               getStatusText(request?.status ?? ''),
//                               style: const TextStyle(fontSize: 16),
//                             ),
//                           ],
//                         ),
//                       ),
//                       AppDetailLocationRow(request?.address),
//                       HalfScreenMapWidget(
//                         latitude: request?.latitude?.toDouble(),
//                         longitude: request?.longitude?.toDouble(),
//                       )
//                     ],
//                   ),
//                 ),
//                 if (request.status == 'CREATED' && widget.needApproveButton)
//                   approveOrCancelButtons(),
//               ],
//             );
//           },
//         ));
//   }
// }
