import 'package:flutter/material.dart';
import 'package:flutter_app/constants/routes.dart';
import 'package:flutter_app/services/auth/auth_service.dart';
import 'package:flutter_app/theme/gebeya_theme.dart';
import 'package:flutter_app/widgets/auth/auth_widgets.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
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
                icon: Icons.mark_email_read_outlined,
                eyebrow: 'One last step',
                headline: 'Verify your\nemail',
                subtitle:
                    "We've sent a verification link to your inbox. "
                    "Click it to activate your Gebeya account.",
                showBackButton: true,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 28, 24, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      "Didn't get the email? Check your spam folder, or send "
                      "a new one below.",
                      style: TextStyle(
                        color: GebeyaColors.textMuted,
                        fontSize: 13.5,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 24),
                    AuthPrimaryButton(
                      label: 'Send verification email',
                      icon: Icons.forward_to_inbox_rounded,
                      onPressed: () async {
                        await AuthService.firebase().sendEmailVerification();
                      },
                    ),
                    const SizedBox(height: 12),
                    AuthSecondaryButton(
                      label: 'Restart',
                      onPressed: () async {
                        await AuthService.firebase().logOut();
                        if (!context.mounted) return;
                        Navigator.of(context).pushNamedAndRemoveUntil(
                          registerRoute,
                          (_) => false,
                        );
                      },
                    ),
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
