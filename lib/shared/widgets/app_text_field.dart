import 'package:flutter/material.dart';

class AppTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? hint;
  final int maxLines;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final Widget? prefixIcon;

  const AppTextField({
    super.key,
    required this.controller,
    required this.label,
    this.hint,
    this.maxLines = 1,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.prefixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      maxLines: maxLines,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: prefixIcon,
      ),
    );
  }
}