import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class TopBarWidget extends StatelessWidget {
  const TopBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0, left: 0, right: 0,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              Container(
                width: 44, height: 44,
                decoration: BoxDecoration(
                  color: AppTheme.darkBg.withOpacity(0.85),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                      color: AppTheme.goldLight.withOpacity(0.3)),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    'assets/images/img.png',
                    width: 44, height: 44,
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              const Spacer(),

              Container(
                width: 44, height: 44,
                decoration: AppTheme.topBarButton(),
                child: const Icon(
                  Icons.menu,
                  color: AppTheme.goldLight,
                  size: 22,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}