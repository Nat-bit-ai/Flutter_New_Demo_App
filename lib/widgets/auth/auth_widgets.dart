import 'package:flutter/material.dart';
import 'package:flutter_app/theme/gebeya_theme.dart';

/// The dark brand header shown at the top of every auth screen: a logo
/// badge, an eyebrow label, a headline, and a short supporting line.
class AuthHeroHeader extends StatelessWidget {
  final IconData icon;
  final String eyebrow;
  final String headline;
  final String subtitle;

  const AuthHeroHeader({
    super.key,
    required this.icon,
    required this.eyebrow,
    required this.headline,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(32),
        bottomRight: Radius.circular(32),
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(28, 60, 28, 40),
        color: GebeyaColors.ink,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // Purely decorative ambient glow behind the wordmark.
            Positioned(
              top: -70,
              right: -50,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      GebeyaColors.orange.withOpacity(0.30),
                      GebeyaColors.orange.withOpacity(0.0),
                    ],
                  ),
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: GebeyaColors.orange,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.storefront_rounded,
                        color: GebeyaColors.ink,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      'GEBEYA',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 2.4,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 36),
                Container(
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                    color: GebeyaColors.inkSoft,
                    shape: BoxShape.circle,
                    border: Border.all(color: GebeyaColors.orange, width: 1.4),
                  ),
                  child: Icon(icon, color: GebeyaColors.orange, size: 24),
                ),
                const SizedBox(height: 20),
                Text(
                  eyebrow.toUpperCase(),
                  style: const TextStyle(
                    color: GebeyaColors.orange,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.6,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  headline,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 27,
                    fontWeight: FontWeight.w800,
                    height: 1.15,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: GebeyaColors.textMutedOnInk,
                    fontSize: 13.5,
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// A two-segment pill used to move between the sign-in and create-account
/// screens. Purely a restyled, combined version of the plain text links the
/// original screens used - it navigates via the same routes, nothing new.
class AuthModeToggle extends StatelessWidget {
  final String leftLabel;
  final String rightLabel;
  final bool leftSelected;
  final VoidCallback onSelectLeft;
  final VoidCallback onSelectRight;

  const AuthModeToggle({
    super.key,
    required this.leftLabel,
    required this.rightLabel,
    required this.leftSelected,
    required this.onSelectLeft,
    required this.onSelectRight,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: GebeyaColors.creamSoft,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(child: _segment(leftLabel, leftSelected, onSelectLeft)),
          Expanded(child: _segment(rightLabel, !leftSelected, onSelectRight)),
        ],
      ),
    );
  }

  Widget _segment(String label, bool selected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(vertical: 11),
        decoration: BoxDecoration(
          color: selected ? GebeyaColors.ink : Colors.transparent,
          borderRadius: BorderRadius.circular(9),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : GebeyaColors.textMuted,
            fontWeight: FontWeight.w700,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}

/// A labeled, icon-prefixed text field styled to match the brand form card.
class AuthTextField extends StatelessWidget {
  final String label;
  final String hint;
  final IconData icon;
  final TextEditingController controller;
  final bool obscureText;

  const AuthTextField({
    super.key,
    required this.label,
    required this.hint,
    required this.icon,
    required this.controller,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: const TextStyle(
            color: GebeyaColors.textMuted,
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.1,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: GebeyaColors.creamSoft,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: GebeyaColors.creamBorder),
          ),
          child: TextField(
            controller: controller,
            obscureText: obscureText,
            enableSuggestions: false,
            autocorrect: false,
            style: const TextStyle(color: GebeyaColors.ink, fontSize: 14),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(color: Color(0xFFB2A796)),
              prefixIcon: Icon(icon, color: GebeyaColors.textMuted, size: 20),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 14),
            ),
          ),
        ),
      ],
    );
  }
}

/// The solid black/orange call-to-action button used on every auth screen.
class AuthPrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final IconData? icon;

  const AuthPrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon = Icons.arrow_forward_rounded,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: GebeyaColors.ink,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(label, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
            if (icon != null) ...[
              const SizedBox(width: 8),
              Icon(icon, size: 17, color: GebeyaColors.orange),
            ],
          ],
        ),
      ),
    );
  }
}

/// A quieter outlined button, used for secondary actions like "Restart".
class AuthSecondaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const AuthSecondaryButton({super.key, required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: GebeyaColors.ink,
          side: const BorderSide(color: GebeyaColors.creamBorder, width: 1.4),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: Text(label, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
      ),
    );
  }
}
