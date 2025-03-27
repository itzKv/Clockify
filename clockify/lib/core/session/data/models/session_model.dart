import 'package:hive/hive.dart';

part 'session_model.g.dart';

@HiveType(typeId: 1)
class SessionModel {
  @HiveField(0)
  final String token;

  @HiveField(1)
  final String userId;

  @HiveField(2)
  final DateTime expiryDate;

  SessionModel({
    required this.token,
    required this.userId,
    required this.expiryDate
  });
}