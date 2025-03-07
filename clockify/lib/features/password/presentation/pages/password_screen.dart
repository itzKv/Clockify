import 'package:clockify/core/themes/theme.dart';
import 'package:flutter/material.dart';

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

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Navigate to Main Screen'),),
        // Navigate to Timer Screen
      );
    }
  }
  
  @override
  Widget build(BuildContext context) {
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
            Container(
              height: 48,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: LinearGradient(
                  colors: [Color(0xff45CDDC), Color(0xff2EBED9)]
                )
              ),

              child: ElevatedButton(
                onPressed: () {
                  
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
            ),
            
            SizedBox(height: 40,),

            // Create new account
            TextButton(
              onPressed: () {

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
            )
          ],
        ),
      )
    );
  }
}