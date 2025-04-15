// import 'dart:convert';

// import 'package:eqshare_mobile/src/core/data/models/payload/payload.dart';
// import 'package:eqshare_mobile/src/core/data/services/network/api_client/ad_api_client.dart';
// import 'package:eqshare_mobile/src/core/data/services/storage/token_provider_service.dart';
// import 'package:eqshare_mobile/src/core/presentation/routing/app_route.dart';
// import 'package:eqshare_mobile/app/app_change_notifier.dart';
// import 'package:eqshare_mobile/src/features/ad/data/classes/ad_list_row_data.dart';
// // import 'package:eqshare_mobile/src/features/ad/data/models/ad_sm_client_detail/ad_client.dart';
// import 'package:eqshare_mobile/src/features/ad/presentation/screens/favorite_ad_sm_list/data/models/favorite_sm_list/favorite.dart';
// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// // import 'package:eqshare_mobile/src/features/ad/presentation/screens/favorite_ad_sm_list/data/models/favorite_ad_client_list/favorite.dart' as fv; 

// import '../../../../data/models/ad_sm_list/ad_specialized_machinery.dart';


// import 'package:eqshare_mobile/src/features/ad/data/models/ad_sm_client_list/ad_client.dart';
// import 'package:eqshare_mobile/src/features/ad/presentation/screens/favorite_ad_sm_list/data/models/favorite_ad_client_list/favorite.dart' as ali;


// class FavoriteAdSMListController extends AppChangeNotifier {
//   bool _isLoading = true;
//   final _adApiClient = AdApiClient();
//   final _ads = <AdListRowData>[];
//   var isLoadingInProgres = false;
//   bool isContentEmpty = false;
//   final _adEquipment= <AdListRowData>[]; 


//   List<AdListRowData> get ads => List.unmodifiable(_ads.toList());
//   List<AdListRowData> get adEquipment => List.unmodifiable(_adEquipment.toList());


//   bool get isLoading => _isLoading;
//   bool hasError = false;
//   String _searchString = '';

//   String get searchString => _searchString;

//   set searchString(String value) {
//     _searchString = value;
//     notifyListeners();
//   }

//   Future<void> setupAds(BuildContext context) async {
//     final token = await TokenService().getToken();
//     if (token == null) {
//       return;
//     }
//     final encodedPayload = token.split('.')[1];
//     final payloadData =
//         utf8.fuse(base64).decode(base64.normalize(encodedPayload));

//     final payload = Payload.fromJson(jsonDecode(payloadData));
//     _isLoading = true;
//     isContentEmpty = false;

//     notifyListeners();
//     _ads.clear();
//     checkConnectivity();

//     if (context.mounted) {
//       await _loadMyAds(context, payload.sub ?? '-1');
//             // final adSpecializedMachineryList = await _adApiClient.aliGetFavoriteAdSpecializedMachinery(token ?? '-1');
//       // _adSpecializedMachineryList.addAll(adSpecializedMachineryList);
//       await _loadMyAdClient(context,payload.sub ?? '-1');
//     }

//     _isLoading = false;
//     notifyListeners();
//   }

//   AdListRowData _makeRowData(AdSpecializedMachinery adSM) {
//     return AdListRowData(
//       id: adSM.id,
//       title: adSM.name,
//       address: adSM.address,
//       category: adSM.type?.name ?? 'Неизвестная категория',
//       price: adSM.price,
//       rating: adSM.rating,
//       imageUrl: adSM.urlFoto?.first ??
//           'https://liamotors.com.ua/image/catalogues/products/no-image.png',
//     );
//   }

//   Future<void> _loadMyAds(BuildContext context, String id) async {
//     isLoadingInProgres = true;

//     try {
//       final favoriteListResponse = await _adApiClient.getFavoriteAdSMList(
//         context,
//       );
//       if (favoriteListResponse != null) {
//         for (Favorite favorite
//             in favoriteListResponse.favorites ?? <Favorite>[]) {
//           if (favorite.adSpecializedMachinery != null) {
//             _ads.add(_makeRowData(favorite.adSpecializedMachinery!));
//           }
//         }
//         if (_ads.isEmpty) {
//           isContentEmpty = true;
//         } else {
//           isContentEmpty = false;
//         }
//         isLoadingInProgres = false;
//         notifyListeners();
//       }
//     } catch (e) {
//       isLoadingInProgres = false;
//     }
//   }

//   void onAdTap(BuildContext context, int index) async {
//     final id = _ads.toList()[index].id.toString();

//     // final result = await Navigator.of(context).pushNamed(
//     //   AppRouteNames.adSMDetail,
//     //   arguments: {'id': id},
//     // );
//     final result = await context.pushNamed(
//       AppRouteNames.adSMDetail,
//       extra: {'id': id},
//     );
//     if (result == true) {
//       if (!context.mounted) return;
//       await setupAds(context);
//       notifyListeners();
//     }
//   }
//    AdListRowData _makeRowDataFrom(AdClient adSM) {
//     String imageUrl;
//     if (adSM.documents == null || adSM.documents?.isEmpty == true) {
//       imageUrl =
//           'https://liamotors.com.ua/image/catalogues/products/no-image.png';
//     } else {
//       imageUrl = adSM.documents?.first.shareLink ??
//           'https://liamotors.com.ua/image/catalogues/products/no-image.png';
//     }
//     return AdListRowData(
//       id: adSM.id,
//       title: adSM.headline,
//       address: adSM.address,
//       category: adSM.type?.name ?? 'Неизвестная категория',
//       price: (adSM.price) .toDouble(),
//       rating: null,
//       imageUrl: imageUrl,
//     );
//   }

//   Future<void> _loadMyAdClient(BuildContext context, String id) async {


//     try {
//       final favoriteListResponse = await _adApiClient.getFavoriteAdSMClientList(
//         context,
//       );
//       print('favoriteListResponse ${favoriteListResponse} ');
//       if (favoriteListResponse != null) {
//         for (ali.Favorite favorite
//             in favoriteListResponse.favorites ?? <ali.Favorite>[]) {
//           if (favorite.adClient != null) {
//             _ads.add(_makeRowDataFrom(favorite.adClient!));
//           }
//         }
//         if (_ads.isEmpty) {
//           isContentEmpty = true;
//         } else {
//           isContentEmpty = false;
//       }
//         isLoadingInProgres = false;
//         notifyListeners();
//       }
//     } catch (e) {
//       isLoadingInProgres = false;
//     }
//   }

// }
