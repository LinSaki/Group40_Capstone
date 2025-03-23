using System.Collections;
using UnityEngine;
using UnityEngine.Networking;
using UnityEngine.UI;
using TMPro;
using UnityEngine.SceneManagement;
using System.Collections.Generic;
using System;

public class GetApiData : MonoBehaviour
{
    public string URL;
    public InputField id;
    public TMP_Text dateText;
    public TMP_Text dateDetailText;
    public GameObject sessionDetailPanel;
    public GameObject sessionListPanel;
    public GameObject sessionRowButtonPrefab;
    public Transform detailContainerPanel;
    public TMP_Text userNameListText;
    public TMP_Text userNameDetailText;

    public TMP_Text sessionIdText, sessionDateText, sessionDurationText;
    public TMP_Text therapistNameText, therapistLicenseText, patientNameText, patientGoalText;

    private string authToken;
    private string userRole;
    private string userId;

    public class SessionList //list of SessionProfile
    {
        public List<SessionProfile> sessions;
    }

    public void GoDetails()
    {
        sessionListPanel.SetActive(false);
        sessionDetailPanel.SetActive(true);
    }

    public void GoBackToList()
    {
        sessionDetailPanel.SetActive(false);
        sessionListPanel.SetActive(true);
    }

    void Start()
    {
        authToken = PlayerPrefs.GetString("AuthToken", "");
        userRole = PlayerPrefs.GetString("UserRole", "");
        userId = PlayerPrefs.GetString("UserId", "");

        Debug.Log("Start() Called in GetApiData");
        Debug.Log("Retrieved AuthToken: " + authToken);
        Debug.Log("Retrieved UserRole: " + userRole);
        Debug.Log("Retrieved UserId: " + userId);


        if (!string.IsNullOrEmpty(userId))
        {
            userNameListText.text = "Logged in as: " + PlayerPrefs.GetString("UserId", userId);
            userNameDetailText.text = "Logged in as: " + PlayerPrefs.GetString("UserId", userId);
            StartCoroutine(FetchSessionList());
        }
        else
        {
            Debug.LogError("No User ID found in PlayerPrefs. Please login again.");
        }

        string todayDateTime = DateTime.Now.ToString("MMMM dd, yyyy, hh:mm tt"); // display current date + time

        if (dateText != null)
        {
            dateText.text =  todayDateTime;
            dateDetailText.text = todayDateTime;
        }
        else
        {
            Debug.LogError("No TMP_Text assigned to DisplayDate script!");
        }
    }

    public IEnumerator FetchSessionList()
    {
        Debug.Log("FetchSessionList() Started");
        if (string.IsNullOrEmpty(authToken) || string.IsNullOrEmpty(userRole))
        {
            Debug.LogError("User not authenticated or role not set.");
            yield break;
        }

        // Use the correct API path based on user role
        string fullUrl = userRole == "Therapist" ? $"{URL}therapists/my-sessions" : $"{URL}patients/my-sessions";
        Debug.Log("Fetching sessions from: " + fullUrl);

        using (UnityWebRequest request = UnityWebRequest.Get(fullUrl))
        {
            request.SetRequestHeader("Authorization", "Bearer " + authToken); //input JWT token from login into Authorization header
            yield return request.SendWebRequest();

            if (request.result == UnityWebRequest.Result.ConnectionError || request.result == UnityWebRequest.Result.ProtocolError)
            {
                Debug.LogError("Error fetching sessions: " + request.error);
            }
            else
            {
                string jsonResponse = request.downloadHandler.text;
                Debug.Log("API Response: " + jsonResponse);

                if (string.IsNullOrEmpty(jsonResponse) || jsonResponse == "[]")
                {
                    Debug.LogWarning("No sessions found for this user.");
                    yield break;
                }

                try
                {
                    // Ensure JSON is wrapped in an object if needed
                    if (!jsonResponse.TrimStart().StartsWith("{"))
                    {
                        jsonResponse = "{ \"sessions\": " + jsonResponse + " }";
                    }

                    Debug.Log("Formatted JSON: " + jsonResponse);

                    SessionList sessionList = JsonUtility.FromJson<SessionList>(jsonResponse);
                    if (sessionList == null || sessionList.sessions == null || sessionList.sessions.Count == 0)
                    {
                        Debug.LogWarning("Deserialization failed or no sessions available.");
                        yield break;
                    }

                    PopulateSessionList(sessionList.sessions);
                }
                catch (System.Exception ex)
                {
                    Debug.LogError("JSON Parsing Error: " + ex.Message);
                }
            }
        }
    }


