import 'package:eqshare_mobile/app/app_change_notifier.dart';
import 'package:eqshare_mobile/src/core/data/models/payload/payload.dart';
import 'package:eqshare_mobile/src/core/presentation/routing/app_route.dart';
import 'package:eqshare_mobile/src/core/presentation/utils/SharePressed.dart';
import 'package:eqshare_mobile/src/core/presentation/utils/auth_middleware.dart';
import 'package:eqshare_mobile/src/core/presentation/widgets/app_circular_progress_indicator.dart';
import 'package:eqshare_mobile/src/core/presentation/widgets/app_detail_location_row.dart';
import 'package:eqshare_mobile/src/core/presentation/widgets/app_primary_button.dart';
import 'package:eqshare_mobile/src/core/res/theme/app_dimensions.dart';
import 'package:eqshare_mobile/src/features/ad/data/models/ad_service_models/ad_service_model/ad_service_model.dart';
import 'package:eqshare_mobile/src/features/ad/data/repository/ad_service_repository.dart';
import 'package:eqshare_mobile/src/features/ad/presentation/screens/ad_client_create_request_screen.dart';
import 'package:eqshare_mobile/src/features/ad/presentation/screens/ad_construction_request_create_screen.dart';
import 'package:eqshare_mobile/src/features/ad/presentation/screens/ad_service/ad_service_detail_screen/ad_service_detail_screen_controller.dart';
import 'package:eqshare_mobile/src/features/ad/presentation/widgets/get_widget.dart';
import 'package:eqshare_mobile/src/features/main/location/detail_map_screen.dart';
import 'package:eqshare_mobile/src/features/main/profile/profile_page/profile_controller.dart';
import 'package:eqshare_mobile/src/features/requests/presentation/widgets/ad_small_info_widget.dart';
import 'package:eqshare_mobile/src/global_widgets/global_future_builder.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:separated_row/separated_row.dart';

class AdServiceDetailScreen extends StatefulWidget {
  final String id;
  const AdServiceDetailScreen({super.key, required this.id});

  @override
  State<AdServiceDetailScreen> createState() => _AdServiceDetailScreenState();
}

class _AdServiceDetailScreenState extends State<AdServiceDetailScreen> {
  final adServiceRepo = AdServiceRepository();

  late final Future<Payload?> future;

  @override
  initState() {
    super.initState();
    future =
        Provider.of<AdServiceDetailScreenController>(context, listen: false)
            .getPayload();
  }

  Widget callForAuthorButton(String? phoneNumber) {
    return Expanded(child: AdCallButton(phoneNumber: phoneNumber));
  }

  AdDetailPhotosWidget adDetailPhotosWidget(List<String> imageUrls) {
    return AdDetailPhotosWidget(
      imageUrls: imageUrls,
    );
  }

