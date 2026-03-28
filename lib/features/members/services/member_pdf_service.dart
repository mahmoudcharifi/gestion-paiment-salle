import 'dart:typed_data';

import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../../data/repositories/member_repository.dart';

class MemberPdfService {
  static String _formatDate(String rawDate) {
    try {
      final date = DateTime.parse(rawDate);
      return DateFormat('dd/MM/yyyy').format(date);
    } catch (_) {
      return rawDate;
    }
  }

  static Future<Uint8List> generateMemberPdf(MemberWithSports item) async {
    final member = item.member;
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(24),
        build: (context) => [
          pw.Text(
            'Fiche adhérent',
            style: pw.TextStyle(
              fontSize: 24,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 20),

          pw.Container(
            padding: const pw.EdgeInsets.all(16),
            decoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColors.grey400),
              borderRadius: pw.BorderRadius.circular(12),
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  '${member.firstName} ${member.lastName}',
                  style: pw.TextStyle(
                    fontSize: 20,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 8),
                pw.Text('Statut : Actif'),
                pw.SizedBox(height: 8),
                pw.Text(
                  'Sports : ${item.sports.isEmpty ? "-" : item.sports.join(", ")}',
                ),
              ],
            ),
          ),

          pw.SizedBox(height: 20),

          pw.Text(
            'Informations personnelles',
            style: pw.TextStyle(
              fontSize: 16,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 10),

          _infoRow('Téléphone', member.phone.isEmpty ? '-' : member.phone),
          _infoRow(
            'CIN',
            (member.cin == null || member.cin!.trim().isEmpty)
                ? '-'
                : member.cin!,
          ),
          _infoRow('Code QR', member.qrCode),
          _infoRow('Date d’inscription', _formatDate(member.registrationDate)),

          pw.SizedBox(height: 24),

          pw.Text(
            'QR Code',
            style: pw.TextStyle(
              fontSize: 16,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 12),

          pw.Center(
            child: pw.BarcodeWidget(
              barcode: pw.Barcode.qrCode(),
              data: member.qrCode,
              width: 140,
              height: 140,
            ),
          ),

          pw.SizedBox(height: 12),

          pw.Center(
            child: pw.Text(
              member.qrCode,
              style: pw.TextStyle(fontSize: 12),
            ),
          ),

          pw.SizedBox(height: 24),

          pw.Text(
            'Notes',
            style: pw.TextStyle(
              fontSize: 16,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 10),

          pw.Container(
            width: double.infinity,
            padding: const pw.EdgeInsets.all(12),
            decoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColors.grey400),
              borderRadius: pw.BorderRadius.circular(10),
            ),
            child: pw.Text(
              (member.notes == null || member.notes!.trim().isEmpty)
                  ? 'Aucune note'
                  : member.notes!,
            ),
          ),
        ],
      ),
    );

    return pdf.save();
  }

  static pw.Widget _infoRow(String label, String value) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 8),
      padding: const pw.EdgeInsets.all(10),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey300),
        borderRadius: pw.BorderRadius.circular(8),
      ),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.SizedBox(
            width: 120,
            child: pw.Text(
              label,
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            ),
          ),
          pw.Expanded(
            child: pw.Text(value),
          ),
        ],
      ),
    );
  }
}