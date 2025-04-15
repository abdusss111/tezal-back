import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:eqshare_mobile/app/app_change_notifier.dart';
import 'package:eqshare_mobile/src/core/data/models/payload/payload.dart';
import 'package:eqshare_mobile/src/core/data/services/storage/token_provider_service.dart';
import 'package:eqshare_mobile/src/core/presentation/services/app_dialog_service.dart';
import 'package:eqshare_mobile/src/core/presentation/utils/date_format_helper.dart';
import 'package:eqshare_mobile/src/core/res/extensions/image_extension.dart';
import 'package:eqshare_mobile/src/core/res/theme/app_dimensions.dart';
import 'package:eqshare_mobile/src/core/res/theme/app_fonts.dart';
import 'package:eqshare_mobile/src/features/ad/presentation/widgets/get_widget.dart';
import 'package:eqshare_mobile/src/global_widgets/global_values.dart';
import 'package:eqshare_mobile/src/features/ad/data/global_fuctions.dart';
import 'package:eqshare_mobile/src/features/main/profile/profile_page/profile_controller.dart';
import 'package:eqshare_mobile/src/features/requests/data/models/request_execution_list/request_execution.dart';
import 'package:eqshare_mobile/src/features/requests/presentation/ali_widgets/request_execution_item_buttons.dart';
import 'package:eqshare_mobile/src/features/requests/presentation/requests/model/request_item_class.dart';
import 'package:eqshare_mobile/src/features/requests/presentation/requests/general_request_screen_controller.dart';
import 'package:eqshare_mobile/src/features/requests/presentation/requests/screens/request_execution_list_screen/request_execution_list_screen_controller.dart';
import 'package:eqshare_mobile/src/features/requests/presentation/widgets/finish_order_dialog.dart';
import 'package:eqshare_mobile/src/features/requests/presentation/widgets/request_photo.dart';
import 'package:eqshare_mobile/src/features/requests/presentation/widgets/request_status_text.dart';
import 'package:eqshare_mobile/src/features/requests/presentation/widgets/request_title_text.dart';
import 'package:flutter/material.dart';

class RequestExecutionCardItem extends StatefulWidget {
  final RequestExecution requestItemData;
  final VoidCallback onTap;
  final RequestExecutionListScreenController? requestScreenController;
  final Future<void> Function({required String requestID, required int amount})?
  finishOrder;

  const RequestExecutionCardItem({
    super.key,
    required this.onTap,
    required this.requestItemData,
    this.requestScreenController,
    this.finishOrder,
  });

  @override
  State<RequestExecutionCardItem> createState() =>
      _RequestExecutionCardItemState();
}

class _RequestExecutionCardItemState extends State<RequestExecutionCardItem> {
  String firstLetterIsMustBig(String title) {
    return '${title.substring(0, 1).toUpperCase()}${title.substring(1)}';
  }

