



import 'package:eqshare_mobile/src/core/data/models/cities/city/city_model.dart';
import 'package:eqshare_mobile/src/core/presentation/widgets/app_generic_dropdown_search.dart';

import 'package:flutter/material.dart';

class CitiesDropDownButtonWithSearch extends StatelessWidget {
  final City? selectedCity;
  final void Function(City?) onChanged;
  final  Future<List<City>>? future;
  
  const CitiesDropDownButtonWithSearch(
      {super.key, required this.selectedCity, required this.onChanged,
      required this.future});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<City>>(
      future: future,
      builder: (context, snapshot) {
        final cities = snapshot.data;
        if(snapshot.connectionState == ConnectionState.waiting){
           if (snapshot.connectionState == ConnectionState.waiting) {
          return AppGenericDropdownSearch<City>(
            enabled: false,
            items: const [],
            selectedItem: selectedCity,
            onChanged: ( value) {},
            itemAsString: ( value) => value.name,
            hintText: 'Выберите город...',
          );
        }
        }
        if(cities == null || cities.isEmpty){
          return const Text('Повторите позже!');
        }
        return AppGenericDropdownSearch<City>(
          enabled: !snapshot.hasError,
          items: cities,
          selectedItem: selectedCity,
          onChanged: onChanged,
          itemAsString: (city) => city.name,
          hintText: 'Введите название города...',
        );
      },
    );
  }
}
