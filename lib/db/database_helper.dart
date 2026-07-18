import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_list/data/categories.dart';

class DatabaseHelper {
  static final String _databaseName = "todo_list.db";
  static final int _databaseVersion = 1;
  static final String _todoTableName = "todo_table";
  static final String _categoryTableName = "category_table";

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  Database? _database;

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String databasePath = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(
      databasePath,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int versionNumber) async {
    await db.execute('''
      CREATE TABLE $_categoryTableName (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        color INTEGER NOT NULL
      )
    ''');
    print("CREATED DATABASE SUCCESFULLY");
  }

  Future<void> debugDeleteDatabase() async {
    String databasePath = join(await getDatabasesPath(), _databaseName);
    await deleteDatabase(databasePath);
    print("DELETE DATABASE SUCCESSFULLY");
  }

  Future<List<Category>> getCategories() async {
    Database db = await instance.database;
    List<Map<String, dynamic>> rows = await db.query(_categoryTableName);
    return rows.map((row) => Category.fromDbMap(row)).toList();
  }

  Future<int> insertCategory(Map<String, dynamic> dbMap) async {
    Database db = await instance.database;
    return await db.insert(_categoryTableName, dbMap);
  }
}
