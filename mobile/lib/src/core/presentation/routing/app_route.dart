import 'dart:developer';
import 'package:eqshare_mobile/src/core/presentation/widgets/app_circular_progress_indicator.dart';
import 'package:eqshare_mobile/src/features/ad/presentation/screens/ad_construction/ad_construction_create_screen/ad_construction_create_screen.dart';
import 'package:eqshare_mobile/src/features/ad/presentation/screens/ad_construction/ad_construction_create_screen/ad_construction_create_screen_controller.dart';
import 'package:eqshare_mobile/src/features/ad/presentation/screens/ad_construction/ad_construction_detail_screen.dart';
import 'package:eqshare_mobile/src/features/ad/presentation/screens/ad_construction/ad_construction_detail_screen_controller.dart';
import 'package:eqshare_mobile/src/features/ad/presentation/screens/ad_equipment/ad_equipment_create/ad_equipment_create_controller.dart';
import 'package:eqshare_mobile/src/features/ad/presentation/screens/ad_equipment/ad_equipment_create/ad_equipment_create_screen.dart';
import 'package:eqshare_mobile/src/features/ad/presentation/screens/ad_equipment/ad_equipment_list/ad_equipment_detail/ad_equipment_detail_controller.dart';
import 'package:eqshare_mobile/src/features/ad/presentation/screens/ad_equipment/ad_equipment_list/ad_equipment_detail/ad_equipment_detail_screen.dart';
import 'package:eqshare_mobile/src/features/ad/presentation/screens/ad_service/ad_service_main_screen.dart';

import 'package:eqshare_mobile/src/features/ad/presentation/screens/my_ad_screens/my_ad_equipment_list/my_ad_equipment_list_controller.dart';
import 'package:eqshare_mobile/src/features/ad/presentation/screens/my_ad_screens/my_ad_equipment_list/my_ad_equipment_list_screen.dart';
import 'package:eqshare_mobile/src/features/ad/presentation/screens/ad_equipment_client/ad_equipment_client_create/ad_equipment_client_create_controller.dart';
import 'package:eqshare_mobile/src/features/ad/presentation/screens/ad_equipment_client/ad_equipment_client_create/ad_equipment_client_create_screen.dart';
import 'package:eqshare_mobile/src/features/ad/presentation/screens/ad_equipment_client/ad_equipment_client_detail/ad_equipment_client_detail_controller.dart';
import 'package:eqshare_mobile/src/features/ad/presentation/screens/ad_equipment_client/ad_equipment_client_detail/ad_equipment_client_detail_screen.dart';
import 'package:eqshare_mobile/src/features/ad/presentation/screens/my_ad_screens/my_ad_equipment/my_ad_equipment_client_detail_controller.dart';
import 'package:eqshare_mobile/src/features/ad/presentation/screens/my_ad_screens/my_ad_equipment/my_ad_equipment_client_detail_screen.dart';

import 'package:eqshare_mobile/src/features/ad/presentation/screens/ad_service/ad_service_create_screen.dart';
import 'package:eqshare_mobile/src/features/ad/presentation/screens/ad_service/ad_service_create_screen_controller.dart';
import 'package:eqshare_mobile/src/features/ad/presentation/screens/ad_service/ad_service_detail_screen.dart';
import 'package:eqshare_mobile/src/features/ad/presentation/screens/ad_service/ad_service_detail_screen/ad_service_detail_screen_controller.dart';
import 'package:eqshare_mobile/src/features/ad/presentation/screens/ad_sm/all_ad_sm/ad_client_list/ad_client_list_screen.dart';
import 'package:eqshare_mobile/src/features/ad/presentation/screens/ad_sm/all_ad_sm/ad_sm_detail/ad_sm_detail_controller.dart';
import 'package:eqshare_mobile/src/features/ad/presentation/screens/ad_sm/all_ad_sm/ad_sm_detail/ad_sm_detail_screen.dart';
import 'package:eqshare_mobile/src/features/ad/presentation/screens/ad_sm/all_ad_sm/ad_sm_list/ad_sm_list_screen.dart';
import 'package:eqshare_mobile/src/features/ad/presentation/screens/ad_sm/my_ad_sm/ad_sm_create/ad_sm_create_controller.dart';
import 'package:eqshare_mobile/src/features/ad/presentation/screens/ad_sm/my_ad_sm/ad_sm_create/ad_sm_create_screen.dart';
import 'package:eqshare_mobile/src/features/ad/presentation/screens/ad_sm/my_ad_sm/ad_sm_create/ad_sm_parameters/ad_sm_parameters_controller.dart';
import 'package:eqshare_mobile/src/features/ad/presentation/screens/ad_sm/my_ad_sm/ad_sm_create/ad_sm_parameters/ad_sm_parameters_screen.dart';
import 'package:eqshare_mobile/src/features/ad/presentation/screens/my_ad_screens/my_ad_sm_list/my_ad_sm_list_controller.dart';
import 'package:eqshare_mobile/src/features/ad/presentation/screens/my_ad_screens/my_ad_sm_list/my_ad_sm_list_screen.dart';
import 'package:eqshare_mobile/src/features/ad/presentation/screens/ad_sm_client/my_ad_sm_client/ad_sm_client_create/ad_sm_client_create_controller.dart';
import 'package:eqshare_mobile/src/features/ad/presentation/screens/ad_sm_client/my_ad_sm_client/ad_sm_client_create/ad_sm_client_create_screen.dart';
import 'package:eqshare_mobile/src/features/ad/presentation/screens/ad_sm_client_business_create/ad_sm_client_create_business_controller.dart';
import 'package:eqshare_mobile/src/features/ad/presentation/screens/ad_sm_client_business_create/ad_sm_client_create_business_screen.dart';
import 'package:eqshare_mobile/src/features/ad/presentation/screens/favorite_ad_sm_list/presentation/favorite_ad_client_list_screen.dart';
import 'package:eqshare_mobile/src/features/ad/presentation/screens/favorite_ad_sm_list/presentation/favorite_ad_sm_list_screen.dart';
import 'package:eqshare_mobile/src/features/ad/presentation/screens/my_ad_screens/my_construction/my_ad_construction_controllers.dart';
import 'package:eqshare_mobile/src/features/ad/presentation/screens/my_ad_screens/my_construction/my_ad_construction_screen.dart';
import 'package:eqshare_mobile/src/features/ad/presentation/screens/my_ad_screens/my_construction/my_ad_contstruction_detail_screen.dart';
import 'package:eqshare_mobile/src/features/ad/presentation/screens/my_ad_screens/my_services/my_ad_service_detail.dart';
import 'package:eqshare_mobile/src/features/ad/presentation/screens/my_ad_screens/my_services/my_services_controller.dart';
import 'package:eqshare_mobile/src/features/ad/presentation/screens/my_ad_screens/my_services/my_services_screen.dart';
import 'package:eqshare_mobile/src/features/ad/presentation/screens/privacy_policy/privacy_policy_screen.dart';
import 'package:eqshare_mobile/src/features/ad/presentation/utils/create_ad_or_request_enum.dart';
import 'package:eqshare_mobile/src/features/auth/data/models/user_model/user_model.dart';
import 'package:eqshare_mobile/src/features/auth/presentation/screens/forgot_password_screens/forgot_password_phone_number_screens/forget_password_controller.dart';
import 'package:eqshare_mobile/src/features/auth/presentation/screens/forgot_password_screens/forgot_password_phone_number_screens/forgot_password_screen.dart';
import 'package:eqshare_mobile/src/features/auth/presentation/screens/forgot_password_screens/forgot_password_ented_email_code_screen/forgot_password_ented_email_code_screen.dart';
import 'package:eqshare_mobile/src/features/auth/presentation/screens/forgot_password_screens/forgot_password_ented_email_code_screen/forgot_password_ented_email_code_screen_controller.dart';
import 'package:eqshare_mobile/src/features/auth/presentation/screens/forgot_password_screens/forgot_password_pick_way_screen.dart';
import 'package:eqshare_mobile/src/features/auth/presentation/screens/forgot_password_screens/forgot_password_phone_number_screens/forgot_password_verification_screen.dart';

