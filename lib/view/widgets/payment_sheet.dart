import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_theme.dart';
import '../../viewmodels/booking_viewmodel.dart';

class PaymentSheet extends StatelessWidget {
  const PaymentSheet({super.key});

  static const _methods = [
    'Apple Pay', 'Google Pay', 'Card ending 4242', 'Cash'
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

          const Text('Payment method',
              style: TextStyle(
                color: AppTheme.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              )),
          const SizedBox(height: 6),
          const Text(
            'Payment is held first, then confirmed when the ride is accepted.',
            style: const TextStyle(color: Color(0xFFB0B0B0), fontSize: 11),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),

          ..._methods.map((m) {
            final sel = vm.paymentMethod == m;
            return GestureDetector(
              onTap: () => context.read<BookingViewModel>().setPaymentMethod(m),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 14),
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  color: sel
                      ? const Color(0xFFC8973A).withOpacity(0.12)
                      : AppTheme.cardBg,
                  borderRadius: BorderRadius.circular(12),
                  border: sel
                      ? Border.all(color: const Color(0xFFC8973A), width: 1.5)
                      : null,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(m,
                        style: TextStyle(
                          color: sel
                              ? AppTheme.white
                              : const Color(0xFFB0B0B0),
                          fontSize: 15,
                          fontWeight: sel ? FontWeight.w500 : FontWeight.w400,
                        )),
                    if (sel)
                      const Text(
                        '✓',
                        style: TextStyle(
                          color: Color(0xFFC8973A),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                  ],
                ),
              ),
            );
          }),

          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity, height: 52,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
              ),
              child: const Text(
                'Done',
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