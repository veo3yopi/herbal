import 'package:coffe/features/cart/cart_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
    // consumer : "Mata-mata" yang mengawasi CartProdvide
    return Consumer<CartProvider>(
      builder: (context, cartProvider, child) {
        // ambil data asli dari provider
        var cartItems = cartProvider.items;

        return Scaffold(
          backgroundColor: const Color(0xFFF9F9F9),
          appBar: AppBar(
            title: const Text(
              "Keranjang Saya",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            centerTitle: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
                size: 20,
              ),
            ),
            actions: [
              // Tombl sampa untuk hapus semua
              IconButton(
                onPressed: () => cartProvider.clearCart(),
                icon: const Icon(Icons.delete_outline, color: Colors.red),
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
                      Text(
                        "Keranjang Kosong",
                        style: TextStyle(color: Colors.grey[500]),
                      ),
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
                        color: Colors.white,
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
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  "Size: ${item["size"]}",
                                  style: TextStyle(
                                    color: Colors.grey[500],
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  "Rp ${item["price"]}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFFD17842),
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
                              color: const Color(0xFFF5F5F5),
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
                                    color: Color(0xFF4E342E),
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
                                    color: Color(0xFF4E342E),
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
                    color: Colors.white,
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
                          const Text(
                            "Total Harga",
                            style: TextStyle(color: Colors.grey),
                          ),
                          // Tolal harga realtime
                          Text(
                            "Rp ${cartProvider.totalPrice}",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Color(0xFF4E342E),
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
                                      child: const Text(
                                        "Bayar",
                                        style: TextStyle(
                                          color: Color(0xFFD17842),
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
                            backgroundColor: const Color(0xFFD17842),
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
      builder: (context) => const Center(
        child: CircularProgressIndicator(color: Color(0xFFD17842)),
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
          return AlertDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.check_circle, color: Colors.green, size: 80),
                const SizedBox(height: 20),
                const Text(
                  "Pembayaran Berhasil!",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Kopimu sedang disiapka. Mohon tunggu sebentar ya",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
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
                      backgroundColor: const Color(0xFFD17842),
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
