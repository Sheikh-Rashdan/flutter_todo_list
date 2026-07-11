import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_list/data/constants.dart';
import 'package:todo_list/data/navigation.dart';
import 'package:todo_list/data/settings.dart';
import 'package:todo_list/pages/category_page.dart';
import 'package:todo_list/pages/todo_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Settings.loadSharedPreferences();

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([
        Settings.themeColor,
        Settings.useDarkBrightness,
      ]),
      builder: (context, child) {
        return MaterialApp(
          title: "Todo App",
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Settings.themeColor.value,
              brightness: Settings.useDarkBrightness.value
                  ? Brightness.dark
                  : Brightness.light,
              contrastLevel: Settings.useDarkBrightness.value ? 0.3 : 0.2,
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

  final List<Widget> pages = const [TodoPage(), CategoryPage()];

  void cycleThemeColor() async {
    Color currentColor = Settings.themeColor.value;
    int length = KColors.themeColorOptions.length, newIndex = 0;
    for (int i = 0; i < length; i++) {
      if (KColors.themeColorOptions[i] == currentColor) {
        newIndex = (i + 1) % length;
        Settings.themeColor.value = KColors.themeColorOptions[newIndex];
        break;
      }
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(KPrefKeys.colorThemeIndexKey, newIndex);
  }

  void toggleBrightness() async {
    Settings.useDarkBrightness.value = !Settings.useDarkBrightness.value;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(
      KPrefKeys.useDarkBrightnessKey,
      Settings.useDarkBrightness.value,
    );
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
                    Theme.of(context).colorScheme.brightness == Brightness.dark
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
      bottomNavigationBar: ValueListenableBuilder(
        valueListenable: NavigationNotifiers.pageIndex,
        builder: (context, value, child) {
          return BottomNavigationBar(
            currentIndex: value,
            backgroundColor: Theme.of(
              context,
            ).colorScheme.inversePrimary.withAlpha(150),
            selectedIconTheme: IconThemeData(size: 28),
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.task_outlined),
                activeIcon: Icon(Icons.task_rounded),
                label: "Todos",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.category_outlined),
                activeIcon: Icon(Icons.category_rounded),
                label: "Categories",
              ),
            ],
            onTap: (int index) {
              NavigationNotifiers.pageIndex.value = index;
            },
          );
        },
      ),
      body: ValueListenableBuilder(
        valueListenable: NavigationNotifiers.pageIndex,
        builder: (context, value, child) {
          return pages[value];
        },
      ),
    );
  }
}