    void PopulateSessionList(List<SessionProfile> sessions)
    {
        // Clear existing session rows
        foreach (Transform child in detailContainerPanel)
        {
            Destroy(child.gameObject);
        }

        foreach (SessionProfile session in sessions)
        {
            GameObject sessionRow = Instantiate(sessionRowButtonPrefab, detailContainerPanel);

            // get all TMP_Text components inside the session row
            TMP_Text[] textComponents = sessionRow.GetComponentsInChildren<TMP_Text>();

            if (textComponents.Length >= 3) // ensure there are enough text fields
            {
                // format the sessionDate display from raw to format
                string formattedDate = FormatSessionDate(session.sessionDate);

                textComponents[0].text = "Session ID: " + session.sessionId;  
                textComponents[1].text = "Date: " + formattedDate;   
                textComponents[2].text = session.sessionDuration + " min";   
            }
            else
            {
                Debug.LogError("SessionRowButton prefab is missing TMP_Text components!");
            }

            DateTime sessionDate;
            if (DateTime.TryParse(session.sessionDate, out sessionDate))  // try to parse sessionDate string to DateTime
            {
                DateTime todayDate = DateTime.Now.Date; // get date

                // Check if the session date is before today's date
                if (sessionDate.Date < todayDate) // if the session date is in the past
                {
                    // Grey out the button by changing its color (but you can still click on it)
                    Button sessionButton = sessionRow.GetComponent<Button>();
                    if (sessionButton != null)
                    {
                        // change the button's color to gray
                        ColorBlock colors = sessionButton.colors;
                        colors.normalColor = Color.gray; 
                        sessionButton.colors = colors;
                    }
                }
            }
            else
            {
                Debug.LogError("Invalid session date format: " + session.sessionDate);
            }

            // add event listener to display the selected session details when clicked
            sessionRow.GetComponent<Button>().onClick.AddListener(() => ShowSessionDetails(session));

            // Ensure the row has a proper height
            LayoutElement layout = sessionRow.GetComponent<LayoutElement>();
            if (layout == null)
            {
                layout = sessionRow.AddComponent<LayoutElement>();
            }
            layout.preferredHeight = 50;  // Set a fixed height for each row
        }
    }


    void ShowSessionDetails(SessionProfile session)
    {
        sessionListPanel.SetActive(false);
        sessionDetailPanel.SetActive(true);

        userNameListText.text = "Logged in as: \n" + PlayerPrefs.GetString("UserId", userId);
        sessionIdText.text = "Session ID: " + session.sessionId;

        // Convert sessionDate to DateTime format
        DateTime sessionDate = DateTime.Parse(session.sessionDate);  // parse
        string formattedDate = sessionDate.ToString("MMMM dd, yyyy hh:mm tt");  // format as "Month day, year hour:minute AM/PM"
        sessionDateText.text = "Date: " + formattedDate;

        sessionDurationText.text = "(" + session.sessionDuration + " min)";
        therapistNameText.text = "Therapist: " + (session.therapistName ?? "N/A");
        therapistLicenseText.text = "License: " + (session.therapistLicense ?? "N/A");
        patientNameText.text = "Patient: " + (session.patientName ?? "N/A");
        patientGoalText.text = "Goal: " + (session.patientGoal ?? "N/A");
    }

    private string FormatSessionDate(string rawDate)
    {
        DateTime dateTime;
        // parse raw date to DateTime object
        if (DateTime.TryParse(rawDate, out dateTime))
        {
            // formatted ex: March 18, 2025, 12:45 PM
            return dateTime.ToString("MMMM dd, yyyy, hh:mm tt");
        }
        else
        {
            Debug.LogError("Invalid session date format: " + rawDate);
            return "Invalid Date"; 
        }
    }
}
