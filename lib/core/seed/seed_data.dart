import '../models/models.dart';
import '../enums/enums.dart';

/// Demo seed data for Assist Health Institute.
/// Uses realistic medical products and scenario data.
class SeedData {
  static DateTime get _now => DateTime.now();

  static List<Institute> get institutes => [
        const Institute(
          id: 'inst-1',
          name: 'Central Health Network',
          hospitalIds: ['hosp-a', 'hosp-b'],
          healthCenterIds: [],
        ),
        const Institute(
          id: 'inst-2',
          name: 'Northern Health Network',
          hospitalIds: ['hosp-c'],
          healthCenterIds: ['hc-1'],
        ),
      ];

  static List<Hospital> get hospitals => [
        const Hospital(id: 'hosp-a', name: 'Al-Rashid General Hospital', instituteId: 'inst-1', departmentIds: ['dept-er-a', 'dept-clinic-a', 'dept-ward-a']),
        const Hospital(id: 'hosp-b', name: 'Al-Zahra Medical Center', instituteId: 'inst-1', departmentIds: ['dept-er-b', 'dept-clinic-b']),
        const Hospital(id: 'hosp-c', name: 'Northern Regional Hospital', instituteId: 'inst-2', departmentIds: ['dept-er-c', 'dept-clinic-c', 'dept-ward-c']),
      ];

  static List<HealthCenter> get healthCenters => [
        const HealthCenter(id: 'hc-1', name: 'Northside Primary Care', instituteId: 'inst-2', departmentIds: ['dept-hc-1']),
      ];

  static List<Department> get departments => [
        const Department(
          id: 'dept-er-a',
          name: 'ER',
          facilityId: 'hosp-a',
          facilityType: DepartmentFacilityType.hospital,
          clinicAreaIds: ['clinic-er-a'],
          pharmacyAreaIds: ['pharm-er-a'],
          labAreaIds: ['lab-er-a'],
          nursingAreaIds: ['nurse-er-a'],
          wardIds: [],
        ),
        const Department(
          id: 'dept-clinic-a',
          name: 'Day & Night Clinics',
          facilityId: 'hosp-a',
          facilityType: DepartmentFacilityType.hospital,
          clinicAreaIds: ['clinic-day-a', 'clinic-night-a'],
          pharmacyAreaIds: ['pharm-day-a', 'pharm-night-a'],
          labAreaIds: ['lab-clinic-a'],
          nursingAreaIds: [],
          wardIds: [],
        ),
        const Department(
          id: 'dept-ward-a',
          name: 'Wards',
          facilityId: 'hosp-a',
          facilityType: DepartmentFacilityType.hospital,
          clinicAreaIds: [],
          pharmacyAreaIds: ['pharm-ward-a'],
          labAreaIds: [],
          nursingAreaIds: ['nurse-ward-a'],
          wardIds: ['ward-a1', 'ward-a2'],
        ),
        const Department(
          id: 'dept-er-b',
          name: 'ER',
          facilityId: 'hosp-b',
          facilityType: DepartmentFacilityType.hospital,
          clinicAreaIds: ['clinic-er-b'],
          pharmacyAreaIds: ['pharm-er-b'],
          labAreaIds: ['lab-er-b'],
          nursingAreaIds: ['nurse-er-b'],
          wardIds: [],
        ),
        const Department(
          id: 'dept-clinic-b',
          name: 'Clinics',
          facilityId: 'hosp-b',
          facilityType: DepartmentFacilityType.hospital,
          clinicAreaIds: ['clinic-day-b'],
          pharmacyAreaIds: ['pharm-day-b'],
          labAreaIds: ['lab-clinic-b'],
          nursingAreaIds: [],
          wardIds: [],
        ),
        const Department(
          id: 'dept-er-c',
          name: 'ER',
          facilityId: 'hosp-c',
          facilityType: DepartmentFacilityType.hospital,
          clinicAreaIds: ['clinic-er-c'],
          pharmacyAreaIds: ['pharm-er-c'],
          labAreaIds: ['lab-er-c'],
          nursingAreaIds: ['nurse-er-c'],
          wardIds: [],
        ),
        const Department(
          id: 'dept-clinic-c',
          name: 'Clinics',
          facilityId: 'hosp-c',
          facilityType: DepartmentFacilityType.hospital,
          clinicAreaIds: ['clinic-day-c'],
          pharmacyAreaIds: ['pharm-day-c'],
          labAreaIds: ['lab-clinic-c'],
          nursingAreaIds: [],
          wardIds: [],
        ),
        const Department(
          id: 'dept-ward-c',
          name: 'Wards',
          facilityId: 'hosp-c',
          facilityType: DepartmentFacilityType.hospital,
          clinicAreaIds: [],
          pharmacyAreaIds: ['pharm-ward-c'],
          labAreaIds: [],
          nursingAreaIds: ['nurse-ward-c'],
          wardIds: ['ward-c1'],
        ),
        const Department(
          id: 'dept-hc-1',
          name: 'General',
          facilityId: 'hc-1',
          facilityType: DepartmentFacilityType.healthCenter,
          clinicAreaIds: ['clinic-hc1'],
          pharmacyAreaIds: ['pharm-hc1'],
          labAreaIds: ['lab-hc1'],
          nursingAreaIds: [],
          wardIds: [],
        ),
      ];

