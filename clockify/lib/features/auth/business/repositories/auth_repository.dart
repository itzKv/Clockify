import 'package:clockify/core/errors/failure.dart';
import 'package:clockify/core/params/params.dart';
import 'package:clockify/features/auth/data/models/responses/forgot_password_response.dart';
import 'package:clockify/features/auth/data/models/responses/login_user_response.dart';
import 'package:clockify/features/auth/data/models/responses/reset_password_response.dart';
import 'package:clockify/features/auth/data/models/user_model.dart';
import 'package:dartz/dartz.dart';

abstract class AuthRepository {
  Future<Either<Failure, LoginResult>> login({ required LoginParams loginParams });
  Future<Either<Failure, UserModel>> register({ required RegisterParams registerParams });
  Future<Either<Failure, String>> verifyEmail({ required String emailToken });
  Future<Either<Failure, ForgotPasswordResponse>> forgotPassword({ required String email });
  Future<Either<Failure, ResetPasswordResponse>> resetPassword({ required ResetPasswordParams resetPasswordParams });
}