import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../firebase_options.dart';//

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
        title: const Text('Sign In'),
      ),
      body: FutureBuilder(
        future: Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        ),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return Column(
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
                  print(userCredential);
                } on FirebaseAuthException catch (e) {
                  if (e.code == 'user-not-found') {
                    print('User not found');
                  } 
                  if (e.code == 'wrong-password') {
                    print('Wrong password');
                  }
                }
              }, // Properly closed onPressed callback
              child: const Text('Sign In'),
            ),
          ],
        );
            default:
              return const Text('Loading...');
          }
        },
      ),
    );
  }
  
} // Added missing class closing brace
