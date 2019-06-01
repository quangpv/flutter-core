import 'dart:convert';

import 'package:flutter_app/models/User.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppCache {
  Future<SharedPreferences> _preferences = SharedPreferences.getInstance();

  var _user;

  Future<User> getUser() async {
    if (_user != null) return _user;
    var userStr = (await _preferences).getString("$User");
    if (userStr == null || userStr == "") return User();
    _user = User.from(json.decode(userStr));
    return _user;
  }

  Future saveUser(User user) async {
    _user = user;
    (await _preferences).setString("$User", json.encode(user.toMap()));
  }
}
