import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_theme.dart';
import '../../viewmodels/map_viewmodel.dart';

class MyLocationButton extends StatelessWidget {
  const MyLocationButton({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<MapViewModel>();
    return Positioned(
      right: 16, bottom: 240,
      child: GestureDetector(
        onTap: () => context.read<MapViewModel>().getUserLocation(),
        child: Container(
          width: 44, height: 44,
          decoration: BoxDecoration(
            color: AppTheme.darkBg,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.3), blurRadius: 8)
            ],
          ),
          child: vm.isLoadingLocation
              ? const Padding(
              padding: EdgeInsets.all(10),
              child: CircularProgressIndicator(
                  color: AppTheme.gold, strokeWidth: 2))
              : const Icon(Icons.my_location,
              color: AppTheme.gold, size: 22),
        ),
      ),
    );
  }
}