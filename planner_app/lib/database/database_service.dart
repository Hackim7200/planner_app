import 'package:path/path.dart';
import 'package:planner_app/database/Task.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  static Database? _db;
  static final DatabaseService instance = DatabaseService._internal();

  final String _tasksTableName = "Tasks";
  final String _taskIdColumnName = "id";
  final String _taskTitleColumnName = "title";
  final String _taskPartOfDayColumnName = "part_of_day";
  final String _taskCreatedAtColumnName = "created_at";
  final String _taskTypeColumnName = "type";
  final String _taskDurationColumnName = "duration";
  final String _taskCompletedColumnName = "completed";
  final String _taskDescriptionColumnName = "description";
  final String _taskOrderColumnName = "order";

  DatabaseService._internal();

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDatabase();
    return _db!;
  }

  Future<Database> _initDatabase() async {
    try {
      final databaseDirPath = await getDatabasesPath();
      final databasePath = join(databaseDirPath, "master_db.db");

      return await openDatabase(
        databasePath,
        version: 1,
        onCreate: (db, version) {
          db.execute("""
    CREATE TABLE $_tasksTableName (
  $_taskIdColumnName INTEGER PRIMARY KEY AUTOINCREMENT,
  $_taskCreatedAtColumnName TEXT NOT NULL,
  $_taskTitleColumnName TEXT NOT NULL,
  $_taskTypeColumnName TEXT NOT NULL,
  $_taskDurationColumnName REAL NOT NULL,
  $_taskCompletedColumnName INTEGER NOT NULL,
  $_taskPartOfDayColumnName TEXT NOT NULL,
  $_taskDescriptionColumnName TEXT NOT NULL,
  $_taskOrderColumnName INTEGER NOT NULL
);
          );
          """);
        },
      );
    } catch (e) {
      throw Exception("Error initializing database: $e");
    }
  }

  // Future<void> addTask(
  //     String title, String type, double duration, String partOfDay) async {
  //   try {
  //     final db = await database;

  //     await db.insert(
  //       _tasksTableName,
  //       {
  //         _taskTitleColumnName: title,
  //         _taskTypeColumnName: type,
  //         _taskDurationColumnName: duration,
  //         _taskCompletedColumnName: 0, // Store false as 0
  //         _taskPartOfDayColumnName: partOfDay,
  //         _taskCreatedAtColumnName: DateTime.now().toIso8601String(),
  //         _taskDescriptionColumnName: "Your description here",
  //       },
  //     );
  //     print(
  //         "Task added: $title, Type: $type, Duration: $duration, Part of Day: $partOfDay");
  //   } catch (e) {
  //     throw Exception("Error adding task: $e");
  //   }
  // }
  Future<void> addTask(
      String title, String type, double duration, String partOfDay) async {
    try {
      final db = await database;

      final result = await db.rawQuery(
          'SELECT MAX($_taskOrderColumnName) as max_order FROM $_tasksTableName WHERE $_taskPartOfDayColumnName = ?',
          [partOfDay]);

      int newOrder = (result.first['max_order'] as int? ?? -1) + 1;

      await db.insert(
        _tasksTableName,
        {
          _taskTitleColumnName: title,
          _taskTypeColumnName: type,
          _taskDurationColumnName: duration,
          _taskCompletedColumnName: 0,
          _taskPartOfDayColumnName: partOfDay,
          _taskCreatedAtColumnName: DateTime.now().toIso8601String(),
          _taskDescriptionColumnName: "Your description here",
          _taskOrderColumnName: newOrder,
        },
      );
    } catch (e) {
      throw Exception("Error adding task: $e");
    }
  }

  Future<List<Task>> getTasksForTime(String time) async {
    try {
      final db = await database;
      final data = await db.query(_tasksTableName,
          where: "$_taskPartOfDayColumnName = ?", whereArgs: [time]);

      List<Task> tasks = data
          .map(
            (task) => Task(
              id: task[_taskIdColumnName] as int,
              title: task[_taskTitleColumnName] as String,
              type: task[_taskTypeColumnName] as String,
              duration: (task[_taskDurationColumnName] as num).toDouble(),
              completed: (task[_taskCompletedColumnName] as int) == 1,
              partOfDay: task[_taskPartOfDayColumnName] as String,
              createdAt:
                  DateTime.parse(task[_taskCreatedAtColumnName] as String),
              description: task[_taskDescriptionColumnName] as String,
            ),
          )
          .toList();

      return tasks;
    } catch (e) {
      throw Exception("Error retrieving tasks: $e");
    }
  }

  Future<void> reorderTask(
      int movedTaskId, int oldIndex, int newIndex, String partOfDay) async {
    final db = await database;
    try {
      await db.transaction((txn) async {
        if (oldIndex < newIndex) {
          await txn.rawUpdate('''
          UPDATE $_tasksTableName
          SET $_taskOrderColumnName = $_taskOrderColumnName - 1
          WHERE $_taskPartOfDayColumnName = ? AND $_taskOrderColumnName > ? AND $_taskOrderColumnName <= ?
        ''', [partOfDay, oldIndex, newIndex]);
        } else {
          await txn.rawUpdate('''
          UPDATE $_tasksTableName
          SET $_taskOrderColumnName = $_taskOrderColumnName + 1
          WHERE $_taskPartOfDayColumnName = ? AND $_taskOrderColumnName >= ? AND $_taskOrderColumnName < ?
        ''', [partOfDay, newIndex, oldIndex]);
        }

        await txn.rawUpdate('''
        UPDATE $_tasksTableName
        SET $_taskOrderColumnName = ?
        WHERE $_taskIdColumnName = ?
      ''', [newIndex, movedTaskId]);
      });

      print('Task moved from $oldIndex to $newIndex');
    } catch (e) {
      print('Failed to reorder task: $e');
    }
  }
}
