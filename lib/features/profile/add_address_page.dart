import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/models/address_model.dart';
import 'providers/address_provider.dart';

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
              _field(_provinceIdController, 'Province ID',
                  keyboardType: TextInputType.number),
              _field(_cityIdController, 'City ID',
                  keyboardType: TextInputType.number),
              _field(_districtIdController, 'District ID',
                  keyboardType: TextInputType.number),
              _field(_postalCodeController, 'Kode Pos'),
              _field(_provinceNameController, 'Nama Provinsi'),
              _field(_cityNameController, 'Nama Kota'),
              _field(_districtNameController, 'Nama Kecamatan'),
              _field(_subDistrictIdController, 'Sub District ID'),
              _field(_subDistrictNameController, 'Nama Kelurahan'),
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
