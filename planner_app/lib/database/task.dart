class Task {
  int id;
  String title;
  String type;
  double duration;
  bool completed;
  String partOfDay;
  DateTime dueDate;
  String description;

  Task({
    required this.id,
    required this.title,
    required this.type,
    required this.duration,
    required this.completed,
    required this.partOfDay,
    required this.dueDate,
    required this.description,
  });
}
