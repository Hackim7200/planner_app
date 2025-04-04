class Task {
  int id;
  String title;
  String type;
  double duration;
  bool completed;
  String partOfDay;
  DateTime createdAt;
  String description;

  Task({
    required this.id,
    required this.title,
    required this.type,
    required this.duration,
    required this.completed,
    required this.partOfDay,
    required this.createdAt,
    required this.description,
  });
}
