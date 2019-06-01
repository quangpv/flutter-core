import 'dart:async';

import 'package:meta/meta.dart';
import 'package:sqflite/sqflite.dart';

import 'Serializable.dart';

class LiteDatabase {
  String name;
  int version;
  Database _database;

  List<ModelTable> models;

  LiteDatabase({
    this.name = "flutter",
    this.version = 1,
    @required this.models,
  });

  String get _dbPath => "$name.db";

  Future _open() async {
    _database = await openDatabase(
      _dbPath,
      version: version,
      onCreate: _onCreateDatabase,
    );
  }

  Future _start(Future Function() function) async {
    await _open();
    var result = await function();
    await _close();
    return result;
  }

  Future _onCreateDatabase(Database db, int version) async {
    for (ModelTable value in models) {
      await _onCreateTable(value);
    }
  }

  Future _onCreateTable(ModelTable value) async {
    var tableContent = _onCreateColumn(value);
    var create = "CREATE TABLE ${value.modelTable} ($tableContent)";
    await _database.execute(create);
  }

  List<String> _onCreateColumn(ModelTable value) {
    var fields = List<String>();
    value.fields.forEach((key, field) => fields.add("$key "
            "${field.modelType} "
            "${field.modelKey} "
            "${field.modelAutoincrement} "
            "${field.modelNotNull}"
        .trim()));
    return fields;
  }

  _close() async => _database.close();

  Future<T> get<T>(String sql, [List<dynamic> arguments]) => _start(() async {
        var data = await _database.rawQuery(sql, arguments);
        if (data.length == 0) return null;
        if (T is List) return data as T;
        return data[0] as T;
      });

  Future insert<T>(T model) async {
    return _start(() async {
      if (model is List) {
        _batch(model, (batch, item) async {
          batch.insert(T.toString(), (item as Serializable).toMap());
        });
        return;
      }

      if (!(model is Serializable))
        throw Exception("Model should be instance of Serializable");
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
          b.update(T.toString(), (item as Serializable).toMap(),
              where: where,
              whereArgs: whereArgs,
              conflictAlgorithm: conflictAlgorithm);
        });
        return;
      }
      if (!(model is Serializable))
        throw Exception("Model should be instance of Serializable");
      await _database.update(T.toString(), (model as Serializable).toMap(),
          where: where,
          whereArgs: whereArgs,
          conflictAlgorithm: conflictAlgorithm);
    });
  }

  Future<int> delete<T>(T model) async {
    var data = (model as Serializable).toMap();
    var where = "";
    var whereArgs = List();
    data.forEach((key, value) {
      var clause = "$key = ?";
      if (where == "")
        where = clause;
      else
        where = "$where and $clause";
    });
    return _start(() async {
      if (model is List) {
        _batch(model, (b, item) {
          b.delete(T.toString(), where: where, whereArgs: whereArgs);
        });
        return;
      }
      if (!(model is Serializable))
        throw Exception("Model should be instance of Serializable");
      await _database.delete(T.toString(), where: where, whereArgs: whereArgs);
    });
  }

  void _batch(List items, Future Function(Batch, dynamic) function) {
    var batch = _database.batch();
    items.forEach((item) {
      if (!(item is Serializable))
        throw Exception("Model should be instance of Serializable");
      function(batch, item);
    });
    batch.commit();
  }
}

class ModelColumn {
  Type type;
  bool isKey;
  bool isNotNull;
  bool isAutoincrement;

  String get modelType {
    switch (type) {
      case bool:
        return "int";
      case String:
        return "text";
      default:
        return type.toString();
    }
  }

  String get modelKey => isKey ? "primary key" : "";

  String get modelAutoincrement => isAutoincrement ? "autoincrement" : "";

  String get modelNotNull => isNotNull ? "not null" : "";

  ModelColumn(this.type, {this.isKey, this.isNotNull, this.isAutoincrement});
}

class ModelTable {
  Type table;
  Map<String, ModelColumn> fields;

  String get modelTable => table.toString();

  ModelTable(this.table, this.fields);
}
