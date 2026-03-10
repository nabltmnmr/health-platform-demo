import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/spacing.dart';
import '../../../core/models/models.dart';
import '../../../core/enums/enums.dart';
import '../../../core/repositories/lab_repository.dart';
import '../../../core/repositories/patient_repository.dart';
import '../../../core/services/app_state_provider.dart';

class LabResultScreen extends ConsumerStatefulWidget {
  const LabResultScreen({super.key, required this.requestId});

  final String requestId;

  @override
  ConsumerState<LabResultScreen> createState() => _LabResultScreenState();
}

class _LabResultScreenState extends ConsumerState<LabResultScreen> {
  final _valueController = TextEditingController();
  final _unitController = TextEditingController();
  final _refController = TextEditingController();
  String? _resultImageBase64;

  @override
  void dispose() {
    _valueController.dispose();
    _unitController.dispose();
    _refController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final xFile = await picker.pickImage(source: ImageSource.gallery, imageQuality: 85);
    if (xFile == null || !mounted) return;
    final bytes = await xFile.readAsBytes();
    if (!mounted) return;
    setState(() => _resultImageBase64 = base64Encode(bytes));
  }

  @override
  Widget build(BuildContext context) {
    final request = ref.watch(labRepositoryProvider).getRequestById(widget.requestId);
    if (request == null) return const Center(child: Text('Request not found'));

    final patient = ref.watch(patientRepositoryProvider).getById(request.patientId);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(request.testName, style: Theme.of(context).textTheme.headlineSmall),
          if (patient != null) Text(patient.name, style: Theme.of(context).textTheme.bodyLarge),
          const SizedBox(height: AppSpacing.xl),
          TextField(controller: _valueController, decoration: const InputDecoration(labelText: 'Result value')),
          const SizedBox(height: 16),
          TextField(controller: _unitController, decoration: const InputDecoration(labelText: 'Unit')),
          const SizedBox(height: 16),
          TextField(controller: _refController, decoration: const InputDecoration(labelText: 'Reference range')),
          const SizedBox(height: 24),
          Text('Test result image', style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: _pickImage,
            icon: const Icon(Icons.upload_file),
            label: const Text('Upload image'),
          ),
          if (_resultImageBase64 != null) ...[
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.memory(
                base64Decode(_resultImageBase64!),
                height: 200,
                width: double.infinity,
                fit: BoxFit.contain,
              ),
            ),
            TextButton.icon(
              onPressed: () => setState(() => _resultImageBase64 = null),
              icon: const Icon(Icons.delete_outline, size: 18),
              label: const Text('Remove image'),
            ),
          ],
          const SizedBox(height: 24),
          FilledButton(
            onPressed: () => _save(request),
            style: FilledButton.styleFrom(backgroundColor: AppColors.primary, padding: const EdgeInsets.symmetric(vertical: 16)),
            child: const Text('Save Result'),
          ),
        ],
      ),
    );
  }

  void _save(LabRequest request) {
    final resultId = 'labres-${DateTime.now().millisecondsSinceEpoch}';
    final result = LabResult(
      id: resultId,
      labRequestId: request.id,
      value: _valueController.text.trim(),
      unit: _unitController.text.trim().isEmpty ? null : _unitController.text.trim(),
      referenceRange: _refController.text.trim().isEmpty ? null : _refController.text.trim(),
      completedAt: DateTime.now(),
      enteredById: ref.read(currentUserProvider)?.id,
      resultImageBase64: _resultImageBase64,
    );
    ref.read(labRepositoryProvider).addResult(result);
    ref.read(labRepositoryProvider).updateRequest(LabRequest(
      id: request.id, encounterId: request.encounterId, patientId: request.patientId, testName: request.testName,
      status: LabRequestStatus.completed, resultId: resultId, sampleCollectedAt: request.sampleCollectedAt,
      completedAt: DateTime.now(), notes: request.notes,
    ));
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Result saved')));
      context.pop();
    }
  }
}
