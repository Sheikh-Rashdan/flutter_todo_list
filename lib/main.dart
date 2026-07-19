import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_list/data/categories.dart';
import 'package:todo_list/data/constants.dart';
import 'package:todo_list/data/navigation.dart';
import 'package:todo_list/data/settings.dart';
import 'package:todo_list/data/todos.dart';

Future<Map<String, dynamic>> loadSharedPreferences() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  Map<String, dynamic> savedSettings = {};
  savedSettings[KPrefKeys.useDarkBrightnessKey] = prefs.getBool(
    KPrefKeys.useDarkBrightnessKey,
  );
  savedSettings[KPrefKeys.colorThemeIndexKey] = prefs.getInt(
    KPrefKeys.colorThemeIndexKey,
  );
  return savedSettings;
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Map<String, dynamic> savedSettings = await loadSharedPreferences();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (BuildContext context) => SettingsModel(
            savedSettings[KPrefKeys.colorThemeIndexKey],
            savedSettings[KPrefKeys.useDarkBrightnessKey],
          ),
        ),
        ChangeNotifierProvider(
          create: (BuildContext context) => NavigationModel(),
        ),
        ChangeNotifierProvider(create: (BuildContext context) => TodoModel()),
        ChangeNotifierProvider(
          create: (BuildContext context) => CategoryModel(),
        ),
      ],
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    SettingsModel settingsModel = context.watch<SettingsModel>();
    return MaterialApp(
      title: "Todo App",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: settingsModel.themeColor,
          brightness: settingsModel.brightness,
          contrastLevel: settingsModel.useDarkBrightness ? 0.3 : 0.2,
        ),
        useMaterial3: true,
      ),
      home: Home(),
    );
  }
}

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    SettingsModel settingsModel = context.read<SettingsModel>();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Todo App",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w500,
            color: Theme.of(context).colorScheme.tertiary,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                IconButton(
                  onPressed: settingsModel.cycleThemeColor,
                  icon: Icon(Icons.brush_rounded),
                ),
                IconButton(
                  onPressed: settingsModel.toggleBrightness,
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
      bottomNavigationBar: Consumer<NavigationModel>(
        builder: (context, navigationModel, child) => SizedBox(
          height: 70,
          child: BottomNavigationBar(
            currentIndex: navigationModel.pageIndex,
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
              navigationModel.setIndex(index);
            },
          ),
        ),
      ),
      body: Consumer<NavigationModel>(
        builder: (context, navigationModel, child) {
          return navigationModel.page;
        },
      ),
    );
  }
}
