import 'dart:convert';
import 'package:http/http.dart' as http;

Future<String> fetchIpFromBackend() async {
  final response = await http.get(Uri.parse('http://77.243.81.199:8777/user/getIpAddress'));

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    final url = data['CI_IP_ADDRESS'];
    final uri = Uri.parse(url);
    return '${uri.host}:${uri.port}';
  } else {
    throw Exception('Failed to get IP from backend');
  }
}
