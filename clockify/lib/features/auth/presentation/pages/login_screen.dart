import 'package:clockify/core/params/params.dart';
import 'package:clockify/features/auth/presentation/pages/create_account_screen.dart';
import 'package:clockify/features/auth/presentation/pages/password_screen.dart';
import 'package:clockify/features/auth/presentation/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Route _createRouteForCreateAccount() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => CreateAccountScreen(),
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
    }
  );
  }
  
  Route _createRouteForPasswordScreen() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => PasswordScreen(),
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
  
  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required.';
    }
    final emailRegex = RegExp(r'^[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,4}$');

    if (!emailRegex.hasMatch(value.toLowerCase())) {
      return 'Enter a valid email.';
    }

    return null;
  }
  
  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(height: 48,),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Padding(
                    padding: EdgeInsets.only(top: 80),
                    // Logo
                    child: SizedBox(
                      height: 80,
                      width: 260,
                      child: Image.asset('assets/images/Logo.png'),
                    ),
                  ),
                ),

                SizedBox(height: 320),

                Row(
                  children: [
                    SvgPicture.asset(
                      'assets/icons/email.svg',
                      width: 24,
                      colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 10, right: 10),
                            child: Form(
                              key: _formKey,
                              child: TextFormField(
                                controller: _emailController,
                                validator: _validateEmail,
                                keyboardType: TextInputType.emailAddress,
                                style: const TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                                  labelText: "Email",
                                  labelStyle: const TextStyle(
                                    color: Colors.white, 
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700
                                  ),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white, width: 2)
                                  )
                                ),
                              ),
                            )
                          )
                        ],
                      )
                    )
                  ],
                ),
                SizedBox(height: 48,),
                
                // Login Button
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
                            if (_formKey.currentState!.validate()) {
                              String email = _emailController.text.trim();

                              LoginParams loginParams = LoginParams(
                                email: email, 
                                password: "" // There is no password form in Login Screen, hence fill with empty string 
                              );

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
                        child: authProvider.isLoading 
                          ? CircularProgressIndicator(
                            color: Colors.white,
                          )
                          : Text(
                            "SIGN IN", 
                            style: TextStyle(
                              color: Colors.white, 
                              fontSize: 16, 
                              fontWeight: FontWeight.w700
                            ),
                          ),
                      ),
                    );
                  },
                ),

                SizedBox(height: 40,),

                // Create new account
                TextButton(
                  onPressed: () {
                    Navigator.push(context, _createRouteForCreateAccount());
                  },
                  child: Text(
                    "Create new account?",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      decoration: TextDecoration.underline,
                      decorationColor: Colors.white,
                    ),
                  )
                ),

                SizedBox(height: 20,),
              ],
            ),
          )
        ),
      )
    );
  }
}
