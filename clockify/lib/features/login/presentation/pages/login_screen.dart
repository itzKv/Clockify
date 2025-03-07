import 'package:clockify/features/password/presentation/pages/password_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();

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
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 80),
              // Logo
              child: SizedBox(
                height: 80,
                width: 260,
                child: Image.asset('assets/images/Logo.png'),
              ),
            ),

            const SizedBox(height: 100),

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
                          // Padding(
                          //   padding: EdgeInsets.only(bottom: 4),
                          //   child: Text(
                          //     "E-mail",
                          //     style: TextStyle(
                          //       color: Colors.white,
                          //       fontSize: 14,
                          //       fontWeight: FontWeight.w700
                          //     ),
                          //   )
                          // ),
                          Padding(
                            padding: EdgeInsets.only(left: 10, right: 10),
                            child: TextFormField(
                              controller: _emailController,
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
                        ],
                      )
                    )
                  ],
                ),
                SizedBox(height: 40,),
                
                // Login Button
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
                      Navigator.push(context, _createRouteForPasswordScreen());
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      )
                    ),
                    child: Text("SIGN IN", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700),),
                  ),
                ),

                SizedBox(height: 40,),

                // Create new account
                TextButton(
                  onPressed: () {
                    debugPrint("Navigating to Register Screen");
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

                SizedBox(height: 40,),
              ],
            ),   
          ],
        ),
      )
    );
  }
}