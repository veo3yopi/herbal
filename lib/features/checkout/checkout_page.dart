import 'package:coffe/data/models/address_model.dart';
import 'package:coffe/data/models/product_model.dart';
import 'package:coffe/features/auth/auth_provider.dart';
import 'package:coffe/features/cart/cart_provider.dart';
import 'package:coffe/features/profile/providers/address_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final addressProvider = context.read<AddressProvider>();
      if (addressProvider.addresses.isEmpty && !addressProvider.isLoading) {
        addressProvider.fetchAddresses();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final formatter = NumberFormat.currency(
      locale: 'id',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    final user = context.watch<AuthProvider>().user;
    final addressProvider = context.watch<AddressProvider>();
    final cartProvider = context.watch<CartProvider>();
    final address = _selectPrimaryAddress(addressProvider.addresses);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
        foregroundColor: theme.colorScheme.onSurface,
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionTitle('Data Pembeli'),
            _infoCard(
              theme: theme,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user?['name'] ?? 'Pengguna',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(user?['phone'] ?? '-'),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _sectionTitle('Alamat Pengiriman'),
            _infoCard(
              theme: theme,
              child: Builder(
                builder: (_) {
                  if (addressProvider.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (addressProvider.error != null) {
                    return Text(addressProvider.error ?? 'Gagal memuat alamat');
                  }
                  if (address == null) {
                    return const Text('Belum ada alamat utama.');
                  }
                  return _addressView(address);
                },
              ),
            ),
            const SizedBox(height: 16),
            _sectionTitle('Produk'),
            _infoCard(
              theme: theme,
              child: cartProvider.items.isEmpty
                  ? const Text('Keranjang masih kosong.')
                  : Column(
                      children: cartProvider.items.map((item) {
                        final product = item['product'] as ProductModel;
                        final qty = item['qty'] as int;
                        final price = (product.price as num).toInt();
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  product.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Text('x$qty'),
                              const SizedBox(width: 12),
                              Text(formatter.format(price * qty)),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
            ),
            const SizedBox(height: 16),
            _sectionTitle('Ringkasan'),
            _infoCard(
              theme: theme,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Total'),
                  Text(
                    formatter.format(cartProvider.totalPrice),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: cartProvider.items.isEmpty ? null : () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                child: const Text(
                  'Buat Pesanan',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  AddressModel? _selectPrimaryAddress(List<AddressModel> addresses) {
    if (addresses.isEmpty) return null;
    return addresses.firstWhere(
      (item) => item.isDefault,
      orElse: () => addresses.first,
    );
  }

  Widget _sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
    );
  }

  Widget _infoCard({required Widget child, required ThemeData theme}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _addressView(AddressModel address) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          address.label,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 6),
        Text(address.recipientName),
        Text(address.phoneNumber),
        const SizedBox(height: 6),
        Text(address.addressLine),
        Text('${address.districtName}, ${address.cityName}'),
        Text('${address.provinceName} ${address.postalCode}'),
      ],
    );
  }
}
