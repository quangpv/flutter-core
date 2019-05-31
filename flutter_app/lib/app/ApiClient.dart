import 'dart:convert';

import 'package:http/http.dart' as http;

import 'AppCache.dart';

class ApiClient {
  final AppCache _appCache;

  Future<int> get _token async => (await _appCache.getUser()).id;

  Future<Map<String, String>> get _headers async => <String, String>{
        'Content-Type': "application/json",
        'Authorization': "Bearer ${await _token}",
      };

  ApiClient(this._appCache);

  Future<T> get<T>(String url) async {
    var response = await http.get(url, headers: await _headers);
    return json.decode(response.body) as T;
  }

  Future<T> post<T>(String url, Object body) async {
    var response = await http.post(url, body: body, headers: await _headers);
    return json.decode(response.body) as T;
  }

  Future<T> patch<T>(String url, Object body) async {
    var response = await http.patch(url, body: body, headers: await _headers);
    return json.decode(response.body) as T;
  }

  Future<T> delete<T>(String url, Object body) async {
    var response = await http.delete(url, headers: await _headers);
    return json.decode(response.body) as T;
  }
}
