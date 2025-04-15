import 'package:eqshare_mobile/app/app_change_notifier.dart';
import 'package:eqshare_mobile/src/global_widgets/global_values.dart';
import 'package:eqshare_mobile/src/features/ad/data/models/ad_sm_models/ad_sm_model/ad_specialized_machinery.dart';
import 'package:eqshare_mobile/src/features/ad/presentation/widgets/ad_detail_header_widget.dart';
import 'package:eqshare_mobile/src/features/ad/presentation/widgets/ad_detail_photos_widget.dart';
import 'package:eqshare_mobile/src/features/main/location/detail_map_screen.dart';
import 'package:eqshare_mobile/src/features/requests/data/repository/sm_request_repository_impl.dart';
import 'package:eqshare_mobile/src/features/requests/presentation/ali_widgets/approve_or_cancel_buttons.dart';
import 'package:eqshare_mobile/src/features/requests/presentation/widgets/ad_request_created_user_card_widget.dart';
import 'package:eqshare_mobile/src/global_widgets/global_future_builder.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../../../core/presentation/widgets/app_detail_location_row.dart';
import '../../../../../main/profile/profile_page/profile_controller.dart';
import '../../../../data/models/specialized_machinery_request_models/specialized_machinery_request_model/specialized_machinery_request.dart';
import '../../../widgets/specialized_machinery_info_widget.dart';
import 'sm_created_request_detail_controller.dart';

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
    // _pageController = PageController(initialPage: _currentIndex);

    super.initState();
  }

  final requestApiClient = SMRequestRepositoryImpl();

  Column body(SpecializedMachineryRequest? request, AdSpecializedMachinery? ad,
      {bool needButton = false}) {
    return Column(children: [
      Expanded(
        child: Padding(
          padding: EdgeInsets.only(top: 5.0),
          child: SingleChildScrollView(
              child: Column(children: [
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white, // Фон контейнера
                    borderRadius: BorderRadius.circular(16), // Скруглённые углы
                    boxShadow: [
                      BoxShadow(
                        offset: Offset(-1, -1), // Смещение вверх и влево
                        blurRadius: 5, // Радиус размытия
                        color: Color.fromRGBO(
                            0, 0, 0, 0.04), // Чёрный цвет с 4% прозрачностью
                      ),
                      BoxShadow(
                        offset: Offset(1, 1), // Смещение вниз и вправо
                        blurRadius: 5, // Радиус размытия
                        color: Color.fromRGBO(
                            0, 0, 0, 0.04), // Чёрный цвет с 4% прозрачностью
                      ),
                    ],
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    children: [
                      AdDetailPhotosWidget(
                        imageUrls: request?.urlFoto ?? <String>[],
                      ),
                      Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AdDetailHeaderWidget(
                                  titleText: request?.description ?? '',
                                  status: request?.status,
                                ),
                                Padding(
                                    padding: const EdgeInsets.all(4),
                                    child:
                                        Divider(color: Colors.grey.shade100)),
                                const SizedBox(height: 16),
                                AdRequestCreatedUserCardWidget(
                                  startedTime: request?.startLeaseAt.toString(),
                                  endedTime: request?.endLeaseAt.toString(),
                                  createdTime: request?.createdAt.toString(),
                                  isClientRequest: !needButton,
                                  forClient: (AppChangeNotifier().userMode ==
                                      UserMode.client),
                                  userFirstName:
                                      !(AppChangeNotifier().payload?.aud ==
                                              'CLIENT')
                                          ? request?.user?.firstName
                                          : request?.adSpecializedMachinery
                                              ?.user?.firstName,
                                  userSecondName:
                                      !(AppChangeNotifier().payload?.aud ==
                                              'CLIENT')
                                          ? request?.user?.lastName
                                          : request?.adSpecializedMachinery
                                              ?.user?.lastName,
                                  userContacts:
                                      !(AppChangeNotifier().payload?.aud ==
                                              'CLIENT')
                                          ? request?.user?.phoneNumber
                                          : request?.adSpecializedMachinery
                                              ?.user?.phoneNumber,
                                ),
                                const SizedBox(height: 8),
                                Padding(
                                    padding: const EdgeInsets.all(4),
                                    child:
                                        Divider(color: Colors.grey.shade100)),
                                SpecializedMachineryInfoWidget(
                                  urlFoto:
                                      request?.adSpecializedMachinery?.urlFoto,
                                  titleText: 'Информация о спецтехнике',
                                  title: ad?.name,
                                  forClient: AppChangeNotifier().payload?.aud ==
                                      'CLIENT',
                                  userName:
                                      '${ad?.user?.firstName} ${ad?.user?.lastName}',
                                  subCategory: ad?.type?.name?.toString(),
                                  price: (ad?.price ?? 0.0).toInt(),
                                  createdTime: ad?.createdAt.toString(),
                                  city: ad?.city?.name,
                                ),
                                const SizedBox(height: 16),
                                Padding(
                                    padding: const EdgeInsets.all(4),
                                    child:
                                        Divider(color: Colors.grey.shade100)),
                                const Text(
                                  'Адрес объекта',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                AppDetailLocationRow(ad?.address),
                                HalfScreenMapWidget(
                                  latitude: ad?.latitude?.toDouble(),
                                  longitude: ad?.longitude?.toDouble(),
                                )
                              ]))
                    ],
                  ),
                )),
          ])),
        ),
      ),
      if (needButton &&
          request?.status == RequestStatus.CREATED.name &&
          (request?.deletedAt == null
              ? true
              : request!.deletedAt.toString().isEmpty))
        ApproveOrCancelButtons(
          approve: () async {
            final result = await requestApiClient.postSMRequestApprove(
              requestId: widget.requestId,
            );
            if (result?.statusCode == 200) {
              return true;
            }
            return false;
          },
          cancel: () async {
            final result = await requestApiClient.postSMRequestCancel(
                requestId: widget.requestId);
            if (result?.statusCode == 200) {
              return true;
            }
            return false;
          },
        )
    ]);
  }

  @override
  Widget build(BuildContext context) {
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
      body: GlobalFutureBuilder(
          future: requestApiClient.getSMRequestDetail(widget.requestId),
          buildWidget: (data) {
            return body(data, data?.adSpecializedMachinery,
                needButton: AppChangeNotifier().userMode != UserMode.client);
          }),
    );
  }
}
