import 'package:eqshare_mobile/app/app_change_notifier.dart';
import 'package:eqshare_mobile/src/core/presentation/routing/app_route.dart';
import 'package:eqshare_mobile/src/core/presentation/utils/SharePressed.dart';
import 'package:eqshare_mobile/src/core/presentation/utils/auth_middleware.dart';

import 'package:eqshare_mobile/src/core/presentation/widgets/get_core_widgets.dart';
import 'package:eqshare_mobile/src/core/res/theme/app_dimensions.dart';

import 'package:eqshare_mobile/src/features/ad/presentation/screens/ad_equipment_client/ad_equipment_client_detail/ad_equipment_client_detail_controller.dart';
import 'package:eqshare_mobile/src/features/ad/presentation/screens/ad_sm_client/ad_sm_client_request_create/ad_sm_client_request_create_controller.dart';
import 'package:eqshare_mobile/src/features/ad/presentation/screens/ad_sm_client/ad_sm_client_request_create/ad_sm_client_request_create_screen.dart';
import 'package:eqshare_mobile/src/features/ad/presentation/widgets/get_widget.dart';
import 'package:eqshare_mobile/src/features/main/location/detail_map_screen.dart';
import 'package:eqshare_mobile/src/features/main/profile/profile_page/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:separated_row/separated_row.dart';

class AdEquipmentClientDetailScreen extends StatefulWidget {
  final String adId;

  const AdEquipmentClientDetailScreen({super.key, required this.adId, P});

  @override
  State<AdEquipmentClientDetailScreen> createState() =>
      _AdEquipmentClientDetailScreenState();
}

class _AdEquipmentClientDetailScreenState
    extends State<AdEquipmentClientDetailScreen> {
  late AdEquipmentClientDetailController controller;

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();

    await Provider.of<AdEquipmentClientDetailController>(context, listen: false)
        .loadDetails(context);
  }

  @override
  void initState() {
    controller = AdEquipmentClientDetailController(widget.adId);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AdEquipmentClientDetailController>(
      builder: (
        context,
        controller,
        child,
      ) {
        final adDetail = controller.adDetails;

        return Scaffold(
            appBar: AppBar(
              title: const Text(
                'Объявление клиента',
              ),
              leading: IconButton(
                onPressed: () {
                  // Navigator.pop(context);
                  context.pop();
                },
                icon: const Icon(Icons.arrow_back_ios_new),
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    SharePressed(adDetail?.id.toString(),
                        '${AppRouteNames.navigation}/${AppRouteNames.adEquipmentClientList}/${AppRouteNames.adEquipmentClientDetail}');
                  },
                  icon: const Icon(Icons.share),
                ),
                !controller.isLoading
                    ? AppLikeButtonWrapper(
                        isLiked: controller.isLiked,
                        onTap: (isTapped) {
                          AuthMiddleware.executeIfAuthenticated(
                              context,
                              () => {
                                    if (controller.isLiked == true)
                                      {controller.deleteFavorite(widget.adId)}
                                    else
                                      {controller.postFavorite(widget.adId)},
                                    controller.toggleUpdateList()
                                  });
                        },
                      )
                    : const SizedBox(),
              ],
            ),
            body: !controller.isLoading
                ? Column(
                    children: [
                      Expanded(
                        child: ListView(
                          children: [
                            AdDetailPhotosWidget(
                                imageUrls: adDetail?.urlFoto ?? []),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  AdDetailHeaderWidget(
                                      titleText: adDetail?.title ?? ''),
                                  AdDetailPriceWidget(
                                      price: adDetail?.price.toString()),
                                  AdDescriptionClientWidget(
                                    descriptionText:
                                        adDetail?.description ?? '',
                                    category:
                                        adDetail?.equipmentSubcategory?.name,
                                    createdAt: adDetail?.createdAt.toString(),
                                    startDate:
                                        adDetail?.startLeaseDate.toString(),
                                    endDate: adDetail?.endLeaseDate.toString(),
                                  ),
                                ],
                              ),
                            ),
                            AdAuthorWidget(
                      userImageLink: adDetail?.user?.urlImage,

                              id: adDetail?.user?.id.toString(),
                              firstName: adDetail?.user?.firstName,
                              lastName: adDetail?.user?.lastName,
                              phoneNumber: adDetail?.user?.phoneNumber,
                            ),
                            AppDetailLocationRow(adDetail?.address),
                            HalfScreenMapWidget(
                              latitude: adDetail?.latitude,
                              longitude: adDetail?.longitude,
                            ),
                            SendReportButton(
                                id: widget.adId,
                                sendReport: (
                                    {required String adID,
                                    required int reportReasonID,
                                    required String reportText}) {
                                  final data = controller.onReportPostBussiness(
                                      context,
                                      int.parse(adID),
                                      reportText,
                                      reportReasonID);
                                  return data;
                                }),
                            ...recommendationAds(context,
                                getRecommendationAds:
                                    controller.getRecommendationAds,
                                retryAds: controller.retryAds,
                                adID: int.parse(controller.adId))
                          ],
                        ),
                      ),
                      Padding(
                        padding: AppDimensions.callButtonPadding,
                        child: SeparatedRow(
                          separatorBuilder: (BuildContext context, int index) =>
                              const SizedBox(
                            width:
                                AppDimensions.footerActionButtonsSeparatorWidth,
                          ),
                          children: [
                            Expanded(
                                child: AdCallButton(
                                    phoneNumber:
                                        adDetail?.user?.phoneNumber ?? '')),
                            Expanded(
                              child: AppPrimaryButtonWidget(
                                  buttonType: ButtonType.filled,
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ChangeNotifierProvider(
                                          create: (context) =>
                                              AdSMClientRequestCreateController(),
                                          child: AdSMClientRequestCreateScreen(
                                            adClientId: widget.adId,
                                            type: 'AdEQ',
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                  textColor: Colors.white,
                                  text: AppChangeNotifier().userMode ==
                                              UserMode.client ||
                                          AppChangeNotifier().userMode ==
                                              UserMode.guest
                                      ? 'Отправить заказ'
                                      : 'Принять заказ'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                : const Expanded(
                    child: Center(child: CircularProgressIndicator())));
      },
    );
  }


}
