import 'package:clockify/core/errors/failure.dart';
import 'package:clockify/features/auth/business/repositories/auth_repository.dart';
import 'package:dartz/dartz.dart';

class VerifyEmail {
  final AuthRepository repository;

  VerifyEmail(this.repository);

  Future<Either<Failure, String>> call(String emailToken) async {
    return await repository.verifyEmail(emailToken: emailToken);
  }
}