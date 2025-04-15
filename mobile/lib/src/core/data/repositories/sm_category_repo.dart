// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;

// import '../../../features/ad/data/models/ad_sm_sub_categories/category.dart';
// import '../services/storage/token_provider_service.dart';
// import '../../../features/ad/data/models/ad_sm_categories/category.dart';
// import 'package:eqshare_mobile/src/core/data/models/category_models/sub_category.dart' as ali;


// Future<List<Category>> getSMCategories() async {
//   final token = await TokenService().getToken();
//   final headers = {'Authorization': 'Bearer $token'};
//   final response = await http.get(
//     Uri.parse('http://206.189.109.61:8777/category'),
//     headers: headers,
//   );
//   debugPrint(response.body.toString());

//   if (response.statusCode == 200) {
//     final List<dynamic> categoriesJson =
//         json.decode(response.body)['categories'];
//     final List<Category> categories = [];
//     for (var categoryJson in categoriesJson) {
//       final categoryName = utf8.decode(categoryJson['name'].runes.toList());
//       categories.add(Category(id: categoryJson['id'], name: categoryName));
//     }
//     return categories;
//   } else {
//     throw Exception('Не удалось загрузить категории.');
//   }
// }

// Future<List<SubCategory>> getSMSubCategories(String categoryId) async {
//   final token = await TokenService().getToken();
//   final headers = {'Authorization': 'Bearer $token'};
//   final response = await http.get(
//     Uri.parse('http://206.189.109.61:8777/$categoryId/sub_category'),
//     headers: headers,
//   );

//   debugPrint(response.body.toString());

//   if (response.statusCode == 200) {
//     final List<dynamic> categoriesJson =
//         json.decode(response.body)['categories'];
//     final List<SubCategory> categories = [];
//     for (var categoryJson in categoriesJson) {
//       final categoryName = utf8.decode(categoryJson['name'].runes.toList());
//       categories.add(SubCategory(id: categoryJson['id'], name: categoryName));
//     }
//     return categories;
//   } else {
//     throw Exception('Не удалось загрузить подкатегории.');
//   }
// }



// Future<List<ali.SubCategory>> aliGetSMSubCategories(String categoryId) async {
//   final token = await TokenService().getToken();
//   final headers = {'Authorization': 'Bearer $token'};
//   final response = await http.get(
//     Uri.parse('http://206.189.109.61:8777/$categoryId/sub_category'),
//     headers: headers,
//   );

//   debugPrint(response.body.toString());

//   if (response.statusCode == 200) {
//     final List<dynamic> categoriesJson =
//         json.decode(response.body)['categories'];
//     final List<ali.SubCategory> categories = [];
//     for (var categoryJson in categoriesJson) {
//       final categoryName = utf8.decode(categoryJson['name'].runes.toList());
//       categories.add(ali.SubCategory(id: categoryJson['id'], name: categoryName));
//     }
//     return categories;
//   } else {
//     throw Exception('Не удалось загрузить подкатегории.');
//   }
// }