  static List<ClinicArea> get clinicAreas => [
        const ClinicArea(id: 'clinic-er-a', name: 'ER Clinic', departmentId: 'dept-er-a', visitType: 'er'),
        const ClinicArea(id: 'clinic-day-a', name: 'Day Clinic', departmentId: 'dept-clinic-a', visitType: 'dayClinic'),
        const ClinicArea(id: 'clinic-night-a', name: 'Night Clinic', departmentId: 'dept-clinic-a', visitType: 'nightClinic'),
        const ClinicArea(id: 'clinic-er-b', name: 'ER Clinic', departmentId: 'dept-er-b', visitType: 'er'),
        const ClinicArea(id: 'clinic-day-b', name: 'Day Clinic', departmentId: 'dept-clinic-b', visitType: 'dayClinic'),
        const ClinicArea(id: 'clinic-er-c', name: 'ER Clinic', departmentId: 'dept-er-c', visitType: 'er'),
        const ClinicArea(id: 'clinic-day-c', name: 'Day Clinic', departmentId: 'dept-clinic-c', visitType: 'dayClinic'),
        const ClinicArea(id: 'clinic-hc1', name: 'General Clinic', departmentId: 'dept-hc-1', visitType: 'dayClinic'),
      ];

  static List<PharmacyArea> get pharmacyAreas => [
        const PharmacyArea(id: 'pharm-er-a', name: 'ER Pharmacy', departmentId: 'dept-er-a'),
        const PharmacyArea(id: 'pharm-day-a', name: 'Day Clinic Pharmacy', departmentId: 'dept-clinic-a'),
        const PharmacyArea(id: 'pharm-night-a', name: 'Night Clinic Pharmacy', departmentId: 'dept-clinic-a'),
        const PharmacyArea(id: 'pharm-ward-a', name: 'Wards Pharmacy', departmentId: 'dept-ward-a'),
        const PharmacyArea(id: 'pharm-er-b', name: 'ER Pharmacy', departmentId: 'dept-er-b'),
        const PharmacyArea(id: 'pharm-day-b', name: 'Day Clinic Pharmacy', departmentId: 'dept-clinic-b'),
        const PharmacyArea(id: 'pharm-er-c', name: 'ER Pharmacy', departmentId: 'dept-er-c'),
        const PharmacyArea(id: 'pharm-day-c', name: 'Day Clinic Pharmacy', departmentId: 'dept-clinic-c'),
        const PharmacyArea(id: 'pharm-ward-c', name: 'Wards Pharmacy', departmentId: 'dept-ward-c'),
        const PharmacyArea(id: 'pharm-hc1', name: 'Pharmacy', departmentId: 'dept-hc-1'),
      ];

  static List<LabArea> get labAreas => [
        const LabArea(id: 'lab-er-a', name: 'ER Lab', departmentId: 'dept-er-a'),
        const LabArea(id: 'lab-clinic-a', name: 'Clinics Lab', departmentId: 'dept-clinic-a'),
        const LabArea(id: 'lab-er-b', name: 'ER Lab', departmentId: 'dept-er-b'),
        const LabArea(id: 'lab-clinic-b', name: 'Clinics Lab', departmentId: 'dept-clinic-b'),
        const LabArea(id: 'lab-er-c', name: 'ER Lab', departmentId: 'dept-er-c'),
        const LabArea(id: 'lab-clinic-c', name: 'Clinics Lab', departmentId: 'dept-clinic-c'),
        const LabArea(id: 'lab-hc1', name: 'Lab', departmentId: 'dept-hc-1'),
      ];

  static List<NursingArea> get nursingAreas => [
        const NursingArea(id: 'nurse-er-a', name: 'ER Nursing', departmentId: 'dept-er-a'),
        const NursingArea(id: 'nurse-ward-a', name: 'Wards Nursing', departmentId: 'dept-ward-a'),
        const NursingArea(id: 'nurse-er-b', name: 'ER Nursing', departmentId: 'dept-er-b'),
        const NursingArea(id: 'nurse-er-c', name: 'ER Nursing', departmentId: 'dept-er-c'),
        const NursingArea(id: 'nurse-ward-c', name: 'Wards Nursing', departmentId: 'dept-ward-c'),
      ];

