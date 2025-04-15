import 'package:eqshare_mobile/src/core/data/models/cities/city/city_model.dart';
import 'package:eqshare_mobile/src/core/presentation/widgets/app_generic_dropdown_search.dart';
import 'package:flutter/material.dart';

class CityDropdownWidget extends StatelessWidget {
  final List<City> cities;
  final City? selectedCity;
  final ValueChanged<City?> onChanged;

  const CityDropdownWidget({
    super.key,
    required this.cities,
    required this.selectedCity,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return AppGenericDropdownSearch<City>(
      enabled: true,
      items: cities,
      selectedItem: selectedCity,
      onChanged: onChanged,
      itemAsString: (City city) => city.name,
      hintText: 'Введите название города...',
    );
  }
}
