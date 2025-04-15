// ignore_for_file: constant_identifier_names

import 'package:eqshare_mobile/app/app_change_notifier.dart';
import 'package:eqshare_mobile/src/core/data/services/network/api_client/user_profile_api_client.dart';
import 'package:eqshare_mobile/src/core/presentation/routing/app_route.dart';
import 'package:eqshare_mobile/src/core/presentation/services/app_dialog_service.dart';
import 'package:eqshare_mobile/src/core/res/app_images.dart';
import 'package:eqshare_mobile/src/features/main/profile/profile_page/profile_controller.dart';
import 'package:eqshare_mobile/src/global_widgets/global_future_builder.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

enum RequestStatus {
  CREATED,
  AWAITS_START,
  APPROVED,
  WORKING,
  FINISHED,
  PAUSE,
  CANCELED,
  ON_ROAD,
  DELETED
}

enum SortAlgorithmEnum {
  ascCreatedAt('ASC=created_at'),
  descCreatedAt('DESC=created_at'),

  ascPrice('ASC=price'),
  descPrice('DESC=price');

  final String name;

  const SortAlgorithmEnum(this.name);
}

Map<String, String> keyValueForSortAlgorithmEnum(String name,
    {bool needToLowerCase = false}) {
  final parts = name.split('=');
  if (parts.length == 2) {
    if (needToLowerCase) {
      return {parts[0].toLowerCase(): parts[1]};
    }
    return {parts[0]: parts[1]};
  } else {
    return {};
  }
}

SortAlgorithmEnum getSortAlgorithmEnumFromString(String value) {
  switch (value) {
    case 'ASC=created_at':
      return SortAlgorithmEnum.ascCreatedAt;
    case 'DESC=created_at':
      return SortAlgorithmEnum.descCreatedAt;
    case 'ASC=price':
      return SortAlgorithmEnum.ascPrice;
    case 'DESC=price':
      return SortAlgorithmEnum.descPrice;
    default:
      return SortAlgorithmEnum.ascCreatedAt;
  }
}

String getNameOfSortAlgorithmEnum(SortAlgorithmEnum value) {
  switch (value) {
    case SortAlgorithmEnum.ascCreatedAt:
      return 'Сначала старые';
    case SortAlgorithmEnum.descCreatedAt:
      return 'Сначала новые';
    case SortAlgorithmEnum.ascPrice:
      return 'Сначала дешевые';
    case SortAlgorithmEnum.descPrice:
      return 'Сначала дорогие';
    default:
      return 'Неизвестное';
  }
}

enum DefaultNames {
  allCategories('Все категории'),
  allSubCategories('Все подкатегории');

  final String name;

  const DefaultNames(this.name);
}

enum ServiceTypeEnum {
  MACHINARY('MACHINARY'),
  EQUIPMENT('EQUIPMENT'),
  CM('CM'),
  SVM('SVC');

  // MACHINARY_RUS('Спецтехника'),
  // EQUIPMENT_RUS('Оборудование');

  final String name;

  const ServiceTypeEnum(this.name);
}

enum AllServiceTypeEnum {
  MACHINARY,
  MACHINARY_CLIENT,
  EQUIPMENT,
  EQUIPMENT_CLIENT,
  CM,
  CM_CLIENT,
  SVM,
  SVM_CLIENT,
  UNKNOWN
}

String getAdListToolsBlockTitleFromSelectedServiceType(
    ServiceTypeEnum? serviceTypeEnum) {
  switch (serviceTypeEnum) {
    case ServiceTypeEnum.CM:
      return 'Заказы материалов';
    case ServiceTypeEnum.MACHINARY:
      return 'Заказы спецтехник';
    case ServiceTypeEnum.EQUIPMENT:
      return 'Оборудования';
    case ServiceTypeEnum.SVM:
      return 'Заказы услуг';
    // case ServiceTypeEnum.MACHINARY_RUS : return 'Заказы спецтехник';
    // case ServiceTypeEnum.EQUIPMENT_RUS : return 'Заказы оборудования';
    default:
      return 'Заказы ';
  }
}

