import 'dart:async';

import 'package:meta/meta.dart';
import 'package:sqflite/sqflite.dart';

import 'Serializable.dart';

class LiteDatabase {
  final String name;
  final int version;
  Database _database;

  final List<ModelTable> models;

  Map<Type, ModelTable> _modelMap;

  LiteDatabase({
    this.name = "flutter",
    this.version = 1,
    @required this.models,
  }) {
    _modelMap =
        models.asMap().map((index, value) => MapEntry(value.table, value));
  }

  String get _dbPath => "$name.db";

  Future _open() async {
    _database = await openDatabase(
      _dbPath,
      version: version,
      onCreate: _onCreateDatabase,
    );
  }

  Future _onCreateDatabase(Database db, int version) async =>
      models.forEach((model) async => await db.execute(model.toString()));

  Future _start(Future Function() function) async {
    await _open();
    var result = await function();
    await _close();
    return result;
  }

  _close() async => _database.close();

  Future get<T>(String sql, [List<dynamic> arguments]) => _start(() async {
        var data = await _database.rawQuery(sql, arguments);
        if (data.length == 0) return null;
        if (T == List) return data;
        return data[0];
      });

  Future insert<T>(T model) async {
    return _start(() async {
      if (model is List) {
        _batch(model, (batch, item) async {
          batch.insert(
              item.runtimeType.toString(), (item as Serializable).toMap());
        });
        return;
      }
      requireSerializable(model);
      await _database.insert(T.toString(), (model as Serializable).toMap());
    });
  }

  Future update<T>(T model,
      {String where,
      List<dynamic> whereArgs,
      ConflictAlgorithm conflictAlgorithm}) async {
    return _start(() async {
      if (model is List) {
        _batch(model, (b, item) {
          b.update(item.runtimeType.toString(), (item as Serializable).toMap(),
              where: where,
              whereArgs: whereArgs,
              conflictAlgorithm: conflictAlgorithm);
        });
        return;
      }
      requireSerializable(model);
      await _database.update(T.toString(), (model as Serializable).toMap(),
          where: where,
          whereArgs: whereArgs,
          conflictAlgorithm: conflictAlgorithm);
    });
  }

  Future delete<T>(T model) async {
    var data = (model as Serializable).toMap();
    String idColumn = _findIdColumn(model);
    var where = "";
    var whereArgs = List();

    if (idColumn != null) {
      where = "$idColumn = ?";
      whereArgs.add(data[idColumn]);
    } else {
      data.forEach((key, value) {
        var clause = "$key = ?";
        if (where == "")
          where = clause;
        else
          where = "$where and $clause";
        whereArgs.add(value);
      });
    }
    return _start(() async {
      if (model is List) {
        _batch(model, (b, item) {
          b.delete(item.runtimeType.toString(),
              where: where, whereArgs: whereArgs);
        });
        return;
      }
      requireSerializable(model);
      await _database.delete(T.toString(), where: where, whereArgs: whereArgs);
    });
  }

  void _batch(List items, Future Function(Batch, dynamic) function) {
    var batch = _database.batch();
    items.forEach((item) {
      requireSerializable(item);
      function(batch, item);
    });
    batch.commit();
  }

  String _findIdColumn<T>(T model) {
    var columns = _modelMap[T].columns;
    for (var key in columns.keys) {
      var column = columns[key];
      if (column.isKey) return key;
    }
    return null;
  }

  void requireSerializable(item) {
    if (!(item is Serializable))
      throw Exception("Model should be instance of Serializable");
  }
}

class ModelColumn {
  Type type;
  bool isKey;
  bool isNotNull;
  bool isAutoincrement;

  String get _modelType {
    switch (type) {
      case bool:
        return "int";
      case String:
        return "text";
      default:
        return type.toString();
    }
  }

  String get _modelKey => isKey ? "primary key" : "";

  String get _modelAutoincrement => isAutoincrement ? "autoincrement" : "";

  String get _modelNotNull => isNotNull ? "not null" : "";

  ModelColumn(this.type,
      {this.isKey = false,
      this.isNotNull = false,
      this.isAutoincrement = false});

  @override
  String toString() =>
      "$_modelType $_modelKey $_modelAutoincrement $_modelNotNull";
}

class ModelTable {
  Type table;
  Map<String, ModelColumn> columns;

  ModelTable(this.table, this.columns);

  List<String> _getColumns() {
    var fields = List<String>();
    columns.forEach(
        (name, field) => fields.add("$name ${field.toString()}".trim()));
    return fields;
  }

  @override
  String toString() {
    var tableContent = _getColumns().reduce((value, item) => "$value, $item");
    return "CREATE TABLE ${table.toString()} ($tableContent)";
  }
}

abstract class LiteDao {
  @protected
  final LiteDatabase database;

  LiteDao(this.database);
}
