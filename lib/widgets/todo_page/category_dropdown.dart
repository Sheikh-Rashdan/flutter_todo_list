import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/data/categories.dart';

class CategoryDropdown extends StatelessWidget {
  const CategoryDropdown({
    super.key,
    required this.selectedValue,
    required this.onChanged,
  });

  final String? selectedValue;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Consumer<CategoryModel>(
      builder: (context, categoryModel, child) {
        List<Category> categoryList = categoryModel.categoryList;
        return Expanded(
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Theme.of(context).colorScheme.primary),
              borderRadius: BorderRadius.circular(4),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
            child: DropdownButtonHideUnderline(
              child: DropdownButton(
                value: selectedValue,
                selectedItemBuilder: (context) => List.generate(
                  categoryList.length,
                  (index) => Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      categoryList[index].name,
                      style: TextStyle(color: categoryList[index].color),
                    ),
                  ),
                ),
                items: List.generate(
                  categoryList.length,
                  (index) => DropdownMenuItem(
                    value: categoryList[index].id,
                    child: Text(
                      categoryList[index].name,
                      style: TextStyle(color: categoryList[index].color),
                    ),
                  ),
                ),
                hint: Row(
                  children: [
                    Icon(
                      Icons.category_rounded,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    SizedBox(width: 10),
                    Text(
                      "Category",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ],
                ),
                icon: Icon(
                  Icons.arrow_drop_down_circle_outlined,
                  color: Theme.of(context).colorScheme.primary,
                ),
                onChanged: onChanged,
              ),
            ),
          ),
        );
      },
    );
  }
}
