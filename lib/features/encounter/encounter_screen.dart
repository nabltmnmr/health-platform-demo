import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/spacing.dart';
import '../../../core/models/models.dart';
import '../../../core/enums/enums.dart';
import '../../../core/repositories/patient_repository.dart';
import '../../../core/repositories/ticket_repository.dart';
import '../../../core/repositories/encounter_repository.dart';
import '../../../core/repositories/pharmacy_repository.dart';
import '../../../core/repositories/lab_repository.dart';
import '../../../core/repositories/nursing_repository.dart';
import '../../../core/services/app_state_provider.dart';
import '../../../core/seed/seed_data.dart';
import '../../../shared/widgets/patient_header_card.dart';
import '../../../shared/widgets/status_chip.dart';
import '../../../shared/widgets/step_timeline.dart';

class EncounterScreen extends ConsumerStatefulWidget {
  const EncounterScreen({super.key, required this.ticketId, this.startNew = false});

  final String ticketId;
  final bool startNew;

  @override
  ConsumerState<EncounterScreen> createState() => _EncounterScreenState();
}

class _EncounterScreenState extends ConsumerState<EncounterScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 7, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ticket = ref.watch(ticketRepositoryProvider).getById(widget.ticketId);
    if (ticket == null) return const Center(child: Text('Ticket not found'));

    final encounter = ref.watch(encounterRepositoryProvider).getByTicketId(widget.ticketId);
    final patient = ref.watch(patientRepositoryProvider).getById(ticket.patientId);

    final hasEncounter = encounter != null;
    if (widget.startNew && !hasEncounter) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _startEncounter(ref));
    }

    return Column(
      children: [
        if (patient != null)
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: PatientHeaderCard(
              patientName: patient.name,
              age: patient.ageYears,
              sex: patient.sex,
              allergies: patient.allergies,
              medicalRecordNumber: patient.medicalRecordNumber,
              visitType: ticket.visitType.label,
            ),
          ),
        TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: const [
            Tab(text: 'Overview'),
            Tab(text: 'Patient Record'),
            Tab(text: 'Diagnosis'),
            Tab(text: 'Prescription'),
            Tab(text: 'Lab'),
            Tab(text: 'Treatment'),
            Tab(text: 'Discharge'),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _OverviewTab(ticket: ticket, encounter: encounter, patient: patient),
              _PatientRecordTab(patientId: ticket.patientId, currentTicketId: ticket.id, currentEncounter: encounter),
              _DiagnosisTab(encounter: encounter),
              _PrescriptionTab(encounter: encounter, ticket: ticket),
              _LabTab(encounter: encounter),
              _TreatmentTab(encounter: encounter),
              _DischargeTab(ticket: ticket, encounter: encounter),
            ],
          ),
        ),
      ],
    );
  }

  void _startEncounter(WidgetRef ref) {
    final ticket = ref.read(ticketRepositoryProvider).getById(widget.ticketId)!;
    final user = ref.read(currentUserProvider);
    if (user == null) return;

    final encId = 'enc-${const Uuid().v4().substring(0, 8)}';
    final encounter = Encounter(
      id: encId,
      ticketId: ticket.id,
      patientId: ticket.patientId,
      providerId: user.id,
      status: VisitStatus.inProgress,
      startedAt: DateTime.now(),
    );

    ref.read(encounterRepositoryProvider).addEncounter(encounter);
    ref.read(ticketRepositoryProvider).update(VisitTicket(
      id: ticket.id,
      patientId: ticket.patientId,
      visitType: ticket.visitType,
      status: VisitStatus.inProgress,
      queueNumber: ticket.queueNumber,
      destinationClinicAreaId: ticket.destinationClinicAreaId,
      facilityId: ticket.facilityId,
      qrPayload: ticket.qrPayload,
      encounterId: encId,
      createdAt: ticket.createdAt,
    ));
    setState(() {});
  }
}

class _OverviewTab extends StatelessWidget {
  const _OverviewTab({required this.ticket, this.encounter, this.patient});

