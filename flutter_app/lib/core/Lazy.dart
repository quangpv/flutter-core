class Lazy<T> {
  T Function() function;

  T _value;

  Lazy(this.function);

  T get() {
    if (this._value == null) this._value = function();
    return this._value;
  }

  void reset() {
    this._value = null;
  }

  static Lazy<T> of<T>(T Function() function) {
    return Lazy(function);
  }
}
