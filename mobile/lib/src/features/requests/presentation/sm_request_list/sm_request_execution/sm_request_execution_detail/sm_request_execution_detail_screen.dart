import 'package:eqshare_mobile/app/app_change_notifier.dart';
import 'package:eqshare_mobile/src/core/presentation/widgets/app_circular_progress_indicator.dart';
import 'package:eqshare_mobile/src/core/res/app_images.dart';
import 'package:eqshare_mobile/src/features/ad/presentation/widgets/ad_detail_header_widget.dart';
import 'package:eqshare_mobile/src/features/ad/presentation/widgets/ad_detail_photos_widget.dart';
import 'package:eqshare_mobile/src/features/main/location/detail_map_screen.dart';
import 'package:eqshare_mobile/src/features/requests/data/repository/sm_request_repository_impl.dart';
import 'package:eqshare_mobile/src/features/requests/presentation/requests/widgets/build_request_items_button.dart';
import 'package:eqshare_mobile/src/features/requests/presentation/sm_request_list/sm_request_execution/sm_request_execution_detail/sm_request_execution_detail_controller.dart';
import 'package:eqshare_mobile/src/features/requests/presentation/widgets/ad_request_created_user_card_widget.dart';
import 'package:eqshare_mobile/src/features/requests/presentation/widgets/ad_small_request_info_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../../../core/presentation/widgets/app_detail_location_row.dart';
import '../../../../../main/profile/profile_page/profile_controller.dart';

class SMRequestExecutionDetailScreen extends StatefulWidget {
  final String requestId;

  const SMRequestExecutionDetailScreen({
    super.key,
    required this.requestId,
  });

  @override
  State<SMRequestExecutionDetailScreen> createState() =>
      _SMRequestExecutionDetailScreenState();
}