  final VisitTicket ticket;
  final Encounter? encounter;
  final Patient? patient;

  @override
  Widget build(BuildContext context) {
    final steps = ['Ticket created', 'Encounter started', 'Diagnosis', 'Prescription', 'Lab', 'Nursing', 'Discharge'];
    var current = 0;
    if (encounter != null) {
      current = 1;
      if (encounter!.diagnosisIds.isNotEmpty) current = 2;
      if (encounter!.prescriptionId != null) current = 3;
      if (encounter!.labRequestIds.isNotEmpty) current = 4;
      if (encounter!.treatmentOrderIds.isNotEmpty) current = 5;
      if (ticket.status == VisitStatus.discharged || ticket.status == VisitStatus.admittedToWard) current = 6;
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          StepTimeline(steps: steps, currentIndex: current),
          const SizedBox(height: AppSpacing.xl),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Visit summary', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: AppSpacing.md),
                  _row(context, 'Ticket', ticket.id),
                  _row(context, 'Status', ticket.status.label),
                  if (encounter != null) _row(context, 'Encounter', encounter!.id),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _row(BuildContext context, String l, String v) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          SizedBox(width: 100, child: Text(l, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary))),
          Text(v, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}

class _PatientRecordTab extends ConsumerWidget {
  const _PatientRecordTab({
    required this.patientId,
    required this.currentTicketId,
    this.currentEncounter,
  });

  final String patientId;
  final String currentTicketId;
  final Encounter? currentEncounter;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final encounterRepo = ref.watch(encounterRepositoryProvider);
    final nursingRepo = ref.watch(nursingRepositoryProvider);
    final ticketRepo = ref.watch(ticketRepositoryProvider);

    final allForPatient = encounterRepo.getByPatientId(patientId);
    final priorEncounters = allForPatient
        .where((e) => e.ticketId != currentTicketId)
        .toList()
      ..sort((a, b) => (b.startedAt ?? DateTime(0)).compareTo(a.startedAt ?? DateTime(0)));
    final lastVisit = priorEncounters.isNotEmpty ? priorEncounters.first : null;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (lastVisit != null) ...[
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.history, color: AppColors.primary, size: 20),
                        const SizedBox(width: 8),
                        Text('Last visit summary', style: Theme.of(context).textTheme.titleMedium),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    _summaryRow(context, 'Date', lastVisit.startedAt != null
                        ? DateFormat.yMMMd().format(lastVisit.startedAt!)
                        : '—'),
                    _summaryRow(context, 'Encounter', lastVisit.id),
                    const SizedBox(height: AppSpacing.sm),
                    Text('Diagnosis', style: Theme.of(context).textTheme.titleSmall?.copyWith(color: AppColors.textSecondary)),
                    const SizedBox(height: 4),
                    _diagnosisBlock(ref, lastVisit),
                    const SizedBox(height: AppSpacing.sm),
                    Text('Treatment', style: Theme.of(context).textTheme.titleSmall?.copyWith(color: AppColors.textSecondary)),
                    const SizedBox(height: 4),
                    _treatmentBlock(ref, lastVisit),
                    const SizedBox(height: AppSpacing.sm),
                    Text('Notes', style: Theme.of(context).textTheme.titleSmall?.copyWith(color: AppColors.textSecondary)),
                    const SizedBox(height: 4),
                    Text(lastVisit.notes != null && lastVisit.notes!.isNotEmpty ? lastVisit.notes! : '—', style: Theme.of(context).textTheme.bodyMedium),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
          ],
          Text('Visit history', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: AppSpacing.sm),
          if (priorEncounters.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
              child: Text('No prior visits recorded.', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary)),
            )
          else
            ...priorEncounters.map((e) {
              final ticket = ticketRepo.getById(e.ticketId);
              final dateStr = e.startedAt != null ? DateFormat.yMMMd().format(e.startedAt!) : (ticket?.createdAt != null ? DateFormat.yMMMd().format(ticket!.createdAt!) : e.id);
              final diagnoses = encounterRepo.getDiagnosesByEncounter(e.id);
              final summary = diagnoses.isNotEmpty ? diagnoses.map((d) => d.description).join('; ') : 'No diagnosis';
              return Card(
                margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: ListTile(
                  title: Text(dateStr),
                  subtitle: Text(summary, maxLines: 2, overflow: TextOverflow.ellipsis),
                  trailing: const Icon(Icons.chevron_right),
                ),
              );
            }),
        ],
      ),
    );
  }

  Widget _summaryRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 90, child: Text(label, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary))),
          Expanded(child: Text(value, style: Theme.of(context).textTheme.bodyMedium)),
        ],
      ),
    );
  }

  Widget _diagnosisBlock(WidgetRef ref, Encounter encounter) {
    final diagnoses = ref.read(encounterRepositoryProvider).getDiagnosesByEncounter(encounter.id);
    if (diagnoses.isEmpty) return Text('—', style: TextStyle(fontSize: 14, color: AppColors.textSecondary));
    return Text(
      diagnoses.map((d) => '${d.code}: ${d.description}${d.notes != null ? ' (${d.notes})' : ''}').join('\n'),
      style: const TextStyle(fontSize: 14),
    );
  }

  Widget _treatmentBlock(WidgetRef ref, Encounter encounter) {
    final orders = ref.read(nursingRepositoryProvider).allOrders
        .where((o) => encounter.treatmentOrderIds.contains(o.id))
        .toList();
    if (orders.isEmpty) return Text('—', style: TextStyle(fontSize: 14, color: AppColors.textSecondary));
    return Text(
      orders.map((o) => o.description).join('\n'),
      style: const TextStyle(fontSize: 14),
    );
  }
}

