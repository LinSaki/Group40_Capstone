using Unity.VisualScripting;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System;

[Serializable]
public class PatientProfile : User
{
    public double anxietyLevel;
    public double heartRate;
    public string therapyGoal;

    public List<Session> sessions;
    public List<PhysiologicalData> physiologicalData;
    public ProgressTracker progressTracker;
}

[Serializable]
public class Session
{
    public long sessionId;
    public string sessionDate;
    public string sessionNotes;
}

[Serializable]
public class PhysiologicalData
{
    public long dataId;
    public string timestamp;
    public double heartRate;
    public double respirationRate;
}

[Serializable]
public class ProgressTracker
{
    public long trackerId;
    public string progressNotes;
}
