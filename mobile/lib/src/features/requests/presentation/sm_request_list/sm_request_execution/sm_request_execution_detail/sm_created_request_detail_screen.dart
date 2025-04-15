import 'package:eqshare_mobile/src/core/presentation/widgets/app_circular_progress_indicator.dart';
import 'package:eqshare_mobile/src/features/ad/presentation/widgets/ad_description_widget.dart';
import 'package:eqshare_mobile/src/features/ad/presentation/widgets/ad_detail_header_widget.dart';
import 'package:eqshare_mobile/src/features/ad/presentation/widgets/ad_detail_photos_widget.dart';
import 'package:eqshare_mobile/src/features/ad/presentation/widgets/ad_detail_price_widget.dart';
import 'package:eqshare_mobile/src/features/main/location/detail_map_screen.dart';
import 'package:eqshare_mobile/src/features/requests/data/repository/sm_request_repository_impl.dart';
import 'package:eqshare_mobile/src/features/requests/presentation/ali_widgets/approve_or_cancel_buttons.dart';
import 'package:eqshare_mobile/src/features/requests/presentation/sm_request_list/sm_created/sm_created_request_detail/sm_created_request_detail_controller.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../../../core/presentation/widgets/app_detail_location_row.dart';
import '../../../../../main/profile/profile_page/profile_controller.dart';
import '../../../widgets/specialized_machinery_info_widget.dart';

class SMCreatedRequestDetailScreen extends StatefulWidget {
  final String requestId;

  const SMCreatedRequestDetailScreen({
    super.key,
    required this.requestId,
  });

  @override
  State<SMCreatedRequestDetailScreen> createState() =>
      _SMCreatedRequestDetailScreenState();
}

class _SMCreatedRequestDetailScreenState
    extends State<SMCreatedRequestDetailScreen> {
  late SMCreatedRequestDetailController controller;

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();

    await Provider.of<SMCreatedRequestDetailController>(context, listen: false)
        .loadDetails(context);
  }

  @override
  void initState() {
    controller = SMCreatedRequestDetailController(widget.requestId);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SMCreatedRequestDetailController>(
      builder: (
        context,
        controller,
        child,
      ) {
        final adDetail = controller.requestDetails;
        var adSM = adDetail?.adSpecializedMachinery;
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
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  AdDetailHeaderWidget(
                                      titleText: adDetail?.description),
                                  const SizedBox(height: 8),
                                  adDetail?.orderAmount != null
                                      ? AdDetailPriceWidget(
                                          price:
                                              adDetail?.orderAmount.toString())
                                      : const SizedBox(),
                                  const SizedBox(height: 16),
                                  AdDescriptionWidget(
                                      descriptionText:
                                          adDetail?.description ?? '',
                                      adSM: adDetail),
                                  const SizedBox(height: 8),
                                  SpecializedMachineryInfoWidget(
                                    urlFoto: adSM?.urlFoto,
                                    name: adSM?.name,
                                    brand: adSM?.brand?.name,
                                    subCategory: adSM?.type?.name,
                                    price: adSM?.price,
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
                        if (controller.appChangeProvider.userMode ==
                                UserMode.driver ||
                            controller.appChangeProvider.userMode ==
                                UserMode.owner)
                          ApproveOrCancelButtons(approve: () async {
                            final dataa = await SMRequestRepositoryImpl()
                                .postSMRequestApprove(
                                    requestId: widget.requestId);
                            if (dataa?.statusCode == 200) {
                              return true;
                            } else {
                              return false;
                            }
                          }, cancel: () async {
                            final dataa = await SMRequestRepositoryImpl()
                                .postSMRequestCancel(
                                    requestId: widget.requestId);
                            if (dataa?.statusCode == 200) {
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
}
