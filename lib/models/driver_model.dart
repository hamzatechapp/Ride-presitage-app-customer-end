enum TripStatus {
  lookingForDriver,
  driverAssigned,
  onTheWay,
  arrived,
  tripStarted,
  dropOff,
  completed,
}

class DriverModel {
  final String id;
  final String name;
  final String initials;
  final String vehicleName;
  final String licensePlate;
  final String phoneNumber;
  final TripStatus status;
  final int etaMinutes;

  const DriverModel({
    required this.id,
    required this.name,
    required this.initials,
    required this.vehicleName,
    required this.licensePlate,
    required this.phoneNumber,
    this.status = TripStatus.driverAssigned,
    this.etaMinutes = 0,
  });

  String get etaText => etaMinutes > 0 ? 'ETA $etaMinutes MIN' : '';

  DriverModel copyWith({TripStatus? status, int? etaMinutes}) {
    return DriverModel(
      id: id,
      name: name,
      initials: initials,
      vehicleName: vehicleName,
      licensePlate: licensePlate,
      phoneNumber: phoneNumber,
      status: status ?? this.status,
      etaMinutes: etaMinutes ?? this.etaMinutes,
    );
  }
}

class StatusStep {
  final String label;
  final TripStatus status;
  final bool isCompleted;
  final bool isActive;

  const StatusStep({
    required this.label,
    required this.status,
    required this.isCompleted,
    required this.isActive,
  });
}