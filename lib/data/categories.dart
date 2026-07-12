import 'dart:math';

import 'package:flutter/material.dart';
import 'package:todo_list/data/todos.dart';
import 'package:uuid/uuid.dart';

class CategoryHandler {
  static ValueNotifier<List<Category>> categoryListNotifier = ValueNotifier([
    Category(name: "Category 1", color: colorList[0]),
    Category(name: "Category 2", color: colorList[1]),
    Category(name: "Category 3", color: colorList[2]),
    Category(name: "Category 4", color: colorList[3]),
  ]);

  static List<Color> colorList = const [
    Color(0xFF7F8FC9),
    Color(0xFF7FAE79),
    Color(0xFFA8A85C),
    Color(0xFFCB9F65),
    Color(0xFFD18365),
    Color(0xFFD78DAA),
    Color(0xFF9A82C7),
  ];

  static void addCategory({required String name, Color? color, int? index}) {
    color = color ?? colorList[Random().nextInt(colorList.length)];
    if (index == null) {
      categoryListNotifier.value = List.from(categoryListNotifier.value)
        ..add(Category(name: name, color: color));
    } else {
      categoryListNotifier.value = List.from(categoryListNotifier.value)
        ..insert(index, Category(name: name, color: color));
    }
  }

  static void removeCategory({required String id}) {
    Category? category = getCategoryById(id);
    if (category != null) {
      TodoHandler.nullAllOfCategory(category);
    }
    categoryListNotifier.value = List.from(categoryListNotifier.value)
      ..remove(category);
  }

  static Category? getCategoryById(String? id) {
    if (id == null) return null;
    for (Category currentCategory in categoryListNotifier.value) {
      if (currentCategory.id == id) return currentCategory;
    }
    return null;
  }

  static void editCategory(Category category, {required String newName}) {
    int index = categoryListNotifier.value.indexOf(category);
    removeCategory(id: category.id);
    addCategory(name: newName, color: category.color, index: index);
  }
}

class Category {
  late final String id;
  final String name;
  final Color color;

  Category({required this.name, required this.color}) : id = const Uuid().v4();

  void editCategory(String newName) {
    CategoryHandler.editCategory(this, newName: newName);
  }
}
