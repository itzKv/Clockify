import 'package:clockify/core/errors/failure.dart';
import 'package:clockify/features/auth/business/repositories/auth_repository.dart';
import 'package:clockify/features/auth/data/models/responses/forgot_password_response.dart';
import 'package:dartz/dartz.dart';

class ForgotPassword {
  final AuthRepository repository;

  ForgotPassword(this.repository);

  Future<Either<Failure, ForgotPasswordResponse>> call(String email) async {
    return await repository.forgotPassword(email: email);
  }
}