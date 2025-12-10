import 'package:coffe/features/detail/detail_page.dart';
import 'package:coffe/widget/product_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final List<Map<String, dynamic>> products = [
    {
      'name': 'Sendifit',
      'type': 'Sendi',
      'price': 100000,
      'weight': "60 kapsul",
      'image':
          'https://down-id.img.susercontent.com/file/id-11134208-7ra0s-mdcokz4a1dbsaa',
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
  String query = '';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final filtered = products.where((p) {
      final q = query.toLowerCase();
      return p['name'].toLowerCase().contains(q) ||
          p['type'].toLowerCase().contains(q);
    }).toList();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Produk'),
        backgroundColor: Colors.transparent,
        foregroundColor: theme.colorScheme.onSurface,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(20),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: TextField(
                onChanged: (v) => setState(() => query = v),
                decoration: InputDecoration(
                  hintText: "Cari produk...",
                  prefixIcon: Icon(
                    CupertinoIcons.search,
                    color: theme.colorScheme.primary,
                  ),
                  filled: true,
                  fillColor: theme.cardColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.all(15),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.builder(
                padding: EdgeInsets.symmetric(horizontal: 12),
                itemCount: filtered.length,

                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.6,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 16,
                ),
                itemBuilder: (context, index) {
                  final item = filtered[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => DetailPage(coffeData: item),
                        ),
                      );
                    },
                    child: ProductCard(
                      name: item['name'],
                      type: item['type'],
                      price: item['price'],
                      weight: item['weight'],
                      imageUrl: item['image'],
                      rating: item['rating'] ?? 4.5,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
