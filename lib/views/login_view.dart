import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:developer' as devtools show log;

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

  @override // Added @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
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
                    final userCredential = await FirebaseAuth.instance
                        .signInWithEmailAndPassword(
                      email: email,
                      password: password,
                    );
                    Navigator.of(context).pushNamedAndRemoveUntil('/home', (route) => false);
                  } on FirebaseAuthException catch (e) {
  if (e.code == 'user-not-found') {
    devtools.log('User not found');
  } else if (e.code == 'wrong-password') {
    devtools.log('Wrong password');
  } else if (e.code == 'invalid-credential') {
    // Newer Firebase Auth versions return this generic code
    // for both wrong password and unregistered email, to
    // avoid leaking which emails are registered.
    devtools.log('Incorrect email or password');
  } else {
    devtools.log('An unknown error occurred: ${e.code}');
  }
}
                }, // Properly closed onPressed callback
                child: const Text('Sign In'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushNamedAndRemoveUntil('/register/', (route) => false);
                },
                child: const Text('Not Registered yet? Register here! '),
              ),
            ],
          ),
    );
  }
  
} // Added missing class closing brace
