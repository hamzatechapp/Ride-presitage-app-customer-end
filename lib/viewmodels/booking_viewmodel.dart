import 'package:flutter/material.dart';
import '../models/booking_model.dart';
import '../models/location_model.dart';
import '../models/stop_model.dart';

class BookingViewModel extends ChangeNotifier {
  BookingModel _booking = BookingModel(
    pickup: LocationModel.empty(),
    dropoff: LocationModel.empty(),
  );

  bool _isLoading = false;
  bool _disposed = false;
  String? _activeSearchField;

  BookingModel get booking => _booking;
  bool get isLoading => _isLoading;
  bool get isSearching => _activeSearchField != null;
  String? get activeSearchField => _activeSearchField;

  LocationModel get pickup => _booking.pickup;
  LocationModel get dropoff => _booking.dropoff;
  List<StopModel> get stops => _booking.stops;
  String get vehicleType => _booking.vehicleType;
  String get paymentMethod => _booking.paymentMethod;
  String get notesForDriver => _booking.notesForDriver;
  String get fareDisplay => _booking.fareDisplay;
  String get distanceDisplay => _booking.distanceDisplay;
  String get pickupTimeText => _booking.pickupTimeText;
  bool get isImmediate => _booking.isImmediate;

  bool get isReadyToConfirm => _booking.dropoff.isNotEmpty;

  void setPickup(LocationModel location) {
    _booking = _booking.copyWith(pickup: location);
    _calcFare();
    notifyListeners();
  }

  void openSearchFor(String fieldId) {
    _activeSearchField = fieldId;
    notifyListeners();
  }

  void closeSearch() {
    _activeSearchField = null;
    notifyListeners();
  }

  void onLocationSelected(LocationModel location) {
    if (_activeSearchField == null) return;
    if (_activeSearchField == 'dropoff') {
      _booking = _booking.copyWith(dropoff: location);
    } else if (_activeSearchField!.startsWith('stop_')) {
      final stopId = _activeSearchField!.replaceFirst('stop_', '');
      _updateStop(stopId, location);
    }
    _calcFare();
    closeSearch();
  }

  void addStop() {
    if (_booking.stops.length >= 5) return;
    final newStops = List<StopModel>.from(_booking.stops);
    final id = 'stop_${DateTime.now().millisecondsSinceEpoch}';
    newStops.add(StopModel.empty(id: id, order: newStops.length + 1));
    _booking = _booking.copyWith(stops: newStops);
    notifyListeners();
    openSearchFor('stop_$id');
  }

  void removeStop(String stopId) {
    final newStops = List<StopModel>.from(_booking.stops)
      ..removeWhere((s) => s.id == stopId);
    for (int i = 0; i < newStops.length; i++) {
      newStops[i] = newStops[i].copyWith(order: i + 1);
    }
    _booking = _booking.copyWith(stops: newStops);
    _calcFare();
    notifyListeners();
  }

  void _updateStop(String stopId, LocationModel location) {
    final newStops = List<StopModel>.from(_booking.stops);
    final i = newStops.indexWhere((s) => s.id == stopId);
    if (i != -1) {
      newStops[i] = newStops[i].copyWith(location: location);
      _booking = _booking.copyWith(stops: newStops);
    }
  }

  void setImmediatePickup() {
    _booking = _booking.copyWith(clearScheduledTime: true);
    notifyListeners();
  }

  void setScheduledTime(DateTime time) {
    _booking = _booking.copyWith(scheduledTime: time);
    notifyListeners();
  }

  void setVehicleType(String type) {
    _booking = _booking.copyWith(vehicleType: type);
    _calcFare();
    notifyListeners();
  }

  void setPaymentMethod(String method) {
    _booking = _booking.copyWith(paymentMethod: method);
    notifyListeners();
  }

  void setNotesForDriver(String notes) {
    _booking = _booking.copyWith(notesForDriver: notes);
    notifyListeners();
  }

  Future<bool> confirmBooking() async {
    if (!isReadyToConfirm) return false;
    _isLoading = true;
    notifyListeners();
    try {
      await Future.delayed(const Duration(seconds: 2));
      if (_disposed) return false;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (_) {
      if (_disposed) return false;
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  void reset() {
    _booking = BookingModel(
      pickup: LocationModel.empty(),
      dropoff: LocationModel.empty(),
    );
    _activeSearchField = null;
    _isLoading = false;
    notifyListeners();
  }

  void _calcFare() {
    double fare = 15.0 + (14.1 * 2.5);
    fare += _booking.stops.length * 5.0;
    if (_booking.vehicleType == 'Executive XL') fare *= 1.4;
    else if (_booking.vehicleType == 'Minibus') fare *= 1.6;
    else if (_booking.vehicleType == 'Coach') fare *= 1.8;
    else fare *= 1.2;
    _booking = _booking.copyWith(
        estimatedFare: fare, estimatedMiles: 14.1, estimatedMinutes: 46);
  }
}