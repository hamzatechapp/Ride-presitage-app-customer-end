import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/map_viewmodel.dart';

class MapWidget extends StatelessWidget {
  const MapWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<MapViewModel>();
    return FlutterMap(
      mapController: vm.mapController,
      options: MapOptions(
        initialCenter: vm.center,
        initialZoom: 14.0,
        minZoom: 5.0,
        maxZoom: 18.0,
        onPositionChanged: (pos, hasGesture) {
          if (hasGesture) {
            context.read<MapViewModel>().onMapMoved(pos.center!);
          }
        },
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.example.rideapp',
        ),
      ],
    );
  }
}