import 'package:eqshare_mobile/src/features/auth/presentation/screens/register/verification_phone_number_screen.dart';
import 'package:eqshare_mobile/src/features/global_search/widgets/search_results_screen/search_results_screen.dart';
import 'package:eqshare_mobile/src/features/global_search/widgets/search_results_screen/search_results_screen_controller.dart';
import 'package:eqshare_mobile/src/features/main/location/bloc/sm_list_map_bloc.dart';
import 'package:eqshare_mobile/src/features/main/location/google_map/google_map_screen_controller.dart';
import 'package:eqshare_mobile/src/features/main/location/google_map/google_navigation_screen/client_check_driver_navigation/client_check_driver_navigation.dart';
import 'package:eqshare_mobile/src/features/main/location/google_map/google_navigation_screen/client_check_driver_navigation/client_check_driver_navigation_controller.dart';
import 'package:eqshare_mobile/src/features/main/location/google_map/google_navigation_screen/google_navigation_screen.dart';
import 'package:eqshare_mobile/src/features/main/location/google_map/google_navigation_screen/google_navigation_screen_controller.dart';
import 'package:eqshare_mobile/src/features/main/location/google_map/google_navigation_workers_screen/google_navigation_workers_screen.dart';
import 'package:eqshare_mobile/src/features/main/location/google_map/google_navigation_workers_screen/google_navigation_workers_screen_controller.dart';
import 'package:eqshare_mobile/src/features/main/location/google_map/sample_map.dart';
import 'package:eqshare_mobile/src/features/main/location/new_client_location_screen.dart';
import 'package:eqshare_mobile/src/features/main/location/sm_list_in_map_screen.dart';
import 'package:eqshare_mobile/src/features/main/profile/change_or_update_password_screen/change_or_update_password_screen.dart';
import 'package:eqshare_mobile/src/features/main/profile/change_or_update_password_screen/change_or_update_password_screen_controller.dart';
import 'package:eqshare_mobile/src/features/main/profile/profile_setting_page.dart';
import 'package:eqshare_mobile/src/features/main/profile/subscribe_for_ads.dart';
import 'package:eqshare_mobile/src/features/main/profile/subscribe_for_ads_controller.dart';
import 'package:eqshare_mobile/src/features/main/user_screen/user_screen.dart';
import 'package:eqshare_mobile/src/features/main/user_screen/user_screen_controller.dart';
import 'package:eqshare_mobile/src/features/main/workers/my_workers/my_workers_list/my_workers_list_controller.dart';
import 'package:eqshare_mobile/src/features/main/workers/my_workers/my_workers_list/my_workers_list_screen.dart';
import 'package:eqshare_mobile/src/features/main/workers/my_workers/workers_list_search/workers_list_search.dart';
import 'package:eqshare_mobile/src/features/requests/data/repository/ad_constructions_request_repository.dart';
import 'package:eqshare_mobile/src/features/requests/data/repository/ad_service_request_repository.dart';
import 'package:eqshare_mobile/src/features/requests/presentation/construction_request_screens/ad_construction_request_client_detail_screen.dart';
import 'package:eqshare_mobile/src/features/requests/presentation/construction_request_screens/ad_construction_request_detail_screen.dart';
import 'package:eqshare_mobile/src/features/requests/presentation/construction_request_screens/construction_request_execution_detail_screen.dart';
import 'package:eqshare_mobile/src/features/requests/presentation/equipment_request_list/equipment_client_created/equipment_client_created_request_detail/equipment_client_created_request_detail_screen.dart';
import 'package:eqshare_mobile/src/features/requests/presentation/equipment_request_list/equipment_created/equipment_created_request_detail/equipment_created_request_detail_controller.dart';
import 'package:eqshare_mobile/src/features/requests/presentation/equipment_request_list/equipment_created/equipment_created_request_detail/equipment_created_request_detail_screen.dart';
import 'package:eqshare_mobile/src/features/requests/presentation/equipment_request_list/equipment_request_execution_detail_screen.dart';
import 'package:eqshare_mobile/src/features/requests/presentation/request_history/request_history_controller.dart';
import 'package:eqshare_mobile/src/features/requests/presentation/request_history/request_history_screen.dart';
import 'package:eqshare_mobile/src/features/requests/presentation/service_requests_screens/ad_service_request_client_detail_screen.dart';
import 'package:eqshare_mobile/src/features/requests/presentation/service_requests_screens/ad_service_request_detail_screen.dart';
import 'package:eqshare_mobile/src/features/requests/presentation/service_requests_screens/service_request_execution_detail_screen.dart';
import 'package:eqshare_mobile/src/features/requests/presentation/sm_request_list/sm_client_created/sm_client_created_request_detail/sm_client_created_request_detail_controller.dart';
import 'package:eqshare_mobile/src/features/requests/presentation/sm_request_list/sm_client_created/sm_client_created_request_detail/sm_client_created_request_detail_screen.dart';
import 'package:eqshare_mobile/src/features/requests/presentation/sm_request_list/sm_created/sm_created_request_detail/sm_created_request_detail_controller.dart';
import 'package:eqshare_mobile/src/features/requests/presentation/sm_request_list/sm_created/sm_created_request_detail/sm_created_request_detail_screen.dart';
import 'package:eqshare_mobile/src/features/requests/presentation/sm_request_list/sm_request_execution/sm_request_execution_detail/sm_request_execution_detail_controller.dart';
import 'package:eqshare_mobile/src/features/requests/presentation/sm_request_list/sm_request_execution/sm_request_execution_detail/sm_request_execution_detail_screen.dart';

import 'package:eqshare_mobile/src/features/main/profile/profile_page/profile_controller.dart';
import 'package:eqshare_mobile/src/global_widgets/global_values.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../../../../main.dart';
import '../../../features/ad/presentation/screens/ad_sm/my_ad_sm/my_ad_sm_detail/my_ad_sm_detail_controller.dart';
import '../../../features/ad/presentation/screens/ad_sm/my_ad_sm/my_ad_sm_detail/my_ad_sm_detail_screen.dart';
import '../../../features/ad/presentation/screens/ad_sm_client/all_ad_sm_client/ad_sm_client_detail/ad_sm_client_detail_controller.dart';
import '../../../features/ad/presentation/screens/ad_sm_client/all_ad_sm_client/ad_sm_client_detail/ad_sm_client_detail_screen.dart';
import '../../../features/ad/presentation/screens/ad_sm_client/my_ad_sm_client/my_ad_sm_client_detail/my_ad_sm_client_detail_controller.dart';
import '../../../features/ad/presentation/screens/ad_sm_client/my_ad_sm_client/my_ad_sm_client_detail/my_ad_sm_client_detail_screen.dart';
import '../../../features/auth/presentation/auth.dart';
import '../../../features/main/navigation/navigation_controller.dart';
import '../../../features/main/navigation/navigation_screen.dart';
import '../widgets/connectivity_check_widget.dart';

abstract class AppRouteNames {
  static const adConstructionDetailFromFavoClient =
      'ad_construction_detail_from_favo_client';
  static const adConstructionDetailFromFavo =
      'ad_construction_detail_from_favo';

  static const adSMClientDetailFromMyClientAd =
      'ad_sm_client_detail_from_my_client_ad';

  static const adEquipmentClientDetailFromFavo =
      'ad_equipment_client_detail_from_favo';
  static const adEquipmentClientDetailFromClientFavo =
      'ad_equipment_client_detail_from_client_favo';

  // static const myAdEquipmentClientList = 'my_ad_eqipment_client_list';
  static const adSMMapList = 'ad_sm_map_list';

  static const adServiceDetailScreenFromFavoClient =
      'ad_service_list_detail_from_favo_client';
  static const adServiceDetailScreenFromFavo =
      'ad_service_list_detail_from_favo';

  static const noneInternet = 'none_internet';

  // MAIN SCREEN
  static const navigation = 'navigation_screen';
  static const adSMList = 'ad_sm_list';
  static const adSMClientList = 'ad_sm_client';
  // MAIN SCREEN
  //**
  //##########################//##########################//##########################
  //*/
  // Ads List routes and ads detail routes
  static const adEquipmentList = 'ad_equipment_list';
  static const adConstructionList = 'ad_construction_list';
  static const adConstructionClientList = 'ad_construction_client_list';
  static const adServiceList = 'ad_service_list';
  static const adServiceClientList = 'ad_service_client_list';

  static const adSMDetail = 'ad_sm_detail';
  static const adSMClientDetail = 'ad_sm_client_detail';

  static const adEquipmentDetail = 'ad_equipment_detail';
  static const adEquipmentClientDetail = 'ad_equipment_client_detail';

  static const adConstructionDetail = 'ad_construction_detail';
  static const adConstructionClientDetail = 'ad_construction_client_detail';
  static const adServiceDetailScreen = 'ad_service_list_detail';
  static const adServiceClientDetailScreen = 'ad_service_detail_list_detail';
  static const adEquipmentClientList = 'ad_equipment_client_list';
  static const adEquipmentRequestAdd = 'equipment_request_ad_equipment';
  static const adEquipmentForBuisness = 'ad_equipment_for_buisness';

  // Ads List routes and ads detail routes
  //**
  //##########################//##########################//##########################
  //*/
  // My ads routes
  static const adSMClientDetailFromMyAd = 'ad_sm_client_detail_from_my_ad';
  static const myAdSMDetail = 'my_ad_sm_detail';
  static const myAdEquipmentDetail = 'my_ad_equipment_detail';
  static const myAdSMClientDetail = 'my_ad_sm_client_detail';
  static const myAdEquipmentClientDetail = 'my_ad_equipment_client_detail';
  static const adEquipmentForBuisnessFromMyAds =
      'ad_equipment_for_buisness_create_from_my_ads';
  // My ads routes
  //**
  //##########################//##########################//##########################
  //*/
  // Login and registration

  static const login = 'login';
  static const registerPhone = 'register_phone';

  static const citySelect = 'register_city_select';
  static const vefirication = 'register_vefirication';

