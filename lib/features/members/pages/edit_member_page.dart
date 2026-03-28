import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/models/member_model.dart';
import '../../../data/repositories/member_repository.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_text_field.dart';
import '../../../shared/widgets/multi_sport_selector.dart';
import '../controllers/members_controller.dart';

class EditMemberPage extends StatefulWidget {
  final MemberWithSports item;

  const EditMemberPage({
    super.key,
    required this.item,
  });

  @override
  State<EditMemberPage> createState() => _EditMemberPageState();
}

class _EditMemberPageState extends State<EditMemberPage> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _cinController;
  late final TextEditingController _notesController;

  bool _saving = false;
  bool _loadingSports = true;
  List<int> _selectedSportIds = [];

  @override
  void initState() {
    super.initState();

    final member = widget.item.member;

    _firstNameController = TextEditingController(text: member.firstName);
    _lastNameController = TextEditingController(text: member.lastName);
    _phoneController = TextEditingController(text: member.phone);
    _cinController = TextEditingController(text: member.cin ?? '');
    _notesController = TextEditingController(text: member.notes ?? '');

    Future.microtask(() async {
      final controller = context.read<MembersController>();
      await controller.loadSports();
      final ids = await controller.getSelectedSportIds(member.id!);

      if (!mounted) return;

      setState(() {
        _selectedSportIds = ids;
        _loadingSports = false;
      });
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

  Future<void> _saveChanges() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedSportIds.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Choisis au moins un sport'),
        ),
      );
      return;
    }

    setState(() {
      _saving = true;
    });

    final oldMember = widget.item.member;

    final updatedMember = MemberModel(
      id: oldMember.id,
      firstName: _firstNameController.text.trim(),
      lastName: _lastNameController.text.trim(),
      phone: _phoneController.text.trim(),
      cin: _cinController.text.trim().isEmpty ? null : _cinController.text.trim(),
      guardianName: oldMember.guardianName,
      guardianPhone: oldMember.guardianPhone,
      birthDate: oldMember.birthDate,
      photoPath: oldMember.photoPath,
      qrCode: oldMember.qrCode,
      registrationDate: oldMember.registrationDate,
      isActive: oldMember.isActive,
      notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
      createdAt: oldMember.createdAt,
      updatedAt: DateTime.now().toIso8601String(),
    );

    await context.read<MembersController>().updateMember(
          updatedMember,
          _selectedSportIds,
        );

    if (!mounted) return;

    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<MembersController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Modifier l’adhérent'),
      ),
      body: _loadingSports
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Modifier le profil',
                      style: AppTextStyles.pageTitle,
                    ),
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
                      text: 'Enregistrer les modifications',
                      icon: Icons.save_rounded,
                      loading: _saving,
                      onPressed: _saveChanges,
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}