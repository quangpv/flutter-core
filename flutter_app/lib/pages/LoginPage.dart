import 'package:flutter/material.dart';
import 'package:flutter_app/core/BaseState.dart';
import 'package:flutter_app/repositories/UserRepository.dart';
import 'package:flutter_app/resources/AppResources.dart';

class LoginPage extends StatefulWidget {

  @override
  State createState() => _LoginPageState();
}

class _LoginPageState extends StateWidget<LoginPage, LoginStateModel> {
  var _emailController = TextEditingController();
  var _passwordController = TextEditingController();

  @override
  void initState() {
    _emailController.text = stateModel.email;
    _passwordController.text = stateModel.password;
    resources.editConfig().setLanguage(SupportLanguage.VN).apply();
    super.initState();
  }

  @override
  Widget buildWidget(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text(getString(RS.app_name))),
        body: Center(
          child: Container(
            padding: EdgeInsets.all(getDimen(RD.size_10)),
            child: content(),
          ),
        ),
      );

  content() => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            decoration: InputDecoration(labelText: getString(RS.hint_email)),
            onChanged: (text) => stateModel.email = text,
            controller: _emailController,
          ),
          TextField(
            decoration: InputDecoration(labelText: getString(RS.hint_password)),
            obscureText: true,
            onChanged: (text) => stateModel.password = text,
            controller: _passwordController,
          ),
          Container(
            padding: EdgeInsets.all(getDimen(RD.size_10)),
            child: Center(
              child: Stack(
                alignment: AlignmentDirectional.center,
                children: <Widget>[
                  loginButton(),
                  loading(stateModel.isLoading),
                ],
              ),
            ),
          ),
        ],
      );

  loginButton() => Column(
        children: <Widget>[
          RaisedButton(
            onPressed: stateModel.login,
            child: Text(getString(RS.btn_login)),
          ),
          error(stateModel.error),
        ],
      );

  error(Error error) => Visibility(
      visible: error != null,
      child: Text(
        error.toString(),
        style: TextStyle(color: Colors.pink),
      ));

  loading(bool isLoading) => Visibility(
        visible: isLoading,
        child: CircularProgressIndicator(strokeWidth: getDimen(RD.size_2)),
      );
}

class LoginStateModel extends StateModel {
  UserRepository userRepo;
  String email = "Sincere@april.biz";
  String password = "";

  LoginStateModel(this.userRepo);

  void login() {
    launch(() async {
      await userRepo.login(email, password);
      navigator.pushNamed(RR.main);
      return false;
    });
  }
}
