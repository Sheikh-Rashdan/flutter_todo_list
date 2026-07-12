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
  String _selectedOutput = "Uncompleted";
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
                  SegmentedButton<String>(
                    segments: [
                      ButtonSegment(
                        value: "Uncompleted",
                        label: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Text("Uncompleted"),
                        ),
                        icon: Icon(Icons.view_headline_rounded),
                      ),
                      ButtonSegment(
                        value: "Completed",
                        label: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Text("Completed"),
                        ),
                        icon: Icon(Icons.checklist_rounded),
                      ),
                    ],
                    selected: {_selectedOutput},
                    showSelectedIcon: false,
                    style: SegmentedButton.styleFrom(
                      textStyle: Theme.of(context).textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.w500),
                      iconSize: Theme.of(
                        context,
                      ).textTheme.titleLarge?.fontSize,
                      selectedBackgroundColor: Theme.of(
                        context,
                      ).colorScheme.inversePrimary,
                      side: BorderSide(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        width: 2,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadiusGeometry.circular(10),
                      ),
                    ),
                    onSelectionChanged: (Set<String> set) {
                      setState(() {
                        _selectedOutput = set.single;
                      });
                    },
                  ),
                  ValueListenableBuilder(
                    valueListenable: TodoHandler.todoListNotifier,
                    builder: (context, value, child) {
                      return _selectedOutput == "Uncompleted"
                          ? ScrollableFadeColumn(
                              height: 250,
                              itemCount:
                                  TodoHandler.getUncompletedTodosLength(),
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
                            )
                          : ScrollableFadeColumn(
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
