import 'package:flutter/cupertino.dart';
import 'package:flutter_app/core/BaseState.dart';
import 'package:flutter_app/core/Supports.dart';
import 'package:flutter_app/models/User.dart';
import 'package:flutter_app/pages/HomePage.dart';
import 'package:flutter_app/resources/AppResources.dart';
import 'package:flutter_app/widgets/SupportListView.dart';


// ignore: non_constant_identifier_names
DefaultFragment(HomeStateModel stateModel) => Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[Text(stateModel.resources.getString(RS.title_default))],
    );
