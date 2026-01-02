import 'package:coffe/data/models/shipping_rate_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CourierSelectPage extends StatelessWidget {
  const CourierSelectPage({
    super.key,
    required this.rates,
    required this.selectedRate,
  });

  final List<ShippingRateModel> rates;
  final ShippingRateModel? selectedRate;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final formatter = NumberFormat.currency(
      locale: 'id',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pilih Kurir'),
        foregroundColor: theme.colorScheme.onSurface,
        backgroundColor: Colors.transparent,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: rates.length,
        separatorBuilder: (_, index) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final rate = rates[index];
          final duration = _formatDuration(
            rate.minDuration,
            rate.maxDuration,
            rate.durationType,
          );
          final isSelected = selectedRate?.signedKey == rate.signedKey;
          return ListTile(
            tileColor: isSelected
                ? theme.colorScheme.primary.withValues(alpha: 0.08)
                : null,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 6,
            ),
            title: Text('${rate.logisticName} - ${rate.rateName}'),
            subtitle: Text(duration),
            trailing: Text(formatter.format(rate.price)),
            leading: Icon(
              isSelected
                  ? Icons.radio_button_checked
                  : Icons.radio_button_off,
              color: isSelected
                  ? theme.colorScheme.primary
                  : theme.colorScheme.onSurface.withValues(alpha: 0.4),
            ),
            onTap: () => Navigator.pop(context, rate),
          );
        },
      ),
    );
  }

  String _formatDuration(int min, int max, String type) {
    final unit = type.toLowerCase() == 'hour' ? 'jam' : 'hari';
    if (min == 0 && max == 0) return 'Estimasi tidak tersedia';
    if (min == max) return 'Estimasi $min $unit';
    return 'Estimasi $min-$max $unit';
  }
}
