import 'package:clockify/features/activity/data/models/activity_model.dart';

class SearchActivityResponse {
  final String status;
  final String? message;
  final int? length;
  final List<ActivityModel>? data;
  final Map<String, dynamic>? errors;

  SearchActivityResponse({
    required this.status,
    this.message,
    this.length,
    this.data,
    this.errors
  });

  factory SearchActivityResponse.fromJson(Map<String, dynamic> json) {
    return SearchActivityResponse(
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