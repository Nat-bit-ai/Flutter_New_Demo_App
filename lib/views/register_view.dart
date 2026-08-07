import 'package:flutter/material.dart';
import 'package:flutter_app/constants/routes.dart';
import 'package:flutter_app/services/auth/auth_exceptions.dart';
import 'package:flutter_app/services/auth/auth_service.dart';
import 'package:flutter_app/theme/gebeya_theme.dart';
import 'package:flutter_app/utilities/error_dialog.dart';
import 'package:flutter_app/widgets/auth/auth_widgets.dart';

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

  Future<void> _register() async {
    final email = _emailController.text;
    final password = _passwordController.text;
    try {
      await AuthService.firebase().createUser(
        email: email,
        password: password,
      );
      AuthService.firebase().sendEmailVerification();
      if (!context.mounted) return;
      Navigator.of(context).pushNamed(verifyEmailRoute);
    } on WeakPasswordAuthException {
      await showErrorDialog(context, 'Weak password');
    } on EmailAlreadyInUseAuthException {
      await showErrorDialog(context, 'Email already in use');
    } on InvalidEmailAuthException {
      await showErrorDialog(context, 'Invalid email');
    } on GenericAuthException catch (e) {
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
                eyebrow: 'Join Gebeya',
                headline: 'Create your\naccount',
                subtitle: 'Save favorites, track orders, and check out faster.',
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 28, 24, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AuthModeToggle(
                      leftLabel: 'Sign in',
                      rightLabel: 'Create account',
                      leftSelected: false,
                      onSelectLeft: () {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                          loginRoute,
                          (route) => false,
                        );
                      },
                      onSelectRight: () {},
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
                      hint: 'Create a password',
                      icon: Icons.lock_outline_rounded,
                      controller: _passwordController,
                      obscureText: true,
                    ),
                    const SizedBox(height: 28),
                    AuthPrimaryButton(label: 'Create account', onPressed: _register),
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
