import 'package:flutter/material.dart';
import 'package:flutter_mobile_app_2026/constants/app_colors.dart';

class ButtonCustomWidget extends StatelessWidget {
  final VoidCallback? onPressed;
  final String? label;
  final Color? backgroundColor;
  final Color? textColor;
  final bool loading;
  final IconData? icon;

  const ButtonCustomWidget({
    super.key,
    this.onPressed,
    this.label,
    this.backgroundColor,
    this.textColor,
    this.loading = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveBg = backgroundColor ?? AppColors.primary;
    final effectiveFg = textColor ?? (effectiveBg == AppColors.primary ? AppColors.textDark : Colors.white);

    return ElevatedButton(
      onPressed: loading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: effectiveBg,
        foregroundColor: effectiveFg,
        disabledBackgroundColor: effectiveBg.withValues(alpha: 0.5),
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        elevation: 3,
        shadowColor: effectiveBg.withValues(alpha: 0.4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
      ),
      child: loading
          ? SizedBox(
              height: 22,
              width: 22,
              child: CircularProgressIndicator(
                color: effectiveFg,
                strokeWidth: 2.5,
              ),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null) ...[
                  Icon(icon, size: 20, color: effectiveFg),
                  const SizedBox(width: 8),
                ],
                Text(
                  label ?? '',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.4,
                    color: effectiveFg,
                  ),
                ),
              ],
            ),
    );
  }
}