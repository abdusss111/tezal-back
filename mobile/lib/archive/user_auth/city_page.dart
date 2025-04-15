import 'package:eqshare_mobile/src/core/data/repositories/app_general_repo.dart';


import 'package:eqshare_mobile/src/core/presentation/widgets/app_primary_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../src/core/data/models/cities/city/city_model.dart';
import '../../src/core/presentation/routing/app_route.dart';
import '../../src/core/presentation/widgets/app_circular_progress_indicator.dart';

class CitySelectPage extends StatefulWidget {
  const CitySelectPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CitySelectPageState createState() => _CitySelectPageState();
}

class _CitySelectPageState extends State<CitySelectPage> {
  late Future<List<City>> futureCities;
  late List<City> cities = [];
  City? _selectedCity;
  late final SharedPreferences prefs;

  @override
  void initState() async {
    super.initState();
    futureCities = AppGeneralRepo().getCities();
    initPref();
  }

  void initPref() async{
    prefs = await SharedPreferences.getInstance();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Регистрация',
          style: TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            // Navigator.pop(context);
            context.pop();
          },
          icon: const Icon(
            Icons.arrow_back_ios_new,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
             Text(
              'Выберите ваш город',
              style: Theme.of(context).textTheme.displayLarge,
              textAlign: TextAlign.center,
            ),
            FutureBuilder<List<City>>(
              future: futureCities,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const AppCircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                } else {
                  cities = snapshot.data!;
                  if (_selectedCity == null && cities.isNotEmpty) {
                    _selectedCity = cities[0];
                  }
                  return Padding(
                    padding: const EdgeInsets.all(26.0),
                    child: Center(
                      child: DropdownButton<City>(
                        borderRadius: BorderRadius.circular(10),
                        isExpanded: true,
                        hint: const Text(
                          'Город',
                        ),
                        value: _selectedCity,
                        onChanged: (City? newValue) {
                          if (newValue != null) {
                            setState(() {
                              prefs.setString(
                                  'selectedCity', newValue.toString());
                              _selectedCity = newValue;
                            });
                          }
                        },
                        items: cities.map<DropdownMenuItem<City>>((City city) {
                          return DropdownMenuItem<City>(
                            alignment: Alignment.center,
                            value: city,
                            child: Text(city.name),
                          );
                        }).toList(),
                      ),
                    ),
                  );
                }
              },
            ),
            AppPrimaryButtonWidget(
              onPressed: () {
                context.go(
                  '/${AppRouteNames.navigation}',
                );
              },
              text: 'Далее',
              icon: Icons.arrow_forward_ios_outlined,
            ),
          ],
        ),
      ),
    );
  }
}
