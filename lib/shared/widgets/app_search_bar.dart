import 'package:flutter/material.dart';

class AppSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final String hint;

  const AppSearchBar({
    super.key,
    required this.controller,
    required this.onChanged,
    this.hint = 'Rechercher...',
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: const Icon(Icons.search_rounded),
      ),
    );
  }
}