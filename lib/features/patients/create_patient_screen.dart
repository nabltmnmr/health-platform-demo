import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/spacing.dart';
import '../../../core/models/models.dart';
import '../../../core/repositories/patient_repository.dart';
import '../../../core/services/app_state_provider.dart';

class CreatePatientScreen extends ConsumerStatefulWidget {
  const CreatePatientScreen({super.key});

  @override
  ConsumerState<CreatePatientScreen> createState() => _CreatePatientScreenState();
}

class _CreatePatientScreenState extends ConsumerState<CreatePatientScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _mrnController = TextEditingController();
  final _dobController = TextEditingController();
  String? _sex;
  final _allergyController = TextEditingController();

  DateTime? get _dateOfBirth {
    final s = _dobController.text.trim();
    if (s.isEmpty) return null;
    return _parseDate(s);
  }

  static DateTime? _parseDate(String s) {
    s = s.replaceAll(RegExp(r'[\s\-/.]'), '-');
    final parts = s.split('-');
    if (parts.length == 3) {
      int? d, m, y;
      if (parts[0].length == 4) {
        y = int.tryParse(parts[0]);
        m = int.tryParse(parts[1]);
        d = int.tryParse(parts[2]);
      } else {
        d = int.tryParse(parts[0]);
        m = int.tryParse(parts[1]);
        y = int.tryParse(parts[2]);
      }
      if (d != null && m != null && y != null) {
        if (y < 100) y += 1900;
        try {
          return DateTime(y, m, d);
        } catch (_) {}
      }
    }
    return null;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _mrnController.dispose();
    _dobController.dispose();
    _allergyController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final d = await showDatePicker(
      context: context,
      initialDate: _dateOfBirth ?? DateTime.now().subtract(const Duration(days: 365 * 30)),
      firstDate: DateTime(1920, 1, 1),
      lastDate: DateTime.now(),
    );
    if (d != null && mounted) {
      setState(() {
        _dobController.text = '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';
      });
    }
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    final name = _nameController.text.trim();
    final patientRepo = ref.read(patientRepositoryProvider);
    final id = const Uuid().v4().substring(0, 8);
    final mrn = _mrnController.text.trim().isEmpty ? 'MRN-$id' : _mrnController.text.trim();
    final allergies = _allergyController.text.trim().isEmpty
        ? <String>[]
        : _allergyController.text.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();

    patientRepo.add(Patient(
      id: 'p-$id',
      name: name,
      dateOfBirth: _dateOfBirth,
      sex: _sex,
      allergies: allergies,
      medicalRecordNumber: mrn,
    ));

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Patient created')));
      context.pop();
      context.push('/tickets/new?patientId=p-$id');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Form(
        key: _formKey,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('New Patient', style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: AppSpacing.xl),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Full name'),
                validator: (v) => (v ?? '').trim().isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: AppSpacing.lg),
              TextFormField(
                controller: _mrnController,
                decoration: const InputDecoration(
                  labelText: 'Medical Record Number',
                  hintText: 'Leave blank to auto-generate',
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              TextFormField(
                controller: _dobController,
                decoration: InputDecoration(
                  labelText: 'Date of birth',
                  hintText: 'DD/MM/YYYY or YYYY-MM-DD',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: _pickDate,
                    tooltip: 'Pick date',
                  ),
                ),
                validator: (v) {
                  final s = (v ?? '').trim();
                  if (s.isEmpty) return null;
                  final d = _parseDate(s);
                  if (d == null) return 'Enter a valid date (e.g. 15/03/1990)';
                  if (d.isAfter(DateTime.now())) return 'Date cannot be in the future';
                  return null;
                },
              ),
              const SizedBox(height: AppSpacing.lg),
              DropdownButtonFormField<String>(
                value: _sex,
                decoration: const InputDecoration(labelText: 'Sex'),
                items: const [
                  DropdownMenuItem(value: 'M', child: Text('Male')),
                  DropdownMenuItem(value: 'F', child: Text('Female')),
                ],
                onChanged: (v) => setState(() => _sex = v),
              ),
              const SizedBox(height: AppSpacing.lg),
              TextFormField(
                controller: _allergyController,
                decoration: const InputDecoration(
                  labelText: 'Allergies',
                  hintText: 'Comma-separated, e.g. Penicillin, Latex',
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),
              FilledButton(
                onPressed: _save,
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.onPrimary,
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                ),
                child: const Text('Create & New Ticket'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