  static List<Ward> get wards => [
        const Ward(id: 'ward-a1', name: 'Ward A1', departmentId: 'dept-ward-a'),
        const Ward(id: 'ward-a2', name: 'Ward A2', departmentId: 'dept-ward-a'),
        const Ward(id: 'ward-c1', name: 'Ward C1', departmentId: 'dept-ward-c'),
      ];

  static List<User> get users => [
        const User(id: 'u-reg', name: 'Samira Hassan', role: UserRole.registrationClerk, facilityId: 'hosp-a'),
        const User(id: 'u-doc', name: 'Dr. Omar Khalil', role: UserRole.doctor, facilityId: 'hosp-a', departmentId: 'dept-er-a'),
        const User(id: 'u-pharm', name: 'Layla Fathi', role: UserRole.pharmacist, facilityId: 'hosp-a', departmentId: 'dept-er-a'),
        const User(id: 'u-lab', name: 'Youssef Ibrahim', role: UserRole.labTechnician, facilityId: 'hosp-a'),
        const User(id: 'u-nurse', name: 'Nadia Salem', role: UserRole.nurse, facilityId: 'hosp-a', departmentId: 'dept-er-a'),
        const User(id: 'u-inv', name: 'Karim Abbas', role: UserRole.inventoryOfficer, facilityId: 'hosp-a'),
        const User(id: 'u-sup', name: 'Rania Mohamed', role: UserRole.supervisor),
      ];

  static List<Patient> get patients {
    final base = DateTime(_now.year - 35, 3, 15);
    return [
      Patient(id: 'p-1', name: 'Ahmed Mahmoud', dateOfBirth: base.subtract(const Duration(days: 365 * 28)), sex: 'M', allergies: ['Penicillin'], medicalRecordNumber: 'MRN001'),
      Patient(id: 'p-2', name: 'Fatima Ali', dateOfBirth: base.subtract(const Duration(days: 365 * 45)), sex: 'F', allergies: [], medicalRecordNumber: 'MRN002'),
      Patient(id: 'p-3', name: 'Hassan Ibrahim', dateOfBirth: base.subtract(const Duration(days: 365 * 62)), sex: 'M', allergies: ['Sulfa'], medicalRecordNumber: 'MRN003'),
      Patient(id: 'p-4', name: 'Mona Said', dateOfBirth: base.subtract(const Duration(days: 365 * 5)), sex: 'F', allergies: [], medicalRecordNumber: 'MRN004'),
      Patient(id: 'p-5', name: 'Khaled Nour', dateOfBirth: base.subtract(const Duration(days: 365 * 38)), sex: 'M', allergies: [], medicalRecordNumber: 'MRN005'),
      Patient(id: 'p-6', name: 'Sara Mohamed', dateOfBirth: base.subtract(const Duration(days: 365 * 22)), sex: 'F', allergies: ['Latex'], medicalRecordNumber: 'MRN006'),
      Patient(id: 'p-7', name: 'Tariq Hussein', dateOfBirth: base.subtract(const Duration(days: 365 * 55)), sex: 'M', allergies: [], medicalRecordNumber: 'MRN007'),
      Patient(id: 'p-8', name: 'Lina Farouk', dateOfBirth: base.subtract(const Duration(days: 365 * 31)), sex: 'F', allergies: [], medicalRecordNumber: 'MRN008'),
      Patient(id: 'p-9', name: 'Omar Rashid', dateOfBirth: base.subtract(const Duration(days: 365 * 70)), sex: 'M', allergies: ['NSAIDs'], medicalRecordNumber: 'MRN009'),
      Patient(id: 'p-10', name: 'Dina Kamal', dateOfBirth: base.subtract(const Duration(days: 365 * 19)), sex: 'F', allergies: [], medicalRecordNumber: 'MRN010'),
      Patient(id: 'p-11', name: 'Amir Bassem', dateOfBirth: base.subtract(const Duration(days: 365 * 41)), sex: 'M', allergies: [], medicalRecordNumber: 'MRN011'),
      Patient(id: 'p-12', name: 'Yasmin Haddad', dateOfBirth: base.subtract(const Duration(days: 365 * 27)), sex: 'F', allergies: [], medicalRecordNumber: 'MRN012'),
    ];
  }

