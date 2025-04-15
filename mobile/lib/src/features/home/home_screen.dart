import 'dart:convert';

import 'package:eqshare_mobile/custom_icons.dart';
import 'package:eqshare_mobile/src/core/data/models/cities/city/city_model.dart';
import 'package:eqshare_mobile/src/core/data/models/payload/payload.dart';
import 'package:eqshare_mobile/src/core/data/repositories/app_general_repo.dart';
import 'package:eqshare_mobile/src/core/data/repositories/user_recently_viewed_ads_repo.dart';

import 'package:eqshare_mobile/src/core/data/services/storage/token_provider_service.dart';
import 'package:eqshare_mobile/src/core/presentation/routing/app_route.dart';
import 'package:eqshare_mobile/src/core/presentation/widgets/app_circular_progress_indicator.dart';
import 'package:eqshare_mobile/src/core/presentation/widgets/app_location_f_a_b.dart';
import 'package:eqshare_mobile/src/core/presentation/widgets/page_wrapper.dart';
import 'package:eqshare_mobile/src/features/ad/presentation/widgets/history_widget/history_widget.dart';
import 'package:eqshare_mobile/src/features/home/location_permission_status_widget.dart';
import 'package:eqshare_mobile/src/features/home/user_mode_switch_widget.dart';
import 'package:eqshare_mobile/src/global_widgets/global_values.dart';

import 'package:eqshare_mobile/src/features/ad/presentation/screens/ad_sm/all_ad_sm/ad_client_list/ad_client_list_controller.dart';
import 'package:eqshare_mobile/src/features/ad/presentation/screens/ad_sm/all_ad_sm/ad_client_list/ad_client_list_widget.dart';
import 'package:eqshare_mobile/src/features/ad/presentation/screens/ad_sm/all_ad_sm/ad_sm_list/ad_sm_list_controller.dart';
import 'package:eqshare_mobile/src/features/ad/presentation/screens/ad_sm/all_ad_sm/ad_sm_list/ad_sm_list_widget.dart';
import 'package:eqshare_mobile/src/features/home/home_controller.dart';
import 'package:eqshare_mobile/src/features/main/navigation/navigation_controller.dart';
import 'package:eqshare_mobile/src/features/main/profile/profile_page/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:side_sheet/side_sheet.dart';

