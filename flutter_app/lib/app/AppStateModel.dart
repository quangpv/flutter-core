import 'dart:io';

import 'package:flutter_app/core/BaseState.dart';
import 'package:flutter_app/exceptions/ResourceException.dart';
import 'package:flutter_app/resources/AppResources.dart';

class AppStateModel extends StateModel {
  @override
  Error convertError(error) {
    if(error is SocketException) return ResourceException(RS.error_no_internet_connection);
    return super.convertError(error);
  }
}
