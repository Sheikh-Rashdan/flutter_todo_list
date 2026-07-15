import 'package:flutter/material.dart';
import 'package:todo_list/data/categories.dart';
import 'package:uuid/uuid.dart';

class TodoModel with ChangeNotifier {
  final List<Todo> _todoList = [];

  List<Todo> get todoList => _todoList;

  Todo? getTodoById(String? id) {
    if (id == null) return null;
    for (Todo currentTodo in _todoList) {
      if (currentTodo.id == id) return currentTodo;
    }
    return null;
  }

  void addTodo({
    required String task,
    required Category? category,
    bool completed = false,
    int index = 0,
    String? id,
  }) {
    _todoList.insert(
      index,
      Todo(task: task, category: category, completed: completed, id: id),
    );
    notifyListeners();
  }

  void removeTodo({required String id}) {
    Todo? todo = getTodoById(id);
    if (todo != null) {
      _todoList.remove(todo);
      notifyListeners();
    }
  }

  void editTodo(
    String id, {
    String? newTask,
    Category? newCategory,
    bool? completed,
    bool removeCategory = false,
  }) {
    Todo? todo = getTodoById(id);
    if (todo == null) return;
    int index = _todoList.indexOf(todo);
    if (removeCategory) {
      newCategory = null;
    } else {
      newCategory ??= todo.category;
    }
    removeTodo(id: id);
    addTodo(
      task: newTask ?? todo.task,
      category: newCategory,
      completed: completed ?? todo.completed,
      index: index,
      id: id,
    );
    notifyListeners();
  }

  void nullAllOfCategory(String categoryId) {
    for (Todo todo in _todoList) {
      if (todo.category?.id == categoryId) {
        editTodo(todo.id, removeCategory: true);
      }
    }
    notifyListeners();
  }

  List<Todo> getTodos({bool? completed, String? categoryId}) {
    List<Todo> todoList = List.from(_todoList);
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

  void markTodoAsCompleted(String id) {
    editTodo(id, completed: true);
  }

  void markTodoAsUncompleted(String id) {
    editTodo(id, completed: false);
  }
}

class Todo {
  final String id;
  final String task;
  final Category? category;
  final bool completed;

  Todo({
    required this.task,
    required this.category,
    this.completed = false,
    String? id,
  }) : id = id ?? const Uuid().v4();
}
