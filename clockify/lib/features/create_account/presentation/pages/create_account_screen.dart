import 'package:clockify/core/presentation/widgets/success_dialog_alert.dart';
import 'package:clockify/core/themes/theme.dart';
import 'package:clockify/features/timer/presentation/pages/timer_screen.dart';
import 'package:flutter/material.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _isObscure = true;

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

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Confirm Password is required';
    }
    if (value != _passwordController.text) {
      return 'Passwords do not match';
    }

    return null;
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Navigate to Main Screen'),),
      );
      // Navigate to Timer Screen
      _createAccountSuccess(context,);
    }
  }

  Route _createRouteForTimerScreen() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => TimerScreen(),
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

  void _createAccountSuccess(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false, 
    builder: (context) {
      Future.delayed(Duration(seconds: 3), () async {
        if (Navigator.canPop(context)) {
          Navigator.pop(context); // Close the dialog
          Navigator.push(context, _createRouteForTimerScreen());
        }
      });

      return SuccessDialog(
        title: "Success",
        message: "Your account has been successfully created.",
      );
    },
  );
}


  // Prevent memory leaks
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
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
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 33),
                      child: Text(
                        "Create New Account",
                        style: TextStyle(
                          color: Color(0xff233971),
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),

                    SizedBox(height: 72),

                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            validator: _validateEmail,
                            decoration: InputDecoration(
                              labelText: "Input Your E-mail",
                              labelStyle: TextStyle(color: Color(0xffA7A6C5), fontSize: 14),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Color(0xffA7A6C5), width: 2),
                              ),
                            ),
                          ),
                          
                          SizedBox(height: 32),
                          
                          // Password Input
                          TextFormField(
                            controller: _passwordController,
                            keyboardType: TextInputType.visiblePassword,
                            validator: _validatePassword,
                            obscureText: _isObscure,
                            decoration: InputDecoration(
                              labelText: "Input Your Password",
                              labelStyle: TextStyle(color: Color(0xffA7A6C5), fontSize: 14),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Color(0xffA7A6C5), width: 2),
                              ),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    _isObscure = !_isObscure;
                                  });
                                },
                                icon: Icon(
                                  _isObscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                                  color: Color(0xffA7A6C5),
                                ),
                              ),
                            ),
                          ),
                          
                          SizedBox(height: 32),
                          
                          // Confirm Password Input
                          TextFormField(
                            controller: _confirmPasswordController,
                            keyboardType: TextInputType.visiblePassword,
                            validator: _validateConfirmPassword,
                            obscureText: _isObscure,
                            decoration: InputDecoration(
                              labelText: "Confirm Your Password",
                              labelStyle: TextStyle(color: Color(0xffA7A6C5), fontSize: 14),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Color(0xffA7A6C5), width: 2),
                              ),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    _isObscure = !_isObscure;
                                  });
                                },
                                icon: Icon(
                                  _isObscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                                  color: Color(0xffA7A6C5),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 12,)
                  ],
                ),
              ),
            ),

            // Pushes the button to the bottom
            Padding(
              padding: EdgeInsets.all(20),
              child: Container(
                height: 48,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: LinearGradient(
                    colors: [Color(0xff45CDDC), Color(0xff2EBED9)],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromARGB(10, 0, 0, 0),
                      blurRadius: 10,
                      spreadRadius: 0,
                      offset: Offset(0.0, 2.0),
                    )
                  ]
                ),
                child: ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    "CREATE",
                    style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}