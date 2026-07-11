import 'package:flutter/material.dart';
import 'package:todo_list/data/categories.dart';
import 'package:todo_list/data/todos.dart';
import 'package:todo_list/widgets/category_dropdown.dart';
import 'package:todo_list/widgets/content_column.dart';
import 'package:todo_list/widgets/primary_button.dart';
import 'package:todo_list/widgets/scrollable_fade_column.dart';
import 'package:todo_list/widgets/task_field.dart';
import 'package:todo_list/widgets/title_card.dart';
import 'package:todo_list/widgets/todo_card.dart';

class TodoPage extends StatefulWidget {
  const TodoPage({super.key});

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  String? _selectedCategoryId;
  final TextEditingController _taskStringController = TextEditingController();
  late FocusNode _taskFieldFocusNode;

  @override
  void initState() {
    super.initState();
    _taskFieldFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _taskFieldFocusNode.dispose();
    super.dispose();
  }

  void createTask() {
    String taskString = _taskStringController.text.trim();
    if (taskString == "") {
      _taskFieldFocusNode.requestFocus();
      return;
    }

    Category? selectedCategory = CategoryHandler.getCategoryById(
      _selectedCategoryId,
    );
    TodoHandler.addTodo(task: taskString, category: selectedCategory);

    setState(() {
      _taskStringController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
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
                  const TitleCard(title: "Create a Todo"),
                  TaskField(
                    controller: _taskStringController,
                    focusNode: _taskFieldFocusNode,
                  ),
                  Row(
                    spacing: 5,
                    children: [
                      CategoryDropdown(
                        selectedValue: _selectedCategoryId,
                        onChanged: (String? categoryId) {
                          setState(() {
                            _selectedCategoryId = categoryId!;
                          });
                        },
                      ),
                      IconButton.outlined(
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(
                            color: _selectedCategoryId != null
                                ? Theme.of(context).colorScheme.primary
                                : Colors.grey,
                          ),
                          foregroundColor: Theme.of(
                            context,
                          ).colorScheme.primary,
                          backgroundColor: Theme.of(
                            context,
                          ).colorScheme.primary.withAlpha(50),
                          disabledForegroundColor: Colors.grey,
                          disabledBackgroundColor: Colors.grey.withAlpha(50),
                        ),
                        onPressed: _selectedCategoryId != null
                            ? () {
                                setState(() {
                                  _selectedCategoryId = null;
                                });
                              }
                            : null,
                        icon: Icon(Icons.clear_all_rounded),
                        tooltip: "Clear Category",
                      ),
                    ],
                  ),
                  PrimaryButton(
                    onPressed: createTask,
                    text: "Create",
                    icon: Icon(Icons.add_circle_outline_rounded),
                  ),
                ],
              ),
              ContentColumn(
                children: [
                  TitleCard(title: "Uncompleted Tasks"),
                  ValueListenableBuilder(
                    valueListenable: TodoHandler.todoListNotifier,
                    builder: (context, value, child) {
                      return ScrollableFadeColumn(
                        height: 250,
                        itemCount: TodoHandler.getUncompletedTodosLength(),
                        itemBuilder: (context, index) {
                          Todo currentTodo =
                              TodoHandler.getUncompletedTodos()[index];
                          return TodoCard(
                            currentTodo: currentTodo,
                            lastCard:
                                index + 1 ==
                                TodoHandler.getUncompletedTodosLength(),
                          );
                        },
                        emptyWidget: Text("No Uncompleted Tasks"),
                      );
                    },
                  ),
                  TitleCard(title: "Completed Tasks"),

                  ValueListenableBuilder(
                    valueListenable: TodoHandler.todoListNotifier,
                    builder: (context, value, child) {
                      return ScrollableFadeColumn(
                        height: 250,
                        itemCount: TodoHandler.getCompletedTodosLength(),
                        itemBuilder: (context, index) {
                          Todo currentTodo =
                              TodoHandler.getCompletedTodos()[index];
                          return TodoCard(
                            currentTodo: currentTodo,
                            lastCard:
                                index + 1 ==
                                TodoHandler.getCompletedTodosLength(),
                          );
                        },
                        emptyWidget: Text("No Completed Tasks"),
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
