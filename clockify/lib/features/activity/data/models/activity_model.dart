import 'package:clockify/features/activity/business/entities/activity_entity.dart';
import 'package:hive/hive.dart';

part 'activity_model.g.dart';

@HiveType(typeId: 0) // Unique
class ActivityModel {
  @HiveField(0)
  final String uuid;
  
  @HiveField(1)
  final String description;
  
  @HiveField(2)
  final DateTime startTime;
  
  @HiveField(3)
  final DateTime endTime;
  
  @HiveField(4)
  final int duration;
  
  @HiveField(5)
  final double? locationLat;
  
  @HiveField(6)
  final double? locationLng;
  
  @HiveField(7)
  final String userUuid;

  @HiveField(8)
  final DateTime createdAt;

  @HiveField(9)
  final DateTime updatedAt;

  ActivityModel({
    required this.uuid,
    required this.description,
    required this.startTime,
    required this.endTime,
    required this.duration,
    this.locationLat,
    this.locationLng,
    required this.userUuid,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ActivityModel.fromEntity(ActivityEntity entity, String userUuid) {
    return ActivityModel(
      uuid: entity.uuid,
      startTime: entity.startTime,
      endTime: entity.endTime,
      duration: entity.duration,
      description: entity.description,
      locationLat: entity.locationLat,
      locationLng: entity.locationLng,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      userUuid: userUuid,
    );
  }

  factory ActivityModel.fromJson({ required Map<String, dynamic> json }) {
    return ActivityModel(
      uuid: json['uuid'],
      description: json['description'],
      startTime: DateTime.parse(json['start_time']),
      endTime: DateTime.parse(json['end_time']),
      duration: json['duration'],
      locationLat: (json['location_lat'] as num).toDouble(),
      locationLng: (json['location_lng'] as num).toDouble(),
      userUuid: json['user_uuid'],
      updatedAt: DateTime.parse(json['updatedAt']),
      createdAt: DateTime.parse(json['createdAt'])
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uuid': uuid,
      'start_time': startTime.toIso8601String(),
      'end_time': endTime.toIso8601String(),
      'description': description,
      'location_lat': locationLat,
      'location_lng': locationLng,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'duration': duration,
      'user_uuid': userUuid,
    };
  }

  // Convert ActivityModel to ActivityEntity
  ActivityEntity toEntity() {
    return ActivityEntity(
      uuid: uuid,
      description: description,
      startTime: startTime,
      endTime: endTime,
      duration: duration,
      locationLat: locationLat,
      locationLng: locationLng,
      updatedAt: updatedAt,
      createdAt: createdAt,
    );
  }
}
