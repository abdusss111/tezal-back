import 'package:eqshare_mobile/app/app_change_notifier.dart';
import 'package:eqshare_mobile/src/core/presentation/services/app_dialog_service.dart';
import 'package:eqshare_mobile/src/features/main/profile/profile_page/profile_controller.dart';
import 'package:eqshare_mobile/src/features/requests/data/models/request_execution_list/request_execution.dart';
import 'package:eqshare_mobile/src/features/requests/data/repository/request_execution_repository.dart';
import 'package:eqshare_mobile/src/features/requests/presentation/ali_widgets/request_execution_item_buttons.dart';
import 'package:eqshare_mobile/src/features/requests/presentation/widgets/finish_order_dialog.dart';
import 'package:flutter/material.dart';

class BuildRequestItemsButton extends StatefulWidget {
  final RequestExecution? requestExecution;
  final RequestExecutionRepository requestExecutionRepository;
  final void Function(UniqueKey) onpressed;
  const BuildRequestItemsButton(
      {super.key,
        required this.requestExecution,
        required this.requestExecutionRepository,
        required this.onpressed});

  @override
  State<BuildRequestItemsButton> createState() =>
      _BuildRequestItemsButtonState();
}

class _BuildRequestItemsButtonState extends State<BuildRequestItemsButton> {
  final amountInputController = AmountInputController();

  Future<bool> finishOrder({required String requestID}) async {
    final data = await showAmountInputDialog(context, (amount) async {
      amountInputController.setAmount(amount);
      try {
        await widget.requestExecutionRepository.finishRequestExecution(
            requestID: requestID, amount: amountInputController.amountPaid);
        if (!context.mounted) return true;
      } on Exception catch (e) {
        if (!mounted) return false;
        AppDialogService.showNotValidFormDialog(context, 'Попробуй позднее');
      }
    });
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(top: 10, left: 6, right: 6, bottom: 5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: widget.requestExecution == null
                  ? const SizedBox()
                  : Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Wrap(
                    spacing: 8,
                    children: [
                      ...requestExecutionItemButtons(
                        context: context,
                        isNeedHistoryButton: AppChangeNotifier().userMode ==
                            UserMode.client,
                        request: widget.requestExecution!,
                        toRoadRequest: ({required String requestID}) {
                          return widget.requestExecutionRepository
                              .toRoadRequestExecution(requestID: requestID)
                              .then((value) {
                            if (value) widget.onpressed(UniqueKey());
                            return value;
                          });
                        },
                        rateOrder: (
                            {required int rating, required RequestExecution request, required String text}) {
                          return widget.requestExecutionRepository
                              .rateOrder(
                              rating: rating, text: text, request: request)
                              .then((value) {
                            widget.onpressed(UniqueKey());
                            return true;
                          });
                        },
                        acceptOrder: ({required String requestID}) {
                          return widget.requestExecutionRepository
                              .startOrAcceptRequestExecution(
                              requestID: requestID)
                              .then(((value) {
                            if (value) widget.onpressed(UniqueKey());
                            return value;
                          }));
                        },
                        pauseOrder: ({required String requestID}) {
                          return widget.requestExecutionRepository
                              .pauseRequestExecution(requestID: requestID)
                              .then((value) {
                            if (value) widget.onpressed(UniqueKey());
                            return value;
                          });
                        },
                        finishOrder: ({required String requestID}) {
                          return finishOrder(requestID: requestID).then((
                              value) {
                            if (value) widget.onpressed(UniqueKey());
                            return value;
                          });
                        },
                        userID: AppChangeNotifier().payload!.sub!,
                        isConstructionMaterials: false,
                        userAUD: AppChangeNotifier().payload!.aud!,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}