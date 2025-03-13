import 'package:clockify/core/errors/failure.dart';
import 'package:clockify/core/params/params.dart';
import 'package:clockify/features/auth/business/repositories/auth_repository.dart';
import 'package:clockify/features/auth/data/models/user_model.dart';
import 'package:dartz/dartz.dart';

class Login {
  final AuthRepository repository;

  Login(this.repository);

  Future<Either<Failure, UserModel>> call(LoginParams loginParams) async {
    return await repository.login(loginParams: loginParams);
  }
}