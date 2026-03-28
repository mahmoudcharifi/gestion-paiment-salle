import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class PaymentReceiptPdfViewPage extends StatelessWidget {
  final String filePath;

  const PaymentReceiptPdfViewPage({
    super.key,
    required this.filePath,
  });

  @override
  Widget build(BuildContext context) {
    final file = File(filePath);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reçu PDF'),
      ),
      body: file.existsSync()
          ? PDFView(
              filePath: filePath,
              enableSwipe: true,
              swipeHorizontal: false,
              autoSpacing: true,
              pageFling: true,
            )
          : const Center(
              child: Text('Fichier PDF introuvable'),
            ),
    );
  }
}