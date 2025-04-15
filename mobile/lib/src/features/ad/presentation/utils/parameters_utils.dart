import 'package:flutter/material.dart';

class ParametersUtils {
  static Widget formatParameter(String key, dynamic value) {
    Map<String, String> translations = {
      'body_height': 'Высота кузова',
      'lift_height': 'Высота подъёма',
      'blade_cutting_depth': 'Глубина врезания нож',
      'fence_depth': 'Глубина забора',
      'grip_depth': 'Глубина захвата',
      'digging_depth': 'Глубина копания',
      'load_capacity': 'Грузоподъёмность',
      'air_pressure': 'Давления воздуха',
      'drilling_diameter': 'Диаметр бурения',
      'roller_diameter': 'Диаметр валика',
      'body_length': 'Длина кузова',
      'platform_length': 'Длина платформы',
      'boom_length': 'Длина стрелы',
      'ground_clearance': 'Дорожный просвет',
      'fuel_tank_capacity': 'Емкость топливного бака',
      'number_of_rollers': 'Количество вальцов',
      'number_of_axles': 'Количество осей',
      'maximum_drilling_depth': 'Максимальная глубина бурения',
      'maximum_towable_trailer_mass': 'Максимальная масса буксируемого прицепа',
      'engine_power': 'Мощность двигателя',
      'voltage': 'Напряжение',
      'water_tank_volume': 'Объем водяного бака',
      'bucket_volume': 'Объем ковша',
      'body_volume': 'Объем кузова',
      'tank_volume': 'Объем цистерны',
      'operating_pressure': 'Рабочее давление',
      'unloading_radius': 'Радиус выгрузки',
      'turning_radius': 'Радиус разворота',
      'refrigerator_temperature_min': 'Температура рефрижератора мин',
      'refrigerator_temperature_max': 'Температура рефрижератора макс',
      'temperature_range': 'Температурный диапазон',
      'roller_type': 'Тип катка',
      'body_type': 'Тип кузова',
      'pump_type': 'Тип насоса',
      'platform_type': 'Тип платформы',
      'welding_source_type': 'Тип сварочного источника',
      'undercarriage_type': 'Тип ходовой части',
      'blade_tilt_angle': 'Угол наклона отвала',
      'frequency': 'Частота',
      'roller_width': 'Ширина валика',
      'grip_width': 'Ширина захвата',
      'digging_width': 'Ширина копания',
      'body_width': 'Ширина кузова',
      'platform_width': 'Ширина платформы',
      'unloading_gap_width': 'Ширина разгрузочной щели',
      'laying_width': 'Ширина укладки',
      'milling_width': 'Ширина фрезерования',
    };

    String translatedKey = translations[key] ?? key;

    return characteristicRow(translatedKey, value.toString());
  }

  static Widget characteristicRow(String key, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(key, style: const TextStyle(fontWeight: FontWeight.bold)),
        Text(value),
      ],
    );
  }
}
