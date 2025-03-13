import 'package:clockify/core/errors/failure.dart';
import 'package:clockify/core/params/params.dart';
import 'package:clockify/features/auth/data/models/user_model.dart';
import 'package:dartz/dartz.dart';

abstract class AuthRepository {
  Future<Either<Failure, UserModel>> login({ required LoginParams loginParams });
  Future<Either<Failure, UserModel>> register({ required RegisterParams registerParams });
  Future<Either<Failure, String>> verifyEmail({ required String emailToken });
}