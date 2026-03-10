import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/spacing.dart';
import '../../../core/models/models.dart';
import '../../../core/enums/enums.dart';
import '../../../core/repositories/patient_repository.dart';
import '../../../core/repositories/ticket_repository.dart';
import '../../../core/repositories/queue_repository.dart';
import '../../../core/services/app_state_provider.dart';
import '../../../core/seed/seed_data.dart';
import '../../../shared/widgets/patient_header_card.dart';

class TicketCreationScreen extends ConsumerStatefulWidget {
  const TicketCreationScreen({super.key, this.initialPatientId});

  final String? initialPatientId;

  @override
  ConsumerState<TicketCreationScreen> createState() => _TicketCreationScreenState();
}

class _TicketCreationScreenState extends ConsumerState<TicketCreationScreen> {
  Patient? _selectedPatient;
  VisitType _visitType = VisitType.er;
  String? _clinicAreaId;

  @override
  void initState() {
    super.initState();
    if (widget.initialPatientId != null) {
      _selectedPatient = ref.read(patientRepositoryProvider).getById(widget.initialPatientId!);
    }
  }

  List<ClinicArea> get _clinicAreas {
    final facilityId = ref.read(selectedFacilityIdProvider) ?? 'hosp-a';
    return SeedData.clinicAreas.where((c) {
      final dept = SeedData.departments.firstWhere((d) => d.clinicAreaIds.contains(c.id));
      return dept.facilityId == facilityId;
    }).toList();
  }

  void _createTicket() {
    if (_selectedPatient == null) return;
    final facilityId = ref.read(selectedFacilityIdProvider) ?? 'hosp-a';
    final clinicArea = _clinicAreaId != null
        ? _clinicAreas.firstWhere((c) => c.id == _clinicAreaId)
        : _clinicAreas.firstWhere((c) => c.visitType == _visitType.name, orElse: () => _clinicAreas.first);

    final ticketRepo = ref.read(ticketRepositoryProvider);
    final queueRepo = ref.read(queueRepositoryProvider);
    final ticketId = 'ticket-${const Uuid().v4().substring(0, 8)}';
    final queueNum = ticketRepo.getNextQueueNumber();
    final ticket = VisitTicket(
      id: ticketId,
      patientId: _selectedPatient!.id,
      visitType: _visitType,
      status: VisitStatus.queued,
      queueNumber: queueNum,
      destinationClinicAreaId: clinicArea.id,
      facilityId: facilityId,
      qrPayload: 'TICKET:$ticketId',
      createdAt: DateTime.now(),
    );

    ticketRepo.add(ticket);
    queueRepo.add(QueueEntry(
      id: 'qe-${const Uuid().v4().substring(0, 8)}',
      ticketId: ticketId,
      patientId: _selectedPatient!.id,
      areaId: clinicArea.id,
      areaType: 'clinic',
      queueNumber: queueNum,
      status: QueueStatus.waiting,
    ));

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Ticket created')));
      context.go('/tickets/$ticketId');
    }
  }

  @override
  Widget build(BuildContext context) {
    final clinicAreas = _clinicAreas;
    if (_clinicAreaId == null && clinicAreas.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) setState(() => _clinicAreaId = clinicAreas.firstWhere(
          (c) => c.visitType == _visitType.name,
          orElse: () => clinicAreas.first,
        ).id);
      });
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 520),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Create Ticket', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: AppSpacing.lg),
            if (_selectedPatient != null) ...[
              PatientHeaderCard(
                patientName: _selectedPatient!.name,
                age: _selectedPatient!.ageYears,
                sex: _selectedPatient!.sex,
                allergies: _selectedPatient!.allergies,
                medicalRecordNumber: _selectedPatient!.medicalRecordNumber,
              ),
              const SizedBox(height: AppSpacing.lg),
            ] else
              Card(
                child: ListTile(
                  leading: const Icon(Icons.person_add),
                  title: const Text('Select patient'),
                  subtitle: const Text('Choose a patient to create a ticket'),
                  onTap: () => context.push('/patients'),
                ),
              ),
            const SizedBox(height: AppSpacing.xl),
            Text('Visit type', style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: AppSpacing.sm),
            Wrap(
              spacing: 8,
              children: VisitType.values.map((v) {
                final selected = _visitType == v;
                return ChoiceChip(
                  label: Text(v.label),
                  selected: selected,
                  onSelected: (_) {
                    setState(() {
                      _visitType = v;
                      final match = clinicAreas.where((c) => c.visitType == v.name).toList();
                      _clinicAreaId = match.isNotEmpty ? match.first.id : clinicAreas.first.id;
                    });
                  },
                  selectedColor: AppColors.primaryContainer,
                );
              }).toList(),
            ),
            if (clinicAreas.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.lg),
              DropdownButtonFormField<String>(
                value: _clinicAreaId ?? clinicAreas.first.id,
                decoration: const InputDecoration(labelText: 'Destination'),
                items: clinicAreas.map((c) => DropdownMenuItem(value: c.id, child: Text(c.name))).toList(),
                onChanged: (v) => setState(() => _clinicAreaId = v),
              ),
            ],
            const SizedBox(height: AppSpacing.xxl),
            FilledButton(
              onPressed: _selectedPatient != null ? _createTicket : null,
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.onPrimary,
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
              ),
              child: const Text('Create Ticket'),
            ),
          ],
        ),
      ),
    );
  }
}
