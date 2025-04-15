import 'package:eqshare_mobile/app/app_change_notifier.dart';
import 'package:eqshare_mobile/src/core/presentation/routing/app_route.dart';
import 'package:eqshare_mobile/src/core/presentation/utils/SharePressed.dart';
import 'package:eqshare_mobile/src/core/presentation/utils/auth_middleware.dart';
import 'package:eqshare_mobile/src/core/presentation/widgets/get_core_widgets.dart';
import 'package:eqshare_mobile/src/core/presentation/widgets/page_wrapper.dart';
import 'package:eqshare_mobile/src/core/res/theme/app_dimensions.dart';
import 'package:eqshare_mobile/src/features/ad/presentation/screens/ad_sm/all_ad_sm/ad_sm_detail/widgets/sendReportBottomSheet.dart';
import 'package:eqshare_mobile/src/features/ad/presentation/utils/parameters_utils.dart';
import 'package:eqshare_mobile/src/features/ad/presentation/widgets/get_widget.dart';

import 'package:eqshare_mobile/src/features/main/location/detail_map_screen.dart';
import 'package:eqshare_mobile/src/features/main/profile/profile_page/profile_controller.dart';
import 'package:eqshare_mobile/src/features/requests/presentation/widgets/requests_widgets.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:separated_row/separated_row.dart';

import '../../../../../../../core/presentation/services/app_bottom_sheet_service.dart';

import '../../ad_sm_request/ad_sm_request_create/ad_sm_request_create_controller.dart';
import '../../ad_sm_request/ad_sm_request_create/ad_sm_request_create_screen.dart';
import 'ad_sm_detail_controller.dart';

class AdSMDetailScreen extends StatefulWidget {
  final String adId;

  const AdSMDetailScreen({
    super.key,
    required this.adId,
  });

  @override
  State<AdSMDetailScreen> createState() => _AdSMDetailScreenState();
}

class _AdSMDetailScreenState extends State<AdSMDetailScreen> {
  late AdSMDetailController controller;

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();

