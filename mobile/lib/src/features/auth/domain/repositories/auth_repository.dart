import 'package:eqshare_mobile/src/features/auth/data/models/user_model/user_model.dart';
import 'package:http/http.dart' as http;

abstract class AuthRepository {
  Future<http.Response?> postAuthenticateUser({
    required String phone,
    required String password,
  });
    Future<http.Response?> postAuthenticateUserWithEmail({
    required String email,
    required String password,
  });
  Future<http.Response?> postSaveFCMToken({
    required String? token,
  });
  Future<http.Response?> postRegisterUser({
    required User userAuthData,
    required String password,
  });
}