ServiceTypeEnum getServiceTypeEnumFromString(String? selectedServiceType) {
  switch (selectedServiceType) {
    case 'MACHINARY':
      return ServiceTypeEnum.MACHINARY;
    case 'EQUIPMENT':
      return ServiceTypeEnum.EQUIPMENT;
    case 'CM':
      return ServiceTypeEnum.CM;
    case 'SVC':
      return ServiceTypeEnum.SVM;
    // case 'Спецтехника': return ServiceTypeEnum.MACHINARY_RUS;
    // case 'Оборудование': return ServiceTypeEnum.EQUIPMENT_RUS;
    default:
      return ServiceTypeEnum.MACHINARY;
  }
}

String getServiceTypeStringFromEnum(ServiceTypeEnum serviceTypeEnum) {
  switch (serviceTypeEnum) {
    case ServiceTypeEnum.MACHINARY:
      return 'Спецтехника';
    case ServiceTypeEnum.EQUIPMENT:
      return 'Оборудование';
    case ServiceTypeEnum.CM:
      return 'Материалы';
    case ServiceTypeEnum.SVM:
      return 'Услуга';
    default:
      return 'Неизвестный тип'; // На случай, если передано неизвестное значение
  }
}

String getTypeFromAllServiceTypeEnum(AllServiceTypeEnum typeEnum) {
  switch (typeEnum) {
    case AllServiceTypeEnum.CM:
      return 'Строий материалы';
    case AllServiceTypeEnum.MACHINARY:
      return 'Спецтехника';
    case AllServiceTypeEnum.EQUIPMENT:
      return 'Оборудовании';
    case AllServiceTypeEnum.SVM:
      return 'Услуги';
    case AllServiceTypeEnum.CM_CLIENT:
      return 'Строй материалы';
    case AllServiceTypeEnum.MACHINARY_CLIENT:
      return 'Спецтехника';
    case AllServiceTypeEnum.EQUIPMENT_CLIENT:
      return 'Оборудовании';
    case AllServiceTypeEnum.SVM_CLIENT:
      return 'Услуги';
    default:
      return 'Заказы ';
  }
}

AllServiceTypeEnum getAllServiceTypeEnumEnumFromName(String enumName) {
  switch (enumName) {
    case 'CM':
      return AllServiceTypeEnum.CM;
    case 'MACHINARY':
      return AllServiceTypeEnum.MACHINARY;
    case 'EQUIPMENT':
      return AllServiceTypeEnum.EQUIPMENT;
    case 'SVM':
      return AllServiceTypeEnum.SVM;
    case 'CM_CLIENT':
      return AllServiceTypeEnum.CM_CLIENT;
    case 'MACHINARY_CLIENT':
      return AllServiceTypeEnum.MACHINARY_CLIENT;
    case 'EQUIPMENT_CLIENT':
      return AllServiceTypeEnum.EQUIPMENT_CLIENT;
    case 'SVM_CLIENT':
      return AllServiceTypeEnum.SVM_CLIENT;
    default:
      throw Exception('Неизвестное имя enum: $enumName');
  }
}

Color getAllServiceTypeEnumColor(AllServiceTypeEnum typeEnum) {
  switch (typeEnum) {
    case AllServiceTypeEnum.CM:
      return Colors.green;

    case AllServiceTypeEnum.MACHINARY:
      return Colors.blue;

    case AllServiceTypeEnum.EQUIPMENT:
      return Colors.red;

    case AllServiceTypeEnum.SVM:
      return Colors.yellow;

    case AllServiceTypeEnum.CM_CLIENT:
      return Colors.green;

    case AllServiceTypeEnum.MACHINARY_CLIENT:
      return Colors.blue;

    case AllServiceTypeEnum.EQUIPMENT_CLIENT:
      return Colors.red;

    case AllServiceTypeEnum.SVM_CLIENT:
      return Colors.yellow;

    default:
      return Colors.green;
  }
}

