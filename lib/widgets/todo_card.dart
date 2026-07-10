import 'package:flutter/material.dart';
import 'package:todo_list/data/constants.dart';
import 'package:todo_list/data/todos.dart';

class TodoCard extends StatelessWidget {
  const TodoCard({super.key, required this.currentTodo, this.lastCard = false});

  final Todo currentTodo;
  final bool lastCard;

  @override
  Widget build(BuildContext context) {
    List<Widget> actionRowWidgets = currentTodo.completed
        ? [
            ActionButton(
              currentTodo: currentTodo,
              icon: Icon(Icons.undo_rounded),
              onPressed: () {
                currentTodo.markUncompleted();
              },
            ),
            ActionButton(
              currentTodo: currentTodo,
              icon: Icon(Icons.delete_forever),
              onPressed: () {
                TodoHandler.removeTodo(id: currentTodo.id);
              },
            ),
          ]
        : [
            ActionButton(
              currentTodo: currentTodo,
              icon: Icon(Icons.edit_rounded),
              onPressed: () {
                TextEditingController newTaskStringController =
                    TextEditingController(text: currentTodo.task);
                showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return EditTodoSheet(
                      newTaskStringController: newTaskStringController,
                      currentTodo: currentTodo,
                    );
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                );
              },
            ),
            ActionButton(
              currentTodo: currentTodo,
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
                  color: Colors.black,
                  decoration: currentTodo.completed
                      ? TextDecoration.lineThrough
                      : null,
                  fontStyle: currentTodo.completed ? FontStyle.italic : null,
                  decorationColor: Colors.black,
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

class EditTodoSheet extends StatelessWidget {
  const EditTodoSheet({
    super.key,
    required this.newTaskStringController,
    required this.currentTodo,
  });

  final TextEditingController newTaskStringController;
  final Todo currentTodo;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(controller: newTaskStringController),
        FilledButton.tonal(
          onPressed: () {
            String newTask = newTaskStringController.text;
            if (newTask != currentTodo.task) {
              currentTodo.editTask(newTask);
            }
            Navigator.of(context).pop();
          },
          child: Text("Edit"),
        ),
      ],
    );
  }
}

class ActionButton extends StatelessWidget {
  const ActionButton({
    super.key,
    required this.currentTodo,
    required this.icon,
    required this.onPressed,
  });

  final Todo currentTodo;
  final Icon icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton.filledTonal(
      style: FilledButton.styleFrom(
        backgroundColor: Colors.white.withAlpha(50),
      ),
      padding: const EdgeInsets.all(4),
      constraints: const BoxConstraints(),
      onPressed: onPressed,
      icon: icon,
    );
  }
}
