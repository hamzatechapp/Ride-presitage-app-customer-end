import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import '../models/location_model.dart';

class MapViewModel extends ChangeNotifier {
  final MapController mapController = MapController();
  static const LatLng _default = LatLng(53.3811, -1.4701);

  LocationModel _pickup = LocationModel.empty();
  LatLng _center = _default;
  bool _isLoadingLocation = false;
  bool _isLoadingAddress = false;
  bool _isSearching = false;
  String? _activeSearchField;
  String? _errorMessage;
  bool _disposed = false;

  LocationModel get pickup        => _pickup;
  LatLng get center               => _center;
  bool get isLoadingLocation      => _isLoadingLocation;
  bool get isLoadingAddress       => _isLoadingAddress;
  bool get isSearching            => _isSearching;
  String? get activeSearchField   => _activeSearchField;
  String? get errorMessage        => _errorMessage;

  String get pickupAddress =>
      _pickup.isNotEmpty ? _pickup.address : 'Fetching location...';

  MapViewModel() {
    getUserLocation();
  }

  @override
  void dispose() {
    _disposed = true;
    mapController.dispose();
    super.dispose();
  }

  void _safeNotify() {
    if (!_disposed) notifyListeners();
  }

  Future<void> getUserLocation() async {
    _isLoadingLocation = true;
    _errorMessage = null;
    _safeNotify();

    try {
      LocationPermission perm = await Geolocator.checkPermission();
      if (perm == LocationPermission.denied) {
        perm = await Geolocator.requestPermission();
      }
      if (perm == LocationPermission.deniedForever) {
        _errorMessage = 'Location permission denied.';
        _isLoadingLocation = false;
        _safeNotify();
        return;
      }
      if (perm == LocationPermission.whileInUse ||
          perm == LocationPermission.always) {
        final pos = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);
        if (_disposed) return;
        final ll = LatLng(pos.latitude, pos.longitude);
        _center = ll;
        mapController.move(ll, 15.0);
        await _fetchAddress(ll);
      }
    } catch (e) {
      _errorMessage = 'Could not get location.';
    } finally {
      _isLoadingLocation = false;
      _safeNotify();
    }
  }

  void onMapMoved(LatLng newCenter) {
    _center = newCenter;
    _safeNotify();
    final captured = newCenter;
    Future.delayed(const Duration(milliseconds: 800), () {
      if (!_disposed && _center == captured) _fetchAddress(captured);
    });
  }

  void openSearch() {
    _isSearching = true;
    _activeSearchField = 'pickup';
    _safeNotify();
  }

  void closeSearch() {
    _isSearching = false;
    _activeSearchField = null;
    _safeNotify();
  }

  void onLocationSelected(LocationModel location) {
    _pickup = location;
    _center = location.latLng;
    mapController.move(location.latLng, 15.0);
    closeSearch();
  }

  Future<void> _fetchAddress(LatLng pos) async {
    _isLoadingAddress = true;
    _safeNotify();
    try {
      final url = Uri.parse(
          'https://nominatim.openstreetmap.org/reverse'
              '?format=json&lat=${pos.latitude}&lon=${pos.longitude}');
      final res = await http.get(url, headers: {
        'User-Agent': 'RideApp/1.0',
        'Accept-Language': 'en',
      });
      if (_disposed) return;
      if (res.statusCode == 200) {
        final data = json.decode(res.body);
        _pickup = LocationModel(address: _buildAddress(data), latLng: pos);
      }
    } catch (_) {
    } finally {
      _isLoadingAddress = false;
      _safeNotify();
    }
  }

  String _buildAddress(Map<String, dynamic> data) {
    final a = data['address'] as Map<String, dynamic>?;
    if (a == null) return data['display_name'] ?? 'Selected location';
    final parts = <String>[];
    final road = a['road'] as String?;
    final house = a['house_number'] as String?;
    if (road != null) parts.add(house != null ? '$house $road' : road);
    final city = a['city'] as String? ??
        a['town'] as String? ??
        a['village'] as String?;
    if (city != null) parts.add(city);
    final post = a['postcode'] as String?;
    if (post != null) parts.add(post);
    return parts.isNotEmpty ? parts.join(', ') : 'Selected location';
  }
}