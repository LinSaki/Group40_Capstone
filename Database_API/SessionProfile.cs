using Unity.VisualScripting;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System;
using Newtonsoft.Json;//deserialize and use jsonproperty attriibute

[Serializable]
public class SessionProfile
{
    public long sessionId;
    public string sessionDate;
    public int sessionDuration;
    public string therapistName;
    public string therapistLicense;
    public string patientName;
    public string patientGoal;
}
