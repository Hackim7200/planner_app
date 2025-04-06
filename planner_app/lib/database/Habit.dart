class Habit {
  int? id;
  String title;
  String type;
  double duration;
  String partOfDay;
  String description;
  List<String> whichDays;

  Habit({
    this.id,
    required this.title,
    required this.type,
    required this.duration,
    required this.partOfDay,
    required this.description,
    required this.whichDays,

  });
}