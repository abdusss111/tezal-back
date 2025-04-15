import 'package:eqshare_mobile/app/app_change_notifier.dart';
import 'package:eqshare_mobile/app/app_safe_change_notifier.dart';
import 'package:eqshare_mobile/src/core/data/repositories/app_general_repo.dart';
import 'package:eqshare_mobile/src/features/auth/data/models/user_model/user_model.dart';
import 'package:eqshare_mobile/src/core/presentation/routing/app_route.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/data/models/cities/city/city_model.dart';


class RegisterCitySelectController extends AppSafeChangeNotifier {
  late Future<List<City>> futureCities;
  late List<City> cities = [];
  City? _selectedCity;

  final appChangeNotifier = AppChangeNotifier();

  String code = '';
  bool itWasCodeMatch = false;

  void changeCode(String value){
    code = value;
    notifyListeners();
  }

    void changeIsMatch(bool value){
    itWasCodeMatch = value;
    notifyListeners();
  }

  City? get selectedCity => _selectedCity;

  set selectedCity(City? newValue) {
    _selectedCity = newValue;
    notifyListeners();
  }

  void setSelectedCity(City? newValue) {
    _selectedCity = newValue;
    notifyListeners();
  }

  void fetchCities() {
    futureCities = AppGeneralRepo().getCities();
    notifyListeners();
  }

  void confirmCity(BuildContext context, User arguments) {
    // Navigator.pushNamed(
    //   context,
    //   AppRouteNames.registerPassword,
    //   arguments: User(
    //     phoneNumber: arguments.phoneNumber,
    //     cityId: _selectedCity?.id ?? -1,
    //   ),
    // );
    context.pushNamed(AppRouteNames.registerPassword,
        extra: User(
          phoneNumber: arguments.phoneNumber,
          cityId: _selectedCity?.id ?? -1,
        ));
  }
}
