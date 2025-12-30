import 'package:coffe/data/models/product_model.dart';
import 'package:coffe/features/cart/cart_provider.dart';
import 'package:coffe/features/checkout/checkout_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final onSurface = theme.colorScheme.onSurface;
    final muted = onSurface.withAlpha(60);
    final formatter = NumberFormat.currency(
      locale: 'id',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    // consumer : "Mata-mata" yang mengawasi CartProdvide
    return Consumer<CartProvider>(
      builder: (context, cartProvider, child) {
        // ambil data asli dari provider
        var cartItems = cartProvider.items;

        return Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          appBar: AppBar(
            title: Text(
              "Keranjang Saya",
              style: TextStyle(fontWeight: FontWeight.bold, color: onSurface),
            ),
            centerTitle: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
            // leading: IconButton(
            //   onPressed: () => Navigator.pop(context),
            //   icon: Icon(Icons.arrow_back_ios, color: onSurface, size: 20),
            // ),
            actions: [
              // Tombl sampa untuk hapus semua
              IconButton(
                onPressed: () => cartProvider.clearCart(),
                icon: Icon(
                  Icons.delete_outline,
                  color: theme.colorScheme.error,
                ),
              ),
            ],
          ),

          // Daftar item keranjang
          body: cartItems.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.shopping_cart_outlined,
                        size: 80,
                        color: Colors.grey[300],
                      ),
                      const SizedBox(height: 20),
                      Text("Keranjang Kosong", style: TextStyle(color: muted)),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: cartItems.length,
                  itemBuilder: (context, index) {
                    final item = cartItems[index];
                    final product = item['product'] as ProductModel;
                    final qty = item['qty'] as int;
                    final imageUrl = product.primaryImage ??
                        (product.image.isNotEmpty ? product.image.first : '');
                    final description = product.description
                        .replaceAll(RegExp(r'<[^>]*>'), '')
                        .trim();
                    return Container(
                      margin: const EdgeInsets.only(bottom: 20),
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: theme.cardColor,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withAlpha(26),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          // 1 gambar kecil
                          ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image.network(
                              imageUrl.isNotEmpty
                                  ? imageUrl
                                  : 'https://via.placeholder.com/150',
                              width: 70,
                              height: 70,
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(width: 15),

                          // 2. info produk
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product.name,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: onSurface,
                                  ),
                                ),
                                if (description.isNotEmpty)
                                  Text(
                                    description,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: muted,
                                      fontSize: 12,
                                    ),
                                  ),
                                const SizedBox(height: 5),
                                Text(
                                  formatter.format(product.price.toInt()),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: primary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // 3. Tombol quantity
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.surfaceContainerHighest,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              children: [
                                // TOMBOL KURAN
                                GestureDetector(
                                  onTap: () {
                                    // panggil fungsi provideer
                                    cartProvider.removeItem(index);
                                  },
                                  child: const Icon(
                                    Icons.remove,
                                    size: 18,
                                    color: Colors.black87,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                  ),
                                  child: Text(
                                    "$qty",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                // TOMBOL TAMBAH
                                GestureDetector(
                                  onTap: () {
                                    cartProvider.addToCart(product);
                                  },
                                  child: const Icon(
                                    Icons.add,
                                    size: 18,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),

          // Panel Total harga (otomatis hitung dari Provider)
          bottomNavigationBar: cartItems.isEmpty
              ? null // sembunyikan kalau koksong
              : Container(
                  padding: const EdgeInsets.all(25),
                  decoration: BoxDecoration(
                    color: theme.cardColor,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withAlpha(26),
                        blurRadius: 10,
                        offset: const Offset(0, -5),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Total Harga", style: TextStyle(color: muted)),
                          // Tolal harga realtime
                          Text(
                            formatter.format(cartProvider.totalPrice),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: primary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const CheckoutPage(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: const Text(
                            "Checkout Sekarang",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
        );
      },
    );
  }

  
}
