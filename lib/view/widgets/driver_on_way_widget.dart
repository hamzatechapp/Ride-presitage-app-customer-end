import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_theme.dart';
import '../../viewmodels/booking_viewmodel.dart';
import '../../viewmodels/driver_viewmodel.dart';

class DriverOnWayWidget extends StatelessWidget {
  const DriverOnWayWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final driverVm = context.watch<DriverViewModel>();
    final driver = driverVm.driver!;

    return Container(
      color: const Color(0xFF0A0A0A),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 16),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1A1A1A),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Container(
                    width: 52, height: 52,
                    decoration: const BoxDecoration(
                      color: Color(0xFFC8973A),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        driver.initials,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(driver.name,
                            style: const TextStyle(
                              color: AppTheme.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            )),
                        const SizedBox(height: 3),
                        Text(
                          '${driver.vehicleName} · ${driver.licensePlate}',
                          style: const TextStyle(
                              color: AppTheme.grey, fontSize: 13),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),

                  GestureDetector(
                    onTap: () =>
                        context.read<DriverViewModel>().callDriver(),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFC8973A),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text('Call',
                          style: TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          )),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: driverVm.statusSteps.map((step) {
                final isDone = step.isActive || step.isCompleted;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    children: [
                      Container(
                        width: 14, height: 14,
                        decoration: BoxDecoration(
                          color: isDone
                              ? AppTheme.goldLight
                              : Colors.transparent,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isDone
                                ? AppTheme.goldLight
                                : Colors.grey[600]!,
                            width: 1.5,
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Text(
                        step.label,
                        style: TextStyle(
                          color: isDone
                              ? AppTheme.white
                              : Colors.grey[500],
                          fontSize: 15,
                          fontWeight: step.isActive
                              ? FontWeight.w600
                              : FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 20),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: GestureDetector(
              onTap: () {
                context.read<DriverViewModel>().cancelBooking();
                context.read<BookingViewModel>().reset();
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1A1A),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Center(
                  child: Text(
                    'Back to home',
                    style: TextStyle(
                      color: AppTheme.goldLight,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}