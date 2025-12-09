import 'package:coffe/features/auth/login_page.dart';
import 'package:coffe/features/home/home_page.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'features/cart/cart_provider.dart';
import 'theme/app_theme.dart';

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
      theme: AppTheme.light(),
      home: const HomePage(),
    );
  }
}
