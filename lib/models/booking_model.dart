import 'location_model.dart';
import 'stop_model.dart';

class BookingModel {
  final LocationModel pickup;
  final LocationModel dropoff;
  final List<StopModel> stops;
  final DateTime? scheduledTime;
  final String vehicleType;
  final String paymentMethod;
  final String notesForDriver;
  final double estimatedFare;
  final double estimatedMiles;
  final int estimatedMinutes;

  const BookingModel({
    required this.pickup,
    required this.dropoff,
    this.stops = const [],
    this.scheduledTime,
    this.vehicleType = 'Prestige',
    this.paymentMethod = 'Apple Pay',
    this.notesForDriver = '',
    this.estimatedFare = 0.0,
    this.estimatedMiles = 0.0,
    this.estimatedMinutes = 0,
  });

  bool get isImmediate => scheduledTime == null;

  String get pickupTimeText {
    if (isImmediate) return 'Pickup now · ETA: 3 min';
    final d = scheduledTime!;
    return '${_day(d.weekday)}, ${d.day} ${_month(d.month)} · ${d.hour}:${d.minute.toString().padLeft(2, '0')}';
  }

  String get fareDisplay => '£${estimatedFare.toStringAsFixed(2)}';
  String get distanceDisplay =>
      '${estimatedMiles.toStringAsFixed(1)} miles · $estimatedMinutes min';

  BookingModel copyWith({
    LocationModel? pickup,
    LocationModel? dropoff,
    List<StopModel>? stops,
    DateTime? scheduledTime,
    bool clearScheduledTime = false,
    String? vehicleType,
    String? paymentMethod,
    String? notesForDriver,
    double? estimatedFare,
    double? estimatedMiles,
    int? estimatedMinutes,
  }) {
    return BookingModel(
      pickup: pickup ?? this.pickup,
      dropoff: dropoff ?? this.dropoff,
      stops: stops ?? this.stops,
      scheduledTime:
      clearScheduledTime ? null : scheduledTime ?? this.scheduledTime,
      vehicleType: vehicleType ?? this.vehicleType,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      notesForDriver: notesForDriver ?? this.notesForDriver,
      estimatedFare: estimatedFare ?? this.estimatedFare,
      estimatedMiles: estimatedMiles ?? this.estimatedMiles,
      estimatedMinutes: estimatedMinutes ?? this.estimatedMinutes,
    );
  }

  String _day(int w) =>
      ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'][w - 1];
  String _month(int m) => [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
  ][m - 1];
}