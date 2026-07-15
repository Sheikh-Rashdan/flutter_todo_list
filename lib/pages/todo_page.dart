import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
  String? _filterCategoryId;

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

    CategoryModel categoryModel = context.read<CategoryModel>();
    TodoModel todoModel = context.read<TodoModel>();

    Category? selectedCategory = categoryModel.getCategoryById(
      _selectedCategoryId,
    );
    todoModel.addTodo(task: taskString, category: selectedCategory);

    setState(() {
      _taskStringController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    bool todoCompletedFilter = _selectedOutput == "Completed";

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
                  Consumer<TodoModel>(
                    builder: (context, todoModel, child) {
                      List<Todo> todoDisplayList = todoModel.getTodos(
                        completed: todoCompletedFilter,
                        categoryId: _filterCategoryId,
                      );
                      return ScrollableFadeColumn(
                        height: 275,
                        itemCount: todoDisplayList.length,
                        itemBuilder: (context, index) {
                          Todo currentTodo = todoDisplayList[index];
                          return TodoCard(
                            currentTodo: currentTodo,
                            lastCard: index + 1 == todoDisplayList.length,
                          );
                        },
                        emptyWidget: Text(
                          "No ${todoCompletedFilter ? "Completed" : "Pending"} Tasks ${_filterCategoryId != null ? "with Filter" : ""}",
                        ),
                      );
                    },
                  ),
                  Consumer<TodoModel>(
                    builder: (context, todoModel, child) {
                      return todoModel.getTodos().isNotEmpty
                          ? CategoryFilterCard(
                              filterCategoryId: _filterCategoryId,
                              onChanged: (String? id) {
                                setState(() {
                                  _filterCategoryId = id;
                                });
                              },
                            )
                          : SizedBox();
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

class CategoryFilterCard extends StatelessWidget {
  const CategoryFilterCard({
    super.key,
    required this._filterCategoryId,
    required this.onChanged,
  });

  final String? _filterCategoryId;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return TitleCard(
      widget: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Filter Category: ",
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w500),
          ),
          Consumer<CategoryModel>(
            builder: (context, categoryModel, child) {
              return DropdownButton<String>(
                value: _filterCategoryId,
                items: List.generate(categoryModel.categoryList.length + 1, (
                  int index,
                ) {
                  if (index == 0) {
                    return DropdownMenuItem<String>(
                      value: null,
                      child: Text("None"),
                    );
                  }
                  index--;
                  Category category = categoryModel.categoryList[index];
                  return DropdownMenuItem<String>(
                    value: category.id,
                    child: Text(
                      category.name,
                      style: TextStyle(color: category.color),
                    ),
                  );
                }),
                isDense: true,
                hint: Text("Category"),
                onChanged: onChanged,
              );
            },
          ),
        ],
      ),
    );
  }
}
