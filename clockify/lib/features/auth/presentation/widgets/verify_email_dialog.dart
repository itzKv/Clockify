import 'package:clockify/features/auth/presentation/pages/login_screen.dart';
import 'package:flutter/material.dart';

class VerifyEmailDialog {
  static void show(
    BuildContext context,
    String email,
    Future<void> Function(String) verifyEmail,
  ) {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent closing tanpa aksi
      builder: (context) {
        return AlertDialog(
          title: Text("Verify Your Email"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("A verification link has been sent to $email"),
              SizedBox(height: 8),
              Text("Please open your email and click the verification link."),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Tutup dialog
              },
              child: Text("OK"),
            ),
            TextButton(
              onPressed: () async {
                try {
                  await verifyEmail(email);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Verification email resent!")),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Verification failed. Try again.")),
                  );
                }
              },
              child: Text("Resend Email"),
            ),
            TextButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Please re-login after verifying.")),
                );
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
                Navigator.of(context).pop();
              },
              child: Text("I have verified"),
            ),
          ],
        );
      },
    );
  }
}