  // National identifiers and brands
  static const String pidAmox = 'pid-amox';
  static const String pidCeft = 'pid-ceft';
  static const String pidPara = 'pid-para';
  static const String pidMero = 'pid-mero';
  static const String pidOme = 'pid-ome';
  static const String pidSaline = 'pid-saline';
  static const String pidSyringe = 'pid-syringe';
  static const String pidGloves = 'pid-gloves';

  static List<ProductNationalIdentifier> get productNationalIdentifiers => [
        const ProductNationalIdentifier(id: pidAmox, name: 'Amoxicillin', form: '500 mg capsule', brandIds: ['brand-jamox', 'brand-amoxi']),
        const ProductNationalIdentifier(id: pidCeft, name: 'Ceftriaxone', form: '1 g vial', brandIds: ['brand-ceft-gen', 'brand-rocephin']),
        const ProductNationalIdentifier(id: pidPara, name: 'Paracetamol', form: '500 mg tablet', brandIds: ['brand-panadol', 'brand-generic-para']),
        const ProductNationalIdentifier(id: pidMero, name: 'Meropenem', form: '1 g vial', brandIds: ['brand-merrem']),
        const ProductNationalIdentifier(id: pidOme, name: 'Omeprazole', form: '20 mg capsule', brandIds: ['brand-losec', 'brand-generic-ome']),
        const ProductNationalIdentifier(id: pidSaline, name: 'Normal Saline', form: 'IV 0.9% 500 mL', brandIds: ['brand-saline-gen']),
        const ProductNationalIdentifier(id: pidSyringe, name: 'Syringe', form: '10 mL', brandIds: ['brand-bd-syringe']),
        const ProductNationalIdentifier(id: pidGloves, name: 'Gloves', form: 'Exam gloves', brandIds: ['brand-gloves-gen']),
        const ProductNationalIdentifier(id: 'pid-ibu', name: 'Ibuprofen', form: '400 mg tablet', brandIds: ['brand-ibu-gen']),
        const ProductNationalIdentifier(id: 'pid-metro', name: 'Metronidazole', form: '500 mg tablet', brandIds: ['brand-flagyl']),
      ];

  static List<ProductBrand> get productBrands => [
        const ProductBrand(id: 'brand-jamox', productNationalId: pidAmox, brandName: 'Jamox', companyName: 'Jam Pharma', batchIds: ['batch-jamox-1', 'batch-jamox-2']),
        const ProductBrand(id: 'brand-amoxi', productNationalId: pidAmox, brandName: 'Amoxi', companyName: 'Amoxi Co', batchIds: ['batch-amoxi-1']),
        const ProductBrand(id: 'brand-ceft-gen', productNationalId: pidCeft, brandName: 'Ceftriaxone Generic', companyName: 'GenMed', batchIds: ['batch-ceft-a1', 'batch-ceft-a2', 'batch-ceft-b1']),
        const ProductBrand(id: 'brand-rocephin', productNationalId: pidCeft, brandName: 'Rocephin', companyName: 'Roche', batchIds: ['batch-rocephin-1']),
        const ProductBrand(id: 'brand-panadol', productNationalId: pidPara, brandName: 'Panadol', companyName: 'GSK', batchIds: ['batch-panadol-1']),
        const ProductBrand(id: 'brand-generic-para', productNationalId: pidPara, brandName: 'Paracetamol Generic', companyName: 'Generic Co', batchIds: ['batch-gpara-1']),
        const ProductBrand(id: 'brand-merrem', productNationalId: pidMero, brandName: 'Merrem', companyName: 'AstraZeneca', batchIds: ['batch-merrem-1']),
        const ProductBrand(id: 'brand-losec', productNationalId: pidOme, brandName: 'Losec', companyName: 'AstraZeneca', batchIds: ['batch-losec-1']),
        const ProductBrand(id: 'brand-generic-ome', productNationalId: pidOme, brandName: 'Omeprazole Generic', companyName: 'Generic Co', batchIds: ['batch-gome-1']),
        const ProductBrand(id: 'brand-saline-gen', productNationalId: pidSaline, brandName: 'Normal Saline', companyName: 'Baxter', batchIds: ['batch-saline-1']),
        const ProductBrand(id: 'brand-bd-syringe', productNationalId: pidSyringe, brandName: 'BD Syringe', companyName: 'BD', batchIds: ['batch-syr-1']),
        const ProductBrand(id: 'brand-gloves-gen', productNationalId: pidGloves, brandName: 'Exam Gloves', companyName: 'MedSupply', batchIds: ['batch-gloves-1', 'batch-gloves-2']),
        const ProductBrand(id: 'brand-ibu-gen', productNationalId: 'pid-ibu', brandName: 'Ibuprofen Generic', companyName: 'Generic Co', batchIds: ['batch-ibu-1']),
        const ProductBrand(id: 'brand-flagyl', productNationalId: 'pid-metro', brandName: 'Flagyl', companyName: 'Sanofi', batchIds: ['batch-flagyl-1']),
      ];

