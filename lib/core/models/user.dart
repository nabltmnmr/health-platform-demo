import '../enums/enums.dart';

/// User for demo role switching.
class User {
  const User({
    required this.id,
    required this.name,
    required this.role,
    this.facilityId,
    this.departmentId,
  });

  final String id;
  final String name;
  final UserRole role;
  final String? facilityId;
  final String? departmentId;

  /// Display name: "Ph." prefix for pharmacists, otherwise [name].
  String get displayName => role == UserRole.pharmacist ? 'Ph. $name' : name;
}
