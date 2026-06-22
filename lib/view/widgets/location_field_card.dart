import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class LocationFieldCard extends StatelessWidget {
  final String label;
  final String value;
  final Color dotColor;
  final Widget? trailing;
  final bool isLoading;
  final VoidCallback? onTap;

  const LocationFieldCard({
    super.key,
    required this.label,
    required this.value,
    required this.dotColor,
    this.trailing,
    this.isLoading = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: AppTheme.cardDecoration,
        child: Row(
          children: [
            _dot(),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: AppTheme.labelStyle),
                  const SizedBox(height: 2),
                  isLoading ? _loader() : _value(),
                ],
              ),
            ),
            if (trailing != null) trailing!,
          ],
        ),
      ),
    );
  }

  Widget _dot() {
    if (label.startsWith('STOP')) {
      return Transform.rotate(
        angle: 0.785,
        child: Container(
          width: 9, height: 9,
          decoration: BoxDecoration(
            color: AppTheme.grey,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      );
    }

    if (label == 'DROP-OFF') {
      return Container(
        width: 9, height: 9,
        decoration: BoxDecoration(
          color: dotColor,
          borderRadius: BorderRadius.circular(2),
        ),
      );
    }

    return Container(
      width: 9, height: 9,
      decoration: BoxDecoration(
        color: dotColor,
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _value() => Text(
    value.isEmpty ? label : value,
    style: const TextStyle(
      color: AppTheme.white,
      fontSize: 15,
      fontWeight: FontWeight.w500,
    ),
    maxLines: 1,
    overflow: TextOverflow.ellipsis,
  );

  Widget _loader() => const SizedBox(
    height: 14, width: 140,
    child: LinearProgressIndicator(
      backgroundColor: AppTheme.darkGrey,
      color: AppTheme.goldLight,
    ),
  );
}

Widget addStopButton(VoidCallback onTap) => GestureDetector(
  onTap: onTap,
  child: Container(
    width: 32, height: 32,
    decoration: BoxDecoration(
      color: Colors.transparent,
      shape: BoxShape.circle,
      border: Border.all(
        color: AppTheme.goldLight,
        width: 1.5,
      ),
    ),
    child: const Icon(
      Icons.add,
      color: AppTheme.goldLight,
      size: 18,
    ),
  ),
);

Widget removeStopButton(VoidCallback onTap) => GestureDetector(
  onTap: onTap,
  child: Container(
    width: 32, height: 32,
    decoration: BoxDecoration(
      color: AppTheme.goldLight.withOpacity(0.15),
      shape: BoxShape.circle,
    ),
    child: const Icon(
      Icons.close,
      color: AppTheme.goldLight,
      size: 16,
    ),
  ),
);