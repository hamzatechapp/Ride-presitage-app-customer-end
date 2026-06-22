import 'dart:async';
import 'package:flutter/material.dart';
import '../models/driver_model.dart';

class DriverViewModel extends ChangeNotifier {
  DriverModel? _driver;
  bool _isLooking = false;
  String? _errorMessage;
  Timer? _etaTimer;

  // GETTERS
  DriverModel? get driver => _driver;
  bool get isLooking => _isLooking;
  bool get driverFound => _driver != null;
  String? get errorMessage => _errorMessage;
  TripStatus get currentStatus =>
      _driver?.status ?? TripStatus.lookingForDriver;

  List<StatusStep> get statusSteps {
    final statuses = [
      TripStatus.driverAssigned,
      TripStatus.onTheWay,
      TripStatus.arrived,
      TripStatus.tripStarted,
      TripStatus.dropOff,
      TripStatus.completed,
    ];
    final labels = [
      'Driver assigned', 'On the way', 'Arrived',
      'Trip started', 'Drop-off', 'Completed',
    ];
    return List.generate(statuses.length, (i) {
      final currentIdx = TripStatus.values.indexOf(currentStatus);
      final thisIdx = TripStatus.values.indexOf(statuses[i]);
      return StatusStep(
        label: labels[i],
        status: statuses[i],
        isCompleted: thisIdx < currentIdx,
        isActive: statuses[i] == currentStatus,
      );
    });
  }

  // ── START LOOKING ────────────────────────────────────────
  Future<void> startLookingForDriver() async {
    _isLooking = true;
    _driver = null;
    _errorMessage = null;
    notifyListeners();

    try {
      await Future.delayed(const Duration(seconds: 3));
      _driver = const DriverModel(
        id: 'driver_001',
        name: 'James Carter',
        initials: 'JC',
        vehicleName: 'Mercedes V-Class',
        licensePlate: 'PX26 RDE',
        phoneNumber: '+44 7700 900000',
        status: TripStatus.onTheWay,
        etaMinutes: 8,
      );
      _isLooking = false;
      notifyListeners();
      _startEtaTimer();
    } catch (_) {
      _isLooking = false;
      _errorMessage = 'Could not find a driver.';
      notifyListeners();
    }
  }

  void updateStatus(TripStatus status) {
    if (_driver == null) return;
    _driver = _driver!.copyWith(status: status);
    notifyListeners();
  }

  void callDriver() {
    debugPrint('Calling: ${_driver?.phoneNumber}');
  }

  void cancelBooking() {
    _etaTimer?.cancel();
    _driver = null;
    _isLooking = false;
    notifyListeners();
  }

  void _startEtaTimer() {
    _etaTimer = Timer.periodic(const Duration(minutes: 1), (_) {
      if (_driver == null) { _etaTimer?.cancel(); return; }
      final eta = _driver!.etaMinutes - 1;
      if (eta <= 0) {
        _etaTimer?.cancel();
        updateStatus(TripStatus.arrived);
      } else {
        _driver = _driver!.copyWith(etaMinutes: eta);
        notifyListeners();
      }
    });
  }

  @override
  void dispose() {
    _etaTimer?.cancel();
    super.dispose();
  }
}