  static const forgotPasswordEnterPhoneNumber = 'enter_phone_number';
  static const forgotPasswordEnterSendCode = 'enter_send_code';
  static const forgotPasswordEnterSendCodeFromEmail =
      'enter_send_code_from_email';
  static const forgotPasswordPickWayScreen = 'forgot_password_pick_way_screen';
  static const registerPassword = 'password';
  static const authOtpForm = 'auth_otp_form';
  static const registerOtpForm = 'register_otp_form';
  // Login and registration
  //**
  //##########################//##########################//##########################
  //*/
  //Profile screen routes
  static const myAdServices = 'my_ad_services';
  static const myAdServicesDetail = 'my_ad_services_detail';
  static const myAdConstruction = 'myAdConstruction';
  static const myAdConstructionDetail = 'myAdConstrutionDetail';
  static const favoriteAdsForClient = 'favorite_ads_for_client';
  static const favoriteAdsForDriverOrOwner = 'favorite_ads_for_driver_or_owner';
  static const notificationList = 'notification_list';
  static const myWorkersList = 'my_workers_list';
  static const myWorker = 'my_worker';
  static const myWorkersListSearch = 'my_workers_list_search';
  static const myWorkersOnMap = 'my_workers_on_map';
  static const myAdSMList = 'my_ad_sm_list';
  static const myAdEquipmentList = 'my_ad_equipment_list';
  static const profileSettings = 'profile_settings';
  static const subscribeForAds = 'subscribe_for_ads';
  static const updateOrChangePassword = 'update_or_change_password';
  static const privacyPolicy = 'privacy_policy';

  //Profile screen routes
  //**
  //##########################//##########################//##########################
  //*/
  //Request execution routes
  static const adConstructionRequesExecutiontDetailScreen =
      'ad_construction_request_execution_detail_screen';
  static const adServiceRequesExecutiontDetailScreen =
      'ad_sevice_request_execution_detail_screen';
  static const adEquipmentRequestDetail = 'ad_equipment_request_detail';
  static const requestExecutionDetailSM = 'request_execution_detail_sm';
  static const monitorDriveFromNavigationScreen =
      'monitor_driver_from_navigation_screen';
  static const requestExecutionDetail = 'request_execution_detail';

  static const requestHistory = 'request_history';
  //Request execution routes
  //**
  //##########################//##########################//##########################
  //*/
  //Request ads routes
  static const adServiceRequestDetailScreen = 'ad_service_request_detail_creen';
  static const adServiceClientRequestDetailScreen =
      'ad_service_client_request_detail_creen';
  static const equipmentCreatedRequestDetail =
      'equipment_created_request_detail';
  static const equipmentCreatedClientRequestDetail =
      'equipment_created_client_request_detail';
  static const smCreatedRequestDetail = 'sm_created_request_detail';
  static const smClientCreatedRequestDetail = 'client_created_request_detail';
  static const adConstructionRequestDetailScreen =
      'ad_construction_request_detail_screen';
  static const adConstructionRequesClientDetailScreen =
      'ad_construction_request_client_detail_screen';
  //Request ads routes
  //**
  //##########################//##########################//##########################
  //*/

  // Create ads
  static const createAdEquipmentForDriverOrOwner =
      'ad_equipment_create_screen_for_driver_or_owner';
  static const createAdEquipmentForClient =
      'ad_equipment_create_screen_for_client';
  static const adSMParameters = 'ad_sm_parameters';
  static const adSMParametersFromMyAds = 'ad_sm_parameters_from_my_ads';
  static const createAdSMForDriverOrOwner =
      'ad_sm_create_screen_for_driver_or_owner';

  static const createAdSMForDriverOrOwnerFromMyADs =
      'ad_sm_create_screen_for_driver_or_owner_from_my_ads';
  static const createAdSMForClient = 'ad_sm_create_screen_for_client';

  static const createAdWithoutType = 'create_ad_without_type';
  static const createAdService = 'create_ad_service';
  static const createAdConstructions = 'create_ad_construction';

  // Create ads

  //search results
  static const searchResult = 'search';
  //user screen
  static const userScreen = 'user_screen';

  static const googleNavigationScreen = 'google_navigation_screen';
  static const clientGoogleNavigationScreen = 'client_google_navigation_screen';
}

