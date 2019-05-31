import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_app/core/BaseState.dart';

class SupportAnimation {
  AnimationController _controller;
  final int seconds;
  Tween<double> _action;

  AnimationController get controller => _controller;

  set action(Tween<double> action) {
    _action = action;
    _action.animate(_controller);
  }

  SupportAnimation(
      {@required this.seconds, @required TickerProvider provider}) {
    _controller = AnimationController(
        duration: new Duration(seconds: seconds), vsync: provider);

    if (provider is StateWidget) {
      (provider as StateWidget)
          .lifecycle
          .onDisposed(() => _controller.dispose());
    }
  }

  void begin({double from}) {
    _controller.forward(from: from);
  }

  /// Using [Transform] for animation
  build({
    @required Widget child,
    @required Widget Function(BuildContext, Widget) transform,
  }) =>
      AnimatedBuilder(
        child: child,
        animation: _controller,
        builder: transform,
      );
}
