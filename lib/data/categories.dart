import 'dart:math';

import 'package:flutter/material.dart';
import 'package:todo_list/db/database_helper.dart';
import 'package:uuid/uuid.dart';

class CategoryModel with ChangeNotifier {
  List<Category> _categoryList = [];

  static final List<Color> _colorList = const [
    Color(0xFF7F8FC9),
    Color(0xFF7FAE79),
    Color(0xFFA8A85C),
    Color(0xFFCB9F65),
    Color(0xFFD18365),
    Color(0xFFD78DAA),
    Color(0xFF9A82C7),
  ];

  CategoryModel() {
    loadCategories();
  }

  List<Category> get categoryList => _categoryList;
  List<Color> get colorList => _colorList;

  static int getColorIndex(Color color) {
    int index = _colorList.indexOf(color);
    if (index != -1) {
      return index;
    }
    return 0;
  }

  static Color getColor(int index) {
    if (index >= 0 && index < _colorList.length) {
      return _colorList[index];
    }
    return _colorList.first;
  }

  Category? getCategoryById(String? id) {
    if (id == null) return null;
    for (Category currentCategory in _categoryList) {
      if (currentCategory.id == id) return currentCategory;
    }
    return null;
  }

  void addCategory({
    required String name,
    Color? color,
    String? id,
    int? index,
  }) {
    color = color ?? _colorList[Random().nextInt(_colorList.length)];
    Category category = Category(id: id, name: name, color: color);
    if (index == null) {
      _categoryList.add(category);
    } else {
      _categoryList.insert(index, category);
    }
    addCategoryDb(category);
    notifyListeners();
  }

  void removeCategory({required String id}) {
    Category? category = getCategoryById(id);
    if (category != null) {
      _categoryList.remove(category);
      removeCategoryDb(category);
      notifyListeners();
    }
  }

  void editCategory(String id, {required String newName}) {
    Category? category = getCategoryById(id);
    if (category == null) return;
    int index = _categoryList.indexOf(category);
    removeCategory(id: id);
    addCategory(id: id, name: newName, color: category.color, index: index);
    notifyListeners();
  }

  Future<void> loadCategories() async {
    _categoryList = await DatabaseHelper.instance.getCategories();
    notifyListeners();
  }

  Future<void> addCategoryDb(Category category) async {
    try {
      DatabaseHelper.instance.insertCategory(category.toDbMap());
    } catch (e) {
      print(e);
    }
  }

  Future<void> removeCategoryDb(Category category) async {
    try {
      DatabaseHelper.instance.deleteCategory(category.id);
    } catch (e) {
      print(e);
    }
  }
}

class Category {
  late final String id;
  final String name;
  final Color color;

  Category({required this.name, required this.color, String? id})
    : id = id ?? const Uuid().v4();

  Map<String, dynamic> toDbMap() {
    return {
      'id': id,
      'name': name,
      'color': CategoryModel.getColorIndex(color),
    };
  }

  factory Category.fromDbMap(Map<String, dynamic> dbMap) {
    return Category(
      id: dbMap["id"],
      name: dbMap["name"],
      color: CategoryModel.getColor(dbMap["color"]),
    );
  }
}