final GoRouter router = GoRouter(
    debugLogDiagnostics: true,
    initialLocation: '/${AppRouteNames.navigation}',
    routes: [
      GoRoute(
          path: '/${AppRouteNames.navigation}',
          name: AppRouteNames.navigation,
          builder: (context, state) {
            final arguments = (state.extra ?? <String, dynamic>{}) as Map;
            final index = arguments['index'];
            final indexValue = int.tryParse(index ?? '0') ?? 0;

            final currentIndex = indexValue > 4 ? 0 : indexValue;
            return ConnectivityCheckWidget(
              connectedWidget: ChangeNotifierProvider(
                create: (_) => Provider.of<NavigationScreenController>(context),
                child: NavigationScreen(initialIndex: currentIndex),
              ),
            );
          },
          routes: [
            GoRoute(
              path: '${AppRouteNames.searchResult}/:slug',
              name: AppRouteNames.searchResult,
              builder: (context, state) {
                final arguments = (state.extra ?? <String, dynamic>{}) as Map;
                final index = arguments['id'];
                final selectedServiceType = arguments['value'] ?? '';
                final slug = state.pathParameters['slug'];
                final searchText = slug;
                return ConnectivityCheckWidget(
                    connectedWidget: ChangeNotifierProvider(
                  create: (context) => SearchResultsScreenController(
                      pickedId: int.parse(index.toString()),
                      serviceTypeEnum: getAllServiceTypeEnumEnumFromName(
                          selectedServiceType),
                      searchText: searchText ?? ''),
                  child: SearchResultsScreenForTabs(),
                ));
              },
            ),

            GoRoute(
              path: AppRouteNames.clientGoogleNavigationScreen,
              name: AppRouteNames.clientGoogleNavigationScreen,
              pageBuilder: (context, state) {
                final arguments = (state.extra ?? <String, dynamic>{}) as Map;
                final index = arguments['id'] as String? ?? '';
                final lat = arguments['lat'] as double;
                final lon = arguments['lon'] as double;

                return CustomTransitionPage(
                  key: state.pageKey,
                  child: ChangeNotifierProvider(
                    create: (context) => ClientCheckDriverNavigationController(
                        currentReID: index, destinationGeo: LatLng(lat, lon)),
                    child: ClientCheckDriverNavigation(),
                  ),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    return FadeTransition(opacity: animation, child: child);
                  },
                );
              },
            ),

            // показывает водителей для бизнеса
            GoRoute(
              path: AppRouteNames.myWorkersOnMap,
              name: AppRouteNames.myWorkersOnMap,
              pageBuilder: (context, state) {
                try {
                  final arguments = (state.extra ?? <String, dynamic>{}) as Map;
                  final index = arguments['id'] as String? ?? '';
                  final lat = (arguments['lat'] is double)
                      ? arguments['lat'] as double
                      : 43.2220;
                  final lon = (arguments['lon'] is double)
                      ? arguments['lon'] as double
                      : 76.8512;
                  final workerId = arguments['workerId'] as String? ?? '';
                  log('workerId');
                  log(workerId);

                  return CustomTransitionPage(
                    key: state.pageKey,
                    child: ChangeNotifierProvider(
                      create: (context) =>
                          GoogleNavigationWorkersScreenController(
                              currentReID: index,
                              destinationGeo: LatLng(lat, lon),
                              workerId: workerId),
                      // workerId: workerId
                      child: GoogleNavigationWorkersScreen(),
                    ),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      return FadeTransition(opacity: animation, child: child);
                    },
                  );
                } catch (e) {
                  log('Error in pageBuilder: $e');
                  final arguments = (state.extra ?? <String, dynamic>{}) as Map;
                  final index = arguments['id'] as String? ?? '';
                  final lat = (arguments['lat'] is double)
                      ? arguments['lat'] as double
                      : 0.0;
                  final lon = (arguments['lon'] is double)
                      ? arguments['lon'] as double
                      : 0.0;
                  final workerId = arguments['id'] as String? ?? '';
                  return CustomTransitionPage(
                    key: state.pageKey,
                    child: ChangeNotifierProvider(
                      create: (context) =>
                          GoogleNavigationWorkersScreenController(
                              currentReID: index,
                              destinationGeo: LatLng(lat, lon),
                              workerId: workerId),
                      child: GoogleNavigationWorkersScreen(),
                    ),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      return FadeTransition(opacity: animation, child: child);
                    },
                  );
                }
              },
            ),

            GoRoute(
              path: '${AppRouteNames.userScreen}/:slug',
              name: AppRouteNames.userScreen,
              builder: (context, state) {
                final slug = state.pathParameters['slug'];
                final userId = slug ?? '0';

                return ConnectivityCheckWidget(
                    connectedWidget: ChangeNotifierProvider(
                  create: (context) => UserScreenController(
                    userID: userId,
                  ),
                  child: UserScreenForCountTab(),
                ));
              },
            ),
            // GoRoute(
            //   path: AppRouteNames.noneInternet,
            //   name: AppRouteNames.noneInternet,
            //   builder: (context, state) {

            //     return  ConnectionNoneScreen(onRetry: (){
            //       context.pushNamed()
            //     });
            //   }),
            loginRoutes(),
            GoRoute(
                path: AppRouteNames.smCreatedRequestDetail,
                name: AppRouteNames.smCreatedRequestDetail,
                builder: (context, state) {
                  final map = state.extra as Map<String, dynamic>;

                  final id = map['id'];
                  return ConnectivityCheckWidget(
                    connectedWidget: ChangeNotifierProvider(
                      create: (context) =>
                          SMCreatedRequestDetailController(id.toString()),
                      child: SMCreatedRequestDetailScreen(
                        requestId: id.toString(),
                      ),
                    ),
                  );
                }),
            GoRoute(
                path: AppRouteNames.smClientCreatedRequestDetail,
                name: AppRouteNames.smClientCreatedRequestDetail,
                builder: (context, state) {
                  final map = state.extra as Map<String, dynamic>;
                  final id = map['id'];
                  return ConnectivityCheckWidget(
                    connectedWidget: ChangeNotifierProvider(
                      create: (context) =>
                          SMClientCreatedRequestDetailController(id.toString()),
                      child: SMClientCreatedRequestDetailScreen(
                        adId: id.toString(),
                      ),
                    ),
                  );
                }),
            GoRoute(
              path: AppRouteNames.monitorDriveFromNavigationScreen,
              name: AppRouteNames.monitorDriveFromNavigationScreen,
              builder: (context, state) {
                final arguments = (state.extra ?? <String, dynamic>{}) as Map;
                final id = arguments['id'] as int? ?? 0;
                return ConnectivityCheckWidget(
                  connectedWidget: NewClientLocationScreen(requestID: id),
                );
              },
            ),
            GoRoute(
              path: AppRouteNames.equipmentCreatedClientRequestDetail,
              name: AppRouteNames.equipmentCreatedClientRequestDetail,
              builder: (context, state) {
                final arguments = (state.extra ?? <String, dynamic>{}) as Map;

                final id = arguments['id'] as String;
                return ConnectivityCheckWidget(
                    connectedWidget: EquipmentClientCreatedRequestDetailScreen(
                  adId: id,
                ));
              },
            ),
            GoRoute(
                path: AppRouteNames.adSMList,
                name: AppRouteNames.adSMList,
                builder: (context, state) {
                  final arguments = (state.extra ?? <String, dynamic>{}) as Map;
                  final subCategoryId = arguments['subCategoryId'];
                  final subCategoryName = arguments['subCategoryName'];
                  final typeId = arguments['typeId'];
                  final typeName = arguments['typeName'];
                  final selectedServiceType = arguments['selectedServiceType'];
                  return ConnectivityCheckWidget(
                    connectedWidget: AdSMListScreen(
                      subCategoryId: subCategoryId,
                      subCategoryName: subCategoryName,
                      typeId: typeId,
                      typeName: typeName,
                      showAdditionalAdWidget: false,
                      selectedServiceType: selectedServiceType,
                    ),
                  );
                },
                routes: [
                  GoRoute(
                    path: AppRouteNames.adSMDetail,
                    name: AppRouteNames.adSMDetail,
                    builder: (context, state) {
                      final uri = Uri.parse(state.uri.toString());
                      final adIdFromURL = uri.queryParameters['id'];
                      final arguments =
                          (state.extra ?? <String, dynamic>{}) as Map;
                      final adIdFromArgs = arguments['id'];
                      final adId = adIdFromURL ?? adIdFromArgs;
                      return ConnectivityCheckWidget(
                        connectedWidget: ChangeNotifierProvider(
                          create: (_) => AdSMDetailController(adId),
                          child: AdSMDetailScreen(adId: adId),
                        ),
                      );
                    },
                  ),
                ]),
            GoRoute(
                path: AppRouteNames.adEquipmentList,
                name: AppRouteNames.adEquipmentList,
                builder: (context, state) {
                  final arguments = (state.extra ?? <String, dynamic>{}) as Map;
                  final subCategoryId = arguments['subCategoryId'];
                  final subCategoryName = arguments['subCategoryName'];
                  final typeId = arguments['typeId'];
                  final typeName = arguments['typeName'];
                  final selectedServiceType = arguments['selectedServiceType'];

                  return ConnectivityCheckWidget(
                    connectedWidget: AdSMListScreen(
                      subCategoryId: subCategoryId,
                      subCategoryName: subCategoryName,
                      typeId: typeId,
                      typeName: typeName,
                      showAdditionalAdWidget: false,
                      selectedServiceType: selectedServiceType,
                    ),
                  );
                },
                routes: [
                  GoRoute(
                      path: AppRouteNames.adEquipmentDetail,
                      name: AppRouteNames.adEquipmentDetail,
                      builder: (context, state) {
                        final uri = Uri.parse(state.uri.toString());
                        final adIdFromURL = uri.queryParameters['id'];
                        final arguments =
                            (state.extra ?? <String, dynamic>{}) as Map;
                        final adIdFromArgs = arguments['id'];
                        final adId = adIdFromURL ?? adIdFromArgs;

                        return ConnectivityCheckWidget(
                            connectedWidget: ChangeNotifierProvider(
                                create: (_) =>
                                    AdEquipmentDetailController(adId),
                                child: AdEquipmentDetailScreen(adId: adId)));
                      }),
                ]),
            GoRoute(
                path: AppRouteNames.adSMClientList,
                name: AppRouteNames.adSMClientList,
                builder: (context, state) {
                  final arguments = (state.extra ?? <String, dynamic>{}) as Map;
                  final subCategoryId = arguments['subCategoryId'];
                  final subCategoryName = arguments['subCategoryName'];
                  final typeId = arguments['typeId'];
                  final typeName = arguments['typeName'];
                  final selectedServiceType = arguments['selectedServiceType'];

                  return ConnectivityCheckWidget(
                      connectedWidget: AdClientListScreen(
                    subCategoryId: subCategoryId,
                    showAdditionalAdWidget: false,
                    subCategoryName: subCategoryName,
                    typeId: typeId,
                    typeName: null,
                    selectedServiceType: selectedServiceType,
                  ));
                },
                routes: [
                  GoRoute(
                    path: AppRouteNames.adSMClientDetail,
                    name: AppRouteNames.adSMClientDetail,
                    builder: (context, state) {
                      final uri = Uri.parse(state.uri.toString());
                      final adIdFromURL = uri.queryParameters['id'];
                      final arguments =
                          (state.extra ?? <String, dynamic>{}) as Map;
                      final adIdFromArgs = arguments['id'];
                      final adId = adIdFromURL ?? adIdFromArgs;

                      return ConnectivityCheckWidget(
                        connectedWidget: ChangeNotifierProvider(
                          create: (_) => AdSMClientDetailController(adId),
                          child: AdSMClientDetailScreen(adId: adId),
                        ),
                      );
                    },
                  ),
                ]),
            GoRoute(
              path: AppRouteNames.adConstructionRequestDetailScreen,
              name: AppRouteNames.adConstructionRequestDetailScreen,
              builder: (context, state) {
                final arguments = (state.extra ?? <String, dynamic>{}) as Map;
                final id = arguments['id'] as String;
                return ConnectivityCheckWidget(
                    connectedWidget: AdConstructionRequestDetailScreen(
                        requestId: id,
                        adConstructionsRequestRepository:
                            AdConstructionsRequestRepository()));
              },
            ),
            GoRoute(
              path: AppRouteNames.adConstructionRequesClientDetailScreen,
              name: AppRouteNames.adConstructionRequesClientDetailScreen,
              builder: (context, state) {
                final arguments = (state.extra ?? <String, dynamic>{}) as Map;
                final id = arguments['id'] as String;
                return ConnectivityCheckWidget(
                    connectedWidget: AdConstructionRequestClientDetailScreen(
                        requestId: id,
                        adConstructionsRequestRepository:
                            AdConstructionsRequestRepository()));
              },
            ),
            GoRoute(
              path: AppRouteNames.adConstructionRequesExecutiontDetailScreen,
              name: AppRouteNames.adConstructionRequesExecutiontDetailScreen,
              builder: (context, state) {
                final arguments = (state.extra ?? <String, dynamic>{}) as Map;
                final id = arguments['id'];
                return ConnectivityCheckWidget(
                    connectedWidget: ConstructionRequestExecutionDetailScreen(
                        requestId: (id)));
              },
            ),
            GoRoute(
              path: AppRouteNames.adServiceRequestDetailScreen,
              name: AppRouteNames.adServiceRequestDetailScreen,
              builder: (context, state) {
                final arguments = (state.extra ?? <String, dynamic>{}) as Map;
                final id = arguments['id'];
                return ConnectivityCheckWidget(
                    connectedWidget: AdServiceRequestDetailScreen(
                        requestID: id,
                        adServiceRequestRepository:
                            AdServiceRequestRepository()));
              },
            ),
            GoRoute(
              path: AppRouteNames.adServiceClientRequestDetailScreen,
              name: AppRouteNames.adServiceClientRequestDetailScreen,
              builder: (context, state) {
                final arguments = (state.extra ?? <String, dynamic>{}) as Map;
                final id = arguments['id'];
                return ConnectivityCheckWidget(
                    connectedWidget: AdServiceRequestClientDetailScreen(
                        requestID: id,
                        adServiceRequestRepository:
                            AdServiceRequestRepository()));
              },
            ),
            GoRoute(
                path: AppRouteNames.adConstructionClientList,
                name: AppRouteNames.adConstructionClientList,
                builder: (context, state) {
                  final arguments = (state.extra ?? <String, dynamic>{}) as Map;
                  final subCategoryId = arguments['subCategoryId'];
                  final subCategoryName = arguments['subCategoryName'];
                  final typeId = arguments['typeId'];
                  // final typeName = arguments['selectedServiceType'];
                  final selectedServiceType = arguments['selectedServiceType'];
                  return ConnectivityCheckWidget(
                      connectedWidget: AdClientListScreen(
                    subCategoryId: subCategoryId,
                    subCategoryName: subCategoryName,
                    showAdditionalAdWidget: false,
                    typeId: typeId,
                    typeName: null,
                    selectedServiceType: selectedServiceType,
                  ));
                },
                routes: [
                  GoRoute(
                    path: AppRouteNames.adConstructionClientDetail,
                    name: AppRouteNames.adConstructionClientDetail,
                    builder: (context, state) {
                      final uri = Uri.parse(state.uri.toString());
                      final adIdFromURL = uri.queryParameters['id'];
                      final arguments =
                          (state.extra ?? <String, dynamic>{}) as Map;
                      final adId = adIdFromURL ?? arguments['id'];

                      return ConnectivityCheckWidget(
                          connectedWidget: ChangeNotifierProvider(
                              create: (context) =>
                                  AdConstructionDetailScreenController(
                                      adID: adId),
                              child: AdConstructionDetailScreen(id: adId)));
                    },
                  ),
                ]),
            GoRoute(
                path: AppRouteNames.adConstructionList,
                name: AppRouteNames.adConstructionList,
                builder: (context, state) {
                  final arguments = (state.extra ?? <String, dynamic>{}) as Map;
                  final subCategoryId = arguments['subCategoryId'];
                  final subCategoryName = arguments['subCategoryName'];
                  final typeId = arguments['typeId'];
                  final typeName = arguments['typeName'];
                  final selectedServiceType = arguments['selectedServiceType'];

                  return ConnectivityCheckWidget(
                    connectedWidget: AdSMListScreen(
                      subCategoryId: subCategoryId,
                      subCategoryName: subCategoryName,
                      typeId: typeId,
                      showAdditionalAdWidget: false,
                      typeName: typeName,
                      selectedServiceType: selectedServiceType,
                    ),
                  );
                },
                routes: [
                  GoRoute(
                    path: AppRouteNames.adConstructionDetail,
                    name: AppRouteNames.adConstructionDetail,
                    builder: (context, state) {
                      final uri = Uri.parse(state.uri.toString());
                      final adIdFromURL = uri.queryParameters['id'];
                      final arguments =
                          (state.extra ?? <String, dynamic>{}) as Map;
                      final adId = adIdFromURL ?? arguments['id'];

                      return ConnectivityCheckWidget(
                          connectedWidget: ChangeNotifierProvider(
                              create: (context) =>
                                  AdConstructionDetailScreenController(
                                      adID: adId),
                              child: AdConstructionDetailScreen(id: adId)));
                    },
                  ),
                ]),
            GoRoute(
                path: AppRouteNames.adServiceClientList,
                name: AppRouteNames.adServiceClientList,
                builder: (context, state) {
                  final arguments = (state.extra ?? <String, dynamic>{}) as Map;
                  final subCategoryId = arguments['subCategoryId'];
                  final subCategoryName = arguments['subCategoryName'];
                  final typeId = arguments['typeId'];
                  // final typeName = arguments['selectedServiceType'];
                  final selectedServiceType = arguments['selectedServiceType'];
                  return ConnectivityCheckWidget(
                      connectedWidget: AdClientListScreen(
                    subCategoryId: subCategoryId,
                    subCategoryName: subCategoryName,
                    showAdditionalAdWidget: false,
                    typeId: typeId,
                    typeName: null,
                    selectedServiceType: selectedServiceType,
                  ));
                },
                routes: [
                  GoRoute(
                    path: AppRouteNames.adServiceClientDetailScreen,
                    name: AppRouteNames.adServiceClientDetailScreen,
                    builder: (context, state) {
                      final uri = Uri.parse(state.uri.toString());
                      final adIdFromURL = uri.queryParameters['id'];
                      final arguments =
                          (state.extra ?? <String, dynamic>{}) as Map;
                      final adId = adIdFromURL ?? arguments['id'];

                      return ConnectivityCheckWidget(
                          connectedWidget: ChangeNotifierProvider(
                              create: (context) =>
                                  AdServiceDetailScreenController(adID: adId),
                              child: AdServiceDetailScreen(id: adId)));
                    },
                  ),
                ]),
            GoRoute(
                path: AppRouteNames.adServiceList,
                name: AppRouteNames.adServiceList,
                builder: (context, state) {
                  final arguments = (state.extra ?? <String, dynamic>{}) as Map;
                  final subCategoryId = arguments['subCategoryId'];
                  final subCategoryName = arguments['subCategoryName'];
                  final typeId = arguments['typeId'];
                  final typeName = arguments['typeName'];
                  final selectedServiceType = arguments['selectedServiceType'];

                  return ConnectivityCheckWidget(
                    connectedWidget: AdServiceMainScreen(
                     
                    ),
                  );
                },
                routes: [
                  GoRoute(
                      path: AppRouteNames.adServiceDetailScreen,
                      name: AppRouteNames.adServiceDetailScreen,
                      builder: (context, state) {
                        final uri = Uri.parse(state.uri.toString());
                        final uriID = uri.queryParameters['id'];

                        final data =
                            (state.extra ?? <String, dynamic>{}) as Map;

                        final id = uriID ?? data['id'] as String;
                        return ConnectivityCheckWidget(
                            connectedWidget: ChangeNotifierProvider(
                                create: (context) =>
                                    AdServiceDetailScreenController(adID: id),
                                child: AdServiceDetailScreen(id: id)));
                      })
                ]),
            GoRoute(
                path: AppRouteNames.myAdServices,
                name: AppRouteNames.myAdServices,
                builder: (context, state) {
                  return ConnectivityCheckWidget(
                    connectedWidget: ChangeNotifierProvider(
                      create: (_) => MyServicesController(),
                      child: const MyServicesScreen(),
                    ),
                  );
                },
                routes: [
                  GoRoute(
                      path: AppRouteNames.myAdServicesDetail,
                      name: AppRouteNames.myAdServicesDetail,
                      builder: (context, state) {
                        final uri = Uri.parse(state.uri.toString());
                        final uriID = uri.queryParameters['id'];
                        final Map<String, dynamic> data =
                            state.extra as Map<String, dynamic>;
                        final id = uriID ?? data['id'] as String;
                        final createAdOrRequestEnum = data['enum'] as String;
                        return ConnectivityCheckWidget(
                            connectedWidget: MyAdServiceDetailScreen(
                                adID: id,
                                createAdOrRequestEnum: createAdOrRequestEnum));
                      }),
                ]),
            GoRoute(
                path: AppRouteNames.adEquipmentClientList,
                name: AppRouteNames.adEquipmentClientList,
                builder: (context, state) {
                  final arguments = (state.extra ?? <String, dynamic>{}) as Map;
                  final subCategoryId = arguments['subCategoryId'];
                  final subCategoryName = arguments['subCategoryName'];
                  final typeId = arguments['typeId'];
                  final typeName = arguments['selectedServiceType'];

                  return ConnectivityCheckWidget(
                    connectedWidget: AdClientListScreen(
                      subCategoryId: subCategoryId,
                      subCategoryName: subCategoryName,
                      showAdditionalAdWidget: false,
                      typeId: typeId,
                      typeName: null,
                      selectedServiceType: typeName,
                    ),
                  );
                },
                routes: [
                  GoRoute(
                    path: AppRouteNames.adEquipmentClientDetail,
                    name: AppRouteNames.adEquipmentClientDetail,
                    builder: (context, state) {
                      final uri = Uri.parse(state.uri.toString());
                      final adIdFromURL = uri.queryParameters['id'];
                      final arguments =
                          (state.extra ?? <String, dynamic>{}) as Map;
                      final adIdFromArgs = arguments['id'];
                      final adId = adIdFromURL ?? adIdFromArgs;

                      return ConnectivityCheckWidget(
                          connectedWidget: ChangeNotifierProvider(
                              create: (_) =>
                                  AdEquipmentClientDetailController(adId),
                              child:
                                  AdEquipmentClientDetailScreen(adId: adId)));
                    },
                  ),
                ]),
            adEquipmentForBuisnessRoute(AppRouteNames.adEquipmentForBuisness),
            GoRoute(
                path: AppRouteNames.createAdEquipmentForDriverOrOwner,
                name: AppRouteNames.createAdEquipmentForDriverOrOwner,
                builder: (context, state) {
                  return ConnectivityCheckWidget(
                    connectedWidget: ChangeNotifierProvider(
                      create: (_) => AdEquipmentCreateController(),
                      lazy: false,
                      child: const AdEquipmentCreateScreen(),
                    ),
                  );
                }),
            GoRoute(
                path: AppRouteNames.createAdEquipmentForClient,
                name: AppRouteNames.createAdEquipmentForClient,
                builder: (context, state) {
                  return ConnectivityCheckWidget(
                    connectedWidget: ChangeNotifierProvider(
                        create: (_) => AdEquipmentClientCreateController(),
                        lazy: false,
                        child: const AdEquipmentClientCreateScreen()),
                  );
                }),
            GoRoute(
                path: AppRouteNames.createAdSMForClient,
                name: AppRouteNames.createAdSMForClient,
                builder: (context, state) {
                  return ConnectivityCheckWidget(
                    connectedWidget: ChangeNotifierProvider(
                      create: (_) => AdSMClientCreateController(),
                      lazy: false,
                      child: const AdSMClientCreateScreen(),
                    ),
                  );
                }),
            createAdSMForDriverOrOwnerRoute(),
            GoRoute(
                path: AppRouteNames.createAdWithoutType,
                name: AppRouteNames.createAdWithoutType,
                builder: (context, state) {
                  return ConnectivityCheckWidget(
                      connectedWidget: ChangeNotifierProvider(
                          create: (_) => AdSmClientCreateBusinessController(),
                          lazy: false,
                          child: const AdSMClientCreateBusinessScreen()));
                }),
            GoRoute(
              path: AppRouteNames.createAdConstructions,
              name: AppRouteNames.createAdConstructions,
              builder: (context, state) {
                final map = state.extra as Map<String, dynamic>;
                final value = map['value'] as String? ?? '';
                return ConnectivityCheckWidget(
                  connectedWidget: ChangeNotifierProvider(
                    create: (_) => AdConstructionCreateScreenController(
                        requestEnum: getCreateAdOrRequestEnumFromString(value)),
                    child: const AdConstructionCreateScreen(),
                  ),
                );
              },
            ),
            GoRoute(
                path: AppRouteNames.createAdService,
                name: AppRouteNames.createAdService,
                builder: (context, state) {
                  final map = state.extra as Map<String, dynamic>;
                  final value = map['value'];

                  return ConnectivityCheckWidget(
                    connectedWidget: ChangeNotifierProvider(
                      create: (_) => AdServiceCreateScreenController(
                          requestEnum:
                              getCreateAdOrRequestEnumFromString(value)),
                      child: const AdServiceCreateScreen(),
                    ),
                  );
                }),
            GoRoute(
                path: AppRouteNames.profileSettings,
                name: AppRouteNames.profileSettings,
                builder: (context, state) {
                  return ConnectivityCheckWidget(
                    connectedWidget: ChangeNotifierProvider(
                      create: (context) => ProfileController(appChangeNotifier: appChangeNotifier),
                      child: const ProfileSettingPage(),
                    ),
                  );
                },
                routes: [
                  GoRoute(
                    path: AppRouteNames.subscribeForAds,
                    name: AppRouteNames.subscribeForAds,
                    builder: (context, state) {
                      return ConnectivityCheckWidget(
                        connectedWidget: ChangeNotifierProvider(
                            create: (context) => SubscribeForAdsController(),
                            child: const SubscribeForAds()),
                      );
                    },
                  ),
                  GoRoute(
                    path: AppRouteNames.updateOrChangePassword,
                    name: AppRouteNames.updateOrChangePassword,
                    builder: (context, state) {
                      return ConnectivityCheckWidget(
                        connectedWidget: ChangeNotifierProvider(
                            create: (context) =>
                                ChangeOrUpdatePasswordScreenController(),
                            child: const ChangeOrUpdatePasswordScreen()),
                      );
                    },
                  ),
                  privacyPolicyRoute(),
                ]),
            GoRoute(
              path: AppRouteNames.equipmentCreatedRequestDetail,
              name: AppRouteNames.equipmentCreatedRequestDetail,
              builder: (context, state) {
                final arguments = (state.extra ?? <String, dynamic>{}) as Map;

                final requestId = arguments['id'];

                return ConnectivityCheckWidget(
                  connectedWidget: ChangeNotifierProvider(
                    create: (_) =>
                        EquipmentCreatedRequestDetailController(requestId),
                    child: EquipmentCreatedRequestDetailScreen(
                      requestId: requestId,
                    ),
                  ),
                );
              },
            ),
            GoRoute(
                path: AppRouteNames.myWorkersList,
                name: AppRouteNames.myWorkersList,
                builder: (context, state) {
                  return ConnectivityCheckWidget(
                    connectedWidget: ChangeNotifierProvider(
                      create: (_) => MyWorkersListController(),
                      child: const MyWorkersListScreen(),
                    ),
                  );
                },
                routes: [
                  GoRoute(
                    path: AppRouteNames.myWorkersListSearch,
                    name: AppRouteNames.myWorkersListSearch,
                    builder: (context, state) => const ConnectivityCheckWidget(
                        connectedWidget: MyWorkersListSearchScreen()),
                  ),
                  // показывает путь водителя
                  GoRoute(
                    path: AppRouteNames.googleNavigationScreen,
                    name: AppRouteNames.googleNavigationScreen,
                    pageBuilder: (context, state) {
                      final arguments =
                          (state.extra ?? <String, dynamic>{}) as Map;
                      final index = arguments['id'] as String? ?? '';
                      final lat = arguments['lat'] as double;
                      final lon = arguments['lon'] as double;

                      return CustomTransitionPage(
                        key: state.pageKey,
                        child: ChangeNotifierProvider(
                          create: (context) => GoogleNavigationScreenController(
                            currentReID: index,
                            destinationGeo: LatLng(lat, lon),
                            destinationAddress: 'Ваш адрес назначения', // Передайте адрес назначения
                          ),
                          child: GoogleNavigationScreen(),
                        ),
                        transitionsBuilder: (context, animation, secondaryAnimation, child) {
                          return FadeTransition(opacity: animation, child: child);
                        },
                      );
                    },
                  ),
                ]),
            GoRoute(
              path: AppRouteNames.adSMMapList,
              name: AppRouteNames.adSMMapList,
              pageBuilder: (context, state) {
                // final arguments = state.extra as Map;
                // final cityName = (arguments['city'] as String? )?? '';
                // return const SmListInMapScreen();
                final blocValue = BlocProvider.of<SmListMapBloc>(context);

                return CustomTransitionPage(
                  key: state.pageKey,
                  child: BlocProvider.value(
                      value: blocValue,
                      child: Builder(builder: (context) {
                        final stateIsMachinary =
                            blocValue.state is SMADMapListState;
                        final stateIsEquipment =
                            blocValue.state is EQADMapListState;
                        final stateIsCm = blocValue.state is CMADMapListState;
                        final stateIsSVM = blocValue.state is SVMADMapListState;

                        if (stateIsMachinary) {
                          final adSpecializedMachinery =
                              (blocValue.state as SMADMapListState)
                                  .adSpecializedMachinery;

                          return ChangeNotifierProvider(
                            create: (context) => GoogleMapScreenController(
                              data: adSpecializedMachinery,
                              serviceTypeEnum: ServiceTypeEnum.MACHINARY,
                            ),
                            child: GoogleMapClustering(),
                          );
                        } else if (stateIsEquipment) {
                          final adEquipment =
                              (blocValue.state as EQADMapListState).equipments;

                          return ChangeNotifierProvider(
                            create: (context) => GoogleMapScreenController(
                              data: adEquipment,
                              serviceTypeEnum: ServiceTypeEnum.EQUIPMENT,
                            ),
                            child: GoogleMapClustering(),
                          );
                        } else if (stateIsCm) {
                          final adCmData = (blocValue.state as CMADMapListState)
                              .adContructions;

                          return ChangeNotifierProvider(
                            create: (context) => GoogleMapScreenController(
                              data: adCmData,
                              serviceTypeEnum: ServiceTypeEnum.CM,
                            ),
                            child: GoogleMapClustering(),
                          );
                        } else if (stateIsSVM) {
                          final adSvmData =
                              (blocValue.state as SVMADMapListState).adServices;

                          return ChangeNotifierProvider(
                            create: (context) => GoogleMapScreenController(
                              data: adSvmData,
                              serviceTypeEnum: ServiceTypeEnum.SVM,
                            ),
                            child: GoogleMapClustering(),
                          );
                        } else {
                          return Scaffold(
                            body: AppCircularProgressIndicator(),
                          );
                        }
                      })),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    return FadeTransition(opacity: animation, child: child);
                  },
                );
              },
            ),

            GoRoute(
                path: AppRouteNames.myAdConstruction,
                name: AppRouteNames.myAdConstruction,
                builder: (context, state) {
                  return ConnectivityCheckWidget(
                    connectedWidget: ChangeNotifierProvider(
                        create: (_) => MyAdConstructionControllers(),
                        child: const MyAdConstructionScreen()),
                  );
                },
                routes: [
                  GoRoute(
                      path: AppRouteNames.myAdConstructionDetail,
                      name: AppRouteNames.myAdConstructionDetail,
                      builder: (context, state) {
                        final map = state.extra as Map<String, dynamic>;
                        return ConnectivityCheckWidget(
                          connectedWidget: MyAdContstructionDetailScreen(
                            adID: map['id'].toString(),
                            createAdOrRequestEnumName: map['enum'].toString(),
                          ),
                        );
                      }),
                ]),
            GoRoute(
                path: AppRouteNames.myAdSMList,
                name: AppRouteNames.myAdSMList,
                builder: (context, state) {
                  return ConnectivityCheckWidget(
                    connectedWidget: ChangeNotifierProvider(
                      create: (_) => MyAdSMListController(),
                      child: const MyAdSmListScreen(),
                    ),
                  );
                },
                routes: [
                  createAdSMForDriverOrOwnerRouteFromMyAds(),
                  GoRoute(
                    path: AppRouteNames.myAdSMClientDetail,
                    name: AppRouteNames.myAdSMClientDetail,
                    builder: (context, state) {
                      final arguments =
                          (state.extra ?? <String, dynamic>{}) as Map;
                      final adId = arguments['id'];
                      return ConnectivityCheckWidget(
                        connectedWidget: ChangeNotifierProvider(
                          create: (_) => MyAdSMClientDetailController(adId),
                          child: MyAdSMClientDetailScreen(
                            adId: adId,
                          ),
                        ),
                      );
                    },
                  ),
                  GoRoute(
                    path: AppRouteNames.myAdSMDetail,
                    name: AppRouteNames.myAdSMDetail,
                    builder: (context, state) {
                      final arguments =
                          (state.extra ?? <String, dynamic>{}) as Map;

                      final adId = arguments['id'];

                      return ConnectivityCheckWidget(
                          connectedWidget: ChangeNotifierProvider(
                              create: (_) => MyAdSMDetailController(adId),
                              child: MyAdSMDetailScreen(adId: adId)));
                    },
                  ),
                ]),
            //  GoRoute(
            //   path: AppRouteNames.myAdSMClientList,
            //   name: AppRouteNames.myAdSMClientList,
            //   builder: (context, state) {
            //     return ConnectivityCheckWidget(
            //         connectedWidget: ChangeNotifierProvider(
            //             create: (_) => MyAdSMClientListController(context),
            //             child: const MyAdSMClientListScreen()));
            //   },
            //   routes: [
            // createAdSMForDriverOrOwnerRouteFromMyAds(),
            // GoRoute(
            //   path: AppRouteNames.myAdSMClientDetail,
            //   name: AppRouteNames.myAdSMClientDetail,
            //   builder: (context, state) {
            //     final arguments =
            //         (state.extra ?? <String, dynamic>{}) as Map;
            //     final adId = arguments['id'];
            //     return ConnectivityCheckWidget(
            //       connectedWidget: ChangeNotifierProvider(
            //         create: (_) => MyAdSMClientDetailController(adId),
            //         child: MyAdSMClientDetailScreen(
            //           adId: adId,
            //         ),
            //       ),
            //     );
            //   },
            // ),
            // ]),
            requestHistoryRoute(AppRouteNames.requestHistory),
            GoRoute(
              path: AppRouteNames.myAdEquipmentList,
              name: AppRouteNames.myAdEquipmentList,
              builder: (context, state) {
                return ConnectivityCheckWidget(
                  connectedWidget: ChangeNotifierProvider(
                    create: (_) => MyAdEquipmentListController(),
                    child: const MyAdEquipmentListScreen(),
                  ),
                );
              },
              routes: [
                GoRoute(
                  path: AppRouteNames.myAdEquipmentClientDetail,
                  name: AppRouteNames.myAdEquipmentClientDetail,
                  builder: (context, state) {
                    final arguments =
                        (state.extra ?? <String, dynamic>{}) as Map;

                    final adId = arguments['id'];
                    final createAdOrRequestEnum = arguments['enum'] as String;

                    return ConnectivityCheckWidget(
                        connectedWidget: ChangeNotifierProvider(
                            create: (_) =>
                                MyAdEquipmentClientDetailController(adId)
                                  ..loadDetails(context),
                            child: MyAdEquipmentClientDetailScreen(
                                adID: adId,
                                createAdOrRequestEnum: createAdOrRequestEnum)));
                  },
                ),
                adEquipmentForBuisnessRoute(
                    AppRouteNames.adEquipmentForBuisnessFromMyAds),
                // GoRoute(
                //   path: AppRouteNames.myAdEquipmentDetail,
                //   name: AppRouteNames.myAdEquipmentDetail,
                //   builder: (context, state) {
                //     final arguments =
                //         (state.extra ?? <String, dynamic>{}) as Map;

                //     final adId = arguments['id'];

                //     return ConnectivityCheckWidget(
                //         connectedWidget: ChangeNotifierProvider(
                //             create: (_) => MyAdEquipmentDetailController(adId),
                //             child: MyAdEquipmentDetailScreen(adId: adId)));
                //   },
                // ),
              ],
            ),
            // GoRoute(
            //     path: AppRouteNames.myAdEquipmentClientList,
            //     name: AppRouteNames.myAdEquipmentClientList,
            //     builder: (context, state) {
            //       return ConnectivityCheckWidget(
            //           connectedWidget: ChangeNotifierProvider(
            //               create: (_) =>
            //                   MyAdEquipmentClientListController(context)
            //                     ..setupAds(context),
            //               child: const MyAdEquipmentClientListScreen()));
            //     },
            //     routes: [
            //       GoRoute(
            //         path: AppRouteNames.myAdEquipmentClientDetail,
            //         name: AppRouteNames.myAdEquipmentClientDetail,
            //         builder: (context, state) {
            //           final arguments =
            //               (state.extra ?? <String, dynamic>{}) as Map;

            //           final adId = arguments['id'];
            //           final createAdOrRequestEnum = arguments['enum'] as String;

            //           return ConnectivityCheckWidget(
            //               connectedWidget: ChangeNotifierProvider(
            //                   create: (_) =>
            //                       MyAdEquipmentClientDetailController(adId)
            //                         ..loadDetails(context),
            //                   child: MyAdEquipmentClientDetailScreen(
            //                       adID: adId,
            //                       createAdOrRequestEnum:
            //                           createAdOrRequestEnum)));
            //         },
            //       ),
            //     ]),
            GoRoute(
              path: AppRouteNames.adEquipmentRequestDetail,
              name: AppRouteNames.adEquipmentRequestDetail,
              builder: (context, state) {
                final arguments = (state.extra ?? <String, dynamic>{}) as Map;

                final adId = arguments['id'];

                return ConnectivityCheckWidget(
                    connectedWidget: EquipmentRequestExecutionDetailScreen(
                        requestID: adId.toString()));
              },
            ),
            requestExecutionDetailRoute(AppRouteNames.requestExecutionDetailSM),
            favoriteAdsForClientRoute(),
            favoriteAdsForDriverOrOwnerRoute(),
            GoRoute(
                path: AppRouteNames.adServiceRequesExecutiontDetailScreen,
                name: AppRouteNames.adServiceRequesExecutiontDetailScreen,
                builder: (context, state) {
                  final arguments = (state.extra ?? <String, dynamic>{}) as Map;
                  final String id = arguments['id'].toString();

                  return ServiceRequestExecutionDetailScreen(
                      requestID: id.toString());
                }),
          ]),
    ]);

