import 'package:clockify/features/activity/data/models/activity_model.dart';

class CreateActivityResponse {
  final String status;
  final String? message;
  final ActivityModel? data;
  final Map<String, dynamic>? errors;

  CreateActivityResponse({
    required this.status,
    this.message,
    this.data,
    this.errors
  });

  factory CreateActivityResponse.fromJson(Map<String, dynamic> json) {
    return CreateActivityResponse(
      status: json['status'],
      message: json.containsKey('message') 
        ? json['message']
        : null,
      data: json.containsKey('data') 
        ? ActivityModel.fromJson(json: json['data']['activity'])
        : null,
        errors: json.containsKey('errors') ? json['errors'] : null,
    );
  }
}