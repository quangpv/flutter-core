import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/app/AppCache.dart';
import 'package:flutter_app/core/BaseState.dart';
import 'package:flutter_app/core/DependenceContext.dart';
import 'package:flutter_app/models/User.dart';
import 'package:flutter_app/resources/AppResources.dart';

class UserProfileFragment extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _UserProfileState();
}

class _UserProfileState
    extends StateWidget<UserProfileFragment, UserProfileStateModel> {
  @override
  Widget buildWidget(BuildContext context) => Container(
        child: Column(
          children: <Widget>[
            Text("UserName ${this.stateModel.user.name}"),
            Text("Email ${this.stateModel.user.email}"),
            Text("Phone ${this.stateModel.user.phone}"),
            toggleLanguageButton()
          ],
        ),
        margin: EdgeInsets.all(getDimen(RD.size_10)),
      );

  toggleLanguageButton() => RaisedButton(
        onPressed: stateModel.changeLanguage,
        child: Text(getString(RS.btn_change_language)),
      );
}

class UserProfileStateModel extends StateModel {
  User user = User();

  AppCache get appCache => inject();

  @override
  void onInitState() {
    launch(() async => user = await appCache.getUser());
  }

  void changeLanguage() {
    var curLang = resources.config.language;
    curLang =
        curLang == SupportLanguage.VN ? SupportLanguage.EN : SupportLanguage.VN;
    resources.editConfig().setLanguage(curLang).apply();
  }
}