GoRoute adEquipmentForBuisnessRoute(String name) {
  return GoRoute(
      path: AppRouteNames.adEquipmentForBuisness,
      name: name,
      builder: (context, state) {
        return ConnectivityCheckWidget(
            connectedWidget: ChangeNotifierProvider(
                create: (_) => AdEquipmentCreateController(),
                child: const AdEquipmentCreateScreen()));
      });
}

GoRoute createAdSMForDriverOrOwnerRoute() {
  return GoRoute(
      path: AppRouteNames.createAdSMForDriverOrOwner,
      name: AppRouteNames.createAdSMForDriverOrOwner,
      builder: (context, state) {
        return ConnectivityCheckWidget(
            connectedWidget: ChangeNotifierProvider(
                create: (_) => AdSMCreateController(),
                lazy: false,
                child: const AdSMCreateScreen()));
      },
      routes: [
        adSMParametersRoute(),
      ]);
}

GoRoute createAdSMForDriverOrOwnerRouteFromMyAds() {
  return GoRoute(
      path: AppRouteNames.createAdSMForDriverOrOwnerFromMyADs,
      name: AppRouteNames.createAdSMForDriverOrOwnerFromMyADs,
      builder: (context, state) {
        return ConnectivityCheckWidget(
            connectedWidget: ChangeNotifierProvider(
          create: (_) => AdSMCreateController(),
          lazy: false,
          child: const AdSMCreateScreen(),
        ));
      },
      routes: [
        adSMParametersRouteFromMyds(),
      ]);
}

