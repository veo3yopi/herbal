import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../cart/cart_provider.dart';

class DetailPage extends StatefulWidget {
  // kita butuh data dari halaman  home
  final Map<String, dynamic> coffeData;

  const DetailPage({super.key, required this.coffeData});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  // Stat untuk pilhan ukuran gelas
  String selectedSize = 'M';

  @override
  Widget build(BuildContext context) {
    // ambil data dari widget
    var coffee = widget.coffeData;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Gambar header
          Stack(
            children: [
              // gambar besar
              Hero(
                tag: coffee['name']!,
                child: Image.network(
                  coffee['image']!,
                  height: 350,
                  width: double.infinity,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, StackTrace) =>
                      Container(height: 350, color: Colors.grey),
                ),
              ),
              // Tombol back & favorite (diatas gambar)
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Tombol Back Bulat
                      CircleAvatar(
                        backgroundColor: Colors.black.withAlpha(50),
                        child: IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      // bomol love bulat
                      CircleAvatar(
                        backgroundColor: Colors.black.withAlpha(50),
                        child: IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.favorite_border,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          //  bagian 2: Detail informasi
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(25),
              decoration: const BoxDecoration(
                color: Colors.white,
                // membuat efek melengkung ke atas menutupi sedikit gambar
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
              // Geser container katas sedikit (-30) agar menumpuk gambar
              transform: Matrix4.translationValues(0, -40, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Judul & harga
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                coffee['name']!,
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF4E342E),
                                ),
                              ),
                              Text(
                                coffee['type']!,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[500],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Text(
                        coffee['price'].toString(),
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFD17842),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),
                  const Text(
                    'Description',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Nikmati sensasi kopi pilihan terbaik yang diseduh dengan teknik khusus untuk menghasilkan rasa yang kaya dan aroma yang memikat.",
                    style: TextStyle(color: Colors.grey[600], height: 1.5),
                  ),
                  const SizedBox(height: 25),
                  const Text(
                    'Size',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),

                  // Pilihan ukuran ( S, M, L)
                  Row(
                    children: [
                      _buildSizeButton("S"),
                      _buildSizeButton("M"),
                      _buildSizeButton("L"),
                    ],
                  ),
                  const Spacer(),

                  // Tombol beli
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: () {
                        // 1 . panggil provider (Si Tukang catatnya)
                        // Listen: false artinya kita cuma mau suruh di acate,
                        // ktia tidak perlu dengar balasan rebuild halaman ini
                        var cart = Provider.of<CartProvider>(
                          context,
                          listen: false,
                        );

                        // 2. Suruh dia measukan barang ini
                        cart.addToCart(
                          {
                            'name': coffee['name']!,
                            'price': coffee['price']!,
                            'image': coffee['image']!,
                          },

                          selectedSize, // ukuran yang di plih user
                        );

                        //  3. Beri info ke user kalau sudah berhasil
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              "${coffee['name']} (Size $selectedSize) berhaisl ditambahkan!",
                            ),

                            backgroundColor: const Color(0xFFD17842),
                            duration: const Duration(seconds: 1),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFD17842),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text(
                        'Add to Cart',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // widget kecil ntuk membuat tombolukuran biar kodenya rapi
  Widget _buildSizeButton(String size) {
    bool isSelected = selectedSize == size;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedSize = size;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(right: 15),
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFD17842) : Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: isSelected ? Colors.transparent : Colors.grey.shade300,
          ),
        ),
        child: Center(
          child: Text(
            size,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isSelected ? Colors.white : Colors.grey[600],
            ),
          ),
        ),
      ),
    );
  }
}
