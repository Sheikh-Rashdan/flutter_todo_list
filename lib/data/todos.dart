import 'package:flutter/material.dart';
import 'package:todo_list/data/categories.dart';
import 'package:uuid/uuid.dart';

class TodoHandler {
  static ValueNotifier<List<Todo>> todoListNotifier = ValueNotifier([]);

  static void addTodo({
    required String task,
    required Category? category,
    bool completed = false,
    int index = 0,
  }) {
    todoListNotifier.value = List.from(todoListNotifier.value)
      ..insert(
        index,
        Todo(task: task, category: category, completed: completed),
      );
  }

  static void removeTodo({required String id}) {
    todoListNotifier.value = List.from(todoListNotifier.value)
      ..removeWhere((Todo currentTodo) => currentTodo.id == id);
  }

  static void editTodo(
    Todo todo, {
    String? newTask,
    Category? newCategory,
    bool removeCategory = false,
  }) {
    int index = todoListNotifier.value.indexOf(todo);
    if (removeCategory) {
      newCategory = null;
    } else {
      newCategory ??= todo.category;
    }
    removeTodo(id: todo.id);
    addTodo(
      task: newTask ?? todo.task,
      category: newCategory,
      completed: todo.completed,
      index: index,
    );
  }

  static void nullAllOfCategory(Category category) {
    for (Todo todo in todoListNotifier.value) {
      if (todo.category == category) {
        editTodo(todo, removeCategory: true);
      }
    }
  }

  static void updateTodoListNotifier() {
    todoListNotifier.value = List.from(todoListNotifier.value);
  }

  static List<Todo> getTodos({bool? completed, String? categoryId}) {
    List<Todo> todoList = TodoHandler.todoListNotifier.value;
    if (completed != null) {
      todoList = todoList
          .where((Todo currentTodo) => currentTodo.completed == completed)
          .toList();
    }
    if (categoryId != null) {
      todoList = todoList
          .where((Todo currentTodo) => currentTodo.category?.id == categoryId)
          .toList();
    }
    return todoList;
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

  void markUncompleted() {
    completed = false;
    TodoHandler.updateTodoListNotifier();
  }

  void editTask(String newTask) {
    TodoHandler.editTodo(this, newTask: newTask);
  }
}
