import 'package:flutter_app/core/DependenceContext.dart';
import 'package:flutter_app/core/Resources.dart';
import 'package:flutter_app/core/Throwable.dart';

class ResourceException extends Throwable {
  final int stringId;

  ResourceException(this.stringId);

  @override
  String toString() => inject<Resources>().getString(stringId);
}
