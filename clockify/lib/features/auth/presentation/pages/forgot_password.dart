import 'package:clockify/core/params/params.dart';
import 'package:clockify/core/presentation/widgets/success_dialog_alert.dart';
import 'package:clockify/core/themes/theme.dart';
import 'package:clockify/features/auth/presentation/providers/auth_provider.dart';
import 'package:clockify/features/home/presentation/pages/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _PasswordScreenState();
}

class _PasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required.';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Enter valid email.';
    }

    return null;
  }

  // Prevent memory leaks
  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }
  
  
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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

        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Title
                Padding(
                  padding: EdgeInsets.only(top: 33),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Forgotten Password",
                        style: TextStyle(
                          color: Color(0xff233971),
                          fontSize: 24,
                          fontWeight: FontWeight.w700
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 24),
                        child: Text(
                          "Please enter your email, and we'll send you a password reset link.\nDon't forget to check your spam folder!",
                          style: TextStyle(
                            color: Color(0xffA7A6C5),
                            fontSize: 12,
                            fontWeight: FontWeight.w400
                          ),
                        )
                      ),
                    ],
                  )
                ),

                SizedBox(height: 80,),

                // Password
                Form(
                  key: _formKey,
                  child: TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    validator: _validateEmail,
                    decoration: InputDecoration(
                      floatingLabelBehavior: FloatingLabelBehavior.auto,
                      floatingLabelStyle: TextStyle(
                        color: Color(0xff233971)
                      ),
                      labelText: "Input Your email",
                      labelStyle: TextStyle(
                        color: Color(0xffA7A6C5),
                        fontSize: 14,
                        fontWeight: FontWeight.w400
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xffA7A6C5), width: 2)
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
                                debugPrint("Email in Password Screen: ${_emailController.text}");


                                // Navigate to Timer Screen
                                authProvider.forgotPasswordUser(context, _emailController.text);
                              }
                            },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            )
                          ),
                        child: Text("RESET", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700),),
                      ),
                    );
                  }
                ),
                
                SizedBox(height: 40,),

              ],
            ),
          ),
        )
      ),
    );
  }
}