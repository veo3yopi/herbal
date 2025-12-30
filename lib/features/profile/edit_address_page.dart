import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

import '../../data/models/address_model.dart';
import 'providers/address_provider.dart';
import 'providers/city_provider.dart';
import 'providers/district_provider.dart';
import 'providers/province_provider.dart';
import 'providers/sub_district_provider.dart';

class EditAddressPage extends StatefulWidget {
  const EditAddressPage({super.key, required this.address});

  final AddressModel address;

  @override
  State<EditAddressPage> createState() => _EditAddressPageState();
}

class _EditAddressPageState extends State<EditAddressPage> {
  final _formKey = GlobalKey<FormState>();

  final _labelController = TextEditingController();
  final _recipientController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressLineController = TextEditingController();
  final _provinceIdController = TextEditingController();
  final _cityIdController = TextEditingController();
  final _districtIdController = TextEditingController();
  final _postalCodeController = TextEditingController();
  final _provinceNameController = TextEditingController();
  final _cityNameController = TextEditingController();
  final _districtNameController = TextEditingController();
  final _subDistrictIdController = TextEditingController();
  final _subDistrictNameController = TextEditingController();
  final _latitudeController = TextEditingController();
  final _longitudeController = TextEditingController();

  bool _isDefault = false;
  bool _isFetchingLocation = false;
  int? _selectedProvinceId;
  int? _selectedCityId;
  int? _selectedDistrictId;
  int? _selectedSubDistrictId;

