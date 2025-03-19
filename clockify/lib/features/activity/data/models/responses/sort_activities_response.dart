import 'package:clockify/features/activity/data/models/activity_model.dart';

class SortActivitiesResponse {
  final String status;
  final String? message;
  final int? length;
  final List<ActivityModel>? data;
  final Map<String, dynamic>? errors;

  SortActivitiesResponse({
    required this.status,
    this.message,
    this.length,
    this.data,
    this.errors
  });

  factory SortActivitiesResponse.fromJson(Map<String, dynamic> json) {
    return SortActivitiesResponse(
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