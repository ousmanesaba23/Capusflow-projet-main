import 'package:campusflow_models/campusflow_models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import 'package:campusflow/core/theme/app_theme.dart';
import 'package:campusflow/core/utils/dates.dart';
import 'package:campusflow/core/widgets/etats.dart';
import 'package:campusflow/features/cours/cours_providers.dart';
import 'taches_notifier.dart';

/// Formulaire de création d'une tâche, branché sur l'état partagé.
class NouvelleTacheScreen extends ConsumerStatefulWidget {
  const NouvelleTacheScreen({super.key});

  @override
  ConsumerState<NouvelleTacheScreen> createState() =>
      _NouvelleTacheScreenState();
}

class _NouvelleTacheScreenState extends ConsumerState<NouvelleTacheScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _dateController = TextEditingController();

  String? _courseId;
  late DateTime _dueDate;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _dueDate = DateTime(now.year, now.month, now.day + 1, 23, 59);
    _dateController.text = Dates.courte(_dueDate);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _dueDate,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 2),
      helpText: 'Date d\'échéance',
    );
    if (picked == null) return;
    setState(() {
      _dueDate = DateTime(picked.year, picked.month, picked.day, 23, 59);
      _dateController.text = Dates.courte(_dueDate);
    });
  }

  static String? validateTitle(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Le titre est obligatoire';
    }
    return null;
  }

  /// POST /taches : on attend la réponse du serveur avant de fermer l'écran.
  Future<void> _save(List<Course> courses) async {
    if (!_formKey.currentState!.validate()) return;

    final draft = Task(
      id: '', // attribué par le serveur
      title: _titleController.text.trim(),
      courseId: _courseId ?? courses.first.id,
      dueDate: _dueDate,
      description: _descriptionController.text.trim(),
    );

    setState(() => _saving = true);
    final ok = await executer(
      context,
      () => ref.read(tachesProvider.notifier).ajouter(draft),
      succes: 'Tâche ajoutée : ${draft.title}',
    );
    if (!mounted) return;
    if (ok) {
      context.pop();
    } else {
      setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final courses = ref.watch(coursProvider).value ?? const <Course>[];

    return Scaffold(
      appBar: AppBar(title: const Text('Nouvelle tâche')),
      // Défilant : le clavier ne masque jamais le bouton « Enregistrer ».
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.l),
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _titleController,
                autofocus: true,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Titre *',
                  hintText: 'Ex. : TP Flutter à rendre',
                ),
                validator: validateTitle,
              ),
              const SizedBox(height: AppSpacing.l),
              DropdownButtonFormField<String>(
                // Reconstruit le champ quand les cours arrivent de l'API.
                key: ValueKey(courses.length),
                // isExpanded : le nom du cours est coupé (…) au lieu de déborder.
                isExpanded: true,
                initialValue:
                    _courseId ?? (courses.isEmpty ? null : courses.first.id),
                decoration: const InputDecoration(labelText: 'Cours'),
                items: [
                  for (final course in courses)
                    DropdownMenuItem(
                      value: course.id,
                      child: Text(
                        course.name,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                ],
                onChanged: (value) {
                  if (value != null) setState(() => _courseId = value);
                },
                validator: (value) =>
                    value == null ? 'Choisissez un cours' : null,
              ),
              const SizedBox(height: AppSpacing.l),
              TextFormField(
                controller: _dateController,
                readOnly: true,
                onTap: _pickDate,
                decoration: const InputDecoration(
                  labelText: 'Date d\'échéance',
                  suffixIcon: Icon(Icons.calendar_today),
                ),
              ),
              const SizedBox(height: AppSpacing.l),
              TextFormField(
                controller: _descriptionController,
                minLines: 3,
                maxLines: 6,
                decoration: const InputDecoration(
                  labelText: 'Description (facultatif)',
                  hintText: 'Consignes, lien…',
                  alignLabelWithHint: true,
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              FilledButton(
                onPressed: _saving ? null : () => _save(courses),
                child: Text(_saving ? 'Enregistrement…' : 'Enregistrer'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
