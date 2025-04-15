// import 'package:eqshare_mobile/src/core/presentation/widgets/empty_list_widgets/app_empty_list_widget.dart';
// import 'package:eqshare_mobile/src/core/res/theme/app_dimensions.dart';
// import 'package:eqshare_mobile/src/features/requests/data/models/request_execution_list/request_execution.dart';
// import 'package:eqshare_mobile/src/features/requests/presentation/utils/request_action_buttons.dart';
// import 'package:eqshare_mobile/src/features/requests/presentation/widgets/request_empty_list_widget.dart';
// import 'package:flutter/material.dart';

// import 'request_driver_name.dart';
// import 'request_list_divider.dart';
// import 'request_photo.dart';
// import 'request_schedule_text.dart';
// import 'request_status_text.dart';
// import 'request_title_text.dart';

// class AppRequestExecutionListWidget extends StatefulWidget {
//   final dynamic controller;

//   const AppRequestExecutionListWidget({
//     super.key,
//     required this.controller,
//   });

//   @override
//   State<AppRequestExecutionListWidget> createState() => _RequestListViewState();
// }

// class _RequestListViewState extends State<AppRequestExecutionListWidget> {
//   @override
//   void initState() {
//     super.initState();
//     widget.controller.setupRequests(context);
//   }

//   var key = UniqueKey();
//   @override
//   Widget build(BuildContext context) {
//     final requests = widget.controller.requests;
//     if (widget.controller.isContentEmpty) {
//       return const RequestEmptyListWidget();
//     } else {
     
//      if(requests.isEmpty){

//       return FutureBuilder(
//         future: Future.delayed(const Duration(seconds: 1)),
//         builder: (context,snaapshot) {
//           if(snaapshot.connectionState == ConnectionState.waiting){
//             return const Center(child:  CircularProgressIndicator());
//           }
//           return const AppAdEmptyListWidget();
//         }
//       );
//      }
//       return ListView.separated(
//         separatorBuilder: (BuildContext context, int index) =>
//             const RequestListDivider(),
//         shrinkWrap: true,
//         key: key,
//         physics: const BouncingScrollPhysics(),
//         itemCount: requests.length,
//         padding: EdgeInsets.zero,
//         itemBuilder: (context, index) {
//           final request = requests[index];
//           return RequestItem(
//             controller: widget.controller,
//             onTap: () {
//               widget.controller.onRequestTap(context, index);
//               setState(() {
//                 key = UniqueKey();
//               });
//             },
//             request: request,
//           );
//         },
//       );
//     }
//   }
// }

// class RequestItem extends StatelessWidget {
//   final RequestExecution request;
//   final dynamic controller;
//   final VoidCallback onTap;

//   const RequestItem({
//     required this.controller,
//     required this.onTap,
//     required this.request,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: onTap,
//       child: Card(
//         elevation: 10,
//         shape: const RoundedRectangleBorder(
//           borderRadius: BorderRadius.zero,
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.end,
//           children: [
//             RequestDetails(request: request),
//             Padding(
//               padding: const EdgeInsets.only(
//                   right: 0.0, left: 0.0, bottom: 0.0, top: 0.0),
//               child: Wrap(
//                 spacing: 5,
//                 // runSpacing: 1,
//                 // alignment: WrapAlignment.spaceBetween,
//                 children: buildActionButtons(context, request, controller),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class RequestDetails extends StatelessWidget {
//   final RequestExecution request;

//   const RequestDetails({super.key, required this.request});

//   @override
//   Widget build(BuildContext context) {
//     final statusText = getStatusText(request.status ?? '');
//     final screenWidth = MediaQuery.of(context).size.width;
//     final urlFoto = getRequestPhoto(request);
//     final requestTitle = getRequestTitle(request);

//     return Container(
//       padding: AppDimensions.requestExecutionContainerPadding,
//       // height: AppDimensions.requestExecutionContainerHeight,
//       width: screenWidth,
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Padding(
//             padding: const EdgeInsets.only(top: 4.0),
//             child: urlFoto != ''
//                 ? RequestPhoto(urlFoto: urlFoto)
//                 : const RequestPhoto(
//                     urlFoto:
//                         'https://liamotors.com.ua/image/catalogues/products/no-image.png'),
//           ),
//           const SizedBox(width: 8),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 RequestTitleText(requestTitle: requestTitle),
//                 RequestDriverName(request: request),
//                 RequestScheduleText(requestExecution: request),
//                 if (request.status != 'FINISHED')
//                   RequestStatusText(
//                       statusText: statusText, color: _getStatusColor(request)),
//                 if (_hasRate(request) && request.status == 'FINISHED')
//                   _RateTextWidget(request)
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Color _getStatusColor(RequestExecution request) {
//     switch (request.status) {
//       case 'AWAITS_START':
//         return Colors.orange;
//       case 'ON_ROAD':
//         return Colors.blue;
//       case 'WORKING':
//         return Colors.green;
//       case 'RESUME':
//         return Colors.green;
//       case 'PAUSE':
//         return Colors.red;
//       case 'FINISHED':
//         return Colors.green;
//       default:
//         return Colors.grey;
//     }
//   }

//   bool _hasRate(RequestExecution request) {
//     return request.rate != null;
//   }

//   String getStatusText(String status) {
//     switch (status) {
//       case 'AWAITS_START':
//         return 'В ожидании начала';
//       case 'ON_ROAD':
//         return 'В пути';
//       case 'WORKING':
//         return 'В работе';
//       case 'PAUSE':
//         return 'Приостановлен';
//       case 'FINISHED':
//         return 'Завершено';
//       default:
//         return 'Неизвестный статус';
//     }
//   }

//   String getRequestPhoto(RequestExecution request) {
//     if (request.urlFoto?.isNotEmpty == true) {
//       return request.urlFoto!.first;
//     } else {
//       return '';
//     }
//   }

//   String getRequestTitle(RequestExecution request) {
//     return request.title;
//   }
// }

// class _RateTextWidget extends StatelessWidget {
//   final RequestExecution request;

//   const _RateTextWidget(this.request);

//   @override
//   Widget build(BuildContext context) {
//     return Text.rich(
//       TextSpan(
//         text: 'Оценка: ',
//         style: const TextStyle(fontWeight: FontWeight.bold),
//         children: [
//           TextSpan(
//             text: '${request.rate}/5.0',
//             style: const TextStyle(fontWeight: FontWeight.normal),
//           ),
//         ],
//       ),
//     );
//   }
// }
