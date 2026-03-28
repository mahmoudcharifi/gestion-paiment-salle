import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/models/payment_model.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_text_field.dart';
import '../controllers/payments_controller.dart';

class AddPaymentPage extends StatefulWidget {
  final int memberId;

  const AddPaymentPage({
    super.key,
    required this.memberId,
  });

  @override
  State<AddPaymentPage> createState() => _AddPaymentPageState();
}

class _AddPaymentPageState extends State<AddPaymentPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  DateTime? _paymentDate;
  DateTime? _startDate;
  DateTime? _endDate;

  String _status = 'payé';
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _paymentDate = DateTime.now();
  }

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _pickDate({
    required DateTime? initialDate,
    required ValueChanged<DateTime> onSelected,
  }) async {
    final now = DateTime.now();

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate ?? now,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      onSelected(picked);
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'Choisir une date';
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }

  Future<void> _savePayment() async {
    if (!_formKey.currentState!.validate()) return;

    if (_paymentDate == null || _startDate == null || _endDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez sélectionner toutes les dates'),
        ),
      );
      return;
    }

    setState(() {
      _saving = true;
    });

    final payment = PaymentModel(
      memberId: widget.memberId,
      paymentDate: _paymentDate!.toIso8601String(),
      amountPaid: double.parse(_amountController.text.trim()),
      startDate: _startDate!.toIso8601String(),
      endDate: _endDate!.toIso8601String(),
      paymentMethod: 'Espèces',
      note: _noteController.text.trim().isEmpty
          ? null
          : _noteController.text.trim(),
      status: _status,
      createdAt: DateTime.now().toIso8601String(),
    );

    await context.read<PaymentsController>().addPayment(payment);

    if (!mounted) return;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajouter un paiement'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Nouveau paiement',
                style: AppTextStyles.pageTitle,
              ),
              const SizedBox(height: AppSpacing.lg),

              AppTextField(
                controller: _amountController,
                label: 'Montant',
                hint: 'Ex: 300',
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Le montant est obligatoire';
                  }

                  final parsed = double.tryParse(value.trim());
                  if (parsed == null || parsed <= 0) {
                    return 'Entre un montant valide';
                  }

                  return null;
                },
              ),
              const SizedBox(height: AppSpacing.md),



              _DatePickerTile(
                title: 'Date de paiement',
                value: _formatDate(_paymentDate),
                onTap: () => _pickDate(
                  initialDate: _paymentDate,
                  onSelected: (date) {
                    setState(() {
                      _paymentDate = date;
                    });
                  },
                ),
              ),
              const SizedBox(height: AppSpacing.md),

              _DatePickerTile(
                title: 'Début abonnement',
                value: _formatDate(_startDate),
                onTap: () => _pickDate(
                  initialDate: _startDate,
                  onSelected: (date) {
                    setState(() {
                      _startDate = date;
                    });
                  },
                ),
              ),
              const SizedBox(height: AppSpacing.md),

              _DatePickerTile(
                title: 'Fin abonnement',
                value: _formatDate(_endDate),
                onTap: () => _pickDate(
                  initialDate: _endDate,
                  onSelected: (date) {
                    setState(() {
                      _endDate = date;
                    });
                  },
                ),
              ),
              const SizedBox(height: AppSpacing.md),

              DropdownButtonFormField<String>(
                value: _status,
                decoration: const InputDecoration(
                  labelText: 'Statut',
                ),
                items: const [
                  DropdownMenuItem(
                    value: 'payé',
                    child: Text('Payé'),
                  ),
                  DropdownMenuItem(
                    value: 'en retard',
                    child: Text('En retard'),
                  ),
                  DropdownMenuItem(
                    value: 'partiel',
                    child: Text('Partiel'),
                  ),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _status = value;
                    });
                  }
                },
              ),
              const SizedBox(height: AppSpacing.md),

              AppTextField(
                controller: _noteController,
                label: 'Note',
                maxLines: 3,
                hint: 'Optionnel',
              ),
              const SizedBox(height: AppSpacing.xl),

              AppButton(
                text: 'Enregistrer le paiement',
                icon: Icons.save_rounded,
                loading: _saving,
                onPressed: _savePayment,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DatePickerTile extends StatelessWidget {
  final String title;
  final String value;
  final VoidCallback onTap;

  const _DatePickerTile({
    required this.title,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: title,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(value),
            const Icon(Icons.calendar_month_rounded),
          ],
        ),
      ),
    );
  }
}