class ApiEndPoints {
  static late String baseUrl;
  static late String baseUrlForWS;

  static void init(String ipWithPort) {
    baseUrl = 'http://$ipWithPort';
    baseUrlForWS = 'ws://$ipWithPort';
  }
}

abstract class AuthEndPoints {
  static const String signUp = '/signup';
  static const String signIn = '/signin';
  static const String deviceTokens = '/device_tokens';
  static const String signOut = '/signout';
  static const String switchToClient = '/auth/CLIENT';
  static const String switchToDriver = '/auth/DRIVER';
  static const String switchToOwner = '/auth/OWNER';
  static const String getOwnerRole = '/owner';
}
