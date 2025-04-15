// ignore_for_file: unused_import

import 'package:cached_network_image/cached_network_image.dart';
import 'package:eqshare_mobile/app/app_change_notifier.dart';
import 'package:eqshare_mobile/src/core/data/models/payload/payload.dart';
import 'package:eqshare_mobile/src/core/data/services/storage/token_provider_service.dart';
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
import 'package:eqshare_mobile/src/features/requests/presentation/ali_widgets/request_item_buttons.dart';
import 'package:eqshare_mobile/src/features/requests/presentation/requests/model/request_item_class.dart';
import 'package:eqshare_mobile/src/features/requests/presentation/requests/screens/requests_screen/requests_list_screen_controller.dart';

import 'package:eqshare_mobile/src/features/requests/presentation/widgets/request_photo.dart';
import 'package:eqshare_mobile/src/features/requests/presentation/widgets/request_status_text.dart';
import 'package:eqshare_mobile/src/features/requests/presentation/widgets/request_title_text.dart';
import 'package:flutter/material.dart';

class RequestCardItem extends StatefulWidget {
  final RequestItemClass requestItemData;
  final VoidCallback onTap;

  final RequestScreenController? requestScreenController;

  const RequestCardItem({
    super.key,
    required this.onTap,
    required this.requestItemData,
    this.requestScreenController,
  });

  @override
  State<RequestCardItem> createState() => _RequestCardItemState();
}

class _RequestCardItemState extends State<RequestCardItem> {
  bool _isLoading = false; // Состояние для управления лоадером
  OverlayEntry? _overlayEntry; // Для управления Overlay

