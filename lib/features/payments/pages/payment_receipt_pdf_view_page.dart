import 'dart:typed_data';

import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../../data/models/payment_model.dart';
import '../../../data/repositories/member_repository.dart';

class PaymentReceiptPdfService {
  static String _formatDate(String rawDate) {
    try {
      final date = DateTime.parse(rawDate);
      return DateFormat('dd/MM/yyyy').format(date);
    } catch (_) {
      return rawDate;
    }
  }

  static Future<Uint8List> generateReceiptPdf({
    required MemberWithSports memberItem,
    required PaymentModel payment,
  }) async {
    final member = memberItem.member;
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(24),
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Container(
                width: double.infinity,
                padding: const pw.EdgeInsets.all(18),
                decoration: pw.BoxDecoration(
                  color: PdfColors.red50,
                  borderRadius: pw.BorderRadius.circular(14),
                  border: pw.Border.all(color: PdfColors.red100),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'Reçu de paiement',
                      style: pw.TextStyle(
                        fontSize: 24,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.red900,
                      ),
                    ),
                    pw.SizedBox(height: 6),
                    pw.Text(
                      'Salle de sport - Gestion adhérent',
                      style: const pw.TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),

              pw.SizedBox(height: 24),

              pw.Text(
                'Adhérent',
                style: pw.TextStyle(
                  fontSize: 16,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 10),

              _infoRow(
                'Nom complet',
                '${member.firstName} ${member.lastName}',
              ),
              _infoRow(
                'Téléphone',
                member.phone.isEmpty ? '-' : member.phone,
              ),
              _infoRow(
                'CIN',
                (member.cin == null || member.cin!.trim().isEmpty)
                    ? '-'
                    : member.cin!,
              ),
              _infoRow(
                'Sports',
                memberItem.sports.isEmpty ? '-' : memberItem.sports.join(', '),
              ),

              pw.SizedBox(height: 20),

              pw.Text(
                'Paiement',
                style: pw.TextStyle(
                  fontSize: 16,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 10),

              _infoRow(
                'Montant',
                '${payment.amountPaid.toStringAsFixed(0)} DH',
              ),
              _infoRow(
                'Date de paiement',
                _formatDate(payment.paymentDate),
              ),
              _infoRow(
                'Début abonnement',
                _formatDate(payment.startDate),
              ),
              _infoRow(
                'Fin abonnement',
                _formatDate(payment.endDate),
              ),
              _infoRow(
                'Statut',
                payment.status,
              ),
              _infoRow(
                'Méthode',
                payment.paymentMethod,
              ),

              pw.SizedBox(height: 20),

              pw.Text(
                'QR adhérent',
                style: pw.TextStyle(
                  fontSize: 16,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 10),

              pw.Center(
                child: pw.BarcodeWidget(
                  barcode: pw.Barcode.qrCode(),
                  data: member.qrCode,
                  width: 120,
                  height: 120,
                ),
              ),
              pw.SizedBox(height: 8),
              pw.Center(
                child: pw.Text(member.qrCode),
              ),

              pw.SizedBox(height: 20),

              pw.Text(
                'Note',
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
                  border: pw.Border.all(color: PdfColors.grey300),
                  borderRadius: pw.BorderRadius.circular(10),
                ),
                child: pw.Text(
                  (payment.note == null || payment.note!.trim().isEmpty)
                      ? 'Aucune note'
                      : payment.note!,
                ),
              ),

              pw.Spacer(),

              pw.Divider(),
              pw.SizedBox(height: 8),
              pw.Text(
                'Document généré automatiquement par l’application.',
                style: const pw.TextStyle(
                  fontSize: 10,
                  color: PdfColors.grey700,
                ),
              ),
            ],
          );
        },
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
            width: 130,
            child: pw.Text(
              label,
              style: pw.TextStyle(
                fontWeight: pw.FontWeight.bold,
              ),
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