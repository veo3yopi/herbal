import 'package:flutter/material.dart';

// ChangeNotifier adalah fitur bawaan Flutter untuk "mengabarkan" perubahan data
class CartProvider extends ChangeNotifier {
  // 1. Data rahasia (list keranjang)
  // kita buat private (_items) atar tidak bisa di acak-acak langsung dari luar
  final List<Map<String, dynamic>> _items = [];

  // Gatter: Agar halmaan lain bisa BACA data, tapi tidak bisa ubah paksa
  List<Map<String, dynamic>> get items => _items;

  // Gatter: Menghitung Total Halaman otomatis
  int get totalPrice {
    int total = 0;
    for (var item in _items) {
      // Rumus : harga x jumlah barang
      //  Kita pastikan tipe datanya int dulu

      int price = int.parse(
        item['price']
            .toString()
            .replaceAll('Rp ', '')
            .replaceAll('rb', '000')
            .replaceAll('.', ''),
      );
      total += price * (item['qty'] as int);
    }
    return total;
  }

  // 2. Aksi : tambah ke keranjang
  void addToCart(Map<String, String> product, String size) {
    // cek apakah produk dengan nama & ukurna ang sama sudah ada ?
    int index = _items.indexWhere(
      (item) => item['name'] == product['name'] && item['size'] == size,
    );
    if (index != -1) {
      // jika sudah ada, kita tambahkan jumlahnya (Qty+1)
      _items[index]['qty'] = (_items[index]['qty'] as int) + 1;
    } else {
      // jika belum ada, masukansebagai baran baru
      _items.add({
        'name': product['name'],
        'price': product['price'],
        'image': product['image'],
        'size': size,
        'qty': 1,
      });
    }

    //  Pengint; bunyikan "lonceng" agar semu halaman updat tampilannya
    notifyListeners();
  }

  // 3. Aksi hapus / kurang
  void removeItem(int index) {
    if (_items[index]['qty'] > 1) {
      _items[index]['qty'] = (_items[index]['qty'] as int) - 1;
    } else {
      _items.removeAt(index);
    }
    notifyListeners();
  }

  // 4. aksei bersihkan keranjang
  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}
