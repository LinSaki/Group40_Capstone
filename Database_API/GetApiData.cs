using System.Collections;
using UnityEngine;
using UnityEngine.Networking;
using UnityEngine.UI;
using TMPro;
using UnityEngine.SceneManagement;

public class GetApiData : MonoBehaviour
{
    public string URL;
    public InputField id;
    public GameObject sessionPanel;
    public TMP_Text userNameText;

    public void GetData()
    {
        StartCoroutine(FetchData());
    }

    public void GoPlayGame()
    {
        SceneManager.LoadScene("Create-with-VR-Starter-Scene");
    }

    void Start()
    {
        if (PlayerPrefs.HasKey("UserName"))
        {
            string savedUserName = PlayerPrefs.GetString("UserName");
            if (userNameText != null)
            {
                userNameText.text = "Logged in as: " + savedUserName;
            }
            Debug.Log("Loaded Username from PlayerPrefs: " + savedUserName);
        }
        else
        {
            Debug.LogWarning("No username found in PlayerPrefs!");
        }
    }

    void Update()
    {
    }

    public IEnumerator FetchData()
    {
        string fullUrl = URL + id.text;
        using (UnityWebRequest request = UnityWebRequest.Get(fullUrl))
        {
            yield return request.SendWebRequest();

            if (request.result == UnityWebRequest.Result.ConnectionError || request.result == UnityWebRequest.Result.ProtocolError)
            {
                Debug.LogError("Error: " + request.error);
            }
            else
            {
                string json = request.downloadHandler.text;
                Debug.Log("API Response: " + json);

                // Deserialize JSON into SessionProfile object
                SessionProfile session = JsonUtility.FromJson<SessionProfile>(json);
                if (session == null)
                {
                    Debug.LogError("Deserialization failed: session object is null");
                    yield break; // Exit the coroutine
                }

                //  Null check for sessionPanel before accessing children
                if (sessionPanel == null)
                {
                    Debug.LogError("sessionPanel is not assigned in the Inspector!");
                    yield break;
                }

                // Save the username automatically if it exists in the API response
                if (session.patientName != null && !string.IsNullOrEmpty(session.patientName))
                {
                    PlayerPrefs.SetString("UserName", session.patientName);
                    PlayerPrefs.SetString("TherapistName", session.therapistName);
                    PlayerPrefs.Save();
                    Debug.Log("Username saved: " + session.patientName);

                    // Update UI with username
                    
                   userNameText.text = "Logged in as: " + session.patientName; //CHANGE THIS WHEN SECURITY IMPLEMENTED
                    
                }

                // Null check for sessionPanel before accessing children
                if (sessionPanel == null)
                {
                    Debug.LogError("sessionPanel is not assigned in the Inspector!");
                    yield break;
                }

                try
                {
                    // Ensure sessionPanel has enough children before accessing
                    if (sessionPanel.transform.childCount >= 7)
                    {
                        
                            sessionPanel.transform.GetChild(0).GetComponent<TMP_Text>().text = "Session ID #"+session.sessionId.ToString();
                            sessionPanel.transform.GetChild(1).GetComponent<TMP_Text>().text = "Date: " + session.sessionDate.ToString();
                            sessionPanel.transform.GetChild(2).GetComponent<TMP_Text>().text = "(" + session.sessionDuration.ToString() + " min)";

                            // Update therapist info
                            sessionPanel.transform.GetChild(3).GetComponent<TMP_Text>().text = ("Therapist:  " + session.therapistName) ?? "Therapist info not available";

                            // Update therapist license #
                            sessionPanel.transform.GetChild(4).GetComponent<TMP_Text>().text = ("License#  " + session.therapistLicense) ?? "# not available";

                            // Update patient info
                            sessionPanel.transform.GetChild(5).GetComponent<TMP_Text>().text = ("Patient:  " + session.patientName) ?? "Patient info not available";

                            // Update therapy goal if available
                            sessionPanel.transform.GetChild(6).GetComponent<TMP_Text>().text = ("Therapy Goal: \n" + session.patientGoal) ?? "No therapy goal available";
                    }
                    else
                    {
                        Debug.LogError("sessionPanel does not have enough child objects!");
                    }
                }
                catch (System.Exception ex)
                {
                    Debug.LogError("Error updating UI: " + ex.Message);
                }
            }
        }
    }
}
