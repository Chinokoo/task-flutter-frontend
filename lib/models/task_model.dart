class Task {
  final String title;
  final String description;
  final String hexColor;
  final DateTime dueDate;
  final String id;

  Task({
    required this.title,
    required this.description,
    required this.hexColor,
    required this.dueDate,
    required this.id,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      title: json['title'],
      description: json['description'],
      hexColor: json['hexColor'],
      dueDate: DateTime.parse(json['dueDate']),
      id: json['_id'],
    );
  }
}
