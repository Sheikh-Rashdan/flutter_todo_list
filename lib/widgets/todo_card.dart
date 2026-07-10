import 'package:flutter/material.dart';
import 'package:todo_list/data/constants.dart';
import 'package:todo_list/data/todos.dart';

class TodoCard extends StatelessWidget {
  const TodoCard({super.key, required this.currentTodo, this.lastCard = false});

  final Todo currentTodo;
  final bool lastCard;

  @override
  Widget build(BuildContext context) {
    IconButton actionButton = currentTodo.completed
        ? IconButton.filledTonal(
            style: FilledButton.styleFrom(
              backgroundColor: Colors.white.withAlpha(50),
            ),
            padding: const EdgeInsets.all(4),
            constraints: const BoxConstraints(),
            onPressed: () {
              TodoHandler.removeTodo(id: currentTodo.id);
            },
            icon: Icon(Icons.delete_forever),
          )
        : IconButton.filledTonal(
            style: FilledButton.styleFrom(
              backgroundColor: Colors.white.withAlpha(50),
            ),
            padding: const EdgeInsets.all(4),
            constraints: const BoxConstraints(),
            onPressed: () {
              currentTodo.markCompleted();
            },
            icon: Icon(Icons.check_rounded),
          );

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
          actionButton,
        ],
      ),
    );
  }
}
