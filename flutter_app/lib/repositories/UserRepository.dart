import 'package:flutter_app/app/ApiClient.dart';
import 'package:flutter_app/app/AppCache.dart';
import 'package:flutter_app/exceptions/ResourceException.dart';
import 'package:flutter_app/models/User.dart';
import 'package:flutter_app/resources/AppResources.dart';

class UserRepository {
  final AppCache _appCache;
  final ApiClient _apiClient;

  UserRepository(this._appCache, this._apiClient);

  login(String email, String password) async {
    if (email == "" || password == "")
      throw ResourceException(RS.error_login_input);
    var user = User.from(await _apiClient.get(RA.login));
    if (user.email != email) throw ResourceException(RS.error_login);
    await _appCache.saveUser(user);
  }
}
