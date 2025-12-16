import 'package:coffe/features/home/home_page.dart';
import 'package:coffe/features/home/providers/category_provider.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'features/cart/cart_provider.dart';

import 'core/theme_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CategoryProvider()),
        ChangeNotifierProvider(create: (context) => CartProvider()),
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Kita bungkus MaterialApp dengan Consumer agar dia bisa berubah warna
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Coffee Shop UI',

          // SETUP TEMA DI SINI
          themeMode: themeProvider.themeMode, // Ikuti status provider
          theme: ThemeProvider.lightTheme, // Kalau mode terang pakai ini
          darkTheme: ThemeProvider.darkTheme, // Kalau mode gelap pakai ini

          home: const HomePage(),
        );
      },
    );
  }
}
