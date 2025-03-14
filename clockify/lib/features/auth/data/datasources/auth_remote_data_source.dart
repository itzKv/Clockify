import 'package:clockify/core/errors/failure.dart';
import 'package:clockify/core/network/api_endpoints.dart';
import 'package:clockify/core/network/dio_client.dart';
import 'package:clockify/core/params/params.dart';
import 'package:clockify/features/auth/data/models/responses/login_user_response.dart';
import 'package:clockify/features/auth/data/models/responses/register_user_response.dart';
import 'package:clockify/features/auth/data/models/responses/verify_email_response.dart';
import 'package:dio/dio.dart';


abstract class AuthRemoteDataSource {
  Future<LoginUserResponse> login({required LoginParams loginParams});
  Future<RegisterUserResponse> register({required RegisterParams registerParams});
  Future<VerifyEmailResponse> verifyEmail({required String emailToken});
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
        data: {"emailToken": emailToken},
        options: Options(
          method: 'GET'
        )
      );

      if (response.statusCode == 200) {
        return VerifyEmailResponse.fromJson(response.data);
      } else {
        throw Exception("Failed to verify email");
      }
    } on DioException catch(e) {
      throw Exception(e.response?.data["message"] ?? "Verify Email Failed");
    }
  }
}