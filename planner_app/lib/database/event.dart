class Event {
  final int? id;
  final String title;
  final DateTime dueDate;
  final String description;
  final String backgroundColor, fontColor;
  final String iconPath;

  Event({
    this.id,
    required this.title,
    required this.dueDate,
    required this.description,
    required this.backgroundColor,
    required this.fontColor,
    required this.iconPath,
  });

  factory Event.fromMap(Map<String, dynamic> map) {
    return Event(
      id: map['id'] as int?,
      title: map['title'] as String,
      dueDate: DateTime.parse(map['event_due_date'] as String),
      description: map['description'] as String,
      backgroundColor: map['background_color'] as String,
      fontColor: map['font_color'] as String,
      iconPath: map['icon_path'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'title': title,
      'event_due_date': dueDate.toIso8601String(),
      'description': description,
      'background_color': backgroundColor,
      'font_color': fontColor,
      'icon_path': iconPath,
    };
  }

  @override
  String toString() {
    return 'Event(id: $id, title: $title, dueDate: $dueDate, description: $description, color: $backgroundColor, iconPath: $iconPath)';
  }
}