GoRoute adSMParametersRouteFromMyds() {
  return GoRoute(
    path: AppRouteNames.adSMParametersFromMyAds,
    name: AppRouteNames.adSMParametersFromMyAds,
    builder: (context, state) {
      final adSMParametersData = state.extra as AdSMParametersData;
      return ConnectivityCheckWidget(
        connectedWidget: ChangeNotifierProvider(
            create: (_) => AdSMParametersController(adSMParametersData),
            child: AdSMParametersScreen(
              adSMParametersData: adSMParametersData,
            )),
      );
    },
  );
}

GoRoute adSMParametersRoute() {
  return GoRoute(
    path: AppRouteNames.adSMParameters,
    name: AppRouteNames.adSMParameters,
    builder: (context, state) {
      final adSMParametersData = state.extra as AdSMParametersData;
      return ConnectivityCheckWidget(
        connectedWidget: ChangeNotifierProvider(
            create: (_) => AdSMParametersController(adSMParametersData),
            child:
                AdSMParametersScreen(adSMParametersData: adSMParametersData)),
      );
    },
  );
}

GoRoute requestExecutionDetailRoute(String name) {
  return GoRoute(
    path: AppRouteNames.requestExecutionDetail,
    name: name,
    builder: (context, state) {
      final arguments = (state.extra ?? <String, dynamic>{}) as Map;

      final requestId = arguments['id'];

      return ConnectivityCheckWidget(
          connectedWidget: ChangeNotifierProvider(
              create: (_) => SMRequestExecutionDetailController(requestId),
              child: SMRequestExecutionDetailScreen(
                  requestId: requestId.toString())));
    },
  );
}

