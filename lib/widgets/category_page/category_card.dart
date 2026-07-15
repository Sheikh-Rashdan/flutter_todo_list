import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:todo_list/data/categories.dart";
import "package:todo_list/data/todos.dart";
import "package:todo_list/widgets/action_button.dart";
import "package:todo_list/widgets/confirm_dialog.dart";
import "package:todo_list/widgets/edit_sheet.dart";

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
                      CategoryModel categoryModel = context
                          .read<CategoryModel>();
                      return EditSheet(
                        title: "Edit Category",
                        textFieldLabel: "Enter Category Name",
                        currentString: currentCategory.name,
                        newStringController: newCategoryStringController,
                        editObject: (String newString) {
                          categoryModel.editCategory(
                            currentCategory.id,
                            newName: newString,
                          );
                        },
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
                      CategoryModel categoryModel = context
                          .read<CategoryModel>();
                      TodoModel todoModel = context.read<TodoModel>();
                      return ConfirmDialog(
                        title: "Delete Category?",
                        iconData: Icons.warning_rounded,
                        onConfirm: () {
                          categoryModel.removeCategory(id: currentCategory.id);
                          todoModel.nullAllOfCategory(currentCategory.id);
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
