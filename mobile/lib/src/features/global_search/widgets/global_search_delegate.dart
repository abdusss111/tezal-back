import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:eqshare_mobile/src/core/data/models/payload/payload.dart';
import 'package:eqshare_mobile/src/core/presentation/widgets/app_circular_progress_indicator.dart';
import 'package:eqshare_mobile/src/core/res/api_endpoints/api_endpoints.dart';
import 'package:eqshare_mobile/src/features/ad/presentation/utils/sliver_delegate.dart';
import 'package:eqshare_mobile/src/global_widgets/global_values.dart';
import 'package:eqshare_mobile/src/features/global_search/models/search_ad_response.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:eqshare_mobile/src/core/data/services/storage/token_provider_service.dart';
import 'package:eqshare_mobile/src/core/presentation/routing/app_route.dart';
import 'package:eqshare_mobile/src/core/res/theme/app_colors.dart';
import 'package:eqshare_mobile/src/features/main/profile/profile_page/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../home/home_controller.dart';

class AdModel {
  final String title;
  final int id;
  final String imageUrl;
  final ServiceTypeEnum selectedServiceType;

  AdModel(
      {required this.id,
      required this.title,
      required this.imageUrl,
      required this.selectedServiceType});
}

typedef OnSearchChanged = Future<List<String>?> Function(String);

Future<List<String>?> getRecentSearchesLike(String query) async {
  final pref = await SharedPreferences.getInstance();
  final allSearches = pref.getStringList('recentSearches');
  return allSearches?.where((search) => search.startsWith(query)).toList();
}

Future<void> saveToRecentSearches(String? searchText) async {
  if (searchText == null) return;
  if (searchText.isEmpty) return;
  final pref = await SharedPreferences.getInstance();

  Set<String> allSearches = pref.getStringList('recentSearches')?.toSet() ?? {};
  allSearches = {searchText, ...allSearches};
  pref.setStringList('recentSearches', allSearches.toList());

  log(allSearches.toString(), name: 'AllSearches');
}

Future<void> deleteFromRecentSearches(String? searchText) async {
  if (searchText == null) return; //Should not be null
  final pref = await SharedPreferences.getInstance();
  Set<String> allSearches = pref.getStringList('recentSearches')?.toSet() ?? {};
  allSearches.remove(searchText);
  pref.setStringList('recentSearches', allSearches.toList());
}

Future<void> clearRecentSearches() async {
  final pref = await SharedPreferences.getInstance();
  Set<String> allSearches = pref.getStringList('recentSearches')?.toSet() ?? {};
  allSearches.clear();
  pref.setStringList('recentSearches', allSearches.toList());
}

class GlobalSearchDelegate extends SearchDelegate<String> {
  final OnSearchChanged? onSearchChanged;
  final String? searchText;

  ///This [_oldFilters] used to store the previous suggestions. While waiting
  ///for [onSearchChanged] to completed, [_oldFilters] are displayed.
  List<String>? _oldFilters = const [];

  GlobalSearchDelegate({this.onSearchChanged, this.searchText});

  @override
  String get searchFieldLabel => 'Поиск по Mezet.online';

