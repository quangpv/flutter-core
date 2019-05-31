class Collections {
  static List<int> range(int from, int to) {
    var list = List<int>();
    for (var i = from; i < to; i++) {
      list.add(i);
    }
    return list;
  }

  static List<T> rangeMap<T>(int from, int to, T Function(int) function) {
    var list = List<T>();
    for (var i = from; i < to; i++) {
      list.add(function(i));
    }
    return list;
  }
}
