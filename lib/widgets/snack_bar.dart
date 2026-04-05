import 'package:flutter/material.dart';

class AppSnackBar {
  AppSnackBar._();

  /// Show success message
  static void showSuccess(
      BuildContext context, {
        required String message,
        Duration duration = const Duration(seconds: 3),
      }) {
    _show(context, message, Colors.green, duration);
  }

  /// Show error message
  static void showError(
      BuildContext context, {
        required String message,
        Duration duration = const Duration(seconds: 3),
      }) {
    _show(context, message, Colors.red, duration);
  }

  /// Show warning message
  static void showWarning(
      BuildContext context, {
        required String message,
        Duration duration = const Duration(seconds: 3),
      }) {
    _show(context, message, Colors.orange, duration);
  }

  /// Show info message
  static void showInfo(
      BuildContext context, {
        required String message,
        Duration duration = const Duration(seconds: 3),
      }) {
    _show(context, message, Colors.blue, duration);
  }

  static void _show(
      BuildContext context,
      String message,
      Color backgroundColor,
      Duration duration,
      ) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
        duration: duration,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
      ),
    );
  }
}