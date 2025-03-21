import 'package:clockify/core/errors/failure.dart';
import 'package:clockify/core/network/api_endpoints.dart';
import 'package:clockify/core/network/dio_client.dart';
import 'package:clockify/core/params/params.dart';
import 'package:clockify/features/auth/data/models/responses/forgot_password_response.dart';
import 'package:clockify/features/auth/data/models/responses/reset_password_response.dart';
import 'package:clockify/features/auth/data/models/responses/login_user_response.dart';
import 'package:clockify/features/auth/data/models/responses/register_user_response.dart';
import 'package:clockify/features/auth/data/models/responses/verify_email_response.dart';
import 'package:dio/dio.dart';


abstract class AuthRemoteDataSource {
  Future<LoginUserResponse> login({required LoginParams loginParams});
  Future<RegisterUserResponse> register({required RegisterParams registerParams});
  Future<VerifyEmailResponse> verifyEmail({required String emailToken});
  Future<ForgotPasswordResponse> forgotPassword({required String email});
  Future<ResetPasswordResponse> resetPassword({required ResetPasswordParams resetPasswordParams});
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final DioClient dioClient;

  AuthRemoteDataSourceImpl(this.dioClient);
  
  @override
  Future<LoginUserResponse> login({required LoginParams loginParams}) async {
    try {
      final response = await dioClient.dio.post(
        ApiEndpoints.login,
        data: {
          "email": loginParams.email, 
          "password": loginParams.password
        },
        options: Options(
          method: 'POST',
        )
      );
      print("Login Response: ${response.data}");
      return LoginUserResponse.fromJson(response.data);
    } on DioException catch(e) {
      print("Error Data: ${e}");
      print("Error: ${e.response?.data}"); // Debugging
      final errorData = e.response?.data;
      final errorMessage = errorData?['errors']['message'] ?? "Login Failed";
      throw ServerFailure(errorData, errorMessage: errorMessage);
    }
  }
  
  @override
  Future<RegisterUserResponse> register({required RegisterParams registerParams}) async {
    try {
      final response = await dioClient.dio.post(
        ApiEndpoints.register,
        data: {
          "email": registerParams.email, 
          "password": registerParams.password
        },
        options: Options(
          method: 'POST',
        ),
      );
      return RegisterUserResponse.fromJson(response.data);
    } on DioException catch(e) {
      final errorData = e.response?.data;
      final errorMessage = errorData?["errors"]["msg"] ?? "Registration Failed";

      throw ServerFailure(errorData, errorMessage: errorMessage);
    }
  }
  
  @override
  Future<VerifyEmailResponse> verifyEmail({required String emailToken}) async {
    try {
      final response = await dioClient.dio.patch(
        ApiEndpoints.verifyEmail,
        data: {
          "emailToken": emailToken
        },
        options: Options(
          method: 'PATCH'
        )
      );

      if (response.statusCode == 200) {
        return VerifyEmailResponse.fromJson(response.data);
      } else {
        throw Exception("Failed to verify email");
      }
    } on DioException catch(e) {
      throw ServerFailure(e.response?.data, errorMessage: e.response?.data["message"] ?? "Verify Email Failed");
    }
  }
  
  @override
  Future<ForgotPasswordResponse> forgotPassword({required String email}) async {
    try {
      final response = await dioClient.dio.post(
        ApiEndpoints.forgotPassword,
        data: {
          "email": email
        },
        options: Options(
          method: 'POST'
        )
      );

      return ForgotPasswordResponse.fromJson(response.data);
    } on DioException catch(e) {
      throw ServerFailure(e.response?.data, errorMessage: e.response?.data['errors']['message'] ?? "Reset Password : Verify Email Failed");
    }
  }
  @override
  Future<ResetPasswordResponse> resetPassword({required ResetPasswordParams resetPasswordParams}) async {
    try {
      final response = await dioClient.dio.patch(
        ApiEndpoints.verifyEmail,
        data: {
          "resetToken": resetPasswordParams.resetToken,
          "password": resetPasswordParams.password,
          "confirmPassword": resetPasswordParams.confirmPassword,
        },
        options: Options(
          method: 'PATCH'
        )
      );

      if (response.statusCode == 200) {
        return ResetPasswordResponse.fromJson(response.data);
      } else {
        throw Exception("Failed to reset password");
      }
    } on DioException catch(e) {
      throw Exception(e.response?.data["message"] ?? "Reset Password Failed");
    }
  }

}