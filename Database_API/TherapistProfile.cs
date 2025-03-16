using Unity.VisualScripting;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System;

[Serializable]
public class TherapistProfile : User
{
    public string licenseNumber;
    public string specialization;
    public int experienceYears;

    public List<Session> sessions;
    public List<Scenario> scenarios;
    public List<Customization> customizations;
}

[Serializable]
public class Scenario
{
    public long scenarioId;
    public string scenarioName;
    public string description;
}

[Serializable]
public class Customization
{
    public long customizationId;
    public string customizationType;
    public string details;
}