GoRoute requestHistoryRoute(String name) {
  return GoRoute(
    path: AppRouteNames.requestHistory,
    name: name,
    builder: (context, state) {
      final requestHistoryData = state.extra as RequestHistoryData;
      return ChangeNotifierProvider(
        create: (_) => RequestHistoryController(requestHistoryData.requestId),
        child: RequestHistoryScreen(
          requestHistoryData: requestHistoryData,
        ),
      );
    },
  );
}

GoRoute favoriteAdsForDriverOrOwnerRoute() {
  return GoRoute(
      path: AppRouteNames.favoriteAdsForDriverOrOwner,
      name: AppRouteNames.favoriteAdsForDriverOrOwner,
      builder: (context, state) {
        return const ConnectivityCheckWidget(
          connectedWidget: FavoriteAdClientListScreen(),
        );
      },
      routes: [
        adSMClientDetailRoute(AppRouteNames.adSMClientDetailFromMyAd),
        adEquipmentClientDetailRoute(
            AppRouteNames.adEquipmentClientDetailFromFavo),
        adConstructionDetailRoute(
            AppRouteNames.adConstructionDetailFromFavoClient),
        adServiceDetailScreenRoute(
            AppRouteNames.adServiceDetailScreenFromFavoClient)
      ]);
}

