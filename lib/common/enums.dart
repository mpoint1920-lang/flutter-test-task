import 'package:flutter/material.dart';

enum TodoType {
  inbox,
  archived;

  /// Returns a display name for the type
  String get name {
    switch (this) {
      case TodoType.inbox:
        return 'Inbox';
      case TodoType.archived:
        return 'Archived';
    }
  }

  /// Returns an icon associated with the type
  IconData get icon {
    switch (this) {
      case TodoType.inbox:
        return Icons.inbox;
      case TodoType.archived:
        return Icons.archive;
    }
  }
}

enum TodoPriority {
  low,
  medium,
  high,
  urgent,
}

extension TodoPriorityExtension on TodoPriority {
  String get label {
    switch (this) {
      case TodoPriority.low:
        return 'Low';
      case TodoPriority.medium:
        return 'Medium';
      case TodoPriority.high:
        return 'High';
      case TodoPriority.urgent:
        return 'Urgent';
    }
  }

  int get colorValue {
    switch (this) {
      case TodoPriority.low:
        return 0xFFEEEEEE; // white
      case TodoPriority.medium:
        return 0xFFFFF176; // yellow
      case TodoPriority.high:
        return 0xFFFFB74D; // orange
      case TodoPriority.urgent:
        return 0xFFE57373; // red
    }
  }
}
