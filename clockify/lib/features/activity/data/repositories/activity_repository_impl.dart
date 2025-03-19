import 'package:clockify/core/errors/failure.dart';
import 'package:clockify/features/activity/business/entities/activity_entity.dart';
import 'package:clockify/features/activity/business/repositories/activity_repository.dart';
import 'package:clockify/features/activity/data/datasources/activity_local_data_source.dart';
import 'package:clockify/features/activity/data/datasources/activity_remote_data_source.dart';
import 'package:clockify/features/activity/data/models/activity_model.dart';
import 'package:clockify/features/activity/data/models/responses/search_activity_description.dart';
import 'package:clockify/features/session/presentation/providers/session_provider.dart';
import 'package:dartz/dartz.dart';

class ActivityRepositoryImpl implements ActivityRepository {
  final ActivityLocalDataSource localDataSource;
  final ActivityRemoteDataSource remoteDataSource;
  final SessionProvider sessionProvider; // Inject AuthProvider
  final bool isOnline;

  ActivityRepositoryImpl({
    required this.localDataSource, 
    required this.remoteDataSource,
    required this.sessionProvider,
    required this.isOnline,
  });

  // @override
  // Future<List<ActivityEntity>> getActivityByDescription(String description) async {
  //   if (isOnline) {
  //     final remoteModels = await activityRemoteDataSou
  //   }
  //   final models = await localDataSource.getActivityByDescription(description);
  //    return models.map((model) => model.toEntity()).toList();
  // }

  @override
  Future<Either<Failure, List<ActivityEntity>>> getAllActivities() async {
    // Get token from session;
    await sessionProvider.loadUserSession();
    final token = sessionProvider.session?.token; 
    print("Token from session provider: $token");
    if (token == null) throw Exception("Unauthorized: Token is missing");

    // Fetch remotely
    final remoteResult = await remoteDataSource.getAllActivities(token: token);
    // Update local storage
    await localDataSource.saveAllActivities(remoteResult.data!);
    
    return Right(remoteResult.data!.map((activity) => activity.toEntity()).toList());
  }

  @override
  Future<Either<Failure, void>> createActivity(ActivityEntity activity) async {
    // Get token from session;
    final token = sessionProvider.session?.token; 
    if (token == null) throw Exception("Unauthorized: Token is missing");

    final model = ActivityModel.fromEntity(activity, token);
    try {
      if (isOnline) {
        await remoteDataSource.createActivity(createActivityParams: activity.toCreateParams(), token: token);
      } else {
        // await localDataSource.createActivity(model);
      }
      return Right(null); // Meaning success;
    } catch (e) {
      return Left(ServerFailure(e, errorMessage:  "Failed to create activity: $e"));
    }
  }
  
  @override
  Future<Either<Failure, void>> deleteActivity(String id) async {
    // Get token from session;
    final token = sessionProvider.session?.token; 
    if (token == null) throw Exception("Unauthorized: Token is missing");

    try {
      if (isOnline) {
        await remoteDataSource.deleteActivity(activityUuid: id, token: token);
      } else {
        await localDataSource.deleteActivity(id);
      }
      return Right(null);
    } catch (e) {
      return Left(ServerFailure(e, errorMessage: "Failed to delete activity: $e"));
    }
  } 
  
  @override
  Future<Either<Failure, List<ActivityEntity>>> getActivityByDescription(String description) async {
    // Get token from session;
    final token = sessionProvider.session?.token; 
    if (token == null) throw Exception("Unauthorized: Token is missing");

    try {
      if (isOnline) {
        final SearchActivityResponse response = await remoteDataSource.searchActivity(description: description, token: token);
        return Right(response.data!.map((activity) => activity.toEntity()).toList());
      } else {
        final List<ActivityModel> activities = await localDataSource.getActivityByDescription(description);
        return Right(activities.map((activity) => activity.toEntity()).toList());
      }
    } catch (e) {
      if (e is ServerFailure) {
        return Left(ServerFailure(e.errorData, errorMessage: e.errorMessage));
      }
      return Left(ServerFailure(e, errorMessage: "Unexpected Error."));
    }
  }
  
  @override
  Future<void> saveAllActivities(List<ActivityEntity> activities) {
    // TODO: implement saveAllActivities
    throw UnimplementedError();
  }
  
  @override
  Future<Either<Failure, void>> updateActivity(ActivityEntity activity) async {
    // Get token from session;
    final token = sessionProvider.session?.token; 
    if (token == null) throw Exception("Unauthorized: Token is missing");

    final model = ActivityModel.fromEntity(activity, token);
    try {
      if (isOnline) {
        await remoteDataSource.updateActivity(updateActivityParams: activity.toUpdateParams(), token: token);
      }
      await localDataSource.createActivity(model); // Just stack the older uuid
      return Right(null); // Meaning success;
    } catch (e) {
      return Left(ServerFailure(e, errorMessage:  "Failed to create activity: $e"));
    }
  }

  Future<Either<Failure, List<ActivityEntity>>> fetchAndUpdateRemote(String token) async {
    if (!isOnline) {
      return Left(ServerFailure([], errorMessage: "No activities found and offline"));
    }

    try {
      final response = await remoteDataSource.getAllActivities(token: token);
      List<ActivityModel> remoteActivities = response.data ?? [];

      // Save new data to local storage
      await localDataSource.saveAllActivities(remoteActivities);


      return Right(remoteActivities.map((e) => e.toEntity()).toList());
    } catch (e, stacktrace) {
      print("Error in getAllActivities: $e");
      print("Stacktrace: $stacktrace");
      return Left(ServerFailure(e, errorMessage: "Unexpected error"));
    }
  }
  
  @override
  Future<Either<Failure, List<ActivityEntity>>> sortActivites(String params, List<double>? location) async {
    // Get token from session;
    final token = sessionProvider.session?.token; 
    if (token == null) throw Exception("Unauthorized: Token is missing");

    try {
      if (isOnline) {
        final response = await remoteDataSource.sortActivities(params: params, location: location, token: token);
        return Right(response.data!.map((activity) => activity.toEntity()).toList());
      } else {
        return Left(ServerFailure(null, errorMessage: "No internet connection"));
      }
    } catch (e) {
      return Left(ServerFailure(e, errorMessage: "Failed to sort activity: $e"));
    }
  }
}