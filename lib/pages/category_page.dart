import "package:flutter/material.dart";
import "package:todo_list/data/categories.dart";
import "package:todo_list/widgets/category_page/category_card.dart";
import "package:todo_list/widgets/content_column.dart";
import "package:todo_list/widgets/primary_button.dart";
import "package:todo_list/widgets/primary_text_field.dart";
import "package:todo_list/widgets/scrollable_fade_column.dart";
import "package:todo_list/widgets/title_card.dart";

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  final TextEditingController _categoryNameStringController =
      TextEditingController();
  late FocusNode _categoryFieldFocusNode;

  @override
  void initState() {
    super.initState();
    _categoryFieldFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _categoryFieldFocusNode.dispose();
    super.dispose();
  }

  void createCategory() {
    String categoryName = _categoryNameStringController.text.trim();
    if (categoryName == "") {
      _categoryFieldFocusNode.requestFocus();
      return;
    }

    CategoryHandler.addCategory(name: categoryName);

    setState(() {
      _categoryNameStringController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsGeometry.symmetric(horizontal: 10),
      child: ListView(
        physics: BouncingScrollPhysics(),
        children: [
          SizedBox(height: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: 10,
            children: [
              ContentColumn(
                children: [
                  const TitleCard(title: "Categories"),
                  ValueListenableBuilder(
                    valueListenable: CategoryHandler.categoryListNotifier,
                    builder: (context, value, child) {
                      return ScrollableFadeColumn(
                        height: 300,
                        itemCount: value.length,
                        itemBuilder: (context, index) {
                          Category currentCategory = value[index];
                          return CategoryCard(
                            currentCategory: currentCategory,
                            lastCard: index + 1 == value.length,
                          );
                        },
                        emptyWidget: Text("No Categories"),
                      );
                    },
                  ),
                ],
              ),
              ContentColumn(
                children: [
                  TitleCard(title: "Create a Category"),
                  PrimaryTextField(
                    controller: _categoryNameStringController,
                    focusNode: _categoryFieldFocusNode,
                    labelText: "Enter Category Name",
                    prefixIcon: Icon(Icons.category_rounded),
                  ),
                  PrimaryButton(
                    text: "Create",
                    icon: Icon(Icons.add_circle_rounded),
                    onPressed: createCategory,
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }
}
