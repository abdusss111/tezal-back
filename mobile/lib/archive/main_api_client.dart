// import 'package:dio/dio.dart';
// import 'package:flutter/foundation.dart';

// import '../src/data/models/tokens/tokens_model.dart';
// import '../src/domain/services/storage/secure_storage_client.dart';

// class ApiClient {
//   Dio api = Dio();
//   String? accessToken;
//   final _storage = SecureStorageClient.getInstance;

//   String baseUrl = "http://206.189.109.61:8777";

//   ApiClient() {
//     api.interceptors.add(InterceptorsWrapper(
//       onRequest: (options, handler) async {
//         if (!options.path.contains('http')) {
//           options.path = baseUrl + options.path;
//         }
//         if (options.path != "$baseUrl/auth/login" ||
//             !options.path.contains("registration")) {
//           if (kDebugMode) {
//             print("Path - ${options.path}");
//           }
//           final token = await _storage.read(key: "accessToken");
//           if (kDebugMode) {
//             print("Access token - $token");
//           }
//           options.headers['Authorization'] = 'Bearer $token';
//         }
//         return handler.next(options);
//       },
//       onError: (e, handler) async {
//         if (e.response?.statusCode != 200 &&
//             e.response?.data['message'] == 'Invalid token!') {
//           if (await _storage.containsKey(key: "refreshToken")) {
//             await refreshToken();
//             return handler.resolve(await _retry(e.requestOptions));
//           }
//         }
//         return handler.next(e);
//       },
//     ));
//   }

//   Future<Response<dynamic>> _retry(RequestOptions requestOptions) async {
//     final options =
//         Options(method: requestOptions.method, headers: requestOptions.headers);
//     return api.request<dynamic>(requestOptions.path,
//         data: requestOptions.data,
//         queryParameters: requestOptions.queryParameters,
//         options: options);
//   }

//   Future<void> refreshToken() async {
//     final refreshToken = await _storage.read(key: 'refreshToken');
//     if (kDebugMode) {
//       print("Refresh token - $refreshToken");
//     }
//     final response =
//         await api.post("/refresh", data: {'Authorization ': refreshToken});
//     if (response.statusCode == 200) {
//       final newAccessToken =
//           Tokens.fromJson(response.data["refresh"]).accessToken;
//       final newRefreshToken =
//           Tokens.fromJson(response.data["refresh"]).refreshToken;
//       if (kDebugMode) {
//         print("New access token - $newAccessToken");
//       }
//       if (kDebugMode) {
//         print("New refresh token - $newRefreshToken");
//       }
//       await _storage.write(key: "accessToken", value: newAccessToken);
//       await _storage.write(key: "refreshToken", value: newRefreshToken);
//     } else {
//       accessToken = null;
//       _storage.deleteAll();
//     }
//   }
// }
