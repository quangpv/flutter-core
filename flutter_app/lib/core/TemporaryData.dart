import 'package:meta/meta.dart';

class TemporaryData<T> {
  Map<Object, T> _data = Map();
  Map<Object, int> _timeLoaded = Map();
  @protected
  final int timeout;

  /// [timeout] in milliseconds
  TemporaryData({this.timeout = 3000});

  Future<T> loadIfNeeded(Object key, Object Function() function) async {
    if (isValid(key)) return _data[key];
    var call = function();
    T newResult;
    if (call is Future)
      newResult = await call;
    else
      newResult = call;

    _data[key] = newResult;
    _timeLoaded[key] = DateTime.now().millisecondsSinceEpoch;
    return newResult;
  }

  bool isValid(Object key) {
    var result = _data[key];
    if (result != null && !isTimeOut(key)) return true;
    return false;
  }

  bool isTimeOut(Object key) {
    if (!_timeLoaded.containsKey(key)) return true;
    var current = DateTime.now().millisecondsSinceEpoch;
    var timeLoaded = _timeLoaded[key];
    return timeLoaded > (current + timeout);
  }
}
