import 'package:eqshare_mobile/src/core/data/models/payload/payload.dart';

import 'package:eqshare_mobile/src/global_widgets/global_values.dart';
import 'package:flutter/material.dart';

import 'package:eqshare_mobile/src/features/requests/presentation/widgets/request_list_action_button.dart';

List<Widget> requestItemButtons({
  required BuildContext context,
  required Payload payload,
  required String status,
  required String requestID,
  required AllServiceTypeEnum serviceType,
  required int ownerID,
  Future<bool> Function({required String requestID})? approveOrder,
  Future<bool> Function({required String requestID})? reassignTheDriver,
  Future<bool> Function({required String requestID})? cancelOrder,
}) {
  Widget reassignTheDriverButton() {
    return RequestListActionButton(
      text: 'Переназначить водителя',
      onPressed: () async {
        showModalWithMyDrivers(context, assign: (assignUserID) async {
          final data = await reassignTheDriver!(requestID: assignUserID);
          return data;
        });
      },
    );
  }

  List<Widget> buildApproveOrCancelButton() {
    return [
      Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: RequestListActionButton(
          backGroundColor: Colors.white,
          foregroundColor: Theme.of(context).primaryColor,
          sideColor: Colors.orange.shade300,
          text: 'Отменить',
          onPressed: () async {
            await cancelOrder!(requestID: requestID);
          },
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: RequestListActionButton(
          backGroundColor: Theme.of(context).primaryColor,
          foregroundColor: Colors.white,
          text: 'Согласовать',
          onPressed: () async {
            await approveOrder!(requestID: requestID);
          },
        ),
      ),
    ];
  }

  List<Widget> buildActionButtons(BuildContext context) {
    final isOwner = payload.aud == 'OWNER';

    final isClient = payload.aud == 'CLIENT';
    bool canApproveOrCancel = isClient
        ? serviceType.name.contains('CLIENT')
        : ownerID == int.parse(payload.sub!);
    return [
      // if (isOwner && canApproveOrCancel) reassignTheDriverButton(),
      if (status == RequestStatus.CREATED.name && canApproveOrCancel)
        ...buildApproveOrCancelButton(),
    ];
  }

  return buildActionButtons(context);
}
