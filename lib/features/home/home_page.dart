import 'package:coffe/features/home/providers/category_provider.dart';
import 'package:coffe/features/home/providers/product_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

import '../../data/models/product_model.dart';
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
    final productState = context.watch<ProductProvider>();
    final products = productState.products;
    const background = Color(0xFFF1F7F3);
    const surface = Color(0xFFFFFFFF);
    const surfaceTint = Color(0xFFE6F1EA);
    const primary = Color(0xFF2F6B4F);
    const textPrimary = Color(0xFF1F3326);
    const textMuted = Color(0xFF5E7A66);
    final formatter = NumberFormat.currency(
      locale: 'id',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    // ukuran grid akan diatur lewat childAspectRatio saja agar responsif
    return Scaffold(
      backgroundColor: background,
      // Safe area memasikan konten tidak tertutup poni HP
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Selamat Pagi,",
                              style: TextStyle(fontSize: 14, color: textMuted),
                            ),
                            const SizedBox(height: 6),
                            const Text(
                              'Yopi Hendrian',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: textPrimary,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            _iconChip(
                              icon: CupertinoIcons.heart,
                              background: surface,
                              iconColor: primary,
                            ),
                            const SizedBox(width: 10),
                            _iconChip(
                              icon: CupertinoIcons.bell,
                              background: surface,
                              iconColor: primary,
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    Container(
                      decoration: BoxDecoration(
                        color: surface,
                        borderRadius: BorderRadius.circular(28),
                        border: Border.all(color: surfaceTint),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.04),
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: "Search Categories",
                          hintStyle: const TextStyle(color: textMuted),
                          prefixIcon: const Icon(
                            CupertinoIcons.search,
                            color: textMuted,
                          ),
                          filled: true,
                          fillColor: surface,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(28),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(18),
                      child: Stack(
                        children: [
                          Container(
                            height: 140,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.black,
                              image: const DecorationImage(
                                image: NetworkImage(
                                  'https://images.unsplash.com/photo-1466692476868-aef1dfb1e735?w=1200&q=80',
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Container(
                            height: 140,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.black.withValues(alpha: 0.7),
                                  Colors.black.withValues(alpha: 0.2),
                                ],
                                begin: Alignment.bottomLeft,
                                end: Alignment.topRight,
                              ),
                            ),
                          ),
                          Positioned(
                            left: 16,
                            top: 20,
                            right: 16,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'EASY PLANTING BE HAPPY',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Temukan tanaman terbaik untuk suasana rumah yang hangat.',
                                  style: TextStyle(
                                    color: Colors.white.withValues(alpha: 0.9),
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: const Text(
                                    '50% OFF',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: textPrimary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 38,
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
                            return const Center(
                              child: Text('Belum ada kategory'),
                            );
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
                                    left: index == 0 ? 4 : 10,
                                    right: index == categories.length - 1
                                        ? 4
                                        : 0,
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 18,
                                  ),
                                  decoration: BoxDecoration(
                                    color: _selectedIndex == index
                                        ? primary
                                        : surface,
                                    borderRadius: BorderRadius.circular(18),
                                    border: Border.all(
                                      color: _selectedIndex == index
                                          ? primary
                                          : surfaceTint,
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      category.name,
                                      style: TextStyle(
                                        color: _selectedIndex == index
                                            ? Colors.white
                                            : textPrimary,
                                        fontWeight: FontWeight.w600,
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
                    const SizedBox(height: 18),
                    _sectionHeader(
                      title: 'Most Popular',
                      actionText: 'See all',
                      onAction: () {},
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 120,
                      child: Builder(
                        builder: (_) {
                          if (productState.isLoading) {
                            return const Center(
                              child: CircularProgressIndicator(strokeWidth: 2),
                            );
                          }
                          if (productState.error != null) {
                            return Center(
                              child: TextButton(
                                onPressed: () => productState.fetchProducts(),
                                child: const Text('Gagal memuat. Coba lagi'),
                              ),
                            );
                          }
                          if (products.isEmpty) {
                            return const Center(
                              child: Text('Belum ada produk'),
                            );
                          }
                          final popularItems = products.take(4).toList();
                          return ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: popularItems.length,
                            separatorBuilder: (_, _) =>
                                const SizedBox(width: 12),
                            itemBuilder: (context, index) {
                              final item = popularItems[index];
                              return _miniProductCard(
                                item: item,
                                background: surface,
                                textPrimary: textPrimary,
                                textMuted: textMuted,
                                formatter: formatter,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => DetailPage(product: item),
                                    ),
                                  );
                                },
                              );
                            },
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 18),
                    _sectionHeader(
                      title: 'Special Offers',
                      actionText: 'See all',
                      onAction: () {},
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),
            if (productState.isLoading)
              const SliverFillRemaining(
                child: Center(child: CircularProgressIndicator()),
              )
            else if (productState.error != null)
              SliverFillRemaining(
                child: Center(
                  child: TextButton(
                    onPressed: () => productState.fetchProducts(),
                    child: const Text('Gagal memuat. Coba lagi'),
                  ),
                ),
              )
            else if (products.isEmpty)
              const SliverFillRemaining(
                child: Center(child: Text('Belum ada produk')),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.65,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 16,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    childCount: products.length,
                    (context, index) {
                      final item = products[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => DetailPage(product: item),
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
                  ),
                ),
              ),
          ],
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

  Widget _iconChip({
    required IconData icon,
    required Color background,
    required Color iconColor,
  }) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE6F1EA)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Icon(icon, color: iconColor, size: 20),
    );
  }

  Widget _sectionHeader({
    required String title,
    required String actionText,
    required VoidCallback onAction,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1F3326),
          ),
        ),
        TextButton(
          onPressed: onAction,
          child: Text(
            actionText,
            style: TextStyle(
              color: Color(0xFF3E8A63),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _miniProductCard({
    required ProductModel item,
    required Color background,
    required Color textPrimary,
    required Color textMuted,
    required NumberFormat formatter,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 260,
        height: 104,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE6F1EA)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: SizedBox(
                width: 76,
                height: 76,
                child: Image.network(
                  item.primaryImage ??
                      (item.image.isNotEmpty ? item.image.first : ''),
                  fit: BoxFit.cover,
                  errorBuilder: (context, _, _) => Container(
                    color: const Color(0xFFF1F7F3),
                    child: const Icon(
                      Icons.image_not_supported_outlined,
                      color: Color(0xFF5E7A66),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      item.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.categories.isNotEmpty
                          ? item.categories.first.name
                          : '',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: textMuted, fontSize: 12),
                    ),
                    Row(
                      children: [
                        Text(
                          formatter.format(item.price.toInt()),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1F3326),
                            fontSize: 13,
                          ),
                        ),
                        const Spacer(),
                        const Icon(
                          Icons.star,
                          size: 14,
                          color: Color(0xFFF1B332),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '4.6',
                          style: TextStyle(color: textMuted, fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
