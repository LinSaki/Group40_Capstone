class Session {
  final int sessionId;
  final DateTime sessionDate;
  final int sessionDuration;
  final String scenarioUsed;
  final String feedback;

  final int? patientId;
  final String? patientName;
  final int? therapistId;
  final String? therapistName;

  Session({
    required this.sessionId,
    required this.sessionDate,
    required this.sessionDuration,
    required this.scenarioUsed,
    required this.feedback,
    this.patientId,
    this.patientName,
    this.therapistId,
    this.therapistName,
  });

  factory Session.fromJson(Map<String, dynamic> json) {
    return Session(
      sessionId: json['sessionId'],
      sessionDate: DateTime.parse(json['sessionDate']),
      sessionDuration: json['sessionDuration'],
      scenarioUsed: json['scenarioUsed'],
      feedback: json['feedback'],
      patientId: json['patient']?['userId'],
      patientName: json['patient']?['fullName'],
      therapistId: json['therapist']?['userId'],
      therapistName: json['therapist']?['fullName'],
    );
  }

  Map<String, dynamic> toJson() => {
        'sessionId': sessionId,
        'sessionDate': sessionDate.toIso8601String(),
        'sessionDuration': sessionDuration,
        'scenarioUsed': scenarioUsed,
        'feedback': feedback,
        if (patientId != null) 'patientId': patientId,
      };
}
