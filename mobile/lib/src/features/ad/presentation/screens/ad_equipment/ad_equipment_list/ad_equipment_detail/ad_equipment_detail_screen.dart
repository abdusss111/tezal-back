import 'package:eqshare_mobile/app/app_change_notifier.dart';
import 'package:eqshare_mobile/src/core/presentation/routing/app_route.dart';
import 'package:eqshare_mobile/src/core/presentation/utils/SharePressed.dart';
import 'package:eqshare_mobile/src/core/presentation/utils/auth_middleware.dart';
import 'package:eqshare_mobile/src/core/presentation/widgets/app_detail_location_row.dart';
import 'package:eqshare_mobile/src/core/presentation/widgets/page_wrapper.dart';
import 'package:eqshare_mobile/src/core/res/theme/app_dimensions.dart';
import 'package:eqshare_mobile/src/features/ad/presentation/screens/ad_construction_request_create_screen.dart';
import 'package:eqshare_mobile/src/features/ad/presentation/screens/ad_equipment/ad_equipment_list/ad_equipment_detail/ad_equipment_detail_controller.dart';
import 'package:eqshare_mobile/src/features/ad/presentation/widgets/ad_author_widget.dart';
import 'package:eqshare_mobile/src/features/ad/presentation/widgets/ad_call_button.dart';
import 'package:eqshare_mobile/src/features/ad/presentation/widgets/ad_description_only_widget.dart';

import 'package:eqshare_mobile/src/features/ad/presentation/widgets/ad_description_widget.dart';
import 'package:eqshare_mobile/src/features/ad/presentation/widgets/ad_detail_photos_widget.dart';
import 'package:eqshare_mobile/src/features/ad/presentation/widgets/ad_detail_price_widget.dart';
import 'package:eqshare_mobile/src/features/ad/presentation/widgets/get_widget.dart';
import 'package:eqshare_mobile/src/features/main/location/detail_map_screen.dart';
import 'package:eqshare_mobile/src/features/main/profile/profile_page/profile_controller.dart';
import 'package:eqshare_mobile/src/features/requests/presentation/widgets/specialized_machinery_info_widget.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:separated_row/separated_row.dart';

import '../../../../../../../core/presentation/services/app_bottom_sheet_service.dart';
import '../../../../../../../core/presentation/widgets/app_primary_button.dart';
import '../../../../widgets/ad_detail_header_widget.dart';
import '../../../../widgets/app_like_button_wrapper.dart';
import 'widgets/send_report_bottom_sheet.dart';

class AdEquipmentDetailScreen extends StatefulWidget {
  final String adId;

  const AdEquipmentDetailScreen({
    super.key,
    required this.adId,
  });

  @override
  State<AdEquipmentDetailScreen> createState() =>
      _AdEquipmentDetailScreenState();
}

class _AdEquipmentDetailScreenState extends State<AdEquipmentDetailScreen> {
  late AdEquipmentDetailController controller;

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();

