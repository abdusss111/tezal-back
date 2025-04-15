import 'dart:convert';

import 'package:eqshare_mobile/src/core/presentation/widgets/app_circular_progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../../core/presentation/widgets/app_primary_button.dart';
import '../../../../../core/data/models/cities/city/city_model.dart';
import '../../../data/models/models.dart';
import '../../widgets/register/city_dropdown_widget.dart';
import '../../controllers/register/register_city_select_controller.dart';

class RegisterCitySelectScreen extends StatefulWidget {
  final User user;
  const RegisterCitySelectScreen({super.key, required this.user});

  @override
  State<RegisterCitySelectScreen> createState() =>
      _RegisterCitySelectScreenState();
}

class _RegisterCitySelectScreenState extends State<RegisterCitySelectScreen> {
  final RegisterCitySelectController controller =
      RegisterCitySelectController();

  @override
  void initState() {
    super.initState();
    controller.fetchCities();
    initPreferense();
  }

  void initPreferense() async {
    preferences = await SharedPreferences.getInstance();
  }

  late final SharedPreferences preferences;

  @override
  Widget build(BuildContext context) {
    // final arguments = ModalRoute.of(context)!.settings.arguments as User;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Выбор города'),
        leading: IconButton(
          // onPressed: () => Navigator.pop(context),
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              'Выберите ваш город',
              style: Theme.of(context)
                  .textTheme
                  .labelLarge
                  ?.copyWith(fontSize: 22),
              textAlign: TextAlign.center,
            ),
            _buildCityDropdown(),
            AppPrimaryButtonWidget(
              onPressed: () => controller.confirmCity(context, widget.user),
              text: 'Далее',
              textColor: Colors.white,
              icon: Icons.arrow_forward_ios_outlined,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCityDropdown() {
    return FutureBuilder<List<City>>(
      future: controller.futureCities,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const AppCircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        } else {
          controller.cities = snapshot.data!;
          if (controller.selectedCity == null && controller.cities.isNotEmpty) {
            controller.setSelectedCity(controller.cities[0]);
          }
          return CityDropdownWidget(
            cities: controller.cities,
            selectedCity: controller.selectedCity,
            onChanged: (City? city) {
              setState(() {
                controller.setSelectedCity(
                  controller.cities.singleWhere((e) => e.name == city?.name),
                );
                preferences.setString(
                    'selectedCity', jsonEncode(city?.toJson()));
              });
            },
          );
        }
      },
    );
  }
}
