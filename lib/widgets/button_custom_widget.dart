import 'package:flutter/material.dart';

class ButtonCustomWidget extends StatelessWidget {
  final VoidCallback? onPressed;
  final String? label;
  final Color? backgroundColor;
  final bool loading;

  const ButtonCustomWidget({
    super.key,
    this.onPressed,
    this.label,
    this.backgroundColor,
    this.loading = false, // បញ្ចូល loading មកក្នុង Constructor
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      // បើកំពុង loading ប៊ូតុងមិនឲ្យចុចទេ, បើអត់ទេ ប្រើប្រាស់ onPressed ដែលបានបោះមកពី View
      onPressed: loading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor ?? Colors.cyan,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
      ),
      child: loading
          ? const SizedBox(
        height: 24,
        width: 24,
        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
      )
          : Text(
        label ?? '',
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}