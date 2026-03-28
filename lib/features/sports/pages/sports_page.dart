import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_text_field.dart';
import '../controllers/sports_controller.dart';
import '../../../shared/widgets/delete_confirmation_dialog.dart';

class SportsPage extends StatefulWidget {
  const SportsPage({super.key});

  @override
  State<SportsPage> createState() => _SportsPageState();
}

class _SportsPageState extends State<SportsPage> {
  final TextEditingController _sportController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<SportsController>().loadSports();
    });
  }

  @override
  void dispose() {
    _sportController.dispose();
    super.dispose();
  }

  Future<void> _addSport() async {
    final controller = context.read<SportsController>();
    final message = await controller.addSport(_sportController.text);

    if (!mounted) return;

    if (message == null) {
      _sportController.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sport ajouté avec succès')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }

  Future<void> _showEditDialog(int id, String currentName) async {
    final editController = TextEditingController(text: currentName);

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Modifier le sport'),
          content: TextField(
            controller: editController,
            decoration: const InputDecoration(
              hintText: 'Nom du sport',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () async {
                final message = await context.read<SportsController>().updateSport(
                      id,
                      editController.text,
                    );

                if (!mounted) return;

                Navigator.pop(context);

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      message ?? 'Sport modifié avec succès',
                    ),
                  ),
                );
              },
              child: const Text('Enregistrer'),
            ),
          ],
        );
      },
    );

    editController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<SportsController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestion des sports'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Sports de la salle',
              style: AppTextStyles.pageTitle,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Ajoute, modifie ou supprime les disciplines disponibles.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: AppSpacing.lg),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  children: [
                    AppTextField(
                      controller: _sportController,
                      label: 'Nom du sport',
                      hint: 'Ex: Grappling, Karaté, Taekwondo...',
                    ),
                    const SizedBox(height: AppSpacing.md),
                    AppButton(
                      text: 'Ajouter le sport',
                      icon: Icons.add_rounded,
                      loading: controller.isLoading,
                      onPressed: _addSport,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: AppSpacing.lg),

            Expanded(
              child: controller.isLoading && controller.sports.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : controller.sports.isEmpty
                      ? const Center(
                          child: Text('Aucun sport disponible'),
                        )
                      : ListView.separated(
                          itemCount: controller.sports.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: AppSpacing.sm),
                          itemBuilder: (context, index) {
                            final sport = controller.sports[index];

                            return Card(
                              child: ListTile(
                                leading: const CircleAvatar(
                                  child: Icon(Icons.sports_mma_rounded),
                                ),
                                title: Text(
                                  sport.name,
                                  style: AppTextStyles.cardTitle,
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit_rounded),
                                      onPressed: () {
                                        _showEditDialog(sport.id!, sport.name);
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete_outline),
                                      onPressed: () async {
                                        final confirmed = await showDeleteConfirmationDialog(
                                          context: context,
                                          title: 'Supprimer le sport',
                                          message: 'Voulez-vous vraiment supprimer le sport "${sport.name}" ?',
                                        );

                                        if (!confirmed) return;

                                        await controller.deleteSport(sport.id!);

                                        if (!mounted) return;
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                            content: Text('Sport supprimé'),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}