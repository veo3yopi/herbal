import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  static const _themeKey = 'is_dark_mode';
  // Default: Mode Terang (Light)
  ThemeMode _themeMode = ThemeMode.light;

  // Getter untuk tahu mode sekarang
  ThemeMode get themeMode => _themeMode;

  // Cek apakah sekarang sedang Dark Mode?
  bool get isDarkMode => _themeMode == ThemeMode.dark;

  Future<void> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool(ThemeProvider._themeKey) ?? false;
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  Future<void> toggleTheme(bool isOn) async {
    _themeMode = isOn ? ThemeMode.dark : ThemeMode.light;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_themeKey, isOn);
    notifyListeners();
  }
  // --- DEFINISI TEMA (Warna-warni) ---

  // 1. TEMA TERANG (Yang sekarang kita pakai)
  static final lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: const Color(0xFFF9F9F9),
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF4E342E),
      brightness: Brightness.light,
    ),
    textTheme: GoogleFonts.poppinsTextTheme(),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.black),
      titleTextStyle: TextStyle(
        color: Colors.black,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
  );

  // 2. TEMA GELAP (Versi Keren)
  static final darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color(0xFF121212), // Hitam pekat tapi lembut
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFFD17842), // Oranye Kopi
      brightness: Brightness.dark,
      surface: const Color(0xFF1E1E1E), // Warna untuk Card/Container
    ),
    textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}