  Widget driverOrOwnerDetailBody(Payload payload) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Услуга'),
          leading: const BackButton(),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () {
                SharePressed(widget.id.toString(),
                    '${AppRouteNames.navigation}/${AppRouteNames.adServiceClientList}/${AppRouteNames.adServiceClientDetailScreen}');
              },
              icon: const Icon(Icons.share),
            ),
            Consumer<AdServiceDetailScreenController>(
                builder: (context, controller, child) {
              return FutureBuilder<bool>(
                  future:
                      adServiceRepo.checkIsAdServiceISFavouriteForDriverOrOwner(
                          int.parse(widget.id)),
                  builder: (context, snapshot) {
                    return AppLikeButtonWrapper(
                      isLiked: snapshot.data,
                      key: controller.uniqueKey,
                      onTap: (isTapped) {
                        AuthMiddleware.executeIfAuthenticated(context,
                            () async {
                          if (snapshot.data == true) {
                            await adServiceRepo
                                .deleteFavouriteADClientServiceFromDriverOrOwnerAccount(
                                    widget.id);
                          } else {
                            await adServiceRepo
                                .adForFavouriteADClientServiceFromDriverOrOwnerAccount(
                                    widget.id);
                          }
                          controller.changeUniqueKeyForLike();
                        });
                      },
                    );
                  });
            })
          ],
        ),
        body: Consumer<AdServiceDetailScreenController>(
            builder: (context, value, child) {
          return Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    AdDetailPhotosWidget(
                        imageUrls: value.adServiceClient?.urlFoto ?? []),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AdDetailHeaderWidget(
                              titleText: value.adServiceClient?.title ?? ''),
                          AdDetailPriceWidget(
                              price: value.adServiceClient?.price.toString(),
                              rating: value.adServiceClient?.rating),
                          AdDescriptionClientWidget(
                            descriptionText:
                                value.adServiceClient?.description ?? '',
                            category: value.adServiceClient?.subcategory?.name,
                            createdAt:
                                value.adServiceClient?.createdAt.toString(),
                            startDate: value.adServiceClient?.startLeaseDate
                                .toString(),
                            endDate:
                                value.adServiceClient?.endLeaseDate.toString(),
                          ),
                        ],
                      ),
                    ),
                    AdAuthorWidget(
                      id: value.adServiceClient?.user?.id.toString(),
                      firstName: value.adServiceClient?.user?.firstName,
                      lastName: value.adServiceClient?.user?.lastName,
                      phoneNumber: value.adServiceClient?.user?.phoneNumber,
                    ),
                    AppDetailLocationRow(value.adServiceClient?.address),
                    HalfScreenMapWidget(
                      latitude: value.adServiceClient?.latitude,
                      longitude: value.adServiceClient?.longitude,
                    ),
                    SendReportButton(
                        id: widget.id,
                        sendReport: (
                            {required String adID,
                            required int reportReasonID,
                            required String reportText}) {
                          final data = value.sendReport(
                              adID: adID,
                              reportReasonID: reportReasonID,
                              reportText: reportText);
                          return data;
                        }),
                    ...recommendationAds(context,
                        getRecommendationAds: value.getRecommendationAds,
                        retryAds: value.retryAds,
                        adID: int.parse(value.adID))
                  ],
                ),
              ),
              Padding(
                padding: AppDimensions.callButtonPadding,
                child: SeparatedRow(
                  separatorBuilder: (BuildContext context, int index) =>
                      const SizedBox(
                    width: AppDimensions.footerActionButtonsSeparatorWidth,
                  ),
                  children: [
                    callForAuthorButton(
                        value.adServiceClient?.user?.phoneNumber),
                    Expanded(
                      child: FutureBuilder(
                          future: adServiceRepo.getPayloadWithNull(),
                          builder: (context, snapshot) {
                            return AppPrimaryButtonWidget(
                                buttonType: ButtonType.filled,
                                onPressed: () {
                                  if (snapshot.data == null) {
                                    context.pushNamed(AppRouteNames.login);
                                    return;
                                  }
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            AdClientCreateRequestScreen(
                                          onPressedCreateRequest: (
                                            value,
                                            executorID,
                                          ) async {
                                            final result = await adServiceRepo
                                                .postRequestFromDriverOrOwnerTOClientAdService(
                                                    description: value,
                                                    adServiceID:
                                                        int.parse(widget.id),
                                                    driverOrOwnerID:
                                                        executorID);
                                            return result;
                                          },
                                          payload: payload,
                                        ),
                                      ));
                                },
                                textColor: Colors.white,
                                text: AppChangeNotifier().userMode ==
                                            UserMode.client ||
                                        AppChangeNotifier().userMode ==
                                            UserMode.guest
                                    ? 'Отправить заказ'
                                    : 'Принять заказ');
                          }),
                    ),
                  ],
                ),
              ),
            ],
          );
        }));
  }

  Scaffold clientBody(AdServiceModel? data) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Объявление'),
          leading: const BackButton(),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () {
                SharePressed(widget.id.toString(),
                    '${AppRouteNames.navigation}/${AppRouteNames.adServiceList}/${AppRouteNames.adServiceDetailScreen}');
              },
              icon: const Icon(Icons.share),
            ),
            Consumer<AdServiceDetailScreenController>(
                builder: (context, controller, child) {
              return FutureBuilder<bool>(
                  future: adServiceRepo.checkIsAdServiceISFavouriteForClient(
                      aadServiceID: int.parse(widget.id)),
                  builder: (context, snapshot) {
                    return AppLikeButtonWrapper(
                      isLiked: snapshot.data,
                      key: controller.uniqueKey,
                      onTap: (isTapped) {
                        AuthMiddleware.executeIfAuthenticated(context,
                            () async {
                          if (snapshot.data == true) {
                            await adServiceRepo
                                .deleteFavouriteADDriverOrOwnerServiceFromClientAccount(
                                    widget.id);
                          } else {
                            await adServiceRepo
                                .adForFavouriteADDriverOrOwnerServiceFromClientAccount(
                                    widget.id);
                          }
                          controller.changeUniqueKeyForLike();
                        });
                      },
                    );
                  });
            })
          ],
        ),
        body: Consumer<AdServiceDetailScreenController>(
            builder: (context, value, child) {
          return Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    adDetailPhotosWidget(data?.urlFoto ?? []),
                    const SizedBox(height: 4),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                            ),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  AdDetailHeaderWidget(titleText: data?.title),
                                  const SizedBox(height: 8),
                                  AdDetailPriceWidget(
                                      price: data?.price.toString()),
                                ])),
                        const AdDivider(),
                        AdDescriptionOnlyWidget(
                            description: data?.description ?? ''),
                        const AdDivider(),
                        Container(
                          decoration: const BoxDecoration(
                            color: Colors.white,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AdSmallInfoWidget(
                                hintTextForTitleText:
                                    'Дополнительная информация',
                                titleText: 'Информация об услуге',
                                subCategory: data?.subcategory?.name,
                                price: data?.price,
                                city: data?.city?.name,
                              ),
                              const SizedBox(height: 8),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        AdAuthorWidget(
                          userImageLink: data?.user?.urlImage,
                          id: data?.user?.id.toString(),
                          firstName: data?.user?.firstName,
                          lastName: data?.user?.lastName,
                          phoneNumber: data?.user?.phoneNumber,
                        ),
                      ],
                    ),
                    AppDetailLocationRow(data?.address),
                    HalfScreenMapWidget(
                      latitude: data?.latitude,
                      longitude: data?.longitude,
                    ),
                    const SizedBox(height: 20),
                    SendReportButton(
                        id: widget.id, sendReport: adServiceRepo.sendReport),
                    ...recommendationAds(context,
                        getRecommendationAds: value.getRecommendationAds,
                        retryAds: value.retryAds,
                        adID: int.parse(value.adID))
                  ],
                ),
              ),
              Padding(
                padding: AppDimensions.footerActionButtonsPadding,
                child: SeparatedRow(
                  separatorBuilder: (BuildContext context, int index) =>
                      const SizedBox(
                    width: AppDimensions.footerActionButtonsSeparatorWidth,
                  ),
                  children: [
                    Expanded(
                      child: callForAuthorButton(data?.user?.phoneNumber),
                    ),
                    Expanded(
                      child: FutureBuilder(
                          future: adServiceRepo.getPayloadWithNull(),
                          builder: (context, snapshot) {
                            return AppPrimaryButtonWidget(
                                buttonType: ButtonType.filled,
                                onPressed: () {
                                  AuthMiddleware.executeIfAuthenticated(
                                      context,
                                      () => Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  AdRequestCreateScreen(
                                                    adID: data?.id.toString() ??
                                                        '',
                                                    adPrice: data?.price
                                                            ?.toDouble() ??
                                                        0,
                                                    approveThisUserPostToDriver: (
                                                        {required adID,
                                                        required adPrice,
                                                        required address,
                                                        required description,
                                                        required latLng,
                                                        pickedEndTime,
                                                        required pickedImages,
                                                        required pickedStart}) async {
                                                      final result = await adServiceRepo
                                                          .postRequestFromClientTODriverOrOwnerAdService(
                                                              address: address,
                                                              latitude: latLng
                                                                  .latitude,
                                                              longitude: latLng
                                                                  .longitude,
                                                              adServiceID:
                                                                  int.parse(
                                                                      adID),
                                                              images:
                                                                  pickedImages,
                                                              description:
                                                                  description,
                                                              endLeaseAt:
                                                                  pickedEndTime,
                                                              startLeaseAt:
                                                                  pickedStart);
                                                      return result;
                                                    },
                                                  ))));
                                },
                                textColor: Colors.white,
                                text: AppChangeNotifier().userMode ==
                                            UserMode.client ||
                                        AppChangeNotifier().userMode ==
                                            UserMode.guest
                                    ? 'Отправить заказ'
                                    : 'Принять заказ');
                          }),
                    ),
                  ],
                ),
              ),
            ],
          );
        }));
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AdServiceDetailScreenController>(
        builder: (context, controller, child) {
      return GlobalFutureBuilder(
          future: future,
          circularProgressWidget: Material(
              color: Colors.white, child: AppCircularProgressIndicator()),
          buildWidget: (payload) {
            return Consumer<AdServiceDetailScreenController>(
                builder: (context, value, child) {
              if (value.isLoading) {
                return Material(
                    color: Colors.white, child: AppCircularProgressIndicator());
              }
              if (value.isClient) {
                return clientBody(value.adService);
              } else {
                return driverOrOwnerDetailBody(payload!);
              }
            });
          });
    });
  }
}
