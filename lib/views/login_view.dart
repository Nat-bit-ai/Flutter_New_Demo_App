import 'package:flutter/material.dart';
import 'package:flutter_app/constants/routes.dart';
import 'package:flutter_app/services/auth/auth_exceptions.dart';
import 'package:flutter_app/services/auth/auth_service.dart';
import 'package:flutter_app/utilities/error_dialog.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text('Login'),
    ),
    body: Column(
      children: [
        TextField(
          controller: _emailController,
          decoration: const InputDecoration( 
            labelText: 'Email',
          ),
          enableSuggestions: false,
          autocorrect: false,
        ),
        TextField(
          controller: _passwordController,
          decoration: const InputDecoration(
            labelText: 'Password',
          ),
          obscureText: true,
          enableSuggestions: false,
          autocorrect: false,
        ),
        TextButton(
          onPressed: () async {
            final email = _emailController.text;
            final password = _passwordController.text;
            try {
              await AuthService.firebase().logIn(
                email: email,
                password: password,
              );
              final user = AuthService.firebase().currentUser;
              if (user != null && !user.isEmailVerified) {
                Navigator.of(context).pushNamed(verifyEmailRoute);
              } else {
                if (!context.mounted) return;
                Navigator.of(context).pushNamedAndRemoveUntil(
                  homeRoute, 
                  (route) => false,
                );
              }
            } on UserNotFoundAuthException {
              await showErrorDialog(context, 'User not found');
            } on WrongPasswordAuthException {
              await showErrorDialog(context, 'Wrong password');
            } on InvalidEmailAuthException {
              await showErrorDialog(context, 'Invalid email');
            } on GenericAuthException catch (e) {
              await showErrorDialog(context, e.toString());
            }
          },
          child: const Text('Sign In'), // Fixed semicolon and comma positioning
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pushNamedAndRemoveUntil(
              registerRoute, 
              (route) => false,
            );
          },
          child: const Text('Not Registered yet? Register here!'),
        ),
      ],
    ),
  );
}
  
} // Added missing class closing brace
