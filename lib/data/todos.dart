import 'package:flutter/material.dart';
import 'package:todo_list/data/categories.dart';
import 'package:uuid/uuid.dart';

class TodoHandler {
  static ValueNotifier<List<Todo>> todoListNotifier = ValueNotifier([]);

  static void addTodo({required String task, required Category? category}) {
    todoListNotifier.value = List.from(todoListNotifier.value)
      ..add(Todo(task: task, category: category));
  }

  static void removeTodo({required String id}) {
    todoListNotifier.value = List.from(todoListNotifier.value)
      ..removeWhere((Todo currentTodo) => currentTodo.id == id);
  }

  static void updateTodoListNotifier() {
    todoListNotifier.value = List.from(todoListNotifier.value);
  }

  static int getCompletedTodosLength() {
    return todoListNotifier.value.where((Todo todo) => todo.completed).length;
  }

  static int getUncompletedTodosLength() {
    return todoListNotifier.value.where((Todo todo) => !todo.completed).length;
  }

  static List<Todo> getCompletedTodos() {
    return todoListNotifier.value.where((Todo todo) => todo.completed).toList();
  }

  static List<Todo> getUncompletedTodos() {
    return todoListNotifier.value
        .where((Todo todo) => !todo.completed)
        .toList();
  }
}

class Todo {
  final String id;
  final String task;
  final Category? category;
  bool completed;

  Todo({required this.task, required this.category, this.completed = false})
    : id = const Uuid().v4();

  void markCompleted() {
    completed = true;
    TodoHandler.updateTodoListNotifier();
  }
}
