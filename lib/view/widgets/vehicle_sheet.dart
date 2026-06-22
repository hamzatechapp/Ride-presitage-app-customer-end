import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_theme.dart';
import '../../viewmodels/booking_viewmodel.dart';

class VehicleSheet extends StatelessWidget {
  const VehicleSheet({super.key});

  static const Color _buttonGold = Color(0xFFC8973A);

  static const _vehicles = [
    {'name': 'Prestige',     'desc': 'Executive saloon · 1-4 passengers', 'badge': 'Best'},
    {'name': 'Executive XL', 'desc': 'Premium MPV · 1-7 passengers',      'badge': '+£10'},
    {'name': 'Minibus',      'desc': 'Private group travel · up to 16',    'badge': '+£24'},
    {'name': 'Coach',        'desc': 'Large group movement',               'badge': 'Quote'},
  ];

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<BookingViewModel>();

    return Container(
      color: AppTheme.sheetBg,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: Container(
              width: 40, height: 4,
              decoration: BoxDecoration(
                  color: Colors.grey[700],
                  borderRadius: BorderRadius.circular(10)),
            ),
          ),
          const SizedBox(height: 20),

          const Text('Vehicle type',
              style: TextStyle(
                color: AppTheme.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              )),
          const SizedBox(height: 6),
          const Text('Choose the right vehicle for your journey',
              style: AppTheme.hintStyle),
          const SizedBox(height: 20),

          ..._vehicles.map((v) {
            final sel = vm.vehicleType == v['name'];
            return GestureDetector(
              onTap: () =>
                  context.read<BookingViewModel>().setVehicleType(v['name']!),
              child: Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 14),
                decoration: BoxDecoration(
                  color: sel
                      ? _buttonGold.withOpacity(0.12)
                      : AppTheme.cardBg,
                  borderRadius: BorderRadius.circular(12),
                  border: sel
                      ? Border.all(color: _buttonGold, width: 1.5)
                      : null,
                ),
                child: Row(
                  children: [
                    Container(
                      width: 42, height: 42,
                      decoration: BoxDecoration(
                        color: const Color(0xFF111111),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(
                          'assets/icons/car.png',
                          width: 42, height: 42,
                          fit: BoxFit.contain,
                          errorBuilder: (_, __, ___) => const Icon(
                            Icons.directions_car,
                            color: AppTheme.goldLight,
                            size: 22,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            v['name']!,
                            style: TextStyle(
                              color: sel ? AppTheme.white : const Color(0xFFB0B0B0),
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            v['desc']!,
                            style: const TextStyle(
                              color: Color(0xFFB0B0B0),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),

                    Text(
                      v['badge']!,
                      style: const TextStyle(
                        color: _buttonGold,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),

          const SizedBox(height: 16),

          SizedBox(
            width: double.infinity, height: 52,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
              ),
              child: const Text(
                'Confirm vehicle',
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}