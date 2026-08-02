import 'package:flutter/material.dart';
import 'package:flutter_app/constants/routes.dart';
import 'package:flutter_app/services/auth/auth_service.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify Email'),
      ),
      body: Column(
          children: [
            const Text("We've sent you an email verification. Please check your email and click on the verification link."),
            const Text('if you haven\'t received it, click the button below.'),
            TextButton(
              onPressed: () async {
                await AuthService.firebase().sendEmailVerification();
              },
                
              child: const Text('Send Verification Email'),
            ),
            TextButton(
              onPressed: () async {
                await AuthService.firebase().logOut();
                Navigator.of(context).pushNamedAndRemoveUntil(registerRoute, (_) => false);
              },
              child: const Text('Restart'),
            ),
          ],
        ),
    );
  }
}