  Future<List<dynamic>> featchData(String searchQuery, int? cityId) async {
    if (searchQuery.isEmpty) {
      return [];
    }

    // Проверяем, если cityId == 92, то НЕ добавляем фильтр по городу
    String cityFilter = (cityId != null && cityId != 92) ? '&city_id=$cityId' : '';

    final response = await http.get(
      Uri.parse('${ApiEndPoints.baseUrl}/search?general=$searchQuery$cityFilter'),
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(utf8.decode(response.bodyBytes));

      final result = jsonData?['result'];
      List<SearchAdResponse> adSMList = [];
      List<SearchAdResponse> adClients = [];
      List<SearchAdResponse> adEqClients = [];
      List<SearchAdResponse> eqList = [];
      List<SearchAdResponse> cmList = [];
      List<SearchAdResponse> cmClientList = [];
      List<SearchAdResponse> svmList = [];
      List<SearchAdResponse> svmClientList = [];

      if (result.isNotEmpty) {
        final List<dynamic> adClientsJson = result['ad_clients'];
        final List<dynamic> adSMListJson = result['ad_specialized_machineries'];
        final List<dynamic> adEqClientsJson = result['ad_equipment_clients'];
        final List<dynamic> eqListJson = result['ad_equipments'];
        final List<dynamic> cmListJson = result['ad_construction_material'];
        final List<dynamic> cmClientListJson =
        result['ad_construction_material_clients'];
        final List<dynamic> svmListJson = result['ad_service'];
        final List<dynamic> svmClientListJson = result['ad_service_clients'];

        if (adSMListJson.isNotEmpty) {
          adSMList = adSMListJson
              .map((adSMJson) => SearchAdResponse.fromJsonNameIsName(adSMJson))
              .toList();
        }
        if (adClientsJson.isNotEmpty) {
          adClients = adClientsJson
              .map((e) => SearchAdResponse.fromJsonNameIsHeadline(e))
              .toList();
        }
        if (eqListJson.isNotEmpty) {
          eqList = eqListJson
              .map((eqJson) => SearchAdResponse.fromJsonNameIsTitle(eqJson))
              .toList();
        }
        if (adEqClientsJson.isNotEmpty) {
          adEqClients = adEqClientsJson
              .map((e) => SearchAdResponse.fromJsonNameIsTitle(e))
              .toList();
        }
        if (cmListJson.isNotEmpty) {
          cmList = cmListJson
              .map((e) => SearchAdResponse.fromJsonNameIsTitle(e))
              .toList();
        }
        if (cmClientListJson.isNotEmpty) {
          cmClientList = cmClientListJson
              .map((e) => SearchAdResponse.fromJsonNameIsTitle(e))
              .toList();
        }
        if (svmListJson.isNotEmpty) {
          svmList = svmListJson
              .map((e) => SearchAdResponse.fromJsonNameIsTitle(e))
              .toList();
        }
        if (svmClientListJson.isNotEmpty) {
          svmClientList = svmClientListJson
              .map((e) => SearchAdResponse.fromJsonNameIsTitle(e))
              .toList();
        }
        final resultForDRIVERorOWNER = [
          adClients,
          adEqClients,
          cmClientList,
          svmClientList,
        ];
        final resultForCLIENTorGHOST = [
          adSMList,
          eqList,
          cmList,
          svmList,
        ];
        final userMode = await getUserMode();
        if (userMode == UserMode.driver || userMode == UserMode.owner) {
          return resultForDRIVERorOWNER;
        } else {
          log(resultForCLIENTorGHOST.length.toString(),
              name: 'Finally result length: ');
          return resultForCLIENTorGHOST;
        }
      }
      return [];
    } else if (response.statusCode == 400) {
      final jsonData = json.decode(utf8.decode(response.bodyBytes));
      if (jsonData['general'] == 'empty') {
        return [];
      } else {
        print("THE FETCHING: $jsonData");
        throw Exception('Failed to fetch categories');
      }
    } else {
      print("THE FETCHING!: ${response.statusCode}");
      final jsonData = json.decode(utf8.decode(response.bodyBytes));

      print("THE FETCHING!: ${jsonData}");
      print(response.toString());
      throw Exception('Failed to fetch categories');
    }
  }


  Future<UserMode> getUserMode() async {
    final token = await TokenService().getToken();
    if (token == null) {
      return UserMode.guest;
    } else {
      final payload = TokenService().extractPayloadFromToken(token);
      switch (payload.aud) {
        case TokenService.driverAudience:
          return UserMode.driver;
        case TokenService.ownerAudience:
          return UserMode.owner;
        case TokenService.clientAudience:
          return UserMode.client;
        default:
          return UserMode.guest;
      }
    }
  }

  Future<Payload?> getPayload() async {
    final token = await TokenService().getToken();
    if (token == null) {
      return null;
    }
    final payload = TokenService().extractPayloadFromToken(token);
    return payload;
  }

  Widget errorWidget(Object? error) {
    if (error is http.ClientException) {
      return const Text(
          'Клиентская ошибка. Попробуйте повторить запрос позже.');
    } else if (error is SocketException) {
      return const Text(
          'Ошибка сети. Проверьте подключение к интернету и попробуйте снова.');
    }
    if (error is FormatException) {
      return Text(
          "Ошибка формата данных. Пожалуйста, сообщите об этой ошибке разработчикам. Ошибка: $error.");
    } else {
      print('THE SEARCH ERROR: $error');
      return const Text(
          'Произошла неизвестная ошибка. Попробуйте повторить запрос позже.');
    }
  }

