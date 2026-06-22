import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_theme.dart';
import '../../viewmodels/booking_viewmodel.dart';
import '../../viewmodels/driver_viewmodel.dart';

class ConfirmSheet extends StatelessWidget {
  const ConfirmSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final bookVm = context.watch<BookingViewModel>();

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _handle(),
          const SizedBox(height: 20),
          const Text('Confirm request', style: AppTheme.headingStyle),
          const SizedBox(height: 8),
          Text(
            'Estimated fare: ${bookVm.fareDisplay}. Payment will be authorised, then your app will look for a driver.',
            style: AppTheme.hintStyle, textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: AppTheme.cardDecoration,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                _CheckItem('Route selected'),
                SizedBox(height: 10),
                _CheckItem('Time selected'),
                SizedBox(height: 10),
                _CheckItem('Vehicle selected'),
                SizedBox(height: 10),
                _CheckItem('Payment ready'),
              ],
            ),
          ),
          const SizedBox(height: 20),

          SizedBox(
            width: double.infinity, height: 52,
            child: ElevatedButton(
              onPressed: bookVm.isLoading
                  ? null
                  : () async {
                final ok = await context
                    .read<BookingViewModel>()
                    .confirmBooking();
                if (ok && context.mounted) {
                  Navigator.pop(context);
                  context
                      .read<DriverViewModel>()
                      .startLookingForDriver();
                }
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
              ),
              child: bookVm.isLoading
                  ? const SizedBox(
                  width: 20, height: 20,
                  child: CircularProgressIndicator(
                      color: Colors.black54, strokeWidth: 2))
                  : const FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  'Authorise payment and request',
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _handle() => Center(
    child: Container(
      width: 40, height: 4,
      decoration: BoxDecoration(
          color: Colors.grey[600],
          borderRadius: BorderRadius.circular(10)),
    ),
  );
}

class _CheckItem extends StatelessWidget {
  final String text;
  const _CheckItem(this.text);

  @override
  Widget build(BuildContext context) => Row(
    children: [
      const Icon(Icons.check, color: AppTheme.gold, size: 16),
      const SizedBox(width: 8),
      Text(text, style: AppTheme.valueStyle),
    ],
  );
}