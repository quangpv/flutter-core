import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/core/Resources.dart';

import 'DependenceContext.dart';
import 'Lifecycle.dart';
import 'Throwable.dart';

abstract class StateWidget<T extends StatefulWidget, V extends StateModel>
    extends State<T> {
  V _stateModel;
  ThemeData _defaultTheme;
  StateLifecycleRegistry _lifecycle;

  OnConfigChangedListener _configChanged;

  @protected
  V get stateModel => _stateModel;

  Resources get resources => inject();

  @protected
  ThemeData get defaultTheme {
    if (_defaultTheme == null) _defaultTheme = Theme.of(context);
    return _defaultTheme;
  }

  StateLifecycle get lifecycle {
    if (_lifecycle == null) _lifecycle = StateLifecycleRegistry();
    return _lifecycle;
  }

  StateWidget() : super() {
    _stateModel = inject();
    _stateModel._state = this;
    _configChanged = OnConfigChangedListener(() {
      if (_lifecycle.currentState != LifeState.disposed) setState(() {});
    });
  }

  @override
  void initState() {
    resources.addChangedListener(_configChanged);
    if (_lifecycle != null) _lifecycle.init();
    stateModel.onInitState();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_lifecycle != null) _lifecycle.build();
    stateModel.onBuilt(context);
    return buildWidget(context);
  }

  @override
  void dispose() {
    resources.removeChangedListener(_configChanged);
    if (_lifecycle != null) _lifecycle.dispose();
    super.dispose();
  }

  String getString(int id) => resources.getString(id);

  double getDimen(int id) => resources.getDimen(id);

  @protected
  Widget buildWidget(BuildContext context);
}

class StateModel {
  StateWidget _state;
  Error _error;
  bool _isLoading = false;
  NavigatorState _navigator;

  Error get error => _error;

  bool get isLoading => _isLoading;

  Resources get resources => _state.resources;

  NavigatorState get navigator {
    if (_navigator == null) _navigator = Navigator.of(_state.context);
    return _navigator;
  }

  RouteSettings _mRouteSetting;

  RouteSettings get _routeSetting {
    if (_mRouteSetting == null)
      _mRouteSetting = ModalRoute.of(_state.context).settings;
    return _mRouteSetting;
  }

  arguments<T>() => _routeSetting.arguments as T;

  /// [function] @return result as boolean to indicate render or not render
  launch(Object Function() function) {
    _onStartLaunch();
    Future load() async {
      var call = function();
      var result;
      if (call is Future)
        result = await call;
      else
        result = call;
      if (!(result is bool)) return true;
      return result;
    }

    load().then((result) => _onFinishLaunch(result)).catchError((error) {
      _handleError(error);
      _onFinishLaunch(false);
    });
  }

  render() {
    if (_state.lifecycle.currentState == LifeState.disposed) return;
    // ignore: invalid_use_of_protected_member
    _state.setState(() {});
  }

  void _handleError(error) {
    if (error is Error) {
      this._error = error;
      if (!(error is Throwable)) print(error.stackTrace);
    } else
      this._error = Throwable(message: error.toString());
    onError(this._error);
  }

  void _onStartLaunch() {
    this._error = null;
    if (shouldShowLoading()) {
      _isLoading = true;
      render();
    }
  }

  void _onFinishLaunch(bool forceRender) {
    if (forceRender) {
      _isLoading = false;
      render();
      return;
    }
    var shouldRender;
    if (shouldShowLoading()) {
      _isLoading = false;
      shouldRender = true;
    } else {
      shouldRender = shouldShowError() && this._error != null;
    }
    if (shouldRender) render();
  }

  void onBuilt(BuildContext context) {}

  void onInitState() {}

  void onError(Error error) {}

  bool shouldShowLoading() => true;

  bool shouldShowError() => true;
}

Future<T> asyncLoad<T>(T Function() function) async {
  return function();
}

Future<T> continuation<T>(Function(Completer) function) async {
  var com = Completer();
  function(com);
  return com.future;
}

Future delay(int milliseconds) =>
    Future.delayed(Duration(milliseconds: milliseconds));