  static List<StockLocation> get stockLocations => [
        const StockLocation(id: 'loc-drug-depot', name: 'DRUG DEPOT', facilityId: 'inst-1', locationType: 'depot'),
        const StockLocation(id: 'loc-inv-a', name: 'Al-Rashid Central Inventory', facilityId: 'hosp-a', locationType: 'central'),
        const StockLocation(id: 'loc-inv-b', name: 'Al-Zahra Central Inventory', facilityId: 'hosp-b', locationType: 'central'),
        const StockLocation(id: 'loc-inv-c', name: 'Northern Regional Inventory', facilityId: 'hosp-c', locationType: 'central'),
        const StockLocation(id: 'pharm-er-a', name: 'Al-Rashid ER Pharmacy', facilityId: 'hosp-a', locationType: 'pharmacy'),
        const StockLocation(id: 'pharm-day-a', name: 'Al-Rashid Day Clinic Pharmacy', facilityId: 'hosp-a', locationType: 'pharmacy'),
        const StockLocation(id: 'pharm-er-b', name: 'Al-Zahra ER Pharmacy', facilityId: 'hosp-b', locationType: 'pharmacy'),
        const StockLocation(id: 'pharm-er-c', name: 'Northern Regional ER Pharmacy', facilityId: 'hosp-c', locationType: 'pharmacy'),
        const StockLocation(id: 'pharm-ward-a', name: 'Al-Rashid Wards Pharmacy', facilityId: 'hosp-a', locationType: 'pharmacy'),
        const StockLocation(id: 'pharm-ward-c', name: 'Northern Regional Wards Pharmacy', facilityId: 'hosp-c', locationType: 'pharmacy'),
        const StockLocation(id: 'pharm-hc1', name: 'Northside Primary Pharmacy', facilityId: 'hc-1', locationType: 'pharmacy'),
      ];