  @override
  ThemeData appBarTheme(BuildContext context) {
    return ThemeData(
      appBarTheme: const AppBarTheme(
          color: Colors.white, surfaceTintColor: Colors.transparent),
      scaffoldBackgroundColor: Colors.white,
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(8),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(8),
        ),
        filled: true,
        fillColor: Colors.grey[200],
        // contentPadding:
        //     const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        isDense: true,
        isCollapsed: true,
        contentPadding: const EdgeInsets.only(left: 12, top: 6, bottom: 6),
      ),
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            if (query.isEmpty) {
              close(context, '');
            }
            query = '';
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          close(context, '');
        });
  }

  int countOfSearch = 1;

  Widget listOFSearchResultList(List<SearchAdResponse> data,
      {required ServiceTypeEnum selectedService, required Payload? payload}) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: data.length,
      physics: const ClampingScrollPhysics(),
      itemBuilder: (context, index) {
        final resultAd = data[index];
        return AdWidget(
          payload: payload,
          searchText: query,
          ad: AdModel(
              id: resultAd.id,
              title: resultAd.name ?? '',
              imageUrl: resultAd.urlFoto?.first ?? '',
              selectedServiceType: selectedService),
        );
      },
    );
  }

  Widget showSearchResults(BuildContext context) {
    final homeController = Provider.of<HomeController>(context, listen: false);
    final selectedCityId = homeController.selectedCity?.id ?? 1;

    return FutureBuilder<Payload?>(
      future: getPayload(),
      builder: (context, payloadSnapshot) {
        if (payloadSnapshot.connectionState == ConnectionState.waiting) {
          return const AppCircularProgressIndicator();
        }
        final payload = payloadSnapshot.data;

        if (payload == null ||
            payload.aud == 'CLIENT' ||
            payload.aud == 'GUEST') {
          return FutureBuilder<List<dynamic>>(
            future: featchData(query.trim(),selectedCityId ),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const AppCircularProgressIndicator();
              } else if (snapshot.hasError) {
                return errorWidgetExpanded(snapshot);
              } else if (snapshot.data == null ||
                  (snapshot.data ?? []).isEmpty) {
                return emtptyAndNotFindAds(context);
              } else {
                return buildSearchResults(
                    context, snapshot.data ?? [], payload);
              }
            },
          );
        } else {
          return FutureBuilder<List<dynamic>>(
            future: featchData(query.trim(), selectedCityId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const AppCircularProgressIndicator();
              } else if (snapshot.hasError) {
                return errorWidgetExpanded(snapshot);
              } else if (snapshot.data == null ||
                  (snapshot.data ?? []).isEmpty) {
                return emtptyAndNotFindAds(context);
              } else {
                return buildSearchResults(
                    context, snapshot.data ?? [], payload);
              }
            },
          );
        }
      },
    );
  }

  Widget buildSearchResults(
      BuildContext context, List<dynamic> data, Payload? payload) {
    final adSM = data[0] as List<SearchAdResponse>;
    final adEQ = data[1] as List<SearchAdResponse>;
    final adCM = data[2] as List<SearchAdResponse>;
    final adSVM = data[3] as List<SearchAdResponse>;

    final isEmpty =
        adSM.isEmpty && adEQ.isEmpty && adCM.isEmpty && adSVM.isEmpty;
    if (isEmpty) {
      return emtptyAndNotFindAds(context);
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(4),
            child: Text(
                'Найдено ${adSM.length + adEQ.length + adCM.length + adSVM.length} объявлений'),
          ),
          listOFSearchResultList(
              payload: payload,
              adSM,
              selectedService: ServiceTypeEnum.MACHINARY),
          listOFSearchResultList(
              payload: payload,
              adEQ,
              selectedService: ServiceTypeEnum.EQUIPMENT),
          listOFSearchResultList(
              payload: payload, adCM, selectedService: ServiceTypeEnum.CM),
          listOFSearchResultList(
              payload: payload, adSVM, selectedService: ServiceTypeEnum.SVM),
        ],
      ),
    );
  }

  Widget errorWidgetExpanded(AsyncSnapshot<List<dynamic>?> snapshot) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: errorWidget(snapshot.error),
      ),
    );
  }

  Widget emtptyAndNotFindAds(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(
            CupertinoIcons.news,
            size: 32,
          ),
          const SizedBox(height: 10),
          Text(
            'По вашему запросу не найдено объявлении',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 7),
        ],
      ),
    );
  }

  double getHeight(BuildContext context, int length) {
    if (length == 0) {
      return MediaQuery.of(context).size.height * 0.04;
    } else if (length == 1) {
      return MediaQuery.of(context).size.height * 0.08;
    } else {
      return MediaQuery.of(context).size.height * 0.12;
    }
  }

  @override
  Widget buildResults(BuildContext context) {
    saveToRecentSearches(query);
    if (query == '') return buildSuggestions(context);
    return SafeArea(child: showSearchResults(context));
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return StatefulBuilder(
      builder: (context, StateSetter setState) {
        return FutureBuilder<List<String>?>(
          future: onSearchChanged != null ? onSearchChanged!(query) : null,
          builder: (context, snapshot) {
            if (snapshot.hasData) _oldFilters = snapshot.data;
            return ListView(
              children: [
                if (_oldFilters?.isNotEmpty == true)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      children: [
                        const Text(
                          'История поиска',
                          style: TextStyle(
                              fontSize: 18.0, fontWeight: FontWeight.bold),
                        ),
                        const Spacer(),
                        TextButton(
                          onPressed: () {
                            clearRecentSearches();
                            setState(() {});
                          },
                          child: const Text(
                            'Очистить',
                            style: TextStyle(
                              color: AppColors.appPrimaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                SizedBox(
                  height: getHeight(context, (_oldFilters ?? []).length),
                  child: ListView(
                    children: (_oldFilters ?? [])
                        .map((e) => ListTile(
                              leading: const Icon(Icons.restore),
                              title: Text(e),
                              onTap: () {
                                query = e;
                                buildResults(context);
                              },
                              trailing: IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () {
                                  deleteFromRecentSearches(e);
                                  onSearchChanged!(query);
                                  setState(() {});
                                },
                              ),
                            ))
                        .toList(),
                  ),
                ),
                showSearchResults(context)
              ],
            );
          },
        );
      },
    );
  }
}

class AdWidget extends StatefulWidget {
  final AdModel ad;
  final String? searchText;
  final Payload? payload;

  const AdWidget(
      {super.key, required this.ad, required this.payload, this.searchText});

  @override
  State<AdWidget> createState() => _AdWidgetState();
}

class _AdWidgetState extends State<AdWidget> {
 RichText getTitle(bool isClient) {
  final searchText = widget.searchText ?? '';
  final fullTitle = '${widget.ad.title} (${isClient ? 'по спецтехнике' : 'спецтехника'})';

  if (searchText.isEmpty || !fullTitle.toLowerCase().contains(searchText.toLowerCase())) {
    return RichText(
      text: TextSpan(
        text: fullTitle,
        style: const TextStyle(fontWeight: FontWeight.normal, color: Colors.black),
      ),
    );
  }

  // Разделяем текст на совпадающие и несоответствующие части
  final spans = <TextSpan>[];
  int start = 0;

  final lowerFullTitle = fullTitle.toLowerCase();
  final lowerSearchText = searchText.toLowerCase();

  while (start < fullTitle.length) {
    final matchIndex = lowerFullTitle.indexOf(lowerSearchText, start);

    if (matchIndex == -1) {
      // Если больше нет совпадений, добавляем остаток текста
      spans.add(TextSpan(
        text: fullTitle.substring(start),
        style: const TextStyle(fontWeight: FontWeight.normal, color: Colors.black),
      ));
      break;
    }

    // Добавляем часть текста перед совпадением
    if (matchIndex > start) {
      spans.add(TextSpan(
        text: fullTitle.substring(start, matchIndex),
        style: const TextStyle(fontWeight: FontWeight.normal, color: Colors.black),
      ));
    }

    // Добавляем совпадающую часть
    spans.add(TextSpan(
      text: fullTitle.substring(matchIndex, matchIndex + searchText.length),
      style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
    ));

    // Обновляем стартовую позицию
    start = matchIndex + searchText.length;
  }

  return RichText(
    text: TextSpan(children: spans),
  );
}


  Future<void> pushToPage(bool isClient) async {
    AllServiceTypeEnum serviceTypeEnum;
    switch (widget.ad.selectedServiceType) {
      case ServiceTypeEnum.MACHINARY:
        if (isClient) {
          serviceTypeEnum = AllServiceTypeEnum.MACHINARY;
        } else {
          serviceTypeEnum = AllServiceTypeEnum.MACHINARY_CLIENT;
        }
        break;

      case ServiceTypeEnum.EQUIPMENT:
        if (isClient) {
          serviceTypeEnum = AllServiceTypeEnum.EQUIPMENT;
        } else {
          serviceTypeEnum = AllServiceTypeEnum.EQUIPMENT_CLIENT;
        }
        break;

      case ServiceTypeEnum.CM:
        if (isClient) {
          serviceTypeEnum = AllServiceTypeEnum.CM;
        } else {
          serviceTypeEnum = AllServiceTypeEnum.CM_CLIENT;
        }
        break;
      case ServiceTypeEnum.SVM:
        if (isClient) {
          serviceTypeEnum = AllServiceTypeEnum.SVM;
        } else {
          serviceTypeEnum = AllServiceTypeEnum.SVM_CLIENT;
        }
        break;

      default:
        if (isClient) {
          serviceTypeEnum = AllServiceTypeEnum.MACHINARY_CLIENT;
        } else {
          serviceTypeEnum = AllServiceTypeEnum.MACHINARY;
        }
        break;
    }

    context.pushNamed(AppRouteNames.searchResult,
        pathParameters: {'slug': widget.searchText ?? ''},
        extra: {'id': widget.ad.id, 'value': serviceTypeEnum.name});

    //   final map = {'id': widget.ad.id.toString()};
    //   switch (widget.ad.selectedServiceType) {
    //     case ServiceTypeEnum.MACHINARY:
    //       // Navigator.push(
    //       //     context,
    //       //     MaterialPageRoute(
    //       //         builder: (context) => ChangeNotifierProvider(
    //       //               create: (context) => SearchResultsScreenController(
    //       //                   pickedId: widget.ad.id,
    //       //                   serviceTypeEnum: isClient
    //       //                       ? AllServiceTypeEnum.MACHINARY
    //       //                       : AllServiceTypeEnum.MACHINARY_CLIENT,
    //       //                   searchText: widget.searchText ?? ''),
    //       //               child: SearchResultsScreen(),
    //       //             )));
    //       if (isClient) {
    //         context.pushNamed(AppRouteNames.adSMDetail, extra: map);
    //       } else {
    //         context.pushNamed(AppRouteNames.adSMClientDetail, extra: map);
    //       }
    //       return;
    //     case ServiceTypeEnum.EQUIPMENT:
    //       if (isClient) {
    //         context.pushNamed(AppRouteNames.adEquipmentDetail, extra: map);
    //       } else {
    //         context.pushNamed(AppRouteNames.adEquipmentClientDetail, extra: map);
    //       }
    //       return;
    //     case ServiceTypeEnum.CM:
    //       context.pushNamed(AppRouteNames.adConstructionDetail, extra: map);
    //       return;
    //     case ServiceTypeEnum.SVM:
    //       context.pushNamed(AppRouteNames.adServiceDetailScreen, extra: map);
    //       return;
    //     default:
    //       context.pushNamed(AppRouteNames.adSMDetail, extra: map);
    //       return;
    //   }
    // }
  }

  @override
  Widget build(BuildContext context) {
    final isClient = (widget.payload == null) ||
        widget.payload?.aud == 'CLIENT' ||
        widget.payload?.aud == 'GUEST';
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => pushToPage(isClient),
        child: ListTileTheme(
          dense: true,
          contentPadding: const EdgeInsets.only(left: 8.0, right: 16.0),
          child: Container(
            padding: const EdgeInsets.only(left: 8),
            decoration: BoxDecoration(
              color: Colors.transparent,
              border: Border(
                bottom: BorderSide(
                    color: Colors.grey.shade300, width: 1.0), // Add a border
              ),
            ),
            child: ListTile(
              leading: const Icon(Icons.fiber_manual_record, size: 10),
              title: getTitle(isClient), 
              trailing: const Icon(
                Icons.arrow_forward_ios,
                color: Colors.black,
                size: 12,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
