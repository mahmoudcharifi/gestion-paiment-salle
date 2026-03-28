import 'package:flutter/material.dart';
import 'package:printing/printing.dart';

import '../../../data/repositories/member_repository.dart';
import '../services/member_pdf_service.dart';

class MemberPdfPreviewPage extends StatelessWidget {
  final MemberWithSports item;

  const MemberPdfPreviewPage({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Aperçu PDF'),
      ),
      body: PdfPreview(
        build: (format) async {
          return await MemberPdfService.generateMemberPdf(item);
        },
        canChangePageFormat: false,
        canChangeOrientation: false,
        canDebug: false,
        onError: (context, error) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                'Erreur PDF : $error',
                textAlign: TextAlign.center,
              ),
            ),
          );
        },
      ),
    );
  }
}