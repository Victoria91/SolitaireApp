import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../constants.dart';

class TokenStorage {
  static Future<String> getDeviceToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    print('from persistent storage========${prefs.getString('token')}');
    return prefs.getString('token') ?? await _fetchAndPersistToken(prefs);
  }

  static Future<String> _fetchAndPersistToken(SharedPreferences prefs) async {
    var client = http.Client();

    try {
      final response = await client.get('http$hostUrlPath/get_unique_token');

      prefs.setString('token', response.body);

      return response.body;
    } catch (e) {
      print('====== Error on get token request: $e =======');
      return 'error';
    } finally {
      client.close();
    }
  }
}
