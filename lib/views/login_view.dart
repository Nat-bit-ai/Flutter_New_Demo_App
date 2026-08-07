import 'package:flutter/material.dart';
import 'package:flutter_app/constants/routes.dart';
import 'package:flutter_app/services/auth/auth_exceptions.dart';
import 'package:flutter_app/services/auth/auth_service.dart';
import 'package:flutter_app/theme/gebeya_theme.dart';
import 'package:flutter_app/utilities/error_dialog.dart';
import 'package:flutter_app/widgets/auth/auth_widgets.dart';

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

  Future<void> _signIn() async {
    final email = _emailController.text;
    final password = _passwordController.text;
    try {
      await AuthService.firebase().logIn(
        email: email,
        password: password,
      );
      final user = AuthService.firebase().currentUser;
      if (!context.mounted) return;
      if (user != null && !user.isEmailVerified) {
        Navigator.of(context).pushNamed(verifyEmailRoute);
      } else {
        Navigator.of(context).pushNamedAndRemoveUntil(
          homeRoute,
          (route) => false,
        );
      }
    } on UserNotFoundAuthException {
      if (!context.mounted) return;
      await showErrorDialog(context, 'User not found');
    } on WrongPasswordAuthException {
      if (!context.mounted) return;
      await showErrorDialog(context, 'Wrong password');
    } on InvalidEmailAuthException {
      if (!context.mounted) return;
      await showErrorDialog(context, 'Invalid email');
    } on GenericAuthException catch (e) {
      if (!context.mounted) return;
      await showErrorDialog(context, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GebeyaColors.cream,
      body: SafeArea(
        top: false,
        bottom: false,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const AuthHeroHeader(
                icon: Icons.storefront_rounded,
                eyebrow: 'Welcome back',
                headline: 'Sign in to\nGebeya',
                subtitle: 'Your cart and saved finds are waiting for you.',
                showIconBadge: false,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 28, 24, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AuthModeToggle(
                      leftLabel: 'Sign in',
                      rightLabel: 'Create account',
                      leftSelected: true,
                      onSelectLeft: () {},
                      onSelectRight: () {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                          registerRoute,
                          (route) => false,
                        );
                      },
                    ),
                    const SizedBox(height: 24),
                    AuthTextField(
                      label: 'Email address',
                      hint: 'you@example.com',
                      icon: Icons.mail_outline_rounded,
                      controller: _emailController,
                    ),
                    const SizedBox(height: 16),
                    AuthTextField(
                      label: 'Password',
                      hint: 'Enter your password',
                      icon: Icons.lock_outline_rounded,
                      controller: _passwordController,
                      obscureText: true,
                    ),
                    const SizedBox(height: 28),
                    AuthPrimaryButton(label: 'Sign in', onPressed: _signIn),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
