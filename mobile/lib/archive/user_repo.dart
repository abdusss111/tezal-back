// import 'package:dio/dio.dart';

// import 'main_api_client.dart';
// import '../src/domain/services/storage/secure_storage_client.dart';
// import '../src/data/models/tokens/tokens_model.dart';
// import '../src/data/models/user_auth/user_auth_model.dart';

// class UserRepository {
//   final _apiClient = ApiClient();
//   final _storage = SecureStorageClient.getInstance;

//   Future<bool> hasToken() async {
//     final value = await _storage.read(key: "accessToken");
//     if (value != null) {
//       return true;
//     } else {
//       return false;
//     }
//   }

//   Future<void> persistToken(Tokens tokens) async {
//     await _storage.write(key: 'accessToken', value: tokens.accessToken);
//     await _storage.write(key: 'refreshToken', value: tokens.refreshToken);
//   }

//   Future<void> deleteToken() async {
//     _storage.delete(key: 'accessToken');
//     _storage.delete(key: 'refreshToken');
//     _storage.deleteAll();
//   }

//   Future<UserAuth> login(String phoneNumber, String password) async {
//     Response response = await _apiClient.api.post("/signin", data: {
//       "phone_number": phoneNumber,
//       "password": password,
//     });
//     return UserAuth.fromJson(response.data);
//   }

//   Future<UserAuth> register(
//     String phoneNumber,
//     String password,
//     String cityId,
//   ) async {
//     Response response = await _apiClient.api.post("/signup", data: {
//       "phone_number": phoneNumber,
//       "password": password,
//       "city_id": cityId,
//     });
//     return UserAuth.fromJson(response.data);
//   }

//   // Future<User> getUserProfile() async {
//   //   final response = await _apiClient.api.get("/auth/login/profile");
//   //   if (response.statusCode == 200) {
//   //     print(response.data);
//   //     return User.fromJson(response.data);
//   //   } else {
//   //     throw Exception("Failed to load user");
//   //   }
//   // }
// }
