import 'package:flutter/material.dart';
import 'package:todo_list/data/constants.dart';
import 'package:todo_list/data/value_notifiers.dart';
import 'package:todo_list/pages/todo_page.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: SettingsValueNotifiers.themeColor,
      builder: (context, value, child) {
        return MaterialApp(
          title: "Todo App",
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: value,
              brightness: Brightness.dark,
              contrastLevel: 0.3,
            ),
            useMaterial3: true,
          ),
          home: Home(),
        );
      },
    );
  }
}

class Home extends StatelessWidget {
  const Home({super.key});

  void toggleThemeColor() {
    Color currentColor = SettingsValueNotifiers.themeColor.value;
    for (Color color in KColors.themeColorOptions) {
      if (color == currentColor) {
        SettingsValueNotifiers.themeColor.value =
            KColors.themeColorOptions[(KColors.themeColorOptions.indexOf(
                      currentColor,
                    ) +
                    1) %
                KColors.themeColorOptions.length];
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Todo App",
          style: KTextStyles.title1.copyWith(
            color: Theme.of(context).colorScheme.tertiary,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: IconButton(
              onPressed: toggleThemeColor,
              icon: Icon(Icons.brush_rounded),
            ),
          ),
        ],
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: TodoPage(),
    );
  }
}