Color getStatusColor(String status) {
  switch (status) {
    case 'CREATED':
      return Colors.green;
    case 'AWAITS_START':
      return Colors.orange;
    case 'ON_ROAD':
      return Colors.blue;
    case 'WORKING':
      return Colors.green;
    case 'RESUME':
      return Colors.green;
    case 'PAUSE':
      return Colors.red;
    case 'FINISHED':
      return Colors.green;
    default:
      return Colors.grey;
  }
}

AllServiceTypeEnum getAllServiceTypeEnumFromSRC(String src) {
  final data = src.toUpperCase();
  switch (data) {
    case 'CM':
      return AllServiceTypeEnum.CM;
    case 'MACHINARY':
      return AllServiceTypeEnum.MACHINARY;
    case 'EQUIPMENT':
      return AllServiceTypeEnum.EQUIPMENT;
    case 'SVM':
      return AllServiceTypeEnum.SVM;
    case 'CM_CLIENT':
      return AllServiceTypeEnum.CM_CLIENT;
    case 'MACHINARY_CLIENT':
      return AllServiceTypeEnum.MACHINARY_CLIENT;
    case 'EQUIPMENT_CLIENT':
      return AllServiceTypeEnum.EQUIPMENT_CLIENT;
    case 'SVM_CLIENT':
      return AllServiceTypeEnum.SVM_CLIENT;
    default:
      return AllServiceTypeEnum
          .UNKNOWN; // Если строка не соответствует ни одному типу
  }
}

AllServiceTypeEnum getAllServiceTypeEnumFromSRCStandart(String src) {
  final data = src.toUpperCase();
  switch (data) {
    case 'CM':
      return AllServiceTypeEnum.CM;
    case 'SM':
      return AllServiceTypeEnum.MACHINARY;
    case 'EQ':
      return AllServiceTypeEnum.EQUIPMENT;
    case 'SVC':
      return AllServiceTypeEnum.SVM;
    case 'CM_CLIENT':
      return AllServiceTypeEnum.CM_CLIENT;
    case 'SM_CLIENT':
      return AllServiceTypeEnum.MACHINARY_CLIENT;
    case 'EQ_CLIENT':
      return AllServiceTypeEnum.EQUIPMENT_CLIENT;
    case 'SVC_CLIENT':
      return AllServiceTypeEnum.SVM_CLIENT;
    default:
      return AllServiceTypeEnum
          .UNKNOWN; // Если строка не соответствует ни одному типу
  }
}

UserMode getUserMode(String userMode) {
  final value = userMode.toUpperCase();
  switch (value) {
    case 'DRIVER':
      return UserMode.driver;
    case 'OWNER':
      return UserMode.owner;

    case 'CLIENT':
      return UserMode.client;

    case 'GUEST':
      return UserMode.guest;

    default:
      return UserMode.guest;
  }
}

Future<bool> showCallOptions(BuildContext context,
    {required Future<bool> Function(String assignUserID) assign}) async {
  final data = await showModalBottomSheet<bool>(
    context: context,
    builder: (BuildContext context) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 50.0), // Добавляем отступы снизу
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ListTile(
          leading: const Icon(Icons.account_box_rounded),
          title: const Text('Назначить себе'),
          onTap: () async {
            AppDialogService.showLoadingDialog(context);
            final result = await assign(AppChangeNotifier().payload!.sub!);

            onSuccessDialog(result, context);
            context.pop(true);
            context.pop(true);
            context.pop(true);
          },
        ),
        ListTile(
          leading: const Icon(Icons.people_rounded),
          title: const Text('Назначить одному из моих водителей'),
          onTap: () async {
            final data =
                await showModalWithMyDrivers(context, assign: assign);
            if (context.mounted) {
              Navigator.pop(context, data);
            }
          },
        ),
      ],
    ),
  );
},

  );
  return data ?? false;
}

