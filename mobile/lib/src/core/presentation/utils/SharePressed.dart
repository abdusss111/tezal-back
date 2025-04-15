import 'package:share_plus/share_plus.dart';

void SharePressed(String? adiD,String address) {
  String message = 'http://mezet.online/${address}/?id=${adiD}';
  print('getAdIdFromUrl(message)::: ${getAdIdFromUrl(message)}');
  Share.share(message);
}

String? getAdIdFromUrl(String url) {
  final uri = Uri.parse(url);
  return uri.queryParameters['id'];
}