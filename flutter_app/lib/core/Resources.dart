import 'dart:convert';

import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Throwable.dart';

abstract class Resources {
  static const DEFAULT = "resources:default";
  static const CONFIG = "resources:config";
  final ResourceConfig _config = ResourceConfig();
  Future<SharedPreferences> _preferences = SharedPreferences.getInstance();

  Map<int, String> _textMap;
  Map<int, String> _defaultTextMap;

  Map<int, double> _dimenMap;
  Map<int, double> _defaultDimenMap;

  Set<OnConfigChangedListener> _listeners = Set();

  ResourceConfig get config => _config;

  Resources() {
    _config._resources = this;
    _defaultTextMap = getTextConfig(DEFAULT);
    _defaultDimenMap = getDimenConfig(DEFAULT);

    _loadConfig().then((newConfig) => _updateConfigIfNeeded(newConfig));
  }

  Future<ResourceConfig> _loadConfig() async {
    var configString = (await _preferences).getString(CONFIG);
    return ResourceConfig.from(configString);
  }

  String getString(int id) {
    if (!_textMap.containsKey(id)) {
      if (_defaultTextMap.containsKey(id)) return _defaultTextMap[id];
      throw Throwable(message: "Not found string resource id $id");
    }
    return _textMap[id];
  }

  double getDimen(int id) {
    if (!_dimenMap.containsKey(id)) {
      if (_defaultDimenMap.containsKey(id)) return _defaultDimenMap[id];
      throw Throwable(message: "Not found dimen resource id $id");
    }
    return _dimenMap[id];
  }

  ResourceConfig editConfig() => _config.clone();

  void addChangedListener(OnConfigChangedListener listener) {
    _listeners.add(listener);
  }

  void removeChangedListener(OnConfigChangedListener listener) {
    _listeners.remove(listener);
  }

  void notifyChanged() {
    _listeners.forEach((item) => item._function());
  }

  Future _onConfigChanged(ResourceConfig newConfig) async {
    if (_updateConfigIfNeeded(newConfig)) {
      (await _preferences).setString(CONFIG, newConfig.toString());
    }
  }

  bool _updateConfigIfNeeded(ResourceConfig newConfig) {
    var isChanged = false;

    if (_config._language.toUpperCase() != newConfig._language.toUpperCase()) {
      _config._language = newConfig._language;
      _textMap = getTextConfig(_config._language);
      isChanged = true;
    }

    if (_config._dimenStyle.toUpperCase() !=
        newConfig._dimenStyle.toUpperCase()) {
      _config._dimenStyle = newConfig._dimenStyle;
      _dimenMap = getDimenConfig(_config._dimenStyle);
      isChanged = true;
    }
    if (isChanged) notifyChanged();
    return isChanged;
  }

  @protected
  Map<int, String> getTextConfig(String language);

  @protected
  Map<int, double> getDimenConfig(String dimenStyle);
}

class OnConfigChangedListener {
  final void Function() _function;

  OnConfigChangedListener(this._function);
}

class ResourceConfig {
  Resources _resources;
  String _language = Resources.DEFAULT;
  String _dimenStyle = Resources.DEFAULT;

  String get language => _language;

  ResourceConfig setLanguage(String lang) {
    _language = lang;
    return this;
  }

  ResourceConfig setDimenStyle(String dimenStyle) {
    _dimenStyle = dimenStyle;
    return this;
  }

  void apply() {
    _resources._onConfigChanged(this).whenComplete(() {});
  }

  ResourceConfig clone() {
    var clone = ResourceConfig();
    clone._language = _language;
    clone._dimenStyle = _dimenStyle;
    clone._resources = _resources;
    return clone;
  }

  @override
  String toString() =>
      json.encode({"language": _language, "dimenStyle": _dimenStyle});

  static ResourceConfig from(String configString) {
    var map = json.decode(configString);
    return ResourceConfig()
        .setLanguage(map["language"])
        .setDimenStyle(map["dimenStyle"]);
  }
}