  static List<StockBatch> get stockBatches {
    final now = _now;
    return [
      StockBatch(id: 'batch-jamox-depot', productBrandId: 'brand-jamox', locationId: 'loc-drug-depot', batchNumber: 'JX-DEPOT-001', expiryDate: now.add(const Duration(days: 400)), quantity: 2000, receivedAt: now.subtract(const Duration(days: 15))),
      StockBatch(id: 'batch-amoxi-depot', productBrandId: 'brand-amoxi', locationId: 'loc-drug-depot', batchNumber: 'AX-DEPOT-001', expiryDate: now.add(const Duration(days: 450)), quantity: 1500, receivedAt: now.subtract(const Duration(days: 10))),
      StockBatch(id: 'batch-jamox-1', productBrandId: 'brand-jamox', locationId: 'pharm-er-a', batchNumber: 'JX2024-001', expiryDate: now.add(const Duration(days: 180)), quantity: 500, receivedAt: now.subtract(const Duration(days: 30))),
      StockBatch(id: 'batch-jamox-2', productBrandId: 'brand-jamox', locationId: 'pharm-er-a', batchNumber: 'JX2024-002', expiryDate: now.add(const Duration(days: 350)), quantity: 200, receivedAt: now.subtract(const Duration(days: 10))),
      StockBatch(id: 'batch-amoxi-1', productBrandId: 'brand-amoxi', locationId: 'pharm-day-a', batchNumber: 'AX2024-001', expiryDate: now.add(const Duration(days: 200)), quantity: 300, receivedAt: now.subtract(const Duration(days: 20))),
      StockBatch(id: 'batch-ceft-a1', productBrandId: 'brand-ceft-gen', locationId: 'loc-inv-a', batchNumber: 'CF-A-001', expiryDate: now.add(const Duration(days: 210)), quantity: 450, receivedAt: now.subtract(const Duration(days: 60))),
      StockBatch(id: 'batch-ceft-a2', productBrandId: 'brand-ceft-gen', locationId: 'loc-inv-a', batchNumber: 'CF-A-002', expiryDate: now.add(const Duration(days: 180)), quantity: 120, receivedAt: now.subtract(const Duration(days: 90))),
      StockBatch(id: 'batch-ceft-b1', productBrandId: 'brand-ceft-gen', locationId: 'loc-inv-b', batchNumber: 'CF-B-001', expiryDate: now.add(const Duration(days: 300)), quantity: 30, receivedAt: now.subtract(const Duration(days: 5))),
      StockBatch(id: 'batch-rocephin-1', productBrandId: 'brand-rocephin', locationId: 'pharm-er-c', batchNumber: 'RO-2024-01', expiryDate: now.add(const Duration(days: 400)), quantity: 80, receivedAt: now.subtract(const Duration(days: 15))),
      StockBatch(id: 'batch-panadol-1', productBrandId: 'brand-panadol', locationId: 'pharm-er-a', batchNumber: 'PN-2024-01', expiryDate: now.add(const Duration(days: 500)), quantity: 1000, receivedAt: now.subtract(const Duration(days: 25))),
      StockBatch(id: 'batch-panadol-depot', productBrandId: 'brand-panadol', locationId: 'loc-drug-depot', batchNumber: 'PN-DEPOT-01', expiryDate: now.add(const Duration(days: 550)), quantity: 3000, receivedAt: now.subtract(const Duration(days: 20))),
      StockBatch(id: 'batch-gpara-1', productBrandId: 'brand-generic-para', locationId: 'pharm-day-a', batchNumber: 'GP-001', expiryDate: now.add(const Duration(days: 365)), quantity: 800, receivedAt: now.subtract(const Duration(days: 40))),
      StockBatch(id: 'batch-merrem-1', productBrandId: 'brand-merrem', locationId: 'loc-inv-a', batchNumber: 'MR-2024-01', expiryDate: now.add(const Duration(days: 120)), quantity: 25, receivedAt: now.subtract(const Duration(days: 100))),
      StockBatch(id: 'batch-losec-1', productBrandId: 'brand-losec', locationId: 'pharm-er-a', batchNumber: 'LS-2024-01', expiryDate: now.add(const Duration(days: 270)), quantity: 400, receivedAt: now.subtract(const Duration(days: 20))),
      StockBatch(id: 'batch-gome-1', productBrandId: 'brand-generic-ome', locationId: 'pharm-day-a', batchNumber: 'GO-001', expiryDate: now.add(const Duration(days: 400)), quantity: 350, receivedAt: now.subtract(const Duration(days: 15))),
      StockBatch(id: 'batch-saline-1', productBrandId: 'brand-saline-gen', locationId: 'loc-inv-a', batchNumber: 'NS-2024-01', expiryDate: now.add(const Duration(days: 450)), quantity: 200, receivedAt: now.subtract(const Duration(days: 30))),
      StockBatch(id: 'batch-syr-1', productBrandId: 'brand-bd-syringe', locationId: 'pharm-er-a', batchNumber: 'BD-2024-01', expiryDate: now.add(const Duration(days: 600)), quantity: 500, receivedAt: now.subtract(const Duration(days: 10))),
      StockBatch(id: 'batch-gloves-1', productBrandId: 'brand-gloves-gen', locationId: 'pharm-er-a', batchNumber: 'GL-2024-01', expiryDate: now.add(const Duration(days: 60)), quantity: 200, receivedAt: now.subtract(const Duration(days: 120))),
      StockBatch(id: 'batch-gloves-2', productBrandId: 'brand-gloves-gen', locationId: 'pharm-er-a', batchNumber: 'GL-2024-02', expiryDate: now.add(const Duration(days: 400)), quantity: 1500, receivedAt: now.subtract(const Duration(days: 5))),
      StockBatch(id: 'batch-ibu-1', productBrandId: 'brand-ibu-gen', locationId: 'pharm-day-a', batchNumber: 'IB-001', expiryDate: now.add(const Duration(days: 350)), quantity: 600, receivedAt: now.subtract(const Duration(days: 20))),
      StockBatch(id: 'batch-flagyl-1', productBrandId: 'brand-flagyl', locationId: 'pharm-er-a', batchNumber: 'FL-2024-01', expiryDate: now.add(const Duration(days: 280)), quantity: 150, receivedAt: now.subtract(const Duration(days: 35))),
    ];
  }

  static List<DemandSignal> get demandSignals => [
        DemandSignal(id: 'ds-1', productNationalId: pidMero, locationId: 'pharm-er-b', requestCount: 5, lastRequestedAt: _now.subtract(const Duration(days: 2))),
        DemandSignal(id: 'ds-2', productNationalId: pidCeft, locationId: 'pharm-er-b', requestCount: 8, lastRequestedAt: _now.subtract(const Duration(days: 1))),
      ];

