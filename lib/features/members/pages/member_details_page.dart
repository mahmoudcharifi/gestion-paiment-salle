import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/constants/app_spacing.dart';
import '../../../core/services/image_picker_service.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/models/payment_model.dart';
import '../../../data/repositories/member_repository.dart';
import '../../../shared/widgets/delete_confirmation_dialog.dart';
import '../../../shared/widgets/info_tile.dart';
import '../../../shared/widgets/section_title.dart';
import '../../../shared/widgets/sport_chip.dart';
import '../../../shared/widgets/status_badge.dart';
import '../../payments/controllers/payments_controller.dart';
import '../../payments/pages/add_payment_page.dart';
import '../../payments/pages/payment_receipt_pdf_view_page.dart';
import '../../payments/services/payment_receipt_pdf_service.dart';
import '../controllers/members_controller.dart';
import '../services/member_pdf_service.dart';
import 'edit_member_page.dart';
import 'member_pdf_view_page.dart';

class MemberDetailsPage extends StatefulWidget {
  final MemberWithSports item;

  const MemberDetailsPage({
    super.key,
    required this.item,
  });

  @override
  State<MemberDetailsPage> createState() => _MemberDetailsPageState();
}

class _MemberDetailsPageState extends State<MemberDetailsPage> {
  String _formatDate(String rawDate) {
    try {
      final date = DateTime.parse(rawDate);
      return DateFormat('dd/MM/yyyy').format(date);
    } catch (_) {
      return rawDate;
    }
  }

