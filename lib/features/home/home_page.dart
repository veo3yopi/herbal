import 'package:coffe/features/home/providers/category_provider.dart';
import 'package:coffe/features/home/providers/product_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import '../../widget/product_card.dart';
import '../detail/detail_page.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CategoryProvider>().fetchCategories();
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductProvider>().fetchProducts();
    });
  }

  // @override
  // void initState() {
  //   super.initState();
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     context.read<ProductProvider>().fetchProducts();
  //   });
  // }

  // final List<Map<String, dynamic>> coffeeList = [
  //   {
  //     'name': 'Sendifit',
  //     'type': 'Sendi',
  //     'price': 100000,
  //     'weight': "60 kapsul",
  //     'image':
  //         'https://down-id.img.susercontent.com/file/id-11134208-7ra0s-mdcokz4a1dbsaa',
  //   },
  //   {
  //     'name': 'Lambungku',
  //     'type': 'Lambung',
  //     'price': 200000,
  //     'weight': "60 kapsul",
  //     'image':
  //         'https://images.unsplash.com/photo-1514432324607-a09d9b4aefdd?w=800&q=80',
  //   },
  //   {
  //     'name': 'Latte Art',
  //     'type': 'Double Shot',
  //     'price': 300000,
  //     'weight': "60 kapsul",
  //     'image':
  //         'https://images.unsplash.com/photo-1514432324607-a09d9b4aefdd?w=800&q=80',
  //   },
  //   {
  //     'name': 'Cold Brew',
  //     'type': 'Low Acid',
  //     'price': 400000,
  //     'weight': "60 kapsul",
  //     'image':
  //         'https://images.unsplash.com/photo-1461023058943-07fcbe16d735?w=800&q=80',
  //   },
  // ];

  // Data kita siapkan daftar kategori
  // final List<String> categories = [
  //   "Capuccino",
  //   "Espersso",
  //   "Latte",
  //   "Flat White",
  //   "Cold Brew",
  //   "Cold Brew",

  //   "Cold Brew",

  //   "Cold Brew",
  // ];

  // state menyimpan index kategori yang sedang dipilih
  //  0 artinya kategori pertama ("Cappuccino") otomatis terpilih

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final categoryState = context.watch<CategoryProvider>();
    final categories = categoryState.categories;
    final theme = Theme.of(context);

    final productState = context.watch<ProductProvider>();
    final products = productState.products;

    // ukuran grid akan diatur lewat childAspectRatio saja agar responsif
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
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
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),

                  // avaratar / foto profil
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(35),
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
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withAlpha(30), // bayangan halus
                      spreadRadius: 1,
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Cari obat herbal...",
                    prefixIcon: Icon(
                      CupertinoIcons.search,
                      color: theme.colorScheme.primary,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.all(15),
                  ),
                ),
              ),
              const SizedBox(height: 25),
              // placeholder untuk konten selanjutnya
              SizedBox(
                height: 40,

                // category
                child: Builder(
                  builder: (_) {
                    if (categoryState.isLoading) {
                      return const Center(
                        child: CircularProgressIndicator(strokeWidth: 2),
                      );
                    }
                    if (categoryState.error != null) {
                      return Center(
                        child: TextButton(
                          onPressed: () {
                            categoryState.fetchCategories();
                          },
                          child: const Text('Ulangi'),
                        ),
                      );
                    }
                    if (categories.isEmpty) {
                      return const Center(child: Text('Belum ada kategory'));
                    }
                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        final category = categories[index];
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedIndex = index;
                            });
                          },
                          child: Container(
                            margin: EdgeInsets.only(
                              left: index == 0 ? 25 : 10,
                              right: index == categories.length - 1 ? 25 : 0,
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            decoration: BoxDecoration(
                              color: _selectedIndex == index
                                  ? theme.colorScheme.primary
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: _selectedIndex == index
                                  ? null
                                  : Border.all(color: Colors.grey.shade300),
                            ),
                            child: Center(
                              child: Text(
                                category.name,
                                style: TextStyle(
                                  color: _selectedIndex == index
                                      ? Colors.white
                                      : Colors.black87,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 10),

              Expanded(
                child: Builder(
                  builder: (_) {
                    if (productState.isLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (productState.error != null) {
                      return Center(
                        child: TextButton(
                          onPressed: () => productState.fetchProducts(),
                          child: Text('Gagal memuat. Coba lagi'),
                        ),
                      );
                    }
                    if (products.isEmpty) {
                      return const Center(child: Text('Belum ada produk'));
                    }
                    return GridView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      itemCount: products.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.6,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 16,
                          ),
                      itemBuilder: (context, index) {
                        final item = products[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => DetailPage(
                                  coffeData: {
                                    'name': item.name,
                                    'type': item.categories.isNotEmpty
                                        ? item.categories.first.name
                                        : '',
                                    'price': item.price,
                                    'weight': '${item.weight} gr',
                                    'image':
                                        item.primaryImage ??
                                        (item.image.isNotEmpty
                                            ? item.image.first
                                            : ''),
                                  },
                                ),
                              ),
                            );
                          },
                          child: ProductCard(
                            name: item.name,
                            type: item.categories.isNotEmpty
                                ? item.categories.first.name
                                : '',
                            price: item.price.toInt(),
                            weight: '${item.weight} gr',
                            imageUrl:
                                item.primaryImage ??
                                (item.image.isNotEmpty ? item.image.first : ''),
                            rating: 4.5,
                          ),
                        );
                      },
                    );
                  },
                ),
              ),

              const SizedBox(height: 5),
            ],
          ),
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   backgroundColor: theme.colorScheme.primary,
      //   child: const Icon(Icons.shopping_bag, color: Colors.white),
      //   onPressed: () {
      //     // pindah ke halmaan keranjang
      //     Navigator.push(
      //       context,
      //       MaterialPageRoute(builder: (context) => const CartPage()),
      //     );
      //   },
      // ),
    );
  }
}