  Widget getRowText(String rowHintText,
      {required String rowValue, required TextStyle textStyle}) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(rowHintText),
          Expanded(child: Text(rowValue, style: textStyle))
        ]);
  }

  Widget getRowTextWithIcon(IconData icons, Color iconColor,
      {required String rowValue, String? additionalInfo}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icons, size: 18, color: iconColor),
            Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Text('$rowValue ${additionalInfo ?? ''}',
                      overflow: TextOverflow.fade),
                ))
          ]),
    );
  }

  Widget getRowTextCircleContainer(Color containerColor,
      {required String rowValue, String? additionalInfo}) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                  color: containerColor,
                  shape: BoxShape.circle,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: Container(),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('$rowValue ${additionalInfo ?? ''}',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            softWrap: true)
                      ]))
            ]));
  }

  final amountInputController = AmountInputController();
  OverlayEntry? _overlayEntry;

  void _showGlobalLoader(BuildContext context) {
    _overlayEntry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          ModalBarrier(
            color: Colors.black.withOpacity(0.5),
            dismissible: false,
          ),
          Center(
            child: CircularProgressIndicator(),
          ),
        ],
      ),
    );
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _hideGlobalLoader() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  Future<bool> finishOrder({required String requestID}) async {
    try {
      final amount = await showAmountInputDialog(context, (amount) async {
        amountInputController.setAmount(amount);
        try {
          await widget.finishOrder!(
              requestID: requestID, amount: amountInputController.amountPaid);
          if (!context.mounted) return true;
        } on Exception catch (e) {
          log(e.toString(), name: 'DSa f sa : ');
          if (!mounted) return false;
          AppDialogService.showNotValidFormDialog(context, 'Попробуй позднее');
        }
      });
      return amount != null;
    } catch (e) {
      log(e.toString(), name: 'Error in finishOrder');
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {

    return InkWell(
      onTap: widget.onTap,
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white, // Фон контейнера
            borderRadius: BorderRadius.circular(16), // Скруглённые углы
            boxShadow: [
              BoxShadow(
                offset: Offset(-1, -1), // Смещение вверх и влево
                blurRadius: 5, // Радиус размытия
                color: Color.fromRGBO(
                    0, 0, 0, 0.04), // Чёрный цвет с 4% прозрачностью
              ),
              BoxShadow(
                offset: Offset(1, 1), // Смещение вниз и вправо
                blurRadius: 5, // Радиус размытия
                color: Color.fromRGBO(
                    0, 0, 0, 0.04), // Чёрный цвет с 4% прозрачностью
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: Container(
              padding: AppDimensions.requestExecutionContainerPadding,
              width: MediaQuery.sizeOf(context).width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                          child: Text(
                            firstLetterIsMustBig(
                                widget.requestItemData.title.isEmpty
                                    ? 'Title'
                                    : widget.requestItemData.title),
                            style: Theme.of(context).textTheme.titleLarge,
                            overflow: TextOverflow.ellipsis,
                          )),
                      if (widget.requestItemData.priceForHour != null &&
                          widget.requestItemData.priceForHour != 0.0)
                        Text('${widget.requestItemData.priceForHour} тг/час',
                            style: Theme.of(context).textTheme.titleMedium),

                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Статус',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      Text(
                          getStatusText(
                            widget.requestItemData.status ?? '',
                          ),
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(
                              color: getStatusColor(
                                  widget.requestItemData.status ?? ''))),
                    ],
                  ),
                  AdDivider(),
                  Builder(builder: (context) {
                    String src = getTypeFromAllServiceTypeEnum(
                        getAllServiceTypeEnumFromSRCStandart(
                            widget.requestItemData.src ?? ''));
                    String subCategory =
                        widget.requestItemData.subCategory ?? '';
                    String delimiter =
                    (src.isNotEmpty && subCategory.isNotEmpty) ? '-' : '';
                    String formattedString = '$src$delimiter$subCategory';
                    return getRowTextWithIcon(
                        Icons.fire_truck_outlined, Colors.black,
                        rowValue: formattedString);
                  }),
                  if (AppChangeNotifier().userMode == UserMode.client)
                    getRowTextWithIcon(
                      Icons.person,
                      Colors.black,
                      additionalInfo: '(Исполнитель)',
                      rowValue:
                      '${widget.requestItemData.assigned != null ? widget.requestItemData.userAssigned?.firstName : widget.requestItemData.driver?.firstName} ${widget.requestItemData.assigned != null ? widget.requestItemData.userAssigned?.lastName : widget.requestItemData.driver?.lastName}',
                    ),
                  if (AppChangeNotifier().userMode != UserMode.client)
                    getRowTextWithIcon(
                      Icons.person,
                      Colors.black,
                      additionalInfo: '(Клиент)',
                      rowValue:
                      '${widget.requestItemData.client?.firstName} ${widget.requestItemData.client?.lastName}',
                    ),
                  getRowTextWithIcon(Icons.timelapse_sharp, Colors.blue,
                      rowValue: DateTimeUtils.formatDateTimeFromYYYYmmDD(
                          DateTimeUtils().formatDateFromyyyyMMddTHHmmssSSSSSSSS(
                              widget.requestItemData.startLeaseAt ?? '')),
                      additionalInfo: '(Начало)'),
                  if (widget.requestItemData.endLeaseAt != null &&
                      widget.requestItemData.endLeaseAt != 'null' &&
                      widget.requestItemData.endLeaseAt!.isNotEmpty)
                    getRowTextWithIcon(Icons.timer_off_rounded, Colors.red,
                        rowValue: DateTimeUtils.formatDateTimeFromYYYYmmDD(
                            DateTimeUtils()
                                .formatDateFromyyyyMMddTHHmmssSSSSSSSS(
                                widget.requestItemData.endLeaseAt ?? '')),
                        additionalInfo: '(Завершение)'),
                  if (widget.requestItemData.finishAddress != null &&
                      widget.requestItemData.finishAddress!.isNotEmpty)
                    getRowTextWithIcon(Icons.location_on_outlined, Colors.red,
                        rowValue:
                        'Адрес: ${widget.requestItemData.finishAddress!}'),
                  if (widget.requestItemData.rate != null &&
                      widget.requestItemData.rate != 0 &&
                      AppChangeNotifier().payload?.aud != 'CLIENT')
                    getRowText('Оценка: ',
                        rowValue:
                        '${widget.requestItemData.rate!.toInt()} балла${widget.requestItemData.rateComment != null && widget.requestItemData.rateComment!.isNotEmpty ? ', ${widget.requestItemData.rateComment}' : ''}',
                        textStyle: Theme.of(context).textTheme.bodyMedium!),
                  if (AppChangeNotifier().payload != null)
                    Column(
                      children: [
                        Wrap(children: [
                          ...requestExecutionItemButtons(
                              context: context,
                              request: widget.requestItemData,
                              toRoadRequest: ({required String requestID}) {
                                _showGlobalLoader(context);
                                return widget.requestScreenController!
                                    .onRoad(requestID: requestID)
                                    .then((value) {
                                  if (value) {
                                    widget.requestScreenController!
                                        .setNewStatusOfRequestExecution(
                                        int.parse(requestID),
                                        RequestStatus.ON_ROAD.name);
                                  }
                                  return value;
                                }).whenComplete(() {
                                  _hideGlobalLoader();
                                });
                              },
                              rateOrder: (
                                  {required int rating,
                                    required RequestExecution request,
                                    required String text}) {
                                _showGlobalLoader(context);
                                return widget.requestScreenController!
                                    .rateOrder(
                                    rating: rating,
                                    text: text,
                                    request: request)
                                    .then((value) {
                                  widget.requestScreenController!
                                      .initController(isFinishedScreen: true);
                                  return true;
                                }).whenComplete(() {
                                  _hideGlobalLoader();
                                });
                              },
                              acceptOrder: ({required String requestID}) {
                                _showGlobalLoader(context);
                                return widget.requestScreenController!
                                    .acceptOrder(requestID: requestID)
                                    .then(((value) {
                                  if (value) {
                                    widget.requestScreenController!
                                        .setNewStatusOfRequestExecution(
                                        int.parse(requestID),
                                        RequestStatus.WORKING.name);
                                  }
                                  return value;
                                })).whenComplete(() {
                                  _hideGlobalLoader();
                                });
                              },
                              pauseOrder: ({required String requestID}) {
                                _showGlobalLoader(context);
                                return widget.requestScreenController!
                                    .pauseOrder(requestID: requestID)
                                    .then((value) {
                                  if (value) {
                                    widget.requestScreenController!
                                        .setNewStatusOfRequestExecution(
                                        int.parse(requestID),
                                        RequestStatus.PAUSE.name);
                                  }
                                  return value;
                                }).whenComplete(() {
                                  _hideGlobalLoader();
                                });
                              },
                              finishOrder: ({required String requestID}) {
                                return finishOrder(requestID: requestID)
                                    .then((value) {
                                  if (value) {
                                    widget.requestScreenController!
                                        .setNewStatusOfRequestExecution(
                                        int.parse(requestID),
                                        RequestStatus.FINISHED.name);
                                  }
                                  return value;
                                });
                              },
                              userID: AppChangeNotifier().payload!.sub!,
                              isConstructionMaterials:
                              widget.requestItemData.src!.contains('CM') ||
                                  widget.requestItemData.src!
                                      .contains('CM_CLIENT'),
                              userAUD: AppChangeNotifier().payload!.aud!)
                        ]),
                      ],
                    )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}