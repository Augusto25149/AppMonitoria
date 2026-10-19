import 'package:flutter/material.dart';

class CoresAplicativo {
  static const azul = Color(0xFF1677FF);
  static const azulClaro = Color(0xFFEAF3FF);
  static const texto = Color(0xFF14232F);
  static const secundario = Color(0xFF647583);
  static const borda = Color(0xFFE0E7EF);
}

ThemeData criarTema() {
  return ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: CoresAplicativo.azul,
      surface: Colors.white,
    ),
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      foregroundColor: CoresAplicativo.texto,
      elevation: 0,
      scrolledUnderElevation: 0,
      toolbarHeight: 72,
      titleTextStyle: TextStyle(
        color: CoresAplicativo.texto,
        fontSize: 22,
        fontWeight: FontWeight.w600,
      ),
      shape: Border(bottom: BorderSide(color: CoresAplicativo.borda)),
    ),
  );
}
