class ActivityEntity {
  final String id;
  final DateTime startTime;
  final DateTime endTime;
  final String description;
  final double? locationLat;
  final double? locationLng;
  final DateTime createdAt;
  final DateTime updatedAt;

  ActivityEntity({
    required this.id,
    required this.startTime,
    required this.endTime,
    required this.description,
    this.locationLat,
    this.locationLng,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'locationLat': locationLat,
      'locationLng': locationLng,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'description': description,
    };
  }

  static ActivityEntity fromMap(Map<String, dynamic> map) {
    return ActivityEntity(
      id: map['id'], 
      startTime: DateTime.parse(map['startTime']), 
      endTime: DateTime.parse(map['endTime']), 
      description: map['description'], 
      locationLat: map['locationLat'],
      locationLng: map['locationLng'],
      createdAt: DateTime.parse(map['createdAt']), 
      updatedAt: DateTime.parse(map['updatedAt']), 
    );
  }
}