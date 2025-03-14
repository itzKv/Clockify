import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:clockify/core/errors/failure.dart';
import 'package:clockify/core/params/params.dart';
import 'package:clockify/core/presentation/widgets/success_dialog_alert.dart';
import 'package:clockify/features/auth/business/usecases/login.dart';
import 'package:clockify/features/auth/business/usecases/register.dart';
import 'package:clockify/features/auth/business/usecases/verify_email.dart';
import 'package:clockify/features/auth/presentation/pages/login_screen.dart';
import 'package:clockify/features/auth/presentation/widgets/verify_email_dialog.dart';
import 'package:clockify/features/home/presentation/pages/home_screen.dart';
import 'package:clockify/features/session/data/models/session_model.dart';
import 'package:clockify/features/session/presentation/providers/session_provider.dart';
import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  final Login login;
  final Register register;
  final VerifyEmail verifyEmail;
  final SessionProvider sessionProvider;

  AuthProvider({ required this.login, required this.register, required this.verifyEmail, required this.sessionProvider });

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool get isAuthenticated => sessionProvider.isAuthenticated;

  Future<bool> loginUser(BuildContext context, LoginParams loginParams) async {
    _isLoading = true;
    notifyListeners();

    final result = await login.call(loginParams);
    print("Result : ${result}");
    result.fold(
      (failure) { 
        print("failure: ${failure.errorMessage}");   
        if (failure is ServerFailure && failure.errorData != null) {
          // final errorJson = failure.errorMessage;
          debugPrint("Error JSON: ${failure.errorData}");
          debugPrint("Error ms: ${failure.errorMessage}");

          if (failure.errorMessage.contains("Account Invalid!, please sign up")) {
            final snackBar = SnackBar(
              elevation: 0,
              duration: Duration(seconds: 3, microseconds: 300),
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.transparent,
              content: AwesomeSnackbarContent(
                title: "Oops! Account Not Found", 
                titleTextStyle: TextStyle(
                  fontSize: 13,
                  color: Colors.white,
                  fontWeight: FontWeight.w700
                ),
                message: "Your account doesn't exist. Please create one.", 
                messageTextStyle: TextStyle(
                  fontSize: 10,
                  color: Colors.white,
                  fontWeight: FontWeight.w400
                ),
                contentType: ContentType.failure
              ),
            );

            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(snackBar);
          }
          else if (failure.errorMessage.contains("Account need to be verified!")) {
            final snackBar = SnackBar(
              elevation: 0,
              duration: Duration(seconds: 3, microseconds: 300),
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.transparent,
              content: AwesomeSnackbarContent(
                title: "Email Not Verified", 
                titleTextStyle: TextStyle(
                  fontSize: 13,
                  color: Colors.white,
                  fontWeight: FontWeight.w700
                ),
                message: "Please check your inbox and verify your email to continue.", 
                messageTextStyle: TextStyle(
                  fontSize: 10,
                  color: Colors.white,
                  fontWeight: FontWeight.w400
                ),
                contentType: ContentType.warning
              ),
            );

            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(snackBar);
          }
          else if (failure.errorMessage.contains("Wrong password!")) {
            final snackBar = SnackBar(
              elevation: 0,
              duration: Duration(seconds: 3, microseconds: 300),
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.transparent,
              content: AwesomeSnackbarContent(
                title: "Incorrect Password", 
                titleTextStyle: TextStyle(
                  fontSize: 13,
                  color: Colors.white,
                  fontWeight: FontWeight.w700
                ),
                message: "The password you entered is incorrect.\nPlease check and try again.", 
                messageTextStyle: TextStyle(
                  fontSize: 10,
                  color: Colors.white,
                  fontWeight: FontWeight.w400
                ),
                contentType: ContentType.failure
              ),
            );

            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(snackBar);
          }
        }
      },
      (result) {
        debugPrint("Login Success: ${result.user}");
        debugPrint("Login Success Msg: ${result.message}");

        if (result.message.contains("Please enter your password")) {
          final snackBar = SnackBar(
            elevation: 0,
            duration: Duration(seconds: 3, microseconds: 300),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.transparent,
            content: AwesomeSnackbarContent(
              title: "Hi there", 
              titleTextStyle: TextStyle(
                fontSize: 13,
                color: Colors.white,
                fontWeight: FontWeight.w700
              ),
              message: result.message, // Show actual error message
              messageTextStyle: TextStyle(
                fontSize: 10,
                color: Colors.white,
                fontWeight: FontWeight.w400
              ),
              contentType: ContentType.success,
            ),
          );

          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(snackBar);

          // Navigate to fill Password
          Future.delayed(Duration(seconds: 2, microseconds: 600), () {
            Navigator.pushNamed(
              context,
              '/password',
              arguments: {'email': result.user.email},
            );
          });   
        }
        else if (result.message.contains("User logged in")) {
          try {
            // Parse expiry time
            final expiryDate = DateTime.now().add(Duration(days: 1, hours: 12));

            final session = SessionModel(
              token: result.token, 
              userId: result.user.uuid, 
              expiryDate: expiryDate,
            );

            // save session
            sessionProvider.saveSession(session);
            sessionProvider.getSession();
          } catch (e) {
            return false;
          }

          // Show success dialog
          showDialog(
            context: context, 
            barrierDismissible: false,
            builder: (context) => SuccessDialog(
              title: "Hi 👋", 
              message: "Welcome back"
            )
          );

          Future.delayed(Duration(seconds: 2, microseconds: 600), () {
            if (context.mounted) {
              Navigator.pop(context); // Pop dialog
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => HomeScreen())
              );
            }
          });
        } else {
          final snackBar = SnackBar(
            elevation: 0,
            duration: Duration(seconds: 3, microseconds: 300),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.transparent,
            content: AwesomeSnackbarContent(
              title: "Login Failed", 
              titleTextStyle: TextStyle(
                fontSize: 13,
                color: Colors.white,
                fontWeight: FontWeight.w700
              ),
              message: result.message, // Show actual error message
              messageTextStyle: TextStyle(
                fontSize: 10,
                color: Colors.white,
                fontWeight: FontWeight.w400
              ),
              contentType: ContentType.failure,
            ),
          );

          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(snackBar);
        }
      },
    );

    _isLoading = false;
    notifyListeners();
    return true;
  }

  Future<void> registerUser(BuildContext context, RegisterParams registerParams) async {
    _isLoading = true;
    notifyListeners();
    final result = await register.call(registerParams);
    debugPrint("API Response: ${result.toString()}");
    result.fold(
      (failure) { 
        String errorMessage = "Registration Failed";

        if (failure is ServerFailure && failure.errorData != null) {
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