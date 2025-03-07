import 'package:clockify/core/themes/theme.dart';
import 'package:flutter/material.dart';

class PasswordScreen extends StatefulWidget {
  const PasswordScreen({super.key});

  @override
  State<PasswordScreen> createState() => _PasswordScreenState();
}

class _PasswordScreenState extends State<PasswordScreen> {
  final TextEditingController _passwordController = TextEditingController();
  late bool _isObscure = true;
  
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
                  fontFamily: 'Nunito Sans',
                  color: Color(0xff233971),
                  fontSize: 24,
                  fontWeight: FontWeight.w700
                ),
              ),
            ),

            SizedBox(height: 80,),

            // Password
            TextFormField(
                controller: _passwordController,
                obscureText: _isObscure,
                decoration: InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                  labelText: "Input Your Password",
                  labelStyle: TextStyle(
                    color: Color(0xffA7A6C5),
                    fontFamily: 'Nunito Sans',
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
                onPressed: () {},
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
              onPressed: () {},
              child: Text(
                "Forgot Password?",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xffA7A6C5),
                  fontFamily: 'Nunito Sans',
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