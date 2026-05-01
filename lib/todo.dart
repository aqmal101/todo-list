import 'package:drift_tutorial/database/app_database.dart';
import 'package:flutter/material.dart';

class TodoPage extends StatefulWidget {
  final AppDatabase db;
  const TodoPage({required this.db});

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  final controller = TextEditingController();

  void addTodo() {
    widget.db.addTodo(controller.text);
    controller.clear();
  }

  void toggle(Todo todo) {
    widget.db.updateTodo(
      todo.copyWith(isDone: !todo.isDone),
    );
  }

  void delete(int id) {
    widget.db.deleteTodo(id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Todo Drift")),
      body: Column(
        children: [
          Row(
            children: [
              Expanded(child: TextField(controller: controller)),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: addTodo,
              ),
            ],
          ),
          Expanded(
            child: StreamBuilder<List<Todo>>(
              stream: widget.db.watchTodos(),
              builder: (context, snapshot) {
                final todos = snapshot.data ?? [];

                return ListView.builder(
                  itemCount: todos.length,
                  itemBuilder: (_, i) {
                    final t = todos[i];
                    return ListTile(
                      title: Text(
                        t.title,
                        style: TextStyle(
                          decoration: t.isDone
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                      ),
                      leading: Checkbox(
                        value: t.isDone,
                        onChanged: (_) => toggle(t),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => delete(t.id),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}