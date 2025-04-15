import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:eqshare_mobile/src/features/main/chats/chats_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';
import 'package:flutter/cupertino.dart';

import 'package:http/http.dart' as http;

import '../../../../res/api_endpoints/api_endpoints.dart';
import '../../storage/token_provider_service.dart';

class NetworkClient {
  // Future<T?> get<T>(
  //   BuildContext context, {
  //   required String path,
  //   Map<String, dynamic>? queryParams,
  //   required T Function(Map<String, dynamic>) fromJson,
  // }) async {
  //   return _getResponse(path, queryParams, fromJson, context);
  // }

  // static final Map<String, http.Response> _cache = {};

  Future<Map<String, String>> _getAuthHeaders() async {
    final token = await TokenService().getToken();
    log(token.toString());
    return {'Authorization': 'Bearer $token'};
  }

  // Future<T?> _getResponse<T>(
  //   String path,
  //   Map<String, dynamic>? queryParams,
  //   T Function(Map<String, dynamic>) fromJson,
  //   BuildContext context,
  // ) async {
  //   final headers = await _getAuthHeaders();
  //   try {
  //     final Uri uri = Uri.parse(ApiEndPoints.baseUrl + path);
  //     final Uri uriWithQuery = uri.replace(queryParameters: queryParams);

  //     final response = await http.get(
  //       uriWithQuery,
  //       headers: headers,
  //     );

  //     log(response.toString(), name: 'Response  NetWorkClient :');
  //     // log(response.body, name: 'Response  NetWorkClient :');

  //     // debugPrint(response.body.toString());

  //     // debugPrint(response.body.toString());
  //     // debugPrint(response.statusCode.toString());
  //     // if (!context.mounted) return null;
  //     return _processResponse<T>(response, fromJson, context);
  //   } on SocketException catch (_) {
  //     if (!context.mounted) return null;

  //     _showNetworkErrorDialog(context);
  //   } catch (e) {
  //     if (!context.mounted) return null;

  //     _handleError(e, context);
  //   }
  //   return null;
  // }

  // T? _processResponse<T>(
  //   http.Response response,
  //   T Function(Map<String, dynamic>) fromJson,
  //   BuildContext context,
  // ) {
  //   debugPrint(response.statusCode.toString());
  //   debugPrint(response.request?.url.toString() ?? 'dada');

  //   if (response.statusCode == 200) {
  //     final dynamic json = jsonDecode(utf8.decode(response.bodyBytes));
  //     final result = _parseResponse<T>(json, fromJson);
  //     return result;
  //   } else if (response.statusCode == 204 || response.statusCode == 500) {
  //     return null;
  //   } else if (response.statusCode == 401) {
  //     context.pushNamed(AppRouteNames.login);
  //     // Navigator.pushNamed(context, AppRouteNames.login);
  //     return null;
  //   } else {
  //     _showErrorSnackbar(
  //         context, 'Error ${response.statusCode}', 'An error occurred');
  //     return null;
  //   }
  // }

  T _parseResponse<T>(dynamic json, T Function(Map<String, dynamic>) fromJson) {
    final jsonMap = json as Map<String, dynamic>;
    return fromJson(jsonMap);
  }

  // void _handleError(dynamic e, BuildContext context) {
  //   debugPrint(e.toString());

  // }

  // Future<http.Response?> post<T>(
  //   String path,
  //   BuildContext context,
  //   Map<String, dynamic> body, [
  //   Map<String, String>? headers,
  // ]) async {
  //   final url = Uri.parse(ApiEndPoints.baseUrl + path);
  //   final authHeaders = await _getAuthHeaders();
  //   final defaultHeaders = {'Content-Type': 'application/json'};
  //   final requestHeaders = headers != null
  //       ? {...authHeaders, ...defaultHeaders, ...headers}
  //       : {...authHeaders, ...defaultHeaders};
  //   try {
  //     debugPrint(url.toString());
  //     log(requestHeaders.toString(), name: 'Reaquest Headers:');

  //     final response = await http.post(
  //       url,
  //       body: jsonEncode(body),
  //       headers: requestHeaders,
  //     );
  //     debugPrint('body: ${response.body.toString()}');
  //     //if (!context.mounted) return null;

  //     return _processHttpResponse(response, context);
  //   } catch (e) {
  //     if (!context.mounted) return null;

  //     _handleError(e, context);
  //   }
  //   return null;
  // }

