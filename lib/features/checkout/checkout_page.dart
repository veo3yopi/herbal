import 'package:coffe/data/models/address_model.dart';
import 'package:coffe/data/models/product_model.dart';
import 'package:coffe/data/models/shipping_rate_model.dart';
import 'package:coffe/data/models/warehouse_model.dart';
import 'package:coffe/data/services/shipping_rate_service.dart';
import 'package:coffe/features/checkout/courier_select_page.dart';
import 'package:cool_alert/cool_alert.dart';
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
  bool _isLoadingDialogShown = false;
  bool _isLoadingDialogVisible = false;
  int _loadingDialogToken = 0;
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
    const background = Color(0xFFF1F7F3);
    const surface = Color(0xFFFFFFFF);
    const surfaceBorder = Color(0xFFDCE8DE);
    const primary = Color(0xFF2F6B4F);
    const primarySoft = Color(0xFFE4F0E7);
    const textPrimary = Color(0xFF1F3326);
    const textMuted = Color(0xFF5E7A66);
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
      backgroundColor: background,
      appBar: AppBar(
        title: const Text('Checkout'),
        foregroundColor: textPrimary,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionTitle(
              'Data Pembeli',
              titleColor: textPrimary,
              accentColor: primary,
            ),
            _infoCard(
              background: surface,
              borderColor: surfaceBorder,
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
                  Text(
                    user?['phone'] ?? '-',
                    style: const TextStyle(color: textMuted),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _sectionTitle(
              'Alamat Pengiriman',
              titleColor: textPrimary,
              accentColor: primary,
            ),
            _infoCard(
              background: surface,
              borderColor: surfaceBorder,
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
                  return _addressView(address, textMuted: textMuted);
                },
              ),
            ),
            const SizedBox(height: 16),
            _sectionTitle(
              'Gudang Pengirim',
              titleColor: textPrimary,
              accentColor: primary,
            ),
            _infoCard(
              background: surface,
              borderColor: surfaceBorder,
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
                      Text(
                        _warehouse!.address,
                        style: const TextStyle(color: textMuted),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Jarak: ${_warehouse!.distanceKm.toStringAsFixed(2)} km',
                        style: const TextStyle(color: textMuted),
                      ),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            _sectionTitle(
              'Produk',
              titleColor: textPrimary,
              accentColor: primary,
            ),
            _infoCard(
              background: surface,
              borderColor: surfaceBorder,
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
                              Text(
                                'x$qty',
                                style: const TextStyle(color: textMuted),
                              ),
                              const SizedBox(width: 12),
                              Text(formatter.format(price * qty)),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
            ),
            const SizedBox(height: 16),
            _sectionTitle(
              'Pilih Kurir',
              titleColor: textPrimary,
              accentColor: primary,
            ),
            _infoCard(
              background: surface,
              borderColor: surfaceBorder,
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
                      Container(
                        decoration: BoxDecoration(
                          color: primarySoft,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 6,
                          ),
                          title: Text(
                            _selectedRate == null
                                ? 'Pilih kurir'
                                : '${_selectedRate!.logisticName} - ${_selectedRate!.rateName}',
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          subtitle: _selectedRate == null
                              ? null
                              : Text(
                                  _formatDuration(
                                    _selectedRate!.minDuration,
                                    _selectedRate!.maxDuration,
                                    _selectedRate!.durationType,
                                  ),
                                  style: const TextStyle(color: textMuted),
                                ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (_selectedRate != null)
                                Text(
                                  formatter.format(_selectedRate!.price),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
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
                      ),
                      if (_selectedRate == null)
                        const Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: Text(
                            'Belum ada kurir dipilih.',
                            style: TextStyle(color: textMuted),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            _sectionTitle(
              'Ringkasan',
              titleColor: textPrimary,
              accentColor: primary,
            ),
            _infoCard(
              background: surface,
              borderColor: surfaceBorder,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Subtotal',
                        style: TextStyle(color: textMuted),
                      ),
                      Text(formatter.format(cartProvider.totalPrice)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Ongkir',
                        style: TextStyle(color: textMuted),
                      ),
                      Text(formatter.format(shippingCost)),
                    ],
                  ),
                  const Divider(height: 24, color: surfaceBorder),
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
                          color: primary,
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
                  backgroundColor: primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  elevation: 0,
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

  Widget _sectionTitle(
    String text, {
    required Color titleColor,
    required Color accentColor,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Container(
            width: 10,
            height: 10,
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              color: accentColor,
              shape: BoxShape.circle,
            ),
          ),
          Text(
            text,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: titleColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoCard({
    required Widget child,
    required Color background,
    required Color borderColor,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
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
    if (_lastRateAddressId == address.id) return;
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
    if (!force && _lastRateAddressId == address.id) return;
    setState(() {
      _isLoadingRates = true;
      _rateError = null;
      _lastRateAddressId = address.id;
    });
    _showLoadingDialog();
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
      _hideLoadingDialog();
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

  void _showLoadingDialog() {
    if (!mounted || _isLoadingDialogShown) return;
    _isLoadingDialogShown = true;
    final token = ++_loadingDialogToken;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_isLoadingDialogShown || _loadingDialogToken != token) {
        return;
      }
      if (!_isLoadingRates) {
        _isLoadingDialogShown = false;
        return;
      }
      _isLoadingDialogVisible = true;
      CoolAlert.show(
        context: context,
        type: CoolAlertType.loading,
        barrierDismissible: false,
        text: 'Mencari gudang terdekat untuk alamat pengiriman...',
      ).whenComplete(() {
        if (mounted) {
          _isLoadingDialogVisible = false;
        }
      });
    });
  }

  void _hideLoadingDialog() {
    if (!mounted) return;
    _isLoadingDialogShown = false;
    _loadingDialogToken++;
    if (!_isLoadingDialogVisible) return;
    _isLoadingDialogVisible = false;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final navigator = Navigator.of(context, rootNavigator: true);
      if (navigator.canPop()) {
        navigator.pop();
      }
    });
  }

  Widget _addressView(AddressModel address, {required Color textMuted}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          address.label,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 6),
        Text(address.recipientName, style: TextStyle(color: textMuted)),
        Text(address.phoneNumber, style: TextStyle(color: textMuted)),
        const SizedBox(height: 6),
        Text(address.addressLine, style: TextStyle(color: textMuted)),
        Text(
          '${address.districtName}, ${address.cityName}',
          style: TextStyle(color: textMuted),
        ),
        Text(
          '${address.provinceName} ${address.postalCode}',
          style: TextStyle(color: textMuted),
        ),
      ],
    );
  }

  
}
