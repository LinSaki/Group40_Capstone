using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEngine;
using UnityEngine.SceneManagement;
using UnityEngine.Networking;
using UnityEngine.UI;
using Unity.VisualScripting;
using System.Text;
using System;

public class LoginScript : MonoBehaviour
{
    public GameObject sessionPanel;
    public GameObject loginPanel;
    public TMP_InputField emailInput;
    public TMP_InputField passwordInput;
    public AudioClip clickSound;
    public TMP_Text errorMessage;

    private string loginUrl = "http://localhost:8080/api/auth/login";

    public void GoEnterSession()
    {
        //PlayerPrefs.SetString("UserName", ); //set Full Name according to user details
        
    }

    public class LoginResponse
    {
        public string token; // JWT Token
        public string fullName; // Full name of user
        public string userEmail; // Email of user
        public string role; // role : Therapist/ Patient
        public int userId; // unique user ID
    }

    public void GoLogin()
    {
        string email = emailInput.text;
        string password = passwordInput.text;
        if (string.IsNullOrEmpty(email) || string.IsNullOrEmpty(password))
        {
            errorMessage.text = "Email and Password cannot be empty.";
            return;
        }
        LoginUser(email, password);
    }

    public void LoginUser(string email, string password)
    {
        StartCoroutine(LoginUserHandler(new User { email = email, password = password }));
    }

    IEnumerator LoginUserHandler(User user)
    {
        string json = JsonUtility.ToJson(user);

        using (UnityWebRequest request = new UnityWebRequest(loginUrl, "POST"))
        {
            byte[] bodyRaw = new System.Text.UTF8Encoding().GetBytes(json); //stores array of bytes of raw info from body
            request.uploadHandler = new UploadHandlerRaw(bodyRaw);
            request.downloadHandler = new DownloadHandlerBuffer();
            request.SetRequestHeader("Content-Type", "application/json");

            yield return request.SendWebRequest();

            if(request.result == UnityWebRequest.Result.ConnectionError || request.result == UnityWebRequest.Result.ProtocolError) { //error handling
                Debug.Log(request.error);
                errorMessage.text = "Incorrect email or password. Please try again.";
            }
            else //login successful
            {
                string responseText = request.downloadHandler.text;
                Debug.Log("User login successful: " + responseText);
                LoginResponse response = JsonUtility.FromJson<LoginResponse>(responseText);

                if (!string.IsNullOrEmpty(response.token))
                {
                    // Store JWT Token & User Info
                    PlayerPrefs.SetString("AuthToken", response.token);
                    PlayerPrefs.Save();

                    Debug.Log("AuthToken Saved: " + response.token);

                    errorMessage.text = "";

                    DecodeJWT(response.token); //extract user data from JWT token

                    // Switch to Session Panel
                    loginPanel.SetActive(false);
                    sessionPanel.SetActive(true);
                    GameObject.FindGameObjectWithTag("MainCamera").GetComponent<AudioSource>().PlayOneShot(clickSound);
                    GameObject.FindObjectOfType<GetApiData>().StartCoroutine("FetchSessionList");

                }
                else
                {
                    errorMessage.text = "Invalid credentials. Please try again.";
                }
            }
        }
    }

    void DecodeJWT(string token) // Converts  Base64 to a readable JSON string
    {
        try
        {
            string[] parts = token.Split('.'); //split JWT 
            if (parts.Length != 3)
            {
                Debug.LogError("Invalid JWT Token");
                return;
            }

            string payload = parts[1];  // Extract payload (Base64 encoded)
            string decodedPayload = Encoding.UTF8.GetString(Convert.FromBase64String(PadBase64(payload)));

            Debug.Log("Decoded JWT Payload: " + decodedPayload); //displayed role, email

            JWTData jwtData = JsonUtility.FromJson<JWTData>(decodedPayload); // converts JSON into c#

            // Save extracted details
            PlayerPrefs.SetString("UserRole", jwtData.role);
            PlayerPrefs.SetString("UserId", jwtData.sub); // email
            PlayerPrefs.Save();

            Debug.Log("UserRole Saved: " + jwtData.role);
            Debug.Log("UserId Saved: " + jwtData.sub);
        }
        catch (Exception e)
        {
            Debug.LogError("Error decoding JWT: " + e.Message);
        }
    }

    // Ensures proper Base64 padding
    private string PadBase64(string base64)
    {
        int padding = 4 - (base64.Length % 4);
        if (padding != 4)
        {
            base64 += new string('=', padding);
        }
        return base64.Replace('-', '+').Replace('_', '/');
    }

    [System.Serializable]
    public class JWTData
    {
        public string sub;  // sub is usually the username or email
        public string role;
        public long exp;
    }
}
