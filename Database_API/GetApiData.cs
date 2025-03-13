using System.Collections;
using UnityEngine;
using UnityEngine.Networking;
using UnityEngine.UI;
using TMPro;

public class GetApiData : MonoBehaviour
{
    public string URL;
    public InputField id;
    public GameObject therapistPanel;

    public void GetData()
    {
        StartCoroutine(FetchData());
    }

    public IEnumerator FetchData()
    {
        string fullUrl = URL +"/"+ id.text;
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

                // Deserialize JSON into TherapistProfile object
                TherapistProfile therapist = JsonUtility.FromJson<TherapistProfile>(json);
                if (therapist == null)
                {
                    Debug.LogError("Deserialization failed: Therapist object is null");
                    yield break; // Exit the coroutine
                }

                //  Null check for therapistPanel before accessing children
                if (therapistPanel == null)
                {
                    Debug.LogError("therapistPanel is not assigned in the Inspector!");
                    yield break;
                }

                try
                {
                    // Make sure therapistPanel has enough children before accessing
                    if (therapistPanel.transform.childCount >= 3)
                    {
                        therapistPanel.transform.GetChild(0).GetComponent<TMP_Text>().text = therapist.name;
                        therapistPanel.transform.GetChild(1).GetComponent<TMP_Text>().text = "License Num: " + therapist.licenseNum;
                        therapistPanel.transform.GetChild(2).GetComponent<TMP_Text>().text = "Patient Count: " + therapist.patientCount.ToString();
                    }
                    else
                    {
                        Debug.LogError("therapistPanel does not have enough child objects!");
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
