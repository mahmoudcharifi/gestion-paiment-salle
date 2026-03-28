import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool loading;

  const AppButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: loading ? null : onPressed,
      icon: loading
          ? const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : Icon(icon ?? Icons.check),
      label: Text(text),
    );
  }
}