  // Функция для отображения глобального лоадера
  void _showGlobalLoader(BuildContext context) {
    _overlayEntry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          ModalBarrier(
            color: Colors.black.withOpacity(0.5), // Затемнение экрана
            dismissible: false,
          ),
          Center(
            child: CircularProgressIndicator(), // Лоадер
          ),
        ],
      ),
    );

    // Вставляем OverlayEntry в Overlay
    Overlay.of(context).insert(_overlayEntry!);
  }

  // Функция для скрытия глобального лоадера
  void _hideGlobalLoader() {
    _overlayEntry?.remove(); // Удаляем OverlayEntry
    _overlayEntry = null;
  }

  String firstLetterIsMustBig(String title) {
    return '${title.substring(0, 1).toUpperCase()}${title.substring(1)}';
  }

  String getStatusTextForRequest() {
    switch (widget.requestItemData.status) {
      case 'CANCELED':
        return 'Отменен';
      case 'CREATED':
        if (widget.requestItemData.type.name.contains('CLIENT')) {
          return 'На утверждении клиента';
        } else {
          return 'На утверждении водителя';
        }
      default:
        return 'Неизвестный статус';
    }
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
            Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text('$rowValue ${additionalInfo ?? ''}'))
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
                        Text(
                            '$rowValue ${rowValue.isNotEmpty ? additionalInfo : 'Не указана'}',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            softWrap: true)
                      ]))
            ]));
  }

  String getUserName() {
    if (AppChangeNotifier().userMode != UserMode.client) {
      return 'Клиент: ${widget.requestItemData.executorUser?.firstName ?? ''} ${widget.requestItemData.executorUser?.lastName ?? ''}';
    } else {
      return 'Исполнитель: ${widget.requestItemData.executorUser?.firstName ?? ''} ${widget.requestItemData.executorUser?.lastName ?? ''}';
    }
  }

  @override
  Widget build(BuildContext context) {

    final userName = widget.requestItemData.executorUser.toString();

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
                    mainAxisAlignment: MainAxisAlignment.start,
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

                  getRowTextWithIcon(Icons.fire_truck_outlined, Colors.black,
                      rowValue:
                      '${getTypeFromAllServiceTypeEnum(widget.requestItemData.type)}${widget.requestItemData.subcategory.isNotEmpty ? '-${widget.requestItemData.subcategory}' : ''}'),
                  getRowTextWithIcon(Icons.timelapse_sharp, Colors.blue,
                      rowValue: DateTimeUtils.formatDateTimeFromYYYYmmDD(
                          DateTimeUtils().formatDateFromyyyyMMddTHHmmssSSSSSSSS(
                              widget.requestItemData.startLeaseDate)),
                      additionalInfo: '(Начало)'),
                  if (widget.requestItemData.endLeaseDate != null &&
                      widget.requestItemData.endLeaseDate != 'null' &&
                      widget.requestItemData.endLeaseDate!.isNotEmpty)
                    getRowTextWithIcon(Icons.timer_off_rounded, Colors.red,
                        rowValue: DateTimeUtils.formatDateTimeFromYYYYmmDD(
                            DateTimeUtils()
                                .formatDateFromyyyyMMddTHHmmssSSSSSSSS(
                                widget.requestItemData.endLeaseDate!)),
                        additionalInfo: '(Завершение)'),
                  if (widget.requestItemData.executorUser != null &&
                      userName.isNotEmpty &&
                      userName.length > 2 &&
                      userName != 'null')
                    getRowTextWithIcon(Icons.person_pin_outlined, Colors.black,
                        rowValue: getUserName()),
                  getRowTextCircleContainer(Colors.green,
                      rowValue: widget.requestItemData.address,
                      additionalInfo: '(Пункт назначения)'),
                  if (widget.requestItemData.finishAddress != null &&
                      widget.requestItemData.finishAddress!.isNotEmpty)
                    getRowTextCircleContainer(Colors.red,
                        rowValue:
                        'Куда: ${widget.requestItemData.finishAddress!}'),
                  if (AppChangeNotifier().payload != null &&
                      widget.requestScreenController != null)
                    Wrap(children: [
                      ...requestItemButtons(
                          context: context,
                          payload: widget.requestScreenController!
                              .appChangeNotifier.payload!,
                          serviceType: widget.requestItemData.type,
                          status: (widget.requestItemData.status),
                          approveOrder: ({required String requestID}) async {

                            final isOwner = AppChangeNotifier().userMode == UserMode.owner;

                            if (isOwner) {
                              // Если владелец, просто выполняем функцию без лоадера
                              return await widget.requestScreenController!
                                  .approveFunctionForOwner(
                                  requestID: requestID,
                                  serviceTypeEnum: widget.requestItemData.type,
                                  context: context)
                                  .then((value) {
                                if (value) {
                                  widget.requestScreenController!.setUpdateStatus(
                                      requestID: requestID, requestStatus: RequestStatus.APPROVED);
                                }
                                return value;
                              });
                            }

                            // Показываем лоадер, если это не владелец
                            _showGlobalLoader(context);
                            try {
                              if (AppChangeNotifier().userMode ==
                                  UserMode.owner) {
                                return await widget.requestScreenController!
                                    .approveFunctionForOwner(
                                    requestID: requestID,
                                    serviceTypeEnum:
                                    widget.requestItemData.type,
                                    context: context)
                                    .then((value) {
                                  if (value) {
                                    widget.requestScreenController!
                                        .setUpdateStatus(
                                        requestID: requestID,
                                        requestStatus:
                                        RequestStatus.APPROVED);
                                  }
                                  return value;
                                });
                              }
                              return await widget.requestScreenController!
                                  .approveFunction(
                                  requestID: requestID,
                                  executorID: widget
                                      .requestItemData.ownerID
                                      .toString(),
                                  serviceTypeEnum:
                                  widget.requestItemData.type)
                                  .then((value) {
                                if (value) {
                                  widget.requestScreenController!
                                      .setUpdateStatus(
                                      requestID: requestID,
                                      requestStatus:
                                      RequestStatus.APPROVED);
                                }
                                return value;
                              });
                            } finally {
                              _hideGlobalLoader(); // Скрываем лоадер после завершения
                            }
                          },
                          cancelOrder: ({required String requestID}) async {
                            _showGlobalLoader(context); // Показываем глобальный лоадер
                            try {
                              return await widget.requestScreenController!
                                  .cancelRequest(
                                  requestID: requestID,
                                  serviceTypeEnum:
                                  widget.requestItemData.type)
                                  .then((value) {
                                if (value) {
                                  widget.requestScreenController!
                                      .setUpdateStatus(
                                      requestID: requestID,
                                      requestStatus:
                                      RequestStatus.CANCELED);
                                }
                                return value;
                              });
                            } finally {
                              _hideGlobalLoader(); // Скрываем лоадер после завершения
                            }
                          },
                          ownerID: widget.requestItemData.ownerID,
                          requestID: widget.requestItemData.id.toString())
                    ]),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}