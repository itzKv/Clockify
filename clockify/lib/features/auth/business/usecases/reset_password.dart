import 'package:clockify/core/errors/failure.dart';
import 'package:clockify/core/params/params.dart';
import 'package:clockify/features/auth/business/repositories/auth_repository.dart';
import 'package:clockify/features/auth/data/models/responses/reset_password_response.dart';
import 'package:dartz/dartz.dart';

class ResetPassword {
  final AuthRepository repository;

  ResetPassword(this.repository);

  Future<Either<Failure, ResetPasswordResponse>> call(ResetPasswordParams resetPasswordParams) async {
    return await repository.resetPassword(resetPasswordParams: resetPasswordParams);
  }
}