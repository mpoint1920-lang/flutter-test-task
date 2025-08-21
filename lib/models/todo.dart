class Todo {
  final int id;
  final String title;
  final bool completed;
  final DateTime? archivedDate;

  Todo({
    required this.id,
    required this.title,
    required this.completed,
    this.archivedDate,
  });

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json['id'] as int,
      title: json['title'] as String,
      completed: json['completed'] as bool,
      archivedDate: json['archivedDate'] != null
          ? DateTime.parse(json['archivedDate'] as String)
          : null,
    );
  }

  Todo copyWith({
    int? id,
    String? title,
    bool? completed,
    DateTime? archivedDate,
  }) {
    return Todo(
      id: id ?? this.id,
      title: title ?? this.title,
      completed: completed ?? this.completed,
      archivedDate: archivedDate ?? this.archivedDate,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'completed': completed,
      'archivedDate': archivedDate?.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'Todo(id: $id, title: $title, completed: $completed, archivedDate: $archivedDate)';
  }
}
