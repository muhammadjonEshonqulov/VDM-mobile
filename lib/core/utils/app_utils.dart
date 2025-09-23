import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AppUtils {
  static void showToast(String message, {ToastGravity gravity = ToastGravity.BOTTOM, Color? backgroundColor, Color? textColor}) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: gravity,
      timeInSecForIosWeb: 1,
      backgroundColor: backgroundColor ?? Colors.black54,
      textColor: textColor ?? Colors.white,
      fontSize: 16.0,
    );
  }

  static void showSuccessSnackBar(BuildContext context, String message) {
    showSnackBar(context, message, backgroundColor: Colors.green);
  }

  static void showErrorSnackBar(BuildContext context, String message) {
    showSnackBar(context, message, backgroundColor: Colors.red);
  }

  static void showWarningSnackBar(BuildContext context, String message) {
    showSnackBar(context, message, backgroundColor: Colors.orange);
  }

  static void showSnackBar(BuildContext context, String message, {Color? backgroundColor}) {
    final messenger = ScaffoldMessenger.of(context);
    messenger.clearSnackBars();

    messenger.showSnackBar(SnackBar(content: Text(message), backgroundColor: backgroundColor, duration: const Duration(seconds: 3)));
  }

  static void showSuccessToast(String message) {
    showToast(message, backgroundColor: Colors.green);
  }

  static void showErrorToast(String message) {
    showToast(message, backgroundColor: Colors.red);
  }

  static void showWarningToast(String message) {
    showToast(message, backgroundColor: Colors.orange);
  }
}

void kPrint(String message) {
  if (kDebugMode) {
    final timestamp = DateTime.now().toString().substring(11, 23);
    debugPrint('[$timestamp] $message');
  }
}
