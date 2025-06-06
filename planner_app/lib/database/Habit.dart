// A simple Habit model for swap items; modify properties as needed.
class Habit {
  final int id;
  final String addictionTitle;
  final List<String> addictionEffects;
  final List<String> addictionTriggers;
  final List<String> addictionPleasures;

  final String habitTitle;
  final List<String> habitEffects;
  final List<String> habitTriggers;
  final List<String> habitPleasures;

  final String partOfDay, habitType;
  final int priority;

  Habit({
    required this.addictionTriggers,
    required this.addictionPleasures,
    required this.habitTriggers,
    required this.habitPleasures,
    required this.priority,
    required this.id,
    required this.addictionTitle,
    required this.addictionEffects,
    required this.habitTitle,
    required this.habitEffects,
    required this.partOfDay,
    required this.habitType,
  });

  @override
  String toString() {
    return 'Habit{id: $id, addictionTitle: $addictionTitle, addictionEffects: $addictionEffects, , habitTitle: $habitTitle, habitEffects: $habitEffects , partOfDay: $partOfDay}';
  }
}
