import 'package:flutter/material.dart';

const preto = Color(0xFF111111);
const cinza = Color(0xFF8A8A8A);
const cinzaClaro = Color(0xFFE6E6E6);
const fundo = Color(0xFFF7F7F7);

OutlineInputBorder _borda(Color cor, [double largura = 1]) {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(14),
    borderSide: BorderSide(color: cor, width: largura),
  );
}

final temaApp = ThemeData(
  useMaterial3: true,
  scaffoldBackgroundColor: fundo,
  colorScheme: const ColorScheme.light(
    primary: preto,
    onPrimary: Colors.white,
    secondary: preto,
    surface: Colors.white,
    onSurface: preto,
    error: Color(0xFFC62828),
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: fundo,
    foregroundColor: preto,
    elevation: 0,
    scrolledUnderElevation: 0,
    titleTextStyle: TextStyle(
      color: preto,
      fontSize: 22,
      fontWeight: FontWeight.w800,
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.white,
    prefixIconColor: cinza,
    border: _borda(cinzaClaro),
    enabledBorder: _borda(cinzaClaro),
    focusedBorder: _borda(preto, 2),
    errorBorder: _borda(const Color(0xFFC62828)),
    focusedErrorBorder: _borda(const Color(0xFFC62828), 2),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: preto,
      foregroundColor: Colors.white,
      minimumSize: const Size.fromHeight(54),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: preto,
      textStyle: const TextStyle(fontWeight: FontWeight.w600),
    ),
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: preto,
    foregroundColor: Colors.white,
  ),
  checkboxTheme: CheckboxThemeData(
    shape: const CircleBorder(),
    side: const BorderSide(color: preto, width: 2),
    fillColor: WidgetStateProperty.resolveWith(
      (estados) =>
          estados.contains(WidgetState.selected) ? preto : Colors.transparent,
    ),
  ),
  snackBarTheme: SnackBarThemeData(
    backgroundColor: preto,
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  ),
  dialogTheme: DialogThemeData(
    backgroundColor: Colors.white,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
  ),
);