  Future<void> _previewPaymentReceipt(PaymentModel payment) async {
    try {
      final pdfData = await PaymentReceiptPdfService.generateReceiptPdf(
        memberItem: widget.item,
        payment: payment,
      );

      final dir = await getTemporaryDirectory();
      final file = File(
        '${dir.path}/recu_${widget.item.member.qrCode}_${payment.id}.pdf',
      );

      await file.writeAsBytes(pdfData, flush: true);

      if (!mounted) return;

      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => PaymentReceiptPdfViewPage(filePath: file.path),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur lors de la création du reçu : $e'),
        ),
      );
    }
  }

  Future<void> _sharePaymentReceipt(PaymentModel payment) async {
    try {
      final pdfData = await PaymentReceiptPdfService.generateReceiptPdf(
        memberItem: widget.item,
        payment: payment,
      );

      final dir = await getTemporaryDirectory();
      final file = File(
        '${dir.path}/recu_${widget.item.member.qrCode}_${payment.id}.pdf',
      );

      await file.writeAsBytes(pdfData, flush: true);

      await Share.shareXFiles(
        [XFile(file.path)],
        text: 'Reçu de paiement',
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur lors du partage du reçu : $e'),
        ),
      );
    }
  }

  Future<void> _previewPdf(BuildContext context) async {
    try {
      final pdfData = await MemberPdfService.generateMemberPdf(widget.item);
      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/${widget.item.member.qrCode}.pdf');

      await file.writeAsBytes(pdfData, flush: true);

      if (!context.mounted) return;

      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => MemberPdfViewPage(filePath: file.path),
        ),
      );
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur lors de la création du PDF : $e'),
        ),
      );
    }
  }

  Future<void> _sharePdf(BuildContext context) async {
    try {
      final pdfData = await MemberPdfService.generateMemberPdf(widget.item);
      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/${widget.item.member.qrCode}.pdf');

      await file.writeAsBytes(pdfData, flush: true);

      await Share.shareXFiles(
        [XFile(file.path)],
        text: 'Fiche adhérent',
      );
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur lors du partage du PDF : $e'),
        ),
      );
    }
  }

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'payé':
        return Colors.green;
      case 'en retard':
        return Colors.orange;
      case 'partiel':
        return Colors.red;
      default:
        return Colors.blue;
    }
  }

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context
          .read<PaymentsController>()
          .loadMemberPayments(widget.item.member.id!);
    });
  }

  @override
  Widget build(BuildContext context) {
    final member = widget.item.member;
    final theme = Theme.of(context);
    final paymentsController = context.watch<PaymentsController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Détail adhérent'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: LinearGradient(
                  colors: [
                    theme.colorScheme.primary.withValues(alpha: 0.12),
                    theme.cardColor,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                border: Border.all(
                  color: theme.dividerColor.withValues(alpha: 0.20),
                ),
              ),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () async {
                      final imagePath =
                          await ImagePickerService.pickImageFromGallery();
                      if (imagePath == null) return;

                      await context
                          .read<MembersController>()
                          .updateMemberPhoto(member.id!, imagePath);

                      if (!context.mounted) return;

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Photo de profil mise à jour'),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color:
                              theme.colorScheme.primary.withValues(alpha: 0.25),
                          width: 2,
                        ),
                      ),
                      child: CircleAvatar(
                        radius: 42,
                        backgroundColor:
                            theme.colorScheme.primary.withValues(alpha: 0.12),
                        backgroundImage: member.photoPath != null &&
                                member.photoPath!.trim().isNotEmpty
                            ? FileImage(File(member.photoPath!))
                            : null,
                        child: (member.photoPath == null ||
                                member.photoPath!.trim().isEmpty)
                            ? Text(
                                member.firstName.isNotEmpty
                                    ? member.firstName[0].toUpperCase()
                                    : '?',
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: theme.colorScheme.primary,
                                ),
                              )
                            : null,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    '${member.firstName} ${member.lastName}',
                    style: AppTextStyles.pageTitle,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  const StatusBadge(
                    text: 'Actif',
                    type: StatusType.success,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  if (widget.item.sports.isNotEmpty)
                    Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 8,
                      runSpacing: 8,
                      children: widget.item.sports
                          .map((sport) => SportChip(label: sport))
                          .toList(),
                    ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.xl),
            const SectionTitle(title: 'Informations personnelles'),
            const SizedBox(height: AppSpacing.md),

            InfoTile(
              icon: Icons.phone_rounded,
              label: 'Téléphone',
              value: member.phone.isEmpty ? '-' : member.phone,
            ),
            const SizedBox(height: AppSpacing.md),

            InfoTile(
              icon: Icons.badge_rounded,
              label: 'CIN',
              value: (member.cin == null || member.cin!.trim().isEmpty)
                  ? '-'
                  : member.cin!,
            ),
            const SizedBox(height: AppSpacing.md),

            InfoTile(
              icon: Icons.calendar_month_rounded,
              label: 'Date d’inscription',
              value: _formatDate(member.registrationDate),
            ),

            const SizedBox(height: AppSpacing.xl),
            const SectionTitle(title: 'QR Code adhérent'),
            const SizedBox(height: AppSpacing.md),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: QrImageView(
                        data: member.qrCode,
                        version: QrVersions.auto,
                        size: 180,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      member.qrCode,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      'Ce code peut être scanné pour afficher rapidement le profil de l’adhérent.',
                      style: theme.textTheme.bodySmall,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: AppSpacing.xl),
            const SectionTitle(title: 'Notes'),
            const SizedBox(height: AppSpacing.md),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Text(
                  (member.notes == null || member.notes!.trim().isEmpty)
                      ? 'Aucune note'
                      : member.notes!,
                  style: theme.textTheme.bodyMedium,
                ),
              ),
            ),

            const SizedBox(height: AppSpacing.xl),
            const SectionTitle(title: 'Actions'),
            const SizedBox(height: AppSpacing.md),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AddPaymentPage(memberId: member.id!),
                        ),
                      );

                      if (!context.mounted) return;
                      await context
                          .read<PaymentsController>()
                          .loadMemberPayments(member.id!);
                    },
                    icon: const Icon(Icons.payments_rounded),
                    label: const Text('Paiement'),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      final updated = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => EditMemberPage(item: widget.item),
                        ),
                      );

                      if (updated == true && context.mounted) {
                        Navigator.pop(context, true);
                      }
                    },
                    icon: const Icon(Icons.edit_rounded),
                    label: const Text('Modifier'),
                  ),
                ),
              ],
            ),

            const SizedBox(height: AppSpacing.md),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _previewPdf(context),
                    icon: const Icon(Icons.picture_as_pdf_rounded),
                    label: const Text('PDF'),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _sharePdf(context),
                    icon: const Icon(Icons.share_rounded),
                    label: const Text('Partager'),
                  ),
                ),
              ],
            ),

            const SizedBox(height: AppSpacing.xl),
            const SectionTitle(title: 'Historique des paiements'),
            const SizedBox(height: AppSpacing.md),

            if (paymentsController.isLoading)
              const Center(
                child: CircularProgressIndicator(),
              )
            else if (paymentsController.payments.isEmpty)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Text(
                    'Aucun paiement enregistré pour le moment.',
                    style: theme.textTheme.bodyMedium,
                  ),
                ),
              )
            else
              Column(
                children: paymentsController.payments
                    .map(
                      (payment) => _PaymentCard(
                        payment: payment,
                        formatDate: _formatDate,
                        statusColor: _statusColor(payment.status),
                        onPreviewReceipt: () => _previewPaymentReceipt(payment),
                        onShareReceipt: () => _sharePaymentReceipt(payment),
                        onDelete: () async {
                          final confirmed = await showDeleteConfirmationDialog(
                            context: context,
                            title: 'Supprimer le paiement',
                            message:
                                'Voulez-vous vraiment supprimer ce paiement de ${payment.amountPaid.toStringAsFixed(0)} DH ?',
                          );

                          if (!confirmed) return;

                          await context
                              .read<PaymentsController>()
                              .deletePayment(payment.id!, member.id!);

                          if (!context.mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Paiement supprimé'),
                            ),
                          );
                        },
                      ),
                    )
                    .toList(),
              ),
          ],
        ),
      ),
    );
  }
}

class _PaymentCard extends StatelessWidget {
  final PaymentModel payment;
  final String Function(String) formatDate;
  final Color statusColor;
  final VoidCallback onDelete;
  final VoidCallback onPreviewReceipt;
  final VoidCallback onShareReceipt;

  const _PaymentCard({
    required this.payment,
    required this.formatDate,
    required this.statusColor,
    required this.onDelete,
    required this.onPreviewReceipt,
    required this.onShareReceipt,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    '${payment.amountPaid.toStringAsFixed(0)} DH',
                    style: AppTextStyles.cardTitle,
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    payment.status,
                    style: TextStyle(
                      color: statusColor,
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Text('Date paiement : ${formatDate(payment.paymentDate)}'),
            const SizedBox(height: 4),
            Text(
              'Période : ${formatDate(payment.startDate)} → ${formatDate(payment.endDate)}',
            ),
            if (payment.note != null && payment.note!.trim().isNotEmpty) ...[
              const SizedBox(height: 4),
              Text('Note : ${payment.note}'),
            ],
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onPreviewReceipt,
                    icon: const Icon(Icons.receipt_long_rounded),
                    label: const Text('Reçu'),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: onShareReceipt,
                    icon: const Icon(Icons.share_rounded),
                    label: const Text('Partager'),
                  ),
                ),
                IconButton(
                  onPressed: onDelete,
                  icon: const Icon(Icons.delete_outline),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}