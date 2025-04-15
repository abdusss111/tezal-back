import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/data/models/cities/city/city_model.dart';

class CityPickerModal extends StatefulWidget {
  final List<City> cities;
  final Function(City) onSelect;
  final City? selectedCity;
  final int? selectedCityId;

  const CityPickerModal({
    required this.cities,
    required this.onSelect,
    this.selectedCity,
    this.selectedCityId,
  });

  @override
  State<CityPickerModal> createState() => _CityPickerModalState();
}

class _CityPickerModalState extends State<CityPickerModal> {
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    // Фильтрация списка городов
    final filteredCities = widget.cities
        .where((city) => city.name.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(widget.selectedCity?.name ?? 'Выберите город'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Поле ввода для поиска
            TextField(
              decoration: InputDecoration(
                hintText: 'Поиск города...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey.shade200,
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value.trim();
                });
              },
            ),
            const SizedBox(height: 16),
            // Список городов
            Expanded(
              child: ListView.builder(
                itemCount: filteredCities.length,
                itemBuilder: (context, index) {
                  final city = filteredCities[index];
                  return ListTile(
                    title: Text(city.name),
                    trailing: widget.selectedCity?.id == city.id
                        ? const Icon(Icons.check, color: Colors.orange)
                        : null,
                    onTap: () async {
                      // ✅ Сохраняем город в память
                      final SharedPreferences prefs = await SharedPreferences.getInstance();
                      prefs.setString('selectedCity', jsonEncode(city.toJson()));

                      // ✅ Обновляем UI в HomeController
                      widget.onSelect(city);

                      // ✅ Закрываем модальное окно и передаем новый город
                      Navigator.pop(context, city);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