GoRoute favoriteAdsForClientRoute() {
  return GoRoute(
      path: AppRouteNames.favoriteAdsForClient,
      name: AppRouteNames.favoriteAdsForClient,
      builder: (context, state) {
        return const ConnectivityCheckWidget(
          connectedWidget: FavoriteAdSMListScreen(),
        );
      },
      routes: [
        GoRoute(
          path: AppRouteNames.adSMDetail,
          name: AppRouteNames.adSMClientDetailFromMyClientAd,
          builder: (context, state) {
            final uri = Uri.parse(state.uri.toString());
            final adIdFromURL = uri.queryParameters['id'];
            final arguments = (state.extra ?? <String, dynamic>{}) as Map;
            final adIdFromArgs = arguments['id'];
            final adId = adIdFromURL ?? adIdFromArgs;
            return ConnectivityCheckWidget(
              connectedWidget: ChangeNotifierProvider(
                create: (_) => AdSMDetailController(adId),
                child: AdSMDetailScreen(adId: adId),
              ),
            );
          },
        ),
        GoRoute(
          path: AppRouteNames.adEquipmentClientDetailFromClientFavo,
          name: AppRouteNames.adEquipmentClientDetailFromClientFavo,
          builder: (context, state) {
            final uri = Uri.parse(state.uri.toString());
            final adIdFromURL = uri.queryParameters['id'];
            final arguments = (state.extra ?? <String, dynamic>{}) as Map;
            final adIdFromArgs = arguments['id'];
            final adId = adIdFromURL ?? adIdFromArgs;

            return ConnectivityCheckWidget(
              connectedWidget: ChangeNotifierProvider(
                create: (_) => AdEquipmentDetailController(adId),
                child: AdEquipmentDetailScreen(
                  adId: adId,
                ),
              ),
            );
          },
        ),
        adConstructionDetailRoute(AppRouteNames.adConstructionDetailFromFavo),
        adServiceDetailScreenRoute(AppRouteNames.adServiceDetailScreenFromFavo)
      ]);
}

GoRoute adSMClientDetailRoute(String name) {
  return GoRoute(
    path: AppRouteNames.adSMClientDetail,
    name: name,
    builder: (context, state) {
      final uri = Uri.parse(state.uri.toString());
      final adIdFromURL = uri.queryParameters['id'];
      final arguments = (state.extra ?? <String, dynamic>{}) as Map;
      final adIdFromArgs = arguments['id'];
      final adId = adIdFromURL ?? adIdFromArgs;

      return ConnectivityCheckWidget(
        connectedWidget: ChangeNotifierProvider(
          create: (_) => AdSMClientDetailController(adId),
          child: AdSMClientDetailScreen(adId: adId),
        ),
      );
    },
  );
}

GoRoute adEquipmentClientDetailRoute(String name) {
  return GoRoute(
    path: AppRouteNames.adEquipmentClientDetail,
    name: name,
    builder: (context, state) {
      final uri = Uri.parse(state.uri.toString());
      final adIdFromURL = uri.queryParameters['id'];
      final arguments = (state.extra ?? <String, dynamic>{}) as Map;
      final adIdFromArgs = arguments['id'];
      final adId = adIdFromURL ?? adIdFromArgs;

      return ConnectivityCheckWidget(
        connectedWidget: ChangeNotifierProvider(
          create: (_) => AdEquipmentClientDetailController(adId),
          child: AdEquipmentClientDetailScreen(
            adId: adId,
          ),
        ),
      );
    },
  );
}

GoRoute adConstructionDetailRoute(String name) {
  return GoRoute(
    path: AppRouteNames.adConstructionDetail,
    name: name,
    builder: (context, state) {
      final uri = Uri.parse(state.uri.toString());
      final adIdFromURL = uri.queryParameters['id'];
      final arguments = (state.extra ?? <String, dynamic>{}) as Map;
      final adId = adIdFromURL ?? arguments['id'];

      return ConnectivityCheckWidget(
          connectedWidget: ChangeNotifierProvider(
              create: (context) =>
                  AdConstructionDetailScreenController(adID: adId),
              child: AdConstructionDetailScreen(id: adId)));
    },
  );
}

GoRoute adServiceDetailScreenRoute(String name) {
  return GoRoute(
      path: AppRouteNames.adServiceDetailScreen,
      name: name,
      builder: (context, state) {
        final Map<String, dynamic> data = state.extra as Map<String, dynamic>;

        final id = data['id'] as String;
        return ChangeNotifierProvider(
            create: (context) => AdServiceDetailScreenController(adID: id),
            child: AdServiceDetailScreen(id: id));
      });
}

//!
GoRoute privacyPolicyRoute() {
  return GoRoute(
    path: AppRouteNames.privacyPolicy,
    name: AppRouteNames.privacyPolicy,
    builder: (context, state) {
      return const ConnectivityCheckWidget(
        connectedWidget: PrivacyPolicyScreen(),
      );
    },
  );
}

GoRoute loginRoutes() {
  return GoRoute(
      path: AppRouteNames.login,
      name: AppRouteNames.login,
      builder: (context, state) {
        return LoginScreen();
        // return SwipeBackDetector(
        //   // pathName: AppRouteNames.login,
        //   // navigationIndex: '4',
        //   // backGroundWidget: ChangeNotifierProvider(
        //   //   create: (_) => NavigationScreenController(),
        //   //   child: const NavigationScreen(initialIndex: 4),
        //   // ),
        //   // swipeAreaWidth: MediaQuery.of(context).size.width * 0.5,
        //   child: const
        // );
      },
      routes: [
        GoRoute(
            path: AppRouteNames.forgotPasswordPickWayScreen,
            name: AppRouteNames.forgotPasswordPickWayScreen,
            builder: (context, state) {
              return const ForgotPasswordPickWayScreen();
            },
            routes: [
              GoRoute(
                  path: AppRouteNames.forgotPasswordEnterSendCodeFromEmail,
                  name: AppRouteNames.forgotPasswordEnterSendCodeFromEmail,
                  builder: (context, state) {
                    return ChangeNotifierProvider(
                        create: (_) =>
                            ForgotPasswordEntedEmailCodeScreenController(),
                        child: const ForgotPasswordEntedEmailCodeScreen());
                  }),
              GoRoute(
                  path: AppRouteNames.forgotPasswordEnterPhoneNumber,
                  name: AppRouteNames.forgotPasswordEnterPhoneNumber,
                  builder: (context, state) {
                    return ChangeNotifierProvider(
                      create: (_) => ForgetPasswordController(),
                      child: const ForgotPasswordScreen(),
                    );
                  },
                  routes: [
                    GoRoute(
                      path: AppRouteNames.forgotPasswordEnterSendCode,
                      name: AppRouteNames.forgotPasswordEnterSendCode,
                      builder: (context, state) {
                        final phoneNumber = state.extra as String;
                        return ChangeNotifierProvider(
                            create: (_) => ForgetPasswordController(),
                            child: ForgotPasswordVerificationScreen(
                                phoneNumber: phoneNumber));
                      },
                    ),
                  ]),
            ]),
        GoRoute(
            path: AppRouteNames.registerPhone,
            name: AppRouteNames.registerPhone,
            builder: (context, state) {
              return ChangeNotifierProvider(
                create: (_) => RegisterPhoneController(),
                child: const RegisterPhoneScreen(),
              );
            }),
        GoRoute(
            path: AppRouteNames.vefirication,
            name: AppRouteNames.vefirication,
            builder: (context, state) {
              final String phoneNumber = state.extra as String;
              return ChangeNotifierProvider(
                  create: (_) => RegisterCitySelectController(),
                  child:
                      VerificationPhoneNumberScreen(phoneNumber: phoneNumber));
            }),
        GoRoute(
            path: AppRouteNames.citySelect,
            name: AppRouteNames.citySelect,
            builder: (context, state) {
              final User user = state.extra as User;
              return ChangeNotifierProvider(
                create: (_) => RegisterCitySelectController(),
                child: RegisterCitySelectScreen(
                  user: user,
                ),
              );
            }),
        GoRoute(
            path: AppRouteNames.registerPassword,
            name: AppRouteNames.registerPassword,
            builder: (context, state) {
              final User user = state.extra as User;
              return RegisterPasswordScreen(
                user: user,
              );
            })
      ]);
}
