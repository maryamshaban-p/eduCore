import 'package:flutter/material.dart';

class ScreenConfig {
  static BuildContext? _context;

  static void init(BuildContext context) {
    _context = context;
  }

  static BuildContext get context {
    if (_context == null) {
      throw Exception("ScreenConfig.init(context) was not called!");
    }
    return _context!;
  }
}
