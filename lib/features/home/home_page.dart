import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../widget/coffe_card.dart';
import '../detail/detail_page.dart';
import '../cart/cart_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Map<String, dynamic>> coffeeList = [
    {
      'name': 'Sendifit',
      'type': 'Sendi',
      'price': 100000,
      'weight': "60 kapsul",
      'image':
          'https://images.unsplash.com/photo-1514432324607-a09d9b4aefdd?w=800&q=80',
    },
    {
      'name': 'Lambungku',
      'type': 'Lambung',
      'price': 200000,
      'weight': "60 kapsul",
      'image':
          'https://images.unsplash.com/photo-1514432324607-a09d9b4aefdd?w=800&q=80',
    },
    {
      'name': 'Latte Art',
      'type': 'Double Shot',
      'price': 300000,
      'weight': "60 kapsul",
      'image':
          'https://images.unsplash.com/photo-1514432324607-a09d9b4aefdd?w=800&q=80',
    },
    {
      'name': 'Cold Brew',
      'type': 'Low Acid',
      'price': 400000,
      'weight': "60 kapsul",
      'image':
          'https://images.unsplash.com/photo-1461023058943-07fcbe16d735?w=800&q=80',
    },
  ];

  // Data kita siapkan daftar kategori
  final List<String> categories = [
    "Capuccino",
    "Espersso",
    "Latte",
    "Flat White",
    "Cold Brew",
    "Cold Brew",

    "Cold Brew",

    "Cold Brew",
  ];

  // state menyimpan index kategori yang sedang dipilih
  //  0 artinya kategori pertama ("Cappuccino") otomatis terpilih

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // ukuran grid akan diatur lewat childAspectRatio saja agar responsif
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      // Safe area memasikan konten tidak tertutup poni HP
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsetsGeometry.all(25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Bagian 1: Header (saapaan dan avatar)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Selamat Pagi,",
                        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 5),
                      const Text(
                        'Yopi Hendrian',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),

                  // avaratar / foto profil
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(15),
                      image: const DecorationImage(
                        image: NetworkImage("https://i.pravatar.cc/150?img=11"),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),

              // Bagian 2: Search Bar
              // kita buat search bar manual agar desainnya custom
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withAlpha(26), // bayangan halus
                      spreadRadius: 1,
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: const TextField(
                  decoration: InputDecoration(
                    hintText: "Cari obat herbal...",
                    prefixIcon: Icon(
                  CupertinoIcons.search,
                      color: theme.colorScheme.primary,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(15),
                  ),
                ),
              ),
              const SizedBox(height: 25),
              // placeholder untuk konten selanjutnya
              SizedBox(
                height: 40,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      // Logika klik : ubah stat index terpilhi
                      onTap: () {
                        setState(() {
                          _selectedIndex = index;
                        });
                      },
                      child: Container(
                        margin: EdgeInsets.only(
                          left: index == 0
                              ? 25
                              : 10, // memberi jarak kiri untuk item pertama
                          right: index == categories.length - 1
                              ? 25
                              : 0, //  jarak kanan item terakhir
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                          // Logika warna
                          // jika index ini sama denga yang dipilih -> warna Orange
                          // jika tika ->warna putih
                          color: _selectedIndex == index
                              ? theme.colorScheme.primary
                              : Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          // tambahkan border tipis jika tidk dipilih
                          border: _selectedIndex == index
                              ? null
                              : Border.all(color: Colors.grey.shade300),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 1),
                  child: GridView.builder(
                    itemCount: coffeeList.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.6,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 16,
                    ),
                    itemBuilder: (context, index) {
                      final coffee = coffeeList[index];
                      return GestureDetector(
                        // Navigasik ke detail page
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  DetailPage(coffeData: coffee),
                            ),
                          );
                        },
                        child: CoffeCard(
                          name: coffeeList[index]['name'] as String,
                          type: coffeeList[index]['type'] as String,
                          price: coffeeList[index]['price'] as int,
                          weight: coffeeList[index]['weight'] as String,
                          imageUrl: coffeeList[index]['image'] as String,
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: theme.colorScheme.primary,
        child: const Icon(Icons.shopping_bag, color: Colors.white),
        onPressed: () {
          // pindah ke halmaan keranjang
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CartPage()),
          );
        },
      ),
    );
  }
}
