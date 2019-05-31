class Throwable extends Error {
  final String message;

  Throwable({this.message = ""});

  @override
  String toString() => message;
}
