import 'dart:convert';

import 'package:flutter_app/models/User.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppCache {
  Future<SharedPreferences> _preferences = SharedPreferences.getInstance();

  var _user;

  Future<User> getUser() async {
    if (_user != null) return _user;
    var userJson = json.decode((await _preferences).getString("user"));
    _user = User.from(userJson);
    return _user;
  }

  Future saveUser(User user) async {
    _user = user;
    (await _preferences).setString("user", json.encode(user.toMap()));
  }
}
