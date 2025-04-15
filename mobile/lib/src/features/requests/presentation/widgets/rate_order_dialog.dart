import 'package:eqshare_mobile/src/core/presentation/services/app_dialog_service.dart';
import 'package:eqshare_mobile/src/features/requests/data/models/request_execution_list/request_execution.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

abstract class RequestListController {
  Future<void> rateOrder(
      BuildContext context, RequestExecution request, int rating, String text);
}

class RateOrderDialog extends StatefulWidget {
  final RequestExecution request;
  final RequestListController controller;

  const RateOrderDialog({
    super.key,
    required this.request,
    required this.controller,
  });

  @override
  State<RateOrderDialog> createState() => _RateOrderDialogState();
}

class _RateOrderDialogState extends State<RateOrderDialog> {
  int _rating = 0;
  final TextEditingController _commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      surfaceTintColor: Colors.transparent,
      title: const Text(
        'Оцените качество выполнения заказа в Mezet',
        textAlign: TextAlign.center,
      ),
      titleTextStyle: Theme.of(context)
          .textTheme
          .displayLarge!
          .copyWith(fontWeight: FontWeight.bold),
      content: Builder(builder: (context) {
        // var width = MediaQuery.of(context).size.width;
        return SizedBox(
          // width: width,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  for (int i = 1; i <= 5; i++)
                    Expanded(
                      child: IconButton(
                        iconSize: 28,
                        icon: Icon(
                          i <= _rating ? Icons.star : Icons.star_border,
                          color: const Color(0xFFFFD700),
                        ),
                        onPressed: () {
                          setState(() {
                            _rating = i;
                          });
                        },
                      ),
                    ),
                ],
              ),
              TextField(
                controller: _commentController,
                decoration: const InputDecoration(
                  hintText: 'Введите комментарий',
                ),
              ),
            ],
          ),
        );
      }),
      actions: [
        TextButton(
          onPressed: () {
            // Navigator.of(context).pop();
            context.pop();
          },
          child: const Text('Отмена'),
        ),
        FilledButton(
          style: FilledButton.styleFrom(foregroundColor: Colors.white),
          onPressed: _rating != 0
              ? () async {
                  AppDialogService.showLoadingDialog(context);
                  await widget.controller.rateOrder(
                    context,
                    widget.request,
                    _rating,
                    _commentController.text,
                  );
                  if (!context.mounted) return;
                  // Navigator.of(context).pop();
                  // Navigator.of(context).pop();
                  context.pop();
                  context.pop();
                }
              : null,
          child: const Text('Оценить'),
        ),
      ],
    );
  }
}

class AliRateOrderDialog extends StatefulWidget {
  final RequestExecution request;
  final Future<void> Function(
      {required RequestExecution request,
      required int rating,
      required String text}) rateOrder;

  const AliRateOrderDialog({
    super.key,
    required this.request,
    required this.rateOrder,
  });

  @override
  State<AliRateOrderDialog> createState() => _AliRateOrderDialogState();
}

class _AliRateOrderDialogState extends State<AliRateOrderDialog> {
  int _rating = 0;
  final TextEditingController _commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      surfaceTintColor: Colors.transparent,
      title: const Text(
        'Оцените качество выполнения заказа в Mezet',
        textAlign: TextAlign.center,
      ),
      titleTextStyle: Theme.of(context)
          .textTheme
          .displayLarge!
          .copyWith(fontWeight: FontWeight.bold),
      content: Builder(builder: (context) {
        // var width = MediaQuery.of(context).size.width;
        return SizedBox(
          // width: width,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  for (int i = 1; i <= 5; i++)
                    Expanded(
                      child: IconButton(
                        iconSize: 28,
                        icon: Icon(
                          i <= _rating ? Icons.star : Icons.star_border,
                          color: const Color(0xFFFFD700),
                        ),
                        onPressed: () {
                          setState(() {
                            _rating = i;
                          });
                        },
                      ),
                    ),
                ],
              ),
              TextField(
                controller: _commentController,
                decoration: const InputDecoration(
                  hintText: 'Введите комментарий',
                ),
              ),
            ],
          ),
        );
      }),
      actions: [ 
        TextButton(
          onPressed: () {
            context.pop();
          },
          child: const Text('Отмена'),
        ),
        FilledButton(
          style: FilledButton.styleFrom(foregroundColor: Colors.white),
          onPressed: _rating != 0
              ? () async {
                  AppDialogService.showLoadingDialog(context);
                final data =  await widget.rateOrder(
                      request: widget.request,
                      text: _commentController.text,
                      rating: _rating);
                  if (!context.mounted) return;

                  context.pop();
                  context.pop();
                }
              : null,
          child: const Text('Оценить'),
        ),
      ],
    );
  }
}

class RateOrderDialogFromNotification extends StatefulWidget {
  final Future<void> Function({required int rating, required String text})
      rateOrder;
  final String requestID;
  final Future<RequestExecution?> getRequestExecution;

  const RateOrderDialogFromNotification(
      {super.key,
      required this.rateOrder,
      required this.requestID,
      required this.getRequestExecution});

  @override
  State<RateOrderDialogFromNotification> createState() =>
      _RateOrderDialogFromNotificationState();
}

class _RateOrderDialogFromNotificationState
    extends State<RateOrderDialogFromNotification> {
  int _rating = 0;
  final TextEditingController _commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      surfaceTintColor: Colors.transparent,
      title: FutureBuilder<RequestExecution?>(
          future: widget.getRequestExecution,
          builder: (context, snapshot) {
            return  Text(
              'Оцените качество выполнения заказа в Mezet: ${snapshot.data?.title}',
              textAlign: TextAlign.center,
            );
          }),
      titleTextStyle: Theme.of(context)
          .textTheme
          .displayLarge!
          .copyWith(fontWeight: FontWeight.bold),
      content: Builder(builder: (context) {
        // var width = MediaQuery.of(context).size.width;
        return SizedBox(
          // width: width,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  for (int i = 1; i <= 5; i++)
                    Expanded(
                      child: IconButton(
                        iconSize: 28,
                        icon: Icon(
                          i <= _rating ? Icons.star : Icons.star_border,
                          color: const Color(0xFFFFD700),
                        ),
                        onPressed: () {
                          setState(() {
                            _rating = i;
                          });
                        },
                      ),
                    ),
                ],
              ),
              TextField(
                controller: _commentController,
                decoration: const InputDecoration(
                  hintText: 'Введите комментарий',
                ),
              ),
            ],
          ),
        );
      }),
      actions: [
        TextButton(
          onPressed: () {
            context.pop();
          },
          child: const Text('Отмена'),
        ),
        FilledButton(
          style: FilledButton.styleFrom(foregroundColor: Colors.white),
          onPressed: _rating != 0
              ? () async {
                  AppDialogService.showLoadingDialog(context);
                  await widget.rateOrder(
                      text: _commentController.text, rating: _rating);
                  if (!context.mounted) return;

                  context.pop();
                  context.pop();
                }
              : null,
          child: const Text('Оценить'),
        ),
      ],
    );
  }
}
