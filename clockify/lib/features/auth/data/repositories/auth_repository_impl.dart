import 'package:clockify/core/errors/failure.dart';
import 'package:clockify/core/params/params.dart';
import 'package:clockify/features/auth/business/repositories/auth_repository.dart';
import 'package:clockify/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:clockify/features/auth/data/models/user_model.dart';
import 'package:dartz/dartz.dart';

class AuthRepositoryImpl extends AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({
    required this.remoteDataSource
  });

  @override
  Future<Either<Failure, UserModel>> login({required LoginParams loginParams}) {
    // TODO: implement login
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, UserModel>> register({required RegisterParams registerParams}) async {
    try {
      final user = await remoteDataSource.register(registerParams: registerParams);
      return Right(user);
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