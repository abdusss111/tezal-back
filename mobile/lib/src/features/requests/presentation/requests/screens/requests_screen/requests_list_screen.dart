import 'package:eqshare_mobile/src/core/data/models/payload/payload.dart';
import 'package:eqshare_mobile/src/core/data/services/storage/token_provider_service.dart';
import 'package:eqshare_mobile/src/core/presentation/widgets/app_circular_progress_indicator.dart';
import 'package:eqshare_mobile/src/features/requests/presentation/requests/model/request_item_class.dart';
import 'package:eqshare_mobile/src/features/requests/presentation/requests/screens/requests_screen/requests_list_screen_controller.dart';
import 'package:eqshare_mobile/src/features/requests/presentation/requests/widgets/request_card_item.dart';

import 'package:eqshare_mobile/src/features/requests/presentation/widgets/request_empty_list_widget.dart';
import 'package:eqshare_mobile/src/global_widgets/global_future_builder.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RequestListScreen extends StatefulWidget {
  const RequestListScreen({super.key});

  @override
  State<RequestListScreen> createState() => _RequestListScreenState();
}

class _RequestListScreenState extends State<RequestListScreen> {
  Future<Payload?> getPayload() async {
    final token = await TokenService().getToken();
    if (token != null) return TokenService().extractPayloadFromToken(token);
    return null;
  }

  Widget buildItem(RequestScreenController controller, RequestItemClass request,
      Animation<double> animation) {
    return SizeTransition(
        sizeFactor: animation,
        child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: RequestCardItem(
                requestScreenController: controller,
                requestItemData: request,
                onTap: () async {
                  await controller
                      .onTapDriverRequest(request.type, request.id.toString())
                      .then((value) {
                    // setState(() {});
                  });
                })));
  }

  @override
  Widget build(BuildContext context) {
    return GlobalFutureBuilder(
        future: getPayload(),
        buildWidget: (payload) {
          return Consumer<RequestScreenController>(
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
              physics: const BouncingScrollPhysics(),
              key: controller.listKey,
              initialItemCount: controller.getReList().length,
              padding: EdgeInsets.zero,
              itemBuilder: (context, index, animation) {
                final request = controller.getReList()[index];
                return buildItem(controller, request, animation);
              },
            );
          });
        });
  }
}
