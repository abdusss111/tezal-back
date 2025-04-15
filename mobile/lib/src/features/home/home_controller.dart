import 'dart:convert';
import 'dart:developer';
import 'package:eqshare_mobile/app/app_safe_change_notifier.dart';
import 'package:eqshare_mobile/src/core/data/models/category_models/category.dart';
import 'package:eqshare_mobile/src/core/data/models/cities/city/city_model.dart';
import 'package:eqshare_mobile/src/features/ad/data/repository/ad_api_client.dart';
import 'package:eqshare_mobile/app/app_change_notifier.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeController extends AppSafeChangeNotifier {
  final _adApiClient = AdApiClient();
  final _categories = <Category>[];
  List<Category> get categories => List.unmodifiable(_categories.toList());

  bool isLoadingInProgres = false;
  bool isLoading = true;
  bool isContentEmpty = false;

  City? _selectedCity;
  City? get selectedCity => _selectedCity;

  final appChangeNotifier = AppChangeNotifier();

  /// ✅ Конструктор загружает категории и город
  HomeController() {
    setUp(); // Загрузка города и категорий
  }

  /// ✅ ГЛАВНЫЙ метод для загрузки данных
  Future<void> setUp() async {
    await _loadSelectedCity();
    await setupCategories();
  }

  /// ✅ Выбор города и его сохранение
  Future<void> selectCity(City? city) async {
    _selectedCity = city;
    print('📍 Город выбран: ${city?.name}, ID: ${city?.id}');

    notifyListeners();

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('selectedCity', jsonEncode(city?.toJson())); // ✅ Сохранение в память
  }

  /// ✅ Загрузка сохраненного города при запуске
  Future<void> _loadSelectedCity() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final cityJson = prefs.getString('selectedCity');

    if (cityJson != null) {
      _selectedCity = City.fromJson(jsonDecode(cityJson));
      print('Загруженный город: ${_selectedCity?.name}, ID: ${_selectedCity?.id}');

    } else {
      _selectedCity = City(
        name: 'Казахстан',
        id: 92,
        latitude: 34.082,
        longitude: 33.023,
      );
    }

    notifyListeners(); // ✅ Обновляем UI
  }

  /// ✅ Загрузка категорий
  Future<List<Category>> _loadCategories() async {
    isLoadingInProgres = true;

    final categoriesResponse = await _adApiClient.getSMCategoryList();
    log(categoriesResponse?.toString() ?? '');
    if (categoriesResponse != null) {
      _categories.clear();
      _categories.addAll(categoriesResponse);
      notifyListeners();

      isContentEmpty = _categories.isEmpty;
      isLoadingInProgres = false;
    }
    return _categories;
  }

  /// ✅ Запуск загрузки категорий
  Future<List<Category>> setupCategories() async {
    isLoading = true;
    isContentEmpty = false;
    appChangeNotifier.checkConnectivity();

    return await _loadCategories();
  }
}
