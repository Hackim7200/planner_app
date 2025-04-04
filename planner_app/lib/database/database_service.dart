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
  final String _taskDueDateColumnName = "task_due_date";
  final String _taskTypeColumnName = "type";
  final String _taskDurationColumnName = "duration";
  final String _taskCompletedColumnName = "completed";
  final String _taskDescriptionColumnName = "description";
  final String _taskOrderColumnName = "task_order";

  final String _habitsTableName = "Habits";
  final String _habitIdColumnName = "id";
  final String _habitTitleColumnName = "title";
  final String _habitPartOfDayColumnName = "part_of_day";
  final String _habitFrequencyColumnName = "frequency";

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
              $_taskDueDateColumnName TEXT NOT NULL,
              $_taskTitleColumnName TEXT NOT NULL,
              $_taskTypeColumnName TEXT NOT NULL,
              $_taskDurationColumnName REAL NOT NULL,
              $_taskCompletedColumnName INTEGER NOT NULL,
              $_taskPartOfDayColumnName TEXT NOT NULL,
              $_taskDescriptionColumnName TEXT NOT NULL,
              $_taskOrderColumnName INTEGER NOT NULL

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
  Future<void> addTask(String title, String type, double duration,
      String partOfDay, bool isToday) async {
    try {
      final db = await database;

      final result = await db.rawQuery(
          'SELECT MAX($_taskOrderColumnName) as max_order FROM $_tasksTableName WHERE $_taskPartOfDayColumnName = ?',
          [partOfDay]);

      int newOrder = (result.first['max_order'] as int? ?? -1) + 1;

      String date = DateTime.now().toIso8601String();

      if (isToday == false) {
        date = DateTime.now().add(const Duration(days: 1)).toIso8601String();
      }
      await db.insert(
        _tasksTableName,
        {
          _taskTitleColumnName: title,
          _taskTypeColumnName: type,
          _taskDurationColumnName: duration,
          _taskCompletedColumnName: 0,
          _taskPartOfDayColumnName: partOfDay,
          _taskDueDateColumnName: date,
          _taskDescriptionColumnName: "Your description here",
          _taskOrderColumnName: newOrder,
        },
      );
      print(
          "Task added: $title, Type: $type, Duration: $duration, Part of Day: $partOfDay , Order: $newOrder, Date: $date");
    } catch (e) {
      throw Exception("Error adding task: $e");
    }
  }

  Future<List<Task>> getTasksForTime(String time, bool isToday) async {
    try {
      // Only use the date part (yyyy-MM-dd)
      String date = DateTime.now().toIso8601String().split('T')[0];
      if (!isToday) {
        date = DateTime.now()
            .add(const Duration(days: 1))
            .toIso8601String()
            .split('T')[0];
      }

      final db = await database;
      final data = await db.query(
        _tasksTableName,
        where:
            "$_taskPartOfDayColumnName = ? AND date($_taskDueDateColumnName) = ?",
        whereArgs: [time, date],
        orderBy: "$_taskOrderColumnName ASC", // explicitly specify order
      );

      List<Task> tasks = data.map((task) {
        return Task(
          id: task[_taskIdColumnName] as int,
          title: task[_taskTitleColumnName] as String,
          type: task[_taskTypeColumnName] as String,
          duration: (task[_taskDurationColumnName] as num).toDouble(),
          completed: (task[_taskCompletedColumnName] as int) == 1,
          partOfDay: task[_taskPartOfDayColumnName] as String,
          dueDate: DateTime.parse(task[_taskDueDateColumnName] as String),
          description: task[_taskDescriptionColumnName] as String,
        );
      }).toList();

      print("Tasks retrieved: ${tasks.toString()}");
      return tasks;
    } catch (e) {
      throw Exception("Error retrieving tasks: $e");
    }
  }

  Future<void> reorderTask(
    int movedTaskId,
    int oldIndex,
    int newIndex,
    String partOfDay,
  ) async {
    final db = await database;
    try {
      await db.transaction((txn) async {
        if (oldIndex < newIndex) {
          await txn.rawUpdate('''
          UPDATE $_tasksTableName
          SET $_taskOrderColumnName = $_taskOrderColumnName - 1
          WHERE $_taskPartOfDayColumnName = ? AND $_taskOrderColumnName > ? AND $_taskOrderColumnName <= ?
        ''', [partOfDay, oldIndex, newIndex]);
        } else if (oldIndex > newIndex) {
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

  Future<void> deleteTask(int taskId, String partOfDay) async {
    final db = await database;
    try {
      await db.transaction((txn) async {
        final task = await txn.query(
          _tasksTableName,
          columns: [_taskOrderColumnName],
          where: "$_taskIdColumnName = ?",
          whereArgs: [taskId],
        );

        if (task.isEmpty) {
          print("Task not found");
          return;
        }

        int deletedOrder = task.first[_taskOrderColumnName] as int;

        await txn.delete(
          _tasksTableName,
          where: "$_taskIdColumnName = ?",
          whereArgs: [taskId],
        );

        await txn.rawUpdate('''
        UPDATE $_tasksTableName
        SET $_taskOrderColumnName = $_taskOrderColumnName - 1
        WHERE $_taskPartOfDayColumnName = ? AND $_taskOrderColumnName > ?
      ''', [partOfDay, deletedOrder]);

        print("Task deleted successfully");
      });
    } catch (e) {
      throw Exception("Error deleting task: $e");
    }
  }
}
