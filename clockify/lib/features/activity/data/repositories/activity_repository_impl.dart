import 'package:clockify/core/errors/failure.dart';
import 'package:clockify/core/params/params.dart';
import 'package:clockify/features/activity/business/entities/activity_entity.dart';
import 'package:clockify/features/activity/business/repositories/activity_repository.dart';
import 'package:clockify/features/activity/data/datasources/activity_local_data_source.dart';
import 'package:clockify/features/activity/data/datasources/activity_remote_data_source.dart';
import 'package:clockify/features/activity/data/models/activity_model.dart';
import 'package:clockify/core/session/presentation/providers/session_provider.dart';
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

  @override
  Future<Either<Failure, List<ActivityEntity>>> getAllActivities(GetAllActivitiesParams getAllActivitiesParams) async {
    // Get token from session;
    await sessionProvider.loadUserSession();
    final token = sessionProvider.session?.token; 
    print("Token from session provider: $token");
    if (token == null) throw Exception("Unauthorized: Token is missing");

    // Fetch remotely
    final remoteResult = await remoteDataSource.getAllActivities(token: token, getAllActivitiesParams: getAllActivitiesParams);
    print("Remote Result: ${remoteResult.data}");

    if (remoteResult is ServerFailure && remoteResult.errors == null) {
      return Left(ServerFailure([], errorMessage: remoteResult.message!));
    }

    if (remoteResult.data == null) {
      print("No activities found, returning empty list.");
      return Right([]); // Return an empty list instead of null
    }

    // Update local storage
    await localDataSource.saveAllActivities(remoteResult.data!);
    
    return Right(remoteResult.data!.map((activity) => activity.toEntity()).toList());
  }

  @override
  Future<Either<Failure, void>> createActivity(ActivityEntity activity) async {
    // Get token from session;
    final token = sessionProvider.session?.token; 
    if (token == null) throw Exception("Unauthorized: Token is missing");

    // final model = ActivityModel.fromEntity(activity, token);
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
  Future<void> saveAllActivities(List<ActivityEntity> activities) {
    // TODO: implement saveAllActivities
    throw UnimplementedError();
  }
  
  @override
  Future<Either<ServerFailure, void>> updateActivity(UpdateActivityParams updateActivityParams) async {
    // Get token from session;
    final token = sessionProvider.session?.token; 
    if (token == null) throw Exception("Unauthorized: Token is missing");

    try {
      print("Update Activity Params in Impl: ${updateActivityParams.toJson()}");
      if (isOnline) {
        await remoteDataSource.updateActivity(updateActivityParams: updateActivityParams, token: token);
      } else {
        return Left(ServerFailure(null, errorMessage: "Failed to update activity remotely"));
      }
      return Right(null); // Meaning success;
    } catch (e) {
      return Left(ServerFailure(e, errorMessage:  "Failed to update activity: $e"));
    }
  }
}