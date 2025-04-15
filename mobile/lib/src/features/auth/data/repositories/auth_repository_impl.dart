import 'package:eqshare_mobile/src/core/data/services/storage/token_provider_service.dart';
import 'package:http/http.dart' as http;

import '../models/user_model/user_model.dart';
import '../../../../core/res/api_endpoints/api_endpoints.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../../../core/data/services/network/api_client/network_client.dart';

class AuthRepositoryImpl implements AuthRepository {
  final _networkClient = NetworkClient();

  @override
  Future<http.Response?> postAuthenticateUser({
    required String phone,
    required String password,
  }) async {
    const path = AuthEndPoints.signIn;
    final Map<String, dynamic> body = {
      'phone_number': phone,
      'password': password,
    };

    http.Response? response = await _networkClient.aliPost(path, body);

    return response;
  }

  @override
  Future<http.Response?> postSaveFCMToken({
    required String? token,
  }) async {
    const path = AuthEndPoints.deviceTokens;
    final Map<String, dynamic> body = {
      'token': token,
    };

    http.Response? response = await _networkClient.aliPost(path, body);

    return response;
  }

  @override
  Future<http.Response?> postRegisterUser({
    required User userAuthData,
    required String password,
  }) async {
    const path = AuthEndPoints.signUp;

    final Map<String, dynamic> body = {
      'phone_number': userAuthData.phoneNumber,
      'city_id': userAuthData.cityId,
      'password': password,
    };

    http.Response? response = await _networkClient.aliPost(path, body);

    return response;
  }

  Future<http.Response?> postSignOut() async {
    final token = await TokenService().getToken();
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    const path = AuthEndPoints.signOut;

    http.Response? response = await _networkClient.aliPost(path, {}, headers);

    return response;
  }

  Future<http.Response?> deleteUserAccount() async {
    const path = '/user';
    final result = await _networkClient.aliDelete(path);
    return result;
  }
  
  @override
  Future<http.Response?> postAuthenticateUserWithEmail({required String email, required String password}) {

    throw UnimplementedError();
  }
}
