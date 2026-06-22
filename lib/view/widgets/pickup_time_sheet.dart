import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_theme.dart';
import '../../viewmodels/booking_viewmodel.dart';

class PickupTimeSheet extends StatefulWidget {
  const PickupTimeSheet({super.key});

  @override
  State<PickupTimeSheet> createState() => _PickupTimeSheetState();
}

class _PickupTimeSheetState extends State<PickupTimeSheet> {
  int _dayIdx = 0;
  int _timeIdx = 0;

  static const Color _accent = Color(0xFFC8973A);

  final List<DateTime> _days =
  List.generate(7, (i) => DateTime.now().add(Duration(days: i)));

  final List<String> _timeLabels = [
    'ETA: 3 min', '+30 min', '+1 hour', '+2 hours'
  ];

  @override
  Widget build(BuildContext context) {
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
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 20),

          const Text(
            'Pickup time',
            style: TextStyle(
              color: AppTheme.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Choose now or schedule for later',
            style: AppTheme.hintStyle,
          ),
          const SizedBox(height: 20),

          SizedBox(
            height: 280,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppTheme.cardBg,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Column(
                        children: List.generate(_days.length, (i) {
                          final isSelected = _dayIdx == i;
                          final label = i == 0 ? 'Pickup now' : _fmt(_days[i]);
                          return GestureDetector(
                            onTap: () => setState(() => _dayIdx = i),
                            child: Container(
                              width: double.infinity,
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 3),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 13),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? _accent.withOpacity(0.18)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(10),
                                border: isSelected
                                    ? Border.all(color: _accent, width: 1.5)
                                    : null,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    label,
                                    style: TextStyle(
                                      color: isSelected
                                          ? Colors.white
                                          : const Color(0xFFB0B0B0),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  if (isSelected)
                                    const Text(
                                      '✓',
                                      style: TextStyle(
                                        color: _accent,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppTheme.cardBg,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Column(
                        children: List.generate(_timeLabels.length, (i) {
                          final isSelected = _timeIdx == i;
                          return GestureDetector(
                            onTap: () => setState(() => _timeIdx = i),
                            child: Container(
                              width: double.infinity,
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 3),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 13),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? _accent.withOpacity(0.18)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(10),
                                border: isSelected
                                    ? Border.all(color: _accent, width: 1.5)
                                    : null,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    _timeLabels[i],
                                    style: TextStyle(
                                      color: isSelected
                                          ? Colors.white
                                          : const Color(0xFFB0B0B0),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  if (isSelected)
                                    const Text(
                                      '✓',
                                      style: TextStyle(
                                        color: _accent,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          SizedBox(
            width: double.infinity, height: 52,
            child: ElevatedButton(
              onPressed: () {
                _confirm();
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: _accent,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
              ),
              child: const Text(
                'Confirm time',
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

  void _confirm() {
    final vm = context.read<BookingViewModel>();
    if (_dayIdx == 0 && _timeIdx == 0) {
      vm.setImmediatePickup();
    } else {
      final d = _days[_dayIdx];
      final mins = [0, 30, 60, 120][_timeIdx];
      vm.setScheduledTime(
        DateTime(d.year, d.month, d.day,
            DateTime.now().hour, DateTime.now().minute)
            .add(Duration(minutes: mins)),
      );
    }
  }

  String _fmt(DateTime d) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${days[d.weekday - 1]}, ${d.day} ${months[d.month - 1]}';
  }
}