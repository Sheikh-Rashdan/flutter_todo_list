import "package:flutter/material.dart";
import "package:todo_list/data/categories.dart";
import "package:todo_list/widgets/category_page/category_card.dart";
import "package:todo_list/widgets/content_column.dart";
import "package:todo_list/widgets/scrollable_fade_column.dart";
import "package:todo_list/widgets/title_card.dart";

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
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
            ],
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }
}
