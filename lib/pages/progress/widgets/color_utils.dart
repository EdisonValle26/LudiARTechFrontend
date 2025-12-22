import 'package:flutter/material.dart';

class ColorUtils {
  static Color pastel(Color c) {
    return Color.lerp(c, Colors.white, 0.55)!;
  }

  static Color darkMetal(Color c, double intensity) {
    return Color.lerp(c, Colors.black, intensity)!;
  }
}