Future<bool> showModalWithMyDrivers(BuildContext context,
    {required Future<bool> Function(String assignUserID) assign}) async {
  final data = await showModalBottomSheet<bool>(
    isScrollControlled: true,
    context: context,
    builder: (BuildContext context) {
      return GlobalFutureBuilder(
        future: UserProfileApiClient()
            .getMyWorkers(AppChangeNotifier().payload!.sub!),
        buildWidget: (users) {
          final workerList = users;
          if (workerList == null || workerList.isEmpty) {
            return SizedBox(
              height: MediaQuery.of(context).size.height * 0.8,
              child: const Center(
                child: Text('Нет данных о водителей'),
              ),
            );
          }
          return SizedBox(
            height: MediaQuery.of(context).size.height * 0.8,
            child: Column(
              children: [
                ListTile(
                  leading: IconButton(
                    onPressed: () {
                      // Navigator.of(context).pop();
                      context.pop(true);
                    },
                    icon: const Icon(Icons.arrow_back),
                  ),
                  title: const Text('Ваши водители'),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: workerList.length,
                    itemBuilder: (BuildContext context, int index) {
                      final worker = workerList[index];
                      return GestureDetector(
                        onTap: () async {
                          AppDialogService.showLoadingDialog(context);
                          final result = await assign(worker.id.toString());

                          onSuccessDialog(result, context);
                          context.pop(true);
                          context.pop(true);
                          context.pop(true);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              Image.asset(
                                AppImages.profilePlaceholder,
                                width: 50,
                                height: 50,
                              ),
                              const SizedBox(width: 28),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    '${worker.firstName ?? ''} ${worker.lastName ?? ''}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall,
                                  ),
                                  Row(
                                    children: [
                                      Text(worker.phoneNumber ?? ''),
                                      const SizedBox(width: 28),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      );
    },
  );
  return data ?? false;
}

void onSuccessDialog(bool result, BuildContext context) {
  if (result) {
    AppDialogService.showSuccessDialog(context, title: 'Успешно отправлено',
        onPressed: () {
      context.pop();
      context.pop();
    }, buttonText: 'Назад');
  } else {
    AppDialogService.showNotValidFormDialog(context, 'Попробуйте позднее');
  }
}

void onAdTapAdListRowData(AllServiceTypeEnum selectedServiceType,
    BuildContext context, String id) async {
  if (selectedServiceType == AllServiceTypeEnum.MACHINARY) {
    await context.pushNamed(
      AppRouteNames.adSMDetail,
      extra: {'id': id},
    );
  } else if (selectedServiceType == AllServiceTypeEnum.EQUIPMENT) {
    await context.pushNamed(
      AppRouteNames.adEquipmentDetail,
      extra: {'id': id},
    );
  } else if (selectedServiceType == AllServiceTypeEnum.CM) {
    await context.pushNamed(
      AppRouteNames.adConstructionDetail,
      extra: {'id': id},
    );
  } else if (selectedServiceType == AllServiceTypeEnum.SVM) {
    await context.pushNamed(
      AppRouteNames.adServiceDetailScreen,
      extra: {'id': id},
    );
  } else if (selectedServiceType == AllServiceTypeEnum.MACHINARY_CLIENT) {
    await context.pushNamed(
      AppRouteNames.adSMClientDetail,
      extra: {'id': id},
    );
  } else if (selectedServiceType == AllServiceTypeEnum.EQUIPMENT_CLIENT) {
    await context.pushNamed(
      AppRouteNames.adEquipmentClientDetail,
      extra: {'id': id},
    );
  } else if (selectedServiceType == AllServiceTypeEnum.CM_CLIENT) {
    await context.pushNamed(
      AppRouteNames.adConstructionClientDetail,
      extra: {'id': id},
    );
  } else {
    await context.pushNamed(
      AppRouteNames.adServiceClientDetailScreen,
      extra: {'id': id},
    );
  }
}

String getPrice(String? price) {
  if (price == null ||
      price == 'null' ||
      double.parse(price) == 0 ||
      double.parse(price) == 2000) {
    return 'Договорная';
  } else {
    return '${(price)} тг/час';
  }
}

String getPriceWithHint(String? price) {
  if (price == null ||
      price == 'null' ||
      double.parse(price) == 0 ||
      double.parse(price) == 2000) {
    return 'Договорная';
  } else {
    return 'Цена: ${(price)} тг/час';
  }
}
