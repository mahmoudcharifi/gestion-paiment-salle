class MemberModel {
  final int? id;
  final String firstName;
  final String lastName;
  final String phone;
  final String? cin;
  final String? guardianName;
  final String? guardianPhone;
  final String? birthDate;
  final String? photoPath;
  final String qrCode;
  final String registrationDate;
  final int isActive;
  final String? notes;
  final String createdAt;
  final String updatedAt;

  MemberModel({
    this.id,
    required this.firstName,
    required this.lastName,
    required this.phone,
    this.cin,
    this.guardianName,
    this.guardianPhone,
    this.birthDate,
    this.photoPath,
    required this.qrCode,
    required this.registrationDate,
    required this.isActive,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'phone': phone,
      'cin': cin,
      'guardian_name': guardianName,
      'guardian_phone': guardianPhone,
      'birth_date': birthDate,
      'photo_path': photoPath,
      'qr_code': qrCode,
      'registration_date': registrationDate,
      'is_active': isActive,
      'notes': notes,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  factory MemberModel.fromMap(Map<String, dynamic> map) {
    return MemberModel(
      id: map['id'],
      firstName: map['first_name'] ?? '',
      lastName: map['last_name'] ?? '',
      phone: map['phone'] ?? '',
      cin: map['cin'],
      guardianName: map['guardian_name'],
      guardianPhone: map['guardian_phone'],
      birthDate: map['birth_date'],
      photoPath: map['photo_path'],
      qrCode: map['qr_code'] ?? '',
      registrationDate: map['registration_date'] ?? '',
      isActive: map['is_active'] ?? 1,
      notes: map['notes'],
      createdAt: map['created_at'] ?? '',
      updatedAt: map['updated_at'] ?? '',
    );
  }
}