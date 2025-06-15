class PatientProfile {
  final String fullName;
  final String email;
  final String userName;
  final String password;
  final String dateOfBirth;
  final String gender;
  final double? anxietyLevel;
  final double? heartRate;
  final String? therapyGoal;
  final String userType = "PATIENT";

  PatientProfile({
    required this.fullName,
    required this.email,
    required this.userName,
    required this.password,
    required this.dateOfBirth,
    required this.gender,
    this.anxietyLevel,
    this.heartRate,
    this.therapyGoal,
  });

  Map<String, dynamic> toJson() => {
        "fullName": fullName,
        "email": email,
        "userName": userName,
        "password": password,
        "dateOfBirth": dateOfBirth,
        "gender": gender,
        "anxietyLevel": anxietyLevel,
        "heartRate": heartRate,
        "therapyGoal": therapyGoal,
        "userType": userType,
      };
}