  static List<SupplyRequest> get supplyRequests => [
        SupplyRequest(id: 'sr-1', requestingLocationId: 'pharm-er-b', productNationalId: pidCeft, quantity: 50, status: SupplyRequestStatus.pending, requestedAt: _now.subtract(const Duration(hours: 4))),
        SupplyRequest(id: 'sr-2', requestingLocationId: 'pharm-day-a', productNationalId: pidPara, quantity: 100, status: SupplyRequestStatus.approved, fulfillmentIds: [], requestedAt: _now.subtract(const Duration(hours: 2))),
        SupplyRequest(id: 'sr-3', requestingLocationId: 'pharm-er-c', productNationalId: pidMero, quantity: 20, status: SupplyRequestStatus.pending, requestedAt: _now.subtract(const Duration(hours: 1))),
      ];

  static List<SupplyReceipt> get supplyReceipts => [
        SupplyReceipt(
          id: 'rec-1',
          receivedAt: _now.subtract(const Duration(days: 5)),
          sourceType: SupplySourceType.healthDepartmentSupply,
          supplierName: 'Regional Health Department',
          referenceNumber: 'HD-2024-001',
          lineItems: [
            SupplyReceiptLine(productBrandId: 'brand-jamox', batchNumber: 'JX-DEPOT-001', quantity: 2000, expiryDate: _now.add(const Duration(days: 400))),
            SupplyReceiptLine(productBrandId: 'brand-amoxi', batchNumber: 'AX-DEPOT-001', quantity: 1500, expiryDate: _now.add(const Duration(days: 450))),
          ],
        ),
        SupplyReceipt(
          id: 'rec-2',
          receivedAt: _now.subtract(const Duration(days: 12)),
          sourceType: SupplySourceType.thirdPartyPurchase,
          supplierName: 'MedSupply Co',
          referenceNumber: 'PO-7892',
          lineItems: [
            SupplyReceiptLine(productBrandId: 'brand-panadol', batchNumber: 'PN-DEPOT-01', quantity: 3000, expiryDate: _now.add(const Duration(days: 550))),
          ],
        ),
      ];

  static List<TransferSuggestion> get transferSuggestions => [
        TransferSuggestion(
          id: 'ts-1',
          productNationalId: pidCeft,
          sourceLocationId: 'loc-inv-a',
          destinationLocationId: 'loc-inv-b',
          sourceInstituteId: 'inst-1',
          destinationInstituteId: 'inst-1',
          quantity: 120,
          reasons: ['Al-Rashid has 570 units of Ceftriaxone with batches expiring in 6–7 months', 'Al-Zahra ER Pharmacy has only 30 units and 8 requests in the last 48 hours'],
          priority: RecommendationPriority.high,
          estimatedWastePrevented: 80,
          shortageRelief: true,
          expiryPrevention: true,
          createdAt: _now.subtract(const Duration(hours: 1)),
        ),
        TransferSuggestion(
          id: 'ts-2',
          productNationalId: pidCeft,
          sourceLocationId: 'loc-inv-a',
          destinationLocationId: 'loc-inv-c',
          sourceInstituteId: 'inst-1',
          destinationInstituteId: 'inst-2',
          quantity: 60,
          reasons: ['Northern Regional can use additional Ceftriaxone before the CF-A-002 batch expires in ~6 months'],
          priority: RecommendationPriority.medium,
          estimatedWastePrevented: 40,
          shortageRelief: false,
          expiryPrevention: true,
          createdAt: _now.subtract(const Duration(hours: 1)),
        ),
      ];

  static List<VisitTicket> get visitTickets {
    final t = _now;
    return [
      VisitTicket(
        id: 'ticket-1',
        patientId: 'p-1',
        visitType: VisitType.er,
        status: VisitStatus.inProgress,
        queueNumber: 3,
        destinationClinicAreaId: 'clinic-er-a',
        facilityId: 'hosp-a',
        qrPayload: 'TICKET:ticket-1',
        encounterId: 'enc-1',
        createdAt: t.subtract(const Duration(hours: 2)),
      ),
      VisitTicket(
        id: 'ticket-2',
        patientId: 'p-2',
        visitType: VisitType.dayClinic,
        status: VisitStatus.awaitingPharmacy,
        queueNumber: 7,
        destinationClinicAreaId: 'clinic-day-a',
        facilityId: 'hosp-a',
        qrPayload: 'TICKET:ticket-2',
        encounterId: 'enc-2',
        createdAt: t.subtract(const Duration(hours: 1)),
      ),
      VisitTicket(
        id: 'ticket-3',
        patientId: 'p-3',
        visitType: VisitType.er,
        status: VisitStatus.queued,
        queueNumber: 5,
        destinationClinicAreaId: 'clinic-er-a',
        facilityId: 'hosp-a',
        createdAt: t.subtract(const Duration(minutes: 30)),
      ),
    ];
  }

