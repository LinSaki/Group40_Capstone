class TherapistProfile {
  final String fullName;
  final String email;
  final String userName;
  final String password;
  final String dateOfBirth;
  final String gender;
  final String? licenseNumber;
  final String? specialization;
  final int? experienceYears;
  final String userType = "THERAPIST";

  TherapistProfile({
    required this.fullName,
    required this.email,
    required this.userName,
    required this.password,
    required this.dateOfBirth,
    required this.gender,
    this.licenseNumber,
    this.specialization,
    this.experienceYears,
  });

  Map<String, dynamic> toJson() => {
        "fullName": fullName,
        "email": email,
        "userName": userName,
        "password": password,
        "dateOfBirth": dateOfBirth,
        "gender": gender,
        "licenseNumber": licenseNumber,
        "specialization": specialization,
        "experienceYears": experienceYears,
        "userType": userType,
      };
}
