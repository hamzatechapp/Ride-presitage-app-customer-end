import 'package:latlong2/latlong.dart';

class LocationModel {
  final String address;
  final LatLng latLng;

  const LocationModel({
    required this.address,
    required this.latLng,
  });

  static LocationModel empty() =>
      LocationModel(address: '', latLng: LatLng(0, 0));

  bool get isEmpty => address.isEmpty;
  bool get isNotEmpty => address.isNotEmpty;

  LocationModel copyWith({String? address, LatLng? latLng}) {
    return LocationModel(
      address: address ?? this.address,
      latLng: latLng ?? this.latLng,
    );
  }

  @override
  String toString() => 'LocationModel(address: $address)';
}