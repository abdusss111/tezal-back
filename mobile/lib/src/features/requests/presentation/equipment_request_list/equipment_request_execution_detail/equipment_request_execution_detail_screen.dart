import 'package:eqshare_mobile/src/core/presentation/widgets/app_circular_progress_indicator.dart';
import 'package:eqshare_mobile/src/core/presentation/widgets/app_detail_location_row.dart';
import 'package:eqshare_mobile/src/features/ad/presentation/widgets/ad_description_widget2.dart';
import 'package:eqshare_mobile/src/features/ad/presentation/widgets/ad_detail_photos_widget.dart';
import 'package:eqshare_mobile/src/features/main/location/detail_map_screen.dart';
import 'package:eqshare_mobile/src/features/main/profile/profile_page/profile_controller.dart';
import 'package:eqshare_mobile/src/features/requests/data/models/specialized_machinery_request_models/specialized_machinery_request_model/specialized_machinery_request.dart';
import 'package:eqshare_mobile/src/features/requests/data/repository/equipment_request_repository_impl.dart';
import 'package:eqshare_mobile/src/features/requests/presentation/ali_widgets/approve_or_cancel_buttons.dart';

import 'package:eqshare_mobile/src/features/requests/presentation/equipment_request_list/equipment_request_execution_detail/equipment_execution_detail_controller.dart';
import 'package:eqshare_mobile/src/features/requests/presentation/widgets/specialized_machinery_info_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class EquipmentRequestExecutionDetailScreen extends StatefulWidget {
  final String requestId;

  const EquipmentRequestExecutionDetailScreen({
    super.key,
    required this.requestId,
  });

  @override
  State<EquipmentRequestExecutionDetailScreen> createState() =>
      _EquipmentRequestExecutionDetailScreenState();
}

class _EquipmentRequestExecutionDetailScreenState
    extends State<EquipmentRequestExecutionDetailScreen> {
  late EquipmentRequestExecutionDetailController controller;

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();

    await Provider.of<EquipmentRequestExecutionDetailController>(context,
            listen: false)
        .loadDetails(context);
  }

  @override
  void initState() {
    controller = EquipmentRequestExecutionDetailController(widget.requestId);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<EquipmentRequestExecutionDetailController>(
      builder: (
        context,
        controller,
        child,
      ) {
        final request = controller.requestDetails;
        final adDetail = controller.requestDetails?.specializedMachineryRequest;
        var adSM = adDetail?.adSpecializedMachinery;
        List<String>? urlFotos;

        // Convert dynamicList to List<String>
        if (adSM != null && adSM.urlFoto != null && adSM.urlFoto!.isNotEmpty) {
          List<dynamic> dynamicList = adSM.urlFoto!;
          urlFotos = dynamicList.map((item) => item.toString()).toList();
        }
        return Scaffold(
            appBar: AppBar(
              title: const Text(
                'Заказ',
              ),
              elevation: 20.0,
              leading: IconButton(
                onPressed: () {
                  // Navigator.pop(context);
                  context.pop();
                },
                icon: const Icon(Icons.arrow_back_ios_new),
              ),
            ),
            body: !controller.isLoading
                ? Column(
                    children: [
                      Expanded(
                        child: ListView(
                          children: [
                            AdDetailPhotosWidget(
                                imageUrls:
                                    controller.requestDetails?.urlFoto ?? []),
                            Padding(
                              padding: const EdgeInsets.all(13.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  buildAdSMHeader(adDetail),
                                  const SizedBox(height: 8),
                                  adDetail?.orderAmount != null
                                      ? buildAdSMPrice(adDetail)
                                      : const SizedBox(),
                                  const SizedBox(height: 16),
                                  AdDescriptionWidget2(
                                    createdTime: request?.createdAt,
                                    startedTime: request?.startLeaseAt,
                                    endedTime: request?.endLeaseAt,
                                    userFirstName: request?.driver?.firstName,
                                    userSecondName: request?.driver?.lastName,
                                    userContacts: request?.driver?.phoneNumber,
                                  ),
                                  const SizedBox(height: 8),
                                  SpecializedMachineryInfoWidget(
                                    urlFoto: urlFotos,
                                    name: adSM?.name,
                                    brand: adSM?.brand?.name,
                                    subCategory: adSM?.type?.name,
                                    price: adSM?.price?.toInt(),
                                    city: null,
                                  ),
                                  const SizedBox(height: 16),
                                  const Text(
                                    'Адрес объекта',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  AppDetailLocationRow(adDetail?.address),
                                  HalfScreenMapWidget(
                                    latitude: adDetail?.latitude,
                                    longitude: adDetail?.longitude,
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (adDetail?.status == 'CREATED')
                        if (controller.appChangeNotifier.userMode ==
                                UserMode.driver ||
                            controller.appChangeNotifier.userMode ==
                                UserMode.owner)
                          ApproveOrCancelButtons(approve: () async {
                            final data = await EquipmentRequestRepositoryImpl()
                                .postEquipmentRequestApprove(
                                    requestId: widget.requestId);
                            if (data?.statusCode == 200) {
                              return true;
                            }
                            return false;
                          }, cancel: () async {
                            final data = await EquipmentRequestRepositoryImpl()
                                .postEquipmentRequestCancel(
                                    requestId: widget.requestId);
                            if (data?.statusCode == 200) {
                              return true;
                            } else {
                              return false;
                            }
                          })
                    ],
                  )
                : const AppCircularProgressIndicator());
      },
    );
  }

  Column buildAdSMBrand(SpecializedMachineryRequest? adDetail) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Бренд',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          adDetail?.description ?? '',
          style: const TextStyle(fontSize: 14),
        ),
      ],
    );
  }

  Column buildAdSMCategory(SpecializedMachineryRequest? adDetail) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Категория',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          adDetail?.description ?? '',
          style: const TextStyle(fontSize: 14),
        ),
      ],
    );
  }

  Column buildAdSMCity(SpecializedMachineryRequest? adDetail) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Город',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          adDetail?.description ?? '',
          style: const TextStyle(fontSize: 14),
        ),
      ],
    );
  }

  Text buildAdSMPrice(dynamic adDetail) {
    return Text(
      '${adDetail?.orderAmount.toString() ?? ''} т',
      style: const TextStyle(fontSize: 18),
    );
  }

  Text buildAdSMHeader(dynamic adDetail) {
    return Text(
      adDetail?.description ?? '',
      style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
    );
  }
}
