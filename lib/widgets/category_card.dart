import "dart:math";

import "package:flutter/material.dart";
import "package:todo_list/data/categories.dart";
import "package:todo_list/widgets/action_button.dart";
import "package:todo_list/widgets/confirm_dialog.dart";
import "package:todo_list/widgets/primary_button.dart";
import "package:todo_list/widgets/title_card.dart";

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
              ActionButton(
                icon: Icon(Icons.edit_rounded),
                onPressed: () {
                  TextEditingController newCategoryStringController =
                      TextEditingController(text: currentCategory.name);
                  showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return EditCategorySheet(
                        newCategoryStringController:
                            newCategoryStringController,
                        currentCategory: currentCategory,
                      );
                    },
                    isScrollControlled: true,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  );
                },
              ),
              ActionButton(
                icon: Icon(Icons.delete_forever_rounded),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return ConfirmDialog(
                        title: "Delete Category?",
                        iconData: Icons.warning_amber_rounded,
                        onConfirm: () {
                          CategoryHandler.removeCategory(
                            id: currentCategory.id,
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class EditCategorySheet extends StatefulWidget {
  const EditCategorySheet({
    super.key,
    required this.newCategoryStringController,
    required this.currentCategory,
  });

  final TextEditingController newCategoryStringController;
  final Category currentCategory;

  @override
  State<EditCategorySheet> createState() => _EditCategorySheetState();
}

class _EditCategorySheetState extends State<EditCategorySheet> {
  @override
  Widget build(BuildContext context) {
    bool buttonEnabled =
        widget.newCategoryStringController.text != widget.currentCategory.name;
    return Padding(
      padding: EdgeInsets.only(
        left: 10,
        right: 10,
        top: 10,
        bottom: max(50, MediaQuery.of(context).viewInsets.bottom + 10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        spacing: 12,
        children: [
          TitleCard(title: "Edit Category"),
          TextField(
            controller: widget.newCategoryStringController,
            style: TextStyle(color: Theme.of(context).colorScheme.primary),
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              label: Text(
                "Enter Category Name",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              prefixIcon: Icon(Icons.bookmark_add),
              prefixIconColor: Theme.of(context).colorScheme.primary,
            ),
            onChanged: (String value) {
              setState(() {});
            },
          ),
          PrimaryButton(
            text: "Edit",
            icon: Icon(Icons.edit_rounded),
            onPressed: buttonEnabled
                ? () {
                    String newName = widget.newCategoryStringController.text;
                    if (newName != widget.currentCategory.name) {
                      widget.currentCategory.editCategory(newName);
                    }
                    Navigator.of(context).pop();
                  }
                : null,
          ),
        ],
      ),
    );
  }
}
