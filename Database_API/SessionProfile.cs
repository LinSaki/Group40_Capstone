using Unity.VisualScripting;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System;
using Newtonsoft.Json;//deserialize and use jsonproperty attriibute

[Serializable]
public class SessionProfile
{
    [JsonProperty("sessionId")]
    public long sessionId; // Session ID

    [JsonProperty("sessionDate")]
    public string sessionDate; // Date as a string (you can parse it later)

    [JsonProperty("sessionDuration")]
    public int sessionDuration; // Session Duration

    [JsonProperty("scenarioUsed")]
    public string scenarioUsed; // Scenario Used

    [JsonProperty("feedback")]
    public string feedback; // Feedback

    [JsonProperty("therapistName")]
    public string therapistName; // Therapist Name

    [JsonProperty("therapistLicense")]
    public string therapistLicense; // Therapist License

    [JsonProperty("patientName")]
    public string patientName; // Patient Name

    [JsonProperty("patientGoal")]
    public string patientGoal; // Patient Goal

    public TherapistProfile therapist; 
    public PatientProfile patient; 
    public ProgressTracker progressTracker; 
}