class _SMRequestExecutionDetailScreenState
    extends State<SMRequestExecutionDetailScreen> {
  late SMRequestExecutionDetailController controller;

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();

    await Provider.of<SMRequestExecutionDetailController>(context,
            listen: false)
        .loadDetails(context);
  }

  @override
  void initState() {
    controller = SMRequestExecutionDetailController(widget.requestId);

    super.initState();
  }

  Future<bool> approve() async {
    final data = await SMRequestRepositoryImpl()
        .postSMRequestApprove(requestId: widget.requestId);
    if (data?.statusCode == 200) {
      return true;
    }
    return false;
  }

  Future<bool> cancel() async {
    final data = await SMRequestRepositoryImpl()
        .postSMRequestCancel(requestId: widget.requestId);
    if (data?.statusCode == 200) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SMRequestExecutionDetailController>(
      builder: (
        context,
        controller,
        child,
      ) {
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
                ? Builder(builder: (context) {
                    final requestExecution = controller.requestDetails;

                    String? city;
                    String? brand;
                    String? category;
                    String? title;
                    String? requestExecutionTitle = requestExecution?.title;
                    String? date;

                    int? price;

                    if (!requestExecution!.src!.contains('CLIENT')) {
                      final clientRequest =
                          requestExecution.specializedMachineryRequest;
                      price = clientRequest?.adSpecializedMachinery?.price ?? 0;
                      category =
                          clientRequest?.adSpecializedMachinery?.type?.name;

                      brand =
                          clientRequest?.adSpecializedMachinery?.brand?.name;
                      title = clientRequest?.adSpecializedMachinery?.name;
                      city = clientRequest?.adSpecializedMachinery?.city?.name;
                      date = clientRequest?.adSpecializedMachinery?.createdAt
                          .toString();
                    } else {
                      final clientRequest = requestExecution.request;
                      price = (clientRequest?.adSm?.price ?? 0).toInt();
                      category = clientRequest?.adSm?.type?.name;

                      title = clientRequest?.adSm?.headline;
                      city = clientRequest?.adSm?.city?.name;
                      date = clientRequest?.adSm?.createdAt.toString();
                    }
                    return Column(
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
                                            offset: Offset(
                                                1, 1), // Смещение вниз и вправо
                                            blurRadius: 5, // Радиус размытия
                                            color: Color.fromRGBO(0, 0, 0,
                                                0.04), // Чёрный цвет с 4% прозрачностью
                                          ),
                                        ],
                                      ),
                                      clipBehavior: Clip.antiAlias,
                                      child: Column(
                                        children: [
                                          AdDetailPhotosWidget(
                                              imageUrls:
                                                  requestExecution.urlFoto ??
                                                      [],
                                              imagePlaceholder:
                                                  AppImages.imagePlaceholder),
                                          Padding(
                                              padding:
                                                  const EdgeInsets.all(13.0),
                                              child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    AdDetailHeaderWidget(
                                                        titleText:
                                                            requestExecutionTitle,
                                                            status: requestExecution.status,),
                                                          
                                                        

                                                    Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(4),
                                                            child: Divider(
                                                                color: Colors
                                                                    .grey
                                                                    .shade100)),
                                                    AdRequestCreatedUserCardWidget(
                                                      createdTime:
                                                          requestExecution
                                                              .createdAt
                                                              .toString(),
                                                      endedTime:
                                                          requestExecution
                                                              .workEndAt
                                                              .toString(),
                                                      startedTime:
                                                          requestExecution
                                                              .startLeaseAt
                                                              .toString(),
                                                      forClient:
                                                          AppChangeNotifier()
                                                                  .userMode ==
                                                              UserMode.client,
                                                      userFirstName:
                                                          AppChangeNotifier()
                                                                      .userMode ==
                                                                  UserMode
                                                                      .client
                                                              ? requestExecution
                                                                  .driver
                                                                  ?.firstName
                                                              : requestExecution
                                                                  .client
                                                                  ?.firstName,
                                                      userSecondName:
                                                          AppChangeNotifier()
                                                                      .userMode ==
                                                                  UserMode
                                                                      .client
                                                              ? requestExecution
                                                                  .driver
                                                                  ?.lastName
                                                              : requestExecution
                                                                  .client
                                                                  ?.lastName,
                                                      userContacts:
                                                          AppChangeNotifier()
                                                                      .userMode ==
                                                                  UserMode
                                                                      .client
                                                              ? requestExecution
                                                                  .driver
                                                                  ?.phoneNumber
                                                              : requestExecution
                                                                  .client
                                                                  ?.phoneNumber,
                                                    ),
                                                    const SizedBox(height: 8),
                                                    Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(4),
                                                            child: Divider(
                                                                color: Colors
                                                                    .grey
                                                                    .shade100)),
                                                    AdSmallRequestInfoWidget(
                                                        dateTime: date,
                                                        titleText: AppChangeNotifier()
                                                                    .userMode ==
                                                                UserMode.client
                                                            ? 'Информация о спецтехнике'
                                                            : 'Информация о объявление',
                                                        brand: brand,
                                                        title: title,
                                                        subCategory: category ??
                                                            'Не указан',
                                                        price: (price).toInt(),
                                                        city: city),
                                                    const SizedBox(height: 16),
                                                    Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(4),
                                                            child: Divider(
                                                                color: Colors
                                                                    .grey
                                                                    .shade100)),
                                                    const Text(
                                                      'Адрес объекта',
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    AppDetailLocationRow(
                                                        requestExecution
                                                            .finishAddress),
                                                    HalfScreenMapWidget(
                                                      latitude: requestExecution
                                                          .finishLatitude,
                                                      longitude:
                                                          requestExecution
                                                              .finishLongitude,
                                                    )
                                                  ]))
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ))),
                        ),
                        BuildRequestItemsButton(
                          requestExecution: requestExecution,
                          requestExecutionRepository:
                              controller.requestApiClient,
                          onpressed: (key) {
                            controller.loadDetails(context);
                          },
                        )
                      ],
                    );
                  })
                : const AppCircularProgressIndicator());
      },
    );
  }
}
