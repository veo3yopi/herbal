import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/models/address_model.dart';
import 'providers/address_provider.dart';
import 'providers/city_provider.dart';
import 'providers/district_provider.dart';
import 'providers/province_provider.dart';
import 'providers/sub_district_provider.dart';

class AddAddressPage extends StatefulWidget {
  const AddAddressPage({super.key});

  @override
  State<AddAddressPage> createState() => _AddAddressPageState();
}

class _AddAddressPageState extends State<AddAddressPage> {
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
  int? _selectedProvinceId;
  int? _selectedCityId;
  int? _selectedDistrictId;
  int? _selectedSubDistrictId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProvinceProvider>().fetchProvinces();
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

    final address = AddressModel(
      id: 0,
      userId: 0,
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
    final error = await provider.addAddress(address);
    if (!mounted) return;
    if (error == null) {
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error)),
      );
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
        title: const Text('Tambah Alamat'),
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
                          'Simpan Alamat',
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

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: DropdownButtonFormField<int>(
        initialValue: _selectedProvinceId,
        items: provinceProvider.provinces
            .map(
              (province) => DropdownMenuItem<int>(
                value: province.id,
                child: Text(province.name),
              ),
            )
            .toList(),
        decoration: const InputDecoration(labelText: 'Provinsi'),
        onChanged: (value) {
          setState(() {
            _selectedProvinceId = value;
            final selected = provinceProvider.provinces.firstWhere(
              (item) => item.id == value,
            );
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
          if (value != null) {
            context.read<CityProvider>().fetchCities(provinceId: value);
            context.read<DistrictProvider>().clear();
            context.read<SubDistrictProvider>().clear();
          } else {
            context.read<CityProvider>().clear();
            context.read<DistrictProvider>().clear();
            context.read<SubDistrictProvider>().clear();
          }
        },
        validator: (value) => value == null ? 'Pilih provinsi' : null,
      ),
    );
  }

  Widget _cityField(CityProvider cityProvider, ThemeData theme) {
    if (_selectedProvinceId == null) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 14),
        child: TextFormField(
          enabled: false,
          decoration: const InputDecoration(
            labelText: 'Kota/Kabupaten',
            hintText: 'Pilih provinsi terlebih dahulu',
            suffixIcon: Icon(Icons.arrow_drop_down),
          ),
        ),
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

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: DropdownButtonFormField<int>(
        initialValue: _selectedCityId,
        items: cityProvider.cities
            .map(
              (city) => DropdownMenuItem<int>(
                value: city.id,
                child: Text(city.name),
              ),
            )
            .toList(),
        decoration: const InputDecoration(labelText: 'Kota/Kabupaten'),
        onChanged: (value) {
          setState(() {
            _selectedCityId = value;
            final selected = cityProvider.cities.firstWhere(
              (item) => item.id == value,
            );
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
          if (value != null) {
            context.read<DistrictProvider>().fetchDistricts(cityId: value);
            context.read<SubDistrictProvider>().clear();
          } else {
            context.read<DistrictProvider>().clear();
            context.read<SubDistrictProvider>().clear();
          }
        },
        validator: (value) => value == null ? 'Pilih kota/kabupaten' : null,
      ),
    );
  }

  Widget _districtField(DistrictProvider districtProvider, ThemeData theme) {
    if (_selectedCityId == null) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 14),
        child: TextFormField(
          enabled: false,
          decoration: const InputDecoration(
            labelText: 'Kecamatan',
            hintText: 'Pilih kota/kabupaten terlebih dahulu',
            suffixIcon: Icon(Icons.arrow_drop_down),
          ),
        ),
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

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: DropdownButtonFormField<int>(
        initialValue: _selectedDistrictId,
        items: districtProvider.districts
            .map(
              (district) => DropdownMenuItem<int>(
                value: district.id,
                child: Text(district.name),
              ),
            )
            .toList(),
        decoration: const InputDecoration(labelText: 'Kecamatan'),
        onChanged: (value) {
          setState(() {
            _selectedDistrictId = value;
            final selected = districtProvider.districts.firstWhere(
              (item) => item.id == value,
            );
            _districtIdController.text = selected.id.toString();
            _districtNameController.text = selected.name;
            _selectedSubDistrictId = null;
            _subDistrictIdController.clear();
            _subDistrictNameController.clear();
            _postalCodeController.clear();
          });
          if (value != null) {
            context.read<SubDistrictProvider>().fetchSubDistricts(
              districtId: value,
            );
          } else {
            context.read<SubDistrictProvider>().clear();
          }
        },
        validator: (value) => value == null ? 'Pilih kecamatan' : null,
      ),
    );
  }

  Widget _subDistrictField(
    SubDistrictProvider subDistrictProvider,
    ThemeData theme,
  ) {
    if (_selectedDistrictId == null) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 14),
        child: TextFormField(
          enabled: false,
          decoration: const InputDecoration(
            labelText: 'Kelurahan',
            hintText: 'Pilih kecamatan terlebih dahulu',
            suffixIcon: Icon(Icons.arrow_drop_down),
          ),
        ),
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

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: DropdownButtonFormField<int>(
        initialValue: _selectedSubDistrictId,
        items: subDistrictProvider.subDistricts
            .map(
              (subDistrict) => DropdownMenuItem<int>(
                value: subDistrict.id,
                child: Text(subDistrict.name),
              ),
            )
            .toList(),
        decoration: const InputDecoration(labelText: 'Kelurahan'),
        onChanged: (value) {
          setState(() {
            _selectedSubDistrictId = value;
            final selected = subDistrictProvider.subDistricts.firstWhere(
              (item) => item.id == value,
            );
            _subDistrictIdController.text = selected.id.toString();
            _subDistrictNameController.text = selected.name;
            _postalCodeController.text = selected.postalCode;
          });
        },
        validator: (value) => value == null ? 'Pilih kelurahan' : null,
      ),
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
