import 'package:flutter/material.dart';
import 'package:bot_toast/bot_toast.dart';
class Tools {
  static Color hetToColor(String code) {
    return Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  }

  static List<Color> multiColors = [
    Colors.red,
    Colors.amber,
    Colors.blue,
    Colors.green
  ];


  static String getUsername(String email) {
    return email.split('@')[0];
  }

  static showDebugPrint(String message) {
    debugPrint("Console : $message");
  }
  static showToasts(String message) {
    BotToast.showText(
        text: message,
        duration: const Duration(seconds: 2),
        contentColor: Colors.black,
        contentPadding:
        const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        textStyle: const TextStyle(fontSize: 20, color: Colors.white, letterSpacing: 1.2));
  }

}
