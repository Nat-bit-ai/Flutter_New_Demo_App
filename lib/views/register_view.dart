import 'package:flutter/material.dart';
import 'package:flutter_app/constants/routes.dart';
import 'package:flutter_app/services/auth/auth_exceptions.dart';
import 'package:flutter_app/services/auth/auth_service.dart';

import 'package:flutter_app/utilities/error_dialog.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
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

  @override // Added @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: Column(
            children: [
              TextField( // Removed const
                controller: _emailController,
                decoration: const InputDecoration( 
                  labelText: 'Email',
                ),
                enableSuggestions: false,
                autocorrect: false,
                
              ),
              TextField( // Removed const
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
                  try{
                  await AuthService.firebase()
                        .createUser(
                      email: email,
                      password: password,
                    );
                    AuthService.firebase().sendEmailVerification();
                    Navigator.of(context).pushNamed(verifyEmailRoute);
                  } on  WeakPasswordAuthException {
                    await showErrorDialog(context, 'Weak password');
                  } on EmailAlreadyInUseAuthException {
                    await showErrorDialog(context, 'Email already in use');
                  } on InvalidEmailAuthException {
                    await showErrorDialog(context, 'Invalid email');
                  } on GenericAuthException 
                  catch (e) {
                    await showErrorDialog(context, e.toString());
                  }
                }, // Properly closed onPressed callback
                child: const Text('Register'),
              ),
              TextButton(onPressed: () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  loginRoute,
                   (route) => false);
              }, 
              child: const Text('already registered? Login here! ')),
            ],
          ),
    );
  }
} // Added missing class closing brace
