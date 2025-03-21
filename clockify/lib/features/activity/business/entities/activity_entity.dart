import 'package:clockify/core/params/params.dart';

class ActivityEntity {
  final String uuid;
  final DateTime startTime;
  final DateTime endTime;
  final int duration;
  final String description;
  final double? locationLat;
  final double? locationLng;
  final DateTime createdAt;
  final DateTime updatedAt;

  ActivityEntity({
    required this.uuid,
    required this.startTime,
    required this.endTime,
    required this.duration,
    required this.description,
    this.locationLat,
    this.locationLng,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'uuid': uuid,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'duration': duration,
      'locationLat': locationLat,
      'locationLng': locationLng,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'description': description,
    };
  }

  static ActivityEntity fromMap(Map<String, dynamic> map) {
    return ActivityEntity(
      uuid: map['uuid'], 
      startTime: DateTime.parse(map['startTime']), 
      endTime: DateTime.parse(map['endTime']), 
      duration: map['duration'],
      description: map['description'], 
      locationLat: map['locationLat'],
      locationLng: map['locationLng'],
      createdAt: DateTime.parse(map['createdAt']), 
      updatedAt: DateTime.parse(map['updatedAt']), 
    );
  }

}
extension  ActivityEntityMapper on ActivityEntity {
  CreateActivityParams toCreateParams() {
    return CreateActivityParams(
      description: description,
      startTime: startTime.toIso8601String(),
      endTime: endTime.toIso8601String(),
      locationLat: locationLat ?? 0.0, // Handle null values
      locationLng: locationLng ?? 0.0, // Handle null values
    );
  }
  UpdateActivityParams toUpdateParams() {
    return UpdateActivityParams(
      activityUuid: uuid, 
      description: description, 
      startTime: startTime,
      endTime: endTime,
    );
  }
}