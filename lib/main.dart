import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'features/auth/auth_provider.dart';
import 'features/auth/login_page.dart';
import 'features/home/providers/category_provider.dart';
import 'features/home/providers/product_provider.dart';
import 'features/cart/cart_provider.dart';
import 'features/profile/providers/address_provider.dart';
import 'features/profile/providers/city_provider.dart';
import 'features/profile/providers/district_provider.dart';
import 'features/profile/providers/province_provider.dart';
import 'features/profile/providers/sub_district_provider.dart';
import 'main_page.dart';
import 'core/theme_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final themeProvider = ThemeProvider();
  final authProvider = AuthProvider();
  await themeProvider.loadTheme();
  await authProvider.loadSession();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: authProvider),
        ChangeNotifierProvider(create: (_) => CategoryProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProxyProvider<AuthProvider, ProvinceProvider>(
          create: (_) => ProvinceProvider(),
          update: (_, auth, provinceProvider) {
            provinceProvider?.setToken(auth.token);
            return provinceProvider ?? ProvinceProvider();
          },
        ),
        ChangeNotifierProxyProvider<AuthProvider, CityProvider>(
          create: (_) => CityProvider(),
          update: (_, auth, cityProvider) {
            cityProvider?.setToken(auth.token);
            return cityProvider ?? CityProvider();
          },
        ),
        ChangeNotifierProxyProvider<AuthProvider, DistrictProvider>(
          create: (_) => DistrictProvider(),
          update: (_, auth, districtProvider) {
            districtProvider?.setToken(auth.token);
            return districtProvider ?? DistrictProvider();
          },
        ),
        ChangeNotifierProxyProvider<AuthProvider, SubDistrictProvider>(
          create: (_) => SubDistrictProvider(),
          update: (_, auth, subDistrictProvider) {
            subDistrictProvider?.setToken(auth.token);
            return subDistrictProvider ?? SubDistrictProvider();
          },
        ),
        ChangeNotifierProxyProvider<AuthProvider, AddressProvider>(
          create: (_) => AddressProvider(),
          update: (_, auth, addressProvider) {
            addressProvider?.setToken(auth.token);
            return addressProvider ?? AddressProvider();
          },
        ),
        ChangeNotifierProvider.value(value: themeProvider),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<ThemeProvider, AuthProvider>(
      builder: (context, themeProvider, authProvider, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Coffee Shop UI',
          themeMode: themeProvider.themeMode,
          theme: ThemeProvider.lightTheme,
          darkTheme: ThemeProvider.darkTheme,
          home: authProvider.isLoggedIn ? const MainPage() : const LoginPage(),
        );
      },
    );
  }
}