  static List<Encounter> get encounters => [
        Encounter(
          id: 'enc-1',
          ticketId: 'ticket-1',
          patientId: 'p-1',
          providerId: 'u-doc',
          diagnosisIds: ['diag-1'],
          prescriptionId: 'rx-1',
          labRequestIds: ['labreq-1'],
          treatmentOrderIds: ['treat-1'],
          status: VisitStatus.inProgress,
          startedAt: _now.subtract(const Duration(hours: 1, minutes: 45)),
          notes: null,
        ),
        Encounter(
          id: 'enc-2',
          ticketId: 'ticket-2',
          patientId: 'p-2',
          providerId: 'u-doc',
          diagnosisIds: ['diag-2'],
          prescriptionId: 'rx-2',
          labRequestIds: [],
          treatmentOrderIds: [],
          status: VisitStatus.awaitingPharmacy,
          startedAt: _now.subtract(const Duration(hours: 1)),
          endedAt: null,
          notes: null,
        ),
      ];

  static List<Diagnosis> get diagnoses => [
        const Diagnosis(id: 'diag-1', encounterId: 'enc-1', code: 'J06.9', description: 'Acute upper respiratory infection', notes: 'Mild', recordedAt: null),
        const Diagnosis(id: 'diag-2', encounterId: 'enc-2', code: 'K21.0', description: 'Gastroesophageal reflux disease', notes: null, recordedAt: null),
      ];

  static List<Prescription> get prescriptions => [
        Prescription(
          id: 'rx-1',
          encounterId: 'enc-1',
          patientId: 'p-1',
          items: [
            PrescriptionItem(id: 'rxi-1', prescriptionId: 'rx-1', productNationalId: pidAmox, quantity: 21, instructions: 'One capsule TID for 7 days', dispensedQuantity: 0),
            PrescriptionItem(id: 'rxi-2', prescriptionId: 'rx-1', productNationalId: pidPara, quantity: 20, instructions: 'As needed for fever', dispensedQuantity: 0),
          ],
          status: PrescriptionStatus.pending,
          pharmacyAreaId: 'pharm-er-a',
          createdAt: _now.subtract(const Duration(hours: 1, minutes: 30)),
        ),
        Prescription(
          id: 'rx-2',
          encounterId: 'enc-2',
          patientId: 'p-2',
          items: [
            PrescriptionItem(id: 'rxi-3', prescriptionId: 'rx-2', productNationalId: pidOme, quantity: 30, instructions: 'Once daily before breakfast', dispensedQuantity: 0),
          ],
          status: PrescriptionStatus.pending,
          pharmacyAreaId: 'pharm-day-a',
          createdAt: _now.subtract(const Duration(minutes: 45)),
        ),
      ];

  static List<LabRequest> get labRequests => [
        LabRequest(
          id: 'labreq-1',
          encounterId: 'enc-1',
          patientId: 'p-1',
          testName: 'CBC',
          status: LabRequestStatus.completed,
          resultId: 'labres-1',
          completedAt: _now.subtract(const Duration(minutes: 50)),
        ),
        LabRequest(
          id: 'labreq-2',
          encounterId: 'enc-1',
          patientId: 'p-1',
          testName: 'CRP',
          status: LabRequestStatus.requested,
        ),
      ];

  static List<LabResult> get labResults => [
        const LabResult(
          id: 'labres-1',
          labRequestId: 'labreq-1',
          value: '14.2',
          unit: '10^9/L',
          referenceRange: '4.0–11.0',
          interpretation: 'Mild leukocytosis',
          completedAt: null,
          enteredById: 'u-lab',
          resultImageBase64: null,
        ),
      ];

  static List<TreatmentOrder> get treatmentOrders => [
        TreatmentOrder(
          id: 'treat-1',
          encounterId: 'enc-1',
          patientId: 'p-1',
          description: 'Paracetamol 500 mg PO',
          dueAt: _now.add(const Duration(minutes: 30)),
          status: TreatmentStatus.pending,
          notes: null,
          medicationDispensed: false,
        ),
      ];

  static List<QueueEntry> get queueEntries => [
        const QueueEntry(id: 'qe-1', ticketId: 'ticket-1', patientId: 'p-1', areaId: 'clinic-er-a', areaType: 'clinic', queueNumber: 3, status: QueueStatus.inProgress),
        const QueueEntry(id: 'qe-2', ticketId: 'ticket-2', patientId: 'p-2', areaId: 'pharm-day-a', areaType: 'pharmacy', queueNumber: 1, status: QueueStatus.waiting),
        const QueueEntry(id: 'qe-3', ticketId: 'ticket-3', patientId: 'p-3', areaId: 'clinic-er-a', areaType: 'clinic', queueNumber: 5, status: QueueStatus.waiting),
      ];
}
