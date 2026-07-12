import 'package:flutter/material.dart';
import 'package:todo_list/data/constants.dart';
import 'package:todo_list/data/todos.dart';
import 'package:todo_list/widgets/action_button.dart';
import 'package:todo_list/widgets/edit_sheet.dart';

class TodoCard extends StatelessWidget {
  const TodoCard({super.key, required this.currentTodo, this.lastCard = false});

  final Todo currentTodo;
  final bool lastCard;

  @override
  Widget build(BuildContext context) {
    List<Widget> actionRowWidgets = currentTodo.completed
        ? [
            ActionButton(
              icon: Icon(Icons.undo_rounded),
              onPressed: () {
                currentTodo.markUncompleted();
              },
            ),
            ActionButton(
              icon: Icon(Icons.delete_forever),
              onPressed: () {
                TodoHandler.removeTodo(id: currentTodo.id);
              },
            ),
          ]
        : [
            ActionButton(
              icon: Icon(Icons.edit_rounded),
              onPressed: () {
                TextEditingController newTaskStringController =
                    TextEditingController(text: currentTodo.task);
                showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return EditSheet(
                      title: "Edit Todo",
                      textFieldLabel: "Enter Task",
                      currentString: currentTodo.task,
                      newStringController: newTaskStringController,
                      editObject: (String newString) {
                        currentTodo.editTask(newString);
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
              icon: Icon(Icons.check_rounded),
              onPressed: () {
                currentTodo.markCompleted();
              },
            ),
          ];

    return Container(
      margin: lastCard
          ? const EdgeInsets.symmetric(vertical: 10)
          : const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: currentTodo.category?.color ?? KColors.defaultCategoryColor,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(16),
          bottom: Radius.circular(6),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Text(
                currentTodo.task,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  decoration: currentTodo.completed
                      ? TextDecoration.lineThrough
                      : null,
                  fontStyle: currentTodo.completed ? FontStyle.italic : null,
                  decorationThickness: 2,
                ),
              ),
            ),
          ),
          Row(children: actionRowWidgets),
        ],
      ),
    );
  }
}
