import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'app_database.g.dart';

// 🔹 TABEL
class Todos extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()();
  BoolColumn get isDone => boolean().withDefault(Constant(false))();
}

@DriftDatabase(tables: [Todos])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  // CREATE
  Future<int> addTodo(String title) {
    return into(todos).insert(TodosCompanion(title: Value(title)));
  }

  // READ
  Stream<List<Todo>> watchTodos() {
    return select(todos).watch();
  }

  // UPDATE
  Future updateTodo(Todo todo) {
    return update(todos).replace(todo);
  }

  // DELETE
  Future deleteTodo(int id) {
    return (delete(todos)..where((t) => t.id.equals(id))).go();
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'app.db'));

    return NativeDatabase(
      file,
      logStatements: true, // 🔥 tetap dipakai (bagus)
    );
  });
}
