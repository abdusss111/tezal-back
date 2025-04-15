import 'package:eqshare_mobile/app/app_change_notifier.dart';
import 'package:eqshare_mobile/app/app_safe_change_notifier.dart';
import 'package:eqshare_mobile/src/core/data/repositories/user_recently_viewed_ads_repo.dart';
import 'package:eqshare_mobile/src/core/domain/services/connectivity_service/connectivity_service.dart';
import 'package:eqshare_mobile/src/core/presentation/services/user_mode_switcher.dart';
import 'package:eqshare_mobile/src/core/presentation/widgets/connectivy_check_screen/connectivy_check_controller.dart';
import 'package:eqshare_mobile/src/features/ad/presentation/screens/ad_sm/all_ad_sm/ad_client_list/ad_client_list_controller.dart';
import 'package:eqshare_mobile/src/features/ad/presentation/screens/ad_sm/all_ad_sm/ad_sm_list/ad_sm_list_controller.dart';
import 'package:eqshare_mobile/src/features/main/location/bloc/sm_list_map_bloc.dart';
import 'package:eqshare_mobile/src/features/main/location/sm_list_map_repository.dart';
import 'package:eqshare_mobile/src/features/main/navigation/navigation_controller.dart';
import 'package:eqshare_mobile/src/global_widgets/global_values.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../src/features/home/home_controller.dart';

List<SingleChildWidget> appProviders() {
  return [
    ChangeNotifierProvider(
      create: (_) => ConnectivityService(),
    ),
    ChangeNotifierProvider(
      create: (_) => AppSafeChangeNotifier(),
    ),
    ChangeNotifierProvider(
      create: (_) => AppChangeNotifier()..init(),
    ),
    ChangeNotifierProvider(
      create: (context) => NavigationScreenController(),
    ),
    ChangeNotifierProxyProvider<HomeController, AdSMListController>(
      create: (context) => AdSMListController(
        selectedServiceType: ServiceTypeEnum.MACHINARY,
        userRecentlyViewedAdsRepo: Provider.of<UserRecentlyViewedAdsRepo>(context, listen: false),
      ),
      update: (context, homeController, previousController) {
        final newCityId = homeController.selectedCity?.id ?? 5; // Получаем cityId

        if (previousController == null) {
          return AdSMListController(
            selectedServiceType: ServiceTypeEnum.MACHINARY,
            userRecentlyViewedAdsRepo: Provider.of<UserRecentlyViewedAdsRepo>(context, listen: false),
          )..setupAds(cityId: newCityId);
        } else {
          previousController.updateCityId(newCityId); // Вызываем setupAds()
          return previousController;
        }
      },
    ),

    ChangeNotifierProxyProvider<HomeController, AdClientListController>(
      create: (context) => AdClientListController(
        selectedServiceType: ServiceTypeEnum.MACHINARY,
      ),
      update: (context, homeController, previousController) {
        final cityId = homeController.selectedCity?.id ?? 5; // Получаем актуальный cityId

        if (previousController == null) {
          return AdClientListController(
            selectedServiceType: ServiceTypeEnum.MACHINARY,
          )..setupAds(cityId: cityId); // Загружаем объявления с cityId
        } else {
          previousController.updateCityId(cityId); // Обновляем при изменении города
          return previousController;
        }
      },
    ),

    ChangeNotifierProvider(
      create: (_) => ProfileController(),
    ),
    ChangeNotifierProvider(create: (_) => ConnectivityServiceController()),

    // BlocProvider(
    //   lazy: true, // Ensures initialization only when needed
    //   create: (context) {
    //     final homeController = context.read<HomeController>(); // Use read() to safely access HomeController
    //     return SmListMapBloc(
    //       smListMapRepository: SmListMapRepository(),
    //       homeController: homeController,
    //     )..add(FetchInitialData());
    //   },
    // ),
    BlocProvider(
      lazy: false,
      create: (context) => SmListMapBloc(
        smListMapRepository: SmListMapRepository(),
        homeController: Provider.of<HomeController>(context, listen: false),
      )..add(FetchInitialData()),

    ),
  ];
}