import '../../../app/app_change_notifier.dart';
import '../../../main.dart';
import '../global_search/widgets/global_search_field_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<Payload?> _payloadFuture;
  late Future<List<City>> _citiesFuture;
  final ScrollController scrollController = ScrollController();
  final ProfileController profileController = ProfileController(appChangeNotifier: appChangeNotifier);

  City? selectedCity;

  @override
  void initState() {
    super.initState();
    _citiesFuture = AppGeneralRepo().getCities();
    _payloadFuture = getPayload();
    _loadSelectedCity();
    Provider.of<HomeController>(context, listen: false).setUp();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProfileController>(context, listen: false)
          .getLocationStatus();
    });
  }

  Future<Payload?> getPayload() async {
    final token = await TokenService().getToken();
    if (token != null) {
      return TokenService().extractPayloadFromToken(token);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileController>(
        builder: (context, profileController, child) {
      return Scaffold(
        floatingActionButton: Consumer<NavigationScreenController>(
          builder: (context, navController, child) {
            return Visibility(
              visible:
                  navController.appChangeNotifier.userMode == UserMode.client,
              child: const AppLocationFAB(heroTag: 'btn1'),
            );
          },
        ),
        appBar: AppBar(
          title: Consumer<HomeController>(
            builder: (context, newController, _) {
              return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'mezet.online',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Consumer<ProfileController>(
                            builder: (context, profileController, child) {
                              final userModeText = getUserModeText(
                                  profileController.appChangeNotifier.userMode);

                              return UserModeSwitcher(
                                  profileController: profileController);
                            },
                          ),
                          FutureBuilder<List<City>>(
                              future: _citiesFuture,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Container(
                                      height: 35,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 6),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                            bottomRight: Radius.circular(8),
                                            topRight: Radius.circular(8)),
                                        color: const Color.fromARGB(
                                            255, 237, 237, 237),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Город',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.04,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          const SizedBox(width: 4),
                                          LocationPermissionStatus(
                                            iconSize: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.06,
                                          ),
                                        ],
                                      ));
                                }
                                if (snapshot.hasError || !snapshot.hasData) {
                                  return const Text('Ошибка загрузки городов');
                                }
                                final cities = snapshot.data!;
                                return Container(
                                  height: 35,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                        bottomRight: Radius.circular(8),
                                        topRight: Radius.circular(8)),
                                    color: const Color.fromARGB(
                                        255, 237, 237, 237),
                                  ),
                                  child: Consumer<HomeController>(
                                      builder: (context, newController, _) {
                                    return Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 0, vertical: 0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          GestureDetector(onTap: () async {
                                            final cities = await _citiesFuture;
                                            final result =
                                                await SideSheet.right(
                                              context: context,
                                              width: MediaQuery.sizeOf(context)
                                                  .width,
                                              body: CitySelectionModal(
                                                cities: cities,
                                                selectedCity:
                                                    newController.selectedCity,
                                              ),
                                            );

                                            if (result.first) {
                                              setState(() {
                                                selectedCity = result[1];
                                                newController.selectCity(selectedCity);
                                              });
                                              context.pushReplacementNamed(
                                                  AppRouteNames.navigation,
                                                  extra: {'id': 0});
                                            }
                                          }, child: Consumer<ProfileController>(
                                            builder: (context,
                                                profileController, child) {
                                              final userModeText =
                                                  getUserModeText(
                                                      profileController
                                                          .appChangeNotifier
                                                          .userMode);

                                              return Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  // Text(
                                                  //   'Город: ',
                                                  //   style: TextStyle(
                                                  //       fontSize: 18),
                                                  // ),
                                                  Text(
                                                    newController.selectedCity?.name ?? 'Выберите город',
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.04,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  const SizedBox(width: 4),
                                                  LocationPermissionStatus(
                                                    iconSize:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.06,
                                                  ),
                                                ],
                                              );
                                            },
                                          ))
                                        ],
                                      ),
                                    );
                                  }),
                                );
                              })
                        ],
                      )
                      // GestureDetector(onTap: () async {
                      //   final cities = await AppGeneralRepo().getCities();
                      //   final result = await SideSheet.right(
                      //     context: context,
                      //     width: MediaQuery.sizeOf(context).width,
                      //     body: CitySelectionModal(
                      //       cities: cities,
                      //       selectedCity: newController.selectedCity,
                      //     ),
                      //   );

                      //   if (result.first) {
                      //     setState(() {
                      //       selectedCity = result[1];
                      //     });
                      //     context.pushReplacementNamed(AppRouteNames.navigation,
                      //         extra: {'id': 0});
                      //   }
                      // }, child: Consumer<ProfileController>(
                      //   builder: (context, profileController, child) {
                      //     final userModeText = getUserModeText(
                      //         profileController.appChangeNotifier.userMode);

                      //     return Row(
                      //       children: [
                      //         VerticalDivider(),
                      //         Text(
                      //           newController.selectedCity?.name ?? '',
                      //           style: const TextStyle(color: Colors.black),
                      //         ),
                      //         const SizedBox(width: 4),
                      //         LocationPermissionStatus(),
                      //       ],
                      //     );
                      //   },
                      // )),
                    ],
                  ));
            },
          ),
          centerTitle: false,
        ),
        body: FutureBuilder<Payload?>(
          future: _payloadFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return const Center(child: Text('Error loading data'));
            }

            final payload = snapshot.data;
            return NestedScrollView(
              controller: scrollController,
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        ColoredBox(
                            color: Colors.white,
                            child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 8),
                                child: const GlobalSearchFieldWidget())),
                        HistoryWidget(),
                        _buildCategoryGrid(payload),
                      ],
                    ),
                  ),
                ];
              },
              body: _buildBody(
                  payload, profileController.appChangeNotifier.userMode),
            );
          },
        ),
      );
    });
  }

  Widget _buildCategoryGrid(Payload? payload) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 12),
        child: PageWrapper(
          child: GridView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 6.0,
              mainAxisSpacing: 6.0,
            ),
            children: [
              _GridItem(
                title: 'Спецтехники',
                icon: CustomIcons.specTech,
                onTap: () => _navigateToList(
                    payload, 'MACHINARY', AppRouteNames.adSMList),
              ),
              _GridItem(
                title: 'Оборудование',
                icon: CustomIcons.oborud,
                onTap: () => _navigateToList(
                    payload, 'EQUIPMENT', AppRouteNames.adEquipmentList),
              ),
              _GridItem(
                title: 'Строительные материалы',
                icon: CustomIcons.stroyMater,
                onTap: () => _navigateToList(
                    payload, 'CM', AppRouteNames.adConstructionList),
              ),
              _GridItem(
                title: 'Услуги',
                icon: CustomIcons.uslugi,
                onTap: () => _navigateToList(
                    payload, 'SVM', AppRouteNames.adServiceList),
              ),
            ],
          ),
        ));
  }
  Future<void> _loadSelectedCity() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final cityJson = prefs.getString('selectedCity');

    if (cityJson != null) {
      setState(() {
        selectedCity = City.fromJson(jsonDecode(cityJson)); // ✅ Загружаем город
      });
    }
  }
  Widget _buildBody(Payload? payload, UserMode? userMode) {
    return Consumer<AppChangeNotifier>(
      builder: (context, appChangeNotifier, child) {
        final mode = appChangeNotifier.userMode;

        if (mode == UserMode.client) {
          return Consumer<AdSMListController>(
            builder: (context, adSmController, _) {
              return AdSMListWidget(
                subCategoryId: null,
                subCategoryName: null,
                typeId: null,
                typeName: null,
                showAdditionalAdWidget: true,
                selectedServiceType: adSmController.selectedServiceType.name,
                cityId: selectedCity?.id == 92 ? null : selectedCity?.id,
              );
            },
          );
        } else {
          return Consumer<AdClientListController>(
            builder: (context, adClientController, _) {
              return AdClientListWidget(
                subCategoryId: null,
                subCategoryName: null,
                typeId: null,
                showAdditionalAdWidget: true,
                typeName: null,
                selectedServiceType: ServiceTypeEnum.MACHINARY.name,
                cityId: selectedCity?.id == 92 ? null : selectedCity?.id,
              );
            },
          );
        }
      },
    );
  }

  void _navigateToList(Payload? payload, String serviceType, String routeName) {
    final arguments = {'selectedServiceType': serviceType};
    if (payload == null || payload.aud == 'CLIENT') {
      context.pushNamed(routeName, extra: arguments);
    } else {
      context.pushNamed(routeName.replaceFirst('List', 'ClientList'),
          extra: arguments);
    }
  }
}

