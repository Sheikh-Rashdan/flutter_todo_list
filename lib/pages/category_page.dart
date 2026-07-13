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
  int _categoryColorIndex = 0;
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
    Color categoryColor = CategoryHandler.colorList[_categoryColorIndex];

    if (categoryName == "") {
      _categoryFieldFocusNode.requestFocus();
      return;
    }

    CategoryHandler.addCategory(name: categoryName, color: categoryColor);

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
                  TitleCard(title: "Create a Category"),
                  PrimaryTextField(
                    controller: _categoryNameStringController,
                    focusNode: _categoryFieldFocusNode,
                    labelText: "Enter Category Name",
                    prefixIcon: Icon(Icons.category_rounded),
                  ),
                  Center(
                    child: SizedBox(
                      height: 50,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        physics: BouncingScrollPhysics(),
                        itemCount: CategoryHandler.colorList.length,
                        itemBuilder: (context, index) {
                          Color currentColor = CategoryHandler.colorList[index];
                          bool selected = index == _categoryColorIndex;
                          return CategoryColorChip(
                            selected: selected,
                            currentColor: currentColor,
                            onSelected: (value) {
                              setState(() {
                                _categoryColorIndex = index;
                              });
                            },
                          );
                        },
                      ),
                    ),
                  ),
                  PrimaryButton(
                    text: "Create",
                    icon: Icon(Icons.add_circle_rounded),
                    onPressed: createCategory,
                  ),
                ],
              ),
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
            ],
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }
}

class CategoryColorChip extends StatelessWidget {
  const CategoryColorChip({
    super.key,
    required this.selected,
    required this.currentColor,
    required this.onSelected,
  });

  final bool selected;
  final Color currentColor;
  final ValueChanged<bool> onSelected;

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: selected ? Icon(Icons.check_rounded) : Text(""),
      selected: selected,
      color: WidgetStatePropertyAll(currentColor),
      showCheckmark: false,
      padding: EdgeInsets.all(selected ? 10 : 8),
      shape: CircleBorder(
        side: BorderSide(
          color:
              (Theme.of(context).colorScheme.brightness == Brightness.dark
                      ? Colors.white
                      : Colors.black)
                  .withAlpha(50),
          width: 2,
        ),
      ),
      onSelected: onSelected,
    );
  }
}
