import 'location_model.dart';

class StopModel {
  final String id;
  final LocationModel location;
  final int order;

  const StopModel({
    required this.id,
    required this.location,
    required this.order,
  });

  factory StopModel.empty({required String id, required int order}) {
    return StopModel(
      id: id,
      location: LocationModel.empty(),
      order: order,
    );
  }

  String get label => 'STOP $order';
  bool get hasLocation => location.isNotEmpty;

  StopModel copyWith({LocationModel? location, int? order}) {
    return StopModel(
      id: id,
      location: location ?? this.location,
      order: order ?? this.order,
    );
  }
}