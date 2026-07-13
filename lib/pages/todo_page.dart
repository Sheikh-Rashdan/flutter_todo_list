import 'package:flutter/material.dart';
import 'package:todo_list/data/categories.dart';
import 'package:todo_list/data/todos.dart';
import 'package:todo_list/widgets/primary_text_field.dart';
import 'package:todo_list/widgets/todo_page/category_dropdown.dart';
import 'package:todo_list/widgets/content_column.dart';
import 'package:todo_list/widgets/primary_button.dart';
import 'package:todo_list/widgets/scrollable_fade_column.dart';
import 'package:todo_list/widgets/title_card.dart';
import 'package:todo_list/widgets/todo_page/todo_card.dart';
import 'package:todo_list/widgets/todo_page/todo_display_selection_segmented_button.dart';

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
                  PrimaryTextField(
                    controller: _taskStringController,
                    focusNode: _taskFieldFocusNode,
                    labelText: "Enter Task",
                    prefixIcon: Icon(Icons.bookmark_add),
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
                    icon: Icon(Icons.add_circle_rounded),
                  ),
                ],
              ),
              ContentColumn(
                children: [
                  TodoDisplaySelectionSegmentedButton(
                    selectedOutput: _selectedOutput,
                    onSelectionChanged: (Set<String> newSelection) {
                      setState(() {
                        _selectedOutput = newSelection.single;
                      });
                    },
                  ),
                  ValueListenableBuilder(
                    valueListenable: TodoHandler.todoListNotifier,
                    builder: (context, value, child) {
                      List<Todo> todoList = TodoHandler.getTodos(
                        completed: _selectedOutput == "Completed",
                      );
                      return ScrollableFadeColumn(
                        height: 300,
                        itemCount: todoList.length,
                        itemBuilder: (context, index) {
                          Todo currentTodo = todoList[index];
                          return TodoCard(
                            currentTodo: currentTodo,
                            lastCard: index + 1 == todoList.length,
                          );
                        },
                        emptyWidget: Text(
                          "No ${_selectedOutput == "Completed" ? "Completed" : "Uncompleted"} Tasks",
                        ),
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
