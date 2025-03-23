using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[Serializable] // lets Unity save ojects and enables JSON serialization for API requests/responses
public class User 
{
    public long userId;
    public string fullName;
    public string email;
    public string userName;
    public string password; 
    public string dateOfBirth;
    public string gender;
}
