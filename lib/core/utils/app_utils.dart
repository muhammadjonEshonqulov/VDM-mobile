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
    debugPrint(message);
  }
}
