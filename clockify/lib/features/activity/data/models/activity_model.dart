import 'package:clockify/features/activity/business/entities/activity_entity.dart';
import 'package:hive/hive.dart';

part 'activity_model.g.dart';

@HiveType(typeId: 0) // Unique
class ActivityModel {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final DateTime startTime;
  
  @HiveField(2)
  final DateTime endTime;
  
  @HiveField(3)
  final String description;
  
  @HiveField(4)
  final double? locationLat;
  
  @HiveField(5)
  final double? locationLng;

  @HiveField(6)
  final DateTime createdAt;

  @HiveField(7)
  final DateTime updatedAt;

  ActivityModel({
    required this.id,
    required this.startTime,
    required this.endTime,
    this.locationLat,
    this.locationLng,
    required this.createdAt,
    required this.updatedAt,
    required this.description,
  });

  factory ActivityModel.fromEntity(ActivityEntity entity) {
    return ActivityModel(
      id: entity.id,
      startTime: entity.startTime,
      endTime: entity.endTime,
      description: entity.description,
      locationLat: entity.locationLat,
      locationLng: entity.locationLng,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt
    );
  }

  ActivityEntity toEntity() {
    return ActivityEntity(
      id: id,
      startTime: startTime,
      endTime: endTime,
      description: description,
      locationLat: locationLat,
      locationLng: locationLng,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
