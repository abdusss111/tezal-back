import 'package:eqshare_mobile/app/app_change_notifier.dart';
import 'package:eqshare_mobile/src/core/presentation/widgets/app_detail_location_row.dart';
import 'package:eqshare_mobile/src/global_widgets/global_values.dart';
import 'package:eqshare_mobile/src/features/ad/data/models/ad_sm_models/ad_sm_client_model/ad_client.dart';
import 'package:eqshare_mobile/src/features/ad/presentation/widgets/ad_detail_header_widget.dart';
import 'package:eqshare_mobile/src/features/ad/presentation/widgets/ad_detail_photos_widget.dart';
import 'package:eqshare_mobile/src/features/main/location/detail_map_screen.dart';
import 'package:eqshare_mobile/src/features/requests/data/models/specialized_machinery_request_models/specialized_machinery_request_client_model/specialized_machinery_request_client.dart';
import 'package:eqshare_mobile/src/features/requests/data/repository/sm_request_repository_impl.dart';
import 'package:eqshare_mobile/src/features/requests/presentation/ali_widgets/approve_or_cancel_buttons.dart';
import 'package:eqshare_mobile/src/features/requests/presentation/widgets/ad_request_created_user_card_widget.dart';
import 'package:eqshare_mobile/src/features/requests/presentation/widgets/specialized_machinery_info_widget.dart';
import 'package:eqshare_mobile/src/global_widgets/global_future_builder.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../../main/profile/profile_page/profile_controller.dart';
import 'sm_client_created_request_detail_controller.dart';

class SMClientCreatedRequestDetailScreen extends StatefulWidget {
  final String adId;

  const SMClientCreatedRequestDetailScreen({
    super.key,
    required this.adId,
  });

  @override
  State<SMClientCreatedRequestDetailScreen> createState() =>
      _SMClientCreatedRequestDetailScreenState();
}

class _SMClientCreatedRequestDetailScreenState
    extends State<SMClientCreatedRequestDetailScreen> {
  late SMClientCreatedRequestDetailController controller;

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();

    await Provider.of<SMClientCreatedRequestDetailController>(context,
            listen: false)
        .loadDetails();
  }

  @override
  void initState() {
    super.initState();

    controller = SMClientCreatedRequestDetailController(widget.adId);
  }

  Column body(SpecializedMachineryRequestClient request, AdClient? ad,
      {bool needButton = false}) {
    final isAssinged = request.assigned != null && request.assigned != 0;
    return Column(children: [
      Expanded(
        child: Padding(
          padding: EdgeInsets.only(top: 16.0),
          child: SingleChildScrollView(
              child: Column(children: [
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 5),
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
                          imageUrls: (request.adSm != null &&
                                  request.adSm!.documents != null &&
                                  request.adSm!.documents!.isNotEmpty)
                              ? request.adSm!.documents!
                                  .map((e) => e.shareLink ?? '')
                                  .toList()
                              : []),
                      Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AdDetailHeaderWidget(
                                  titleText: request.comment ?? '',
                                ),
                                const SizedBox(height: 16),
                                Padding(
                                    padding: const EdgeInsets.all(4),
                                    child:
                                        Divider(color: Colors.grey.shade100)),
                                AdRequestCreatedUserCardWidget(
                                  createdTime: request.createdAt.toString(),
                                  isClientRequest: !needButton,
                                  forClient: (AppChangeNotifier().userMode ==
                                      UserMode.client),
                                  userFirstName: AppChangeNotifier().userMode ==
                                          UserMode.client
                                      ? !isAssinged
                                          ? request.user?.firstName
                                          : request.executorUser?.firstName
                                      : request.adSm?.user?.firstName,
                                  userSecondName:
                                      AppChangeNotifier().userMode ==
                                              UserMode.client
                                          ? !isAssinged
                                              ? request.user?.lastName
                                              : request.executorUser?.lastName
                                          : request.adSm?.user?.lastName,
                                  userContacts: AppChangeNotifier().userMode ==
                                          UserMode.client
                                      ? !isAssinged
                                          ? request.user?.phoneNumber
                                          : request.executorUser?.phoneNumber
                                      : request.adSm?.user?.phoneNumber,
                                  isAssinged: isAssinged,
                                  assingedUserFirstName:
                                      request.user?.firstName,
                                  assingedUSerLastName: request.user?.lastName,
                                  assingedUserContacts:
                                      request.user?.phoneNumber,
                                ),
                                const SizedBox(height: 8),
                                Padding(
                                    padding: const EdgeInsets.all(4),
                                    child:
                                        Divider(color: Colors.grey.shade100)),
                                SpecializedMachineryInfoWidget(
                                  titleText: 'Информация о спецтехнике',
                                  title: ad?.headline,
                                  forClient: AppChangeNotifier().userMode ==
                                      UserMode.client,
                                  userName:
                                      '${ad?.user?.firstName} ${ad?.user?.lastName}',
                                  subCategory: ad?.type?.name?.toString(),
                                  price: (ad?.price ?? 0.0).toInt(),
                                  createdTime: ad?.createdAt.toString(),
                                  startedTime: ad?.startDate,
                                  endedTime: ad?.endDate.toString(),
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
                                Padding(
                                  padding: const EdgeInsets.all(4),
                                ),
                                HalfScreenMapWidget(
                                  latitude: ad?.latitude?.toDouble(),
                                  longitude: ad?.longitude?.toDouble(),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 16),
                                ),
                              ]))
                    ],
                  ),
                )),
          ])),
        ),
      ),
      if (needButton &&
          request.status == RequestStatus.CREATED.name &&
          request.deletedAt == null)
        ApproveOrCancelButtons(
          approve: () async {
            final result = await SMRequestRepositoryImpl()
                .postClientRequestApprove(requestId: widget.adId);

            if (result?.statusCode == 200) {
              return true;
            }
            return false;
          },
          cancel: () async {
            final result = await SMRequestRepositoryImpl()
                .postClientRequestCancel(requestId: widget.adId);

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
            'Заказ к объявлению',
          ),
          leading: IconButton(
            onPressed: () {
              // Navigator.pop(context);
              context.pop();
            },
            icon: const Icon(Icons.arrow_back_ios_new),
          ),
        ),
        body: GlobalFutureBuilder(
            future:
                SMRequestRepositoryImpl().getClientRequestDetailWC(widget.adId),
            buildWidget: (data) {
              return body(data!, data.adSm,
                  needButton: AppChangeNotifier().userMode == UserMode.client);
            }));
  }
}