    await Provider.of<AdEquipmentDetailController>(context, listen: false)
        .loadDetails();
  }

  @override
  void initState() {
    controller = AdEquipmentDetailController(widget.adId);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AdEquipmentDetailController>(
      builder: (
        context,
        controller,
        child,
      ) {
        final adDetail = controller.adDetails;

        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'Оборудование',
            ),
            actions: [
              IconButton(
                onPressed: () {
                  SharePressed(widget.adId,
                      '${AppRouteNames.navigation}/${AppRouteNames.adEquipmentList}/${AppRouteNames.adEquipmentDetail}');
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
                              controller.deleteFavorite(
                                widget.adId,
                              );
                            } else {
                              controller.postFavorite(widget.adId);
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
                                          color: Colors.white, // Фон контейнера
                                          borderRadius: BorderRadius.circular(
                                              16), // Скруглённые углы
                                          boxShadow: [
                                            BoxShadow(
                                              offset: Offset(-1,
                                                  -1), // Смещение вверх и влево
                                              blurRadius: 5, // Радиус размытия
                                              color: Color.fromRGBO(0, 0, 0,
                                                  0.04), // Чёрный цвет с 4% прозрачностью
                                            ),
                                            BoxShadow(
                                              offset: Offset(1,
                                                  1), // Смещение вниз и вправо
                                              blurRadius: 5, // Радиус размытия
                                              color: Color.fromRGBO(0, 0, 0,
                                                  0.04), // Чёрный цвет с 4% прозрачностью
                                            ),
                                          ],
                                        ),
                                        clipBehavior: Clip.antiAlias,
                                        child: Column(children: [
                                          AdDetailPhotosWidget(
                                            imageUrls: adDetail?.urlFoto ?? [],
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
                                                            titleText: adDetail
                                                                ?.title),
                                                        const SizedBox(
                                                            height: 8),
                                                        AdDetailPriceWidget(
                                                          price: adDetail?.price
                                                              .toString(),
                                                          rating:
                                                              adDetail?.rating,
                                                        )
                                                      ])),
                                              Padding(
                                                  padding:
                                                      const EdgeInsets.all(4),
                                                  child: Divider(
                                                      color: Colors
                                                          .grey.shade100)),
                                              Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 16),
                                                decoration: const BoxDecoration(
                                                  color: Colors.white,
                                                ),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    AdDescriptionOnlyWidget(
                                                        description: adDetail
                                                                ?.description ??
                                                            ''),
                                                    Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(4),
                                                        child: Divider(
                                                            color: Colors.grey
                                                                .shade100)),
                                                    SpecializedMachineryInfoWidget(
                                                      titleText:
                                                          'Информация об оборудовании',
                                                      name: adDetail?.title,
                                                      brand:
                                                          adDetail?.brand?.name,
                                                      subCategory: adDetail
                                                          ?.subcategory?.name,
                                                      city:
                                                          adDetail?.city?.name,
                                                    ),
                                                    const SizedBox(height: 8),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(height: 10),
                                              AdAuthorWidget(
                                                userImageLink:
                                                    adDetail?.user?.urlImage,
                                                id: adDetail?.user?.id
                                                    .toString(),
                                                firstName:
                                                    adDetail?.user?.firstName,
                                                lastName:
                                                    adDetail?.user?.lastName,
                                                phoneNumber:
                                                    adDetail?.user?.phoneNumber,
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(4),
                                              ),
                                            ],
                                          ),
                                          AppDetailLocationRow(
                                              controller.adDetails?.address),
                                          Padding(
                                            padding: const EdgeInsets.all(4),
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
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 16),
                                            child: GestureDetector(
                                              onTap: () {
                                                AppBottomSheetService
                                                    .showAppCupertinoModalBottomSheet(
                                                  context,
                                                  SendReportEqBottomSheet(
                                                      adEquipmentDetailController:
                                                          controller,
                                                      specializedMachineryId:
                                                          adDetail?.id),
                                                );
                                              },
                                              child: Container(
                                                height: 40,
                                                decoration: BoxDecoration(
                                                  color: Color.fromARGB(
                                                      255, 255, 212, 0),
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Icon(
                                                      Icons.report_outlined,
                                                      color: Colors.black,
                                                      size: 24,
                                                    ),
                                                    const Text(
                                                        'Пожаловаться на обьявление')
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8),
                                          ),
                                        ]))),
                                Padding(
                                  padding: const EdgeInsets.all(8),
                                ),
                                PageWrapper(
                                    child: Column(children: [
                                  ...recommendationAds(context,
                                      getRecommendationAds:
                                          controller.getRecommendationAds,
                                      retryAds: controller.retryAds,
                                      adID: int.parse(controller.adId))
                                ]))
                              ],
                            )))),
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
                                phoneNumber: adDetail?.user?.phoneNumber),
                          ),
                          Expanded(
                            child: AppPrimaryButtonWidget(
                                buttonType: ButtonType.filled,
                                onPressed: () {
                                  AuthMiddleware.executeIfAuthenticated(
                                      context,
                                      () => Navigator.push(context,
                                              MaterialPageRoute(
                                                  builder: (context) {
                                            return AdRequestCreateScreen(
                                                adID: widget.adId,
                                                adPrice: controller
                                                        .adDetails?.price
                                                        .toDouble() ??
                                                    0.0,
                                                approveThisUserPostToDriver: (
                                                    {required adID,
                                                    required adPrice,
                                                    required address,
                                                    required description,
                                                    required latLng,
                                                    pickedEndTime,
                                                    required pickedImages,
                                                    required pickedStart}) async {
                                                  return controller
                                                      .createRequestForDriverOROwnerFromClient(
                                                          adID: adID,
                                                          adPrice: adPrice,
                                                          address: address,
                                                          description:
                                                              description,
                                                          latLng: latLng,
                                                          selectedImages:
                                                              pickedImages,
                                                          toDateTime:
                                                              pickedEndTime,
                                                          fromDateTime:
                                                              pickedStart);
                                                });
                                          })));
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
