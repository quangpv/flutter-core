import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/core/BaseState.dart';
import 'package:flutter_app/resources/AppResources.dart';

class SplashPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SplashState();
}

class _SplashState extends StateWidget<SplashPage, SplashStateModel> {
  @override
  Widget buildWidget(BuildContext context) => Container(
        color: Theme.of(context).backgroundColor,
        child: Center(
          child: Text(resources.getString(RS.app_name)),
        ),
      );
}

class SplashStateModel extends StateModel {
  @override
  void onInitState() {
    resources.editConfig().setLanguage(SupportLanguage.VN).apply();
    launch(() async {
      await delay(100);
      navigator.pushNamed(RR.login);
      return false;
    });
  }
}
