import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/models/member_model.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_text_field.dart';
import '../../../shared/widgets/multi_sport_selector.dart';
import '../controllers/members_controller.dart';

class AddMemberPage extends StatefulWidget {
  const AddMemberPage({super.key});

  @override
  State<AddMemberPage> createState() => _AddMemberPageState();
}

class _AddMemberPageState extends State<AddMemberPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _cinController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  bool _saving = false;
  List<int> _selectedSportIds = [];

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<MembersController>().loadSports();
    });
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _cinController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _saveMember() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedSportIds.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Choisis au moins un sport'),
        ),
      );
      return;
    }

    setState(() => _saving = true);

    final now = DateTime.now().toIso8601String();

    final member = MemberModel(
      firstName: _firstNameController.text.trim(),
      lastName: _lastNameController.text.trim(),
      phone: _phoneController.text.trim(),
      cin: _cinController.text.trim().isEmpty ? null : _cinController.text.trim(),
      guardianName: null,
      guardianPhone: null,
      birthDate: null,
      photoPath: null,
      qrCode: 'MEM-${DateTime.now().millisecondsSinceEpoch}',
      registrationDate: now,
      isActive: 1,
      notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
      createdAt: now,
      updatedAt: now,
    );

    await context.read<MembersController>().addMember(
          member,
          _selectedSportIds,
        );

    if (!mounted) return;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<MembersController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajouter un adhérent'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Nouveau profil', style: AppTextStyles.pageTitle),
              const SizedBox(height: AppSpacing.lg),

              AppTextField(
                controller: _firstNameController,
                label: 'Prénom',
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Le prénom est obligatoire';
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppSpacing.md),

              AppTextField(
                controller: _lastNameController,
                label: 'Nom',
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Le nom est obligatoire';
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppSpacing.md),

              AppTextField(
                controller: _phoneController,
                label: 'Téléphone',
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Le téléphone est obligatoire';
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppSpacing.md),

              AppTextField(
                controller: _cinController,
                label: 'CIN',
                hint: 'Optionnel',
              ),
              const SizedBox(height: AppSpacing.md),

              MultiSportSelector(
                sports: controller.sports,
                selectedSportIds: _selectedSportIds,
                onChanged: (value) {
                  setState(() {
                    _selectedSportIds = value;
                  });
                },
              ),
              const SizedBox(height: AppSpacing.md),

              AppTextField(
                controller: _notesController,
                label: 'Notes',
                maxLines: 3,
              ),
              const SizedBox(height: AppSpacing.xl),

              AppButton(
                text: 'Enregistrer',
                icon: Icons.save_rounded,
                loading: _saving,
                onPressed: _saveMember,
              ),
            ],
          ),
        ),
      ),
    );
  }
}