  Future<http.Response?> aliPost<T>(
    String path,
    Map<String, dynamic> body, [
    Map<String, String>? headers,
  ]) async {
    final url = Uri.parse(ApiEndPoints.baseUrl + path);
    final authHeaders = await _getAuthHeaders();
    final defaultHeaders = {'Content-Type': 'application/json'};
    final requestHeaders = headers != null
        ? {...authHeaders, ...defaultHeaders, ...headers}
        : {...authHeaders, ...defaultHeaders};
    try {
      debugPrint(url.toString());
      log(requestHeaders.toString(), name: 'Reaquest Headers:');

      final response = await http.post(
        url,
        body: jsonEncode(body),
        headers: requestHeaders,
      );
      debugPrint('body: ${response.body.toString()}');
      //if (!context.mounted) return null;

      return _alipProcessHttpResponse(response);
    } catch (e) {
      log(e.toString(), name: 'Error on postc :');
    }
    return null;
  }

  // Future<http.Response?> patch({
  //   required String path,
  //   required File imageFile,
  //   required BuildContext context,
  // }) async {
  //   final url = Uri.parse(ApiEndPoints.baseUrl + path);
  //   final mimeTypeData = lookupMimeType(imageFile.path)?.split('/');

  //   if (mimeTypeData == null) {
  //     _showErrorSnackbar(context, 'Error', 'Invalid file type');
  //     return null;
  //   }

  //   final imageUploadRequest = http.MultipartRequest('PATCH', url);
  //   final file = await http.MultipartFile.fromPath(
  //     'foto',
  //     imageFile.path,
  //     contentType: MediaType(mimeTypeData[0], mimeTypeData[1]),
  //   );

  //   imageUploadRequest.files.add(file);

  //   final token = await TokenService().getToken();
  //   imageUploadRequest.headers['Authorization'] = 'Bearer $token';

  //   try {
  //     final streamedResponse = await imageUploadRequest.send();
  //     final response = await http.Response.fromStream(streamedResponse);
  //     //if (!context.mounted) return null;

  //     return _processHttpResponse(response, context);
  //   } catch (e) {
  //     if (!context.mounted) return null;

  //     _handleError(e, context);
  //   }
  //   return null;
  // }

  Future<http.Response?> aliPatchWithBody({
    required String path,
    required Map<String, dynamic> map,
  }) async {
    final url = Uri.parse(ApiEndPoints.baseUrl + path);

    final token = await TokenService().getToken();
    final Map<String, String> headers = {};
    headers['Authorization'] = 'Bearer $token';

    try {
      final response = await http.patch(url, body: map, headers: headers);

      return _alipProcessHttpResponse(response);
    } catch (e) {
      log(e.toString(), name: 'Errors on patch : ');
    }
    return null;
  }

  Future<http.Response?> aliPatch({
    required String path,
    required File imageFile,
  }) async {
    final url = Uri.parse(ApiEndPoints.baseUrl + path);
    final mimeTypeData = lookupMimeType(imageFile.path)?.split('/');

    if (mimeTypeData == null) {
      return null;
    }

    final imageUploadRequest = http.MultipartRequest('PATCH', url);
    final file = await http.MultipartFile.fromPath(
      'foto',
      imageFile.path,
      contentType: MediaType(mimeTypeData[0], mimeTypeData[1]),
    );

    imageUploadRequest.files.add(file);

    final token = await TokenService().getToken();
    imageUploadRequest.headers['Authorization'] = 'Bearer $token';

    try {
      final streamedResponse = await imageUploadRequest.send();
      final response = await http.Response.fromStream(streamedResponse);
      //if (!context.mounted) return null;

      return _alipProcessHttpResponse(response);
    } catch (e) {
      log(e.toString(), name: 'Errors on patch : ');
    }
    return null;
  }

  // Future<http.Response?> put(
  //   String path,
  //   BuildContext context,
  //   Map<String, dynamic>? body, {
  //   Map<String, String>? headers,
  //   bool isJson = false, // Default to false
  // }) async {
  //   final url = Uri.parse(ApiEndPoints.baseUrl + path);
  //   final authHeaders = await _getAuthHeaders();
  //   final defaultHeaders = {'Content-Type': 'application/json'};
  //   final requestHeaders = headers != null
  //       ? {...authHeaders, ...defaultHeaders, ...headers}
  //       : {...authHeaders, ...defaultHeaders};
  //   try {
  //     final response = await http.put(
  //       url,
  //       body: body != null ? jsonEncode(body) : null,
  //       headers: requestHeaders,
  //     );
  //     if (!context.mounted) return null;

  //     return _processHttpResponse(response, context);
  //   } catch (e) {
  //     if (!context.mounted) return null;

  //     _handleError(e, context);
  //   }
  //   return null;
  // }

