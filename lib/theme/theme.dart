import 'package:flutter/material.dart';

final ThemeData theme = ThemeData(
  useMaterial3: true,

  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.black,
    surfaceTintColor:  Colors.black,
    elevation: 0
  ),

  brightness: Brightness.dark,
  scaffoldBackgroundColor: Colors.black,
  colorScheme: const ColorScheme.dark(
    // background: Colors.black
    brightness: Brightness.dark,
    surfaceTint: Colors.black,

    primary: Colors.white,
    onPrimary: Colors.black
  ),
  elevatedButtonTheme: const ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: WidgetStatePropertyAll( Colors.black),
      foregroundColor: WidgetStatePropertyAll( Colors.black), 
    )
  ),
);