  @override
  void initState() {
    super.initState();
    final address = widget.address;
    _labelController.text = address.label;
    _recipientController.text = address.recipientName;
    _phoneController.text = address.phoneNumber;
    _addressLineController.text = address.addressLine;
    _provinceIdController.text = address.provinceId.toString();
    _cityIdController.text = address.cityId.toString();
    _districtIdController.text = address.districtId.toString();
    _postalCodeController.text = address.postalCode;
    _provinceNameController.text = address.provinceName;
    _cityNameController.text = address.cityName;
    _districtNameController.text = address.districtName;
    _subDistrictIdController.text = address.subDistrictId;
    _subDistrictNameController.text = address.subDistrictName;
    _latitudeController.text = address.latitude;
    _longitudeController.text = address.longitude;
    _isDefault = address.isDefault;
    _selectedProvinceId = address.provinceId;
    _selectedCityId = address.cityId;
    _selectedDistrictId = address.districtId;
    _selectedSubDistrictId =
        int.tryParse(address.subDistrictId.isEmpty ? '0' : address.subDistrictId);
    if (_selectedSubDistrictId == 0) {
      _selectedSubDistrictId = null;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProvinceProvider>().fetchProvinces();
      if (_selectedProvinceId != null) {
        context.read<CityProvider>().fetchCities(
              provinceId: _selectedProvinceId!,
            );
      }
      if (_selectedCityId != null) {
        context.read<DistrictProvider>().fetchDistricts(
              cityId: _selectedCityId!,
            );
      }
      if (_selectedDistrictId != null) {
        context.read<SubDistrictProvider>().fetchSubDistricts(
              districtId: _selectedDistrictId!,
            );
      }
    });
  }

  @override
  void dispose() {
    _labelController.dispose();
    _recipientController.dispose();
    _phoneController.dispose();
    _addressLineController.dispose();
    _provinceIdController.dispose();
    _cityIdController.dispose();
    _districtIdController.dispose();
    _postalCodeController.dispose();
    _provinceNameController.dispose();
    _cityNameController.dispose();
    _districtNameController.dispose();
    _subDistrictIdController.dispose();
    _subDistrictNameController.dispose();
    _latitudeController.dispose();
    _longitudeController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final updated = AddressModel(
      id: widget.address.id,
      userId: widget.address.userId,
      label: _labelController.text.trim(),
      recipientName: _recipientController.text.trim(),
      phoneNumber: _phoneController.text.trim(),
      addressLine: _addressLineController.text.trim(),
      provinceId: int.parse(_provinceIdController.text.trim()),
      cityId: int.parse(_cityIdController.text.trim()),
      districtId: int.parse(_districtIdController.text.trim()),
      postalCode: _postalCodeController.text.trim(),
      provinceName: _provinceNameController.text.trim(),
      cityName: _cityNameController.text.trim(),
      districtName: _districtNameController.text.trim(),
      subDistrictId: _subDistrictIdController.text.trim(),
      subDistrictName: _subDistrictNameController.text.trim(),
      isDefault: _isDefault,
      latitude: _latitudeController.text.trim(),
      longitude: _longitudeController.text.trim(),
    );

    final provider = context.read<AddressProvider>();
    final error = await provider.updateAddress(
      addressId: widget.address.id,
      address: updated,
    );
    if (!mounted) return;
    if (error == null) {
      Navigator.pop(context);
    } else {
      _showMessage(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final provider = context.watch<AddressProvider>();
    final provinceProvider = context.watch<ProvinceProvider>();
    final cityProvider = context.watch<CityProvider>();
    final districtProvider = context.watch<DistrictProvider>();
    final subDistrictProvider = context.watch<SubDistrictProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Alamat'),
        foregroundColor: theme.colorScheme.onSurface,
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _field(_labelController, 'Label (Rumah/Kantor)'),
              _field(_recipientController, 'Nama Penerima'),
              _field(_phoneController, 'Nomor Telepon',
                  keyboardType: TextInputType.phone),
              _field(_addressLineController, 'Alamat Lengkap'),
              _provinceField(provinceProvider, theme),
              _cityField(cityProvider, theme),
              _districtField(districtProvider, theme),
              _subDistrictField(subDistrictProvider, theme),
              _field(_postalCodeController, 'Kode Pos'),
              _locationButton(theme),
              _field(_latitudeController, 'Latitude'),
              _field(_longitudeController, 'Longitude'),
              SwitchListTile(
                value: _isDefault,
                onChanged: (value) => setState(() => _isDefault = value),
                title: const Text('Jadikan alamat utama'),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: provider.isLoading ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: provider.isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'Simpan Perubahan',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _locationButton(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: SizedBox(
        width: double.infinity,
        height: 48,
        child: OutlinedButton.icon(
          onPressed: _isFetchingLocation ? null : _fetchLocation,
          icon: _isFetchingLocation
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.my_location),
          label: Text(
            _isFetchingLocation ? 'Mengambil lokasi...' : 'Gunakan Lokasi Saat Ini',
          ),
        ),
      ),
    );
  }

  Future<void> _fetchLocation() async {
    setState(() => _isFetchingLocation = true);
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _showMessage('Layanan lokasi belum aktif. Buka pengaturan.');
        await Geolocator.openLocationSettings();
        return;
      }

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied) {
        _showMessage('Izin lokasi ditolak.');
        return;
      }
      if (permission == LocationPermission.deniedForever) {
        _showMessage('Izin lokasi ditolak permanen. Buka pengaturan.');
        await Geolocator.openAppSettings();
        return;
      }

      Position? position;
      try {
        position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
          timeLimit: const Duration(seconds: 10),
        );
      } on TimeoutException {
        position = await Geolocator.getLastKnownPosition();
      }

      if (position == null) {
        _showMessage('Lokasi tidak tersedia. Coba lagi.');
        return;
      }
      _latitudeController.text = position.latitude.toString();
      _longitudeController.text = position.longitude.toString();
    } catch (e) {
      _showMessage('Gagal mengambil lokasi: ${e.toString()}');
    } finally {
      if (mounted) {
        setState(() => _isFetchingLocation = false);
      }
    }
  }

  void _showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Widget _provinceField(ProvinceProvider provinceProvider, ThemeData theme) {
    if (provinceProvider.isLoading) {
      return const Padding(
        padding: EdgeInsets.only(bottom: 14),
        child: LinearProgressIndicator(),
      );
    }
    if (provinceProvider.error != null) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 14),
        child: Row(
          children: [
            Expanded(
              child: Text(
                provinceProvider.error ?? 'Gagal memuat data provinsi',
                style: TextStyle(color: theme.colorScheme.error),
              ),
            ),
            TextButton(
              onPressed: () => provinceProvider.fetchProvinces(),
              child: const Text('Ulangi'),
            ),
          ],
        ),
      );
    }

    return _searchableField(
      label: 'Provinsi',
      controller: _provinceNameController,
      enabled: true,
      hint: 'Pilih provinsi',
      validator: (_) => _selectedProvinceId == null ? 'Pilih provinsi' : null,
      onTap: () async {
        final selected = await _openSearchSheet(
          title: 'Pilih Provinsi',
          items: provinceProvider.provinces,
          itemLabel: (item) => item.name,
        );
        if (selected == null) return;
        setState(() {
          _selectedProvinceId = selected.id;
          _provinceIdController.text = selected.id.toString();
          _provinceNameController.text = selected.name;
          _selectedCityId = null;
          _cityIdController.clear();
          _cityNameController.clear();
          _selectedDistrictId = null;
          _districtIdController.clear();
          _districtNameController.clear();
          _selectedSubDistrictId = null;
          _subDistrictIdController.clear();
          _subDistrictNameController.clear();
          _postalCodeController.clear();
        });
        context.read<CityProvider>().fetchCities(provinceId: selected.id);
        context.read<DistrictProvider>().clear();
        context.read<SubDistrictProvider>().clear();
      },
    );
  }

  Widget _cityField(CityProvider cityProvider, ThemeData theme) {
    if (_selectedProvinceId == null) {
      return _searchableField(
        label: 'Kota/Kabupaten',
        controller: _cityNameController,
        enabled: false,
        hint: 'Pilih provinsi terlebih dahulu',
      );
    }
    if (cityProvider.isLoading) {
      return const Padding(
        padding: EdgeInsets.only(bottom: 14),
        child: LinearProgressIndicator(),
      );
    }
    if (cityProvider.error != null) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 14),
        child: Row(
          children: [
            Expanded(
              child: Text(
                cityProvider.error ?? 'Gagal memuat data kota',
                style: TextStyle(color: theme.colorScheme.error),
              ),
            ),
            TextButton(
              onPressed: () => cityProvider.fetchCities(
                provinceId: _selectedProvinceId!,
              ),
              child: const Text('Ulangi'),
            ),
          ],
        ),
      );
    }

    if (cityProvider.cities.isEmpty) {
      return const Padding(
        padding: EdgeInsets.only(bottom: 14),
        child: Text('Belum ada data kota'),
      );
    }

    return _searchableField(
      label: 'Kota/Kabupaten',
      controller: _cityNameController,
      enabled: true,
      hint: 'Pilih kota/kabupaten',
      validator: (_) =>
          _selectedCityId == null ? 'Pilih kota/kabupaten' : null,
      onTap: () async {
        final selected = await _openSearchSheet(
          title: 'Pilih Kota/Kabupaten',
          items: cityProvider.cities,
          itemLabel: (item) => item.name,
        );
        if (selected == null) return;
        setState(() {
          _selectedCityId = selected.id;
          _cityIdController.text = selected.id.toString();
          _cityNameController.text = selected.name;
          _selectedDistrictId = null;
          _districtIdController.clear();
          _districtNameController.clear();
          _selectedSubDistrictId = null;
          _subDistrictIdController.clear();
          _subDistrictNameController.clear();
          _postalCodeController.clear();
        });
        context.read<DistrictProvider>().fetchDistricts(cityId: selected.id);
        context.read<SubDistrictProvider>().clear();
      },
    );
  }

  Widget _districtField(DistrictProvider districtProvider, ThemeData theme) {
    if (_selectedCityId == null) {
      return _searchableField(
        label: 'Kecamatan',
        controller: _districtNameController,
        enabled: false,
        hint: 'Pilih kota/kabupaten terlebih dahulu',
      );
    }
    if (districtProvider.isLoading) {
      return const Padding(
        padding: EdgeInsets.only(bottom: 14),
        child: LinearProgressIndicator(),
      );
    }
    if (districtProvider.error != null) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 14),
        child: Row(
          children: [
            Expanded(
              child: Text(
                districtProvider.error ?? 'Gagal memuat data kecamatan',
                style: TextStyle(color: theme.colorScheme.error),
              ),
            ),
            TextButton(
              onPressed: () => districtProvider.fetchDistricts(
                cityId: _selectedCityId!,
              ),
              child: const Text('Ulangi'),
            ),
          ],
        ),
      );
    }

    if (districtProvider.districts.isEmpty) {
      return const Padding(
        padding: EdgeInsets.only(bottom: 14),
        child: Text('Belum ada data kecamatan'),
      );
    }

    return _searchableField(
      label: 'Kecamatan',
      controller: _districtNameController,
      enabled: true,
      hint: 'Pilih kecamatan',
      validator: (_) =>
          _selectedDistrictId == null ? 'Pilih kecamatan' : null,
      onTap: () async {
        final selected = await _openSearchSheet(
          title: 'Pilih Kecamatan',
          items: districtProvider.districts,
          itemLabel: (item) => item.name,
        );
        if (selected == null) return;
        setState(() {
          _selectedDistrictId = selected.id;
          _districtIdController.text = selected.id.toString();
          _districtNameController.text = selected.name;
          _selectedSubDistrictId = null;
          _subDistrictIdController.clear();
          _subDistrictNameController.clear();
          _postalCodeController.clear();
        });
        context.read<SubDistrictProvider>().fetchSubDistricts(
          districtId: selected.id,
        );
      },
    );
  }

  Widget _subDistrictField(
    SubDistrictProvider subDistrictProvider,
    ThemeData theme,
  ) {
    if (_selectedDistrictId == null) {
      return _searchableField(
        label: 'Kelurahan',
        controller: _subDistrictNameController,
        enabled: false,
        hint: 'Pilih kecamatan terlebih dahulu',
      );
    }
    if (subDistrictProvider.isLoading) {
      return const Padding(
        padding: EdgeInsets.only(bottom: 14),
        child: LinearProgressIndicator(),
      );
    }
    if (subDistrictProvider.error != null) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 14),
        child: Row(
          children: [
            Expanded(
              child: Text(
                subDistrictProvider.error ?? 'Gagal memuat data kelurahan',
                style: TextStyle(color: theme.colorScheme.error),
              ),
            ),
            TextButton(
              onPressed: () => subDistrictProvider.fetchSubDistricts(
                districtId: _selectedDistrictId!,
              ),
              child: const Text('Ulangi'),
            ),
          ],
        ),
      );
    }

    if (subDistrictProvider.subDistricts.isEmpty) {
      return const Padding(
        padding: EdgeInsets.only(bottom: 14),
        child: Text('Belum ada data kelurahan'),
      );
    }

    return _searchableField(
      label: 'Kelurahan',
      controller: _subDistrictNameController,
      enabled: true,
      hint: 'Pilih kelurahan',
      validator: (_) =>
          _selectedSubDistrictId == null ? 'Pilih kelurahan' : null,
      onTap: () async {
        final selected = await _openSearchSheet(
          title: 'Pilih Kelurahan',
          items: subDistrictProvider.subDistricts,
          itemLabel: (item) => item.name,
        );
        if (selected == null) return;
        setState(() {
          _selectedSubDistrictId = selected.id;
          _subDistrictIdController.text = selected.id.toString();
          _subDistrictNameController.text = selected.name;
          _postalCodeController.text = selected.postalCode;
        });
      },
    );
  }

  Widget _searchableField({
    required String label,
    required TextEditingController controller,
    required bool enabled,
    required String hint,
    VoidCallback? onTap,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        controller: controller,
        readOnly: true,
        enabled: enabled,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          suffixIcon: const Icon(Icons.arrow_drop_down),
        ),
        onTap: enabled ? onTap : null,
        validator: validator,
      ),
    );
  }

  Future<T?> _openSearchSheet<T>({
    required String title,
    required List<T> items,
    required String Function(T) itemLabel,
  }) async {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        final searchController = TextEditingController();
        var filtered = items;
        return StatefulBuilder(
          builder: (context, setModalState) {
            void applyFilter(String query) {
              final q = query.trim().toLowerCase();
              setModalState(() {
                filtered = q.isEmpty
                    ? items
                    : items
                        .where(
                          (item) => itemLabel(item).toLowerCase().contains(q),
                        )
                        .toList();
              });
            }

            return Padding(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 16,
                bottom: MediaQuery.of(context).viewInsets.bottom + 16,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: searchController,
                    onChanged: applyFilter,
                    decoration: const InputDecoration(
                      hintText: 'Cari...',
                      prefixIcon: Icon(Icons.search),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Flexible(
                    child: filtered.isEmpty
                        ? const Text('Tidak ada hasil')
                        : ListView.separated(
                            shrinkWrap: true,
                            itemCount: filtered.length,
                            separatorBuilder: (_, __) =>
                                const Divider(height: 1),
                            itemBuilder: (context, index) {
                              final item = filtered[index];
                              return ListTile(
                                title: Text(itemLabel(item)),
                                onTap: () => Navigator.pop(context, item),
                              );
                            },
                          ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _field(
    TextEditingController controller,
    String label, {
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(labelText: label),
        validator: (value) =>
            value == null || value.isEmpty ? 'Wajib diisi' : null,
      ),
    );
  }
}
