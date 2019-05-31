class DependenceContext {
  static DependenceContext _instance;

  Map<Type, Bean> _beans = new Map();

  static provides(Function(DependenceContext) function) {
    _instance = DependenceContext();
    function(_instance);
  }

  T lookup<T>() {
    if (_beans.containsKey(T)) return _beans[T].instance;
    throw Exception("Not found $T, Please provide before using !");
  }

  void single<T>(T Function() function) {
    _beans[T] = Bean(function, true);
  }

  void state<T>(T Function() function) {
    _beans[T] = Bean(function, false);
  }
}

class Bean<T> {
  T Function() _invokable;
  bool _singleton = false;
  Object _value;

  Bean(T Function() invokable, isSingleTon) {
    _invokable = invokable;
    _singleton = isSingleTon;
  }

  get instance {
    if (!_singleton)
      return _invokable();
    else {
      if (_value == null) _value = _invokable();
      return _value;
    }
  }
}

T inject<T>() => DependenceContext._instance.lookup<T>();

single<T>(T Function() function) =>
    DependenceContext._instance.single<T>(function);

state<T>(T Function() function) =>
    DependenceContext._instance.state<T>(function);
