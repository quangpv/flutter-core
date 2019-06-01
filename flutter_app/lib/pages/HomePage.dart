import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/app/AppStateModel.dart';
import 'package:flutter_app/core/BaseState.dart';
import 'package:flutter_app/resources/AppResources.dart';

import 'fragments/DefaultFragment.dart';
import 'fragments/HomeFragment.dart';
import 'fragments/UserProfileFragment.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomeState();
}

class _HomeState extends StateWidget<HomePage, HomeStateModel>
    with SingleTickerProviderStateMixin {
  PageController _pageController =
      PageController(initialPage: 0, keepPage: true);

  @override
  Widget buildWidget(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(getString(RS.title_home)),
        ),
        body: Center(child: body()),
      );

  body() => Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Expanded(
            child: PageView(
              children: <Widget>[
                HomeFragment(),
                DefaultFragment(stateModel),
                UserProfileFragment()
              ],
              controller: _pageController,
              onPageChanged: (page) {
                stateModel.scene = page;
              },
            ),
            flex: 1,
          ),
          bottomMenu()
        ],
      );

  bottomMenu() => BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text(getString(RS.tab_home)),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.drive_eta),
            title: Text(getString(RS.tab_default)),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.supervised_user_circle),
            title: Text(getString(RS.tab_user)),
          ),
        ],
        currentIndex: stateModel.scene,
        onTap: (page) {
          _pageController.animateToPage(page,
              curve: Curves.ease, duration: Duration(milliseconds: 500));
          stateModel.scene = page;
        },
      );
}

class HomeStateModel extends AppStateModel {
  @protected
  var _scene = 0;

  int get scene => _scene;

  set scene(value) {
    _scene = value;
    render();
  }

  String get args => arguments();
}
