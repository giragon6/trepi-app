import 'package:flutter/material.dart';
import 'package:trepi_app/core/styles/trepi_color.dart';

ThemeData trepiTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: TrepiColor.orange,
    primary: TrepiColor.orange,
    secondary: TrepiColor.brown,
    tertiary: TrepiColor.green,
    surface: TrepiColor.white,
    onPrimary: TrepiColor.black,
    onSecondary: TrepiColor.black,
    onTertiary: TrepiColor.black,
    onSurface: TrepiColor.black,
  ),
  textTheme: TextTheme(
    bodyLarge: TextStyle(color: TrepiColor.black, fontSize: 16.0),
    bodyMedium: TextStyle(color: TrepiColor.black, fontSize: 14.0),
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: TrepiColor.orange,
    foregroundColor: TrepiColor.white,
  ),
);