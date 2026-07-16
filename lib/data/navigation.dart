import "package:flutter/material.dart";
import "package:todo_list/pages/category_page.dart";
import "package:todo_list/pages/todo_page.dart";

class NavigationModel with ChangeNotifier {
  int _pageIndex = 0;
  final List<Widget> _pages = const [TodoPage(), CategoryPage()];

  int get pageIndex => _pageIndex;
  Widget get page => _pages[_pageIndex];

  void setIndex(int index) {
    _pageIndex = index;
    notifyListeners();
  }
}
