import 'package:clockify/core/params/params.dart';
import 'package:clockify/core/themes/theme.dart';
import 'package:clockify/features/auth/presentation/pages/forgot_password.dart';
import 'package:clockify/features/auth/presentation/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PasswordScreen extends StatefulWidget {
  const PasswordScreen({super.key});

  @override
  State<PasswordScreen> createState() => _PasswordScreenState();
}

class _PasswordScreenState extends State<PasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
  bool _isObscure = true;

  // Prevent memory leaks
  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required.';
    }
    if (value.length < 6 || value.length > 20) {
      return 'Password must be 6-20 characters.';
    }
    final regex = RegExp(r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[!@#$%^&*()_+{}:;<>,.?/~`\[\]\\-]).{6,20}$');
  
    if (!regex.hasMatch(value)) {
      return 'Password must contain 1 number and \n1 special character';
    }
    
    return null;
  }

  Route _createRouteForForgotPasswordScreen() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => ForgotPasswordScreen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;

        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
    );
  }
  
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final email = args?['email'] ?? "No email provided";
    return Scaffold(
      backgroundColor: appTheme.secondaryHeaderColor,
      appBar: AppBar(
        backgroundColor: appTheme.secondaryHeaderColor,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          }, 
          icon: Icon(Icons.arrow_back)
        ),
      ),

      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Title
            Padding(
              padding: EdgeInsets.only(top: 33),
              child: Text(
                "Password",
                style: TextStyle(
                  color: Color(0xff233971),
                  fontSize: 24,
                  fontWeight: FontWeight.w700
                ),
              ),
            ),

            SizedBox(height: 80,),

            // Password
            Form(
              key: _formKey,
              child: TextFormField(
                controller: _passwordController,
                obscureText: _isObscure,
                keyboardType: TextInputType.visiblePassword,
                validator: _validatePassword,
                decoration: InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                  floatingLabelStyle: TextStyle(
                    color: Color(0xff233971)
                  ),
                  labelText: "Input Your Password",
                  labelStyle: TextStyle(
                    color: Color(0xffA7A6C5),
                    fontSize: 14,
                    fontWeight: FontWeight.w400
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xffA7A6C5), width: 2)
                  ),
                  suffixIcon: 
                    // Icon Toggle
                    IconButton(
                      onPressed: () {
                        setState(() {
                          _isObscure = !_isObscure;
                        });
                      }, 
                      icon: Icon(_isObscure
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                        color: Color(0xffA7A6C5) , 
                      )
                  ),
                ),
              ),
            ),

            SizedBox(height: 40,),
            
            // Button
            Consumer<AuthProvider>(
              builder: (context, authProvider, child) {
                return Container(
                  height: 48,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: LinearGradient(
                      colors: [Color(0xff45CDDC), Color(0xff2EBED9)]
                    )
                  ),

                  child: ElevatedButton(
                    onPressed: authProvider.isLoading 
                      ? null
                      : () {
                          if (_formKey.currentState == null || !_formKey.currentState!.validate()) {
                            return; // Stop execution if formKey is null or validation fails
                          }

                          if (_formKey.currentState!.validate()) {
                            debugPrint("Email in Password Screen: $email");

                            LoginParams loginParams = LoginParams(
                              email: email, 
                              password: _passwordController.text,
                            );

                            // Navigate to Timer Screen
                            authProvider.loginUser(context, loginParams);
                          }
                        },
                       style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        )
                      ),
                    child: Text("OK", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700),),
                  ),
                );
              }
            ),
            
            SizedBox(height: 40,),

            // Create new account
            Consumer<AuthProvider>(
              builder: (context, authProvider, child) {
                return TextButton(
                  onPressed: () {
                    Navigator.of(context).push(_createRouteForForgotPasswordScreen());
                  },
                  child: Text(
                    "Forgot Password?",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xffA7A6C5),
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      decoration: TextDecoration.underline,
                      decorationColor: Color(0xffA7A6C5),
                    ),
                  )
                );
              },
            )
          ],
        ),
      )
    );
  }
}