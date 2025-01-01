class Task {
  final String title;
  final String description;
  final String hexColor;
  final DateTime dueDate;
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;

  Task({
    required this.title,
    required this.description,
    required this.hexColor,
    required this.dueDate,
    required this.id,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      title: json['title'],
      description: json['description'],
      hexColor: json['hexColor'],
      dueDate: DateTime.parse(json['dueDate']),
      id: json['_id'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'description': description,
      "hexColor": hexColor,
      'dueDate': dueDate.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  /// provided map.
  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['_id']?.toString() ?? "",
      title: map['title'] ?? "",
      description: map['description'] ?? "",
      hexColor: map['hexColor'] ?? "",
      dueDate:
          DateTime.parse(map['dueDate'] ?? DateTime.now().toIso8601String()),
      createdAt:
          DateTime.parse(map['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt:
          DateTime.parse(map['updatedAt'] ?? DateTime.now().toIso8601String()),
    );
  }
}
