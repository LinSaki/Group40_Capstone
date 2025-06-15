using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class MenuScript : MonoBehaviour
{
    public GameObject menuCanvas;
    public GameObject loginCanvas;
    public GameObject settingPanel;
    public GameObject aboutPanel;
    public AudioClip clickSound;
    public void GoQuit()
    {
        Debug.Log("Quit App!");
        Application.Quit();
    }
    public void ToggleAbout()
    {
        if (aboutPanel != null)
        {
            bool isSettingActive = settingPanel.activeSelf;
            if (isSettingActive == false)
            {
                bool isAboutActive = aboutPanel.activeSelf;
                aboutPanel.SetActive(!isAboutActive);
                GameObject.FindGameObjectWithTag("MainCamera").GetComponent<AudioSource>().PlayOneShot(clickSound);
            }
            else //switch panel to About if Setting is active
            {
                settingPanel.gameObject.SetActive(false);
                aboutPanel.gameObject.SetActive(true);
                GameObject.FindGameObjectWithTag("MainCamera").GetComponent<AudioSource>().PlayOneShot(clickSound);
            }

        }
    }

    public void ToggleSetting()
    {
        if (settingPanel != null)
        {
            bool isAboutActive = aboutPanel.activeSelf;
            if (isAboutActive == false)
            {
                bool isActive = settingPanel.activeSelf;
                settingPanel.SetActive(!isActive);
                GameObject.FindGameObjectWithTag("MainCamera").GetComponent<AudioSource>().PlayOneShot(clickSound);
            }
            else //switch panel to Setting if About is active
            {
                aboutPanel.gameObject.SetActive(false);
                settingPanel.gameObject.SetActive(true);
                GameObject.FindGameObjectWithTag("MainCamera").GetComponent<AudioSource>().PlayOneShot(clickSound);
            }
        }
    }
    public void GoLogin()
    {
        menuCanvas.gameObject.SetActive(false);
        loginCanvas.gameObject.SetActive(true);
        GameObject.FindGameObjectWithTag("MainCamera").GetComponent<AudioSource>().PlayOneShot(clickSound);
    }
}
