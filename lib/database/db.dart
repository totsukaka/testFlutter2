import 'dart:io';

import 'package:moor/ffi.dart';
import 'package:moor/moor.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
part 'db.g.dart';

class Todos extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text().withLength(min: 6, max: 32)();
  TextColumn get content => text().named('body')();
  IntColumn get category => integer().nullable()();
}

@DataClassName("Category")
class Categories extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get description => text()();
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return VmDatabase(file);
  });
}

@UseMoor(tables: [Todos, Categories])
class MyDatabase extends _$MyDatabase {
  MyDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  /// 全てのTodoを取得する
  Future<List<Todo>> get allTodoEntries => select(todos).get();

  /// Categoryに紐付く全てのTodoを取得する。Streamはデータベースの変更を監視し、
  /// 変更が行われたら新しい結果を返す。
  Stream<List<Todo>> watchEntriesInCategory(Category c) {
    return (select(todos)..where((t) => t.category.equals(c.id))).watch();
  }

  /// [id]のTodoを取得する。Streamはデータベースの変更を監視し、変更が行われたら新しい結果を返す。
  Stream<Todo> todoById(int id) {
    return (select(todos)..where((t) => t.id.equals(id))).watchSingle();
  }

  Future<int> addTodoEntry(TodosCompanion entry) {
    print('database_____!!!!');
    return into(todos).insert(entry);
  }

  Future<List<Todo>> getAllTodoEntries() {
    return select(todos).get();
  }
}
