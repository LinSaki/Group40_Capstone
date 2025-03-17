using UnityEngine;
using Photon.Pun;
using TMPro;

public class PlayerSpawner : MonoBehaviour
{
    public GameObject playerPrefab; // Assign XR Rig prefab in Inspector
    public TMP_Text roomNameText; // Assign TMP Text field in Inspector

    private void Start()
    {
        if (PhotonNetwork.IsConnected && PhotonNetwork.InRoom)
        {
            DisplayRoomName();
            SpawnPlayer();
        }
    }

    void SpawnPlayer()
    {
        Vector3 spawnPosition = new Vector3(Random.Range(-2, 2), 0, Random.Range(-2, 2));
        PhotonNetwork.Instantiate(playerPrefab.name, spawnPosition, Quaternion.identity);
    }

    void DisplayRoomName()
    {
        if (roomNameText != null)
        {
            roomNameText.text = PhotonNetwork.CurrentRoom.Name;
        }
    }
}
