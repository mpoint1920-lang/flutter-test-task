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
