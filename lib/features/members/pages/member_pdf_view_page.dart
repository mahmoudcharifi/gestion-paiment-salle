import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class MemberPdfViewPage extends StatelessWidget {
  final String filePath;

  const MemberPdfViewPage({
    super.key,
    required this.filePath,
  });

  @override
  Widget build(BuildContext context) {
    final file = File(filePath);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Aperçu PDF'),
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