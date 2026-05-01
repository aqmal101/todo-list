import 'package:drift_tutorial/todo.dart';
import 'package:flutter/material.dart';
import 'database/app_database.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final db = AppDatabase();

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: TodoPage(db: db));
  }
}
