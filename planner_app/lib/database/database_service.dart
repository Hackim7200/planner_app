import 'package:path/path.dart';
import 'package:planner_app/database/backlog.dart';
import 'package:planner_app/database/habit.dart';

import 'package:planner_app/database/Task.dart';
import 'package:planner_app/database/event.dart';

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

  final String _swapTableName = "Swap";
  final String _swapIdColumnName = "id";

  final String _swapPartOfDayColumnName = "part_of_day";
  final String _swapPriorityColumnName = "priority";
  final String _swapHabitTypeColumnName = "habit_type";

  final String _swapAddictionTitleColumnName = "addiction_title";
  final String _swapAddictionEffectsColumnName = "addiction_effects";
  final String _swapAddictionTriggersColumnName = "addiction_triggers";
  final String _swapAddictionPleasuresColumnName = "addiction_pleasures";
  final String _swapAddictionActionsColumnName = "addiction_actions";

  final String _swapHabitTitleColumnName = "habit_title";
  final String _swapHabitEffectsColumnName = "habit_effects";
  final String _swapHabitTriggersColumnName = "habit_triggers";
  final String _swapHabitPleasuresColumnName = "habit_pleasures";
  final String _swapHabitActionsColumnName = "habit_actions";

  final String _eventTableName = "Events";
  final String _eventIdColumnName = "id";
  final String _eventTitleColumnName = "title";
  final String _eventDueDateColumnName = "event_due_date";
  final String _eventDescriptionColumnName = "description";
  final String _eventBackgroundColorColumnName = "background_color";
  final String _eventFontColorColumnName = "font_color";
  final String _eventIconColumnName = "icon_path";

  final String _backlogTableName = "Backlog";
  final String _backlogIdColumnName = "id";
  final String _backlogTitleColumnName = "title";
  final String _backlogDescriptionColumnName = "description";
  final String _backlogTimelineColumnName = "timeline";

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
              $_taskCompletedColumnName INTEGER NOT NULL DEFAULT 0,
              $_taskPartOfDayColumnName TEXT NOT NULL,
              $_taskDescriptionColumnName TEXT NOT NULL,
              $_taskOrderColumnName INTEGER NOT NULL
            );
          """);

          // Create Swap Table
          db.execute("""
            CREATE TABLE $_swapTableName (
              $_swapIdColumnName INTEGER PRIMARY KEY AUTOINCREMENT,
              $_swapPriorityColumnName INTEGER NOT NULL,
              $_swapHabitTypeColumnName TEXT NOT NULL,
              $_swapAddictionTitleColumnName TEXT NOT NULL,
              $_swapAddictionEffectsColumnName TEXT,
              $_swapAddictionTriggersColumnName TEXT,  
              $_swapAddictionPleasuresColumnName TEXT,  
              $_swapHabitTitleColumnName TEXT NOT NULL,
              $_swapHabitEffectsColumnName TEXT,
              $_swapHabitTriggersColumnName TEXT,    
              $_swapHabitPleasuresColumnName TEXT,    
              $_swapHabitActionsColumnName TEXT,
              $_swapAddictionActionsColumnName TEXT,
              $_swapPartOfDayColumnName TEXT NOT NULL
            );
          """);

          // Create Events Table
          db.execute("""
            CREATE TABLE $_eventTableName (
              $_eventIdColumnName INTEGER PRIMARY KEY AUTOINCREMENT,
              $_eventTitleColumnName TEXT NOT NULL,
              $_eventDueDateColumnName TEXT NOT NULL,
              $_eventDescriptionColumnName TEXT NOT NULL,
              $_eventBackgroundColorColumnName TEXT NOT NULL,
              $_eventFontColorColumnName TEXT NOT NULL,
              $_eventIconColumnName TEXT NOT NULL
            );
          """);

          // Create Backlog Table
          db.execute("""
            CREATE TABLE $_backlogTableName (
              $_backlogIdColumnName INTEGER PRIMARY KEY AUTOINCREMENT,
              $_backlogTitleColumnName TEXT NOT NULL,
              $_backlogDescriptionColumnName TEXT NOT NULL,
              $_backlogTimelineColumnName TEXT NOT NULL
            );
          """);
        },
      );
    } catch (e) {
      throw Exception("Error initializing database: $e");
    }
  }

  /// Inserts a new habit (swap entry) into the Swap table.
  Future<void> addHabit(int priority, String partOfDay, String addictionTitle,
      String habitTitle, String habitType) async {
    try {
      final db = await database;

      await db.insert(
        _swapTableName,
        {
          _swapPriorityColumnName: priority,
          _swapHabitTypeColumnName: habitType,
          _swapAddictionTitleColumnName: addictionTitle,
          _swapHabitTitleColumnName: habitTitle,
          _swapPartOfDayColumnName: partOfDay,
        },
      );
      print(
          "Habit (swap) added: addiction: $addictionTitle, habit: $habitTitle, type: $habitType");
    } catch (e) {
      throw Exception("Error adding habit (swap): $e");
    }
  }

  Future<List<Habit>> getAllHabits() async {
    try {
      final db = await database;
      // Use the correct table name.
      final data = await db.query(_swapTableName);

      List<Habit> habits = data.map((row) {
        return Habit(
          id: row[_swapIdColumnName] as int,
          priority: row[_swapPriorityColumnName] as int,
          addictionTitle: row[_swapAddictionTitleColumnName] as String,
          habitTitle: row[_swapHabitTitleColumnName] as String,
          partOfDay: row[_swapPartOfDayColumnName] as String,
          habitType: row[_swapHabitTypeColumnName] as String,
          addictionEffects:
              (row[_swapAddictionEffectsColumnName] as String? ?? "")
                  .split(", "),
          addictionTriggers:
              (row[_swapAddictionTriggersColumnName] as String? ?? "")
                  .split(", "),
          addictionPleasures:
              (row[_swapAddictionPleasuresColumnName] as String? ?? "")
                  .split(", "),
          habitEffects:
              (row[_swapHabitEffectsColumnName] as String? ?? "").split(", "),
          habitTriggers:
              (row[_swapHabitTriggersColumnName] as String? ?? "").split(", "),
          habitPleasures:
              (row[_swapHabitPleasuresColumnName] as String? ?? "").split(", "),
        );
      }).toList();

      print("Habits retrieved (${habits.length}): $habits");
      return habits;
    } catch (e) {
      throw Exception("Error retrieving habits: $e");
    }
  }

  /// Updates an existing habit (swap entry) in the Swap table.
  Future<void> updateHabit({
    required int id,
    required int priority,
    required String partOfDay,
    required String addictionTitle,
    required String addictionEffects,
    required String habitTitle,
    required String habitEffects,
    required String habitType,
  }) async {
    try {
      final db = await database;

      // Create a map of the new values
      Map<String, Object?> updatedValues = {
        _swapPriorityColumnName: priority,
        _swapPartOfDayColumnName: partOfDay,
        _swapAddictionTitleColumnName: addictionTitle,
        _swapAddictionEffectsColumnName: addictionEffects,
        _swapHabitTitleColumnName: habitTitle,
        _swapHabitEffectsColumnName: habitEffects,
        _swapHabitTypeColumnName: habitType,
      };

      // Execute the update query
      int count = await db.update(
        _swapTableName,
        updatedValues,
        where: "$_swapIdColumnName = ?",
        whereArgs: [id],
      );

      if (count == 0) {
        print("No habit found with id: $id");
      } else {
        print("Habit with id $id updated successfully.");
      }
    } catch (e) {
      throw Exception("Error updating habit with id $id: $e");
    }
  }

  // Get Effects
  Future<List<String>> getEffects(int id, bool isGood) async {
    try {
      final db = await database;
      final columnName = isGood
          ? _swapHabitEffectsColumnName
          : _swapAddictionEffectsColumnName;

      final data = await db.query(
        _swapTableName,
        where: "$_swapIdColumnName = ?",
        whereArgs: [id],
      );

      if (data.isEmpty || data.first[columnName] == null) {
        print("No data found for id: $id");
        return [];
      }

      final String effectsString = data.first[columnName] as String;
      final List<String> effects =
          effectsString.split(", ").where((e) => e.isNotEmpty).toList();

      return effects;
    } catch (e) {
      throw Exception("Error retrieving effects for habit with id $id: $e");
    }
  }

// Get Triggers
  Future<List<String>> getTriggers(int id, bool isGood) async {
    try {
      final db = await database;
      final columnName = isGood
          ? _swapHabitTriggersColumnName
          : _swapAddictionTriggersColumnName;

      final data = await db.query(
        _swapTableName,
        where: "$_swapIdColumnName = ?",
        whereArgs: [id],
      );

      if (data.isEmpty || data.first[columnName] == null) {
        print("No data found for id: $id");
        return [];
      }

      final String triggersString = data.first[columnName] as String;
      final List<String> triggers =
          triggersString.split(", ").where((e) => e.isNotEmpty).toList();

      return triggers;
    } catch (e) {
      throw Exception("Error retrieving triggers for habit with id $id: $e");
    }
  }

// Get Actions
  Future<List<String>> getActions(int id, bool isGood) async {
    try {
      final db = await database;
      final columnName = isGood
          ? _swapHabitActionsColumnName
          : _swapAddictionActionsColumnName;

      final data = await db.query(
        _swapTableName,
        where: "$_swapIdColumnName = ?",
        whereArgs: [id],
      );

      if (data.isEmpty || data.first[columnName] == null) {
        print("No data found for id: $id");
        return [];
      }

      final String actionsString = data.first[columnName] as String;
      final List<String> actions =
          actionsString.split(", ").where((e) => e.isNotEmpty).toList();

      return actions;
    } catch (e) {
      throw Exception("Error retrieving actions for habit with id $id: $e");
    }
  }

// Update Effects
  Future<void> updateEffects({
    required int id,
    required bool isGood,
    required String effects,
  }) async {
    try {
      final db = await database;
      final columnName = isGood
          ? _swapHabitEffectsColumnName
          : _swapAddictionEffectsColumnName;

      final Map<String, Object?> updatedValues = {columnName: effects};

      final count = await db.update(
        _swapTableName,
        updatedValues,
        where: "$_swapIdColumnName = ?",
        whereArgs: [id],
      );

      if (count == 0) {
        print("No habit found with id: $id");
      } else {
        print("Effects updated for habit with id $id.");
      }
    } catch (e) {
      throw Exception("Error updating effects for habit with id $id: $e");
    }
  }

// Update Triggers
  Future<void> updateTriggers({
    required int id,
    required bool isGood,
    required String triggers,
  }) async {
    try {
      final db = await database;
      final columnName = isGood
          ? _swapHabitTriggersColumnName
          : _swapAddictionTriggersColumnName;

      final Map<String, Object?> updatedValues = {columnName: triggers};

      final count = await db.update(
        _swapTableName,
        updatedValues,
        where: "$_swapIdColumnName = ?",
        whereArgs: [id],
      );

      if (count == 0) {
        print("No habit found with id: $id");
      } else {
        print("Triggers updated for habit with id $id.");
      }
    } catch (e) {
      throw Exception("Error updating triggers for habit with id $id: $e");
    }
  }

// Update Actions
  Future<void> updateActions({
    required int id,
    required bool isGood,
    required String actions,
  }) async {
    try {
      final db = await database;
      final columnName = isGood
          ? _swapHabitActionsColumnName
          : _swapAddictionActionsColumnName;

      final Map<String, Object?> updatedValues = {columnName: actions};

      final count = await db.update(
        _swapTableName,
        updatedValues,
        where: "$_swapIdColumnName = ?",
        whereArgs: [id],
      );

      if (count == 0) {
        print("No habit found with id: $id");
      } else {
        print("Actions updated for habit with id $id.");
      }
    } catch (e) {
      throw Exception("Error updating actions for habit with id $id: $e");
    }
  }

// Add Effect
  Future<void> addEffect({
    required int id,
    required bool isGood,
    required String effect,
  }) async {
    try {
      final db = await database;
      final columnName = isGood
          ? _swapHabitEffectsColumnName
          : _swapAddictionEffectsColumnName;

      final data = await db.query(
        _swapTableName,
        where: "$_swapIdColumnName = ?",
        whereArgs: [id],
      );

      if (data.isEmpty) {
        print("No data found for id: $id");
        return;
      }

      final String currentEffects = data.first[columnName] as String? ?? "";
      final updatedEffects =
          currentEffects.isEmpty ? effect : "$currentEffects, $effect";

      Map<String, Object?> updatedValues = {columnName: updatedEffects};

      int count = await db.update(
        _swapTableName,
        updatedValues,
        where: "$_swapIdColumnName = ?",
        whereArgs: [id],
      );

      if (count == 0) {
        print("No habit found with id: $id");
      } else {
        print("Effect added/updated for habit with id $id.");
      }
    } catch (e) {
      throw Exception("Error adding effect for habit with id $id: $e");
    }
  }

// Add Trigger
  Future<void> addTrigger({
    required int id,
    required bool isGood,
    required String trigger,
  }) async {
    try {
      final db = await database;
      final columnName = isGood
          ? _swapHabitTriggersColumnName
          : _swapAddictionTriggersColumnName;

      final data = await db.query(
        _swapTableName,
        where: "$_swapIdColumnName = ?",
        whereArgs: [id],
      );

      if (data.isEmpty) {
        print("No data found for id: $id");
        return;
      }

      final String currentTriggers = data.first[columnName] as String? ?? "";
      final updatedTriggers =
          currentTriggers.isEmpty ? trigger : "$currentTriggers, $trigger";

      Map<String, Object?> updatedValues = {columnName: updatedTriggers};

      int count = await db.update(
        _swapTableName,
        updatedValues,
        where: "$_swapIdColumnName = ?",
        whereArgs: [id],
      );

      if (count == 0) {
        print("No habit found with id: $id");
      } else {
        print("Trigger added/updated for habit with id $id.");
      }
    } catch (e) {
      throw Exception("Error adding trigger for habit with id $id: $e");
    }
  }

// Add Action
  Future<void> addAction({
    required int id,
    required bool isGood,
    required String action,
  }) async {
    try {
      final db = await database;
      final columnName = isGood
          ? _swapHabitActionsColumnName
          : _swapAddictionActionsColumnName;

      final data = await db.query(
        _swapTableName,
        where: "$_swapIdColumnName = ?",
        whereArgs: [id],
      );

      if (data.isEmpty) {
        print("No data found for id: $id");
        return;
      }

      final String currentActions = data.first[columnName] as String? ?? "";
      final updatedActions =
          currentActions.isEmpty ? action : "$currentActions, $action";

      Map<String, Object?> updatedValues = {columnName: updatedActions};

      int count = await db.update(
        _swapTableName,
        updatedValues,
        where: "$_swapIdColumnName = ?",
        whereArgs: [id],
      );

      if (count == 0) {
        print("No habit found with id: $id");
      } else {
        print("Action added/updated for habit with id $id.");
      }
    } catch (e) {
      throw Exception("Error adding action for habit with id $id: $e");
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

  Future<void> addEvent({
    required String title,
    required DateTime dueDate,
    required String description,
    required String backgroundColor,
    required String fontColor,
    required String iconPath,
  }) async {
    try {
      final db = await database;

      await db.insert(
        'Events',
        {
          _eventTitleColumnName: title,
          _eventDueDateColumnName: dueDate.toIso8601String(),
          _eventDescriptionColumnName: description,
          _eventBackgroundColorColumnName: backgroundColor,
          _eventFontColorColumnName: fontColor,
          _eventIconColumnName: iconPath,
        },
      );

      print("Event added: $title, Date: $dueDate");
    } catch (e) {
      throw Exception("Error adding event: $e");
    }
  }

  Future<void> deleteEvent(int id) async {
    try {
      final db = await database;

      int deletedCount = await db.delete(
        'Events',
        where: '$_eventIdColumnName = ?',
        whereArgs: [id],
      );

      if (deletedCount == 0) {
        print("No event found with id: $id");
      } else {
        print("Event with id $id deleted successfully.");
      }
    } catch (e) {
      throw Exception("Error deleting event: $e");
    }
  }

  Future<List<Event>> getAllEvents({required bool isFuture}) async {
    try {
      final db = await database;

      // Get current date in ISO format without time (for more consistent comparisons)
      final now = DateTime.now().toIso8601String();

      final data = await db.query(
        'Events',
        orderBy: "$_eventDueDateColumnName ASC",
        where: isFuture
            ? "$_eventDueDateColumnName > ?"
            : "$_eventDueDateColumnName <= ?",
        whereArgs: [now],
      );

      List<Event> events = data.map((event) {
        return Event(
          id: event[_eventIdColumnName] as int,
          title: event[_eventTitleColumnName] as String,
          dueDate: DateTime.parse(event[_eventDueDateColumnName] as String),
          description: event[_eventDescriptionColumnName] as String,
          backgroundColor: event[_eventBackgroundColorColumnName] as String,
          fontColor: event[_eventFontColorColumnName] as String,
          iconPath: event[_eventIconColumnName] as String,
        );
      }).toList();

      print("Events retrieved (${events.length}): $events");
      return events;
    } catch (e) {
      throw Exception("Error retrieving events: $e");
    }
  }

  Future<Backlog> addBacklog({
    required String title,
    required String description,
    required String timeline,
  }) async {
    final db = await database;
    final id = await db.insert(
      _backlogTableName,
      {
        _backlogTitleColumnName: title,
        _backlogDescriptionColumnName: description,
        _backlogTimelineColumnName: timeline,
      },
    );
    return Backlog(
        id: id, title: title, description: description, timeScale: timeline);
  }

  Future<List<Backlog>> getAllBacklogs(String timeline) async {
    final db = await database;
    final rows = await db.query(
      _backlogTableName,
      orderBy: '$_backlogTimelineColumnName ASC',
      where: " $_backlogTimelineColumnName = ?",
      whereArgs: [timeline],
    );
    return rows.map((r) {
      return Backlog(
        id: r[_backlogIdColumnName] as int? ?? 0,
        title: r[_backlogTitleColumnName] as String,
        description: r[_backlogDescriptionColumnName] as String,
        timeScale: r[_backlogTimelineColumnName] as String,
      );
    }).toList();
  }

  Future<Backlog?> getBacklogById(int id) async {
    final db = await database;
    final rows = await db.query(
      _backlogTableName,
      where: '$_backlogIdColumnName = ?',
      whereArgs: [id],
    );
    if (rows.isEmpty) return null;
    final r = rows.first;
    return Backlog(
      id: r[_backlogIdColumnName] as int? ?? 0,
      title: r[_backlogTitleColumnName] as String,
      description: r[_backlogDescriptionColumnName] as String,
      timeScale: r[_backlogTimelineColumnName] as String,
    );
  }

  Future<bool> updateBacklog({
    required int id,
    required String title,
    required String description,
    required String timeline,
  }) async {
    final db = await database;
    final Map<String, Object?> values = {};

    if (title.trim().isNotEmpty) values[_backlogTitleColumnName] = title;
    if (description.trim().isNotEmpty)
      values[_backlogDescriptionColumnName] = description;
    if (timeline.trim().isNotEmpty)
      values[_backlogTimelineColumnName] = timeline;

    if (values.isEmpty) return false;

    final count = await db.update(
      _backlogTableName,
      values,
      where: '$_backlogIdColumnName = ?',
      whereArgs: [id],
    );
    return count > 0;
  }

  Future<bool> updateBacklogDesc({
    required int id,
    required String description,
  }) async {
    final db = await database;
    final Map<String, Object?> values = {};

    if (description.isNotEmpty) {
      values[_backlogDescriptionColumnName] = description;
    }

    if (values.isEmpty) return false;

    final count = await db.update(
      _backlogTableName,
      values,
      where: '$_backlogIdColumnName = ?',
      whereArgs: [id],
    );

    return count > 0;
  }

  Future<bool> deleteBacklog(int id) async {
    final db = await database;
    final count = await db.delete(
      _backlogTableName,
      where: '$_backlogIdColumnName = ?',
      whereArgs: [id],
    );
    return count > 0;
  }
}
