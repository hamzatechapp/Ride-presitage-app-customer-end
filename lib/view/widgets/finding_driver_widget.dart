import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class FindingDriverWidget extends StatelessWidget {
  const FindingDriverWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
            decoration: BoxDecoration(
              color: const Color(0xFF0A0A0A),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                SizedBox(
                  width: 52, height: 52,
                  child: CircularProgressIndicator(
                    color: AppTheme.goldLight,
                    backgroundColor: AppTheme.goldLight.withOpacity(0.15),
                    strokeWidth: 3,
                  ),
                ),
                const SizedBox(height: 20),

                const Text(
                  'Looking for a nearby driver',
                  style: TextStyle(
                    color: AppTheme.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),

                const Text(
                  'Your request is being matched with the best '
                      'available operator. Scheduled journeys are held '
                      'and dispatched before pickup time.',
                  style: TextStyle(
                    color: AppTheme.grey,
                    fontSize: 13,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),

          GestureDetector(
            onTap: () {},
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: AppTheme.goldLight,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'REFER A FRIEND, EARN £5 →',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}