import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:eqshare_mobile/src/core/data/models/payload/payload.dart';
import 'package:eqshare_mobile/src/core/presentation/services/app_dialog_service.dart';
import 'package:eqshare_mobile/src/core/presentation/utils/date_format_helper.dart';
import 'package:eqshare_mobile/src/core/res/extensions/image_extension.dart';
import 'package:eqshare_mobile/src/core/res/theme/app_dimensions.dart';

import 'package:eqshare_mobile/src/features/main/profile/profile_page/profile_controller.dart';
import 'package:eqshare_mobile/src/features/requests/data/models/request_execution_list/request_execution.dart';
import 'package:eqshare_mobile/src/features/requests/data/repository/request_execution_repository.dart';
import 'package:eqshare_mobile/src/features/requests/presentation/ali_widgets/request_execution_item_buttons.dart';
import 'package:eqshare_mobile/src/features/requests/presentation/widgets/finish_order_dialog.dart';
import 'package:eqshare_mobile/src/features/requests/presentation/widgets/request_status_text.dart';
import 'package:flutter/material.dart';

class RequestExecutionItemCard extends StatefulWidget {
  final RequestExecution request;
  final VoidCallback onTap;
  final UserMode userMode;
  final Payload payload;
  final bool isFromOwnerDriversList;
  final bool isConstructionMaterials;
  final Future<void> Function({required String requestID})? pauseOrder;
  final Future<void> Function({required String requestID})? acceptOrder;
  final Future<void> Function({required String requestID, required int amount})?
      finishOrder;
  final Future<void> Function({required String requestID})? toRoadRequest;
  final Future<void> Function(
      {required RequestExecution request,
      required int rating,
      required String text})? rateOrder;

  const RequestExecutionItemCard(
      {super.key,
      required this.onTap,
      required this.request,
      required this.userMode,
      required this.payload,
      this.isFromOwnerDriversList = false,
      this.isConstructionMaterials = false,
      this.pauseOrder,
      this.acceptOrder,
      this.finishOrder,
      this.toRoadRequest,
      this.rateOrder});

  @override
  State<RequestExecutionItemCard> createState() =>
      _RequestExecutionItemCardState();
}

class _RequestExecutionItemCardState extends State<RequestExecutionItemCard> {
  final requestExecutionRepository = RequestExecutionRepository();
  final amountInputController = AmountInputController();

