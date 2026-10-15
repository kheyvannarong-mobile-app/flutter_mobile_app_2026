import 'package:flutter/material.dart';

class BotanicalBackgroundWidget extends StatelessWidget {
  final Widget child;

  const BotanicalBackgroundWidget({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Base Ambient Gradient
        Positioned.fill(
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFFEAF3ED),
                  Color(0xFFE2EFE6),
                  Color(0xFFD6E7DC),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ),

        // Top-left soft diffuse botanical orb
        Positioned(
          top: -80,
          left: -60,
          width: 320,
          height: 320,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  const Color(0xFF9FC4A9).withValues(alpha: 0.35),
                  const Color(0xFFC3DDCB).withValues(alpha: 0.15),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),

        // Right ambient botanical leaf glow
        Positioned(
          top: 180,
          right: -80,
          width: 300,
          height: 340,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  const Color(0xFF86B894).withValues(alpha: 0.28),
                  const Color(0xFFBCE0C9).withValues(alpha: 0.1),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),

        // Bottom left soft glow
        Positioned(
          bottom: -60,
          left: -40,
          width: 280,
          height: 280,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  const Color(0xFFA5CFAF).withValues(alpha: 0.25),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),

        // Content
        child,
      ],
    );
  }
}