  Future<http.Response?> aliPut(
    String path,
    Map<String, dynamic>? body, {
    Map<String, String>? headers,
    bool isJson = false,
  }) async {
    final url = Uri.parse(ApiEndPoints.baseUrl + path);
    final authHeaders = await _getAuthHeaders();
    final defaultHeaders = {'Content-Type': 'application/json'};
    final requestHeaders = headers != null
        ? {...authHeaders, ...defaultHeaders, ...headers}
        : {...authHeaders, ...defaultHeaders};

    try {
      // Log the request details
      log('Sending PUT request to: $url');
      log('Headers: ${jsonEncode(requestHeaders)}');
      log('Body: ${jsonEncode(body)}');

      final response = await http.put(
        url,
        body: body != null ? jsonEncode(body) : null,
        headers: requestHeaders,
      );



      // Log the response details
      log('Response status: ${response.statusCode}');
      log('Response body: ${response.body}');

      return _alipProcessHttpResponse(response);
    } catch (e) {
      log('Error during PUT request: $e', name: 'NetworkClient');
    }
    return null;
  }
  // Future<http.Response?> delete(
  //   String path,
  //   BuildContext context,
  // ) async {
  //   final url = Uri.parse(ApiEndPoints.baseUrl + path);
  //   final headers = await _getAuthHeaders();
  //   try {
  //     final response = await http.delete(
  //       url,
  //       headers: headers,
  //     );
  //     if (!context.mounted) return null;

  //     return _processHttpResponse(response, context);
  //   } catch (e) {
  //     if (!context.mounted) return null;

  //     _handleError(e, context);
  //   }
  //   return null;
  // }

  Future<http.Response?> aliDelete(
    String path,
  ) async {
    final url = Uri.parse(ApiEndPoints.baseUrl + path);
    final headers = await _getAuthHeaders();
    try {
      final response = await http.delete(
        url,
        headers: headers,
      );

      return _alipProcessHttpResponse(response);
    } catch (e) {
      log(e.toString(), name: 'Error on delete :');
      rethrow;
    }
  }

  // http.Response? _processHttpResponse(
  //     http.Response response, BuildContext context) {
  //   debugPrint(response.statusCode.toString());
  //   debugPrint(response.body.toString());
  //   if (response.statusCode == 200) {
  //     return response;
  //   } else if (response.statusCode == 204) {
  //     return response;
  //   } else if (response.statusCode == 403) {
  //     return response;
  //   } else if (response.statusCode == 401) {
  //     context.pushNamed(AppRouteNames.login);
  //     // Navigator.pushNamed(context, AppRouteNames.login);
  //     return response;
  //   } else if (response.statusCode == 500) {
  //     return response;
  //   } else {
  //     _showErrorSnackbar(
  //         context, 'Error ${response.statusCode}', 'An error occurred');
  //     return null;
  //   }
  // }

  http.Response? _alipProcessHttpResponse(http.Response response) {
    if (kDebugMode) {
      log((response.request?.url ?? 'null uri').toString(),
          name: ' ${response.request?.method} url : ');

      log(response.statusCode.toString(),
          name: '${response.request?.method} Status code: ');
      log(response.body.toString(), name: 'Response body ');
    }

    if (response.statusCode == 200) {
      return response;
    } else if (response.statusCode == 204) {
      return response;
    } else if (response.statusCode == 403) {
      return response;
    } else if (response.statusCode == 401) {
      return response;
    } else if (response.statusCode == 500) {
      return response;
    } else {
      log('Error ${response.statusCode}', name: 'An error occurred');
      return null;
    }
  }

  Future<T?> aliGet<T>({
    required String path,
    Map<String, dynamic>? queryParams,
    required T Function(Map<String, dynamic>) fromJson,
  }) async {
    return _aliGetResponse(path, queryParams, fromJson);
  }

  Future<T?> _aliGetResponse<T>(String path, Map<String, dynamic>? queryParams,
      T Function(Map<String, dynamic>) fromJson) async {
    final headers = await _getAuthHeaders();

    try {
      final Uri uri = Uri.parse(ApiEndPoints.baseUrl + path);
      final Uri uriWithQuery = uri.replace(queryParameters: queryParams);
      final response = await http.get(
        uriWithQuery,
        headers: headers,
      );
      print('ADSMRESPONSE $response');
      print('ADSMURIWITHQUERY $uriWithQuery');

 log('Response Status Code (aliGet2): ${response.statusCode}', name: 'GET Response');
    log('Response Body (aliGet2): ${utf8.decode(response.bodyBytes)}', name: 'Response Body');      // _cache[cacheKey] = response;

      return _aliProcessResponse<T>(response, fromJson);
    } on SocketException catch (_) {
      log(_.toString(), name: 'Error on SocketException getResponse');
      return null;
    } on TimeoutException catch (e) {
      log(e.toString(),
          name: 'TimeoutException on SocketException getResponse');
      return null;
    } catch (e) {
      log(e.toString(), name: 'Error on getResponse');
      return null;
    }
  }