    await Provider.of<AdSMDetailController>(context, listen: false)
        .loadDetails(context);
  }

  @override
  void initState() {
    controller = AdSMDetailController(widget.adId)..loadDetails(context);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AdSMDetailController>(
      builder: (context, controller, child) {
        final adDetail = controller.adDetails;
        final showParams = adDetail?.params?.toJson().entries.map((entry) {
          if (entry.value != null &&
              entry.key != 'ad_specialized_machinery_id') {
            return entry;
          } else {
            return null;
          }
        }).toList();
        showParams?.removeWhere((e) => e?.value == null);

        return Scaffold(
          // backgroundColor: const Colors.fromRGBO(240, 240, 240, 1),
          appBar: AppBar(
            title: const Text(
              'Спецтехника',
            ),
            actions: [
              IconButton(
                onPressed: () {
                  SharePressed(widget.adId.toString(),
                      '${AppRouteNames.navigation}/${AppRouteNames.adSMList}/${AppRouteNames.adSMDetail}');
                },
                icon: const Icon(Icons.share),
              ),
              !controller.isLoading
                  ? Padding(
                      padding: EdgeInsets.only(right: 16),
                      child: AppLikeButtonWrapper(
                        isLiked: controller.isLiked,
                        onTap: (isTapped) {
                          AuthMiddleware.executeIfAuthenticated(context, () {
                            if (controller.isLiked == true) {
                              controller.deleteFavorite(widget.adId, context);
                            } else {
                              controller.postFavorite(widget.adId, context);
                            }
                            controller.toggleUpdateList();
                          });
                        },
                      ))
                  : const SizedBox(),
            ],
          ),
          body: !controller.isLoading
              ? Column(
                  children: [
                    Expanded(
                        child: Padding(
                            padding: EdgeInsets.only(top: 5.0),
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 8),
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
                                              AdDetailPhotosWidget(
                                                imageUrls: controller
                                                        .adDetails?.urlFoto ??
                                                    [],
                                              ),
                                              const SizedBox(height: 4),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                      horizontal: 16,
                                                    ),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        AdDetailHeaderWidget(
                                                          titleText:
                                                              adDetail?.name ??
                                                                  '',
                                                        ),
                                                        const SizedBox(
                                                            height: 8),
                                                        AdDetailPriceWidget(
                                                            price: adDetail
                                                                ?.price
                                                                .toString(),
                                                            rating: adDetail
                                                                ?.rating),
                                                      ],
                                                    ),
                                                  ),
                                                  const SizedBox(height: 4),
                                                  Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 16),
                                                    decoration:
                                                        const BoxDecoration(
                                                      color: Colors.white,
                                                    ),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        // AdDescriptionWidget(
                                                        //   descriptionText:
                                                        //       adDetail?.description ?? '',
                                                        //   adSM: controller.adDetails,
                                                        // ),
                                                        Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(4),
                                                            child: Divider(
                                                                color: Colors
                                                                    .grey
                                                                    .shade100)),
                                                        AdDescriptionOnlyWidget(
                                                            description: adDetail
                                                                    ?.description ??
                                                                ''),
                                                        Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(4),
                                                            child: Divider(
                                                                color: Colors
                                                                    .grey
                                                                    .shade100)),
                                                        SpecializedMachineryInfoWidget(
                                                          name: adDetail?.name,
                                                          brand: adDetail
                                                              ?.brand?.name,
                                                          subCategory: adDetail
                                                              ?.type?.name,
                                                          city: adDetail
                                                              ?.city?.name,
                                                        ),
                                                        Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(4),
                                                            child: Divider(
                                                                color: Colors
                                                                    .grey
                                                                    .shade100)),
                                                        if ((showParams ?? [])
                                                                .length >
                                                            1)
                                                          Container(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(0),
                                                            decoration:
                                                                BoxDecoration(
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Row(
                                                                  children: [
                                                                    Text(
                                                                        'Общие характеристики',
                                                                        style: Theme.of(context)
                                                                            .textTheme
                                                                            .bodyLarge),
                                                                  ],
                                                                ),
                                                                const SizedBox(
                                                                    height: 8),
                                                                ...adDetail
                                                                        ?.params
                                                                        ?.toJson()
                                                                        .entries
                                                                        .map(
                                                                            (entry) {
                                                                      if (entry.value !=
                                                                              null &&
                                                                          entry.key !=
                                                                              'ad_specialized_machinery_id') {
                                                                        return ParametersUtils.formatParameter(
                                                                            entry.key,
                                                                            entry.value);
                                                                      } else {
                                                                        return const SizedBox
                                                                            .shrink();
                                                                      }
                                                                    }).toList() ??
                                                                    <Widget>[],
                                                              ],
                                                            ),
                                                          ),
                                                      ],
                                                    ),
                                                  ),
                                                  if ((showParams ?? [])
                                                          .length >
                                                      1)
                                                    Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(4),
                                                        child: Divider(
                                                            color: Colors.grey
                                                                .shade100)),
                                                  AdAuthorWidget(
                                                    userImageLink: adDetail
                                                        ?.user?.urlImage,
                                                    id: adDetail?.userId
                                                        .toString(),
                                                    firstName: adDetail
                                                        ?.user?.firstName,
                                                    lastName: adDetail
                                                        ?.user?.lastName,
                                                    phoneNumber: adDetail
                                                        ?.user?.phoneNumber,
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(4),
                                                  )
                                                ],
                                              ),
                                              AppDetailLocationRow(controller
                                                  .adDetails?.address),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(4),
                                              ),
                                              Container(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 16),
                                                  child: HalfScreenMapWidget(
                                                    latitude: controller
                                                        .adDetails?.latitude,
                                                    longitude: controller
                                                        .adDetails?.longitude,
                                                  )),
                                              const SizedBox(
                                                height: 20,
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 16),
                                                child: GestureDetector(
                                                  onTap: () {
                                                    AppBottomSheetService
                                                        .showAppCupertinoModalBottomSheet(
                                                      context,
                                                      SendReportBottomSheet(
                                                          adSMDetailController:
                                                              controller,
                                                          specializedMachineryId:
                                                              adDetail?.id ??
                                                                  int.parse(widget
                                                                      .adId)),
                                                    );
                                                  },
                                                  child: Container(
                                                    height: 45,
                                                    decoration: BoxDecoration(
                                                      color: Color.fromARGB(
                                                          255, 255, 212, 0),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                    ),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Icon(
                                                          Icons.report_outlined,
                                                          color: Colors.black,
                                                          size: 24,
                                                        ),
                                                        const Text(
                                                            'Пожаловаться на обьявление',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600))
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8),
                                              ),
                                            ],
                                          ))),
                                  Padding(
                                    padding: const EdgeInsets.all(8),
                                  ),
                                  PageWrapper(
                                      child: Column(
                                    children: [
                                      ...recommendationAds(context,
                                          adID: adDetail?.id ?? 0,
                                          getRecommendationAds:
                                              controller.getRecommendationAds,
                                          retryAds: controller.retryAds),
                                    ],
                                  ))
                                ],
                              ),
                            ))),
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
                                  phoneNumber: adDetail?.user?.phoneNumber)),
                          Expanded(
                            child: AppPrimaryButtonWidget(
                                buttonType: ButtonType.filled,
                                onPressed: () {
                                  AuthMiddleware.executeIfAuthenticated(
                                    context,
                                    () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ChangeNotifierProvider(
                                          create: (context) =>
                                              AdSMRequestCreateController(),
                                          child: AdSMRequestCreateScreen(
                                            adSMId: widget.adId,
                                            adSMPrice: controller
                                                    .adDetails?.price
                                                    ?.toDouble() ??
                                                0.0,
                                          ),
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
              : const Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}
