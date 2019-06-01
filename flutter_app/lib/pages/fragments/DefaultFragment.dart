import 'package:flutter/cupertino.dart';
import 'package:flutter_app/pages/HomePage.dart';
import 'package:flutter_app/resources/AppResources.dart';


// ignore: non_constant_identifier_names
DefaultFragment(HomeStateModel stateModel) => Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[Text(stateModel.resources.getString(RS.title_default))],
    );
