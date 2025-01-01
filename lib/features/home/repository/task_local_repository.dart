import 'package:frontend/models/task_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class TaskLocalRepository {
  String tableName = 'tasks';
  Database? _database;
  //getter method to get or initialize the database
  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await _initDatabase();
    return _database!;
  }

  //init database method
  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'task.db');

    return openDatabase(path, version: 1, onCreate: (db, version) {
      return db.execute('''
        CREATE TABLE $tableName(
      id TEXT PRIMARY KEY,
      title TEXT NOT NULL,
      description TEXT NOT NULL,
      hexColor TEXT NOT NULL,
      due_date TEXT NOT NULL,
      created_at DATETIME NOT NULL,
      updated_at DATETIME NOT NULL
      )
        ''');
    });
  }

  //insert user method to database
  Future<void> insertTask(Task task) async {
    final db = await database;
    await db.insert(
      tableName,
      task.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> insertTasks(List<Task> tasks) async {
    final db = await database;
    final batch = db.batch();
    for (final task in tasks) {
      batch.insert(
        tableName,
        task.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit(noResult: true);
  }

  //get user method to get user from database
  Future<List<Task>?> getTasks() async {
    final db = await database;
    final result = await db.query(
      tableName,
    );
    if (result.isNotEmpty) {
      List<Task> tasks = [];
      for (final elem in result) {
        tasks.add(Task.fromMap(elem));
      }
      return tasks;
    }
    return null;
  }

  Future<void> deleteTask(String id) async {
    final db = await database;
    await db.delete(tableName, where: 'id = ?', whereArgs: [id]);
  }

  Future<void> showTableColumns() async {
    final db = await database;

    final tableInfo = await db.rawQuery('PRAGMA table_info(tasks)');

    for (final row in tableInfo) {
      print('Column: ${row['name']}, Type: ${row['type']}');
    }
  }
}
