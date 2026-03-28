import 'package:flutter/material.dart';

Future<bool> showDeleteConfirmationDialog({
  required BuildContext context,
  required String title,
  required String message,
  String confirmText = 'Supprimer',
  String cancelText = 'Annuler',
}) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(cancelText),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(confirmText),
          ),
        ],
      );
    },
  );

  return result ?? false;
}
