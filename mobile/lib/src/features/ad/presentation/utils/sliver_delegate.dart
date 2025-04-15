import 'package:flutter/material.dart';

class SliverDelegate {
  SliverGridDelegateWithFixedCrossAxisCount
      sliverGridDelegateWithFixedCrossAxisCount() {
    return const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // Количество колонок
        crossAxisSpacing: 6, // Расстояние между колонками
        mainAxisSpacing: 6, // Расстояние между строками
        childAspectRatio: 0.90);
  }

  SliverGridDelegateWithFixedCrossAxisCount sliverForLitle() {
    return const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2, // Количество элементов в одном ряду
      mainAxisSpacing: 5.0, // Расстояние между строками
      crossAxisSpacing: 7.0, // Расстояние между элементами
      childAspectRatio: 0.45, // Соотношение сторон элементов
    );
  }

 
}
