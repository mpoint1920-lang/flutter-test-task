import 'package:todo_test_task/common/enums.dart';

class Todo {
  final int id;
  final String title;
  final bool completed;
  final DateTime? archivedDate;
  final String? collectionName;
  final DateTime? deadline;
  final TodoPriority priority;

  Todo({
    required this.id,
    required this.title,
    required this.completed,
    this.archivedDate,
    this.collectionName,
    this.deadline,
    this.priority = TodoPriority.low,
  });

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json['id'] as int,
      title: json['title'] as String,
      completed: json['completed'] as bool,
      archivedDate: json['archivedDate'] != null
          ? DateTime.parse(json['archivedDate'] as String)
          : null,
      collectionName: json['collectionName'] as String?,
      deadline: json['deadline'] != null
          ? DateTime.parse(json['deadline'] as String)
          : null,
      priority: TodoPriority.values.firstWhere(
        (p) => p.name == json['priority'],
        orElse: () => TodoPriority.low,
      ),
    );
  }

  Todo copyWith({
    int? id,
    String? title,
    bool? completed,
    DateTime? archivedDate,
    String? collectionName,
    DateTime? deadline,
    TodoPriority? priority,
  }) {
    return Todo(
      id: id ?? this.id,
      title: title ?? this.title,
      completed: completed ?? this.completed,
      archivedDate: archivedDate ?? this.archivedDate,
      collectionName: collectionName ?? this.collectionName,
      deadline: deadline ?? this.deadline,
      priority: priority ?? this.priority,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'completed': completed,
      'archivedDate': archivedDate?.toIso8601String(),
      'collectionName': collectionName,
      'deadline': deadline?.toIso8601String(),
      'priority': priority.name,
    };
  }

  @override
  String toString() {
    return 'Todo(id: $id, title: $title, completed: $completed, archivedDate: $archivedDate, collectionName: $collectionName, deadline: $deadline, priority: $priority)';
  }
}