class CitySelectionModal extends StatefulWidget {
  final List<City> cities;
  final City? selectedCity;

  const CitySelectionModal(
      {super.key, required this.cities, this.selectedCity});

  @override
  State<CitySelectionModal> createState() => _CitySelectionModalState();
}

class _CitySelectionModalState extends State<CitySelectionModal> {
  late List<City> _filteredCities;
  final TextEditingController _searchController = TextEditingController();
  late String _selectedCity;
  City? selectedCity;

  @override
  void initState() {
    super.initState();
    _filteredCities = widget.cities;
    _selectedCity = widget.selectedCity?.name ?? '';
    _searchController
        .addListener(_searchCities); // Adding listener to the search field
  }

  @override
  void dispose() {
    _searchController.removeListener(_searchCities);
    _searchController.dispose();
    super.dispose();
  }

  // Method for filtering cities based on the search input
  void _searchCities() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredCities = widget.cities
          .where((city) => city.name.toLowerCase().contains(query))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.pop([false, selectedCity]);
          },
        ),
        title: const Text('Выбор города'),
      ),
      body: GestureDetector(
        onHorizontalDragEnd: (details) {
          // Swipe gesture handling
          if (details.primaryVelocity != null && details.primaryVelocity! > 0) {
            // Swipe right
            context.pop([false, selectedCity]);
          }
        },
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    hintText: 'Поиск города',
                    prefixIcon: Icon(Icons.search),
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: _filteredCities.length,
                  itemBuilder: (context, index) {
                    final city = _filteredCities[index];
                    return ListTile(
                      title: Text(city.name),
                      leading: _selectedCity == city.name
                          ? const Icon(Icons.check, color: Colors.green)
                          : null, // Check icon if the city is selected
                      onTap: () async {
                        setState(() {
                          context.read<HomeController>().selectCity(city);
                          _selectedCity = city.name;
                          selectedCity = city;
                        });

                        final SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        prefs.setString('selectedCity', jsonEncode(city?.toJson())); // ✅ Сохранение в память

                        context.pop([true, selectedCity]);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GridItem extends StatelessWidget {
  const _GridItem({
    required this.onTap,
    required this.title,
    required this.icon, // Новый параметр для иконки
  });

  final Function()? onTap;
  final String title;
  final IconData icon; // Добавленный параметр для иконки

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white, // Цвет с прозрачностью
          borderRadius: BorderRadius.circular(16.0), // Скругленные углы
          boxShadow: [
            // BoxShadow(
            //   offset: Offset(-1, -1), // Смещение тени вверх и влево
            //   blurRadius: 1, // Радиус размытия
            //   color: Color.fromRGBO(0, 0 , 0 , 0.3), // Цвет тени
            // ),
            BoxShadow(
              offset: Offset(0, 1), // Смещение тени вниз и вправо
              blurRadius: 1, // Радиус размытия
              color: Color.fromRGBO(0, 0, 0, 0.5), // Цвет тени
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: Icon(
                icon,
                size: 30,
                color: Colors.black,
              ),
            ), // Использование иконки
            Expanded(
              child: Text(
                title,
                style: Theme.of(context)
                    .textTheme
                    .labelLarge
                    ?.copyWith(fontSize: 12, color: Colors.black),
                maxLines: 2,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
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
