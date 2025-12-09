import 'package:coffe/features/auth/login_page.dart';
import 'package:coffe/features/home/home_page.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'features/cart/cart_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (context) => CartProvider())],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Coffe Shop UI',
      theme: ThemeData(
        // mengatur defaul color & font
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF4E342E)),
        useMaterial3: true,
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      home: const HomePage(),
    );
  }
}
