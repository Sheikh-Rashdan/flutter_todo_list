import 'dart:math';

import 'package:flutter/material.dart';
import 'package:todo_list/data/constants.dart';
import 'package:todo_list/data/todos.dart';
import 'package:todo_list/widgets/action_button.dart';
import 'package:todo_list/widgets/primary_button.dart';
import 'package:todo_list/widgets/title_card.dart';

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
                  isScrollControlled: true,
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

class EditTodoSheet extends StatefulWidget {
  const EditTodoSheet({
    super.key,
    required this.newTaskStringController,
    required this.currentTodo,
  });

  final TextEditingController newTaskStringController;
  final Todo currentTodo;

  @override
  State<EditTodoSheet> createState() => _EditTodoSheetState();
}

class _EditTodoSheetState extends State<EditTodoSheet> {
  @override
  Widget build(BuildContext context) {
    bool buttonEnabled =
        widget.newTaskStringController.text != widget.currentTodo.task;
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
          TitleCard(title: "Edit Todo"),
          TextField(
            controller: widget.newTaskStringController,
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
                "Enter Task",
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
                    String newTask = widget.newTaskStringController.text;
                    if (newTask != widget.currentTodo.task) {
                      widget.currentTodo.editTask(newTask);
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
