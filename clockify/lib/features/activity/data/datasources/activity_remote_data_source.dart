import 'package:clockify/core/errors/failure.dart';
import 'package:clockify/core/network/api_endpoints.dart';
import 'package:clockify/core/network/dio_client.dart';
import 'package:clockify/core/params/params.dart';
import 'package:clockify/features/activity/data/models/responses/create_activity_response.dart';
import 'package:clockify/features/activity/data/models/responses/delete_activity_response.dart';
import 'package:clockify/features/activity/data/models/responses/get_all_activities_response.dart';
import 'package:clockify/features/activity/data/models/responses/search_activity_description.dart';
import 'package:clockify/features/activity/data/models/responses/sort_activities_response.dart';
import 'package:clockify/features/activity/data/models/responses/update_activity_response.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

abstract class ActivityRemoteDataSource {
  Future<CreateActivityResponse> createActivity({required CreateActivityParams createActivityParams, required String token});
  Future<GetAllActivitiesResponse> getAllActivities({required String token, required GetAllActivitiesParams getAllActivitiesParams});
  Future<DeleteActivityResponse> deleteActivity({required String activityUuid, required String token});
  Future<UpdateActivityResponse> updateActivity({required UpdateActivityParams updateActivityParams, required String token});
}

class ActivityRemoteDataSourceImpl implements ActivityRemoteDataSource {
  final DioClient dioClient;

  ActivityRemoteDataSourceImpl(this.dioClient);

  @override
  Future<CreateActivityResponse> createActivity({required CreateActivityParams createActivityParams, required String token}) async {
    try {
      final response = await dioClient.dio.post(
        ApiEndpoints.createActivity,
        data: createActivityParams.toJson(),
        options: Options(
          method: 'POST',
          headers: {
            'Authorization': 'Bearer $token',
          }
        )
      );
      debugPrint("Create Activity Response: ${response.data}");
      return CreateActivityResponse.fromJson(response.data);
    } on DioException catch(e) {
      throw ServerFailure(e.response?.data, errorMessage: e.message!);
    }
  }

  @override
  Future<GetAllActivitiesResponse> getAllActivities({required GetAllActivitiesParams getAllActivitiesParams, required String token}) async {
    try {
      final String keyword = getAllActivitiesParams.description ?? "";
      final String choice = getAllActivitiesParams.choice;
      final double latitude = getAllActivitiesParams.locationLat ?? 0.0;
      final double longitude = getAllActivitiesParams.locationLng ?? 0.0;

      final response = await dioClient.dio.get(
        '${ApiEndpoints.getAllActivities}?description=$keyword&sortBy=$choice&lat=$latitude&lng=$longitude',
        options: Options(
          method: 'GET',
          headers: {
            'Authorization': 'Bearer $token',
          }
        )
      );
      final data = response.data;
      return GetAllActivitiesResponse.fromJson(data);
    } on DioException catch(e) {
      final statusCode = e.response?.statusCode;
      final errorData = e.response?.data ?? "No response data";
      debugPrint("Error Data: $errorData");
      if (errorData.toString().contains("is offline") || errorData.toString().contains("No response data")) {
        return GetAllActivitiesResponse(status: 'fail', data: [], errors: {'message': {'No post found'}});
      }
      final errorMessage = errorData['message'] ?? "Unknown error";

      debugPrint("DioException occurred: $errorMessage");
      debugPrint("Response data: $errorData");

      if (statusCode == 404) {
        // Return empty list
        debugPrint("No activities found!");
        return GetAllActivitiesResponse(status: 'fail', data: []);
      }

      throw ServerFailure(errorData, errorMessage: errorMessage);
    }
  }
  
  @override
  Future<DeleteActivityResponse> deleteActivity({required String activityUuid, required String token}) async {
    try {
      final response = await dioClient.dio.delete(
        '${ApiEndpoints.deleteActivity}/$activityUuid',
        options: Options(
          method: "DEL",
          headers: {
            'Authorization': 'Bearer $token',
          }
        )
      );
      final data = response.data;
      debugPrint("Delete Activity Response: $data");
      return DeleteActivityResponse.fromJson(data);
    } on DioException catch (e) {
      throw ServerFailure(e.response?.data, errorMessage: e.message!);
    }
  }
  
  @override
  Future<UpdateActivityResponse> updateActivity({required UpdateActivityParams updateActivityParams, required String token}) async {
    print("Update Activity Params: ${updateActivityParams.toJson()}");
    print("Update Activity UUID: ${updateActivityParams.activityUuid}");
    try {
      final response = await dioClient.dio.patch(
        '${ApiEndpoints.updateActivity}/${updateActivityParams.activityUuid}',
        data: updateActivityParams.toJson(),
        options: Options(
          method: "PATCH",
          headers: {
            'Authorization': 'Bearer $token',
          }
        )
      );
      final data = response.data;
      debugPrint("Update Activity Response: $data");
      return UpdateActivityResponse.fromJson(data);
    } on DioException catch (e) {
      debugPrint("E: ${e}");
      debugPrint("E response: ${e.response}");
      debugPrint("E data: ${e.response?.data}");
      throw ServerFailure(e.response?.data, errorMessage: e.message!);
    }
  }
}