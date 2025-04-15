import 'package:eqshare_mobile/src/core/presentation/widgets/app_form_field_label.dart';
import 'package:eqshare_mobile/src/features/ad/presentation/widgets/app_location_picker_row_item.dart';
import 'package:flutter/material.dart';

class RequiredTextUpWidgets {
  static Widget categeryText() {
    return const AppInputFieldLabel(text: 'Категория', isRequired: true);
  }

  static Widget subCategeryText() {
    return const AppInputFieldLabel(text: 'Подкатегория', isRequired: true);
  }

  static Widget cityText() {
    return const AppInputFieldLabel(text: 'Город', isRequired: true);
  }
  static Widget brandText() {
    return const AppInputFieldLabel(text: 'Бренд', isRequired: true);
  }

  static Widget headlineOrTitleText() {
    return const AppInputFieldLabel(text: 'Заголовок', isRequired: true);
  }

  static Widget descriptionText() {
    return const AppInputFieldLabel(text: 'Описание', isRequired: true);
  }

  static Widget adressText() {
    return const AppInputFieldLabel(text: 'Адрес объекта', isRequired: true);
  }

  static Widget priceText() {
    return const AppInputFieldLabel(
        text: 'Предлагаемая цена', isRequired: true);
  }

  static Widget pickedAdressWithOpenMap({
    required dynamic Function(Map<String, dynamic>) onLocationSelected,
    String? address
  }) {
    return AppLocationPickerRowItem(
              onLocationSelected: onLocationSelected,
              selectedAddress:  address,
              hintText: 'Выберите адрес объекта',
            );
  }
}
