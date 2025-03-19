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
  Future<GetAllActivitiesResponse> getAllActivities({required String token});
  Future<DeleteActivityResponse> deleteActivity({required String activityUuid, required String token});
  Future<UpdateActivityResponse> updateActivity({required UpdateActivityParams updateActivityParams, required String token});
  Future<SearchActivityResponse> searchActivity({required String description, required String token});
  Future<SortActivitiesResponse> sortActivities({required params, required List<double>? location, required String token});
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
  Future<GetAllActivitiesResponse> getAllActivities({required String token}) async {
    try {
      final response = await dioClient.dio.get(
        ApiEndpoints.getAllActivities,
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
      throw ServerFailure(e.response?.data, errorMessage: e.message!);
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
      throw ServerFailure(e.response?.data, errorMessage: e.message!);
    }
  }
  
  @override
  Future<SearchActivityResponse> searchActivity({required String description, required String token}) async {
    try {
      final response = await dioClient.dio.get(
        '${ApiEndpoints.searchActivity}$description',
        options: Options(
          method: "GET",
          headers: {
            'Authorization': 'Bearer $token',
          }
        )
      );
      final data = response.data;
      debugPrint("Search Activity Response: $data");
      return SearchActivityResponse.fromJson(data);
    } on DioException catch (e) {
      final errorData = e.response?.data;
      final errorMessage = errorData?['errors']['message'] ?? "No activities with that description.";
      debugPrint("Error data: $errorData");
      throw ServerFailure(errorData, errorMessage: errorMessage);
    }
  }

  @override
  Future<SortActivitiesResponse> sortActivities({required params, required List<double>? location, required String token}) async {
    try {
      Response response;

      if (params == 'Latest Date') {
        response = await dioClient.dio.get(
          '${ApiEndpoints.sortActivities}=latest',
          options: Options(
            method: 'GET',
            headers: {
              'Authorization': 'Bearer $token',
            }
          )
        );
        debugPrint("Sort by Latest Date Response: ${response.data}");
      } else if (params == 'Nearby') {
        if (location == null || location.length < 2) {
          throw ArgumentError("Location must contain latitude and longitude.");
        }

        response = await dioClient.dio.get(
          '${ApiEndpoints.sortActivities}=distance&lat=${location[0]}&lng=${location[1]}',
          options: Options(
            method: 'GET',
            headers: {
              'Authorization': 'Bearer $token',
            }
          )
        );
        debugPrint("Sort by Nearby Response: ${response.data}");
      } else {
        throw ArgumentError("Invalid sorting parameter: $params");
      }

      return SortActivitiesResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw ServerFailure(e.response?.data, errorMessage: e.message!);
    }
  }
}