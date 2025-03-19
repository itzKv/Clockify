import 'package:clockify/core/errors/failure.dart';
import 'package:clockify/core/params/params.dart';
import 'package:clockify/features/auth/business/repositories/auth_repository.dart';
import 'package:clockify/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:clockify/features/auth/data/models/responses/login_user_response.dart';
import 'package:clockify/features/auth/data/models/user_model.dart';
import 'package:dartz/dartz.dart';

class AuthRepositoryImpl extends AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({
    required this.remoteDataSource
  });

  @override
  Future<Either<Failure, LoginResult>> login({required LoginParams loginParams}) async {
    try {
      final response = await remoteDataSource.login(loginParams: loginParams);
      return Right(LoginResult(user: response.user!, message: response.message!, token: response.token!));
    } catch (e) {
      if (e is ServerFailure) {
        return Left(ServerFailure(e.errorData, errorMessage: e.errorMessage));
      }
      return Left(ServerFailure(null, errorMessage: "Unexpected error"));
    }
  }

  @override
  Future<Either<Failure, UserModel>> register({required RegisterParams registerParams}) async {
    try {
      final response = await remoteDataSource.register(registerParams: registerParams);
      return Right(response.user!);
    } catch (e) {
      if (e is ServerFailure) {
        return Left(ServerFailure(e.errorData, errorMessage: e.errorMessage));
      }
      return Left(ServerFailure(null, errorMessage: "Unexpected Error"));
    }
  }

  @override
  Future<Either<Failure, String>> verifyEmail({required String emailToken}) async {
    try {
      final response = await remoteDataSource.verifyEmail(emailToken: emailToken);
      return Right(response.message);
    }catch (e) {
      if (e is ServerFailure) {
        return Left(ServerFailure(e.errorData, errorMessage: e.errorMessage));
      }
      return Left(ServerFailure(null, errorMessage: "Unexpected Error"));
    }
  }
}