  T? _aliProcessResponse<T>(
      http.Response response, T Function(Map<String, dynamic>) fromJson) {
    log(response.statusCode.toString(), name: ' Network status code: ');
    log('${response.request?.url.toString()}', name: 'url ');
    if (response.statusCode != 200) {
      log(response.body, name: 'Response body');
    }
    if (response.statusCode == 200) {
      final dynamic json = jsonDecode(utf8.decode(response.bodyBytes));
      final result = _parseResponse<T>(json, fromJson);
      return result;
    } else if (response.statusCode == 204 || response.statusCode == 500) {
      return null;
    } else if (response.statusCode == 401) {
      return null;
    } else {
      return null;
    }
  }

  Future<T?> aliGet2<T>({
    required String path,
    Map<String, dynamic>? queryParams,
    required T Function(dynamic) fromJson,
  }) async {
    return _aliGetResponse2(path, queryParams, fromJson);
  }
  Future<List<NotificationMessage>?> aliGet3(
      String path, {
        Map<String, String>? headers,
        required List<NotificationMessage> Function(dynamic) fromJson,
      }) async {
    final url = Uri.parse(ApiEndPoints.baseUrl + path);
    final authHeaders = await _getAuthHeaders();
    final defaultHeaders = {'Content-Type': 'application/json'};
    final requestHeaders = headers != null
        ? {...authHeaders, ...defaultHeaders, ...headers}
        : {...authHeaders, ...defaultHeaders};

    try {
      debugPrint('Request URL: $url');
      debugPrint('Request Headers: $requestHeaders');

      // Отправляем GET-запрос
      final response = await http.get(url, headers: requestHeaders);
      debugPrint('Response Status: ${response.statusCode}');
      debugPrint('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final dynamic responseBody = jsonDecode(utf8.decode(response.bodyBytes));

        // Проверяем, что ответ - это Map<String, dynamic>
        if (responseBody is Map<String, dynamic>) {
          // Извлекаем access_role и notifications
          final String? accessRole = responseBody['access_role'];
          final List<dynamic>? notificationsJson = responseBody['notifications'];

          debugPrint('User Role: $accessRole');

          if (notificationsJson == null) {
            debugPrint('Notifications отсутствуют в ответе');
            return [];
          }

          // Преобразуем список в List<NotificationMessage>
          List<NotificationMessage> notifications = notificationsJson
              .map((item) => NotificationMessage.fromJson(
            item as Map<String, dynamic>,
            accessRole: accessRole ?? 'UNKNOWN', // Добавляем обязательный параметр
          ))
              .toList();

          return notifications;
        } else {
          debugPrint('Unexpected response structure: Expected Map but got ${responseBody.runtimeType}');
          return [];
        }
      } else {
        debugPrint('Error: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      debugPrint('Request failed: $e');
      return [];
    }
  }

  Future<T?> _aliGetResponse2<T>(
    String path,
    Map<String, dynamic>? queryParams,
    T Function(dynamic) fromJson, // Updated to accept dynamic
  ) async {
    final headers = await _getAuthHeaders();

    try {
      final Uri uri = Uri.parse(ApiEndPoints.baseUrl + path);
      final Uri uriWithQuery = uri.replace(queryParameters: queryParams);

      final response = await http.get(
        uriWithQuery,
        headers: headers,
      );

      // Process the response
      return _aliProcessResponse2<T>(response, fromJson);
    } on SocketException catch (_) {
      log(_.toString(), name: 'Error on SocketException getResponse');
      return null;
    } on TimeoutException catch (e) {
      log(e.toString(),
          name: 'TimeoutException on SocketException getResponse');
      return null;
    } catch (e) {
      log(e.toString(), name: 'Error on getResponse');
      return null;
    }
  }

  Future<T?> _aliProcessResponse2<T>(
      http.Response response, T Function(dynamic) fromJson) async {
    if (response.statusCode == 200) {
      // Decode with UTF-8 to ensure proper handling of Russian characters
      final body = jsonDecode(utf8.decode(response.bodyBytes));

      if (body is List) {
        // Handle List<dynamic> response
        return fromJson(body) as T?;
      } else if (body is Map<String, dynamic>) {
        // Handle Map<String, dynamic> response
        return fromJson(body);
      } else {
        throw Exception('Unexpected JSON format');
      }
    } else {
      throw Exception('Failed to load data');
    }
  }
}
