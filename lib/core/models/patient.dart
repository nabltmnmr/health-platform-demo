/// Patient with digital medical profile.
class Patient {
  const Patient({
    required this.id,
    required this.name,
    this.dateOfBirth,
    this.sex,
    this.allergies = const [],
    this.medicalRecordNumber,
    this.phone,
    this.address,
  });

  final String id;
  final String name;
  final DateTime? dateOfBirth;
  final String? sex;
  final List<String> allergies;
  final String? medicalRecordNumber;
  final String? phone;
  final String? address;

  int? get ageYears {
    if (dateOfBirth == null) return null;
    final now = DateTime.now();
    var age = now.year - dateOfBirth!.year;
    if (now.month < dateOfBirth!.month ||
        (now.month == dateOfBirth!.month && now.day < dateOfBirth!.day)) {
      age--;
    }
    return age;
  }
}
