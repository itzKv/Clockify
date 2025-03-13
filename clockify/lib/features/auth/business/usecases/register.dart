import 'package:clockify/core/errors/failure.dart';
import 'package:clockify/core/params/params.dart';
import 'package:clockify/features/auth/business/repositories/auth_repository.dart';
import 'package:clockify/features/auth/data/models/user_model.dart';
import 'package:dartz/dartz.dart';

class Register {
  final AuthRepository repository;

  Register(this.repository);

  Future<Either<Failure, UserModel>> call(RegisterParams registerParams) async {
    return await repository.register(registerParams: registerParams);
  }
}