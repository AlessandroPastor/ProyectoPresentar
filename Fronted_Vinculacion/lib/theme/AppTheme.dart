import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();
  static Color colorX = Color(0xff99ff05);
  static  List<Color> colorOptions = [
    Color(0xff99ff05),
    Color(0xff6750a4),
    Colors.blue,
    Colors.teal,
    Colors.green,
    Colors.yellow,
    Colors.orange,
    Colors.pink
  ];
  static   List<String> colorText = <String>[
    "M3 Baseline",
    "M3 BaselineD",
    "Verde",
    "Teal",
    "Morado",
    "Yellow",
    "Orange",
    "Pink",
  ];

  static List<Color> colorOptionsLD = <Color>[Colors.green, Colors.purple];
  static List<String> colorTextLD = <String>["Verde", "Morado"];

  static List<ColorScheme> colorOptionsShemeL = [
    lightColorSchemeBlue,
    lightColorSchemeGreen
  ];
  static List<ColorScheme> colorOptionsShemeD = [
    darkColorSchemeBlue,
    darkColorSchemeGreen
  ];


  static  bool useMaterial3 = false;
  static bool useLightMode = true;
  static  int colorSelected = 1;

  static  ThemeData themeData=ThemeData(
      colorSchemeSeed: AppTheme.colorOptions[AppTheme.colorSelected],
      useMaterial3: AppTheme.useMaterial3,
      brightness: AppTheme.useLightMode ? Brightness.light : Brightness.dark);

  static const Color grey = Color(0xFF3A5160);
  static const Color nearlyWhite = Color(0xFFFEFEFE);
  static Color colorMenu=Color(0xFF3A5160);

  static ThemeData themeDataLight=ThemeData(useMaterial3: useMaterial3,
      colorScheme: AppTheme.colorOptionsShemeL[AppTheme.colorSelected]);
  static ThemeData themeDataDark=ThemeData(useMaterial3: useMaterial3,
      colorScheme: AppTheme.colorOptionsShemeD[AppTheme.colorSelected]);

  static const lightColorSchemeGreen = ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFF146E00),
    onPrimary: Color(0xFFFFFFFF),
    primaryContainer: Color(0xFF9EF981),
    onPrimaryContainer: Color(0xFF022100),
    secondary: Color(0xFF54624D),
    onSecondary: Color(0xFFFFFFFF),
    secondaryContainer: Color(0xFFD7E8CC),
    onSecondaryContainer: Color(0xFF121F0E),
    tertiary: Color(0xFF386668),
    onTertiary: Color(0xFFFFFFFF),
    tertiaryContainer: Color(0xFFBCEBED),
    onTertiaryContainer: Color(0xFF002021),
    error: Color(0xFFBA1A1A),
    errorContainer: Color(0xFFFFDAD6),
    onError: Color(0xFFFFFFFF),
    onErrorContainer: Color(0xFF410002),
    background: Color(0xFFFDFDF6),
    onBackground: Color(0xFF1A1C18),
    surface: Color(0xFFFDFDF6),
    onSurface: Color(0xFF1A1C18),
    surfaceVariant: Color(0xFFDFE4D7),
    onSurfaceVariant: Color(0xFF43483F),
    outline: Color(0xFF73796E),
    onInverseSurface: Color(0xFFF1F1EA),
    inverseSurface: Color(0xFF2F312D),
    inversePrimary: Color(0xFF83DB68),
    shadow: Color(0xFF000000),
    surfaceTint: Color(0xFF146E00),
    outlineVariant: Color(0xFFC3C8BC),
    scrim: Color(0xFF000000),
  );

  static const darkColorSchemeGreen = ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xFF83DB68),
    onPrimary: Color(0xFF063900),
    primaryContainer: Color(0xFF0D5300),
    onPrimaryContainer: Color(0xFF9EF981),
    secondary: Color(0xFFBBCBB1),
    onSecondary: Color(0xFF273421),
    secondaryContainer: Color(0xFF3D4B36),
    onSecondaryContainer: Color(0xFFD7E8CC),
    tertiary: Color(0xFFA0CFD1),
    onTertiary: Color(0xFF003739),
    tertiaryContainer: Color(0xFF1E4E50),
    onTertiaryContainer: Color(0xFFBCEBED),
    error: Color(0xFFFFB4AB),
    errorContainer: Color(0xFF93000A),
    onError: Color(0xFF690005),
    onErrorContainer: Color(0xFFFFDAD6),
    background: Color(0xFF1A1C18),
    onBackground: Color(0xFFE2E3DC),
    surface: Color(0xFF1A1C18),
    onSurface: Color(0xFFE2E3DC),
    surfaceVariant: Color(0xFF43483F),
    onSurfaceVariant: Color(0xFFC3C8BC),
    outline: Color(0xFF8D9387),
    onInverseSurface: Color(0xFF1A1C18),
    inverseSurface: Color(0xFFE2E3DC),
    inversePrimary: Color(0xFF146E00),
    shadow: Color(0xFF000000),
    surfaceTint: Color(0xFF83DB68),
    outlineVariant: Color(0xFF43483F),
    scrim: Color(0xFF000000),
  );


  static const lightColorSchemeBlue = ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFF0062A1),
    onPrimary: Color(0xFFFFFFFF),
    primaryContainer: Color(0xFFD0E4FF),
    onPrimaryContainer: Color(0xFF001D35),
    secondary: Color(0xFF525F70),
    onSecondary: Color(0xFFFFFFFF),
    secondaryContainer: Color(0xFFD6E4F7),
    onSecondaryContainer: Color(0xFF0F1D2A),
    tertiary: Color(0xFF2E5DA8),
    onTertiary: Color(0xFFFFFFFF),
    tertiaryContainer: Color(0xFFD7E2FF),
    onTertiaryContainer: Color(0xFF001A40),
    error: Color(0xFFBA1A1A),
    errorContainer: Color(0xFFFFDAD6),
    onError: Color(0xFFFFFFFF),
    onErrorContainer: Color(0xFF410002),
    background: Color(0xFFFDFCFF),
    onBackground: Color(0xFF1A1C1E),
    surface: Color(0xFFFDFCFF),
    onSurface: Color(0xFF1A1C1E),
    surfaceVariant: Color(0xFFDFE3EB),
    onSurfaceVariant: Color(0xFF42474E),
    outline: Color(0xFF73777F),
    onInverseSurface: Color(0xFFF1F0F4),
    inverseSurface: Color(0xFF2F3033),
    inversePrimary: Color(0xFF9CCAFF),
    shadow: Color(0xFF000000),
    surfaceTint: Color(0xFF0062A1),
    outlineVariant: Color(0xFFC2C7CF),
    scrim: Color(0xFF000000),
  );

  static const darkColorSchemeBlue = ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xFF9CCAFF),
    onPrimary: Color(0xFF003256),
    primaryContainer: Color(0xFF00497B),
    onPrimaryContainer: Color(0xFFD0E4FF),
    secondary: Color(0xFFBAC8DB),
    onSecondary: Color(0xFF243140),
    secondaryContainer: Color(0xFF3B4857),
    onSecondaryContainer: Color(0xFFD6E4F7),
    tertiary: Color(0xFFACC7FF),
    onTertiary: Color(0xFF002F67),
    tertiaryContainer: Color(0xFF08458E),
    onTertiaryContainer: Color(0xFFD7E2FF),
    error: Color(0xFFFFB4AB),
    errorContainer: Color(0xFF93000A),
    onError: Color(0xFF690005),
    onErrorContainer: Color(0xFFFFDAD6),
    background: Color(0xFF1A1C1E),
    onBackground: Color(0xFFE2E2E6),
    surface: Color(0xFF1A1C1E),
    onSurface: Color(0xFFE2E2E6),
    surfaceVariant: Color(0xFF42474E),
    onSurfaceVariant: Color(0xFFC2C7CF),
    outline: Color(0xFF8C9199),
    onInverseSurface: Color(0xFF1A1C1E),
    inverseSurface: Color(0xFFE2E2E6),
    inversePrimary: Color(0xFF0062A1),
    shadow: Color(0xFF000000),
    surfaceTint: Color(0xFF9CCAFF),
    outlineVariant: Color(0xFF42474E),
    scrim: Color(0xFF000000),
  );
}