import 'package:coffe/features/product/product_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'features/home/home_page.dart';
import 'features/cart/cart_page.dart';
import 'features/profile/profile_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  // 1. STATE; Index halaman yang sedang aktif (0 = Home)
  int _currentIndex = 0;

  // 2. Daftar halaman
  final List<Widget> _pages = [
    const HomePage(),
    const ProductPage(),
    const CartPage(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 3. Body: menampilkan halaman sesuai index saat ini
      body: IndexedStack(index: _currentIndex, children: _pages),

      // 4. Button Navigasi bar
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withAlpha(40),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.white,
          selectedItemColor: const Color(0xFFD17842),
          unselectedItemColor: Colors.grey[400],
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
          currentIndex: _currentIndex,

          // fungsi saat tombol diklik
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_filled),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.cube_box),
              label: 'Produk',
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.cart_fill),
              label: 'Cart',
            ),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Akun'),
          ],
        ),
      ),
    );
  }
}
