import 'package:clockify/features/activity/data/models/activity_model.dart';

class GetAllActivitiesResponse {
  final String status;
  final String? message;
  final int? length;
  final List<ActivityModel>? data;
  final Map<String, dynamic>? errors;

  GetAllActivitiesResponse({
    required this.status,
    this.message,
    this.length,
    this.data,
    this.errors
  });

  factory GetAllActivitiesResponse.fromJson(Map<String, dynamic> json) {
    return GetAllActivitiesResponse(
      status: json['status'],
      message: json['message'],
      length: json.containsKey('length') ? json['length'] : null,
      data: json.containsKey('data') && json['data'].containsKey('activities')
        ? (json['data']['activities'] as List).map((item) => ActivityModel.fromJson(json: item)).toList()
        : null,
        errors: json.containsKey('errors') ? json['errors'] : null,
    );
  }

}