class _DiagnosisTab extends ConsumerStatefulWidget {
  const _DiagnosisTab({this.encounter});
  final Encounter? encounter;
  @override
  ConsumerState<_DiagnosisTab> createState() => _DiagnosisTabState();
}

class _DiagnosisTabState extends ConsumerState<_DiagnosisTab> {
  final _codeController = TextEditingController();
  final _descController = TextEditingController();
  @override
  void dispose() {
    _codeController.dispose();
    _descController.dispose();
    super.dispose();
  }
  void _add() {
    if (widget.encounter == null) return;
    final code = _codeController.text.trim();
    final desc = _descController.text.trim();
    if (code.isEmpty || desc.isEmpty) return;
    final d = Diagnosis(id: 'diag-${const Uuid().v4().substring(0, 8)}', encounterId: widget.encounter!.id, code: code, description: desc, recordedAt: DateTime.now());
    ref.read(encounterRepositoryProvider).addDiagnosis(d);
    ref.read(encounterRepositoryProvider).updateEncounter(Encounter(
      id: widget.encounter!.id, ticketId: widget.encounter!.ticketId, patientId: widget.encounter!.patientId, providerId: widget.encounter!.providerId,
      diagnosisIds: [...widget.encounter!.diagnosisIds, d.id], prescriptionId: widget.encounter!.prescriptionId, labRequestIds: widget.encounter!.labRequestIds, treatmentOrderIds: widget.encounter!.treatmentOrderIds,
      status: widget.encounter!.status, startedAt: widget.encounter!.startedAt, endedAt: widget.encounter!.endedAt, notes: widget.encounter!.notes,
    ));
    _codeController.clear();
    _descController.clear();
    setState(() {});
  }
  @override
  Widget build(BuildContext context) {
    if (widget.encounter == null) return const Center(child: Text('Start encounter first'));
    final diagnoses = ref.watch(encounterRepositoryProvider).getDiagnosesByEncounter(widget.encounter!.id);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(controller: _codeController, decoration: const InputDecoration(labelText: 'ICD code')),
          const SizedBox(height: 8),
          TextField(controller: _descController, decoration: const InputDecoration(labelText: 'Description')),
          const SizedBox(height: 16),
          FilledButton.icon(onPressed: _add, icon: const Icon(Icons.add), label: const Text('Add diagnosis')),
          const SizedBox(height: 24),
          if (diagnoses.isNotEmpty) ...[
            Text('Recorded', style: Theme.of(context).textTheme.titleSmall),
            ...diagnoses.map((d) => ListTile(title: Text(d.description), subtitle: Text(d.code))),
          ],
        ],
      ),
    );
  }
}

