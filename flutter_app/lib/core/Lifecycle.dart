enum LifeState { none, created, built, disposed }

abstract class StateLifecycle {
  LifeState get currentState;

  StateLifecycle onDisposed(void Function() function);

  StateLifecycle onBuilt(void Function() function);

  StateLifecycle onInit(void Function() function);
}

class StateLifecycleRegistry extends StateLifecycle {
  Map<LifeState, List<void Function()>> _lifecycleAction = Map();

  LifeState _currentState = LifeState.none;

  @override
  LifeState get currentState => _currentState;

  _notifyIfNeeded(LifeState state) {
    if (_currentState == state) return;
    if (!_lifecycleAction.containsKey(state)) return;
    _lifecycleAction[state].forEach((function) => function());
    _currentState = state;
  }

  StateLifecycleRegistry _add(LifeState state, void Function() function) {
    if (!_lifecycleAction.containsKey(state)) _lifecycleAction[state] = List();
    _lifecycleAction[state].add(function);
    if (_currentState == state) function();
    return this;
  }

  void init() => _notifyIfNeeded(LifeState.created);

  void build() => _notifyIfNeeded(LifeState.built);

  void dispose() => _notifyIfNeeded(LifeState.disposed);

  StateLifecycleRegistry onDisposed(void Function() function) =>
      _add(LifeState.disposed, function);

  StateLifecycleRegistry onBuilt(void Function() function) =>
      _add(LifeState.built, function);

  StateLifecycleRegistry onInit(void Function() function) =>
      _add(LifeState.created, function);
}
