import 'package:coffe/features/cart/cart_provider.dart';
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
    final muted = onSurface.withOpacity(0.65);
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
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(Icons.arrow_back_ios, color: onSurface, size: 20),
            ),
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
                              item['image'],
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
                                  item['name'],
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: onSurface,
                                  ),
                                ),
                                Text(
                                  "Size: ${item["size"]}",
                                  style: TextStyle(color: muted, fontSize: 12),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  formatter.format(item["price"] as int),
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
                              color: theme.colorScheme.surfaceVariant,
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
                                    "${item['qty']}",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                // TOMBOL TAMBAH
                                GestureDetector(
                                  onTap: () {
                                    // panggil fungsi profivder add to cart
                                    cartProvider.addToCart({
                                      'name': item['name'],
                                      'price': item['price'],
                                      'image': item['image'],
                                    }, item['size']);
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
                            // tampilkan dialog konfirmasi
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text("Konfirmasi"),
                                  content: const Text(
                                    "Apakah kamu yakin ingin membayar pesanan ini?",
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text(
                                        "Batal",
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        _processPayment(cartProvider);
                                      },
                                      child: Text(
                                        "Bayar",
                                        style: TextStyle(
                                          color: primary,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
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

  void _processPayment(CartProvider cartProvider) async {
    // 1. tampilkan loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child: CircularProgressIndicator(
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );

    // 2. Jaeda waktu 2 detik
    await Future.delayed(const Duration(seconds: 2));

    // 3. Tutup loading
    if (mounted) {
      Navigator.of(context).pop();
    }

    // 4. tampilan Dialog Sukses
    if (mounted) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          final theme = Theme.of(context);
          final primary = theme.colorScheme.primary;
          final onSurface = theme.colorScheme.onSurface;
          final muted = onSurface.withOpacity(0.65);
          return AlertDialog(
            backgroundColor: theme.cardColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.check_circle, color: Colors.green, size: 80),
                const SizedBox(height: 20),
                Text(
                  "Pembayaran Berhasil!",
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: onSurface,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "Kopimu sedang disiapka. Mohon tunggu sebentar ya",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: muted),
                ),
                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // 5. Berishan keranjang
                      cartProvider.clearCart();

                      // 6. kembali ke menu utama
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: const Text(
                      "Kembali Belanja",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );
    }
  }
}
