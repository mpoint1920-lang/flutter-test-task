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

class GlobalSnackBar {
  final String message;

  const GlobalSnackBar({
    required this.message,
  });

  static show(
    BuildContext context,
    String message,
  ) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        elevation: 0.0,
        //behavior: SnackBarBehavior.floating,
        content: Text(message),
        duration: const Duration(seconds: 5000000),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16.0), topRight: Radius.circular(16.0)),
        ),
        //backgroundColor: Colors.redAccent,
        action: SnackBarAction(
          textColor: const Color(0xFFFAF2FB),
          label: 'OK',
          onPressed: () {},
        ),
      ),
    );
  }
}
