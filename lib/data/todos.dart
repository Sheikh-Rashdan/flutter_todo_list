import 'package:flutter/material.dart';
import 'package:todo_list/data/categories.dart';
import 'package:todo_list/db/database_helper.dart';
import 'package:uuid/uuid.dart';

class TodoModel with ChangeNotifier {
  List<Todo> _todoList = [];

  List<Todo> get todoList => _todoList;

  TodoModel() {
    loadTodos();
  }

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
    Todo todo = Todo(
      id: id,
      task: task,
      category: category,
      completed: completed,
    );
    _todoList.insert(index, todo);
    addTodoDb(todo);
    notifyListeners();
  }

  void removeTodo({required String id}) {
    Todo? todo = getTodoById(id);
    if (todo != null) {
      _todoList.remove(todo);
      removeTodoDb(todo);
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
      id: id,
      task: newTask ?? todo.task,
      category: newCategory,
      completed: completed ?? todo.completed,
      index: index,
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

  Future<void> loadTodos() async {
    _todoList = await DatabaseHelper.instance.getTodos();
    notifyListeners();
  }

  Future<void> addTodoDb(Todo todo) async {
    DatabaseHelper.instance.insertTodo(todo.toDbMap());
  }

  Future<void> removeTodoDb(Todo todo) async {
    DatabaseHelper.instance.deleteTodo(todo.id);
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

  Map<String, dynamic> toDbMap() {
    return {
      'id': id,
      'task': task,
      'category': category?.id,
      'completed': completed ? 1 : 0,
    };
  }

  factory Todo.fromDbMap(Map<String, dynamic> dbMap) {
    return Todo(
      id: dbMap["id"],
      task: dbMap["task"],
      category: CategoryModel.getCategoryById(dbMap["category"]),
      completed: dbMap["completed"] == 1,
    );
  }
}