class _PrescriptionTab extends ConsumerWidget {
  const _PrescriptionTab({this.encounter, required this.ticket});
  final Encounter? encounter;
  final VisitTicket ticket;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (encounter == null) return const Center(child: Text('Start encounter first'));
    final pharmacyRepo = ref.watch(pharmacyRepositoryProvider);
    final inventoryRepo = ref.watch(inventoryRepositoryProvider);
    final prescriptions = pharmacyRepo.getPrescriptionsByEncounterId(encounter!.id);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Build prescription by national identifier', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary)),
          const SizedBox(height: AppSpacing.md),
          FilledButton.icon(
            onPressed: () => context.push('/encounter/${ticket.id}/prescription'),
            icon: const Icon(Icons.add),
            label: const Text('Create Prescription'),
          ),
          if (prescriptions.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.xl),
            Text('Prescriptions', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: AppSpacing.sm),
            ...prescriptions.map((rx) {
              final productNames = <String, String>{};
              for (final p in inventoryRepo.nationalProducts) {
                productNames[p.id] = '${p.name} ${p.form}';
              }
              return Card(
                margin: const EdgeInsets.only(bottom: AppSpacing.md),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
                  title: Text(
                    rx.items.isEmpty
                        ? 'Prescription ${rx.id}'
                        : rx.items.map((i) => productNames[i.productNationalId] ?? i.productNationalId).join(', '),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text('${rx.items.length} item(s) · ${rx.status.label}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.edit_outlined),
                    onPressed: () => context.push('/encounter/${ticket.id}/prescription/${rx.id}'),
                    tooltip: 'Edit',
                  ),
                  isThreeLine: true,
                ),
              );
            }),
          ],
        ],
      ),
    );
  }
}

class _LabTab extends ConsumerStatefulWidget {
  const _LabTab({this.encounter});
  final Encounter? encounter;
  @override
  ConsumerState<_LabTab> createState() => _LabTabState();
}

class _LabTabState extends ConsumerState<_LabTab> {
  final _testController = TextEditingController();
  @override
  void dispose() {
    _testController.dispose();
    super.dispose();
  }
  void _add() {
    if (widget.encounter == null) return;
    final name = _testController.text.trim();
    if (name.isEmpty) return;
    final r = LabRequest(id: 'labreq-${const Uuid().v4().substring(0, 8)}', encounterId: widget.encounter!.id, patientId: widget.encounter!.patientId, testName: name);
    ref.read(labRepositoryProvider).addRequest(r);
    ref.read(encounterRepositoryProvider).updateEncounter(Encounter(
      id: widget.encounter!.id, ticketId: widget.encounter!.ticketId, patientId: widget.encounter!.patientId, providerId: widget.encounter!.providerId,
      diagnosisIds: widget.encounter!.diagnosisIds, prescriptionId: widget.encounter!.prescriptionId, labRequestIds: [...widget.encounter!.labRequestIds, r.id], treatmentOrderIds: widget.encounter!.treatmentOrderIds,
      status: widget.encounter!.status, startedAt: widget.encounter!.startedAt, endedAt: widget.encounter!.endedAt, notes: widget.encounter!.notes,
    ));
    _testController.clear();
    setState(() {});
  }
  @override
  Widget build(BuildContext context) {
    if (widget.encounter == null) return const Center(child: Text('Start encounter first'));
    final encounter = ref.read(encounterRepositoryProvider).getByTicketId(widget.encounter!.ticketId) ?? widget.encounter!;
    final requests = ref.read(labRepositoryProvider).allRequests.where((r) => encounter.labRequestIds.contains(r.id)).toList();
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(controller: _testController, decoration: const InputDecoration(labelText: 'Test name', hintText: 'e.g. CBC, CRP')),
          const SizedBox(height: 16),
          FilledButton.icon(onPressed: _add, icon: const Icon(Icons.add), label: const Text('Request lab test')),
          const SizedBox(height: 24),
          if (requests.isNotEmpty) ...[
            Text('Requests', style: Theme.of(context).textTheme.titleSmall),
            ...requests.map((r) => ListTile(
              title: Text(r.testName),
              trailing: StatusChip(label: r.status.label, size: StatusChipSize.small),
              onTap: () => context.push('/lab/result/${r.id}'),
            )),
          ],
        ],
      ),
    );
  }
}

