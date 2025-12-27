import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../core/theme_provider.dart';
import '../auth/auth_provider.dart';
import '../auth/login_page.dart';
import 'address_page.dart';
import 'edit_profile_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final auth = context.watch<AuthProvider>();
    final user = auth.user;
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          children: [
            const SizedBox(height: 50),

            // Foto profile
            Center(
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: const DecorationImage(
                    image: NetworkImage("https://i.pravatar.cc/300?img=11"),
                    fit: BoxFit.cover,
                  ),
                  border: Border.all(color: const Color(0xFFD17842), width: 3),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Nama user
            Text(
              user?['name'] ?? 'Pengguna',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            Text(
              user?['phone'] ?? '-',
              style: const TextStyle(fontSize: 14, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 50),
            // Menu mode gelap
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  // warna kotak menyesuakan tema
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(20),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: SwitchListTile(
                  title: const Text(
                    "Mode Gelap",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  secondary: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.grey.withAlpha(29),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.dark_mode,
                      color: const Color(0xFFD17842),
                    ),
                  ),
                  value: themeProvider.isDarkMode,

                  // activeColor: ,
                  onChanged: (value) {
                    themeProvider.toggleTheme(value);
                  },
                ),
              ),
            ),
            // MENU SETTING
            _buildMenuItem(
              context,
              Icons.person,
              "Edit Profil",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const EditProfilePage()),
                );
              },
            ),
            _buildMenuItem(
              context,
              Icons.location_on,
              "Alamat Saya",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AddressPage()),
                );
              },
            ),
            _buildMenuItem(context, Icons.history, "Riwayat Pesanan"),
            _buildMenuItem(context, Icons.settings, "Pengaturan"),

            // Tombol Logout
            Padding(
              padding: const EdgeInsets.all(25),
              child: SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    final error = await auth.logout();
                    if (!context.mounted) return;
                    if (error != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(error)),
                      );
                      return;
                    }
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginPage()),
                      (route) => false,
                    );
                  },
                  icon: const Icon(Icons.logout, color: Colors.red),
                  label: const Text(
                    "Logout Akun",
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: SizedBox(
                width: double.infinity,
                height: 55,
                child: OutlinedButton.icon(
                  onPressed: () => SystemNavigator.pop(),
                  icon: const Icon(Icons.exit_to_app),
                  label: const Text("Keluar Aplikasi"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context,
    IconData icon,
    String text, {
    VoidCallback? onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(color: Colors.black.withAlpha(20), blurRadius: 10),
          ],
        ),
        child: ListTile(
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey.withAlpha(26),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: const Color(0xFFD17842)),
          ),
          title: Text(
            text,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          trailing: const Icon(
            Icons.arrow_forward_ios,
            size: 16,
            color: Colors.grey,
          ),
          onTap: onTap,
        ),
      ),
    );

    // return ListTile(
    //   leading: Container(
    //     padding: const EdgeInsets.all(8),
    //     decoration: BoxDecoration(
    //       color: Colors.grey[100],
    //       borderRadius: BorderRadius.circular(10),
    //     ),
    //     child: Icon(icon, color: const Color(0xFFD17842)),
    //   ),
    //   title: Text(text, style: const TextStyle(fontWeight: FontWeight.bold)),
    //   trailing: const Icon(
    //     Icons.arrow_forward_ios,
    //     size: 16,
    //     color: Colors.grey,
    //   ),
    //   onTap: () {},
    // );
  }
}
