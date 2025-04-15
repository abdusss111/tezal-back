import 'package:eqshare_mobile/app/app_change_notifier.dart';
import 'package:eqshare_mobile/src/core/presentation/routing/app_route.dart';
import 'package:eqshare_mobile/src/core/presentation/utils/auth_middleware.dart';

import 'package:eqshare_mobile/src/core/presentation/widgets/get_core_widgets.dart';
import 'package:eqshare_mobile/src/core/presentation/widgets/page_wrapper.dart';
import 'package:eqshare_mobile/src/core/res/theme/app_dimensions.dart';
import 'package:eqshare_mobile/src/features/ad/data/models/ad_sm_models/ad_sm_client_model/ad_client.dart';
import 'package:eqshare_mobile/src/features/ad/presentation/widgets/get_widget.dart';

import 'package:eqshare_mobile/src/features/main/location/detail_map_screen.dart';
import 'package:eqshare_mobile/src/features/main/profile/profile_page/profile_controller.dart';
import 'package:eqshare_mobile/src/global_widgets/global_future_builder.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:separated_row/separated_row.dart';

import '../../../../../../../core/presentation/utils/SharePressed.dart';

import '../../ad_sm_client_request_create/ad_sm_client_request_create_controller.dart';
import '../../ad_sm_client_request_create/ad_sm_client_request_create_screen.dart';
import 'ad_sm_client_detail_controller.dart';

class AdSMClientDetailScreen extends StatefulWidget {
  final String adId;

  const AdSMClientDetailScreen({super.key, required this.adId, P});

  @override
  State<AdSMClientDetailScreen> createState() => _AdSMClientDetailScreenState();
}

class _AdSMClientDetailScreenState extends State<AdSMClientDetailScreen> {
  late AdSMClientDetailController controller;

  @override
  void initState() {
    super.initState();
    controller = AdSMClientDetailController(widget.adId);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AdSMClientDetailController>(
      builder: (context, controller, child) {
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
                    SharePressed(widget.adId.toString(),
                        '${AppRouteNames.navigation}/${AppRouteNames.adSMClientList}/${AppRouteNames.adSMClientDetail}');
                  },
                  icon: const Icon(Icons.share),
                ),
                Consumer<AdSMClientDetailController>(
                    builder: (context, newController, child) {
                  return FutureBuilder(
                      future: controller.checkIsFavourite(
                          int.parse(widget.adId), context),
                      builder: (context, snapshot) {
                        return AppLikeButtonWrapper(
                          isLiked: controller.isLiked,
                          onTap: (isTapped) {
                            AuthMiddleware.executeIfAuthenticated(
                                context,
                                () => {
                                      if (controller.isLiked)
                                        {
                                          newController.deleteFavorite(
                                              widget.adId, context)
                                        }
                                      else
                                        {
                                          newController.postFavorite(
                                              widget.adId, context)
                                        }
                                    });
                          },
                        );
                      });
                }),
              ],
            ),
            body: Consumer<AdSMClientDetailController>(
                builder: (context, value, child) {
              if (value.isLoading) {
                return AppCircularProgressIndicator();
              }
              final adDetail = value.adDetails;
              List<String?> imageUrls = adDetail?.documents
                      ?.map((document) => document.shareLink)
                      .toList() ??
                  [];
              return Column(
                children: [
                   Expanded(
                        child: Padding(
                            padding: EdgeInsets.only(top: 5.0),
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 16),
                                      child: Container(
                                          decoration: BoxDecoration(
                                            color:
                                                Colors.white, // Фон контейнера
                                            borderRadius: BorderRadius.circular(
                                                16), // Скруглённые углы
                                            boxShadow: [
                                              BoxShadow(
                                                offset: Offset(-1,
                                                    -1), // Смещение вверх и влево
                                                blurRadius:
                                                    5, // Радиус размытия
                                                color: Color.fromRGBO(0, 0, 0,
                                                    0.04), // Чёрный цвет с 4% прозрачностью
                                              ),
                                              BoxShadow(
                                                offset: Offset(1,
                                                    1), // Смещение вниз и вправо
                                                blurRadius:
                                                    5, // Радиус размытия
                                                color: Color.fromRGBO(0, 0, 0,
                                                    0.04), // Чёрный цвет с 4% прозрачностью
                                              ),
                                            ],
                                          ),
                                          clipBehavior: Clip.antiAlias,
                                          child: Column(
                                            children: [
                        AdDetailPhotosWidget(imageUrls: imageUrls),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AdDetailHeaderWidget(
                                  titleText: adDetail?.headline ?? ''),
                              AdDetailPriceWidget(
                                  price: adDetail?.price.toString()),
                                  AdDivider(),
                              AdDescriptionClientWidget(
                                descriptionText: adDetail?.description ?? '',
                                category: adDetail?.type?.name,
                                createdAt: adDetail?.createdAt.toString(),
                                startDate: adDetail?.startDate.toString(),
                                endDate: adDetail?.endDate.toString(),
                              ),
                                  AdDivider(),

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
                                  AdDivider(),
                        
                        AppDetailLocationRow(adDetail?.address),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                          child: 
                        HalfScreenMapWidget(
                          latitude: adDetail?.latitude,
                          longitude: adDetail?.longitude,
                        )),
                        Padding(
                          padding: const EdgeInsets.all(8.0)),
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
                            Padding(
                          padding: const EdgeInsets.all(8.0))
                            ]))),
                            Padding(
                          padding: const EdgeInsets.all(8.0),),
                            PageWrapper(child:
                                  Column(
                                    children: [
                        ...recommendationAds(context,
                            getRecommendationAds:
                                controller.getRecommendationAds,
                            retryAds: controller.retryAds,
                            adID: int.parse(widget.adId))
                      ],))]
                    ),
                  ),)),
                  Padding(
                    padding: AppDimensions.callButtonPadding,
                    child: SeparatedRow(
                      separatorBuilder: (BuildContext context, int index) =>
                          const SizedBox(
                        width: AppDimensions.footerActionButtonsSeparatorWidth,
                      ),
                      children: [
                        Expanded(
                            child: AdCallButton(
                                phoneNumber: adDetail?.user?.phoneNumber)),
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
                                        type: 'AdSM',
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
              );
            }));
      },
    );
  }

  Text buildAdSMHeader(AdClient? adDetail) {
    return Text(
      adDetail?.headline ?? '',
      style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
    );
  }
}