class _TreatmentTab extends ConsumerStatefulWidget {
  const _TreatmentTab({this.encounter});
  final Encounter? encounter;
  @override
  ConsumerState<_TreatmentTab> createState() => _TreatmentTabState();
}

class _TreatmentTabState extends ConsumerState<_TreatmentTab> {
  final _descController = TextEditingController();
  @override
  void dispose() {
    _descController.dispose();
    super.dispose();
  }
  void _add() {
    if (widget.encounter == null) return;
    final desc = _descController.text.trim();
    if (desc.isEmpty) return;
    final due = DateTime.now().add(const Duration(hours: 1));
    final t = TreatmentOrder(id: 'treat-${const Uuid().v4().substring(0, 8)}', encounterId: widget.encounter!.id, patientId: widget.encounter!.patientId, description: desc, dueAt: due);
    ref.read(nursingRepositoryProvider).addOrder(t);
    ref.read(encounterRepositoryProvider).updateEncounter(Encounter(
      id: widget.encounter!.id, ticketId: widget.encounter!.ticketId, patientId: widget.encounter!.patientId, providerId: widget.encounter!.providerId,
      diagnosisIds: widget.encounter!.diagnosisIds, prescriptionId: widget.encounter!.prescriptionId, labRequestIds: widget.encounter!.labRequestIds, treatmentOrderIds: [...widget.encounter!.treatmentOrderIds, t.id],
      status: widget.encounter!.status, startedAt: widget.encounter!.startedAt, endedAt: widget.encounter!.endedAt, notes: widget.encounter!.notes,
    ));
    _descController.clear();
    setState(() {});
  }
  @override
  Widget build(BuildContext context) {
    if (widget.encounter == null) return const Center(child: Text('Start encounter first'));
    final orders = ref.watch(nursingRepositoryProvider).allOrders.where((o) => widget.encounter!.treatmentOrderIds.contains(o.id)).toList();
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(controller: _descController, decoration: const InputDecoration(labelText: 'Treatment', hintText: 'e.g. Paracetamol 500 mg PO')),
          const SizedBox(height: 16),
          FilledButton.icon(onPressed: _add, icon: const Icon(Icons.add), label: const Text('Order treatment')),
          const SizedBox(height: 24),
          if (orders.isNotEmpty) ...[
            Text('Orders', style: Theme.of(context).textTheme.titleSmall),
            ...orders.map((o) => ListTile(
              title: Text(o.description),
              subtitle: Text('Due ${o.dueAt.toString().substring(11, 16)}${(o.medicationDispensed ?? false) ? ' · Dispensed' : ''}'),
              trailing: StatusChip(label: o.status.label, size: StatusChipSize.small),
            )),
          ],
        ],
      ),
    );
  }
}

class _DischargeTab extends ConsumerWidget {
  const _DischargeTab({required this.ticket, this.encounter});
  final VisitTicket ticket;
  final Encounter? encounter;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (encounter == null) return const Center(child: Text('Start encounter first'));
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: FilledButton.icon(
          onPressed: () => context.push('/discharge/${ticket.id}'),
          icon: const Icon(Icons.exit_to_app),
          label: const Text('Discharge or Admit to Ward'),
          style: FilledButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16)),
        ),
      ),
    );
  }
}
