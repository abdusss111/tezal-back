import 'package:eqshare_mobile/src/core/presentation/routing/app_route.dart';
import 'package:eqshare_mobile/src/core/presentation/widgets/get_core_widgets.dart';
import 'package:eqshare_mobile/src/core/res/app_images.dart';
import 'package:eqshare_mobile/src/features/ad/data/classes/ad_list_row_data.dart';
import 'package:eqshare_mobile/src/features/ad/presentation/widgets/app_ad_list_view_widget.dart';
import 'package:eqshare_mobile/src/features/main/profile/profile_page/profile_controller.dart';

import 'package:eqshare_mobile/src/features/main/user_screen/user_screen_controller.dart';
import 'package:eqshare_mobile/src/global_widgets/global_values.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class UserScreenForCountTab extends StatelessWidget {
  const UserScreenForCountTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<UserScreenController>(builder: (context, value, child) {
      if (value.isLoading) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Информация о пользователе'),
            leading: BackButton(),
          ),
          body: AppCircularProgressIndicator(),
        );
      } else {
        return ChangeNotifierProvider.value(
          value: Provider.of<UserScreenController>(context),
          child: UserScreen(tabBarCount: value.uniqueServiceTypes.length),
        );
      }
    });
  }
}

class UserScreen extends StatefulWidget {
  final int tabBarCount;
  const UserScreen({super.key, required this.tabBarCount});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen>
    with SingleTickerProviderStateMixin {
  late TabController tabBarController;
  @override
  initState() {
    super.initState();
    tabBarController = TabController(length: widget.tabBarCount, vsync: this);
  }

  Future<void> pushToPage(int id, AllServiceTypeEnum serviceTypeEnum) async {
    final map = {'id': id.toString()};
    switch (serviceTypeEnum) {
      case AllServiceTypeEnum.MACHINARY:
        context.pushNamed(AppRouteNames.adSMDetail, extra: map);
        break;

      case AllServiceTypeEnum.MACHINARY_CLIENT:
        context.pushNamed(AppRouteNames.adSMClientDetail, extra: map);
        break;

      case AllServiceTypeEnum.EQUIPMENT:
        context.pushNamed(AppRouteNames.adEquipmentDetail, extra: map);

        break;

      case AllServiceTypeEnum.EQUIPMENT_CLIENT:
        context.pushNamed(AppRouteNames.adEquipmentClientDetail, extra: map);

        break;

      case AllServiceTypeEnum.CM:
        context.pushNamed(AppRouteNames.adConstructionDetail, extra: map);

        break;

      case AllServiceTypeEnum.CM_CLIENT:
        context.pushNamed(AppRouteNames.adConstructionDetail, extra: map);

        break;

      case AllServiceTypeEnum.SVM:
        context.pushNamed(AppRouteNames.adServiceDetailScreen, extra: map);

        break;

      case AllServiceTypeEnum.SVM_CLIENT:
        context.pushNamed(AppRouteNames.adServiceClientDetailScreen,
            extra: map);

        break;

      default:
        context.pop();

        break;
    }
  }

  String getUserModeText(UserMode? userMode) {
    switch (userMode) {
      case UserMode.driver:
        return 'Водитель';
      case UserMode.owner:
        return 'Бизнес';
      default:
        return 'Клиент';
    }
  }

  Widget tabs(AllServiceTypeEnum allServiceTypeEnum) {
    return Tab(child: Text(getTypeFromAllServiceTypeEnum(allServiceTypeEnum)));
  }

  Widget listViewData(List<AdListRowData> list) {
    return ListView(
      children: list
          .map((e) => AppAdItem(
              onTap: () {
                if (e.id != null && e.allServiceTypeEnum != null) {
                  pushToPage(e.id!, e.allServiceTypeEnum!);
                }
              },
              adListRowData: e,
              imageBoxFit: BoxFit.contain))
          .toList(),
    );
  }

  Widget searchResultsList() {
    return Consumer<UserScreenController>(
      builder: (context, value, child) {
        return TabBarView(
          controller: tabBarController,
          children: value.uniqueServiceTypes.map((type) {
            final filteredData = _filterDataByType(value.userSm, type);
            return listViewData(filteredData);
          }).toList(),
        );
      },
    );
  }

  List<AdListRowData> _filterDataByType(
      List<AdListRowData> data, AllServiceTypeEnum type) {
    return data.where((e) => e.allServiceTypeEnum == type).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Информация о пользователя'),
        leading: BackButton(),
      ),
      body: Consumer<UserScreenController>(builder: (context, value, child) {
        if (value.isLoading) {
          return AppCircularProgressIndicator();
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            userInfoHeader(value, context),
            TabBar(
                isScrollable: value.uniqueServiceTypes.length > 2,
                tabAlignment: value.uniqueServiceTypes.length > 2
                    ? TabAlignment.start
                    : TabAlignment.fill,
                indicatorSize: TabBarIndicatorSize.tab,
                padding: EdgeInsets.zero,
                controller: tabBarController,
                tabs: value.uniqueServiceTypes
                    .map((type) => tabs(type))
                    .toList()),
            Expanded(child: searchResultsList())
          ],
        );
      }),
    );
  }

  SizedBox userInfoHeader(UserScreenController value, BuildContext context) {
    String userName =
        (value.user?.firstName ?? '') + (value.user?.lastName ?? '') != ''
            ? '${value.user?.firstName ?? ''} ${value.user?.lastName ?? ''}'
            : 'Неизвестный клиент';

    return SizedBox(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            height: 80,
            child: AppImageNetworkWidget(
              imageUrl: '${value.user?.urlImage}',
              width: 80,
              height: 80,
              key: UniqueKey(),
              imagePlaceholder: AppImages.profilePlaceholder,
            ),
          ),
          const SizedBox(width: 12),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                FittedBox(
                  child: Text(
                    userName,
                    style: Theme.of(context).textTheme.titleLarge,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
                const SizedBox(height: 8),
                Text('${value.user?.phoneNumber}',
                    style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
