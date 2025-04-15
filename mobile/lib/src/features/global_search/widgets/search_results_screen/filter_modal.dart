import 'package:flutter/material.dart';

class FilterModal extends StatefulWidget {
  final Function(Map<String, String>) onApply;
  final Map<String, String> activeFilters;

  const FilterModal(
      {Key? key, required this.onApply, required this.activeFilters})
      : super(key: key);

  @override
  State<FilterModal> createState() => _FilterModalState();
}

String _translateFilter(String key) {
  final Map<String, String> translations = {
    'body_height': 'Высота кузова',
    'lift_height': 'Высота подъема',
    'blade_cutting_depth': 'Глубина реза лезвием',
    'fence_depth': 'Глубина ограждения',
    'grip_depth': 'Глубина захвата',
    'digging_depth': 'Глубина копания',
    'load_capacity': 'Грузоподъемность',
    'air_pressure': 'Давление воздуха',
    'drilling_diameter': 'Диаметр бурения',
    'roller_diameter': 'Диаметр вальца',
    'body_length': 'Длина кузова',
    'platform_length': 'Длина платформы',
    'boom_length': 'Длина стрелы',
    'ground_clearance': 'Дорожный просвет',
    'fuel_tank_capacity': 'Объем топливного бака',
    'number_of_rollers': 'Количество катков',
    'number_of_axles': 'Количество осей',
    'maximum_drilling_depth': 'Максимальная глубина бурения',
    'engine_power': 'Мощность двигателя',
    'voltage': 'Напряжение',
    'bucket_volume': 'Объем ковша',
    'tank_volume': 'Объем бака',
    'operating_pressure': 'Рабочее давление'
  };
  return translations[key] ?? key;
}

class _FilterModalState extends State<FilterModal> {
  final Map<String, TextEditingController> _controllersMin = {};
  final Map<String, TextEditingController> _controllersMax = {};

  @override
  void initState() {
    super.initState();
    final List<String> filters = [
      'body_height',
      'lift_height',
      'blade_cutting_depth',
      'fence_depth',
      'grip_depth',
      'digging_depth',
      'load_capacity',
      'air_pressure',
      'drilling_diameter',
      'roller_diameter',
      'body_length',
      'platform_length',
      'boom_length',
      'ground_clearance',
      'fuel_tank_capacity',
      'number_of_rollers',
      'number_of_axles',
      'maximum_drilling_depth',
      'engine_power',
      'voltage',
      'bucket_volume',
      'tank_volume',
      'operating_pressure'
    ];

    // Инициализация контроллеров для _min и _max
    for (String filter in filters) {
      _controllersMin[filter] = TextEditingController(
          text: widget.activeFilters['${filter}_min'] ?? '');
      _controllersMax[filter] = TextEditingController(
          text: widget.activeFilters['${filter}_max'] ?? '');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Фильтры',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView(
              children: _controllersMin.entries.map((entry) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _translateFilter(entry.key),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          // Поле ввода для min
                          Expanded(
                            child: TextField(
                              controller: _controllersMin[entry.key],
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.grey.shade200,
                                hintText: 'Мин',
                                contentPadding:
                                    const EdgeInsets.symmetric(horizontal: 12),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide.none,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide.none,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          const SizedBox(width: 16),
                          // Поле ввода для max
                          Expanded(
                            child: TextField(
                              controller: _controllersMax[entry.key],
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.grey.shade200,
                                hintText: 'Макс',
                                contentPadding:
                                    const EdgeInsets.symmetric(horizontal: 12),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide.none,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide.none,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              keyboardType: TextInputType.number,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () {
                  // Сброс всех фильтров
                  _controllersMin.forEach((key, controller) {
                    controller.clear();
                  });
                  _controllersMax.forEach((key, controller) {
                    controller.clear();
                  });

                  widget.onApply({});
                  Navigator.of(context).pop();
                },
                child: const Text('Сбросить'),
              ),
              FilledButton(
                style: FilledButton.styleFrom(
                    backgroundColor: Colors.orange,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10))),
                onPressed: () {
                  Map<String, String> filters = {};
                  _controllersMin.forEach((key, controller) {
                    if (controller.text.isNotEmpty) {
                      filters['${key}_min'] = controller.text;
                    }
                  });
                  _controllersMax.forEach((key, controller) {
                    if (controller.text.isNotEmpty) {
                      filters['${key}_max'] = controller.text;
                    }
                  });
                  widget.onApply(filters);
                  Navigator.of(context).pop();
                },
                child: const Text(
                  'Применить',
                  style: TextStyle(color: Colors.white),
                ),
              )
            ],
          )
        ],
      ),
    ));
  }
}
