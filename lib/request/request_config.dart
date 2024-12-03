import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pts/globals.dart' as globals;
import 'package:shared_preferences/shared_preferences.dart';

class RequestConfig {
  SharedPreferences preferences;
  RequestConfig({required this.preferences});

  static Map<String, String> headers = {};

  static String pts = "b)+qK2{%'NpM5y`?6]Q/Y^w,FPgd";

   Future<String?> getBearerToken() async {
    return preferences.getString("AccessToken");
  }

  Future get(String path) async {
    String? token = await getBearerToken(); 
    
    print("object=============================$token");
    return http.get(Uri.parse(path),
        headers: <String, String>{
          'Authorization': token != null ? 'Bearer $token' : '',
          'pts': RequestConfig.pts,
          'Content-Type': 'application/json; charset=UTF-8'
        }).timeout(
      const Duration(seconds: 10),
      onTimeout: () {
        // Request Timeout response status code
        return http.Response('Error', 408);
      },
    );
  }

  Future post(String path, Map<String, dynamic> body) async {
    String? token = await getBearerToken();

    return http
        .post(Uri.parse(path),
            headers: <String, String>{
              'Authorization': token != null ? 'Bearer $token' : '',
              'pts': RequestConfig.pts,
              'Content-Type': 'application/json; charset=UTF-8'
            },
            body: jsonEncode(body))
        .timeout(
      const Duration(seconds: 10),
      onTimeout: () {
        print("==============================");
        // Request Timeout response status code
        return http.Response('Error', 408);
      },
    );
  }

  static void updateCookie(http.Response response) {
    String? rawCookie = response.headers['set-cookie'];
    if (rawCookie != null) {
      int index = rawCookie.indexOf(';');
      headers['cookie'] =
          (index == -1) ? rawCookie : rawCookie.substring(0, index);
    }
  }

  static String readyCookie(http.Response response, String property) {
    dynamic target;
    var headersList = response.headers['set-cookie']!.split(";");
    for (var kvPair in headersList) {
      var kv = kvPair.split("=");
      if (kv[0].contains(property)) {
        target = kv[1];
      }
    }
    return target;
  }
}
