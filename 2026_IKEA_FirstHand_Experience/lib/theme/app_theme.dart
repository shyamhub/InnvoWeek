import 'package:flutter/material.dart';

abstract final class AppTheme {
  static const canvas = Color(0xFFF6F4EE);
  static const paper = Color(0xFFFFFEFA);
  static const ink = Color(0xFF22231F);
  static const mutedInk = Color(0xFF777970);
  static const blue = Color(0xFF07569F);

  static ThemeData get light {
    final scheme = ColorScheme.fromSeed(
      seedColor: blue,
      brightness: Brightness.light,
      surface: paper,
    );
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: canvas,
      colorScheme: scheme,
      fontFamily: 'Roboto',
      appBarTheme: const AppBarTheme(
        backgroundColor: canvas,
        foregroundColor: ink,
        elevation: 0,
        centerTitle: false,
        surfaceTintColor: Colors.transparent,
      ),
      sliderTheme: const SliderThemeData(
        activeTrackColor: blue,
        inactiveTrackColor: Color(0xFFE1E0D9),
        thumbColor: blue,
        overlayColor: Color(0x2207569F),
        trackHeight: 4,
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
          (states) =>
              states.contains(WidgetState.selected) ? Colors.white : null,
        ),
        trackColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected) ? blue : null,
        ),
      ),
    );
  }
}