  Future<void> finishOrder({required String requestID}) async {
    showAmountInputDialog(context, (amount) async {
      amountInputController.setAmount(amount);
      try {
        await widget.finishOrder!(
            requestID: requestID, amount: amountInputController.amountPaid);
        if (!context.mounted) return;
      } on Exception catch (e) {
        log(e.toString(), name: 'DSa f sa : ');
        if (!mounted) return;
        AppDialogService.showNotValidFormDialog(context, 'Попробуй позднее');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: Card(
        elevation: 10,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            RequestDetails(request: widget.request),
            Padding(
              padding: const EdgeInsets.only(
                  right: 0.0, left: 0.0, bottom: 0.0, top: 0.0),
              child: Wrap(
                spacing: 5,
                // runSpacing: 1,
                // alignment: WrapAlignment.spaceBetween,
                children: requestExecutionItemButtons(
                    request: widget.request,
                    userID: widget.payload.sub ?? '',
                    userAUD: widget.payload.aud ?? '',
                    context: context,
                    isConstructionMaterials: widget.isConstructionMaterials,
                    isFromOwnerDriversPage: widget.isFromOwnerDriversList),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RequestDetails extends StatefulWidget {
  final RequestExecution request;

  const RequestDetails({super.key, required this.request});

  @override
  State<RequestDetails> createState() => _RequestDetailsState();
}

class _RequestDetailsState extends State<RequestDetails> {
  @override
  Widget build(BuildContext context) {
    final statusText = getStatusText(widget.request.status ?? '');
    final screenWidth = MediaQuery.of(context).size.width;
    final urlFoto = getRequestPhoto(widget.request);
    final requestTitle = getRequestTitle(widget.request);

    return Container(
      padding: AppDimensions.requestExecutionContainerPadding,
      // height: AppDimensions.requestExecutionContainerHeight,
      width: screenWidth,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: urlFoto != ''
                ? requestPhoto(urlFoto: urlFoto)
                : requestPhoto(
                    urlFoto:
                        'https://liamotors.com.ua/image/catalogues/products/no-image.png'),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 6.0),
                  child: Text(
                    requestTitle,
                    style: Theme.of(context).textTheme.headlineSmall,
                    textAlign: TextAlign.start,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ),
                requestDriverUserName(),
                requestScheduleText(),
                RequestStatusText(
                    statusText: statusText,
                    color: _getStatusColor(widget.request)),
                if (_hasRate(widget.request) &&
                    widget.request.status == 'FINISHED')
                  _RateTextWidget(widget.request)
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget getRequestStatus() {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Text.rich(
        TextSpan(
          text: 'Статус: ',
          style: Theme.of(context)
              .textTheme
              .displayLarge!
              .copyWith(fontWeight: FontWeight.bold),
          children: [
            TextSpan(
              text: widget.request.status,
              style: Theme.of(context).textTheme.displayLarge!.copyWith(
                  fontWeight: FontWeight.normal,
                  color: _getStatusColor(widget.request)),
            ),
          ],
        ),
      ),
    );
  }

  Padding requestDriverUserName() {
    String value;
    if (widget.request.assigned != null) {
      value =
          '${widget.request.userAssigned?.firstName ?? 'Не'} ${widget.request.userAssigned?.lastName ?? 'указан'}';
    } else {
      final driver = widget.request.driver;
      value = '${driver?.firstName ?? 'Не'} ${driver?.lastName ?? 'указан'}';
    }
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Text.rich(
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        TextSpan(
          text: 'Исполнитель: ',
          style: Theme.of(context)
              .textTheme
              .bodyLarge!
              .copyWith(fontWeight: FontWeight.bold),
          children: [
            TextSpan(
              text: value,
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    fontWeight: FontWeight.normal,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(RequestExecution request) {
    switch (request.status) {
      case 'AWAITS_START':
        return Colors.orange;
      case 'ON_ROAD':
        return Colors.blue;
      case 'WORKING':
        return Colors.green;
      case 'RESUME':
        return Colors.green;
      case 'PAUSE':
        return Colors.red;
      case 'FINISHED':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  bool _hasRate(RequestExecution request) {
    return request.rate != null;
  }

  String getStatusText(String status) {
    switch (status) {
      case 'AWAITS_START':
        return 'В ожидании начала';
      case 'ON_ROAD':
        return 'В пути';
      case 'WORKING':
        return 'В работе';
      case 'PAUSE':
        return 'Приостановлен';
      case 'FINISHED':
        return 'Завершено';
      default:
        return 'Неизвестный статус';
    }
  }

  String getRequestPhoto(RequestExecution request) {
    if (request.urlFoto != null && request.urlFoto!.isNotEmpty) {
      return request.urlFoto!.first;
    } else {
      return '';
    }
  }

  String getRequestTitle(RequestExecution request) {
    return request.title;
  }

  Widget requestScheduleText() {
    log(widget.request.endLeaseAt.toString(),
        name: 'widget.request.endLeaseAt: ');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text.rich(
              TextSpan(
                text: 'Начало заказа: ',
                style: Theme.of(context).textTheme.bodyMedium!,
                children: [
                  TextSpan(
                    text: DateTimeUtils.formatDatetime(
                        widget.request.startLeaseAt.toString()),
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(fontWeight: FontWeight.normal),
                  ),
                ],
              ),
            ),
            if (widget.request.endLeaseAt != null &&
                widget.request.endLeaseAt.toString().isNotEmpty)
              Text.rich(
                TextSpan(
                  text: 'Завершение заказа: ',
                  style: Theme.of(context).textTheme.bodyMedium,
                  children: [
                    TextSpan(
                      text: DateTimeUtils.formatDatetime(
                          widget.request.endLeaseAt.toString()),
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(fontWeight: FontWeight.normal),
                    ),
                  ],
                ),
              ),
            if (widget.request.createdAt != null)
              Text.rich(
                TextSpan(
                  text: 'Заказ создан: ',
                  style: Theme.of(context).textTheme.bodyMedium!,
                  children: [
                    TextSpan(
                      text: DateTimeUtils.formatDatetime(
                          widget.request.createdAt.toString()),
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(fontWeight: FontWeight.normal),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget requestPhoto({required String urlFoto}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: CachedNetworkImage(
        height: 125,
        width: 125,
        memCacheHeight: (AppDimensions.requestExecutionContainerHeight - 10)
            .cacheSize(context),
        memCacheWidth: (AppDimensions.requestExecutionContainerHeight - 10)
            .cacheSize(context),
        fit: BoxFit.fill,
        imageUrl: urlFoto,
        progressIndicatorBuilder: (context, url, progress) {
          return const Center(child: CircularProgressIndicator());
        },
        errorWidget: (context, url, error) => const Icon(Icons.error),
      ),
    );
  }
}

class _RateTextWidget extends StatelessWidget {
  final RequestExecution request;

  const _RateTextWidget(this.request);

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        text: 'Оценка: ',
        style: const TextStyle(fontWeight: FontWeight.bold),
        children: [
          TextSpan(
            text: '${request.rate}/5.0',
            style: const TextStyle(fontWeight: FontWeight.normal),
          ),
        ],
      ),
    );
  }
}
