import 'package:flutter/material.dart';

class CenterPinWidget extends StatelessWidget {
  const CenterPinWidget({super.key});

  static const Color _gold = Color(0xFFC8973A);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 52, height: 52,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.92),
              shape: BoxShape.circle,
              border: Border.all(color: _gold, width: 2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Center(
              child: Text(
                '3 min',
                style: TextStyle(
                  color: Color(0xFF1A1A1A),
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          Container(
            width: 2,
            height: 20,
            color: _gold,
          ),
        ],
      ),
    );
  }
}