import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Logo
            SizedBox(
              height: 80,
              width: 260,
              child: Image.asset('assets/images/Logo.png'),
            ),

            const SizedBox(height: 40),

            // Email 
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
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
                            padding: EdgeInsets.only(bottom: 4),
                            child: Text(
                              "E-mail",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w700
                              ),
                            )
                          ),
                          TextFormField(
                            controller: _emailController,
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              labelText: "Input E-mail",
                              labelStyle: const TextStyle(color: Colors.grey),

                            ),
                          ),
                        ],
                      )
                    )
                  ],
                ),
                // Login Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      print("Loggin in: ${_emailController.text}");
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      )
                    ),
                    child: Text("SIGN IN", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700),)
                  ),
                ),

                // Create new account
                TextButton(
                  onPressed: () {
                    debugPrint("Navigating to Register Screen");
                  },
                  child: Text(
                    "Create new account?",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      decoration: TextDecoration.underline
                    ),
                  )
                )

              ],
            ),   
          ],
        ),
      )
    );
  }
}