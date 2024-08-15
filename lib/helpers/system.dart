import 'package:flutter/services.dart';

class System {
  static void copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
  }

  static Future<String> pasteFromClipboard() async {
    ClipboardData? data = await Clipboard.getData(Clipboard.kTextPlain);
    if (data != null) {
      return data.text!;
    }
    return '';
  }

  static Future<String> startClipboardMonitor() async {
    ClipboardData? data = await Clipboard.getData(Clipboard.kTextPlain);
    if (data != null) {
      return data.text!;
    }
    return '';
  }
}
