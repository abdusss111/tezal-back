import 'package:eqshare_mobile/src/core/data/models/payload/payload.dart';
import 'package:eqshare_mobile/src/core/data/services/storage/token_provider_service.dart';
import 'package:eqshare_mobile/src/core/presentation/widgets/app_circular_progress_indicator.dart';
import 'package:eqshare_mobile/src/features/requests/data/models/request_execution_list/request_execution.dart';
import 'package:eqshare_mobile/src/features/requests/presentation/requests/screens/request_execution_list_screen/request_execution_list_screen_controller.dart';
import 'package:eqshare_mobile/src/features/requests/presentation/requests/widgets/request_execution_card_item.dart';
import 'package:eqshare_mobile/src/features/requests/presentation/widgets/request_empty_list_widget.dart';
import 'package:eqshare_mobile/src/global_widgets/global_future_builder.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RequestExecutionListScreen extends StatefulWidget {
  const RequestExecutionListScreen({super.key});

  @override
  State<RequestExecutionListScreen> createState() =>
      _RequestExecutionListScreenState();
}

class _RequestExecutionListScreenState
    extends State<RequestExecutionListScreen> {
  Future<Payload?> getPayload() async {
    final token = await TokenService().getToken();
    if (token != null) return TokenService().extractPayloadFromToken(token);
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return GlobalFutureBuilder(
        future: getPayload(),
        buildWidget: (payload) {
          return Consumer<RequestExecutionListScreenController>(
              builder: (context, controller, _) {
            if (payload == null) {
              return const RequestEmptyListWidget();
            }
            if (controller.isLoading) {
              return const AppCircularProgressIndicator();
            }
            if (controller.getReList().isEmpty) {
              return const RequestEmptyListWidget();
            }
            return AnimatedList(
              shrinkWrap: true,
              key: controller.listKey,
              physics: const BouncingScrollPhysics(),
              initialItemCount: controller.getReList().length,
              padding: EdgeInsets.zero,
              itemBuilder: (context, index, animation) {
                final request = controller.getReList()[index];
                return controller.buildItem(request, animation);
              },
            );
          });
        });
  }
}
