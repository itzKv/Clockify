import 'dart:convert';
import 'dart:io';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:clockify/core/errors/failure.dart';
import 'package:clockify/core/params/params.dart';
import 'package:clockify/features/auth/business/usecases/login.dart';
import 'package:clockify/features/auth/business/usecases/register.dart';
import 'package:clockify/features/auth/business/usecases/verify_email.dart';
import 'package:clockify/features/auth/presentation/pages/login_screen.dart';
import 'package:clockify/features/auth/presentation/widgets/verify_email_dialog.dart';
import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  final Login login;
  final Register register;
  final VerifyEmail verifyEmail;

  AuthProvider({ required this.login, required this.register, required this.verifyEmail });

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> loginUser(LoginParams loginParams) async {
    _isLoading = true;
    notifyListeners();

    final result = await login.call(loginParams);
    result.fold(
      (failure) { 
        debugPrint("Login failed: ${failure.errorMessage}");
      },
      (user) {
        debugPrint("Login Success: ${user.email}");
      },
    );
    _isLoading = false;
    notifyListeners();
  }

  Future<void> registerUser(BuildContext context, RegisterParams registerParams) async {
    _isLoading = true;
    notifyListeners();
    final result = await register.call(registerParams);
    debugPrint("API Response: ${result.toString()}");
    result.fold(
      (failure) { 
        debugPrint("Register failed: ${failure.toString()}");
        debugPrint("Error Message: ${failure.errorMessage}");
        
        String errorMessage = "Registration Failed";

        if (failure is ServerFailure && failure.errorData != null) {
          debugPrint("Server error data: ${failure.errorData}");

          final errorJson = failure.errorData;

          if (errorJson.containsKey("errors")) {
            final errors = errorJson["errors"];
            debugPrint("Errors JSON: $errors");
            if (errors.containsKey("email")) {
              final emailsError = errors['email'];
              debugPrint("Errors Email: $emailsError");
              if (emailsError.containsKey("msg")) {
                errorMessage = emailsError["msg"];
                debugPrint("Errors Message: $errorMessage");
              }
            }
          }
        }

        // Check if the error is Registered Email
        if (errorMessage.contains("Email already exists")) {
          final snackBar = SnackBar(
            elevation: 0,
            duration: Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.transparent,
            content: AwesomeSnackbarContent(
              titleTextStyle: TextStyle(
                fontSize: 20,
              ),
              title: "Hello there", 
              message: "You already registered!", 
              contentType: ContentType.help
            ),
          );

          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(snackBar);

          Future.delayed(Duration(seconds: 2, microseconds: 600), () {
            // Navigate to Password Screen
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => LoginScreen())
            );
          });
        }


        _isLoading = false;
        notifyListeners();
      },
      (user) async {
        debugPrint("Register Success: ${user.email}");

        // Show the email verif dialog
        VerifyEmailDialog.show(
          context, 
          user.email, 
          verifyEmail
        );
      },
    );
  _isLoading = false;
    notifyListeners();
  }

  Future<void> verifyEmailUser(String emailToken) async {
    _isLoading = true;
    notifyListeners();

    final result = await verifyEmail.call(emailToken);
    result.fold(
      (failure) {
        debugPrint("Verify Email Failed: ${failure.errorMessage}");
      },
      (message) {
        debugPrint("Verify Email Success: $message");
      },
    );

    _isLoading = false;
    notifyListeners();
  }
}