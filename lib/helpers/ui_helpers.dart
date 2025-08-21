import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppSnack {
  // -----------------------------
  // Show Error Snackbar
  // -----------------------------
  static void error(String message, {String title = 'Error'}) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.all(10),
      borderRadius: 8,
    );
  }

  // -----------------------------
  // Show Success Snackbar
  // -----------------------------
  static void success(String message,
      {String title = 'Success',
      SnackPosition snackPosition = SnackPosition.BOTTOM}) {
    Get.snackbar(
      title,
      message,
      snackPosition: snackPosition,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.all(10),
      borderRadius: 8,
    );
  }

  // -----------------------------
  // Show Info Snackbar
  // -----------------------------
  static void info(String message, {String title = 'Info'}) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.blue,
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.all(10),
      borderRadius: 8,
    );
  }
}

String getFriendlyDate(DateTime date) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final target = DateTime(date.year, date.month, date.day);

  final difference = target.difference(today).inDays;

  if (difference == 0) return 'Today';
  if (difference == -1) return 'Yesterday';
  if (difference == 1) return 'Tomorrow';
  return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
}

/// Shows a customizable SnackBar with an optional leading icon and an undo action.
///
/// - [context]: The BuildContext from which to find the ScaffoldMessenger.
/// - [message]: The primary text message to display.
/// - [undoAction]: The callback to be executed when the 'Undo' button is pressed.
/// - [actionIcon]: An optional icon to display at the beginning of the SnackBar.
/// - [onTap]: An optional callback to make the entire SnackBar tappable.
/// - [duration]: The duration for which the SnackBar is displayed. Defaults to 3 seconds.
void showUndoSnackBar({
  required BuildContext context,
  required String message,
  required VoidCallback undoAction,
  IconData? actionIcon,
  VoidCallback? onTap,
  Duration? duration,
}) {
  final scaffoldMessenger = ScaffoldMessenger.of(context);
  final theme = Theme.of(context);

  // Hide any currently displayed snackbar to avoid overlap.
  scaffoldMessenger.hideCurrentSnackBar();

  scaffoldMessenger.showSnackBar(
    SnackBar(
      content: InkWell(
        onTap: onTap,
        child: Row(
          children: [
            // Use the provided icon or a default one, using theme color
            Icon(actionIcon ?? Icons.info_outline,
                color: theme.colorScheme.onSurface),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: TextStyle(color: theme.colorScheme.onSurface),
              ),
            ),
          ],
        ),
      ),
      duration: duration ?? const Duration(seconds: 3),
      action: SnackBarAction(
        label: 'Undo',
        onPressed: undoAction,
        textColor: theme.colorScheme.primary,
      ),
      backgroundColor: theme.colorScheme.surface, // Theme-aware background
      behavior: SnackBarBehavior.floating, // Modern floating look
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
    ),
  );
}

// This is a different helper function for a simple, tappable snackbar
void showInfoSnackBar({
  required BuildContext context,
  required String message,
  VoidCallback? onTap,
}) {
  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: InkWell(
        onTap: onTap, // Make the whole snackbar tappable
        child: Row(
          children: [
            const Icon(Icons.check_circle_outline, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
      ),
      duration: const Duration(seconds: 2),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
    ),
  );
}

Future<String?> showAddCollectionDialog(BuildContext context) async {
  final TextEditingController textController = TextEditingController();
  final theme = Theme.of(context);

  return showDialog<String>(
    context: context,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            const Icon(Icons.folder_outlined).paddingOnly(right: 8),
            Text(
              "New Collection",
              style: theme.textTheme.titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: TextField(
          controller: textController,
          autofocus: true,
          decoration: InputDecoration(
            hintText: "Enter collection name",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
                  BorderSide(color: theme.colorScheme.primary, width: 2),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
        actionsPadding: const EdgeInsets.only(bottom: 16, right: 16),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, textController.text.trim()),
            style: FilledButton.styleFrom(
              backgroundColor: theme.colorScheme.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text("Add"),
          ),
        ],
      );
    },
  );
}

/// Shows a customizable confirmation dialog.
///
/// Returns `true` if the user confirms, `false` otherwise.
Future<bool> showConfirmationDialog({
  required BuildContext context,
  required String title,
  required String content,
  String confirmText = 'Confirm',
  String cancelText = 'Cancel',
}) async {
  final theme = Theme.of(context);

  final result = await showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          title,
          style:
              theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        content: Text(
          content,
          style: theme.textTheme.bodyLarge,
        ),
        actionsPadding: const EdgeInsets.only(bottom: 16, right: 16, left: 16),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(cancelText),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: FilledButton.styleFrom(
              backgroundColor: theme
                  .colorScheme.error, // Use error color for destructive actions
              foregroundColor: theme.colorScheme.onError,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(confirmText),
          ),
        ],
      );
    },
  );

  // If the dialog is dismissed by tapping outside, it returns null.
  return result ?? false;
}
