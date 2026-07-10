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
    return AnimatedBuilder(
      animation: Listenable.merge([
        SettingsValueNotifiers.themeColor,
        SettingsValueNotifiers.useDarkBrightness,
      ]),
      builder: (context, child) {
        return MaterialApp(
          title: "Todo App",
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: SettingsValueNotifiers.themeColor.value,
              brightness: SettingsValueNotifiers.useDarkBrightness.value
                  ? Brightness.dark
                  : Brightness.light,
              contrastLevel: SettingsValueNotifiers.useDarkBrightness.value
                  ? 0.3
                  : 0.2,
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

  void cycleThemeColor() {
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

  void toggleBrightness() {
    SettingsValueNotifiers.useDarkBrightness.value =
        !SettingsValueNotifiers.useDarkBrightness.value;
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
            child: Row(
              children: [
                IconButton(
                  onPressed: cycleThemeColor,
                  icon: Icon(Icons.brush_rounded),
                ),
                IconButton(
                  onPressed: toggleBrightness,
                  icon: Icon(
                    SettingsValueNotifiers.useDarkBrightness.value
                        ? Icons.dark_mode_rounded
                        : Icons.light_mode_rounded,
                  ),
                ),
              ],
            ),
          ),
        ],
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: TodoPage(),
    );
  }
}
