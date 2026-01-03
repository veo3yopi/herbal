import 'package:coffe/data/models/address_model.dart';
import 'package:coffe/data/models/product_model.dart';
import 'package:coffe/data/models/shipping_rate_model.dart';
import 'package:coffe/data/models/warehouse_model.dart';
import 'package:coffe/data/services/shipping_rate_service.dart';
import 'package:coffe/features/checkout/courier_select_page.dart';
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
  final ShippingRateService _rateService = ShippingRateService();
  List<ShippingRateModel> _rates = [];
  ShippingRateModel? _selectedRate;
  WarehouseModel? _warehouse;
  bool _isLoadingRates = false;
  String? _rateError;
  int? _lastRateAddressId;

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
    final token = context.watch<AuthProvider>().token;
    final addressProvider = context.watch<AddressProvider>();
    final cartProvider = context.watch<CartProvider>();
    final address = _selectPrimaryAddress(addressProvider.addresses);

    _maybeLoadRates(
      token: token,
      address: address,
      cartProvider: cartProvider,
    );

    final shippingCost = _selectedRate?.price ?? 0;
    final totalWithShipping = cartProvider.totalPrice + shippingCost;

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
            _sectionTitle('Gudang Pengirim'),
            _infoCard(
              theme: theme,
              child: Builder(
                builder: (_) {
                  if (cartProvider.items.isEmpty) {
                    return const Text('Keranjang masih kosong.');
                  }
                  if (address == null) {
                    return const Text('Tambahkan alamat utama terlebih dahulu.');
                  }
                  if (_isLoadingRates) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (_rateError != null) {
                    return Text(_rateError ?? 'Gagal memuat gudang');
                  }
                  if (_warehouse == null) {
                    return const Text('Gudang belum tersedia.');
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _warehouse!.name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 6),
                      Text(_warehouse!.address),
                      const SizedBox(height: 6),
                      Text(
                        'Jarak: ${_warehouse!.distanceKm.toStringAsFixed(2)} km',
                      ),
                    ],
                  );
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
                        final ProductModel product = item['product'];
                        final qty = item['qty'] as int;
                        final price = product.price.toInt();
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
            _sectionTitle('Pilih Kurir'),
            _infoCard(
              theme: theme,
              child: Builder(
                builder: (_) {
                  if (cartProvider.items.isEmpty) {
                    return const Text('Keranjang masih kosong.');
                  }
                  if (address == null) {
                    return const Text('Tambahkan alamat utama terlebih dahulu.');
                  }
                  if (_isLoadingRates) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (_rateError != null) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(_rateError ?? 'Gagal memuat ongkir'),
                        const SizedBox(height: 8),
                        TextButton(
                          onPressed: () => _loadRates(
                            token: token,
                            address: address,
                            cartProvider: cartProvider,
                            force: true,
                          ),
                          child: const Text('Ulangi'),
                        ),
                      ],
                    );
                  }
                  if (_rates.isEmpty) {
                    return const Text('Belum ada pilihan kurir.');
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(
                          _selectedRate == null
                              ? 'Pilih kurir'
                              : '${_selectedRate!.logisticName} - ${_selectedRate!.rateName}',
                        ),
                        subtitle: _selectedRate == null
                            ? null
                            : Text(
                                _formatDuration(
                                  _selectedRate!.minDuration,
                                  _selectedRate!.maxDuration,
                                  _selectedRate!.durationType,
                                ),
                              ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (_selectedRate != null)
                              Text(formatter.format(_selectedRate!.price)),
                            const SizedBox(width: 8),
                            const Icon(Icons.arrow_forward_ios, size: 16),
                          ],
                        ),
                        onTap: () async {
                          final selected = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => CourierSelectPage(
                                rates: _rates,
                                selectedRate: _selectedRate,
                              ),
                            ),
                          );
                          if (!mounted || selected == null) return;
                          setState(() => _selectedRate = selected);
                        },
                      ),
                      if (_selectedRate == null)
                        const Text('Belum ada kurir dipilih.'),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            _sectionTitle('Ringkasan'),
            _infoCard(
              theme: theme,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Subtotal'),
                      Text(formatter.format(cartProvider.totalPrice)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Ongkir'),
                      Text(formatter.format(shippingCost)),
                    ],
                  ),
                  const Divider(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        formatter.format(totalWithShipping),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: cartProvider.items.isEmpty
                    ? null
                    : () {
                        cartProvider.clearCart();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Checkout berhasil. Keranjang dikosongkan.',
                            ),
                          ),
                        );
                        Navigator.pop(context);
                      },
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

  void _maybeLoadRates({
    required String? token,
    required AddressModel? address,
    required CartProvider cartProvider,
  }) {
    if (token == null || token.isEmpty) return;
    if (address == null) return;
    if (cartProvider.items.isEmpty) return;
    if (_isLoadingRates) return;
    if (_lastRateAddressId == address.id && _rates.isNotEmpty) return;
    _loadRates(token: token, address: address, cartProvider: cartProvider);
  }

  Future<void> _loadRates({
    required String? token,
    required AddressModel address,
    required CartProvider cartProvider,
    bool force = false,
  }) async {
    if (token == null || token.isEmpty) return;
    if (_isLoadingRates) return;
    if (!force && _lastRateAddressId == address.id && _rates.isNotEmpty) return;
    setState(() {
      _isLoadingRates = true;
      _rateError = null;
    });
    try {
      final items = cartProvider.items.map((item) {
        final product = item['product'] as ProductModel;
        final qty = item['qty'] as int;
        return {'product_id': product.id, 'quantity': qty};
      }).toList();
      final response = await _rateService.fetchRates(
        token: token,
        addressId: address.id,
        items: items,
      );
      if (!mounted) return;
      setState(() {
        _rates = response.rates;
        _selectedRate = _selectCheapestRate(response.rates) ?? _selectedRate;
        _warehouse = response.warehouse;
        _lastRateAddressId = address.id;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _rateError = e.toString().replaceFirst('Exception: ', '');
        _rates = [];
        _selectedRate = null;
        _warehouse = null;
      });
    } finally {
      if (mounted) {
        setState(() => _isLoadingRates = false);
      }
    }
  }

  ShippingRateModel? _selectCheapestRate(List<ShippingRateModel> rates) {
    if (rates.isEmpty) return null;
    return rates.reduce(
      (current, next) => next.price < current.price ? next : current,
    );
  }

  String _formatDuration(int min, int max, String type) {
    final unit = type.toLowerCase() == 'hour' ? 'jam' : 'hari';
    if (min == 0 && max == 0) return 'Estimasi tidak tersedia';
    if (min == max) return 'Estimasi $min $unit';
    return 'Estimasi $min-$max $unit';
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
