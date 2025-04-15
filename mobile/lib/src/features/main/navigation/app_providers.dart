// import 'package:eqshare_mobile/app/app_change_notifier.dart';
// import 'package:eqshare_mobile/app/app_safe_change_notifier.dart';
// import 'package:eqshare_mobile/src/core/data/repositories/user_recently_viewed_ads_repo.dart';
// import 'package:eqshare_mobile/src/core/domain/services/connectivity_service/connectivity_service.dart';
// import 'package:eqshare_mobile/src/core/presentation/services/user_mode_switcher.dart';
// import 'package:eqshare_mobile/src/features/ad/presentation/screens/ad_sm/all_ad_sm/ad_client_list/ad_client_list_controller.dart';
// import 'package:eqshare_mobile/src/features/ad/presentation/screens/ad_sm/all_ad_sm/ad_sm_list/ad_sm_list_controller.dart';
// import 'package:eqshare_mobile/src/features/home/home_controller.dart';
// import 'package:eqshare_mobile/src/features/main/navigation/navigation_controller.dart';
// import 'package:eqshare_mobile/src/global_widgets/global_values.dart';
// import 'package:provider/provider.dart';
// import 'package:provider/single_child_widget.dart';

// List<SingleChildWidget> appProviders() {
//   return [
//     ChangeNotifierProvider(create: (context) => AppSafeChangeNotifier()),
//     ChangeNotifierProvider(create: (context) => AppChangeNotifier()..init()),
//     ChangeNotifierProvider(
//       create: (context) => AdSMListController(
//         selectedServiceType: ServiceTypeEnum.MACHINARY,
//         userRecentlyViewedAdsRepo:
//             Provider.of<UserRecentlyViewedAdsRepo>(context, listen: false),
//       )..setupAds(),
//     ),
//     ChangeNotifierProvider(create: (context) => ProfileController()),
//     ChangeNotifierProvider(
//         create: (_) => AdClientListController(
//               selectedServiceType: ServiceTypeEnum.MACHINARY,
//             )..setupAds()),
//     ChangeNotifierProvider(create: (context) => HomeController()..setUp()),
//   ];
// }
