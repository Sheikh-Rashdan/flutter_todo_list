import "package:flutter/material.dart";
import "package:todo_list/data/categories.dart";
import "package:todo_list/widgets/action_button.dart";

class CategoryCard extends StatelessWidget {
  const CategoryCard({
    super.key,
    required this.currentCategory,
    this.lastCard = false,
  });

  final Category currentCategory;
  final bool lastCard;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: currentCategory.color,
        borderRadius: BorderRadius.circular(10),
      ),
      margin: lastCard
          ? EdgeInsets.symmetric(vertical: 10)
          : EdgeInsets.only(top: 10),
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: Text(
                currentCategory.name,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          ),
          Row(
            children: [
              ActionButton(icon: Icon(Icons.edit_rounded), onPressed: () {}),
              ActionButton(
                icon: Icon(Icons.delete_forever_rounded),
                onPressed: () {
                  CategoryHandler.removeCategory(id: currentCategory.id);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
