import 'package:eqshare_mobile/src/core/presentation/widgets/app_circular_progress_indicator.dart';
import 'package:eqshare_mobile/src/features/requests/presentation/requests/screens/request_execution_list_screen/request_execution_list_screen_controller.dart';
import 'package:eqshare_mobile/src/features/requests/presentation/requests/widgets/request_card_item.dart';
import 'package:eqshare_mobile/src/features/requests/presentation/requests/widgets/request_execution_card_item.dart';
import 'package:eqshare_mobile/src/features/requests/presentation/widgets/request_empty_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FinishedRequestsScreen extends StatefulWidget {
  const FinishedRequestsScreen({super.key});

  @override
  State<FinishedRequestsScreen> createState() => _FinishedRequestsScreenState();
}

class _FinishedRequestsScreenState extends State<FinishedRequestsScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<RequestExecutionListScreenController>(
        builder: (context, controller, _) {
      if (controller.isLoading) {
        return const AppCircularProgressIndicator();
      }
      if (controller.getReList().isEmpty &&
          controller.getReItemClass().isEmpty) {
        return const RequestEmptyListWidget();
      }
      return ListView(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        children: [
          ...controller.getReList().map((request) => RequestExecutionCardItem(
              requestItemData: request,
              requestScreenController: controller,
              onTap: () {
                controller.onTapDriverRequestExecution(request);
              })),
          ...controller.getReItemClass().map((request) => RequestCardItem(
              requestItemData: request,
              onTap: () {
                controller.onTapRequestItemCLass(
                    request.type, request.id.toString());
              })),
        ],
      );
    });
  }
}
