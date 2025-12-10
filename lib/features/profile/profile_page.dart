import 'package:flutter/material.dart';
import '../auth/login_page.dart';
import 'package:provider/provider.dart';
import '../../core/theme_provider.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    var themeProvider = Provider.of<ThemeProvider>(context);
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
            const Text(
              "Akhir Project",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const Text(
              "admin@mail.com",
              style: TextStyle(fontSize: 14, color: Colors.grey),
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
            _buildMenuItem(context, Icons.person, "Edit Profil"),
            _buildMenuItem(context, Icons.history, "Riwayat Pesanan"),
            _buildMenuItem(context, Icons.settings, "Pengaturan"),
            const Spacer(),

            // Tombol Logout
            Padding(
              padding: const EdgeInsets.all(25),
              child: SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Logika logout
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginPage(),
                      ),
                      (route) => false,
                    );
                  },
                  label: const Text(
                    "Keluar Aplikasi ",
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, IconData icon, String text) {
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
          onTap: () {},
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
