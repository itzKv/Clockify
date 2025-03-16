import 'package:clockify/features/activity/data/models/activity_model.dart';

class UpdateActivityResponse {
  final String status;
  final String? message;
  final ActivityModel? activity;
  final Map<String, dynamic>? errors;

  UpdateActivityResponse({
    required this.status,
    this.message,
    this.activity,
    this.errors,
  });

  factory UpdateActivityResponse.fromJson(Map<String, dynamic> json) {
    return UpdateActivityResponse(
      status: json['status'], 
      message: json.containsKey('message') ? json['message'] : null,
      activity: json.containsKey('activity') ? ActivityModel.fromJson(json: json['activity']) : null,
      errors: json.containsKey('errors') ? json['errors'] : null,
    );
  }
}