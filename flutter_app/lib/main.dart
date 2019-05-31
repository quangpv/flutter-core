import 'package:flutter/material.dart';
import 'package:flutter_app/pages/HomePage.dart';
import 'package:flutter_app/pages/LoginPage.dart';
import 'package:flutter_app/pages/fragments/HomeFragment.dart';
import 'package:flutter_app/pages/fragments/UserProfileFragment.dart';
import 'package:flutter_app/repositories/PostRepository.dart';
import 'package:flutter_app/repositories/UserRepository.dart';
import 'package:flutter_app/resources/AppResources.dart';
import 'package:flutter_app/resources/AppTheme.dart';

import 'app/ApiClient.dart';
import 'app/AppCache.dart';
import 'core/DependenceContext.dart';
import 'core/Resources.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  Resources get resources => inject();

  @override
  Widget build(BuildContext context) {
    DependenceContext.provides((context) => onProvides());
    return MaterialApp(
      title: resources.getString(RS.title),
      theme: AppTheme.defaultTheme,
      home: LoginPage(),
      routes: {
        RR.login: (context) => LoginPage(),
        RR.main: (context) => HomePage(),
      },
    );
  }

  onProvides() {
    state(() => LoginStateModel(inject()));
    state(() => HomeStateModel());
    state(() => HomeDetailStateModel());
    state(() => UserProfileStateModel());

    single<Resources>(() => AppResources());

    single(() => AppCache());
    single(() => ApiClient(inject()));
    single(() => UserRepository(inject(), inject()));
    single(() => PostRepository(inject(), inject()));
  }
}
